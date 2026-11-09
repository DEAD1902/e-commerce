<?php
namespace Tests\Controller;

use PHPUnit\Framework\TestCase;
use App\Controller\PayPalController;
use App\Service\PayPalGateway;
use GuzzleHttp\Client;
use GuzzleHttp\Handler\MockHandler;
use GuzzleHttp\HandlerStack;
use GuzzleHttp\Middleware;
use GuzzleHttp\Psr7\Response as GuzzleResponse;
use GuzzleHttp\Psr7\ServerRequest;

/**
 * Unit and integration tests for PayPalController with mocked Guzzle responses.
 */
class PayPalControllerTest extends TestCase
{
    private array $historyContainer;

    protected function setUp(): void
    {
        $this->historyContainer = [];
        putenv('PAYPAL_CLIENT_ID=unit_test_client_id');
        putenv('PAYPAL_CLIENT_SECRET=unit_test_client_secret');
        putenv('PAYPAL_WEBHOOK_ID=unit_test_webhook_id');
    }

    /**
     * Helper to create a PayPalController with mocked Guzzle responses and history tracking.
     */
    private function createControllerWithMockResponses(array $responses): PayPalController
    {
        $mock = new MockHandler($responses);
        $handlerStack = HandlerStack::create($mock);
        
        $history = Middleware::history($this->historyContainer);
        $handlerStack->push($history);

        $mockClient = new Client(['handler' => $handlerStack]);
        $gateway = new PayPalGateway($mockClient);

        return new PayPalController($gateway);
    }

    /**
     * Test successful PayPal order creation flow.
     */
    public function testCreateOrderReturnsSuccessfulJsonResponse(): void
    {
        $oauthResponse = new GuzzleResponse(200, [], json_encode([
            'access_token' => 'MOCK_ACCESS_TOKEN_123',
            'token_type'   => 'Bearer',
            'expires_in'   => 3600,
        ]));

        $orderResponse = new GuzzleResponse(201, [], json_encode([
            'id'     => 'ORDER-777888',
            'status' => 'CREATED',
            'links'  => [
                [
                    'href'   => 'https://www.sandbox.paypal.com/checkoutnow?token=ORDER-777888',
                    'rel'    => 'approve',
                    'method' => 'GET',
                ],
            ],
        ]));

        $controller = $this->createControllerWithMockResponses([$oauthResponse, $orderResponse]);

        $requestPayload = [
            'amount'    => 129.99,
            'currency'  => 'USD',
            'returnUrl' => 'https://example.com/checkout/success',
            'cancelUrl' => 'https://example.com/checkout/cancel',
        ];

        $request = new ServerRequest(
            'POST',
            '/api/payments/paypal/create',
            ['Content-Type' => 'application/json'],
            json_encode($requestPayload)
        );
        $response = new GuzzleResponse();

        $resultResponse = $controller->create($request, $response, []);

        // Assert HTTP response details
        $this->assertSame(200, $resultResponse->getStatusCode());
        $this->assertSame('application/json', $resultResponse->getHeaderLine('Content-Type'));

        $body = json_decode((string) $resultResponse->getBody(), true);
        $this->assertNotNull($body);
        $this->assertSame('ORDER-777888', $body['id']);
        $this->assertSame('CREATED', $body['status']);
        $this->assertArrayHasKey('links', $body);

        // Verify Guzzle HTTP calls
        $this->assertCount(2, $this->historyContainer);

        // 1st request: OAuth Token
        $tokenReq = $this->historyContainer[0]['request'];
        $this->assertSame('POST', $tokenReq->getMethod());
        $this->assertStringContainsString('oauth2/token', (string) $tokenReq->getUri());
        $this->assertStringContainsString('Basic', $tokenReq->getHeaderLine('Authorization'));

        // 2nd request: Order Creation
        $orderReq = $this->historyContainer[1]['request'];
        $this->assertSame('POST', $orderReq->getMethod());
        $this->assertStringContainsString('checkout/orders', (string) $orderReq->getUri());
        $this->assertSame('Bearer MOCK_ACCESS_TOKEN_123', $orderReq->getHeaderLine('Authorization'));

        $sentPayload = json_decode((string) $orderReq->getBody(), true);
        $this->assertSame('CAPTURE', $sentPayload['intent']);
        $this->assertSame('129.99', $sentPayload['purchase_units'][0]['amount']['value']);
        $this->assertSame('USD', $sentPayload['purchase_units'][0]['amount']['currency_code']);
        $this->assertSame('https://example.com/checkout/success', $sentPayload['application_context']['return_url']);
    }

    /**
     * Test order creation with missing body fields defaults correctly.
     */
    public function testCreateOrderWithDefaultValuesWhenParamsOmitted(): void
    {
        $oauthResponse = new GuzzleResponse(200, [], json_encode([
            'access_token' => 'MOCK_TOKEN_DEFAULT',
            'expires_in'   => 3600,
        ]));

        $orderResponse = new GuzzleResponse(201, [], json_encode([
            'id'     => 'ORDER-DEFAULT-001',
            'status' => 'CREATED',
        ]));

        $controller = $this->createControllerWithMockResponses([$oauthResponse, $orderResponse]);

        // Empty JSON body
        $request = new ServerRequest(
            'POST',
            '/api/payments/paypal/create',
            ['Content-Type' => 'application/json'],
            '{}'
        );
        $response = new GuzzleResponse();

        $resultResponse = $controller->create($request, $response, []);

        $this->assertSame(200, $resultResponse->getStatusCode());
        $body = json_decode((string) $resultResponse->getBody(), true);
        $this->assertSame('ORDER-DEFAULT-001', $body['id']);

        // Inspect that amount defaulted to 0.00 and currency to USD
        $orderReq = $this->historyContainer[1]['request'];
        $sentPayload = json_decode((string) $orderReq->getBody(), true);
        $this->assertSame('0.00', $sentPayload['purchase_units'][0]['amount']['value']);
        $this->assertSame('USD', $sentPayload['purchase_units'][0]['amount']['currency_code']);
        $this->assertSame('', $sentPayload['application_context']['return_url']);
        $this->assertSame('', $sentPayload['application_context']['cancel_url']);
    }

    /**
     * Test capture endpoint executes order successfully when orderId is provided.
     */
    public function testCaptureOrderReturnsSuccessfulJsonResponse(): void
    {
        $oauthResponse = new GuzzleResponse(200, [], json_encode([
            'access_token' => 'MOCK_CAPTURE_TOKEN',
            'expires_in'   => 3600,
        ]));

        $captureResponse = new GuzzleResponse(200, [], json_encode([
            'id'             => 'ORDER-777888',
            'status'         => 'COMPLETED',
            'purchase_units' => [
                [
                    'payments' => [
                        'captures' => [
                            [
                                'id'     => 'CAPTURE-999',
                                'status' => 'COMPLETED',
                                'amount' => ['value' => '129.99', 'currency_code' => 'USD'],
                            ],
                        ],
                    ],
                ],
            ],
        ]));

        $controller = $this->createControllerWithMockResponses([$oauthResponse, $captureResponse]);

        $request = new ServerRequest(
            'POST',
            '/api/payments/paypal/execute',
            ['Content-Type' => 'application/json'],
            json_encode(['orderId' => 'ORDER-777888'])
        );
        $response = new GuzzleResponse();

        $resultResponse = $controller->capture($request, $response, []);

        $this->assertSame(200, $resultResponse->getStatusCode());
        $this->assertSame('application/json', $resultResponse->getHeaderLine('Content-Type'));

        $body = json_decode((string) $resultResponse->getBody(), true);
        $this->assertNotNull($body);
        $this->assertSame('ORDER-777888', $body['id']);
        $this->assertSame('COMPLETED', $body['status']);

        // Verify capture URL contains the order ID
        $captureReq = $this->historyContainer[1]['request'];
        $this->assertSame('POST', $captureReq->getMethod());
        $this->assertStringContainsString('checkout/orders/ORDER-777888/capture', (string) $captureReq->getUri());
        $this->assertSame('Bearer MOCK_CAPTURE_TOKEN', $captureReq->getHeaderLine('Authorization'));
    }

    /**
     * Test capture endpoint returns 400 when orderId is missing from request body.
     */
    public function testCaptureOrderReturns400WhenOrderIdMissing(): void
    {
        $controller = $this->createControllerWithMockResponses([]);

        // Request with missing orderId
        $request = new ServerRequest(
            'POST',
            '/api/payments/paypal/execute',
            ['Content-Type' => 'application/json'],
            json_encode(['unrelated_key' => 'some_val'])
        );
        $response = new GuzzleResponse();

        $resultResponse = $controller->capture($request, $response, []);

        $this->assertSame(400, $resultResponse->getStatusCode());
        $this->assertSame('application/json', $resultResponse->getHeaderLine('Content-Type'));

        $body = json_decode((string) $resultResponse->getBody(), true);
        $this->assertSame(['error' => 'orderId missing'], $body);

        // Verify zero outgoing HTTP calls were made
        $this->assertCount(0, $this->historyContainer);
    }

    /**
     * Test capture endpoint returns 400 when orderId is empty string.
     */
    public function testCaptureOrderReturns400WhenOrderIdIsEmptyString(): void
    {
        $controller = $this->createControllerWithMockResponses([]);

        $request = new ServerRequest(
            'POST',
            '/api/payments/paypal/execute',
            ['Content-Type' => 'application/json'],
            json_encode(['orderId' => ''])
        );
        $response = new GuzzleResponse();

        $resultResponse = $controller->capture($request, $response, []);

        $this->assertSame(400, $resultResponse->getStatusCode());
        $body = json_decode((string) $resultResponse->getBody(), true);
        $this->assertSame('orderId missing', $body['error']);
        $this->assertCount(0, $this->historyContainer);
    }

    /**
     * Test default constructor instantiates dependencies without parameters.
     */
    public function testDefaultConstructorInstantiatesDependencies(): void
    {
        $controller = new PayPalController();
        $this->assertInstanceOf(PayPalController::class, $controller);
        $this->assertInstanceOf(PayPalGateway::class, $controller->getGateway());
    }

    /**
     * Test OAuth token caching avoids duplicate authorization requests.
     */
    public function testOAuthTokenIsCachedAndReusedBetweenActions(): void
    {
        $oauthResponse = new GuzzleResponse(200, [], json_encode([
            'access_token' => 'CACHED_TOKEN_XYZ',
            'expires_in'   => 7200,
        ]));

        $orderResponse = new GuzzleResponse(201, [], json_encode([
            'id'     => 'ORDER-CACHE-1',
            'status' => 'CREATED',
        ]));

        $captureResponse = new GuzzleResponse(200, [], json_encode([
            'id'     => 'ORDER-CACHE-1',
            'status' => 'COMPLETED',
        ]));

        // Exactly 3 responses queued: 1 token, 1 order, 1 capture
        $controller = $this->createControllerWithMockResponses([
            $oauthResponse,
            $orderResponse,
            $captureResponse,
        ]);

        // Action 1: Create
        $req1 = new ServerRequest('POST', '/api/payments/paypal/create', [], json_encode(['amount' => 50.0]));
        $res1 = $controller->create($req1, new GuzzleResponse(), []);
        $this->assertSame(200, $res1->getStatusCode());

        // Action 2: Capture
        $req2 = new ServerRequest('POST', '/api/payments/paypal/execute', [], json_encode(['orderId' => 'ORDER-CACHE-1']));
        $res2 = $controller->capture($req2, new GuzzleResponse(), []);
        $this->assertSame(200, $res2->getStatusCode());

        // Total HTTP calls should be 3: 1 OAuth + 1 Order + 1 Capture (token was NOT fetched a second time)
        $this->assertCount(3, $this->historyContainer);
        $this->assertStringContainsString('oauth2/token', (string) $this->historyContainer[0]['request']->getUri());
        $this->assertStringContainsString('checkout/orders', (string) $this->historyContainer[1]['request']->getUri());
        $this->assertStringContainsString('checkout/orders/ORDER-CACHE-1/capture', (string) $this->historyContainer[2]['request']->getUri());
    }
}

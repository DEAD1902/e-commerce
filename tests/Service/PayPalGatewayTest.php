<?php
namespace Tests\Service;

use PHPUnit\Framework\TestCase;
use App\Service\PayPalGateway;
use GuzzleHttp\Client;
use GuzzleHttp\Handler\MockHandler;
use GuzzleHttp\HandlerStack;
use GuzzleHttp\Middleware;
use GuzzleHttp\Psr7\Response as GuzzleResponse;

/**
 * Unit tests for PayPalGateway service with mocked Guzzle HTTP client.
 */
class PayPalGatewayTest extends TestCase
{
    private array $historyContainer;

    protected function setUp(): void
    {
        $this->historyContainer = [];
        putenv('PAYPAL_CLIENT_ID=gateway_client_id_test');
        putenv('PAYPAL_CLIENT_SECRET=gateway_client_secret_test');
    }

    private function createGateway(array $responses): PayPalGateway
    {
        $mock = new MockHandler($responses);
        $stack = HandlerStack::create($mock);
        $stack->push(Middleware::history($this->historyContainer));
        $client = new Client(['handler' => $stack]);
        return new PayPalGateway($client);
    }

    public function testCreateOrderSendsCorrectPayload(): void
    {
        $oauthResp = new GuzzleResponse(200, [], json_encode(['access_token' => 'GW_TOKEN_1', 'expires_in' => 3600]));
        $orderResp = new GuzzleResponse(201, [], json_encode(['id' => 'GW-ORDER-99', 'status' => 'CREATED']));

        $gateway = $this->createGateway([$oauthResp, $orderResp]);
        $order = $gateway->createOrder(75.50, 'EUR', 'https://shop.com/ret', 'https://shop.com/can');

        $this->assertSame('GW-ORDER-99', $order['id']);
        $this->assertSame('CREATED', $order['status']);

        $this->assertCount(2, $this->historyContainer);
        $orderRequest = $this->historyContainer[1]['request'];
        $body = json_decode((string) $orderRequest->getBody(), true);

        $this->assertSame('CAPTURE', $body['intent']);
        $this->assertSame('75.50', $body['purchase_units'][0]['amount']['value']);
        $this->assertSame('EUR', $body['purchase_units'][0]['amount']['currency_code']);
        $this->assertSame('https://shop.com/ret', $body['application_context']['return_url']);
        $this->assertSame('https://shop.com/can', $body['application_context']['cancel_url']);
    }

    public function testCaptureOrderSendsPostToCaptureUrl(): void
    {
        $oauthResp = new GuzzleResponse(200, [], json_encode(['access_token' => 'GW_TOKEN_2', 'expires_in' => 3600]));
        $captureResp = new GuzzleResponse(200, [], json_encode(['id' => 'GW-ORDER-99', 'status' => 'COMPLETED']));

        $gateway = $this->createGateway([$oauthResp, $captureResp]);
        $result = $gateway->captureOrder('GW-ORDER-99');

        $this->assertSame('GW-ORDER-99', $result['id']);
        $this->assertSame('COMPLETED', $result['status']);

        $captureRequest = $this->historyContainer[1]['request'];
        $this->assertStringContainsString('checkout/orders/GW-ORDER-99/capture', (string) $captureRequest->getUri());
    }

    public function testVerifyWebhookReturnsTrueOnSuccess(): void
    {
        $oauthResp = new GuzzleResponse(200, [], json_encode(['access_token' => 'GW_TOKEN_3', 'expires_in' => 3600]));
        $verifyResp = new GuzzleResponse(200, [], json_encode(['verification_status' => 'SUCCESS']));

        $gateway = $this->createGateway([$oauthResp, $verifyResp]);

        $headers = [
            'paypal-auth-algo'         => 'SHA256withRSA',
            'paypal-cert-url'          => 'https://api.paypal.com/v1/certs/cert.pem',
            'paypal-transmission-id'   => 'TRANS-111',
            'paypal-transmission-sig'  => 'SIG-222',
            'paypal-transmission-time' => '2026-11-04T12:00:00Z',
        ];
        $body = json_encode(['event_type' => 'CHECKOUT.ORDER.APPROVED']);

        $isValid = $gateway->verifyWebhook($headers, $body, 'WH-TEST-001');
        $this->assertTrue($isValid);

        $verifyRequest = $this->historyContainer[1]['request'];
        $verifyPayload = json_decode((string) $verifyRequest->getBody(), true);
        $this->assertSame('WH-TEST-001', $verifyPayload['webhook_id']);
        $this->assertSame('TRANS-111', $verifyPayload['transmission_id']);
        $this->assertSame('CHECKOUT.ORDER.APPROVED', $verifyPayload['webhook_event']['event_type']);
    }

    public function testVerifyWebhookReturnsFalseOnFailure(): void
    {
        $oauthResp = new GuzzleResponse(200, [], json_encode(['access_token' => 'GW_TOKEN_4', 'expires_in' => 3600]));
        $verifyResp = new GuzzleResponse(200, [], json_encode(['verification_status' => 'FAILURE']));

        $gateway = $this->createGateway([$oauthResp, $verifyResp]);
        $isValid = $gateway->verifyWebhook([], '{}', 'WH-TEST-001');
        $this->assertFalse($isValid);
    }
}

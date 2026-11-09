<?php
namespace App\Controller;

use App\Service\PayPalGateway;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Slim\Views\PhpRenderer;

/**
 * Slim controller handling PayPal payment flow.
 */
class PayPalController
{
    private PayPalGateway $gateway;
    private string $webhookId;

    public function __construct(?PayPalGateway $gateway = null)
    {
        $this->gateway = $gateway ?? new PayPalGateway();
        $this->webhookId = (string) (getenv('PAYPAL_WEBHOOK_ID') ?: ''); // optional, used by webhook verification
    }

    public function getGateway(): PayPalGateway
    {
        return $this->gateway;
    }

    /**
     * POST /api/payments/paypal/create
     * Expects JSON body with amount, currency, returnUrl, cancelUrl.
     */
    public function create(Request $request, Response $response, array $args): Response
    {
        $data = json_decode((string) $request->getBody(), true);
        $amount = $data['amount'] ?? 0;
        $currency = $data['currency'] ?? 'USD';
        $returnUrl = $data['returnUrl'] ?? '';
        $cancelUrl = $data['cancelUrl'] ?? '';

        $order = $this->gateway->createOrder((float) $amount, $currency, $returnUrl, $cancelUrl);
        $payload = json_encode($order);
        $response->getBody()->write($payload);
        return $response->withHeader('Content-Type', 'application/json');
    }

    /**
     * POST /api/payments/paypal/execute
     * Expects JSON body with orderId.
     */
    public function capture(Request $request, Response $response, array $args): Response
    {
        $data = json_decode((string) $request->getBody(), true);
        $orderId = $data['orderId'] ?? '';
        if (!$orderId) {
            $error = ['error' => 'orderId missing'];
            $response->getBody()->write(json_encode($error));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }
        $result = $this->gateway->captureOrder($orderId);
        $response->getBody()->write(json_encode($result));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
?>
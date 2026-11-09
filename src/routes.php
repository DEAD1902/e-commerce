<?php
declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Routing\RouteCollectorProxy;
use App\\Services\\PayPalService; // Assume a service wrapper exists

return function (App $app): void {
    // Health check route
    $app->get('/health', function (Request $request, Response $response) {
        $response->getBody()->write('OK');
        return $response->withStatus(200);
    });

    // PayPal routes group
    $app->group('/paypal', function (RouteCollectorProxy $group) {
        // Initiate PayPal checkout/order creation
        $group->post('/order', function (Request $request, Response $response) {
            // In a real implementation, you would inject PayPalService via container
            $payPal = new PayPalService();
            $data = $request->getParsedBody();
            $order = $payPal->createOrder($data);
            $response->getBody()->write(json_encode($order));
            return $response->withHeader('Content-Type', 'application/json');
        });

        // Capture/execute the approved order (PayPal redirects back here)
        $group->post('/capture', function (Request $request, Response $response) {
            $payPal = new PayPalService();
            $data = $request->getParsedBody();
            $result = $payPal->captureOrder($data['orderId'] ?? '');
            $response->getBody()->write(json_encode($result));
            return $response->withHeader('Content-Type', 'application/json');
        });

        // PayPal webhook endpoint
        $group->post('/webhook', function (Request $request, Response $response) {
            $payPal = new PayPalService();
            $payload = $request->getBody()->getContents();
            $verified = $payPal->verifyWebhook($payload, $request->getHeaderLine('Paypal-Transmission-Id'), $request->getHeaderLine('Paypal-Transmission-Sig'), $request->getHeaderLine('Paypal-Transmission-Time'));
            if ($verified) {
                $payPal->handleWebhook(json_decode($payload, true));
                return $response->withStatus(200);
            }
            return $response->withStatus(400);
        });
    });
};

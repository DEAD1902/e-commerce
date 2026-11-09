<?php
require __DIR__.'/../../vendor/autoload.php'; // Adjust path as needed

use App\Service\PayPalGateway;

// Read raw POST body
$body = file_get_contents('php://input');
// Get all request headers (case-insensitive)
$headers = getallheaders();

$gateway = new PayPalGateway();
$webhookId = getenv('PAYPAL_WEBHOOK_ID');

if (!$webhookId) {
    http_response_code(500);
    echo json_encode(['error' => 'PAYPAL_WEBHOOK_ID not configured']);
    exit;
}

$valid = $gateway->verifyWebhook($headers, $body, $webhookId);

if ($valid) {
    // Process the webhook event as needed (e.g., order completed)
    http_response_code(200);
    echo json_encode(['status' => 'verified']);
} else {
    http_response_code(400);
    echo json_encode(['error' => 'invalid signature']);
}
?>
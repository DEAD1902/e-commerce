<?php
namespace App\Service;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;

/**
 * Service class that wraps PayPal REST API calls using Guzzle.
 *
 * It obtains an OAuth2 access token using client‑id / client‑secret and
 * provides helper methods for creating orders and capturing payments.
 */
class PayPalGateway
{
    private const PAYPAL_OAUTH_URL = 'https://api-m.paypal.com/v1/oauth2/token';
    private const PAYPAL_ORDER_URL = 'https://api-m.paypal.com/v2/checkout/orders';
    private const PAYPAL_CAPTURE_URL = 'https://api-m.paypal.com/v2/checkout/orders/%s/capture';
    private const PAYPAL_WEBHOOK_VERIFY_URL = 'https://api-m.paypal.com/v1/notifications/verify-webhook-signature';

    /** @var Client */
    private $http;
    /** @var string */
    private $clientId;
    /** @var string */
    private $clientSecret;
    /** @var string|null */
    private $accessToken = null;
    /** @var int|null */
    private $tokenExpiresAt = null;

    public function __construct(?Client $http = null)
    {
        $this->clientId = (string) (getenv('PAYPAL_CLIENT_ID') ?: '');
        $this->clientSecret = (string) (getenv('PAYPAL_CLIENT_SECRET') ?: '');
        $this->http = $http ?? new Client([
            'timeout' => 30,
        ]);
    }

    /**
     * Get a fresh access token, caching it until it expires.
     */
    private function getAccessToken(): string
    {
        // Return cached token if still valid
        if ($this->accessToken && $this->tokenExpiresAt && $this->tokenExpiresAt > time()) {
            return $this->accessToken;
        }

        $auth = base64_encode("{$this->clientId}:{$this->clientSecret}");
        $response = $this->http->post(self::PAYPAL_OAUTH_URL, [
            'headers' => [
                'Authorization' => "Basic {$auth}",
                'Accept' => 'application/json',
                'Content-Type' => 'application/x-www-form-urlencoded',
            ],
            'form_params' => [
                'grant_type' => 'client_credentials',
            ],
        ]);
        $data = json_decode((string) $response->getBody(), true);
        $this->accessToken = $data['access_token'];
        // expires_in is seconds
        $this->tokenExpiresAt = time() + $data['expires_in'] - 30; // 30s safety buffer
        return $this->accessToken;
    }

    /**
     * Create a PayPal order.
     *
     * @param float $amount Decimal amount (e.g. 19.99)
     * @param string $currency ISO 4217 currency code (e.g. "USD")
     * @param string $returnUrl URL where the buyer is redirected after approval
     * @param string $cancelUrl URL where the buyer is redirected if they cancel
     * @return array The decoded JSON response from PayPal.
     */
    public function createOrder(float $amount, string $currency, string $returnUrl, string $cancelUrl): array
    {
        $payload = [
            'intent' => 'CAPTURE',
            'purchase_units' => [[
                'amount' => [
                    'currency_code' => $currency,
                    'value' => number_format($amount, 2, '.', ''),
                ],
            ]],
            'application_context' => [
                'return_url' => $returnUrl,
                'cancel_url' => $cancelUrl,
            ],
        ];

        $response = $this->http->post(self::PAYPAL_ORDER_URL, [
            'headers' => [
                'Authorization' => 'Bearer ' . $this->getAccessToken(),
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
            ],
            'json' => $payload,
        ]);
        return json_decode((string) $response->getBody(), true);
    }

    /**
     * Capture a PayPal order after the buyer approved it.
     *
     * @param string $orderId PayPal order ID
     * @return array The decoded JSON response from PayPal.
     */
    public function captureOrder(string $orderId): array
    {
        $url = sprintf(self::PAYPAL_CAPTURE_URL, $orderId);
        $response = $this->http->post($url, [
            'headers' => [
                'Authorization' => 'Bearer ' . $this->getAccessToken(),
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
            ],
        ]);
        return json_decode((string) $response->getBody(), true);
    }

    /**
     * Verify a PayPal webhook signature.
     *
     * @param array $headers All HTTP headers from the incoming webhook request
     * @param string $body Raw request payload (JSON string)
     * @param string $webhookId The ID of the webhook you registered in PayPal
     * @return bool True if the signature is valid.
     */
    public function verifyWebhook(array $headers, string $body, string $webhookId): bool
    {
        $payload = [
            'auth_algo' => $headers['paypal-auth-algo'] ?? $headers['PAYPAL-AUTH-ALGO'] ?? '',
            'cert_url' => $headers['paypal-cert-url'] ?? $headers['PAYPAL-CERT-URL'] ?? '',
            'transmission_id' => $headers['paypal-transmission-id'] ?? $headers['PAYPAL-TRANSMISSION-ID'] ?? '',
            'transmission_sig' => $headers['paypal-transmission-sig'] ?? $headers['PAYPAL-TRANSMISSION-SIG'] ?? '',
            'transmission_time' => $headers['paypal-transmission-time'] ?? $headers['PAYPAL-TRANSMISSION-TIME'] ?? '',
            'webhook_id' => $webhookId,
            'webhook_event' => json_decode($body, true),
        ];

        $response = $this->http->post(self::PAYPAL_WEBHOOK_VERIFY_URL, [
            'headers' => [
                'Authorization' => 'Bearer ' . $this->getAccessToken(),
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
            ],
            'json' => $payload,
        ]);
        $result = json_decode((string) $response->getBody(), true);
        return ($result['verification_status'] ?? '') === 'SUCCESS';
    }
}
?>
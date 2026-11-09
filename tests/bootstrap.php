<?php
/**
 * PHPUnit test suite bootstrap file.
 */

// Define test environment variables
putenv('APP_ENV=testing');
putenv('PAYPAL_CLIENT_ID=test_paypal_client_id_123');
putenv('PAYPAL_CLIENT_SECRET=test_paypal_client_secret_456');
putenv('PAYPAL_WEBHOOK_ID=test_webhook_id_789');

$_ENV['APP_ENV'] = 'testing';
$_ENV['PAYPAL_CLIENT_ID'] = 'test_paypal_client_id_123';
$_ENV['PAYPAL_CLIENT_SECRET'] = 'test_paypal_client_secret_456';
$_ENV['PAYPAL_WEBHOOK_ID'] = 'test_webhook_id_789';

// Load vendor autoloader
require_once __DIR__ . '/../vendor/autoload.php';

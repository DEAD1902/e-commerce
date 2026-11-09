<?php
declare(strict_types=1);

// Autoload dependencies
require __DIR__ . '/../vendor/autoload.php';

// Load environment variables (optional, bootstrap does it as well)
if (file_exists(__DIR__ . '/../.env')) {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
    $dotenv->load();
}

// Load DI container
$container = require __DIR__ . '/../src/bootstrap.php';

use Slim\Factory\AppFactory;

// Set the container for Slim
AppFactory::setContainer($container);

// Create Slim app
$app = AppFactory::create();

// Register routes
$registerRoutes = require __DIR__ . '/../src/routes.php';
$registerRoutes($app);

// Run the application
$app->run();

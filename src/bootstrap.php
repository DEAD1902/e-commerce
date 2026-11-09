<?php
require __DIR__ . '/../vendor/autoload.php';

use Dotenv\Dotenv;
use DI\ContainerBuilder;
use Illuminate\Database\Capsule\Manager as Capsule;

// Load environment variables
$dotenv = Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();

// Set up PHP-DI container
$containerBuilder = new ContainerBuilder();
$containerBuilder->addDefinitions([
    // You can define your services here
]);
$container = $containerBuilder->build();

// Set up Eloquent ORM (Illuminate Database)
$capsule = new Capsule();
$capsule->addConnection([
    'driver'    => $_ENV['DB_CONNECTION'] ?? 'mysql',
    'host'      => $_ENV['DB_HOST'] ?? '127.0.0.1',
    'database'  => $_ENV['DB_DATABASE'] ?? 'ecommerce',
    'username'  => $_ENV['DB_USERNAME'] ?? 'root',
    'password'  => $_ENV['DB_PASSWORD'] ?? '',
    'charset'   => 'utf8',
    'collation' => 'utf8_unicode_ci',
    'prefix'    => '',
]);
$capsule->setAsGlobal();
$capsule->bootEloquent();

return $container;
?>
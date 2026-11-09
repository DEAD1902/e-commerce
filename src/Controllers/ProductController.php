<?php
declare(strict_types=1);

namespace App\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use App\Models\Product;

class ProductController
{
    public function list(Request $request, Response $response): Response
    {
        $products = Product::all();
        $payload = $products->toJson();
        $response->getBody()->write($payload);
        return $response->withHeader('Content-Type', 'application/json');
    }
}
?>
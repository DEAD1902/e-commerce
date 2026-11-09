<?php
require_once __DIR__ . '/../../config/env.php';

// web/ajax/google.ajax.php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();
header('Content-Type: application/json');

require_once __DIR__ . '/../extensions/vendor/autoload.php'; 
require_once __DIR__ . '/../controllers/template.controller.php';
require_once __DIR__ . '/../controllers/curl.controller.php';

use Google\Client;

$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

if(!$data || !isset($data['id_token'])){
    echo json_encode(["success"=>false, "error"=>"Token faltante"]);
    exit;
}

$id_token = $data['id_token'];
$redirect = isset($data['redirect']) ? $data['redirect'] : TemplateController::urlRedirect();

// Verificar el id_token con Google
$client = new Client(['client_id' => app_env('GOOGLE_CLIENT_ID')]); // 🔑 pon aquí tu Client ID
$payload = $client->verifyIdToken($id_token);

if(!$payload){
    echo json_encode(["success"=>false, "error"=>"Token inválido"]);
    exit;
}

// Extraer datos del payload
$email   = $payload['email'] ?? null;
$name    = $payload['name'] ?? trim(($payload['given_name'] ?? '').' '.($payload['family_name'] ?? ''));
$picture = $payload['picture'] ?? null;

if(!$email){
    echo json_encode(["success"=>false, "error"=>"Google no devolvió email"]);
    exit;
}

/* === Verificar si usuario existe en API === */
$url    = "users?linkTo=email_user&equalTo=" . $email;
$method = "GET";
$fields = [];

$user = CurlController::request($url, $method, $fields);

if($user->status != 200){
    // Registrar nuevo usuario
    $url    = "users?register=true&suffix=user";
    $method = "POST";
    $fields = array(
        "name_user"        => trim($name),
        "email_user"       => $email,
        "method_user"      => "google",
        "verification_user"=> 1,
        "date_created_user"=> date("Y-m-d")
    );

    $register = CurlController::request($url, $method, $fields);

    if($register->status != 200){
        echo json_encode(["success"=>false, "error"=>"Error al registrar usuario"]);
        exit;
    }

    // Recuperar recién creado
    $user = CurlController::request("users?linkTo=email_user&equalTo=".$email, "GET", []);
}

if($user->status == 200){
    $_SESSION["user"] = $user->results[0];

    echo json_encode([
        "success"  => true,
        "user"     => $user->results[0],
        "redirect" => $redirect
    ]);
    exit;
}

echo json_encode(["success"=>false, "error"=>"No se pudo autenticar usuario"]);
exit;

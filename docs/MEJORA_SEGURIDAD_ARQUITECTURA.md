# Plan de Acción Definitivo: Mejora de Seguridad y Arquitectura Vanguardista (Pasarela Única: **PayPal**) 

---

## 1. Resumen Ejecutivo

Este plan propone una **reestructura integral** del proyecto e‑commerce, centrada en **un único proveedor de pagos – PayPal** – que ofrece la combinación más alta de seguridad, cumplimiento regulatorio (PCI‑DSS) y cobertura global.  Todas las mejoras de seguridad y modernización arquitectónica se alinean a esta decisión, lo que simplifica la superficie de ataque, reduce la complejidad del código y permite una implementación más robusta y mantenible.

---

## 2. Elección de la Pasarela de Pago

| Criterio | PayPal | Mercado Pago | dLocal |
|----------|--------|--------------|--------|
| **Seguridad** | Tokenización, 3‑DS, certificación PCI‑DSS, detección de fraude propia. | Buen nivel, pero depende de integraciones locales. | Menor historial de auditorías internacionales. |
| **Cobertura Geográfica** | Más de 200 mercados, múltiples divisas. | Principalmente LATAM. | Enfocado en mercados emergentes. |
| **Documentación y SDK** | SDK oficial para PHP, ejemplos claros, soporte activo. | SDK menos maduro, documentación fragmentada. | API más cruda, menos ejemplos. |
| **Mantenimiento** | Actualizaciones automáticas, webhooks estandarizados. | Cambios frecuentes en APIs regionales. | Necesita adaptación constante a regulaciones locales. |
| **Cumplimiento** | Cumple con GDPR, PSD2, Strong Customer Authentication. | Cumple en LATAM, pero menos auditorías internacionales. | Dependiente del país, menos homogéneo. |

**Conclusión**: *PayPal* es la opción más segura y con menor carga operativa para un proyecto que busca estándares internacionales.

---

## 3. Checklist de Hardening de Seguridad (actualizada)

| Área | Problema Detectado | Acción Correctiva (PayPal‑Centric) | Prioridad |
|------|-------------------|-----------------------------------|----------|
| **Secretos** | API keys y JWT secret hard‑coded. | Mover `PAYPAL_CLIENT_ID`, `PAYPAL_CLIENT_SECRET`, `JWT_SECRET` a `.env` usando **vlucas/phpdotenv**. | Alta |
| **JWT** | Generación sin firma; validación sólo compara token. | Usar **Firebase\JWT** con algoritmo HS256, validar `exp`, `iat`, `nbf`. Rotar secreto cada 90 días. | Alta |
| **Inyección SQL** | Concatenación en `orderBy`, `orderMode`. | Consultas preparadas con *whitelist* de columnas (`price`, `created_at`). | Alta |
| **CSRF** | Endpoints AJAX sin protección. | Middleware CSRF que genera token por sesión y lo verifica en cada petición POST/PUT. | Media |
| **Exposición de Errores** | `display_errors=1` en producción. | Desactivar `display_errors`, habilitar `log_errors` → `logs/app.log`. | Alta |
| **Sesiones** | Cookies sin `HttpOnly`/`Secure`. | Configurar `session.cookie_httponly=true`, `session.cookie_secure=true` (HTTPS). | Media |
| **Validación de Entrada** | Falta de sanitización en datos de carrito y checkout. | Utilizar **Respect/Validation** para tipado y rango, `filter_var` para emails. | Media |
| **Rate Limiting** | Sin límite de intentos de pago. | Añadir limitador por IP/usuario (ej. **Laravel Throttle**) para la ruta `/api/payments/paypal/create`. | Baja |

---

## 4. Hoja de Ruta de Modernización Arquitectónica (enfoque PayPal)

```mermaid
flowchart TD
    subgraph "Estado Actual"
        A[PHP Procedural] --> B[Raw PDO + cURL (PayPal & otros)]
        B --> C[Controladores sin DI]
    end
    subgraph "Objetivo"
        D[Framework Slim] --> E[DI Container (PHP‑DI)]
        E --> F[ORM Eloquent / Doctrine]
        F --> G[Servicio PayPal (Strategy)]
        G --> H[Tests PHPUnit & Mockery]
        H --> I[CI/CD (GitHub Actions)]
    end
    A --> D
    style "Estado Actual" fill:#f9d5d3,stroke:#e05d44
    style "Objetivo" fill:#d5f9d3,stroke:#2e8b57
```

### 4.1. Paso 0 – Preparación del Entorno
1. **Instalar Composer** y crear `composer.json`.
2. Añadir dependencias (ejecutar en la raíz del proyecto):
   ```bash
   composer require slim/slim:^4 php-di/php-di vlucas/phpdotenv firebase/php-jwt monolog/monolog guzzlehttp/guzzle
   composer require --dev phpunit/phpunit mockery/mockery
   ```
3. Crear carpeta `src/` con **PSR‑4** (`"App\\": "src/"`).

### 4.2. Paso 1 – Migrar a Slim (solo PayPal)
- **Router**: trasladar rutas de `api/routes/routes.php` a *Slim* (`src/Routes.php`).
- **Controlador PayPal**: crear `App\Controller\PayPalController` que expone:
  - `POST /api/payments/paypal/create` → crea la orden en PayPal.
  - `GET /api/payments/paypal/execute?orderId=` → captura la orden.
- **Middleware**: `AuthMiddleware` (JWT), `CsrfMiddleware`, `ErrorHandler`.
- **Inyección**: pasar a los controladores `PDO $db`, `GuzzleHttp\Client $http`, `Logger $logger`.

### 4.3. Paso 2 – Persistencia con ORM
- Definir entidades `Order`, `OrderItem`, `Product` en `src/Entity/`.
- Configurar **Eloquent** (o **Doctrine**) en `bootstrap.php`:
  ```php
  $capsule = new\Illuminate\Database\Capsule\Manager();
  $capsule->addConnection(require __DIR__.'/../config/database.php');
  $capsule->setAsGlobal();
  $capsule->bootEloquent();
  ```
- Re‑escribir consultas a través del ORM, eliminando SQL crudo.

### 4.4. Paso 3 – Servicio PayPal (Strategy)
```php
interface PaymentGateway {
    public function createOrder(array $orderData): array; // devuelve approval_url y order_id
    public function capture(string $orderId): array; // devuelve status y detalles
    public function verifyWebhook(string $payload, array $headers): bool;
}

class PayPalGateway implements PaymentGateway {
    private $clientId;
    private $clientSecret;
    private $http;
    public function __construct(string $clientId, string $clientSecret, Client $http) { ... }
    // Implementación usando Guzzle y OAuth2 token flow
}
```
- Sólo este gateway se registra en el contenedor (`$container->set(PaymentGateway::class, PayPalGateway::class);`).
- Elimina todo el código relacionado con Mercado Pago y dLocal.

### 4.5. Paso 4 – Transacciones Atómicas
```php
$db->beginTransaction();
try {
    $orderId = $orderService->create($orderDto);
    $paypalResponse = $gateway->createOrder([...]);
    $orderService->storePaypalInfo($orderId, $paypalResponse['order_id']);
    $db->commit();
    return $response->withJson(['approval_url' => $paypalResponse['approval_url']]);
} catch (Exception $e) {
    $db->rollBack();
    $logger->error('Checkout error', ['exception' => $e]);
    return $response->withStatus(500)->withJson(['error' => 'Internal server error']);
}
```
- Garantiza consistencia aunque la llamada a PayPal falle.

### 4.6. Paso 5 – Logging Centralizado
- Configurar **Monolog** con canal `payment` (JSON + correlation ID).
- Cada request a PayPal registra request/response y tiempo.

### 4.7. Paso 6 – Testing & CI/CD (PayPal‑Focused)
**GitHub Actions** (`.github/workflows/php.yml`):
```yaml
name: PHP CI
on: [push, pull_request]
jobs:
  tests:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: mbstring, intl, pdo_mysql
      - name: Install deps
        run: composer install --prefer-dist --no-progress --no-suggest
      - name: Static analysis
        run: vendor/bin/phpstan analyse -l max src
      - name: PHPUnit tests
        env:
          PAYPAL_CLIENT_ID: ${{ secrets.PAYPAL_CLIENT_ID }}
          PAYPAL_CLIENT_SECRET: ${{ secrets.PAYPAL_CLIENT_SECRET }}
        run: vendor/bin/phpunit --coverage-text
```
- Los **secrets** de GitHub almacenan credenciales PayPal encriptadas.

---

## 5. Refactorizaciones de Bugs Críticos (PayPal‑Only)

| Archivo | Issue | Solución Propuesta |
|--------|-------|-------------------|
| `web/controllers/payments.controller.php` | `price_cart` asignado a cada línea del carrito, inflando total. | Calcular `line_total = $item['price'] * $item['quantity'];` y sumar a `$total`. |
| `web/controllers/payments.controller.php` | Captura PayPal solo verifica `APPROVED`. | Implementar llamada `/v2/checkout/orders/{orderId}/capture` y validar que `status === "COMPLETED"`. |
| `web/controllers/payments.controller.php` | Selección frágil de enlace (`links[1]->href`). | Buscar enlace por `rel: "approve"` en la respuesta y usar su `href`. |
| `web/webhooks/paypal.php` (nuevo) | Falta de verificación de firma de webhook. | Validar `X-PayPal-Transmission-Sig` usando la clave pública de PayPal (SDK). |
| `template.controller.php` (JWT) | Secret hard‑coded y sin firma. | Mover `JWT_SECRET` a `.env` y usar `JWT::decode`. |
| `api/models/get.model.php` | Concatenación de `orderBy`/`orderMode`. | Whitelist de columnas y valores, usar consultas preparadas. |
| General | Uso de `curl` manual. | Sustituir por **Guzzle** con manejo de retries y timeout. |

---

## 6. Plan de Migración Incremental (PayPal‑Centric)
1. **Crear rama `feature/paypal‑only‑secure`**.
2. **Commit 1** – Añadir `.env.example` con `PAYPAL_CLIENT_ID`, `PAYPAL_CLIENT_SECRET`, `JWT_SECRET` y cargar `phpdotenv` en `web/index.php`.
3. **Commit 2** – Refactorizar todas las referencias a credenciales (PayPal, JWT) para que lean de `$_ENV`.
4. **Commit 3** – Implementar `PayPalGateway` (classe) y registrar en el contenedor DI.
5. **Commit 4** – Re‑escribir `PaymentsController` como `PayPalController` (clase) usando DI y transacciones PDO.
6. **Commit 5** – Añadir middleware JWT y CSRF a Slim.
7. **Commit 6** – Reemplazar toda la capa de acceso a datos por **Eloquent** (entidades `Order`, `OrderItem`).
8. **Commit 7** – Implementar webhook `web/webhooks/paypal.php` con validación de firma.
9. **Commit 8** – Escribir pruebas unitarias para `PayPalGateway` (mock de Guzzle) y para `PayPalController` (HTTP request/response).
10. **Commit 9** – Configurar GitHub Actions (static analysis + PHPUnit). 
11. **Commit 10** – Despliegue a entorno *staging* y pruebas de carga (JMeter) para validar tiempo de checkout < 1.2 s.

Cada commit abre un **pull request** con revisión de seguridad (PHPStan, Psalm) y documentación actualizada.

---

## 7. Métricas de Éxito (PayPal‑Only)
| Métrica | Valor objetivo |
|---------|----------------|
| Vulnerabilidades críticas (OWASP) | 0 |
| Cobertura de pruebas | ≥ 80 % |
| Tiempo medio de checkout | ≤ 1.2 s |
| Transacciones PayPal fallidas | ≤ 0.5 % del total |
| Deploy automatizado sin intervención | 100 % |
| Incidentes de fraude detectados por PayPal | < 1 por mes (monitorizado en dashboard) |

---

## 8. Documentación y Capacitación (PayPal‑Focused)
- **README.md**: actualizar sección *Variables de entorno* con `PAYPAL_CLIENT_ID`, `PAYPAL_CLIENT_SECRET` y ejemplos de uso.
- **docs/PAYPAL_INTEGRATION.md**: paso‑a‑paso de creación de orden, captura y webhook.
- **docs/MIGRACION.md**: guía para transicionar de código procedural a Slim + ORM.
- **Workshop interno**: 2‑hour live coding donde el equipo implementa una orden PayPal completa usando el nuevo gateway.

---

*Este plan definitivo está listo para ser ejecutado.  La adopción de **una única pasarela (PayPal)** simplifica la arquitectura, reduce la superficie de ataque y facilita la aplicación de buenas prácticas de seguridad y desarrollo moderno.*

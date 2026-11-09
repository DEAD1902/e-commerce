# ARQUITECTURA_COMPLETA.md – Visión Global del Sistema Refactorizado

## 1. Diagrama de Arquitectura (Mermaid)
```mermaid
flowchart LR
    subgraph Client
        Browser[Browser / SPA] -->|HTTP| Nginx[Web Server (Apache/XAMPP)]
    end
    Nginx -->|Requests| Slim[Slim 4 Application]
    Slim -->|DI Container| Container[PHP‑DI]
    Container -->|ORM| Eloquent[Eloquent ORM]
    Container -->|Service| PayPal[PayPalGateway (Guzzle)]
    Container -->|Middleware| Auth[AuthMiddleware]
    Container -->|Middleware| CSRF[CsrfMiddleware]
    Eloquent -->|DB| MySQL[MySQL Database]
    PayPal -->|HTTPS| PayPalAPI[PayPal REST API]
    Slim -->|Routes| Routes[src/routes.php]
    Slim -->|Controllers| Controllers[App\Controller]
    Controllers -->|Models| Models[App\Model]
    Controllers -->|Services| Services[App\Service]
    Controllers -->|Views| Views[public/templates (optional)]
    Auth -->|JWT Validation| JWT[Firebase JWT]
    CSRF -->|Token Validation| CSRFToken[Session CSRF Token]
```

## 2. Componentes Clave
| Componente | Función | Tecnologías | Archivo principal |
|------------|---------|--------------|-------------------|
| **Slim 4** | Enrutamiento, middleware y manejo de peticiones HTTP. | `slim/slim`, `psr/http-message` | `public/index.php`, `src/routes.php` |
| **PHP‑DI** | Contenedor de dependencias; gestiona instancias de servicios y modelos. | `php-di/php-di` | `src/bootstrap.php` |
| **Eloquent ORM** | Abstracción de base de datos, transacciones y relaciones. | `illuminate/database` | `src/Models/*.php` |
| **PayPalGateway** | Cliente HTTP para OAuth, creación de órdenes, captura y verificación de webhook. | `guzzlehttp/guzzle` | `src/Service/PayPalGateway.php` |
| **AuthMiddleware** | Validación de JWT, refresco de expiración, inyección de usuario en request. | `firebase/php-jwt` | `src/Middleware/AuthMiddleware.php` |
| **CsrfMiddleware** | Generación y validación de tokens CSRF para POST/PUT/DELETE. | - | `src/Middleware/CsrfMiddleware.php` |
| **Monolog** | Registro estructurado de events y errores. | `monolog/monolog` | `src/Logger.php` |
| **Configuración** | Variables sensibles cargadas desde `.env`. | `vlucas/phpdotenv` | `.env.example` |

## 3. Flujo de Checkout con PayPal
1. **Cliente** solicita crear una orden → POST `/api/payments/paypal/create`.
2. **PayPalGateway** obtiene token OAuth, envía payload a PayPal `/v2/checkout/orders` con `intent: CAPTURE`.
3. **Respuesta** contiene `approval_url`; el frontend redirige al comprador.
4. Tras la autorización, **PayPal** redirige a `/api/payments/paypal/execute` con `orderId`.
5. **PayPalGateway** llama `/v2/checkout/orders/{id}/capture`; confirma `status === "COMPLETED"`.
6. **Transacción** se persiste en base de datos dentro de una transacción PDO/Eloquent.
7. **Webhook** `/web/webhooks/paypal.php` valida la firma (`PAYPAL_WEBHOOK_ID`) y actualiza el estado de la orden de forma asíncrona.

---

## 4. Seguridad Integrada
- **JWT** firmado con clave aleatoria (256‑bit) desde `.env`.
- **CSRF** tokens por sesión y verificación en middleware.
- **Todas las consultas** usan Eloquent (parámetros enlazados) → elimina SQLi.
- **Secrets** nunca en código; `.env` está en `.gitignore`.
- **RCE** mitigado: carga de archivos solo para admins, validación MIME y extensión.

---

## 5. Próximos Pasos Técnicos
1. Completar migración de lógica de negocio restante a controladores Slim.
2. Añadir pruebas de integración (API + PayPal sandbox).
3. Configurar CI/CD (GitHub Actions, archivo `php.yml`).
4. Documentar proceso de despliegue en `DOCUMENTACION-TECNICA.md`.

---

*Documento actualizado el 2026‑11‑05.*
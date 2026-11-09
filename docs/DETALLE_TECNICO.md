# DETALLE_TECNICO.md – Detalle Técnico del Sistema Refactorizado

## 1. Estructura de Directorios
```
/ecommerce
├─ public/                 # Front‑controller (index.php) y assets estáticos
├─ src/                    # Código de aplicación
│   ├─ Controllers/        # Controladores Slim (ej. PayPalController, ProductController)
│   ├─ Services/           # Servicios de dominio (PayPalGateway, EmailService, etc.)
│   ├─ Models/             # Entidades Eloquent (User, Product, Order, Cart)
│   ├─ Middleware/         # AuthMiddleware, CsrfMiddleware, ErrorMiddleware
│   ├─ Logger.php          # Configuración de Monolog
│   ├─ bootstrap.php       # Configuración DI + Eloquent + .env
│   └─ routes.php          # Registro de rutas y grupos
├─ tests/                  # Tests PHPUnit (controladores, servicios, middleware)
├─ .env.example            # Plantilla de variables de entorno
└─ composer.json           # Dependencias del proyecto
```

## 2. Controladores Principales
| Controlador | Responsabilidad | Rutas Asociadas |
|------------|----------------|-----------------|
| **PayPalController** | Gestión del flujo de pago (create, capture). | `POST /api/payments/paypal/create`, `POST /api/payments/paypal/execute` |
| **ProductController** | CRUD de productos, listado y búsqueda. | `GET /api/products`, `POST /api/products`, `PUT /api/products/{id}`, `DELETE /api/products/{id}` |
| **OrderController** | Creación de órdenes, historial y estado. | `GET /api/orders`, `GET /api/orders/{id}`, `POST /api/orders` |
| **AuthController** | Login, refresco de token y revocación. | `POST /api/auth/login`, `POST /api/auth/refresh` |

## 3. Servicios (Business Logic)
- **PayPalGateway** (`src/Service/PayPalGateway.php`)
  - Obtención de token OAuth2.
  - Creación de órdenes (`/v2/checkout/orders`).
  - Captura de fondos (`/v2/checkout/orders/{id}/capture`).
  - Verificación de webhook (`/v1/notifications/webhooks-events/verification`).
- **EmailService** (ejemplo) para notificaciones transaccionales.
- **UserService** encargado de registro, hashing de contraseñas con `password_hash`, y generación de JWT.

## 4. Modelos Eloquent
```php
class User extends Model {
    protected $table = 'users';
    protected $fillable = ['email','password','role'];
    protected $hidden = ['password'];
}

class Product extends Model {
    protected $table = 'products';
    protected $fillable = ['name','price','stock','description'];
}

class Order extends Model {
    protected $table = 'orders';
    protected $fillable = ['user_id','status','total','paypal_order_id'];
    public function items(){ return $this->hasMany(OrderItem::class); }
}
```
Todas las relaciones se definen con Eloquent, garantizando integridad referencial y soporte de transacciones.

## 5. Middleware de Seguridad
- **AuthMiddleware**: valida JWT (`Firebase\JWT\JWT::decode`) y anexa el objeto `User` al request.
- **CsrfMiddleware**: genera token en sesión y lo verifica en métodos que modifican estado (`POST|PUT|DELETE`).
- **ErrorMiddleware**: captura excepciones y devuelve JSON estandarizado con código HTTP.

## 6. Registro y Logging
Se utiliza **Monolog** con canales `app` y `payment`. Cada llamada externa a PayPal se registra con `request_id` para trazabilidad.

## 7. Gestión de Configuración
Todas las credenciales (`PAYPAL_CLIENT_ID`, `PAYPAL_CLIENT_SECRET`, `JWT_SECRET`, `DB_*`) se cargan desde `.env` mediante **phpdotenv** y nunca aparecen en el repositorio.

---

*Este documento está sincronizado con la última versión del código (2026‑11‑05).*
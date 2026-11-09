# 03 — Arquitectura Observada

> **Estado:** `[CONFIRMADO]` mediante trazabilidad estática completa de procesos, enrutadores, controladores y adaptadores HTTP.

---

## 1. Clasificación Arquitectónica Real

El sistema implementa una **Arquitectura Cliente-Servidor Desacoplada por HTTP Local pero Lógicamente Acoplada a Esquema**, compuesta por dos aplicaciones PHP independientes dentro del mismo repositorio:

1. **Aplicación Web Híbrida (`web/`)**:
   - Actúa simultáneamente como **Storefront SSR**, **Panel Administrativo SSR (`/admin`)**, **Capa de lógica de negocio** y **Puente AJAX (`web/ajax/`)**.
   - **No tiene conexión directa a MySQL**. Todo acceso a datos pasa por peticiones HTTP cURL hacia `http://api.ecommerce.com/` usando `CurlController::request()`.
   - La lógica de negocio (cálculo de totales de carrito, actualización manual de contadores de productos por categoría/subcategoría, orquestación de pagos, creación de órdenes y borrado de archivos físicos) reside íntegramente en `web/` (repartida entre controladores, vistas como `thanks.php` y scripts en `web/ajax/`).
2. **Motor API RESTful Dinámico Basado en Tablas (`api/`)**:
   - Es un pasamanos CRUD genérico sobre PDO (`GetModel`, `PostModel`, `PutModel`, `DeleteModel`) que traduce el primer segmento de la URL (`/{tabla}` o `/relations`) y los parámetros query (`linkTo`, `equalTo`, `rel`, `type`, `select`, `orderBy`, `startAt`, `endAt`, `between1`, `between2`, `search`) directamente en sentencias SQL contra MySQL, apoyándose en `information_schema.columns` y convenciones estrictas de sufijos (`_{entidad}`).

---

## 2. Diagrama de Contexto del Sistema

```mermaid
flowchart LR
    subgraph Actores["Actores"]
        Buyer["Comprador / Visitante\n(Navegador Web)"]
        Admin["Administrador / Editor\n(Navegador Web /admin)"]
    end

    subgraph SistemaPropio["Sistema Ecommerce (c:/xampp/htdocs/ecommerce)"]
        WebApp["Aplicación Web Híbrida (web/)\nSSR + 16 Puentes AJAX + Webhook"]
        RestAPI["API RESTful Dinámica (api/)\nMotor CRUD + JWT + PDO"]
        MySQL[("Base de Datos MySQL\n(ecommerce - 15 tablas)")]
        FS[("Sistema de Archivos Local\n(web/views/assets/img/)")]
    end

    subgraph Externos["Proveedores y Servicios Externos"]
        PayPal["PayPal Sandbox API\n(api-m.sandbox.paypal.com)"]
        DLocal["DLocal Go Sandbox API\n(api-sbx.dlocalgo.com)"]
        MP["Mercado Pago API\n(api.mercadopago.com)"]
        Google["Google Identity Services\n(accounts.google.com)"]
        FB["Facebook OAuth\n(Comentado en UI)"]
        Geo["GeoIP APIs\n(ip-api.com / geoplugin.net)"]
        Mail["Servidor de Correo\n(PHPMailer isMail)"]
    end

    Buyer -->|"HTTP GET/POST + AJAX"| WebApp
    Admin -->|"HTTP GET/POST + AJAX"| WebApp
    WebApp -->|"cURL HTTP + Header Authorization"| RestAPI
    WebApp -->|"Lectura / Escritura GD / unlink"| FS
    RestAPI -->|"PDO (mysql:host=localhost)"| MySQL

    WebApp -->|"OAuth2 + Orders v2"| PayPal
    WebApp -->|"Payments v1"| DLocal
    WebApp -->|"Preferences + Payments v1"| MP
    MP -.->|"Webhook (Roto / Apunta a /thanks)"| WebApp
    Buyer -->|"GSI id_token"| Google
    WebApp -->|"verifyIdToken()"| Google
    WebApp -.->|"Graph SDK (Inactivo)"| FB
    WebApp -->|"HTTP GET JSON"| Geo
    WebApp -->|"mail()"| Mail
```

---

## 3. Diagrama de Contenedores y Procesos Internos

```mermaid
flowchart TD
    subgraph Browser["Navegador del Usuario"]
        DOM["Vistas Renderizadas (HTML/Bootstrap 5/4)"]
        JS["Scripts Cliente (forms.js, tables.js, product.js, carts.js, template.php GSI)"]
        LS[("localStorage\n(token-user / token-admin)")]
        JS <--> LS
        JS <--> DOM
    end

    subgraph WebContainer["Contenedor Web: http://ecommerce.com (web/)"]
        WebIndex["web/index.php\n+ TemplateController"]
        TemplateView["web/views/template.php\n(Session + Enrutador Cascada)"]
        StorePages["Vistas Tienda\n(home, products, product, carrito, checkout, thanks, perfil)"]
        AdminPages["Vistas Admin\n(admin.php -> 11 módulos + tablero)"]
        WebControllers["Controladores de Dominio\n(Users, Payments, Products, Categories, Subcategories, Slides, Banners, Socials, Templates, Admins)"]
        AjaxBridges["16 Puentes AJAX\n(web/ajax/*.ajax.php)"]
        WebhookMP["web/webhooks/mercadopago.php\n(Roto: culr.controller.php)"]
        CurlCtrl["CurlController\n(request, paypal, dlocal, mercadoPago, apiGeoplugin)"]

        WebIndex --> TemplateView
        TemplateView --> StorePages
        TemplateView --> AdminPages
        StorePages --> WebControllers
        AdminPages --> WebControllers
        StorePages --> CurlCtrl
        AdminPages --> CurlCtrl
        WebControllers --> CurlCtrl
        AjaxBridges --> CurlCtrl
    end

    subgraph ApiContainer["Contenedor API: http://api.ecommerce.com (api/)"]
        ApiIndex["api/index.php\n+ RoutesController"]
        ApiRouter["api/routes/routes.php\n(Valida Authorization == apikey)"]
        ApiServices["Servicios HTTP\n(get.php, post.php, put.php, delete.php)"]
        ApiControllers["Controladores API\n(Get, Post, Put, DeleteController)"]
        ApiConn["Connection\n(connect, getColumnsData, jwt, tokenValidate)"]
        ApiModels["Modelos PDO\n(GetModel, PostModel, PutModel, DeleteModel)"]

        ApiIndex --> ApiRouter
        ApiRouter --> ApiServices
        ApiServices --> ApiConn
        ApiServices --> ApiControllers
        ApiControllers --> ApiModels
        ApiModels --> ApiConn
    end

    DOM -->|"Submit Form POST / Navegación GET"| WebIndex
    JS -->|"$.ajax / fetch POST"| AjaxBridges
    CurlCtrl -->|"HTTP GET/POST/PUT/DELETE\nHeader: Authorization"| ApiIndex
```

---

## 4. Análisis de Fronteras y Límites entre Módulos (Sección 4.3 y 5.5)

1. **Ausencia de Frontera de Dominio en `api/` (`[CONFIRMADO]`)**:
   - `api/` no conoce reglas de negocio del e-commerce (no sabe qué es un carrito, un descuento ni un pedido). Solo conoce nombres de tablas, sufijos de columnas y tokens en tablas de autenticación (`users`, `admins`).
2. **Descentralización de Escrituras en `web/` (`[CONFIRMADO]`)**:
   - Las mutaciones de base de datos no están encapsuladas en una capa de servicios:
     - Se ejecutan en **Controladores** (`PaymentsController`, `ProductsController`, etc.) al procesar `$_POST`.
     - Se ejecutan directamente en **Vistas durante peticiones `GET`**: `template.php:L18-22` actualiza `date_updated_user` en cada carga de página; `template.php:L492-496` verifica correos con `token=no`; `product.php:L43-47` incrementa `views_product` con `token=no`; `thanks.php:L74-177` actualiza `carts`, inserta en `orders`, actualiza `products` y elimina `carts`.
     - Se ejecutan en **Puentes AJAX (`web/ajax/`)**: `delete-admin.ajax.php`, `status-admin.ajax.php`, `templates.ajax.php`, `forms.ajax.php`, `google.ajax.php`.
3. **Doble Estado de Autenticación (`$_SESSION` vs `localStorage`) (`[CONFIRMADO]`)**:
   - Al iniciar sesión en PHP (`UsersController::login` o `AdminsController::login`), el servidor guarda el objeto usuario/admin en `$_SESSION["user"]` o `$_SESSION["admin"]` y simultáneamente inyecta un `<script>` que guarda `token_user` o `token_admin` en `localStorage`.
   - Las vistas SSR leen `$_SESSION`, mientras que las llamadas AJAX desde JS (`forms.js`, `tables.js`, `product.js`, `carts.js`) leen el token desde `localStorage` y lo envían por `$_POST["token"]` a `web/ajax/*.ajax.php`.
   - Al cerrar sesión en `web/views/pages/salir/salir.php`, solo se ejecuta `session_destroy()` sin limpiar `localStorage`.
4. **Mantenimiento Manual de Contadores Desnormalizados (`[CONFIRMADO]`)**:
   - Las columnas `categories.subcategories_category`, `categories.products_category` y `subcategories.products_subcategory` se incrementan y decrementan manualmente mediante peticiones `GET` seguidas de `PUT` desde `SubcategoriesController`, `ProductsController` y `delete-admin.ajax.php`, sin transacciones ni bloqueos.


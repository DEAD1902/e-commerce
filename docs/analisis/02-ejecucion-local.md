# 02 — Descubrimiento de Ejecución Local y Configuración

> **Estado de verificación:** `[CONFIRMADO]` mediante inspección estática exhaustiva de puntos de entrada, `.htaccess`, conexiones PDO y clientes cURL.

---

## 1. Puntos de Entrada y Procesos Identificados

Aunque `api/` y `web/` residen dentro de `c:\xampp\htdocs\ecommerce`, el sistema **no puede ejecutarse correctamente desde subcarpetas (`http://localhost/ecommerce/...`)** sin configurar **dos VirtualHosts independientes** en Apache, debido a cómo ambos enrutadores parsean `$_SERVER['REQUEST_URI']` y a las llamadas HTTP quemadas en `CurlController`.

| Proceso / Subsistema | Servidor requerido | Punto de entrada físico | Qué inicializa | Evidencia | Estado |
|---|---|---|---|---|---|
| **Backend API (`api/`)** | Apache VirtualHost en raíz (`http://api.ecommerce.com/`) | `api/index.php` (reescrito por `api/.htaccess`) | Configura errores, cabeceras CORS, carga `RoutesController` -> `api/routes/routes.php`. Exige `count($routesArray) == 1` (`routes.php:L32`). | `api/index.php:L1-28`, `api/routes/routes.php:L6-35` | `[CONFIRMADO]` |
| **Aplicación Web (`web/`)** | Apache VirtualHost en raíz (`http://ecommerce.com/` o similar) | `web/index.php` (reescrito por `web/.htaccess`) | Carga `TemplateController`, `CurlController`, `extensions/vendor/autoload.php`, inicia sesión PHP (`session_start()`) y despacha vistas de tienda o `/admin`. | `web/index.php:L1-26`, `web/views/template.php:L1-658` | `[CONFIRMADO]` |
| **Puentes AJAX (`web/ajax/`)** | Mismo servidor que `web/` | 16 archivos en `web/ajax/*.ajax.php` (invocados directamente porque `web/.htaccess` excluye archivos existentes `!-f`) | Instancian controladores locales (`DatatableController`, `DeleteController`, `FormsController`, etc.) y llaman a `CurlController::request()` o manipulan `web/views/assets/img/`. | `web/.htaccess:L7`, `web/ajax/*.ajax.php` | `[CONFIRMADO]` |
| **Receptor Webhook (`web/webhooks/`)** | Mismo servidor que `web/` (requiere HTTPS por su `.htaccess`) | `web/webhooks/mercadopago.php` | Intenta cargar `culr.controller.php` desde una ruta absoluta de Linux inexistente y falla con Fatal Error. | `web/webhooks/.htaccess:L4-7`, `web/webhooks/mercadopago.php:L8` | `[CONFIRMADO]` |

---

## 2. Variables de Entorno y Configuración Quemada en Código (Hardcoded Config)

El proyecto **no utiliza archivos `.env`** (`[NO ENCONTRADO]`). Toda la configuración de base de datos, dominios, rutas de logs y credenciales de terceros está quemada directamente en el código fuente PHP y JavaScript.

### 2.1 Parámetros de Infraestructura y Acoplamiento de Entorno

| Parámetro / Constante | Valor observado en código | Consumidor | Archivo y línea | Impacto al ejecutar localmente | Estado |
|---|---|---|---|---|---|
| Base de datos MySQL | `host=localhost`, `database="ecommerce"`, `user="root"`, `pass=""` | `Connection::infoDatabase()` / `connect()` | `api/models/connection.php:L11-23, L56-60` | Requiere instancia MySQL/MariaDB local en puerto 3306 con usuario `root` sin contraseña y base de datos llamada `ecommerce`. | `[CONFIRMADO]` |
| URL base de la API | `'http://api.ecommerce.com/'.$url` | `CurlController::request()` | `web/controllers/curl.controller.php:L15` | `web/` realiza peticiones cURL de servidor a servidor hacia `http://api.ecommerce.com/`. Si no está en `C:\Windows\System32\drivers\etc\hosts` y `httpd-vhosts.conf`, todas las peticiones de `web/` fallan. | `[CONFIRMADO]` |
| Ruta de log de errores (API) | `"D:/xampp/htdocs/sist-ecommerce/api\n\t/php_error_log"` | `ini_set("error_log", ...)` | `api/index.php:L9-10` | Contiene un salto de línea/tabulación literal y apunta a una unidad `D:` y carpeta `sist-ecommerce` de otra máquina. | `[CONFIRMADO]` `[RIESGO]` |
| Ruta de log de errores (Web) | `"D:/xampp/htdocs/ecommerce/web/php_error_log"` | `ini_set("error_log", ...)` | `web/index.php:L9` | Apunta a la unidad `D:` cuando el proyecto actual está en `C:\xampp\htdocs\ecommerce`. | `[CONFIRMADO]` `[RIESGO]` |
| Ruta absoluta en Webhook | `"/home/customer/www/ecommerce.cortes24.com/public_html/culr.controller.php"` | `require_once` | `web/webhooks/mercadopago.php:L8` | Ruta de hosting compartido Linux + error tipográfico (`culr` en lugar de `curl`). Provoca fallo fatal inmediato. | `[CONFIRMADO]` `[RIESGO]` |
| Número de WhatsApp | `$phone = 5565422173;` | `template.php`, `product.php`, `ws.php` | `web/views/template.php:L46` | Quemado globalmente en la plantilla principal. | `[CONFIRMADO]` |

### 2.2 Inventario de Credenciales y Secretos en Código (Enmascarados)

> [!CAUTION]
> Siguiendo el Principio 6 y la Sección 3.2 de la guía, **ningún secreto se reproduce en texto plano completo**. Se documenta su ubicación para su rotación y externalización a variables de entorno.

| Tipo de Secreto / Credencial | Valor enmascarado | Consumidor | Ubicación exacta | Estado |
|---|---|---|---|---|
| **API Key interna (`web` ↔ `api`)** | `SSDF...Dadg` | `Connection::apikey()` y `CurlController::request()` | `api/models/connection.php:L31`, `web/controllers/curl.controller.php:L25` | `[CONFIRMADO]` `[RIESGO]` |
| **Clave secreta firma JWT** | `dfhs...ry46` | `JWT::encode()` | `api/controllers/post.controller.php:L64,125,167` | `[CONFIRMADO]` `[RIESGO]` |
| **Sal estática Blowfish (`crypt`)** | `$2a$07$azyb...fhsd$` | `PostController`, `UsersController`, `AdminsController` | `api/controllers/post.controller.php:L35,119`, `web/controllers/users.controller.php:L283,360`, `web/controllers/admins.controller.php:L132,226,293` | `[CONFIRMADO]` `[RIESGO]` |
| **PayPal Sandbox Client ID & Secret** | `AeIu...Fp96` / `ENus...mQVs` | `CurlController::paypal()` | `web/controllers/curl.controller.php:L45-46` | `[CONFIRMADO]` `[RIESGO]` |
| **DLocal Go Sandbox API Key & Secret** | `NQsX...DQBj` / `VC61...9ILa` | `CurlController::dlocal()` | `web/controllers/curl.controller.php:L124-125` | `[CONFIRMADO]` `[RIESGO]` |
| **MercadoPago Access Token (`APP_USR`)** | `APP_USR-4914...6567` | `CurlController::mercadoPago()` | `web/controllers/curl.controller.php:L162` | `[CONFIRMADO]` `[RIESGO]` |
| **Google OAuth Client ID & Secret** | `9861...googleusercontent.com` / `[REDACTADO_GOOGLE_SECRET]..._4Xm` | `template.php`, `google.ajax.php`, `UsersController`, `client_secret.json` | `web/views/template.php:L382`, `web/ajax/google.ajax.php:L28`, `web/views/assets/json/client_secret.json:L1` | `[CONFIRMADO]` `[RIESGO]` |
| **Facebook App ID & Secret** | `584973620817686` / `9ae9...e888` | `UsersController::socialConnect()` | `web/controllers/users.controller.php:L439-440` | `[CONFIRMADO]` `[RIESGO]` |

---

## 3. Guía Reproducible para Ejecución Local Segura en XAMPP

### Requisitos
- **Runtime:** PHP 8.0 / 8.1 / 8.2 (Nota: en PHP 8.x existen 2 bugs de precedencia de operadores string+int documentados en `FIN-03` que lanzan `TypeError` al incrementar vistas de producto o ventas en `thanks.php`).
- **Extensiones PHP requeridas:** `pdo_mysql`, `curl`, `gd`, `mbstring`, `openssl`.
- **Servidor Web:** Apache 2.4 con `mod_rewrite`, `mod_headers` y `mod_setenvif` habilitados.
- **Base de datos:** MariaDB 10.4+ o MySQL 5.7/8.0.

### Paso 1: Configurar VirtualHosts y archivo `hosts`
1. Agregar en `C:\Windows\System32\drivers\etc\hosts`:
   ```text
   127.0.0.1 api.ecommerce.com
   127.0.0.1 ecommerce.com
   ```
2. Agregar en `C:\xampp\apache\conf\extra\httpd-vhosts.conf`:
   ```apache
   <VirtualHost *:80>
       DocumentRoot "C:/xampp/htdocs/ecommerce/api"
       ServerName api.ecommerce.com
       <Directory "C:/xampp/htdocs/ecommerce/api">
           AllowOverride All
           Require all granted
       </Directory>
   </VirtualHost>

   <VirtualHost *:80>
       DocumentRoot "C:/xampp/htdocs/ecommerce/web"
       ServerName ecommerce.com
       <Directory "C:/xampp/htdocs/ecommerce/web">
           AllowOverride All
           Require all granted
       </Directory>
   </VirtualHost>
   ```

### Paso 2: Importar Base de Datos
1. Crear la base de datos `ecommerce` (cotejamiento `utf8_general_ci`).
2. Importar el archivo `c:\xampp\htdocs\ecommerce\ecommerce (1).sql`.

### Paso 3: Problemas Conocidos de Arranque Detectados Estáticamente
- **Fallo en modo `http://localhost/ecommerce/web/`**: Si se intenta abrir sin VirtualHost, aunque `web/views/template.php:L60-66` recorta 2 segmentos de la URI para `localhost`, las rutas relativas a la raíz en HTML/JS (`/carrito`, `/perfil`, `/ajax/forms.ajax.php`, `/views/assets/...`) apuntan a `http://localhost/...` y devuelven `404` `[CONFIRMADO]`.
- **Fallo si `api.ecommerce.com` no responde o la tabla `templates` no tiene un registro con `active_template = 'ok'`**: `web/views/template.php:L108-134` redirige inmediatamente toda la aplicación a la vista `pages/500/500.php` `[CONFIRMADO]`.


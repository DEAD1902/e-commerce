# 01 — Inventario Técnico y Mapa de Evidencias

> **Proyecto:** Sistema Ecommerce (`c:\xampp\htdocs\ecommerce`)  
> **Fecha de análisis:** 2026-10-28  
> **Control de versiones:** `[NO ENCONTRADO]` (No existe directorio `.git` en la raíz del proyecto; únicamente existen archivos `.gitignore`/`.gitattributes` dentro de la plantilla inerte `recursos/AdminLTE-3.2.0`).

---

## 1. Ficha de Reconocimiento Inicial

- **Proyecto/carpeta:** `c:\xampp\htdocs\ecommerce` `[CONFIRMADO]`
- **Fecha:** 2026-10-28 `[CONFIRMADO]`
- **Versión o commit:** Sin repositorio Git en la raíz (`[NO ENCONTRADO]`). Volcado de base de datos fechado el `19-11-2025 18:54:10` en `ecommerce (1).sql:L6` `[CONFIRMADO]`.
- **Ruta raíz:** `c:\xampp\htdocs\ecommerce` `[CONFIRMADO]`
- **Aplicaciones o paquetes identificados:**
  1. **`api/`**: Backend RESTful genérico en PHP nativo + PDO sobre MySQL/MariaDB `[CONFIRMADO]`.
  2. **`web/`**: Aplicación web monolítica SSR (Server-Side Rendering) en PHP nativo que incluye el **Storefront (Tienda)**, el **Panel Administrativo (`/admin`)**, **16 puentes AJAX (`web/ajax/`)** y **1 receptor de Webhook (`web/webhooks/`)** `[CONFIRMADO]`.
  3. **`ecommerce (1).sql`**: Volcado completo de base de datos MariaDB 10.4.32 con esquema (15 tablas) y datos semilla `[CONFIRMADO]`.
- **Lenguajes y runtimes confirmados:** PHP (generado/probado en PHP `8.2.12` según `ecommerce (1).sql:L8`), SQL (MariaDB `10.4.32`), JavaScript (ES5/ES6 con jQuery), HTML5 y CSS3 `[CONFIRMADO]`.
- **Archivos de configuración relevantes:**
  - `api/.htaccess`, `api/index.php`, `api/models/connection.php` `[CONFIRMADO]`
  - `web/.htaccess`, `web/index.php`, `web/controllers/curl.controller.php`, `web/controllers/template.controller.php`, `web/webhooks/.htaccess` `[CONFIRMADO]`
  - `api/vendor/composer/installed.json`, `web/extensions/composer.json`, `web/extensions/composer.lock` `[CONFIRMADO]`
- **Pruebas localizadas:** `[NO ENCONTRADO]` (No existen suites de PHPUnit, Pest, Jest, Cypress ni carpeta `tests/` en `api/` ni en `web/`).
- **Persistencia localizada:** MySQL/MariaDB (`dbname=ecommerce` en `api/models/connection.php:L15`) respaldada por el archivo `ecommerce (1).sql` y almacenamiento local de archivos multimedia en `web/views/assets/img/` `[CONFIRMADO]`.
- **Integraciones aparentes y confirmadas:**
  - **PayPal Orders API v2** (`https://api-m.sandbox.paypal.com/` en `web/controllers/curl.controller.php:L44`) `[CONFIRMADO]`
  - **DLocal Go API v1** (`https://api-sbx.dlocalgo.com/` en `web/controllers/curl.controller.php:L123`) `[CONFIRMADO]`
  - **Mercado Pago API** (`https://api.mercadopago.com/` en `web/controllers/curl.controller.php:L161` y `web/webhooks/mercadopago.php`) `[CONFIRMADO]`
  - **Google Identity Services (GSI) / Google API Client** (`web/views/template.php:L378-468`, `web/ajax/google.ajax.php`, `web/controllers/users.controller.php:L618-747`) `[CONFIRMADO]`
  - **Facebook Graph SDK OAuth** (`web/controllers/users.controller.php:L433-616`, botones comentados en `web/views/modules/modals.php:L31-47`) `[CONFIRMADO]`
  - **Geolocalización por IP**: `ip-api.com` (`web/controllers/template.controller.php:L334`) y `geoplugin.net` (`web/controllers/curl.controller.php:L200`) `[CONFIRMADO]`
  - **PHPMailer** (`web/controllers/template.controller.php:L38-105`) `[CONFIRMADO]`
- **Infraestructura localizada:** Servidor local XAMPP sobre Windows (`Apache` + `MariaDB`). No existen `Dockerfile`, `docker-compose.yml` ni pipelines de CI/CD propios del proyecto (los existentes en `recursos/AdminLTE-3.2.0/` pertenecen a la plantilla base de AdminLTE) `[CONFIRMADO]`.
- **Directorios excluidos del runtime y motivo:**
  - `recursos/AdminLTE-3.2.0/`: Plantilla original descargada de AdminLTE 3.2.0 usada como material de referencia visual durante la maquetación; ningún archivo de `api/` ni `web/` la incluye en tiempo de ejecución `[CONFIRMADO]`.
  - `api/vendor/` y `web/extensions/vendor/`: Código de terceros gestionado por Composer (inventariado por versión en la sección 3) `[CONFIRMADO]`.

---

## 2. Clasificación Estructural del Contenido

| Ruta real | Clasificación | Contenido observado | Responsabilidad | Evidencia | Estado |
|---|---|---|---|---|---|
| `ecommerce (1).sql` | Esquema y Semilla SQL | DDL (`CREATE TABLE`, `ALTER TABLE`) e `INSERT` para 15 tablas | Definición de la base de datos `ecommerce` | `ecommerce (1).sql:L1-856` | `[CONFIRMADO]` |
| `api/` | Código activo (Backend API) | Front controller, enrutador dinámico, 5 controladores, 5 modelos PDO y 4 servicios HTTP | Exponer una API RESTful CRUD genérica y dinámica para todas las tablas | `api/index.php`, `api/routes/routes.php` | `[CONFIRMADO]` |
| `api/Documentación-APIRESTFul.pdf` | Documentación | Manual de 26 páginas del motor API RESTful genérico | Especificar convenciones de sufijos, endpoints `GET/POST/PUT/DELETE` y tokens | `api/Documentación-APIRESTFul.pdf` | `[CONFIRMADO]` |
| `api/vendor/` | Dependencias de terceros | Autoloader de Composer y paquete `firebase/php-jwt` v5.4.0 | Firma de tokens JWT en registro y login | `api/vendor/composer/installed.json:L3-15` | `[CONFIRMADO]` |
| `web/` | Código activo (Frontend + Admin) | Front controller SSR, 12 controladores, vistas de tienda y admin | Renderizado de tienda, panel administrativo, checkout y gestión de sesiones | `web/index.php`, `web/views/template.php` | `[CONFIRMADO]` |
| `web/ajax/` | Código activo (Puentes AJAX) | 16 scripts PHP independientes (`*.ajax.php`) | Alimentar tablas DataTables, subir archivos temporales, OAuth Google y mutaciones rápidas | `web/ajax/*.ajax.php` | `[CONFIRMADO]` |
| `web/webhooks/` | Código inactivo / roto | `.htaccess` y `mercadopago.php` | Receptor asíncrono de notificaciones de MercadoPago (actualmente roto por ruta quemada y typo) | `web/webhooks/mercadopago.php:L8` | `[CONFIRMADO]` |
| `web/template-email.html` | Maqueta estática / Huérfano | Archivo HTML estático de ejemplo de correo | Maqueta de diseño para correos; `TemplateController::sendEmail()` no lo lee sino que construye su propio HTML en línea | `web/template-email.html:L1-45`, `web/controllers/template.controller.php:L62-91` | `[CONFIRMADO]` |
| `web/extensions/vendor/` | Dependencias de terceros | `phpmailer/phpmailer`, `google/apiclient`, `facebook/graph-sdk` y dependencias transitivas | Envío de correo, verificación de tokens Google GSI y SDK de Facebook | `web/extensions/composer.json:L1-8` | `[CONFIRMADO]` |
| `web/views/assets/img/` | Almacenamiento multimedia local | Carpetas `template/`, `categories/`, `subcategories/`, `products/`, `slide/`, `banner/`, `temp/` | Imágenes subidas desde el panel administrativo | `web/controllers/template.controller.php:L155-281` | `[CONFIRMADO]` |
| `recursos/AdminLTE-3.2.0/` | Material de referencia inerte | Distribución completa de AdminLTE 3.2.0 | Referencia estática de maquetación; no participa en ejecución | Inspección cruzada de `require`/`include`/`src` en `web/` | `[CONFIRMADO]` |

---

## 3. Inventario de Tecnologías por Capas

### 3.1 Backend (`api/`)

| Capa | Tecnología / Librería | Versión | Uso real confirmado | Evidencia | Estado |
|---|---|---|---|---|---|
| Lenguaje / Runtime | PHP | Probado en `8.2.12` | Ejecución de la API RESTful | `ecommerce (1).sql:L8`, `api/index.php` | `[CONFIRMADO]` |
| Servidor Web | Apache (`mod_rewrite`, `mod_headers`, `mod_setenvif`) | XAMPP | Reescritura a `index.php` y paso de cabecera `Authorization` | `api/.htaccess:L1-18` | `[CONFIRMADO]` |
| Acceso a Datos | PDO (`mysql` driver) + `information_schema` | Nativo PHP | Consultas preparadas y validación dinámica de tablas/columnas | `api/models/connection.php:L51-135` | `[CONFIRMADO]` |
| Autenticación / Tokens | `firebase/php-jwt` | `v5.4.0` | Firma HS256 (`JWT::encode`) al registrar o iniciar sesión (`JWT::decode` no se usa) | `api/controllers/post.controller.php:L4,64,125,167` | `[CONFIRMADO]` |
| Hashing de Contraseñas | `crypt()` (Blowfish `$2a$07$`) | Nativo PHP | Hash con sal fija `$2a$07$[REDACTADO_SALT]$` | `api/controllers/post.controller.php:L35,119` | `[CONFIRMADO]` |

### 3.2 Aplicación Web (`web/`) — Backend SSR y Dependencias Composer

| Capa | Tecnología / Librería | Versión | Uso real confirmado | Evidencia | Estado |
|---|---|---|---|---|---|
| Cliente HTTP Interno/Externo | Extensión `cURL` (`CurlController`) + `file_get_contents` | Nativo PHP | Comunicación con `http://api.ecommerce.com/`, PayPal, DLocal, MercadoPago, GeoPlugin e `ip-api.com` | `web/controllers/curl.controller.php:L10-217`, `template.controller.php:L337` | `[CONFIRMADO]` |
| Procesamiento de Imágenes | Extensión `GD` (`imagecreatetruecolor`, `imagecopyresampled`) | Nativo PHP | Redimensionamiento y recorte de imágenes JPG/PNG | `web/controllers/template.controller.php:L155-281` | `[CONFIRMADO]` |
| Correo Electrónico | `phpmailer/phpmailer` | `v6.6.5` | Envío mediante `$mail->isMail()` en registro, recuperación, checkout y confirmación | `web/extensions/composer.lock:L848`, `template.controller.php:L45-95` | `[CONFIRMADO]` |
| Autenticación Google | `google/apiclient` | `v2.15.3` | Verificación de `id_token` en `google.ajax.php` y OAuth en `UsersController::socialConnect` | `web/extensions/composer.lock:L133`, `web/ajax/google.ajax.php:L28` | `[CONFIRMADO]` |
| Autenticación Facebook | `facebook/graph-sdk` (Abandonado) | `5.1.4` | Código presente en `UsersController::socialConnect`, pero deshabilitado/comentado en vistas | `web/extensions/composer.lock:L10,66`, `web/views/modules/modals.php:L31-47` | `[CONFIRMADO]` |

### 3.3 Frontend (`web/views/assets/`)

| Librería / Plugin | Ubicación / Carga | Propósito en el proyecto | Evidencia | Estado |
|---|---|---|---|---|
| **Bootstrap 5.2.0 / 4.x** | CDN / Local `plugins/bootstrap/` | UI general (BS5) y vista `/admin/productos/gestion` (BS4 por compatibilidad con Summernote) | `web/views/template.php:L164,269-281` | `[CONFIRMADO]` |
| **AdminLTE 3.2.0** | Local `css/plugins/adminlte/` | Layout del panel administrativo y componentes de tienda | `web/views/template.php:L226,356` | `[CONFIRMADO]` |
| **jQuery** | Local `js/plugins/jquery/` | Manipulación DOM y peticiones `$.ajax` a `web/ajax/*.ajax.php` | `web/views/template.php:L259` | `[CONFIRMADO]` |
| **DataTables + Buttons/Responsive** | Local `plugins/datatables-*` | Tablas paginadas del admin y exportación de reportes (CSV, Excel, PDF, Print) | `web/views/assets/js/tables/tables.js` | `[CONFIRMADO]` |
| **SweetAlert2 & Toastr** | Local `plugins/sweetalert2/`, `toastr/` | Alertas modales de confirmación, carga y notificaciones | `web/views/assets/js/alerts/alerts.js` | `[CONFIRMADO]` |
| **Summernote** | Local `plugins/summernote/` | Editor WYSIWYG para `info_product` con subida de imágenes a `/ajax/upload.ajax.php` | `web/views/assets/js/forms/forms.js` | `[CONFIRMADO]` |
| **Dropzone.js** | Local `plugins/dropzone/` | Carga de galerías de variantes en base64 | `web/views/assets/js/forms/forms.js:L651-660` | `[CONFIRMADO]` |
| **Chart.js** | Referenciado en `template.php:L377` como `plugins/chart.js/Chart.min.js`, pero **la carpeta no existe en disco** | Gráfico lineal de ventas mensuales en `/admin` (actualmente no renderiza: `Chart is not defined`) | `web/views/template.php:L377`, `web/views/pages/admin/tablero/modules/sales-chart.php:L139` | `[CONFIRMADO]` `[RIESGO]` |
| **FlexSlider & knob / twbsPagination** | Local `plugins/` | Galería de detalle de producto y paginación de catálogo | `web/views/assets/js/product/product.js`, `products.js` | `[CONFIRMADO]` |

---

## 4. Registro de Preguntas Abiertas e Incógnitas Resueltas

| ID | Pregunta inicial | Por qué importa | Evidencia encontrada | Estado |
|---|---|---|---|---|
| **Q-001** | ¿La carpeta `recursos/AdminLTE-3.2.0` es parte del sistema en ejecución? | Evitar falsos positivos de Docker/Node.js en el inventario | Ningún archivo de `web/` ni `api/` referencia `recursos/`; `web/` tiene sus propios assets copiados en `web/views/assets/`. | `[CONFIRMADO]` (Excluido del runtime) |
| **Q-002** | ¿Cómo se comunican `web/` y `api/` si están en la misma carpeta? | Determina topología de procesos y requisitos de red local | No se comunican por `include` PHP, sino por HTTP mediante `CurlController::request` apuntando a `http://api.ecommerce.com/`. | `[CONFIRMADO]` |
| **Q-003** | ¿Dónde se gestiona la tabla `sellers` definida en `ecommerce (1).sql`? | Existen FKs físicas hacia `sellers` desde `products`, `variants` y `carts` | No existe controlador ni vista en `web/views/pages/admin/` para `sellers`. Es una funcionalidad incompleta/huérfana en el código pero activa en el esquema SQL. | `[CONFIRMADO]` |
| **Q-004** | ¿El webhook `web/webhooks/mercadopago.php` se utiliza realmente en producción/local? | Define si la confirmación de pagos es asíncrona o dependiente del navegador | `PaymentsController::payment()` envía `notification_url` apuntando a `/thanks` (`payments.controller.php:L235`), y `mercadopago.php:L8` tiene un `require_once` roto (`culr.controller.php`). | `[CONFIRMADO]` (Inactivo/Roto) |


# 04 — Matriz y Fichas de Módulos del Sistema

> **Estado:** `[CONFIRMADO]` mediante inspección completa de `api/` y `web/`.

---

## 1. Matriz General de Módulos Confirmados

| Subsistema | Módulo / Clase | Archivos reales | Entrada | Lógica principal | Tablas leídas / escritas | Salidas y efectos secundarios |
|---|---|---|---|---|---|---|
| **API (`api/`)** | Enrutador y Conexión (`RoutesController`, `Connection`) | `api/index.php`, `api/routes/routes.php`, `api/models/connection.php` | Toda petición HTTP a `api.ecommerce.com/{tabla}` | Valida cabecera `Authorization` contra `apikey()`, consulta `information_schema.columns`, genera/valida tokens y despacha por verbo HTTP. | `information_schema.columns`, `users`, `admins` | Respuestas JSON o inclusión de `services/{get,post,put,delete}.php`. |
| **API (`api/`)** | Motor de Lectura (`GetController`, `GetModel`) | `api/routes/services/get.php`, `api/controllers/get.controller.php`, `api/models/get.model.php` | `GET /{tabla}` o `GET /relations` | Ejecuta 8 variantes de consulta (`getData`, `getDataFilter`, `getRelData`, `getRelDataFilter`, `getDataSearch`, `getRelDataSearch`, `getDataRange`, `getRelDataRange`). | Las 15 tablas del esquema | JSON `{"status": 200, "total": N, "results": [...]}` o `404`. |
| **API (`api/`)** | Motor de Creación y Auth (`PostController`, `PostModel`) | `api/routes/services/post.php`, `api/controllers/post.controller.php`, `api/models/post.model.php` | `POST /{tabla}` (`?register=true`, `?login=true`, `?token=...`) | Inserta registros dinámicamente, hashea contraseñas con `crypt()`, firma JWT (`JWT::encode`) y actualiza `token_*` / `token_exp_*`. | Todas las tablas (`INSERT`); `users` y `admins` (`UPDATE` token) | JSON `{"status": 200, "results": {"lastId": ...}}` o objeto usuario con JWT. |
| **API (`api/`)** | Motor de Edición y Borrado (`Put/DeleteController`, `Put/DeleteModel`) | `api/routes/services/{put,delete}.php`, `api/controllers/{put,delete}.controller.php`, `api/models/{put,delete}.model.php` | `PUT /{tabla}?id=...&nameId=...`, `DELETE /{tabla}?id=...&nameId=...` | Valida token (`tokenValidate`) o excepción (`token=no&except=...`) y ejecuta `UPDATE` o `DELETE` dinámico. | Todas las tablas | JSON `200` con comentario de éxito o error `303`/`400`. |
| **Web (`web/`)** | Orquestador y Utilidades (`TemplateController`) | `web/index.php`, `web/controllers/template.controller.php`, `web/views/template.php` | Toda petición HTTP a la tienda o `/admin` | Gestiona sesión, heartbeat de `token_user`, enrutamiento en cascada, redimensionamiento GD de imágenes (`saveImage`), envío de emails (`sendEmail`) y GeoIP (`exchange`). | Lee `templates`, `products`, `categories`, `subcategories`, `users`; escribe `users` | Renderizado HTML SSR, escritura de imágenes en `views/assets/img/`, envío de correos. |
| **Web (`web/`)** | Adaptador HTTP (`CurlController`) | `web/controllers/curl.controller.php` | Llamadas internas desde controladores, vistas y AJAX | Ejecuta peticiones cURL hacia `api.ecommerce.com`, PayPal, DLocal, MercadoPago y GeoPlugin. | Indirectamente todas vía `api/` | Objetos decodificados (`json_decode`). |
| **Web (`web/`)** | Clientes y Auth (`UsersController`) | `web/controllers/users.controller.php`, `web/views/modules/modals.php`, `web/views/pages/perfil/` | Formularios POST de registro, login, reset, verificación, perfil y rutas `/facebook`, `/google` | Registro con código `confirm_user`, login, recuperación de clave, OAuth y edición de perfil. | `users`, `orders`, `favorites`, `products`, `variants` | Sesión `$_SESSION["user"]`, `localStorage.setItem("token-user")`, correos de confirmación/reset. |
| **Web (`web/`)** | Checkout y Pagos (`PaymentsController`, `thanks.php`) | `web/controllers/payments.controller.php`, `web/views/pages/checkout/`, `web/views/pages/thanks/thanks.php`, `web/webhooks/mercadopago.php` | POST de checkout (`optradio`) y retorno `GET /thanks?ref=...` | Actualiza dirección del usuario, calcula `$totalCart`, crea orden en PayPal/DLocal/MercadoPago, actualiza `carts`, y en `/thanks` crea `orders`, incrementa `sales_product` y vacía `carts`. | `users`, `carts`, `variants`, `products`, `sellers`, `orders` | Redirección a pasarela, correos a vendedor y comprador, creación de pedidos. |
| **Web (`web/`)** | Catálogo e Inventario Admin (`Products`, `Categories`, `SubcategoriesController`) | `web/controllers/{products,categories,subcategories}.controller.php`, `web/views/pages/admin/{productos,categorias,subcategorias}/` | Formularios POST en `/admin` | CRUD de categorías, subcategorías, productos y sus `1..N` variantes; mueve imágenes temporales de Summernote; actualiza contadores `products_category`, `subcategories_category`, `products_subcategory`. | `categories`, `subcategories`, `products`, `variants` | Creación/borrado de carpetas e imágenes en `views/assets/img/`; registros en BD. |
| **Web (`web/`)** | Apariencia, Promoción y Admin (`Admins`, `Templates`, `Slides`, `Banners`, `SocialsController`) | `web/controllers/{admins,templates,slides,banners,socials}.controller.php`, `web/views/pages/admin/` | Formularios POST en `/admin` | Login/reset/CRUD de administradores, gestión de plantillas, slides, banners, redes sociales y edición de estado de pedidos (`PaymentsController::editOrder`). | `admins`, `templates`, `slides`, `banners`, `socials`, `orders`, `visits` | Sesión `$_SESSION["admin"]`, `localStorage.setItem("token-admin")`, imágenes y correos de estado de pedido. |
| **Web (`web/`)** | Puentes Asíncronos (`web/ajax/*.ajax.php`) | 16 archivos en `web/ajax/` | Peticiones `$.ajax` / `fetch` desde JS | Alimentan 9 tablas DataTables, suben archivos temporales (`upload.ajax.php`), eliminan registros y archivos (`delete-admin.ajax.php`), cambian estados (`status-admin.ajax.php`), activan plantillas (`templates.ajax.php`), gestionan carrito/favoritos (`forms.ajax.php`) y login Google (`google.ajax.php`). | Todas las tablas excepto `visits` | Respuestas JSON / texto plano y mutaciones de sistema de archivos. |

---

## 2. Fichas Detalladas de Componentes y Funciones Críticas

### 2.1 Componente: Motor de Consultas Dinámicas (`GetModel`)
- **Estado:** `[CONFIRMADO]`
- **Ubicación:** `api/models/get.model.php:L1-820`
- **Proceso en el que se ejecuta:** Contenedor API (`http://api.ecommerce.com/`)
- **Punto de entrada:** Invocado por `GetController` desde `api/routes/services/get.php:L21-81`.
- **Responsabilidad observada:** Construir y ejecutar sentencias `SELECT` dinámicas simples o con `INNER JOIN` en estrella (`relations`), soportando igualdad (`linkTo`/`equalTo`), búsqueda parcial (`LIKE`), rangos (`BETWEEN` + `IN`), ordenamiento (`ORDER BY`) y paginación (`LIMIT`).
- **Validaciones realizadas:**
  - En consultas a una sola tabla (`getData`, `getDataFilter`, `getDataSearch`, `getDataRange`), valida que la tabla y las columnas de `$select`, `$linkTo` y `$filterTo` existan en `information_schema.columns` mediante `Connection::getColumnsData()`.
  - En consultas relacionales (`getRelData*`), **solo valida que las tablas de `$rel` existan** (`getColumnsData($value, ["*"])`), omitiendo validar las columnas de `$select`, `$linkTo` y `$filterTo` (`[RIESGO]`).
- **Manejo de errores:** Captura `PDOException` en `execute()` y retorna `null` (que `GetController::fncResponse` convierte en HTTP `404`). Sin embargo, `Connection::getColumnsData()` ejecuta `PDO::query()` fuera de un bloque `try/catch`.

### 2.2 Función Crítica: `PaymentsController::payment()`
- **Archivo y símbolo:** `web/controllers/payments.controller.php:L9-306` (`PaymentsController::payment`) `[CONFIRMADO]`
- **Qué problema resuelve:** Procesar el formulario de checkout, persistir los datos de envío del comprador, calcular el importe del carrito, generar una referencia única de pago, iniciar la orden en la pasarela elegida (PayPal, DLocal o MercadoPago), actualizar los ítems del carrito con los metadatos de la transacción y redirigir al comprador.
- **Quién la llama:** `web/views/pages/checkout/modules/pasarelas.php:L62-63` al enviar el formulario POST de `/checkout`.
- **Parámetros y origen de datos:**
  - `$_POST["optradio"]` (`"paypal"`, `"dlocal"`, `"mercado_pago"`), `$_POST["name_user"]`, `$_POST["country_user"]`, `$_POST["department_user"]`, `$_POST["city_user"]`, `$_POST["address_user"]`, `$_POST["phone_user"]`.
  - `$_SESSION["user"]->id_user` y `$_SESSION["user"]->token_user`.
- **Secuencia de lecturas y escrituras:**
  1. `PUT /users?id={id_user}...` (`L24-28`): Actualiza datos de envío del usuario.
  2. `GET /relations?rel=carts,variants,products,sellers&type=cart,variant,product,seller&linkTo=id_user_cart&equalTo={id_user}` (`L36-42`): Obtiene los ítems del carrito.
  3. Calcula `$totalCart` sumando `(offer_variant ?: price_variant) * quantity_cart` (`L49-61`) y genera `$ref = TemplateController::genCodec(1000)` (`L64`).
  4. Envía correo inmediato a `admin@ecommerce.com` anunciando el pago antes de que se confirme (`L70-76`).
  5. Llama a `CurlController::paypal()`, `dlocal()` o `mercadoPago()` (`L109, 166, 239`).
  6. Recorre `$carts` y ejecuta `PUT /carts?id={id_cart}...` (`L117-121, 176-180, 247-251`) guardando `ref_cart=$ref`, `order_cart={gateway_id}`, `method_cart={optradio}` y **`price_cart=$totalCart`** (`[RIESGO]` — sobrescribe el precio de cada línea con el total global del carrito).
  7. Redirige el navegador a la URL de pago de la pasarela (`L129, 186, 261`).

### 2.3 Función/Vista Crítica: Confirmación de Pago en `thanks.php`
- **Archivo y símbolo:** `web/views/pages/thanks/thanks.php:L1-291` `[CONFIRMADO]`
- **Qué problema resuelve:** Validar el retorno del comprador desde la pasarela (`GET /thanks?ref=...`), comprobar el estado del pago en la API de la pasarela y convertir los registros de `carts` en registros definitivos de `orders`.
- **Quién la llama:** Incluida por `web/views/template.php:L555` cuando `$routesArray[0] == "thanks"`.
- **Condiciones de ejecución y efectos secundarios:**
  1. Consulta `GET /relations?rel=carts,variants,products&type=cart,variant,product&linkTo=ref_cart&equalTo={$_GET["ref"]}` (`L12-17`).
  2. Según `$carts[0]->method_cart`:
     - `paypal` (`L27-38`): Consulta `GET v2/checkout/orders/{order_cart}` y exige `status == "APPROVED"` (omite llamar al endpoint `/capture`).
     - `dlocal` (`L44-55`): Consulta `GET v1/payments/{order_cart}` y exige `status == "PAID"`.
     - `mercado_pago` (`L61-116`): Si `order_cart == ""`, toma `$_GET["payment_id"]`, actualiza `carts` y consulta `GET v1/payments/{payment_id}` exigiendo `status == "approved"`.
  3. Si `$status == "ok"` (`L122-201`), por cada ítem del carrito:
     - Inserta en `POST /orders` (`L137-156`) usando `$_SESSION["user"]->token_user`.
     - Actualiza `PUT /products?id={id_product_cart}&nameId=id_product&token=no&except=sales_product` con `"sales_product=".$value->sales_product+$value->quantity_cart` (`L164-168` — falla con `TypeError` en PHP 8+ por precedencia de operadores).
     - Elimina el ítem del carrito con `DELETE /carts?id={id_cart}` (`L174-177`).
     - Envía correo de confirmación al comprador (`L181-195`).


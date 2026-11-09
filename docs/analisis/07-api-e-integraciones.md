# 07 — APIs, Contratos, Puentes AJAX e Integraciones Externas

> **Estado:** `[CONFIRMADO]` mediante contraste directo entre `api/`, `api/Documentación-APIRESTFul.pdf`, `web/controllers/curl.controller.php`, `web/ajax/*.ajax.php` y `web/webhooks/mercadopago.php`.

---

## 1. Motor API RESTful Dinámico (`api/`)

### 1.1 Reglas Globales de Enrutamiento y Autenticación (`api/routes/routes.php`)
- **Estructura de ruta requerida:** Exactamente 1 segmento de ruta (`http://api.ecommerce.com/{tabla_o_relations}`). Si `count($routesArray) == 0`, devuelve `404`. Si `count($routesArray) > 1`, finaliza sin emitir respuesta (`routes.php:L13-32`).
- **Control de acceso de primer nivel (`Authorization`):**
  - Exige cabecera HTTP `Authorization: SSDF...Dadg` (`Connection::apikey()`).
  - Si falta o no coincide, verifica `in_array($table, Connection::publicAccess())` (`routes.php:L40-42`). Como `publicAccess()` devuelve `[""]` (`connection.php:L41`), ninguna tabla real es pública y responde `400 "You are not authorized to make this request"`.
- **Control de acceso de segundo nivel (`token` en `POST`, `PUT`, `DELETE`):**
  - Las peticiones de escritura requieren `?token={jwt}&table={users|admins}&suffix={user|admin}` (si se omiten `table` y `suffix`, asume `users` / `user` por defecto) **o bien** el modo excepción sin token `?token=no&except={columna_existente}` (soportado en `post.php:L68-94` y `put.php:L55-82`).

### 1.2 Inventario Completo de Patrones de Endpoints en `api/`

| Verbo HTTP | Ruta y Query Parameters | Servicio y Método en Modelo | Comportamiento y SQL Generado | Estado |
|---|---|---|---|---|
| `GET` | `/{tabla}?[select=...][&orderBy=...&orderMode=ASC\|DESC][&startAt=N&endAt=M]` | `get.php:L80` -> `GetModel::getData` (`get.model.php:L11-75`) | Valida tabla y `$select` con `getColumnsData`. Ejecuta `SELECT $select FROM $table [ORDER BY ...] [LIMIT ...]`. | `[CONFIRMADO]` |
| `GET` | `/{tabla}?linkTo=c1[,c2]&equalTo=v1[,v2][&select=...]` | `get.php:L21` -> `GetModel::getDataFilter` (`get.model.php:L81-174`) | Filtra por igualdad (`WHERE c1 = :c1 AND c2 = :c2`) usando `bindParam`. | `[CONFIRMADO]` |
| `GET` | `/relations?rel=t0,t1[,t2]&type=s0,s1[,s2][&select=...]` | `get.php:L29` -> `GetModel::getRelData` (`get.model.php:L180-266`) | Une `t0` con `tk` mediante `INNER JOIN tk ON t0.id_{sk}_{s0} = tk.id_{sk}`. No valida columnas de `$select`. | `[CONFIRMADO]` |
| `GET` | `/relations?rel=t0,t1&type=s0,s1&linkTo=c1&equalTo=v1` | `get.php:L37` -> `GetModel::getRelDataFilter` (`get.model.php:L272-385`) | `INNER JOIN` en estrella + filtro `WHERE c1 = :c1`. No valida columnas de `$select` ni `$linkTo`. | `[CONFIRMADO]` |
| `GET` | `/{tabla}?linkTo=c1[,c2]&search=s1[,v2]` | `get.php:L45` -> `GetModel::getDataSearch` (`get.model.php:L391-489`) | Busca con `WHERE c1 LIKE '%$searchArray[0]%'` (interpolado sin parametrizar) y `AND c2 = :c2` para columnas adicionales. | `[CONFIRMADO]` |
| `GET` | `/relations?rel=...&type=...&linkTo=c1[,c2]&search=s1[,v2]` | `get.php:L53` -> `GetModel::getRelDataSearch` (`get.model.php:L496-612`) | `INNER JOIN` en estrella + `LIKE '%$searchArray[0]%'`. | `[CONFIRMADO]` |
| `GET` | `/{tabla}?linkTo=col&between1=b1&between2=b2[&filterTo=f&inTo=val]` | `get.php:L62` -> `GetModel::getDataRange` (`get.model.php:L618-708`) | `WHERE $linkTo BETWEEN '$between1' AND '$between2' [AND $filterTo IN ($inTo)]`. | `[CONFIRMADO]` |
| `GET` | `/relations?rel=...&type=...&linkTo=col&between1=b1&between2=b2[&filterTo=f&inTo=val]` | `get.php:L70` -> `GetModel::getRelDataRange` (`get.model.php:L714-816`) | `INNER JOIN` en estrella + `BETWEEN` + `IN ($inTo)`. | `[CONFIRMADO]` |
| `POST` | `/{tabla}?register=true[&suffix=user\|admin]` (Body form-data) | `post.php:L47` -> `PostController::postRegister` (`post.controller.php:L31-97`) | Si incluye `password_{suffix}`, la hashea con `crypt()` e inserta. Si `password_{suffix}` es nulo/omitido, inserta, genera JWT y actualiza `token_{suffix}`. | `[CONFIRMADO]` |
| `POST` | `/{tabla}?login=true[&suffix=user\|admin]` (Body form-data) | `post.php:L57` -> `PostController::postLogin` (`post.controller.php:L103-199`) | Busca por `email_{suffix}`. Si el usuario tiene contraseña en BD, la verifica con `crypt()`; si es `null` en BD, emite JWT sin pedir contraseña. | `[CONFIRMADO]` |
| `POST` | `/{tabla}?token={jwt}&table={t}&suffix={s}` o `?token=no&except={col}` | `post.php:L84,113` -> `PostModel::postData` (`post.model.php:L11-56`) | Valida que las llaves de `$_POST` existan en `$table` y ejecuta `INSERT INTO $table (...) VALUES (...)`. | `[CONFIRMADO]` |
| `PUT` | `/{tabla}?id={val}&nameId={col}&token={jwt}&table={t}&suffix={s}` o `?token=no&except={col}` | `put.php:L71,101` -> `PutModel::putData` (`put.model.php:L12-68`) | Parsea `php://input` con `parse_str`, valida columnas y ejecuta `UPDATE $table SET ... WHERE $nameId = :$nameId`. | `[CONFIRMADO]` |
| `DELETE` | `/{tabla}?id={val}&nameId={col}&token={jwt}&table={t}&suffix={s}` | `delete.php:L45` -> `DeleteModel::deleteData` (`delete.model.php:L12-52`) | Valida `$nameId` y token, y ejecuta `DELETE FROM $table WHERE $nameId = :$nameId`. No soporta `token=no`. | `[CONFIRMADO]` |

---

## 2. Discrepancias entre `Documentación-APIRESTFul.pdf` y el Código Real

| Aspecto | Lo que afirma `Documentación-APIRESTFul.pdf` | Lo que hace el código real (`api/`) |
|---|---|---|
| **Validación de `select` en relaciones** (pág. 10, 15-20) | Indica que `select` debe contener nombres de columnas válidos de las tablas consultadas. | `getRelData*` solo llama a `getColumnsData($value, ["*"])` para verificar que las tablas existan; **jamás valida `$select`, `$linkTo` ni `$filterTo`**. |
| **Registro y Login sin contraseña** (págs. 21-22) | Establece que los datos mínimos obligatorios son `email` y `password`. | `PostController` (`L44-95, 159-188`) incluye ramas no documentadas en el PDF que registran y autentican usuarios sin contraseña cuando `password_{suffix}` es nulo. |
| **Tablas de acceso público (`publicAccess`)** (pág. 3) | Documenta acceso público de lectura a tablas listadas en `publicAccess()`. | En `routes.php:L59-62`, si una tabla estuviera en `publicAccess()`, fuerza `getData($table, "*", null, null, null, null)`, ignorando cualquier filtro `linkTo`, `select` o paginación. |
| **Verificación de JWT** (págs. 21-25) | Presenta el uso de `firebase/php-jwt` como mecanismo de seguridad de tokens. | `JWT::encode()` se usa para generar la cadena, pero **`JWT::decode()` no se invoca nunca**: `Connection::tokenValidate()` (`connection.php:L164-194`) solo compara la cadena en la BD y el entero `token_exp_*`. |

---

## 3. Inventario de los 16 Puentes AJAX (`web/ajax/*.ajax.php`)

Todos los scripts (salvo `upload.ajax.php`) incluyen `CurlController` y envían automáticamente la `Authorization` API Key maestra a `http://api.ecommerce.com/`.

| Archivo | Símbolo / Clase | Parámetros de Entrada | Verifica `$_SESSION` | Llamadas API / Acciones en Disco | Estado / Riesgo |
|---|---|---|---|---|---|
| `data-admins.ajax.php` | `DatatableController::data` | `$_POST` DataTables (`draw`, `order`, `start`, `length`, `search`) | **No** | `GET /admins` | `[CONFIRMADO]` Expone lista de admins sin sesión. |
| `data-banners.ajax.php` | `DatatableController::data` | `$_POST` DataTables | **No** | `GET /banners` | `[CONFIRMADO]` Sin control de sesión. |
| `data-categories.ajax.php` | `DatatableController::data` | `$_POST` DataTables | **No** | `GET /categories` | `[CONFIRMADO]` Sin control de sesión. |
| `data-orders.ajax.php` | `DatatableController::data` | `$_POST` DataTables | **No** | `GET /relations?rel=orders,users,products,variants` | `[CONFIRMADO]` Expone pedidos y clientes sin sesión. |
| `data-products.ajax.php` | `DatatableController::data` | `$_POST` DataTables | **No** | `GET /relations?rel=products,subcategories,categories` | `[CONFIRMADO]` Bug en `$linkTo[4]` (`L70`). |
| `data-slides.ajax.php` | `DatatableController::data` | `$_POST` DataTables | **No** | `GET /slides` | `[CONFIRMADO]` Regex bloquea guiones al buscar fechas (`L62`). |
| `data-subcategories.ajax.php` | `DatatableController::data` | `$_POST` DataTables | **No** | `GET /relations?rel=subcategories,categories` | `[CONFIRMADO]` Bug en `$linkTo[4]` (`L70`). |
| `data-templates.ajax.php` | `DatatableController::data` | `$_POST` DataTables | **No** | `GET /templates` | `[CONFIRMADO]` Omite `if(!empty($_POST))`. |
| `report-clients.ajax.php` | `DatatableController::data` | `$_GET["between1","between2"]` + `$_POST` DataTables | **No** | `GET /users?select=*` | `[CONFIRMADO]` `[RIESGO]` Volcado total de PII de clientes sin autenticación. |
| `report-sales.ajax.php` | `DatatableController::data` | `$_GET["between1","between2"]` + `$_POST` DataTables | **No** | `GET /relations?rel=orders,users,products,variants&filterTo=process_order&inTo=2` | `[CONFIRMADO]` `[RIESGO]` Volcado financiero de ventas sin autenticación. |
| `delete-admin.ajax.php` | `DeleteController::ajaxDelete` | `$_POST["token","table","id","nameId"]` | **No** (Pasa `token` a la API al final) | `GET`, `unlink()`, `rmdir()`, `PUT` contadores y al final `DELETE /{table}` | `[CONFIRMADO]` `[RIESGO]` Ejecuta `unlink`/`rmdir` **antes** de validar el token en la API (`L25-321`). |
| `status-admin.ajax.php` | `StatusController::ajaxStatus` | `$_POST["token","table","id","status","column"]` | **No** | `PUT /{table}?id=...&token=...` (`status_{column}`) | `[CONFIRMADO]` Sin validación de rol ni whitelist de tabla. |
| `templates.ajax.php` | `TemplatesController::ajaxTemplates` | `$_POST["token","idTemplate"]` | **No** | `GET /templates` -> `PUT active_template=Null` en todas -> `PUT active_template=ok` en `idTemplate` | `[CONFIRMADO]` `[RIESGO]` Si `idTemplate` no existe, deja todas en `"Null"` y tumba el sitio (error 500). |
| `forms.ajax.php` | `FormsController` (7 métodos) | `table/equalTo/linkTo`, `idCategory`, `idProduct/token`, `idFavorite/token`, `idProductCart/...`, `idCartUpdate/...`, `idCartDelete/...` | **No** | `GET /{table}`, `GET /subcategories`, `POST/DELETE /favorites`, `POST/PUT/DELETE /carts` | `[CONFIRMADO]` `[RIESGO]` Oráculo de tablas en `ajaxForms` e IDOR en carrito/favoritos. |
| `google.ajax.php` | Script procedimental | JSON `{id_token, action, redirect}` | Sí (`session_start()`) | `Google\Client::verifyIdToken`, `GET /users`, `POST /users?register=true` | `[CONFIRMADO]` No renueva `token_user` para usuarios existentes (`L51-84`). |
| `upload.ajax.php` | Script procedimental | `$_FILES["file"]` | **No** | Verifica `$_FILES["file"]["type"]` (cabecera cliente) y guarda con la extensión original en `views/assets/img/temp/` | `[CONFIRMADO]` `[RIESGO]` Subida arbitraria de archivos `.php` sin autenticación (`L11, 45-62`). |

---

## 4. Integraciones Externas Confirmadas

| Integración | Proveedor | Archivo / Adaptador | Operaciones y Endpoints | Manejo de Errores / Timeouts | Estado |
|---|---|---|---|---|---|
| **Pagos PayPal** | PayPal Sandbox | `CurlController::paypal` (`curl.controller.php:L42-115`) | `POST v1/oauth2/token` y `POST/GET v2/checkout/orders` | `CURLOPT_TIMEOUT => 0` (sin límite); no captura orden (`/capture`). | `[CONFIRMADO]` |
| **Pagos DLocal** | DLocal Go Sandbox | `CurlController::dlocal` (`curl.controller.php:L121-153`) | `POST/GET v1/payments` | `CURLOPT_TIMEOUT => 0`; verifica `status == "PAID"`. | `[CONFIRMADO]` |
| **Pagos MercadoPago** | Mercado Pago | `CurlController::mercadoPago` (`curl.controller.php:L159-189`) y `webhooks/mercadopago.php` | `POST checkout/preferences`, `GET v1/payments/{id}` | Webhook roto (`culr.controller.php`); `notification_url` mal apuntada a `/thanks`. | `[CONFIRMADO]` |
| **Login Google** | Google Identity Services | `template.php:L378-468`, `google.ajax.php`, `users.controller.php:L618-747` | Validación de `id_token` con `google/apiclient` | Funcional en registro inicial; falla al no refrescar JWT en logins subsecuentes. | `[CONFIRMADO]` |
| **Login Facebook** | Meta Graph SDK v5 | `users.controller.php:L433-616` | OAuth redirect `/facebook` | Inactivo en UI (`modals.php:L31-47` comentado); typo `getLongLivedAccesToken` en `L507`. | `[CONFIRMADO]` |
| **Geolocalización IP** | `ip-api.com` y `geoplugin.net` | `TemplateController::exchange` (`L328-363`), `CurlController::apiGeoplugin` (`L195-217`) | `GET http://ip-api.com/json/{ip}` y `GET http://www.geoplugin.net/json.gp?ip={ip}` | `exchange()` se invoca en cada `formatDate()` y `sendEmail()`, haciendo llamadas HTTP síncronas externas. | `[CONFIRMADO]` |
| **Correo Saliente** | Función `mail()` local vía PHPMailer | `TemplateController::sendEmail` (`template.controller.php:L38-105`) | Envío de HTML con `$mail->isMail()` desde `noreply@ecommerce.com` | En XAMPP local sin servidor SMTP/sendmail configurado, `$mail->send()` falla. | `[CONFIRMADO]` |


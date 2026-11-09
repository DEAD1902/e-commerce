# 09 — Análisis de Seguridad Basado en Evidencia

> **Alcance y nota metodológica:** Esta sección documenta los controles de seguridad observados y las vulnerabilidades confirmadas mediante inspección estática de `api/` y `web/`. Ninguna prueba destructiva fue ejecutada contra servicios externos.

---

## 1. Matriz de Identidad, Sesiones y Autorización Real

Los actores reales del sistema son:
1. **Anónimo** (Visitante sin sesión ni token).
2. **Cliente Autenticado (`users`)** (Posee `$_SESSION["user"]` y `token_user` en `localStorage`).
3. **Administrador Rol `editor` (`admins.rol_admin == 'editor'`)** (Posee `$_SESSION["admin"]` y `token_admin`).
4. **Administrador Rol `admin` (`admins.rol_admin == 'admin'`)** (Posee `$_SESSION["admin"]` y `token_admin`).

| Operación o Recurso | Anónimo | Cliente (`users`) | Admin `editor` | Admin `admin` | Evidencia de cómo se aplica realmente |
|---|---|---|---|---|---|
| **Llamar directamente a `http://api.ecommerce.com/{tabla}`** | Bloqueado si no conoce `Authorization` (pero la clave es fija en código) | Permitido si conoce `Authorization` | Permitido si conoce `Authorization` | Permitido | `api/routes/routes.php:L40` solo compara `getallheaders()["Authorization"] == Connection::apikey()`. |
| **Volcar PII de clientes y ventas vía `/ajax/report-*.ajax.php` y `/ajax/data-*.ajax.php`** | **Permitido (`[RIESGO]`)** | **Permitido (`[RIESGO]`)** | Permitido | Permitido | Ninguno de los 11 archivos `data-*.ajax.php` / `report-*.ajax.php` verifica `$_SESSION["admin"]`; ellos mismos inyectan la `Authorization` API key (`report-clients.ajax.php:L32-170`). |
| **Subir archivos ejecutables (`.php`) vía `/ajax/upload.ajax.php`** | **Permitido (`[RIESGO]`)** | **Permitido (`[RIESGO]`)** | Permitido | Permitido | `web/ajax/upload.ajax.php:L3-62` no verifica sesión ni token y conserva la extensión original del archivo. |
| **Borrar imágenes y carpetas del servidor vía `/ajax/delete-admin.ajax.php`** | **Permitido (`[RIESGO]`)** | **Permitido (`[RIESGO]`)** | Permitido | Permitido | `web/ajax/delete-admin.ajax.php:L25-321` ejecuta `unlink()` y `rmdir()` **antes** de que la API valide `$_POST["token"]` en la línea 323. |
| **Modificar o borrar registros ajenos (`users`, `carts`, `orders`, `admins`) en `api/`** | Permitido en `POST`/`PUT` usando `?token=no&except={col}` si tiene la API key | **Permitido (`[RIESGO]`)** en cualquier tabla (incluso `admins`) con su `token_user` | **Permitido (`[RIESGO]`)** en cualquier tabla con su `token_admin` | Permitido | `Connection::tokenValidate` (`connection.php:L164-194`) solo comprueba que el token exista y no haya expirado en `$tableToken`; no verifica propiedad (`id`) ni permisos sobre la tabla destino (`put.php:L92`, `delete.php:L36`). |
| **Acceder a vistas restringidas de `/admin` (`administradores`, `plantillas`, `pedidos`, `informes`, `clientes`, `redes-sociales`)** | Redirigido a `login.php` (`admin.php:L5-7`) | Redirigido a `login.php` | **Permitido (`[RIESGO]`)** | Permitido | En `administradores.php:L2-7` (y demás módulos) se imprime `<script>window.location=".../404"</script>` **sin `return;`**, enviando todo el HTML y procesando formularios POST; en `redes-sociales.php` ni siquiera existe el `if`. |

---

## 2. Catálogo de Hallazgos de Seguridad Confirmados (`SEC-001` .. `SEC-012`)

### SEC-001 — Inyección SQL en Cláusulas Dinámicas de `GetModel` y `Connection::getColumnsData`
- **Estado:** `[CONFIRMADO]` | **Prioridad:** Crítica | **Confianza:** Alta
- **Ubicación y símbolo:**
  - `api/models/connection.php:L90-92` (`Connection::getColumnsData`)
  - `api/models/get.model.php:L29-60, L130-150, L206-243, L319-356, L432-460, L542-579, L654-690, L732-793` (`GetModel`)
  - Expuesto sin autenticación a través de `web/ajax/data-*.ajax.php` y `web/ajax/forms.ajax.php`.
- **Evidencia:**
  1. `Connection::getColumnsData($table, $columns)` interpola `$table` directamente en `PDO::query("... WHERE table_schema = '$database' AND table_name = '$table'")`.
  2. Los 8 métodos de `GetModel` concatenan directamente `$orderBy`, `$orderMode`, `$startAt` y `$endAt` en la cadena SQL (`ORDER BY $orderBy $orderMode LIMIT $startAt, $endAt`) sin validarlos contra `getColumnsData()` ni hacer cast a entero.
  3. Los 4 métodos relacionales (`getRelData*`) concatenan `$select`, `$type`, `$linkTo` y `$filterTo` sin pasarlos por `getColumnsData()`.
  4. `getDataSearch` y `getRelDataSearch` concatenan `$searchArray[0]` entre comillas simples (`LIKE '%$searchArray[0]%'`).
  5. `getDataRange` y `getRelDataRange` concatenan `$between1`, `$between2` e `$inTo` (`BETWEEN '$between1' AND '$between2' AND $filterTo IN ($inTo)`).
- **Escenario de riesgo:** Un atacante anónimo no necesita siquiera conocer la API key de `api.ecommerce.com`; puede enviar una petición POST a cualquier puente como `/ajax/data-products.ajax.php` manipulando `$_POST["order"][0]["dir"]` (`$orderType`), `$_POST["start"]` o `$_POST["columns"][0]["data"]` (`$orderBy`), los cuales el puente reenvía directamente a `GetModel`.
- **Recomendación:** Validar estrictamente nombres de tablas y columnas contra una lista blanca de identificadores alfanuméricos (`/^[a-zA-Z0-9_]+$/`) verificada en `information_schema` con consultas preparadas; restringir `$orderMode` a `in_array(strtoupper($orderMode), ['ASC','DESC'], true)`; convertir `$startAt` y `$endAt` con `(int)`; y usar `bindValue` para `LIKE`, `BETWEEN` e `IN`.

---

### SEC-002 — Subida Arbitraria de Archivos sin Autenticación y Ejecución Remota de Código (RCE) en `upload.ajax.php`
- **Estado:** `[CONFIRMADO]` | **Prioridad:** Crítica | **Confianza:** Alta
- **Ubicación y símbolo:** `web/ajax/upload.ajax.php:L1-62`
- **Evidencia:**
  - El archivo no inicia sesión (`session_start()`) ni verifica `$_SESSION["admin"]`.
  - En `L11` valida únicamente `$_FILES["file"]["type"]` (cabecera `Content-Type` controlada por el cliente) contra `"image/jpeg"`, `"image/png"`, `"image/gif"`.
  - En `L45-51` toma la extensión del nombre original del archivo (`$extension = explode(".", $_FILES["file"]["name"]); ... $file = $name.".".$extension[count($extension)-1];`) y en `L60-62` lo guarda en `../views/assets/img/temp/$file` devolviendo la ruta pública `/views/assets/img/temp/$file`.
- **Escenario de riesgo:** Cualquier usuario anónimo puede enviar una petición `multipart/form-data` a `/ajax/upload.ajax.php` con un archivo `shell.php` y cabecera `Content-Type: image/jpeg`. El servidor guardará `/views/assets/img/temp/{random}.php`, permitiendo ejecución remota de código PHP en el servidor web.
- **Recomendación:** Exigir sesión activa de administrador (`$_SESSION["admin"]`), validar la imagen mediante `getimagesize()` / `finfo_file()`, mapear la extensión a partir del MIME real detectado (forzando `.jpg`, `.png` o `.gif`), reprocesar con GD y deshabilitar la ejecución de PHP en `views/assets/img/` mediante `.htaccess`.

---

### SEC-003 — Roto Control de Autorización a Nivel de Objeto/Tabla (IDOR, Escalada de Privilegios y Bypass `?token=no`)
- **Estado:** `[CONFIRMADO]` | **Prioridad:** Crítica | **Confianza:** Alta
- **Ubicación y símbolo:** `api/models/connection.php:L164-194` (`Connection::tokenValidate`), `api/routes/services/post.php:L68-114`, `api/routes/services/put.php:L55-103`, `api/routes/services/delete.php:L31-47`, `web/ajax/forms.ajax.php:L88-97, 147-176`.
- **Evidencia:**
  1. `Connection::tokenValidate($token, $table, $suffix)` solo verifica que exista alguna fila en `$table` con `token_{suffix} == $token` y `time() < token_exp_{suffix}`, devolviendo `"ok"`. **Descarta la identidad del usuario** y no comprueba que el dueño del token sea el propietario del registro `$_GET["id"]` ni que tenga rol para modificar la tabla solicitada.
  2. A través de `forms.ajax.php` (`updateCart`, `remCart`, `remFavorite`), cualquier cliente con un `token_user` válido puede modificar o borrar el carrito o favoritos de cualquier otro cliente cambiando `idCartUpdate`, `idCartDelete` o `idFavorite`.
  3. En `post.php:L70` y `put.php:L57`, pasar `?token=no&except={cualquier_columna_de_la_tabla}` omite por completo la validación de token JWT.
- **Recomendación:** Eliminar el parámetro `?token=no&except=...` del acceso externo, verificar criptográficamente el JWT con `JWT::decode()`, extraer el `id` y el `rol` del token validado y comprobar en cada `POST`, `PUT` y `DELETE` la propiedad del recurso y los permisos sobre la tabla.

---

### SEC-004 — Exposición de PII, Ventas y Borrado Arbitrario de Archivos en Puentes AJAX sin Sesión (`web/ajax/`)
- **Estado:** `[CONFIRMADO]` | **Prioridad:** Crítica | **Confianza:** Alta
- **Ubicación y símbolo:** `web/ajax/report-clients.ajax.php:L1-183`, `web/ajax/report-sales.ajax.php:L1-192`, `web/ajax/data-admins.ajax.php:L1-188`, `web/ajax/data-orders.ajax.php:L1-236`, `web/ajax/delete-admin.ajax.php:L1-347`.
- **Evidencia:**
  - Los scripts de `web/ajax/` no verifican `$_SESSION["admin"]` y actúan como proxies abiertos que inyectan la API key maestra (`CurlController::request`).
  - `report-clients.ajax.php` vuelca `SELECT * FROM users` (nombres, correos, teléfonos, direcciones físicas).
  - `delete-admin.ajax.php:L25-321` ejecuta todas las llamadas `unlink()` y `rmdir()` sobre `views/assets/img/` **antes** de enviar la petición `DELETE` que valida `$_POST["token"]` en la línea 323.
- **Recomendación:** Iniciar sesión y verificar `isset($_SESSION["admin"])` (y el rol requerido) al inicio de todos los endpoints administrativos en `web/ajax/`, y validar el token y permisos antes de tocar el sistema de archivos.

---

### SEC-005 — Bypass de Control de Acceso Basado en Roles (RBAC) en Vistas Administrativas (`editor` vs `admin`)
- **Estado:** `[CONFIRMADO]` | **Prioridad:** Alta | **Confianza:** Alta
- **Ubicación y símbolo:**
  - `web/views/pages/admin/administradores/administradores.php:L2-7`
  - `web/views/pages/admin/plantillas/plantillas.php:L1-6`
  - `web/views/pages/admin/pedidos/pedidos.php:L1-6`
  - `web/views/pages/admin/informes/informes.php:L3-8`
  - `web/views/pages/admin/clientes/clientes.php:L2-7`
  - `web/views/pages/admin/redes-sociales/redes-sociales.php:L1-30`
- **Evidencia:**
  - Las 5 primeras vistas ejecutan `if ($_SESSION["admin"]->rol_admin == "editor"){ echo '<script>window.location = "'.$path.'404";</script>'; }` **sin `return;` ni `exit;`**. PHP continúa renderizando el módulo completo y ejecutando los controladores POST (`AdminsController::adminManage`, `TemplatesController::templatesManage`, `PaymentsController::editOrder`).
  - `redes-sociales.php` carece por completo de la comprobación de rol.
- **Recomendación:** Añadir `return;` o `exit;` inmediatamente después de la redirección y validar `$_SESSION["admin"]->rol_admin === "admin"` dentro de cada controlador y puente AJAX.

---

### SEC-006 — Autenticación sin Contraseña en `PostController::postLogin` y `postRegister`
- **Estado:** `[CONFIRMADO]` | **Prioridad:** Alta | **Confianza:** Alta
- **Ubicación y símbolo:** `api/controllers/post.controller.php:L44-95` (`postRegister`) y `L159-188` (`postLogin`).
- **Evidencia:**
  - En `postLogin` (`L159`), si la fila del usuario en BD tiene `password_{suffix} == null` (como ocurre con todos los usuarios registrados vía Google OAuth), la API genera, guarda y devuelve un JWT válido recibiendo **únicamente** el `email_user`, sin verificar contraseña ni `id_token` de Google.
- **Recomendación:** No permitir que el endpoint genérico `?login=true` emita tokens sin contraseña; exigir la validación del token OAuth en el servidor antes de emitir un JWT interno.

---

### SEC-007 — Criptografía Débil (Sal Estática Blowfish), Exposición de Hashes en `GET` y Secretos Quemados en Código
- **Estado:** `[CONFIRMADO]` | **Prioridad:** Alta | **Confianza:** Alta
- **Ubicación y símbolo:** `api/controllers/post.controller.php:L35,119`, `api/models/connection.php:L29-33`, `web/controllers/curl.controller.php:L25,45-46,124-125,162`, `web/views/assets/json/client_secret.json`.
- **Evidencia:**
  1. Todas las contraseñas de usuarios y administradores se hashean con `crypt($pass, '$2a$07$[REDACTADO_SALT]$')` (sal fija idéntica para todos los registros y factor de costo bajo `07`). En `ecommerce (1).sql`, `admin@ecommerce.com`, `editor@ecommerce.com` y `user@ecommerce.com` tienen exactamente el mismo hash.
  2. `GetController` no filtra `password_user`, `password_admin`, `token_user` ni `token_admin` cuando se consulta `GET /users` o `GET /admins`.
  3. Las claves de PayPal, DLocal, MercadoPago (`APP_USR-...`), Google OAuth (`client_secret.json` accesible vía web si no se protege) y Facebook están quemadas en el repositorio.
- **Recomendación:** Migrar a `password_hash($pass, PASSWORD_BCRYPT)` y `password_verify()`, excluir columnas de credenciales en `GetModel`, bloquear acceso HTTP a `.json` sensibles y mover todos los secretos a variables de entorno (`.env`).

---

### SEC-008 — XSS Almacenado / Reflejado y Ausencia de Protección CSRF
- **Estado:** `[CONFIRMADO]` | **Prioridad:** Media-Alta | **Confianza:** Alta
- **Ubicación y símbolo:** `web/ajax/data-*.ajax.php`, `web/ajax/report-*.ajax.php`, `web/views/pages/admin/administradores/modules/gestion.php:L42`, `web/views/modules/modals.php`, `web/views/pages/checkout/checkout.php`.
- **Evidencia:**
  1. Los 11 archivos `data-*.ajax.php` y `report-*.ajax.php` construyen respuestas JSON concatenando cadenas manualmente sin `json_encode` ni `htmlspecialchars`, permitiendo inyectar HTML/JS en las celdas de DataTables (donde además `token-admin` reside en `localStorage`).
  2. Ningún formulario POST del sistema (`UsersController`, `PaymentsController`, `AdminsController`, `ProductsController`, etc.) implementa tokens anti-CSRF.
- **Recomendación:** Construir las respuestas de DataTables mediante `json_encode()` escapando salidas con `htmlspecialchars()`, migrar tokens de `localStorage` a cookies `HttpOnly; SameSite=Lax`, e implementar tokens CSRF por sesión.


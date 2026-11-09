# 11 — Despliegue, Observabilidad y Operación

> **Estado:** `[CONFIRMADO]` respecto de la configuración versionada en la carpeta; los aspectos de producción externa no incluidos en el repositorio se declaran como `[NO VERIFICABLE]`.

---

## 1. Evidencia de Entornos y Despliegue

El repositorio no incluye pipelines de CI/CD propios, manifiestos Kubernetes ni configuración de Terraform (`[NO ENCONTRADO]`). Sin embargo, la inspección del código revela rastros concretos de **tres entornos históricos distintos** en los que este código fue ejecutado o editado:

| Entorno Detectado | Evidencia en el Código | Base de Datos | Integraciones de Pago | Estado |
|---|---|---|---|---|
| **1. Entorno Local Actual (`C:\xampp\htdocs\ecommerce`)** | Ruta física actual del workspace y volcado `ecommerce (1).sql` generado desde `127.0.0.1` (`MariaDB 10.4.32`, `PHP 8.2.12`). | `localhost` / `ecommerce` (`root` sin clave en `api/models/connection.php:L13-19`). | PayPal Sandbox, DLocal Sandbox, MercadoPago (`sandbox_init_point` en `payments.controller.php:L261`). | `[CONFIRMADO]` |
| **2. Entorno Local Previo en Unidad `D:`** | `api/index.php:L9-10` (`"D:/xampp/htdocs/sist-ecommerce/api\n\t/php_error_log"`) y `web/index.php:L9` (`"D:/xampp/htdocs/ecommerce/web/php_error_log"`). | Misma configuración local XAMPP. | Sandbox. | `[CONFIRMADO]` |
| **3. Rastros de Hosting Compartido / Dominios Externos** | - `web/webhooks/mercadopago.php:L8`: `/home/customer/www/ecommerce.cortes24.com/public_html/culr.controller.php`<br>- `web/controllers/users.controller.php:L626`: `https://oasis.anmec.org/google`<br>- `web/views/assets/js/plugins/countdown/countdown.min.js:L3`: `https://miblogi.com/...` | Desconocida en hosting remoto (`[NO VERIFICABLE]`). | En `payments.controller.php:L257-261` existe comentada la línea `$mercadoPago->init_point` (producción) junto a `$mercadoPago->sandbox_init_point` (activa). | `[CONFIRMADO]` |

---

## 2. Observabilidad, Logs y Manejo de Errores en Operación

1. **Configuración de Errores PHP (`[CONFIRMADO]` `[RIESGO]`)**:
   - Tanto `api/index.php:L7-8` como `web/index.php:L7-8` y `web/ajax/google.ajax.php:L4-5` tienen `ini_set("display_errors", 1)` y `ini_set("log_errors", 1)`.
   - Como las rutas de `error_log` apuntan a la unidad `D:` (y en `api/index.php` contienen un salto de línea `\n\t` inválido en nombres de archivo de Windows), el guardado en disco del log de errores falla o se desvía al log global de Apache, mientras que `display_errors = 1` imprime errores y rutas internas directamente en las respuestas HTTP/JSON.
   - En sentido opuesto, `web/views/pages/admin/tablero/modules/date-range.php:L5` ejecuta `error_reporting(0)`, ocultando silenciosamente cualquier error en los módulos posteriores del dashboard.
2. **Logs de Webhooks (`[CONFIRMADO]`)**:
   - `web/webhooks/mercadopago.php:L16-20` intenta abrir `mercadopago.log` en modo `a+` y escribir el cuerpo crudo de la petición, pero nunca llega a ejecutarse debido al `require_once` roto en la línea 8.
3. **Métricas, Trazas y Correlación de Peticiones (`[NO ENCONTRADO]`)**:
   - No existe integración con herramientas de APM, OpenTelemetry ni identificadores de correlación (`X-Request-Id`) entre las llamadas de `CurlController` en `web/` y las respuestas de `api/`.

---

## 3. Análisis de Modos de Fallo Operativo y Recuperación (Sección 12)

| Escenario de Fallo | Respuesta Implementada en el Sistema | Impacto Operativo | Evidencia |
|---|---|---|---|
| **Base de datos MySQL desconectada o caída** | `Connection::connect()` ejecuta `die("Error: ".$e->getMessage())` con código HTTP 200. `CurlController::request()` recibe texto no-JSON (`json_decode` devuelve `null`), y `web/views/template.php:L118` muestra la página `500.php`. | Caída total de tienda y panel `/admin`, exponiendo el mensaje de excepción de PDO en la API. | `api/models/connection.php:L64-68`, `web/views/template.php:L118-134` |
| **Timeout en Pasarelas de Pago o API interna (`CurlController`)** | Todos los métodos de `CurlController` configuran `CURLOPT_TIMEOUT => 0` (espera infinita) y no verifican `curl_errno($curl)`. | Si PayPal, DLocal, MercadoPago o `ip-api.com` tardan en responder, el worker de Apache/PHP queda bloqueado hasta agotar `max_execution_time`. | `web/controllers/curl.controller.php:L19,60,94,135,171,204` |
| **Usuario cierra el navegador tras pagar en la pasarela antes de volver a `/thanks`** | No existe job de conciliación ni webhook funcional. | El dinero se cobra en DLocal/MercadoPago, pero los ítems permanecen en `carts` y **jamás se crea el pedido en `orders`**. | `web/views/pages/thanks/thanks.php`, `web/webhooks/mercadopago.php:L8` |
| **Fallo al activar plantilla en `/admin/plantillas` (`templates.ajax.php`)** | El script primero pone `active_template = "Null"` en todas las filas de `templates` y al final pone `"ok"` en la seleccionada. | Si falla la última petición o el ID es inválido, ninguna plantilla queda activa y todo el sitio (incluido `/admin`) devuelve permanentemente la vista `500.php` hasta actualizar la BD manualmente. | `web/ajax/templates.ajax.php:L26-56`, `web/views/template.php:L108-134` |
| **Backups y Restauración** | Existe únicamente el volcado manual `ecommerce (1).sql` en la raíz del proyecto; no existen scripts de backup automático ni restauración verificada. | `[NO ENCONTRADO]` para automatización de copias de seguridad. | Raíz del workspace |


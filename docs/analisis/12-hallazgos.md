# 12 — Registro Consolidado de Defectos, Riesgos, Deuda Técnica e Incógnitas

> **Estado:** `[CONFIRMADO]`. Todos los hallazgos están clasificados según la Sección 13 de la guía, separando observación, evidencia, impacto y recomendación.  
> *(Nota: Las vulnerabilidades de seguridad `SEC-001` a `SEC-008` detalladas en `09-seguridad.md` se referencian aquí de forma cruzada junto con los defectos funcionales y financieros).*

---

## 1. Matriz Resumen de Hallazgos Prioritarios

| ID | Tipo | Prioridad | Título Concreto | Ubicación Principal | Estado |
|---|---|---|---|---|---|
| **FIND-001** (`FIN-01`) | Defecto confirmado (Financiero) | **Crítica** | Inflación de importes (`price_cart` y `price_order` guardan el total global del carrito en cada ítem individual) | `web/controllers/payments.controller.php:L119,178,249`, `web/views/pages/thanks/thanks.php:L145` | `[CONFIRMADO]` |
| **FIND-002** (`FIN-02`) | Defecto confirmado (Financiero) | **Crítica** | Órdenes de PayPal entregadas en estado `APPROVED` sin ejecutar el cobro (`POST .../capture`) | `web/views/pages/thanks/thanks.php:L29-37` | `[CONFIRMADO]` |
| **FIND-003** (`FIN-03`) | Defecto confirmado (Runtime PHP 8) | **Crítica** | `Fatal error: TypeError (string + int)` al actualizar `sales_product` en `thanks.php` y `views_product` en `product.php` | `web/views/pages/thanks/thanks.php:L166`, `web/views/pages/product/product.php:L45` | `[CONFIRMADO]` |
| **FIND-004** (`DRIFT-01`) | Defecto confirmado (Datos / Flujo) | **Crítica** | Productos nuevos creados desde el Admin carecen de `id_seller_product`, rompiendo la inserción y lectura del carrito (`carts`) | `web/controllers/products.controller.php:L394-406`, `ecommerce (1).sql:L816,837` | `[CONFIRMADO]` |
| **FIND-005** (`SEC-001..004`) | Riesgo / Vulnerabilidad de Seguridad | **Crítica** | SQLi en cláusulas dinámicas (`api/`), subida arbitraria de `.php` (`upload.ajax.php`), borrado de archivos sin auth (`delete-admin.ajax.php`), IDOR y exposición de PII (`report-clients.ajax.php`) | `api/models/get.model.php`, `api/models/connection.php`, `web/ajax/*.ajax.php` | `[CONFIRMADO]` |
| **FIND-006** (`FIN-04`) | Defecto confirmado (Inventario) | **Alta** | El stock (`variants.stock_variant`) nunca se descuenta al comprar y la tienda fabrica stock falso (`rand(10,20)`) cuando es `0` | `web/views/pages/thanks/thanks.php:L122-201`, `web/views/pages/product/product.php:L275-284`, `product.js:L201-208` | `[CONFIRMADO]` |
| **FIND-007** (`FIN-05/09`) | Defecto confirmado (Arquitectura Pagos) | **Alta** | Webhook de MercadoPago roto (`culr.controller.php`) y `notification_url` mal apuntada; todo el fulfillment depende de `GET /thanks` con sesión activa | `web/webhooks/mercadopago.php:L8`, `web/controllers/payments.controller.php:L235` | `[CONFIRMADO]` |
| **FIND-008** (`SEC-005`) | Defecto confirmado (RBAC Admin) | **Alta** |Falta de `return;` tras redirección JS para el rol `editor` en 5 módulos administrativos y omisión total del chequeo en `redes-sociales.php` | `web/views/pages/admin/{administradores,plantillas,pedidos,informes,clientes,redes-sociales}/` | `[CONFIRMADO]` |
| **FIND-009** | Defecto confirmado (Auth Admin) | **Alta** | Si `password_admin` no cumple el regex al crear/editar administrador, no hay `return;` y se sobrescribe la contraseña en BD con cadena vacía `""` | `web/controllers/admins.controller.php:L222-245, L289-312` | `[CONFIRMADO]` |
| **FIND-010** | Defecto confirmado (Auth Google) | **Alta** | `google.ajax.php` no invoca `users?login=true` para usuarios existentes, dejando `token_user` nulo o expirado y causando cierre de sesión en `template.php` | `web/ajax/google.ajax.php:L51-84`, `web/views/template.php:L18-36` | `[CONFIRMADO]` |
| **FIND-011** (`DRIFT-04`) | Defecto confirmado (Admin Productos) | **Alta** | Eliminar un producto en `delete-admin.ajax.php` no elimina antes sus variantes/favoritos ni sus imágenes de galería, fallando `rmdir()` y lanzando `PDOException` por FK | `web/ajax/delete-admin.ajax.php:L118-173`, `api/models/delete.model.php:L37` | `[CONFIRMADO]` |
| **FIND-012** | Defecto confirmado (Frontend Carrito) | **Media** | `carts.js` produce `NaN` al actualizar cantidades cuando el precio o subtotal es `>= 1,000.00` debido a la coma de `number_format()` | `web/views/pages/carrito/carrito.php:L141-170`, `web/views/assets/js/carts/carts.js:L29-46` | `[CONFIRMADO]` |
| **FIND-013** | Defecto confirmado (Admin / Vistas) | **Media** | Variables indefinidas (`$createData` al editar banner en `banners.controller.php:L29`, `$updateData` en `socials.controller.php:L97`, `$warrantyDate` en `compras.php:L99`) y archivo `Chart.min.js` inexistente (`template.php:L377`) | `banners.controller.php:L29`, `socials.controller.php:L97`, `compras.php:L99`, `template.php:L377` | `[CONFIRMADO]` |
| **FIND-014** | Defecto confirmado (UI / Búsqueda) | **Media** | Ahorro negativo mostrado en detalle de producto (`offer - price`), bug de `404` en la 6.ª columna del buscador (`template.php:L634`, `products.php:L235`) y error en `$linkTo` de `data-products.ajax.php:L70` | `product.php:L169`, `product.js:L129`, `template.php:L617-638`, `data-products.ajax.php:L70` | `[CONFIRMADO]` |
| **FIND-015** | Deuda técnica | **Media** | Consultas N+1 por cada carga de página (`navbar.php`, `footer.php`), heartbeat `PUT /users` en cada petición GET y llamadas HTTP externas a `ip-api.com` en cada `formatDate()` | `template.php:L18`, `navbar.php:L98`, `footer.php:L40`, `template.controller.php:L334,370` | `[CONFIRMADO]` |

---

## 2. Fichas Detalladas de los Defectos Técnicos Principales

### FIND-001 — Inflación de importes en carritos con múltiples productos (`price_cart` y `price_order`)
- **Tipo:** Defecto confirmado | **Estado:** `[CONFIRMADO]` | **Prioridad:** Crítica
- **Ubicación:** `web/controllers/payments.controller.php:L47-61, L119, L178, L249` y `web/views/pages/thanks/thanks.php:L145`.
- **Comportamiento actual:** `PaymentsController::payment()` suma el total de todos los ítems en `$totalCart`. Posteriormente, dentro del bucle `foreach ($carts as $key => $value)`, actualiza cada fila del carrito enviando `price_cart=".$totalCart`. En `thanks.php:L145`, al crear cada fila en `orders`, se asigna `"price_order" => $value->price_cart`.
- **Escenario de fallo:** Si un cliente tiene 3 ítems de \$100 MXN cada uno (`$totalCart = 300`), las 3 filas en `orders` se guardan con `price_order = 300` cada una. El dashboard (`tablero/modules/top.php:L19`) y el reporte de ventas (`report-sales.ajax.php`) suman `price_order` de las 3 filas, reportando \$900 MXN en lugar de \$300 MXN.
- **Recomendación:** Calcular el subtotal de cada línea (`$itemPrice = (!empty($value->offer_variant) ? $value->offer_variant : $value->price_variant) * $value->quantity_cart`) y guardar `$itemPrice` en `price_cart`, manteniendo `$totalCart` únicamente para el cobro agregado en la pasarela.
- **Criterio de resolución:** Al comprar $N$ productos en un mismo checkout, la suma de `orders.price_order` para ese `ref_order` debe ser exactamente igual a `$totalCart`.

---

### FIND-002 — Ausencia de captura (`capture`) en pagos de PayPal Orders v2
- **Tipo:** Defecto confirmado | **Estado:** `[CONFIRMADO]` | **Prioridad:** Crítica
- **Ubicación:** `web/controllers/payments.controller.php:L84-111` y `web/views/pages/thanks/thanks.php:L27-38`.
- **Comportamiento actual:** La orden se crea en PayPal con `"intent": "CAPTURE"`. Cuando el comprador aprueba el pago en PayPal y regresa a `/thanks?ref=...`, `thanks.php:L29-30` ejecuta únicamente una petición `GET v2/checkout/orders/{order_cart}` y da por válido el pago si `$paypal->status == "APPROVED"`.
- **Escenario de fallo:** En PayPal Orders v2, el estado `APPROVED` solo indica que el comprador autorizó la orden; el dinero no se transfiere ni el estado pasa a `COMPLETED` hasta que el comercio envía `POST v2/checkout/orders/{id}/capture`. El sistema entrega los productos y cursos sin cobrar los fondos.
- **Recomendación:** Cuando `$paypal->status == "APPROVED"`, ejecutar `CurlController::paypal("v2/checkout/orders/".$carts[0]->order_cart."/capture", "POST", "{}")` y verificar que la respuesta tenga `status == "COMPLETED"`.
- **Criterio de resolución:** Las órdenes de PayPal quedan en estado `COMPLETED` en el sandbox de PayPal antes de insertar registros en `orders`.

---

### FIND-003 — Error fatal `TypeError: Unsupported operand types: string + int` en PHP 8+ (`thanks.php` y `product.php`)
- **Tipo:** Defecto confirmado | **Estado:** `[CONFIRMADO]` | **Prioridad:** Crítica
- **Ubicación:** `web/views/pages/thanks/thanks.php:L166` y `web/views/pages/product/product.php:L45`.
- **Evidencia:**
  - `thanks.php:L166`: `$fields = "sales_product=".$value->sales_product+$value->quantity_cart;`
  - `product.php:L45`: `$fields = "views_product=".$product->views_product+1;`
- **Comportamiento actual:** En PHP, los operadores `.` y `+` requieren paréntesis explícitos cuando se concatena el resultado de una suma a un string; de lo contrario, se evalúa primero `"sales_product=" . $value->sales_product` (dando el string `"sales_product=0"`) y luego se intenta sumar `+$value->quantity_cart`. En PHP 8.0+, sumar un entero a un string no numérico lanza un `TypeError` fatal no capturado.
- **Impacto potencial:**
  1. En `product.php:L45`, impide renderizar el resto de la página de detalle de producto si `display_errors` o el manejador detiene la ejecución.
  2. En `thanks.php:L166`, el fallo ocurre **justo después** de `POST /orders` (`L156`) y **antes** de `DELETE /carts` (`L174`). El primer ítem se inserta en `orders`, el script muere antes de borrarlo del carrito, y cada vez que el usuario refresca `/thanks?ref=...` se crean órdenes duplicadas infinitamente.
- **Recomendación:** Colocar paréntesis alrededor de la suma: `"sales_product=".($value->sales_product + $value->quantity_cart)` y `"views_product=".($product->views_product + 1)`.
- **Criterio de resolución:** Ejecutar ambos flujos en PHP 8.2 sin que se produzca `TypeError` y verificando el incremento exacto en la base de datos.

---

### FIND-004 — Bloqueo de compra para productos creados en el Admin por omisión de `id_seller_product`
- **Tipo:** Defecto confirmado | **Estado:** `[CONFIRMADO]` | **Prioridad:** Crítica
- **Ubicación:** `web/controllers/products.controller.php:L394-406, L503-516`, `web/views/pages/product/product.php:L342`, `web/ajax/forms.ajax.php:L125`, `ecommerce (1).sql:L816,837`.
- **Comportamiento actual:** La base de datos define una tabla `sellers` y llaves foráneas desde `products.id_seller_product`, `variants.id_seller_variant` y `carts.id_seller_cart` hacia `sellers.id_seller`. Sin embargo, el formulario y controlador de productos en `/admin/productos/gestion` no incluyen ningún campo para seleccionar vendedor (`id_seller_product` queda en `NULL`). Cuando un cliente intenta agregar ese producto al carrito, `id_seller_cart` se envía vacío (`""`), violando la restricción `FOREIGN KEY (id_seller_cart) REFERENCES sellers (id_seller)` en MySQL, o quedando excluido del carrito por el `INNER JOIN sellers` en `navbar.php:L32` y `payments.controller.php:L36`.
- **Recomendación:** Incorporar el selector de vendedor (`id_seller_product` / `id_seller_variant`) en `/admin/productos/gestion` (o asignar por defecto `id_seller = 1`), o bien eliminar la dependencia obligatoria de `INNER JOIN sellers` cuando un producto no tenga vendedor asignado.
- **Criterio de resolución:** Un producto recién creado desde `/admin/productos/gestion` puede agregarse al carrito, visualizarse en `/carrito` y completarse en `/checkout`.


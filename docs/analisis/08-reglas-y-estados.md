# 08 — Reglas de Negocio y Máquinas de Estados

> **Estado:** `[CONFIRMADO]` mediante inspección de controladores, vistas y modelos en `web/` y `api/`.

---

## 1. Máquinas de Estados del Sistema

Siguiendo la Sección 9 de la guía, las máquinas de estados de **Carrito (`carts`)**, **Pedido (`orders`)** y **Usuario (`users`)** se documentan por separado tal como las trata el código.

### 1.1 Máquina de Estados del Carrito (`carts`)

```mermaid
stateDiagram-v2
    [*] --> EnCarrito : POST /carts (FormsController::addCart)\nref_cart=NULL, order_cart=NULL, price_cart=0
    EnCarrito --> EnCarrito : PUT /carts (FormsController::updateCart)\nModifica quantity_cart
    EnCarrito --> Eliminado : DELETE /carts (FormsController::remCart)
    EnCarrito --> PendientePago : PUT /carts (PaymentsController::payment)\nAsigna ref_cart, order_cart (PayPal/DLocal), method_cart, price_cart=$totalCart
    PendientePago --> OrdenCreada : GET /thanks?ref=... (status == "ok")\nCrea fila en orders + DELETE /carts
    PendientePago --> PendientePago : Fallo TypeError en thanks.php:L166 (PHP 8)\nCrea fila en orders pero NO ejecuta DELETE /carts
    Eliminado --> [*]
    OrdenCreada --> [*]
```

### 1.2 Máquina de Estados del Pedido (`orders.process_order`)

En `orders`, la columna `process_order` (`int(11)`) representa el estado logístico del pedido (`data-orders.ajax.php:L140-178`, `perfil/modules/compras.php:L127-172`, `PaymentsController::editOrder` en `payments.controller.php:L312-370`):

```mermaid
stateDiagram-v2
    [*] --> Proceso0_Pendiente : POST /orders en thanks.php:L129\n(Si type_variant == "gallery")
    [*] --> Proceso2_Entregado : POST /orders en thanks.php:L133\n(Si type_variant == "video" - entrega inmediata)

    Proceso0_Pendiente --> Proceso1_EnProceso : Admin PUT /orders (PaymentsController::editOrder)\nprocess_order = 1 (En reparto / Guía)
    Proceso1_EnProceso --> Proceso2_Entregado : Admin PUT /orders (PaymentsController::editOrder)\nprocess_order = 2 (Entregado)
    Proceso0_Pendiente --> Proceso2_Entregado : Admin PUT /orders (Salto directo a 2)
    Proceso2_Entregado --> Proceso3_Garantia : Admin PUT /orders\nprocess_order = 3 (Garantía)
    Proceso2_Entregado --> Proceso4_Devolucion : Admin PUT /orders\nprocess_order = 4 (Devolución / Reembolso)
```

### 1.3 Tabla de Transiciones de Estado Confirmadas

| Entidad real | Campo de estado | Estado inicial | Acción / Evento | Actor | Condición previa en código | Estado final | Efectos secundarios | Evidencia |
|---|---|---|---|---|---|---|---|---|
| `users` | `verification_user` | `0` (No verificado) | Click en enlace `/?confirm={code}` | Comprador | `GET /users?linkTo=confirm_user&equalTo={code}` devuelve `200` | `1` (Verificado) | `PUT /users?...&token=no&except=verification_user` | `web/views/template.php:L482-521` |
| `templates` | `active_template` | `"Null"` | Radio button `.changeTemplate` en `/admin/plantillas` | Admin (`token-admin`) | `POST /ajax/templates.ajax.php` con `idTemplate` | `"ok"` en la elegida, `"Null"` en las demás | Si `idTemplate` no existe, todas quedan en `"Null"` y el sitio cae en error 500 | `web/ajax/templates.ajax.php:L26-56` |
| `categories`, `subcategories`, `products`, `slides`, `banners` | `status_{entidad}` | `1` (Activo) | Switch Bootstrap `.changeStatus` en DataTables | Admin (`token-admin`) | `POST /ajax/status-admin.ajax.php` | `0` (Inactivo) o `1` (Activo) | `PUT /{tabla}?id=...&nameId=id_{col}` | `web/ajax/status-admin.ajax.php:L15-21` |
| `carts` | `ref_cart`, `order_cart`, `method_cart` | `NULL` | Submit formulario `/checkout` | Comprador autenticado | `PaymentsController::payment()` crea orden/preferencia en pasarela | `ref_cart={ref}`, `order_cart={id}`, `price_cart=$totalCart` | Envía email a `admin@ecommerce.com` y redirige a pasarela | `web/controllers/payments.controller.php:L115-261` |
| `orders` | `process_order` | `0` (`gallery`) o `2` (`video`) | Retorno `GET /thanks?ref={ref}` | Comprador con `$_SESSION["user"]` | Pasarela devuelve `APPROVED` / `PAID` / `approved` | `0` o `2` | `POST /orders`, `PUT /products` (`sales_product`), `DELETE /carts`, email al cliente | `web/views/pages/thanks/thanks.php:L122-199` |
| `orders` | `process_order` | `0`, `1`, `2`, `3`, `4` | Modal `.modalEditOrder` en `/admin/pedidos` | Admin (`$_SESSION["admin"]`) | `PaymentsController::editOrder()` (`isset($_POST["idOrder"])`) | `0..4` + `track_order` y fechas | Envía email al comprador notificando cambio en su pedido | `web/controllers/payments.controller.php:L312-370` |

---

## 2. Catálogo de Reglas de Negocio Observadas (`BR-001` .. `BR-010`)

### BR-001 — Cálculo del importe total del carrito y prioridad de oferta
- **Regla observada:** Para cada ítem del carrito, si `offer_variant` no está vacío (`!empty($value->offer_variant)`), se usa `offer_variant * quantity_cart`; en caso contrario se usa `price_variant * quantity_cart`.
- **Estado de certeza:** `[CONFIRMADO]`
- **Dónde se aplica:** `web/controllers/payments.controller.php:L49-61`, `web/views/modules/navbar.php:L197-205`, `web/views/pages/carrito/carrito.php:L141-170`, `web/views/pages/checkout/modules/carrito.php:L52-80`.
- **Excepciones / Defectos:** Ninguno de estos archivos verifica si la fecha límite de la oferta (`end_offer_variant`) ya expiró (`end_offer_variant < date("Y-m-d")`), salvo la vista de detalle `product.php:L145` para mostrar u ocultar el contador regresivo.
- **Riesgo si se incumple:** El comprador sigue pagando el precio de oferta aunque `end_offer_variant` haya vencido (`FIN-07`).

### BR-002 — Entrega inmediata de productos tipo `"video"` frente a productos físicos (`"gallery"`)
- **Regla observada:** Al confirmarse un pago en `thanks.php`, si la variante comprada tiene `type_variant == "gallery"`, el pedido nace con `process_order = 0` (pendiente de envío físico). Si `type_variant == "video"`, nace directamente con `process_order = 2` (entregado) y habilita el acceso al reproductor en `/aprendizaje/{url_product}`.
- **Estado de certeza:** `[CONFIRMADO]`
- **Dónde se aplica:** `web/views/pages/thanks/thanks.php:L128-135`, `web/views/pages/perfil/modules/compras.php:L127-219`, `web/views/pages/aprendizaje/aprendizaje.php:L1-95`.
- **Dónde se vuelve a validar:** En `aprendizaje.php:L13-25` se comprueba que exista una fila en `orders` para `id_user_order == $_SESSION["user"]->id_user` y `url_product == $routesArray[1]`.

### BR-003 — Plazo de garantía (`warranty_order`) diferenciado por tipo de variante
- **Regla observada:** Todo pedido se crea en `thanks.php:L149` con un valor fijo `warranty_order = 7` (7 días). En `/perfil` (`compras.php:L89-121`), la vigencia de la garantía para productos físicos (`gallery`) se calcula sumando `warranty_order` días a `end_date_order` (fecha de entrega), mientras que para cursos (`video`) se suma a `start_date_order` (fecha de compra).
- **Estado de certeza:** `[CONFIRMADO]`
- **Dónde se aplica:** `web/views/pages/thanks/thanks.php:L149` y `web/views/pages/perfil/modules/compras.php:L89-121`.
- **Riesgo / Defecto:** En `compras.php:L90-99`, si un producto `gallery` aún no ha sido entregado (`end_date_order == null`), la variable `$warrantyDate` no se define antes de evaluarse en la línea 99.

### BR-004 — Contabilización de ventas en Dashboard y Reportes solo para pedidos con `process_order = 2`
- **Regla observada:** Tanto la tarjeta de "Ventas Totales" del dashboard (`tablero/modules/top.php:L7`), como el gráfico de ventas (`sales-chart.php:L9`) y el reporte exportable de ventas (`report-sales.ajax.php:L32,105`), filtran exclusivamente los pedidos cuyo `process_order == 2` (Entregado).
- **Estado de certeza:** `[CONFIRMADO]`
- **Dónde se aplica:** `web/views/pages/admin/tablero/modules/top.php:L7`, `sales-chart.php:L9`, `web/ajax/report-sales.ajax.php:L32,105`.

### BR-005 — Reglas de protección contra borrado en `delete-admin.ajax.php`
- **Regla observada:**
  1. No se puede eliminar el administrador principal con `id_admin == 1` (`delete-admin.ajax.php:L14-19`).
  2. No se puede eliminar una categoría si `subcategories_category > 0` (`L38-43`).
  3. No se puede eliminar una subcategoría si `products_subcategory > 0` (`L76-81`).
  4. No se puede eliminar una plantilla si es la única existente (`$totalTemplates == 1`) o si está activa (`active_template == "ok"`) (`L216-235`).
  5. No se puede eliminar un slide si es el único existente (`$totalSlides == 1`) (`L264-269`).
- **Estado de certeza:** `[CONFIRMADO]`
- **Dónde se aplica:** Únicamente en el puente `web/ajax/delete-admin.ajax.php`. **No** se valida en `api/routes/services/delete.php`.
- **Defecto asociado:** `delete-admin.ajax.php` **no** impide borrar un producto que tenga variantes, favoritos u órdenes, lo que provoca el borrado de su imagen principal seguido de un fallo fatal de `FOREIGN KEY` en MySQL (`DRIFT-04`).

### BR-006 — Restricción de módulos entre roles `admin` y `editor`
- **Regla observada:** El rol `editor` solo debe gestionar `Slides`, `Banners`, `Categorías`, `Subcategorías` y `Productos`; no debe acceder a `Administradores`, `Plantillas`, `Redes Sociales`, `Pedidos`, `Informes`, `Clientes` ni a los KPIs financieros del `Tablero`.
- **Estado de certeza:** `[CONFIRMADO]`
- **Dónde se aplica:** `web/views/modules/sidebar.php:L52-183` y vistas en `web/views/pages/admin/`.
- **Fallo crítico de aplicación:** En las vistas restringidas (`administradores.php`, `plantillas.php`, `pedidos.php`, `informes.php`, `clientes.php`) se imprime `<script>window.location = ".../404";</script>` **sin `return;` ni `exit;`**, en `redes-sociales.php` ni siquiera existe la comprobación, y en `api/` cualquier token de `admins` (sea `editor` o `admin`) tiene permisos totales sobre todas las tablas (`SEC-03`, `SEC-05`).


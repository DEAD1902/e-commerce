# 10 — Pruebas y Calidad

> **Estado:** `[CONFIRMADO]` (`[NO ENCONTRADO]` para suites de pruebas automatizadas en el código propio del proyecto).

---

## 1. Inventario de Herramientas de Pruebas y Análisis Estático

| Categoría | Estado en `api/` y `web/` | Observación sobre `recursos/AdminLTE-3.2.0/` | Evidencia |
|---|---|---|---|
| **Pruebas Unitarias / Integración (PHPUnit, Pest)** | `[NO ENCONTRADO]` | No existen archivos `phpunit.xml` ni carpetas `tests/` en `api/` ni en `web/`. | Inspección de árbol de directorios y `composer.json` en `api/` y `web/extensions/`. |
| **Pruebas Frontend / E2E (Jest, Cypress, Playwright)** | `[NO ENCONTRADO]` | Tampoco existen en `web/`. | Inspección de árbol de directorios. |
| **Linters y Análisis Estático (PHPStan, Psalm, ESLint)** | `[NO ENCONTRADO]` en código propio | Los archivos `.eslintrc.json` y `.stylelintrc` presentes en `recursos/AdminLTE-3.2.0/` pertenecen exclusivamente a la plantilla de referencia inerte. | `recursos/AdminLTE-3.2.0/.eslintrc.json` |

---

## 2. Matriz de Cobertura Funcional Observada

Dado que no existen pruebas automatizadas en el repositorio, todas las verificaciones de comportamiento se realizaron mediante **inspección estática trazable**:

| Flujo real | Prueba automatizada localizada | Camino feliz (Inspección estática) | Manejo de errores | Control de permisos | Concurrencia / Idempotencia | Estado de verificación |
|---|---|---|---|---|---|---|
| **Consultas y CRUD en `api/`** | `[NO ENCONTRADO]` | Cubierto en `Get/Post/Put/DeleteModel` | Parcial (`Post/Put/DeleteModel` no capturan `PDOException` en `execute()`) | Débil (`tokenValidate` no verifica propiedad ni rol; existe bypass `token=no`) | Sin transacciones | Inspeccionado estáticamente `[CONFIRMADO]` |
| **Catálogo y Detalle (`products.php`, `product.php`)** | `[NO ENCONTRADO]` | Cubierto con paginación y variantes | Bug de `404` adicional en el 6.º filtro de búsqueda (`template.php:L634`) y `TypeError` en `product.php:L45` (PHP 8) | Público | Incremento de `views_product` no atómico | Inspeccionado estáticamente `[CONFIRMADO]` |
| **Registro, Login y Perfil (`UsersController`, `google.ajax.php`)** | `[NO ENCONTRADO]` | Cubierto en registro directo y login | En `google.ajax.php`, usuarios existentes no reciben nuevo `token_user` | `postLogin` permite login sin contraseña si `password_user == null` | Heartbeat `PUT users` en cada carga de página (`template.php:L18`) | Inspeccionado estáticamente `[CONFIRMADO]` |
| **Carrito (`forms.ajax.php`, `carrito.php`, `carts.js`)** | `[NO ENCONTRADO]` | Cubierto para productos con `id_seller_product` válido | Falla si `id_seller_product` es `NULL` (productos nuevos del admin); `NaN` en JS si precio `>= 1,000` | IDOR en `updateCart` y `remCart` | Duplica filas al agregar la misma variante varias veces | Inspeccionado estáticamente `[CONFIRMADO]` |
| **Checkout y Pasarelas (`PaymentsController::payment`)** | `[NO ENCONTRADO]` | Redirige a PayPal, DLocal y MercadoPago | Sobrescribe `price_cart` con `$totalCart` (`FIN-01`); no valida `end_offer_variant` | Requiere `$_SESSION["user"]` | Actualizaciones secuenciales por cURL sin transacción | Inspeccionado estáticamente `[CONFIRMADO]` |
| **Fulfillment en `/thanks` y Webhook (`thanks.php`, `mercadopago.php`)** | `[NO ENCONTRADO]` | Crea `orders` y vacía `carts` en PHP 7 | En PHP 8 falla en `thanks.php:L166` (`TypeError` string+int) antes de borrar `carts`; PayPal no llama a `/capture`; no descuenta `stock_variant`; webhook roto | Mutación crítica en petición `GET` dependiente de `$_SESSION` | Alta vulnerabilidad a duplicación de órdenes al recargar `/thanks` | Inspeccionado estáticamente `[CONFIRMADO]` |
| **Administración y Puentes AJAX (`admin/`, `web/ajax/`)** | `[NO ENCONTRADO]` | CRUD de catálogo, plantillas, slides, banners y pedidos | Bugs de variables indefinidas en `banners.controller.php:L29`, `socials.controller.php:L97` y `admins.controller.php:L228` | Puentes `web/ajax/` sin control de sesión; vistas restringidas sin `return;` para rol `editor` | `templates.ajax.php` desactiva todas las plantillas antes de activar la nueva | Inspeccionado estáticamente `[CONFIRMADO]` |

---

## 3. Recomendaciones Prioritarias de Pruebas Seguras

1. **Suite de Pruebas de Integración para `api/` (PHPUnit):**
   - Probar los 8 modos de `GET`, `POST` (`register`, `login`, `postData`), `PUT` y `DELETE` sobre una base de datos SQLite/MySQL efímera (`ecommerce_test`).
   - Incluir pruebas de regresión de seguridad para verificar que un `token_user` no pueda modificar registros de otro `id_user` ni escribir en `admins`, `products` u `orders`.
2. **Pruebas Unitarias y de Integración para el Cálculo Financiero y Fulfillment:**
   - Verificar que un carrito con múltiples productos persista el precio unitario o subtotal de línea correcto en `price_cart` y `price_order` (`FIN-01`).
   - Verificar la idempotencia de confirmación de pago (que recargar `/thanks?ref=...` o recibir un webhook simultáneo nunca cree órdenes duplicadas ni falle en PHP 8.2).


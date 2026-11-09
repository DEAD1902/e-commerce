# 00 — Resumen Técnico Ejecutivo del Proyecto

> **Proyecto:** Sistema Ecommerce (`c:\xampp\htdocs\ecommerce`)  
> **Fecha de análisis:** 2026-10-28  
> **Metodología aplicada:** [Guía Definitiva de Ingeniería Inversa E-Commerce (Mejorada)](file:///c:/Users/USER/Documents/Nueva%20carpeta/guia_definitiva_ingenieria_inversa_ecommerce.md) y suite de 6 Skills en `.agents/skills/`.

---

## 1. Identificación y Alcance

- **Ruta analizada:** `c:\xampp\htdocs\ecommerce` `[CONFIRMADO]`
- **Versión / Commit:** Sin repositorio Git en la raíz (`[NO ENCONTRADO]`). Volcado SQL fechado el `19-11-2025` sobre `MariaDB 10.4.32` y `PHP 8.2.12` (`ecommerce (1).sql:L6-8`).
- **Áreas revisadas al 100%:**
  - Esquema y datos semilla en [ecommerce (1).sql](file:///c:/xampp/htdocs/ecommerce/ecommerce%20(1).sql) (15 tablas).
  - Motor API RESTful en `api/` y su manual [Documentación-APIRESTFul.pdf](file:///c:/xampp/htdocs/ecommerce/api/Documentaci%C3%B3n-APIRESTFul.pdf).
  - Aplicación web `web/` (Storefront SSR, 12 controladores, vistas de tienda, panel administrativo `/admin`, 16 puentes en `web/ajax/`, webhook en `web/webhooks/` y 15 scripts JS personalizados).
- **Áreas excluidas del runtime:**
  - `recursos/AdminLTE-3.2.0/`: Plantilla original estática guardada como referencia de maquetación; ningún archivo de `api/` ni `web/` la importa en ejecución (`TR-001`).

---

## 2. Funcionalidad y Arquitectura Observada

El sistema se divide en dos contenedores lógicos en PHP que se comunican por HTTP mediante cURL (`CurlController::request` -> `http://api.ecommerce.com/`):

1. **[`api/` — Motor RESTful CRUD Genérico](file:///c:/xampp/htdocs/ecommerce/docs/analisis/07-api-e-integraciones.md):**
   - Traduce peticiones `GET`, `POST`, `PUT` y `DELETE` sobre `/{tabla}` o `/relations` en consultas SQL dinámicas usando PDO e `information_schema.columns`, exigiendo una convención donde toda tabla está en plural (`users`, `products`) y sus columnas terminan con el sufijo en singular (`_user`, `_product`).
   - Carece de lógica de negocio de comercio electrónico; toda la orquestación reside en `web/`.
2. **[`web/` — Storefront SSR, Panel `/admin` y Puentes AJAX](file:///c:/xampp/htdocs/ecommerce/docs/analisis/03-arquitectura-observada.md):**
   - Implementa el catálogo con variantes (`gallery` para productos físicos y `video` para cursos en línea), carrito de compras, checkout con **PayPal**, **DLocal Go** y **MercadoPago**, perfil de cliente y un panel administrativo para gestionar administradores, plantillas visuales, categorías, subcategorías, productos/variantes, slides, banners, pedidos y reportes.

### Índice Completo de Entregables Generados en `docs/analisis/`

| Documento | Propósito |
|---|---|
| [01-inventario.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/01-inventario.md) | Estructura de directorios, separación de código vivo vs. `recursos/`, tecnologías y dependencias por capa. |
| [02-ejecucion-local.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/02-ejecucion-local.md) | Requisitos de VirtualHosts (`api.ecommerce.com` y `ecommerce.com`), rutas quemadas, secretos enmascarados y guía XAMPP. |
| [03-arquitectura-observada.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/03-arquitectura-observada.md) | Diagramas de Contexto y Contenedores, límites entre módulos y doble estado `$_SESSION` vs `localStorage`. |
| [04-modulos.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/04-modulos.md) | Matriz completa de módulos y fichas técnicas de `GetModel`, `PaymentsController::payment` y `thanks.php`. |
| [05-flujos.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/05-flujos.md) | Trazabilidad E2E con diagramas de secuencia y auditoría financiera de checkout, pasarelas y `/thanks`. |
| [06-modelo-de-datos.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/06-modelo-de-datos.md) | Diagrama `erDiagram` de las 15 tablas, FKs físicas vs. implícitas y auditoría de deriva esquema-código (`DRIFT-01..05`). |
| [07-api-e-integraciones.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/07-api-e-integraciones.md) | Gramática completa de `api/`, diferencias con el PDF, auditoría de los 16 archivos `web/ajax/` e integraciones externas. |
| [08-reglas-y-estados.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/08-reglas-y-estados.md) | Máquinas de estados (`stateDiagram-v2`) de `carts` y `orders`, tabla de transiciones y reglas `BR-001..006`. |
| [09-seguridad.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/09-seguridad.md) | Matriz de control de acceso real y fichas de vulnerabilidades críticas `SEC-001` a `SEC-008`. |
| [10-pruebas.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/10-pruebas.md) | Estado de pruebas automatizadas (`[NO ENCONTRADO]`), matriz de cobertura estática y plan de pruebas. |
| [11-despliegue-y-operacion.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/11-despliegue-y-operacion.md) | Rastros de entornos, observabilidad, timeouts infinitos en cURL y modos de fallo operativo. |
| [12-hallazgos.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/12-hallazgos.md) | Catálogo priorizado de defectos funcionales, financieros, de runtime PHP 8 y deuda técnica (`FIND-001..015`). |
| [13-glosario-del-proyecto.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/13-glosario-del-proyecto.md) | Definiciones exactas de los términos y convenciones del código (`suffix`, `relations`, `token=no`, `process_order`). |
| [matriz-trazabilidad.md](file:///c:/xampp/htdocs/ecommerce/docs/analisis/matriz-trazabilidad.md) | Relación verificable `TR-001` a `TR-035` entre cada afirmación y su archivo/línea exacta. |

---

## 3. Hallazgos Prioritarios (Top Críticos Confirmados)

1. **`FIND-001` (`FIN-01`) — Inflación de ventas $N\times$ en carritos multi-ítem:** `PaymentsController::payment()` guarda `$totalCart` (la suma de todo el carrito) en la columna `price_cart` de cada fila individual del carrito (`payments.controller.php:L119,178,249`), y `thanks.php:L145` la copia a `orders.price_order`.
2. **`FIND-002` (`FIN-02`) — Órdenes de PayPal entregadas sin capturar el cobro:** `thanks.php:L29-36` solo verifica que la orden de PayPal esté en estado `APPROVED`, pero nunca ejecuta `POST v2/checkout/orders/{id}/capture`.
3. **`FIND-003` (`FIN-03`) — Fallo fatal `TypeError (string + int)` en PHP 8+ que provoca órdenes duplicadas:** En `thanks.php:L166` (`"sales_product=".$value->sales_product+$value->quantity_cart`) y `product.php:L45`, la falta de paréntesis lanza un `TypeError` en PHP 8. En `thanks.php`, esto aborta la ejecución después de crear la orden en `orders` y antes de eliminar el carrito en `carts`, duplicando el pedido en cada recarga.
4. **`FIND-004` (`DRIFT-01`) — Imposibilidad de comprar productos nuevos creados desde el Admin:** `ProductsController::productManage()` nunca asigna `id_seller_product`, por lo que al agregar un producto nuevo al carrito falla la FK `carts.id_seller_cart -> sellers.id_seller` o el `INNER JOIN sellers` oculta el carrito.
5. **`SEC-001` a `SEC-005` — Vulnerabilidades críticas de seguridad:**
   - **SQLi en cláusulas dinámicas** (`$table`, `$select`, `$orderBy`, `$orderMode`, `$startAt`, `$endAt`, `$search`, `$between1`, `$inTo`) en `GetModel` y `Connection::getColumnsData`.
   - **Subida arbitraria de archivos `.php` sin autenticación (RCE)** en `web/ajax/upload.ajax.php`.
   - **Borrado arbitrario de archivos/carpetas sin autenticación previa** en `web/ajax/delete-admin.ajax.php` y **volcado total de PII de clientes** en `web/ajax/report-clients.ajax.php`.
   - **IDOR y escalada de privilegios en `api/`** (`Connection::tokenValidate` no verifica propiedad del `id` ni rol/tabla, además del bypass `?token=no&except=...`).
   - **Bypass de rol `editor` en `/admin`** por omisión de `return;` tras `<script>window.location = ".../404"</script>`.

---

## 4. Verificación de Criterios de Finalización (Sección 16 de la Guía)

- [x] La carpeta y los archivos relevantes están inventariados (`01-inventario.md`).
- [x] El alcance, la versión analizada y las exclusiones (`recursos/AdminLTE-3.2.0`) están registrados (`01-inventario.md`).
- [x] Los runtimes, las dependencias y los puntos de entrada están identificados con evidencia (`01-inventario.md`, `02-ejecucion-local.md`).
- [x] La configuración para ejecución local y sus acoplamientos están documentados (`02-ejecucion-local.md`).
- [x] La arquitectura observada refleja componentes demostrables y señala los límites reales (`03-arquitectura-observada.md`).
- [x] Los módulos principales están descritos con rutas y responsabilidades reales (`04-modulos.md`).
- [x] Los flujos críticos se siguen hasta los datos, las respuestas y los efectos secundarios (`05-flujos.md`).
- [x] El modelo de datos se deriva del volcado `.sql` y las consultas reales, incluyendo la deriva esquema-código (`06-modelo-de-datos.md`).
- [x] Las APIs, puentes AJAX, integraciones y webhooks están inventariados (`07-api-e-integraciones.md`).
- [x] Las reglas y transiciones de estado se respaldan con código (`08-reglas-y-estados.md`).
- [x] Se revisaron autenticación, permisos, validaciones, secretos (enmascarados) y datos sensibles (`09-seguridad.md`).
- [x] El estado de pruebas se inventarió con precisión (`10-pruebas.md`).
- [x] El despliegue, la observabilidad y los modos de fallo están documentados (`11-despliegue-y-operacion.md`).
- [x] Los hallazgos expresan evidencia, impacto, confianza y criterio de resolución (`12-hallazgos.md`).
- [x] Las afirmaciones importantes aparecen en la matriz de trazabilidad (`matriz-trazabilidad.md`).
- [x] Las contradicciones (como PDF vs. código y SQL vs. controladores) están declaradas (`06`, `07`, `12`).
- [x] Otra persona puede repetir los pasos principales y comprobar cada hallazgo con archivo y línea exacta.


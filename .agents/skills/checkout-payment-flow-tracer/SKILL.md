---
name: checkout-payment-flow-tracer
description: >-
  Use this skill to trace end-to-end functional flows, audit financial and
  transactional integrity in checkout/payments, and reconstruct business rules
  and state machines following Sections 5, 6, and 9 of the guide.
---

# Checkout, Payment & E2E Flow Tracer Skill

Follow this runbook to execute Sections 5, 6, and 9 of the reverse engineering guide.

## 1. End-to-End Flows to Trace
Trace each flow from Browser JS / Form submission -> Web Controller / View / AJAX -> `CurlController` -> `api/` -> MySQL / External Provider:
1. **Catalog & Product Detail**: Category/subcategory filtering, pagination, product variants (`variants`), offer calculations, view counters.
2. **User Registration, Login & Social Auth**: Password hashing (`crypt`), JWT issuance, email verification, password recovery, session management (`$_SESSION["user"]`, `$_SESSION["admin"]`).
3. **Shopping Cart Management**: Adding items, selecting variants/quantities, updating quantities in cart view, deleting items.
4. **Checkout & Payment Initiation (`PaymentsController::payment`)**:
   - User profile update (`PUT /users`).
   - Cart retrieval (`GET /relations?rel=carts,variants,products,sellers...`) and total calculation (`$totalCart`).
   - Reference code generation (`$ref = TemplateController::genCodec(1000)`).
   - Seller notification email.
   - Gateway-specific order/preference creation (**PayPal**, **DLocal**, **MercadoPago**) and cart update (`PUT /carts` with `ref_cart`, `order_cart`, `method_cart`, `price_cart`).
5. **Payment Confirmation & Order Fulfillment (`thanks.php` vs. `webhooks/mercadopago.php`)**:
   - Browser redirect `GET /thanks?ref=...` verification against gateway API.
   - Order creation (`POST /orders`), stock decrement / sales increment (`PUT /products`, `PUT /variants`), and cart deletion (`DELETE /carts`).
   - Asynchronous webhook `web/webhooks/mercadopago.php` behavior and comparison with `thanks.php`.
6. **Admin Operations**: Admin login, CRUD of templates, categories, subcategories, products/variants, slides, banners, orders status updates, and sales/client reports.

## 2. Financial & Transactional Integrity Audit (Section 6.1)
Verify and document with exact line references:
- How `price_cart` and `price_order` are populated when a cart has multiple items (check if `$totalCart` overwrites per-item prices).
- Whether PayPal orders in `SHOW`/`APPROVED` state are actually captured (`POST /v2/checkout/orders/{id}/capture`) or only checked for `APPROVED`.
- Race conditions and idempotency between `thanks.php` and `webhooks/mercadopago.php`.
- Lack of atomic database transactions across sequential cURL requests.

## 3. Deliverables Produced by This Skill
- `docs/analisis/05-flujos.md`: End-to-end flow sheets with Mermaid `sequenceDiagram` (including error/alt paths) and before/after data mutations.
- `docs/analisis/08-reglas-y-estados.md`: Business rules (`BR-001`...) and Mermaid `stateDiagram-v2` state machines for Cart, Payment, Order, and User/Admin lifecycle.


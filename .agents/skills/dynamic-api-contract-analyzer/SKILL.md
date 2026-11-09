---
name: dynamic-api-contract-analyzer
description: >-
  Use this skill to reverse engineer generic table-driven REST APIs, compare
  code against API documentation PDFs, catalog cURL client calls, and audit
  AJAX bridge endpoints following Sections 5 and 8 of the guide.
---

# Dynamic API, cURL Client & AJAX Bridge Contract Analyzer Skill

Follow this runbook to execute Sections 5 and 8 of the reverse engineering guide for projects with a generic CRUD API (`api/`) and a consumer web app (`web/`).

## 1. Generic REST API Grammar (`api/`)
1. Trace `api/index.php` -> `api/controllers/routes.controller.php` -> `api/routes/routes.php`.
2. Analyze each HTTP method service in `api/routes/services/`:
   - `get.php` + `GetController` + `GetModel`: Document all query modes (unfiltered, filtered `linkTo`/`equalTo`, `relations` with `rel`/`type`, range `between1`/`between2` + `filterTo`/`inTo`, `search` + `linkTo`, ordering `orderBy`/`orderMode`, pagination `startAt`/`endAt`).
   - `post.php` + `PostController` + `PostModel`: Document standard record creation, user registration (`?register=true&suffix=...`), and user/admin login (`?login=true&suffix=...`) with JWT generation (`Connection::jwt`).
   - `put.php` + `PutController` + `PutModel`: Document dynamic `UPDATE` (`?id=...&nameId=...&token=...&table=...&suffix=...`).
   - `delete.php` + `DeleteController` + `DeleteModel`: Document dynamic `DELETE` (`?id=...&nameId=...&token=...&table=...&suffix=...`).
3. Contrast the actual code in `api/` against `api/Documentación-APIRESTFul.pdf` and record any discrepancies.

## 2. Web Consumer & External Integrations (`CurlController`)
1. Catalog every method in `web/controllers/curl.controller.php`:
   - `CurlController::request($url, $method, $fields)` (Internal API calls)
   - `CurlController::paypal($url, $method, $fields)` (PayPal OAuth2 + Orders v2 API)
   - `CurlController::dlocal($url, $method, $fields)` (DLocal Go API)
   - `CurlController::mercadoPago($url, $method, $fields)` (MercadoPago Preferences & Payments API)
2. Catalog other external integrations: PHPMailer (`TemplateController::sendEmail`), Google/Facebook OAuth (`socials` / `google.ajax.php`).

## 3. AJAX Bridge Endpoints (`web/ajax/*.ajax.php`) & Webhooks (`web/webhooks/*.php`)
1. Inspect all files in `web/ajax/` and `web/webhooks/`.
2. For each file, document: entry parameters (`$_POST`, `$_GET`, `$_FILES`), authentication/session checks, internal API calls made, and response format.

## 4. Deliverable Produced by This Skill
- `docs/analisis/07-api-e-integraciones.md`: Full API endpoint matrix, query parameter grammar, PDF vs. implementation comparison, AJAX endpoints table, external payment/email/OAuth integrations table, and webhook analysis.


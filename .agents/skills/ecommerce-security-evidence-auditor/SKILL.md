---
name: ecommerce-security-evidence-auditor
description: >-
  Use this skill to conduct an evidence-based security audit and technical debt
  assessment covering dynamic SQL injection, JWT/API authentication, IDOR,
  unprotected AJAX endpoints, and payment vulnerabilities (Sections 10 and 13).
---

# E-Commerce Security & Technical Findings Auditor Skill

Follow this runbook to execute Sections 10 and 13 of the reverse engineering guide. Never exploit production systems; base all findings on reproducible static code evidence.

## 1. Priority Security Audit Checklist
1. **SQL Injection in Dynamic Query Builders (`api/models/`)**:
   - Inspect `Connection::getColumnsData($table, $columns)` for unparameterized interpolation of `$table` in `information_schema.columns`.
   - Inspect `GetModel`, `PostModel`, `PutModel`, `DeleteModel` for direct string concatenation of `$select`, `$orderBy`, `$orderMode`, `$startAt`, `$endAt`, `$filterTo`, `$inTo`, `$nameId`.
2. **Authentication, API Key & JWT Controls**:
   - Inspect `api/routes/routes.php` for static `Authorization` header validation and how `in_array($table, Connection::publicAccess()) == 0` behaves.
   - Inspect `Connection::jwt` and `Connection::tokenValidate` for secret key strength, token expiration, and signature verification.
3. **Broken Object Level Authorization (IDOR) & Privilege Escalation**:
   - Check whether `PUT` and `DELETE` services verify that the provided `token` belongs to the record owner (`id`) or if *any* valid `users` token can modify/delete any row in any table (including `admins`, `orders`, `products`, or other `users`).
4. **AJAX Bridge Exposure (`web/ajax/*.ajax.php`)**:
   - Check each of the 16 `.ajax.php` files to see if they validate `$_SESSION["admin"]` or `$_SESSION["user"]` before forwarding privileged requests using the hardcoded API key in `CurlController::request()`.
5. **Payment, Webhook & Session Security**:
   - Check `web/webhooks/mercadopago.php` for webhook signature verification (`x-signature`).
   - Check `thanks.php` for unauthenticated state mutation via `GET ?ref=...`.
   - Check password hashing salt/algorithm (`crypt` with static salt), XSS in views, CSRF in forms, and hardcoded credentials in `CurlController`.

## 2. Deliverables Produced by This Skill
- `docs/analisis/09-seguridad.md`: Access control matrix, observed security controls, payment security evaluation, and detailed `SEC-001`..`SEC-NNN` security finding sheets.
- `docs/analisis/12-hallazgos.md`: Consolidated catalog of functional defects, financial bugs, technical risks, technical debt, and uncertainties (`FIND-001`..`FIND-NNN`).


---
name: ecommerce-recon-inventory
description: >-
  Use this skill to perform initial reconnaissance, technical inventory,
  environment coupling detection, and architectural mapping of an e-commerce
  project following Sections 1, 2, 3, and 4 of the reverse engineering guide.
---

# E-Commerce Reconnaissance, Inventory & Architecture Skill

Follow this runbook to execute Sections 1, 2, 3, and 4 of the reverse engineering guide without altering any project files.

## 1. Scope & Live vs. Inert Code Separation
1. Enumerate top-level directories and files at the workspace root.
2. Identify and exclude reference templates or third-party demos (e.g., `recursos/AdminLTE-3.2.0`, `vendor/`, `node_modules/`) from runtime component counts, documenting why they are excluded.
3. Classify every directory into:
   - Active Backend/API (`api/`)
   - Active Web/SSR/Admin (`web/`)
   - Database Dumps/Schemas (`*.sql`)
   - Reference Assets/Templates (`recursos/`)
   - Third-party dependencies (`api/vendor/`, `web/extensions/vendor/`)

## 2. Static Discovery Commands (PowerShell)
Run read-only static searches to locate entry points and hardcoded configurations:

```powershell
# Locate entry points, routers, and front controllers
Get-ChildItem -Path "api","web" -Recurse -Include *.php,.htaccess |
  Where-Object { $_.FullName -notmatch 'vendor' } |
  Select-String -Pattern 'RewriteRule|REQUEST_URI|REQUEST_METHOD|session_start|require_once'

# Locate hardcoded URLs, disk paths, and credentials (mask secrets in reports!)
Get-ChildItem -Path "api","web" -Recurse -Include *.php,*.js,*.json |
  Where-Object { $_.FullName -notmatch 'vendor' } |
  Select-String -Pattern 'http://|https://|[A-Za-z]:/|error_log|Authorization|apikey|clientId|secret'
```

## 3. Deliverables Produced by This Skill
- `docs/analisis/01-inventario.md`: Full directory table, confirmed tech stack by layer, composer dependencies (`firebase/php-jwt`, `phpmailer/phpmailer`, etc.), frontend JS libraries, and open questions (`Q-001`...).
- `docs/analisis/02-ejecucion-local.md`: Apache VirtualHosts required (`api.ecommerce.com`, web host), MySQL database setup (`ecommerce`), PHP extensions (`pdo_mysql`, `curl`, `gd`, `mbstring`), hardcoded paths that fail across machines (e.g., `D:/xampp/...`), and masked credential inventory.
- `docs/analisis/03-arquitectura-observada.md`: Context, Container, and Component Mermaid diagrams showing how Browser, `web/` (SSR + AJAX + Webhooks), `api/` (Generic REST CRUD over PDO), MySQL, and external providers (PayPal, DLocal, MercadoPago, Google/Facebook OAuth, SMTP) interact.
- `docs/analisis/04-modulos.md`: Module matrix and detailed component sheets for every controller, model, AJAX handler, and view module.

## 4. Verification Rules
- Every claim must carry a certainty tag (`[CONFIRMADO]`, `[INFERIDO]`, `[PENDIENTE]`, `[RIESGO]`).
- Never copy plaintext secrets or API keys in full; mask them (e.g., `SSDF...adg`, `AeIu...p96`).


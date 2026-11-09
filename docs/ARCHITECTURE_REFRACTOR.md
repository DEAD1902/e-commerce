# ARCHITECTURE_REFRACTOR.md – Resumen de la Refactorización a Slim 4

## Estado Actual
- **Framework:** Slim 4 (PSR‑15 middleware)
- **Inyección de Dependencias:** PHP‑DI (container defined in `src/bootstrap.php`).
- **ORM:** Eloquent (configurado en `bootstrap.php`).
- **Configuración:** Variables de entorno cargadas desde `.env` usando **vlucas/phpdotenv**.
- **Estructura de Carpetas:**
```
/ecommerce
├─ public/               # Front‑controller (`index.php`)
├─ src/                  # Código de aplicación
│   ├─ Controllers/      # Controladores Slim (ej. PayPalController, ProductController)
│   ├─ Services/         # Servicios de dominio (PayPalGateway, etc.)
│   ├─ Models/           # Entidades Eloquent (Product, Order, User)
│   ├─ bootstrap.php     # DI + Eloquent setup
│   └─ routes.php        # Registro de rutas
├─ tests/                # PHPUnit tests (generados por Testing Engineer)
├─ .env.example          # Plantilla de variables de entorno
└─ composer.json         # Dependencias: slim/slim, php‑di/php‑di, illuminate/database, vlucas/phpdotenv, firebase/php‑jwt, guzzlehttp/guzzle
```

## Principales Cambios
1. **Eliminado código procedural** bajo `web/` y `api/`.
2. **Todos los endpoints** ahora se definen en `src/routes.php` y son gestionados por Slim.
3. **Acceso a la base de datos** mediante modelos Eloquent (`App\Models\*`).
4. **Configuración sensible** (credenciales PayPal, JWT secret, DB creds) se trasladó a `.env` y se excluye del repositorio.
5. **Middleware de seguridad**:
   - `AuthMiddleware` verifica JWT con clave fuerte.
   - `CsrfMiddleware` valida tokens CSRF en POST/PUT/DELETE.
6. **Servicio de pagos** encapsulado en `App\Service\PayPalGateway` usando Guzzle y siguiendo el flujo de *order → capture*.
7. **Log centralizado** con Monolog (canal `app` y `payment`).

## Próximos Pasos
- Finalizar la migración de lógica de negocio de los controladores antiguos a los nuevos (ej. `ProductController`).
- Añadir pruebas unitarias e integración (ver `TESTING_REPORT.md`).
- Implementar CI/CD (ver `CI_CD_SETUP.md`).

---

*Documento actualizado el 2026‑11‑05.*
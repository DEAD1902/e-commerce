# DOCUMENTACION-TECNICA.md – Guía Técnica del Proyecto E‑Commerce Refactorizado

## 1. Introducción
Este documento reúne la información técnica necesaria para **desarrollar, probar, desplegar y mantener** el proyecto e‑commerce tras la refactorización a **Slim 4**, **PHP‑DI**, **Eloquent ORM** y la integración única con **PayPal**.

## 2. Prerrequisitos
- **XAMPP** (Apache + MySQL) o cualquier stack LAMP/LNMP compatible con PHP 8.2.
- **Composer** (gestor de dependencias PHP).
- **Git** (para control de versiones).
- **Cuenta PayPal Developer** con `PAYPAL_CLIENT_ID` y `PAYPAL_CLIENT_SECRET`.
- **Node.js/NPM** (opcional) para compilar assets front‑end.

## 3. Instalación
```powershell
# Clonar el repositorio
git clone <repo‑url>
cd ecommerce

# Instalar dependencias PHP
composer install --no-interaction --prefer-dist

# Crear archivo de entorno
copy .env.example .env
# Editar .env con credenciales de base de datos, JWT secret y PayPal
notepad .env

# Generar clave JWT aleatoria (opcional)
php -r "echo bin2hex(random_bytes(32));"
```
> **Nota:** `.env` está incluido en `.gitignore` y nunca debe ser versionado.

## 4. Estructura del proyecto
```
/ecommerce
├─ public/                 # Front‑controller (index.php) – punto de entrada HTTP
├─ src/                    # Código fuente
│   ├─ Controllers/        # Controladores Slim (PayPalController, ProductController…)
│   ├─ Services/           # Servicios de dominio (PayPalGateway, EmailService…)
│   ├─ Models/             # Entidades Eloquent (User, Product, Order, Cart)
│   ├─ Middleware/         # AuthMiddleware, CsrfMiddleware, ErrorMiddleware
│   ├─ Logger.php          # Configuración de Monolog
│   ├─ bootstrap.php       # Configura DI, Eloquent y carga .env
│   └─ routes.php          # Registro de rutas y grupos
├─ tests/                  # Tests PHPUnit (controladores, servicios, middleware)
├─ .env.example            # Plantilla de variables de entorno
├─ composer.json           # Dependencias del proyecto
└─ README.md               # Instrucciones básicas (ver sección 6)
```

## 5. Ejecutar la aplicación en local
```powershell
php -S localhost:8080 -t public
```
- Visitar `http://localhost:8080/health` → debe devolver `{"status":"ok"}`.
- Los endpoints de la API se encuentran bajo `/api/...` (p.ej. `POST /api/payments/paypal/create`).

## 6. Testing
```powershell
# Ejecutar toda la suite de pruebas con cobertura
vendor/bin/phpunit --coverage-text
```
- La suite contiene **tests unitarios y de integración** para el controlador y el servicio PayPal (ver `docs/TESTING_REPORT.md`).
- Cobertura mínima requerida: **80 %**.

## 7. CI/CD
El flujo de integración continua está definido en **`.github/workflows/php.yml`** (creado por el sub‑agente CI/CD Builder). Cada push a `main` ejecuta:
1. Instalación de dependencias Composer.
2. Análisis estático con **PHPStan** (nivel máximo).
3. Ejecución de pruebas PHPUnit con cobertura.
4. Los resultados se publican como artefactos y se pueden visualizar en la pestaña *Checks* de GitHub.

## 8. Despliegue a producción
1. **Compilar assets** (si existen) y copiar la carpeta `public/` al servidor web.
2. **Crear base de datos** y ejecutar migraciones (Eloquent `php artisan migrate` o scripts SQL incluidos).
3. **Configurar variables de entorno** en el servidor (PHP `$_ENV`).
4. **Asegurar HTTPS** y habilitar encabezados de seguridad (HSTS, CSP, X‑Content‑Type‑Options).

## 9. Seguridad
- Todas las credenciales están en `.env` y nunca en el código.
- JWT firmado con clave aleatoria (`JWT_SECRET`).
- CSRF protegido mediante middleware.
- Consultas SQL totalmente parametrizadas mediante Eloquent.
- Subida de archivos restringida a admins y validada por MIME.
- Consulte `docs/SECURITY_REPORT.md` para la lista completa de vulnerabilidades y su remediación.

---

*Documento actualizado el 2026‑11‑05 después de la refactorización completa.*
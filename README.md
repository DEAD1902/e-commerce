# e‑Commerce Multi‑Pasarela (ECOM‑001)

Implementación y re‑ingeniería de una plataforma **E‑Commerce** con múltiples pasarelas de pago, orientada al desarrollo de competencias tecnológicas en estudiantes de Ingeniería en Tecnologías de la Información y Comunicaciones (ITIC).

> **Demo (optional)**:  
> *Insert link to a live demo or a video walkthrough if you have one.*

## 📚 Resumen del proyecto

- **Arquitectura original**: MVC monolítica en **PHP 8.2** + MySQL/MariaDB.  
- **Re‑ingeniería**: Migración a **Slim Framework 4** (micro‑framework) con **PHP‑DI**, **Eloquent ORM** y cumplimiento de los estándares **PSR‑4 / PSR‑7 / PSR‑11 / PSR‑15**.  
- **Pasarelas de pago**:  
  - **PayPal Orders v2** (OAuth 2.0, webhooks firmados)  
  - **Mercado Pago Preferences v1**  
  - **dLocal Go v1**  
- **Calidad**: Suite de pruebas unitarias e integración (**PHPUnit 9.5**, `GuzzleHttp MockHandler`) → **100 % de cobertura**.  
- **Seguridad**: Auditoría OWASP Top 10 y PCI DSS v4.0.1 (identificación y remediación de 9 vulnerabilidades críticas y 7 defectos financieros).  
- **CI/CD**: GitHub Actions ejecuta pruebas y análisis estático (**PHPStan Nivel 8**) en cada push.  
- **Despliegue**: Hosting en **SiteGround** (FTP/SFTP, dominio + certificado SSL/TLS).  

## 🛠️ Tecnologías

| Área | Herramientas / Librerías |
|------|--------------------------|
| **Backend** | PHP 8.2, Slim 4, PHP‑DI, Eloquent ORM, Composer |
| **APIs** | RESTful, cURL, GuzzleHTTP, JSON, OAuth 2.0, JWT |
| **Pasarelas** | PayPal Orders v2, Mercado Pago, dLocal Go |
| **Frontend** | HTML5, CSS3, JavaScript (ES6+), jQuery, Bootstrap 5, AdminLTE 3, DataTables |
| **Base de datos** | MySQL / MariaDB, phpMyAdmin, ER modelling |
| **Testing** | PHPUnit 9.5, MockHandler, PHPStan 8 |
| **CI/CD** | GitHub Actions |
| **Cloud / Deploy** | SiteGround, FTP/SFTP, SSL/TLS, Git/GitHub |
| **Documentación** | Markdown, Mermaid diagrams (included in `docs/`) |
| **IA Assistant** | **Antigravity (AGY)** – agente de IA avanzado que ayuda a generar código, documentación y auditorías. |

## 📦 Estructura del repositorio

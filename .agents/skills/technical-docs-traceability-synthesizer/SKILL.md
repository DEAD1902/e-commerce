---
name: technical-docs-traceability-synthesizer
description: >-
  Use this skill to compile the final reverse engineering deliverables
  (docs/analisis/00..13), build the traceability matrix, verify Mermaid
  diagrams, and audit completion criteria (Sections 11, 12, 14, 15, and 16).
---

# Technical Documentation & Traceability Synthesizer Skill

Follow this runbook to execute Sections 11, 12, 14, 15, and 16 of the reverse engineering guide and assemble the complete documentation suite in `docs/analisis/`.

## 1. Deliverable Suite (`docs/analisis/`)
Ensure all 15 files exist, are cross-linked, and use consistent certainty tags (`[CONFIRMADO]`, `[INFERIDO]`, `[PENDIENTE]`, `[NO VERIFICABLE]`, `[NO ENCONTRADO]`, `[NO APLICA]`, `[RIESGO]`, `[RECOMENDACIÓN]`):
1. `00-resumen-tecnico.md`
2. `01-inventario.md`
3. `02-ejecucion-local.md`
4. `03-arquitectura-observada.md`
5. `04-modulos.md`
6. `05-flujos.md`
7. `06-modelo-de-datos.md`
8. `07-api-e-integraciones.md`
9. `08-reglas-y-estados.md`
10. `09-seguridad.md`
11. `10-pruebas.md`
12. `11-despliegue-y-operacion.md`
13. `12-hallazgos.md`
14. `13-glosario-del-proyecto.md`
15. `matriz-trazabilidad.md`

## 2. Quality & Traceability Verification
1. Every major architectural, functional, data, or security claim in `00`–`12` must map to an entry `TR-001`..`TR-NNN` in `matriz-trazabilidad.md` with exact relative file paths and symbol names.
2. All Mermaid diagrams must use valid syntax (`flowchart TD/LR`, `sequenceDiagram`, `erDiagram`, `stateDiagram-v2`) with quoted node labels when special characters appear.
3. Run the 17-point completion checklist from Section 16 of the guide in `00-resumen-tecnico.md`.


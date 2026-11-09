---
name: sql-schema-drift-auditor
description: >-
  Use this skill to reconstruct the Entity-Relationship data model from SQL
  dumps (.sql), analyze suffix-based relational conventions, and detect
  schema-code drift following Section 7 of the reverse engineering guide.
---

# SQL Schema, Implicit Relations & Drift Auditor Skill

Follow this runbook to execute Section 7 of the reverse engineering guide for projects using raw SQL dumps (`.sql`) and dynamic relational queries.

## 1. SQL Dump Extraction (`*.sql`)
1. Parse all `CREATE TABLE`, `ALTER TABLE`, and index definitions in the `.sql` dump (`ecommerce (1).sql`).
2. Record for each table:
   - Exact table name and column suffix convention (e.g., `users` -> `_user`, `products` -> `_product`, `variants` -> `_variant`, `carts` -> `_cart`, `orders` -> `_order`).
   - Primary keys, column data types, nullability, default values, and `AUTO_INCREMENT`.
   - Whether physical `FOREIGN KEY` constraints exist in InnoDB or if relationships are enforced solely in application code.

## 2. Dynamic Suffix & Join Convention Analysis
1. Inspect `api/models/connection.php` (`getColumnsData`) and `api/models/get.model.php` (`getRelData`, `getRelDataFilter`, etc.).
2. Document how `relations?rel=t1,t2,t3&type=s1,s2,s3` constructs `INNER JOIN` clauses using naming conventions (`ON t1.id_{s2}_{s1} = t2.id_{s2}`).
3. Map every implicit foreign key column across all tables (e.g., `id_category_product`, `id_subcategory_product`, `id_product_variant`, `id_user_cart`, `id_product_cart`, `id_variant_cart`, `id_order` relations).

## 3. Schema-Code Drift Audit
1. Extract all table and column names referenced in `web/controllers/`, `web/ajax/`, `web/views/`, and `web/webhooks/`.
2. Cross-reference them against the `.sql` dump to detect:
   - Columns read or written in PHP that do not exist in the SQL dump (or have different types/names).
   - Columns present in the SQL dump that are never written or read by the application.
   - Data integrity risks caused by missing DB constraints or denormalized snapshots.

## 4. Deliverable Produced by This Skill
- `docs/analisis/06-modelo-de-datos.md`: Complete Mermaid `erDiagram`, detailed entity sheets for all tables, field-by-field tables, implicit join rules, sensitive fields inventory, and Schema-Code Drift table.


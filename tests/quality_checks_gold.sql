/*
===============================================================================
Quality Checks – Gold Layer (PostgreSQL Version)
===============================================================================
Script Purpose:
    Performs data quality checks to validate integrity, consistency,
    and analytical reliability of the Gold Layer.

Validation Scope:
    - Surrogate key uniqueness in dimension tables
    - Referential integrity between fact and dimension tables
    - Data model relationship validation

Usage:
    Run after Gold layer load is completed.

Expectation:
    All queries must return ZERO rows.
===============================================================================
*/


-- =============================================================================
-- Checking: gold.dim_customers
-- =============================================================================

-- 1. Check Uniqueness of Customer Key
-- Expectation: No results
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;



-- =============================================================================
-- Checking: gold.dim_products
-- =============================================================================

-- 1. Check Uniqueness of Product Key
-- Expectation: No results
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;



-- =============================================================================
-- Checking: gold.fact_sales
-- =============================================================================

-- 1. Referential Integrity Check (Fact → Dimensions)
-- Expectation: No results

SELECT 
    f.*
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL;



/*
===============================================================================
END OF GOLD LAYER QUALITY CHECKS
===============================================================================
If any rows are returned:
    - Duplicate surrogate keys must be investigated immediately.
    - Missing dimension references indicate broken ETL logic.
    - Do NOT expose Gold layer to BI tools before resolving issues.
===============================================================================
*/

/*
===============================================================================
Quality Checks – Silver Layer (PostgreSQL Version)
===============================================================================
Script Purpose:
    Performs data quality checks for consistency, accuracy,
    and standardization across the Silver layer.

Usage:
    Run this script AFTER loading Silver tables.

Expectation:
    All queries should return ZERO rows unless an issue exists.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================

-- 1. Check for NULLs or Duplicates in Primary Key
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 2. Unwanted Spaces in cst_key
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key <> TRIM(cst_key);

-- 3. Data Standardization
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;


-- =============================================================================
-- Checking: silver.crm_prd_info
-- =============================================================================

-- 1. NULLs or Duplicates in Primary Key
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 2. Unwanted Spaces
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- 3. NULL or Negative Cost
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 4. Data Standardization
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- 5. Invalid Date Order (End < Start)
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- =============================================================================
-- Checking: silver.crm_sales_details
-- =============================================================================

-- 1. Invalid Raw Dates (Assumed YYYYMMDD numeric format)
SELECT 
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LENGTH(sls_due_dt::text) <> 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- 2. Invalid Date Order
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- 3. Sales Calculation Consistency
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- =============================================================================
-- Checking: silver.erp_cust_az12
-- =============================================================================

-- 1. Out-of-Range Birthdates
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < DATE '1924-01-01'
   OR bdate > CURRENT_DATE;

-- 2. Data Standardization
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- =============================================================================
-- Checking: silver.erp_loc_a101
-- =============================================================================

-- Data Standardization & Consistency
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- =============================================================================
-- Checking: silver.erp_px_cat_g1v2
-- =============================================================================
-- 1. Unwanted Spaces
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat <> TRIM(cat)
   OR subcat <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);

-- 2. Data Standardization
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;

/*
===============================================================================
END OF QUALITY CHECKS
===============================================================================
All queries above should return zero rows.
If any rows are returned, investigate data issues before promoting to Gold.
===============================================================================
*/

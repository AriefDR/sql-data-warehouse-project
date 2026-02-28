/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze_data();
===============================================================================
*/

-- FULL LOAD (TRUNCATE & INSERT)
CREATE OR REPLACE PROCEDURE bronze.load_bronze_data()
LANGUAGE plpgsql
AS $$
DECLARE
    v_message TEXT;
    v_context TEXT;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
BEGIN
    batch_start_time = clock_timestamp();
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'Loading Bronze Layer Data...';
    RAISE NOTICE '=================================================';
    RAISE NOTICE '-------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables...';
    RAISE NOTICE '-------------------------------------------------';

    start_time = clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;
    RAISE NOTICE '>> Inserting Table: bronze.crm_cust_info';
    COPY bronze.crm_cust_info
    FROM '/Users/brxle0/Developments/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    DELIMITER ','
    CSV HEADER;
    end_time = clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '-------------------------------------------------';


    start_time = clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;
    RAISE NOTICE '>> Inserting Table: bronze.crm_prd_info';
    COPY bronze.crm_prd_info
    FROM '/Users/brxle0/Developments/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    DELIMITER ','
    CSV HEADER;
    end_time = clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '-------------------------------------------------';

    start_time = clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;
    RAISE NOTICE '>> Inserting Table: bronze.crm_sales_details';
    COPY bronze.crm_sales_details
    FROM '/Users/brxle0/Developments/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    DELIMITER ','
    CSV HEADER;
    end_time = clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '-------------------------------------------------';

    RAISE NOTICE '-------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables...';
    RAISE NOTICE '-------------------------------------------------';

    start_time = clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;
    RAISE NOTICE '>> Inserting Table: bronze.erp_cust_az12';
    COPY bronze.erp_cust_az12
    FROM '/Users/brxle0/Developments/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
    DELIMITER ','
    CSV HEADER;
    end_time = clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '-------------------------------------------------';

   start_time = clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;
    RAISE NOTICE '>> Inserting Table: bronze.erp_loc_a101';
    COPY bronze.erp_loc_a101
    FROM '/Users/brxle0/Developments/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
    DELIMITER ','
    CSV HEADER;
    end_time = clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '-------------------------------------------------';

   start_time = clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    RAISE NOTICE '>> Inserting Table: bronze.erp_px_cat_g1v2';
    COPY bronze.erp_px_cat_g1v2
    FROM '/Users/brxle0/Developments/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
    DELIMITER ','
    CSV HEADER;
    end_time = clock_timestamp();
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '-------------------------------------------------';

    batch_end_time = clock_timestamp();
    RAISE NOTICE '-------------------------------------------------';
    RAISE NOTICE 'Loading Bronze Layer Completed!';
    RAISE NOTICE '  - Total Load Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '-------------------------------------------------';

EXCEPTION
    WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS
        	v_message = MESSAGE_TEXT,
            v_context = PG_EXCEPTION_CONTEXT;
			
        RAISE NOTICE 'An error occurred';
        RAISE NOTICE 'Error message: %', v_message;
        RAISE NOTICE 'SQLSTATE: %', v_context;
        RAISE NOTICE '-------------------------------------------------';
        RAISE NOTICE 'ERROR OCCURED DURING LOADING BRONZE LAYER !';
        RAISE NOTICE 'Error Message: %', v_message;
        RAISE NOTICE 'Error Context: %', v_context;
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
        RAISE NOTICE '-------------------------------------------------';
END;
$$;

-- Call the procedure to load data into bronze layer
CALL bronze.load_bronze_data();

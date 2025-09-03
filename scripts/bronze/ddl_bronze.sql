CREATE DATABASE DataWarehouse;
--CREATING DATABASE


--USING THE DATABASE FOR UPCOMING TASK
USE DataWarehouse;
Go

--CREATING 3 DIFFERENT SCHEMA FOR THE 3 DIFFERENT LAYERS.
CREATE SCHEMA bronze;
GO -- This is just a separator, like finish upper command then go to the next.
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

-- CREATING TABLE SAME AS SOURCE TABLES.

IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	 cst_id INT, 
	 cst_key NVARCHAR(50),
	 cst_firstname NVARCHAR(50),
	 cst_lastname NVARCHAR(50), 
	 cst_marital_status NVARCHAR(50), 
	 cst_gndr NVARCHAR(50),
	 cst_create_date DATE
);


IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	 prod_id INT, 
	 prd_key NVARCHAR(50),
	 prd_nm NVARCHAR(50),
	 prd_cost INT, 
	 prd_line NVARCHAR(50), 
	 prd_start_dt DATETIME,
	 prd_end_dt DATETIME
);


IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (

	 sls_ord_num NVARCHAR(50),
	 sls_prd_key NVARCHAR(50),
	 sls_cust_id INT,
	 sls_order_dt INT,
	 sls_ship_dt INT,
	 sls_due_dt INT,
	 sls_sales INT,
	 sls_quantity INT,
	 sls_price INT
);

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate Date, -- date should be in acceptable format : YYYY-MM-DD
	gen NVARCHAR(50)
);



IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);




IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50), 
	maintenance NVARCHAR(50)
);



-- Full Load of data - Truncate + Insert

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '===================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '===================================================================';
		PRINT '-------------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------------------------------------------';
		
		--  cust_info   --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info 
		FROM 'D:\Umang\Data Warehousing\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> DURATION: '+ CAST(DATEDIFF(second, @start_time,@end_time) AS VARCHAR) + ' Seconds';
		PRINT '-------------------------';


		-- Quality check and check if the data is on correct column or not. It may occure if the separator is wrong or table schema is wrong.
		-- SELECT * FROM bronze.crm_cust_info ;



		--  prd_info   --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting Data Into: bronze.crm_prd_info';

		BULK INSERT bronze.crm_prd_info 
		FROM 'D:\Umang\Data Warehousing\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> DURATION: '+ CAST(DATEDIFF(second, @start_time,@end_time) AS VARCHAR) + ' Seconds';
		PRINT '-------------------------';



		--  sales_details   --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';

		BULK INSERT bronze.crm_sales_details 
		FROM 'D:\Umang\Data Warehousing\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> DURATION: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' Seconds';
		PRINT '-------------------------';

		PRINT '-------------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-------------------------------------------------------------------';
		--  cust_az12   --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';

		BULK INSERT bronze.erp_cust_az12 
		FROM 'D:\Umang\Data Warehousing\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> DURATION: '+ CAST(DATEDIFF(second, @start_time,@end_time) AS VARCHAR) + ' Seconds';
		PRINT '-------------------------';


		--   loc_a101  --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

		BULK INSERT bronze.erp_loc_a101 
		FROM 'D:\Umang\Data Warehousing\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> DURATION: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + ' Seconds';
		PRINT '-------------------------';


		--  px_cat_g1v2  --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

		BULK INSERT bronze.erp_px_cat_g1v2 
		FROM 'D:\Umang\Data Warehousing\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> DURATION: '+ CAST(DATEDIFF(second, @start_time,@end_time) AS VARCHAR) + ' Seconds';

	END TRY
	BEGIN CATCH 
		PRINT '====================================================';
		PRINT 'ERROR OCCURED DURING BRONZE LAYER';
		PRINT 'Error Message: '+ ERROR_MESSAGE();
		PRINT 'Error Message: '+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: '+ CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '====================================================';

	END CATCH
END;

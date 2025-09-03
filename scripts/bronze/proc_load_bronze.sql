/* 
  STORED PROCEDURE : Load data into bronze schema from csv files.
  USAGE EXAMPLE : 
      EXEC bronze.load_bronze;
*/
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

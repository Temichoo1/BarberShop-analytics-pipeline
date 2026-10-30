Use barbershopAnalytics
GO

TRUNCATE TABLE staging.bookings;

INSERT INTO
	staging.bookings(
	   [booking_id]
      ,[customer_id]
      ,[barber_code]
      ,[service_code]
      ,[service_short_code]
      ,[branch_code]
      ,[branch_city_code]
      ,[branch_suburb_code]
      ,[booking_datetime]
      ,[booking_date]
      ,[booking_year]
      ,[booking_month]
      ,[booking_month_name]
      ,[booking_day_name]
      ,[booking_hour]
      ,[time_of_day_bucket]
      ,[is_weekend]
      ,[booking_status]
      ,[is_completed]
      ,[is_cancelled]
      ,[is_no_show]
      ,[gross_amount]
      ,[discount_amount]
      ,[tip_amount]
      ,[net_amount]
      ,[has_discount]
      ,[has_tip]
      ,[source_file_name]
      ,[loaded_at]
	
	)

    select 
         NULLIF(trim(booking_id), '')
        ,COALESCE(NULLIF(UPPER(trim(customer_id)), ''), 'UNKNOWN')
        ,COALESCE(NULLIF(UPPER(trim(barber_code)), ''), 'UNKNOWN')
        ,CASE
            WHEN service_code is null or trim(service_code) = ''
            THEN 'UNKNOWN'
            WHEN UPPER(TRIM(service_code)) = 'SVC-UNKNOWN' 
            THEN 'UNKNOWN'
            ELSE
            UPPER(service_code)
        END
         ,CASE
            WHEN service_code is null or trim(service_code) = ''
            THEN 'UNKNOWN'
            WHEN UPPER(TRIM(service_code)) = 'SVC-UNKNOWN' 
            THEN 'UNKNOWN'
            ELSE
            REPLACE(UPPER(TRIM(service_code)), 'SVC-','')
        END
        ,COALESCE(NULLIF(UPPER(TRIM(branch_code)), ''), 'UNKNOWN')
        ,CASE
            WHEN branch_code is null or trim(branch_code) = ''
            THEN 'UNKNOWN'
         ELSE SUBSTRING(UPPER(TRIM(branch_code)),4, 3)
            END
        ,CASE
            WHEN branch_code is null or trim(branch_code) = ''
            Then 'UNKNOWN'
         else RIGHT(UPPER(TRIM(branch_code)),3)
         END
         ,TRY_CONVERT(datetime2, booking_datetime)
         ,CAST(TRY_CONVERT(DATETIME2, booking_datetime) as DATE)
         ,DATEPART(YEAR,TRY_CONVERT(DATETIME2, booking_datetime))
         ,DATEPART(MONTH,TRY_CONVERT(DATETIME2, booking_datetime))
         ,DATENAME(MONTH,TRY_CONVERT(DATETIME2, booking_datetime))
         ,DATENAME(WEEKDAY,TRY_CONVERT(DATETIME2, booking_datetime))
         ,DATEPART(HH,TRY_CONVERT(DATETIME2, booking_datetime))
         ,CASE
            WHEN DATEPART(HH,TRY_CONVERT(DATETIME2, booking_datetime)) BETWEEN 0 and 11 
            THEN 'Morning'
            WHEN DATEPART(HH,TRY_CONVERT(DATETIME2, booking_datetime)) BETWEEN 12 and 16 
            THEN 'Afternoon'
            WHEN DATEPART(HH,TRY_CONVERT(DATETIME2, booking_datetime)) BETWEEN 17 and 23 
            THEN 'Evening'
            ELSE 'Other'
          END
          ,CASE 
            WHEN DATENAME(WEEKDAY,TRY_CONVERT(DATETIME2, booking_datetime)) in ('Saturday', 'Sunday')
            THEN 1
            ELSE 0
            END
          ,COALESCE(NULLIF(trim(booking_status), ''), 'UNKNOWN')
          ,CASE
            WHEN booking_status = 'Completed' 
            THEN 1
            ELSE 0
            END
           ,CASE
            WHEN booking_status = 'Cancelled' 
            THEN 1
            ELSE 0
            END
            ,CASE
            WHEN booking_status = 'No Show' 
            THEN 1
            ELSE 0
            END
           ,TRY_CONVERT(decimal(10,2), booking_amount)
           ,TRY_CONVERT(decimal(10,2), discount_amount)
           ,TRY_CONVERT(decimal(10,2), tip_amount)
           ,ISNULL(TRY_CONVERT(decimal(10,2), booking_amount), 0) 
                - ISNULL(TRY_CONVERT(decimal(10,2), discount_amount), 0) 
                + ISNULL(TRY_CONVERT(decimal(10,2), tip_amount), 0)
           ,CASE
              WHEN ISNULL(TRY_CONVERT(DECIMAL(10,2), discount_amount), 0) > 0
              THEN 1
              ELSE 0
              END
           ,CASE
              WHEN ISNULL(TRY_CONVERT(DECIMAL(10,2), tip_amount), 0) > 0
              THEN 1
              ELSE 0
              END
            ,source_file_name
            ,loaded_at

    from
    bronze.bookings_raw
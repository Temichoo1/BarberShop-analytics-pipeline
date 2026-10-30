/**** LOAd dimension tables  **/

USE BarbershopAnalytics;
GO

/******
         /*****   trick to get columns in theor order   *****/
            SELECT
                COLUMN_NAME
            FROM
                INFORMATION_SCHEMA.COLUMNS
            WHERE
                TABLE_SCHEMA = 'dm'
            AND 
                TABLE_NAME = 'dim_customer'
            ORDER BY
                ORDINAL_POSITION

******/





TRUNCATE TABLE dw.dim_customer;

INSERT INTO dw.dim_customer (
    customer_id, full_name, gender_group, city, province,
    region, signup_date, signup_year
)
SELECT DISTINCT
    customer_id, full_name, gender_group, city, province,
    region, signup_date, signup_year
FROM staging.customers
WHERE customer_id <> 'UNKNOWN';

SET IDENTITY_INSERT dw.dim_customer ON;

INSERT INTO dw.dim_customer (
    customer_key, customer_id, full_name, gender_group, city,
    province, region, signup_date, signup_year
)
VALUES (
    -1, 'UNKNOWN', 'Unknown Customer', 'Unknown',
    'Unknown', 'Unknown', 'Unknown', NULL, NULL
);

SET IDENTITY_INSERT dw.dim_customer OFF;
GO


TRUNCATE TABLE dw.dim_barber;

INSERT INTO dw.dim_barber (
    barber_code, barber_name, branch_code, branch_city_code,
    experience_level, experience_group, hire_date, years_employed
)
SELECT DISTINCT
    barber_code, barber_name, branch_code, branch_city_code,
    experience_level, experience_group, hire_date, years_employed
FROM staging.barbers
WHERE barber_code <> 'UNKNOWN';

SET IDENTITY_INSERT dw.dim_barber ON;

INSERT INTO dw.dim_barber (
    barber_key, barber_code, barber_name, branch_code, branch_city_code,
    experience_level, experience_group, hire_date, years_employed
)
VALUES (
    -1, 'UNKNOWN', 'Unknown Barber', 'UNKNOWN', 'UNKNOWN',
    'Unknown', 'Unknown', NULL, NULL
);

SET IDENTITY_INSERT dw.dim_barber OFF;
GO


TRUNCATE TABLE dw.dim_branch;

INSERT INTO dw.dim_branch (
    branch_code, branch_name, branch_city_code, branch_suburb_code,
    province, city, suburb, region
)
SELECT DISTINCT
    branch_code, branch_name, branch_city_code, branch_suburb_code,
    province, city, suburb, region
FROM staging.branches
WHERE branch_code <> 'UNKNOWN';

SET IDENTITY_INSERT dw.dim_branch ON;

INSERT INTO dw.dim_branch (
    branch_key, branch_code, branch_name, branch_city_code,
    branch_suburb_code, province, city, suburb, region
)
VALUES (
    -1, 'UNKNOWN', 'Unknown Branch', 'UNKNOWN',
    'UNKNOWN', 'Unknown', 'Unknown', 'Unknown', 'Unknown'
);

SET IDENTITY_INSERT dw.dim_branch OFF;
GO


TRUNCATE TABLE dw.dim_service;

INSERT INTO dw.dim_service (
    service_code, service_short_code, service_name, category,
    service_group, standard_price, duration_minutes,
    duration_bucket, price_bucket
)
SELECT DISTINCT
    service_code, service_short_code, service_name, category,
    service_group, standard_price, duration_minutes,
    duration_bucket, price_bucket
FROM staging.services
WHERE service_code <> 'UNKNOWN';

SET IDENTITY_INSERT dw.dim_service ON;

INSERT INTO dw.dim_service (
    service_key, service_code, service_short_code, service_name,
    category, service_group, standard_price, duration_minutes,
    duration_bucket, price_bucket
)
VALUES (
    -1, 'UNKNOWN', 'UNKNOWN', 'Unknown Service',
    'Unknown', 'Unknown', NULL, NULL, 'Unknown', 'Unknown'
);

SET IDENTITY_INSERT dw.dim_service OFF;
GO


TRUNCATE TABLE dw.dim_date;

INSERT INTO dw.dim_date (
    date_key, full_date, year, month_number, month_name,
    day_number, day_name, week_number, is_weekend
)
SELECT DISTINCT
    CONVERT(INT, FORMAT(booking_date, 'yyyyMMdd')) AS date_key,
    booking_date AS full_date,
    DATEPART(YEAR, booking_date) AS year,
    DATEPART(MONTH, booking_date) AS month_number,
    DATENAME(MONTH, booking_date) AS month_name,
    DATEPART(DAY, booking_date) AS day_number,
    DATENAME(WEEKDAY, booking_date) AS day_name,
    DATEPART(WEEK, booking_date) AS week_number,
    is_weekend
FROM staging.bookings
WHERE booking_date IS NOT NULL;

INSERT INTO dw.dim_date (
    date_key, full_date, year, month_number, month_name,
    day_number, day_name, week_number, is_weekend
)
VALUES (
    -1, '1900-01-01', 1900, 0, 'Unknown',
    0, 'Unknown', 0, 0
);
GO
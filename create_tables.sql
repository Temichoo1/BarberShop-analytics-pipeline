--Create database BarbershopAnalytics

Use BarbershopAnalytics
Go

/****CREATE SCHEMAS**/

IF NOT Exists (select * from sys.schemas where [name] = 'bronze')
BEGIN
	exec('Create schema bronze')
END

IF NOT Exists (select * from sys.schemas where [name] = 'staging')
BEGIN
	exec('Create schema staging')
END

IF NOT Exists (select * from sys.schemas where [name] = 'dw')
BEGIN
	exec('Create schema dw')
END


/*** CREATE TABLES  ***/
If object_id('bronze.customers_raw', 'U') IS NOT NULL
	drop table bronze.customer_raw

CREATE TABLE bronze.customers_raw (
	customer_id varchar(50),
	first_name varchar(200),
	last_name varchar(100),
	phone_number varchar(50),
	email varchar(200),
	gender varchar (50),
	city varchar(100),
	province varchar(50),
	signup_date date,
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO

If object_id('bronze.barbers_raw', 'U') IS NOT NULL
	drop table bronze.barbers_raw

CREATE TABLE bronze.barbers_raw (
    barber_code varchar(50),
	barber_name varchar(50),
	branch_code varchar(50),
	experience_level varchar(50),
	hire_date date,
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO

If object_id('bronze.bookings_raw', 'U') IS NOT NULL
	drop table bronze.bookings_raw

CREATE TABLE bronze.bookings_raw (
	booking_id varchar(50),
	customer_id varchar(50),
	barber_code varchar(50),
	service_code varchar(50),
	branch_code varchar(50),
	booking_datetime datetime2,
	booking_status varchar(50),
	booking_amount money,
	discount_amount money,
	tip_amount money,
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO


If object_id('bronze.branches_raw', 'U') IS NOT NULL
	drop table bronze.branches_raw

CREATE TABLE bronze.branches_raw (
	branch_code varchar(50),
	branch_name varchar(50),
	province varchar(50),
	city varchar(50),
	suburb varchar(50),
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO

If object_id('bronze.payments_raw', 'U') IS NOT NULL
	drop table bronze.payments_raw

CREATE TABLE bronze.payments_raw (
	payment_id varchar(50),
	booking_id varchar(50),
	payment_method varchar(50),
	payment_amount money,
	payment_status varchar(50),
	payment_datetime datetime2,
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO




If object_id('bronze.Services_raw', 'U') IS NOT NULL
	drop table bronze.services_raw

CREATE TABLE bronze.services_raw (
	service_code varchar(50),
	service_name varchar(50),
	category varchar(50),
	standard_price money,
	duration_minutes int,
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO
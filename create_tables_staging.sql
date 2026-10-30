--Create database BarbershopAnalytics

Use BarbershopAnalytics
Go

/****CREATE SCHEMAS**/

IF NOT Exists (select * from sys.schemas where [name] = 'staging')
BEGIN
	exec('Create schema staging')
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


--CUSTOMERS
If object_id('staging.customers_raw', 'U') IS NOT NULL
	drop table staging.customer_raw


CREATE TABLE staging.customers_raw (
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



-- BARBERS
If object_id('staging.barbers_raw', 'U') IS NOT NULL
	drop table staging.barbers_raw

CREATE TABLE staging.barbers_raw (
    barber_code varchar(50),
	barber_name varchar(50),
	branch_code varchar(50),
	experience_level varchar(50),
	hire_date date,
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO

-- BOOKINGS
If object_id('staging.bookings_raw', 'U') IS NOT NULL
	drop table staging.bookings_raw

CREATE TABLE staging.bookings_raw (
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

--BRANCHES
If object_id('staging.branches_raw', 'U') IS NOT NULL
	drop table staging.branches_raw

CREATE TABLE staging.branches_raw (
	branch_code varchar(50),
	branch_name varchar(50),
	province varchar(50),
	city varchar(50),
	suburb varchar(50),
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO

--PAYMENTS
If object_id('staging.payments_raw', 'U') IS NOT NULL
	drop table staging.payments_raw

CREATE TABLE staging.payments_raw (
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



-- SERVICES
If object_id('staging.Services_raw', 'U') IS NOT NULL
	drop table staging.services_raw

CREATE TABLE staging.services_raw (
	service_code varchar(50),
	service_name varchar(50),
	category varchar(50),
	standard_price money,
	duration_minutes int,
	source_file_name varchar(50),
	loaded_at datetime2 default getdate()

);
GO
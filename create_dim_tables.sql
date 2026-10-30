/**creatiNg dIMENSION TABLES**/

-- dim customer
if object_ID('dw.dim_customer', 'U') IS NOT NULL
	DROP TABLE dw.dim_customer;
GO

CREATE TABLE dw.dim_customer(
	 customer_key INT IDENTITY(1,1) primary key --surrogate key
	,customer_id varchar(50)
	,full_name varchar(250)
	,gender_group varchar(20)
	,city varchar(50)
	,province varchar(50)
	,region varchar(50)
	,signup_date date
	,signup_year int

);
GO

-- dim barber
if object_ID('dw.dim_barber', 'U') IS NOT NULL
	DROP TABLE dw.dim_barber;
GO

CREATE TABLE dw.dim_barber(
	 barber_key INT IDENTITY(1,1) primary key --surrogate key
	,barber_code varchar(50) NOT NULL
	,barber_name varchar(550)
	,branch_code varchar(20)
	,branch_city_code varchar(10)
	,experience_level varchar(20)
	,experience_group varchar(20)
	,hire_date date
	,years_employed int

);
GO


-- dim branch
if object_ID('dw.dim_branch', 'U') IS NOT NULL
	DROP TABLE dw.dim_branch;
GO

CREATE TABLE dw.dim_branch(
	 branch_key INT IDENTITY(1,1) primary key --surrogate key
	,branch_code varchar(50) NOT NULL
	,branch_name varchar(200)
	,branch_city_code varchar(20)
	,branch_suburb_code varchar(50)
	,province varchar(50)
	,city varchar(50)
	,suburb varchar(50)
	,region varchar(50)

);
GO


-- dim service
if object_ID('dw.dim_service', 'U') IS NOT NULL
	DROP TABLE dw.dim_service;
GO

CREATE TABLE dw.dim_service(

	 service_key INT IDENTITY(1,1) primary key --surrogate key
	,service_code varchar(50) NOT NULL
	,service_short_code varchar(200)
	,service_name varchar(200)
	,category varchar(50)
	,service_group varchar(50)
	,standard_price decimal(10,2)
	,duration_minutes int
	,duration_bucket varchar(50)
	,price_bucket varchar(50)

);
GO


-- dim date
if object_ID('dw.dim_date', 'U') IS NOT NULL
	DROP TABLE dw.dim_date;
GO

CREATE TABLE dw.dim_date(

	 date_key INT primary key  --surrogate key
	,full_date DATE NOT NULL
	,year INT
	,month_number INT
	,month_name varchar(50)
	,day_number INT
	,day_name varchar(50)
	,week_number int
	,is_weekend bit

);
GO
/**** CREATING FACT TABLES  *****/


-- fact bookings
if object_ID('dw.fact_bookings', 'U') IS NOT NULL
	DROP TABLE dw.fact_bookings;
GO

CREATE TABLE dw.fact_bookings(
     booking_key int identity (1,1) primary key
    ,booking_id varchar(50) not null

    --surrogate keys
    ,customer_key int
    ,barber_key int
    ,branch_key int
    ,service_key int
    ,date_key  int


    ,booking_datetime datetime2
    ,booking_status varchar(50)
    ,time_of_day_bucket varchar(20)

    --measures
    ,gross_amount decimal(10,2)
    ,discount_amount decimal (10,2)
    ,tip_amount decimal (10,2)
    ,net_amount decimal (10,2)

    --flags
    ,is_completed bit
    ,is_cancelled bit
    ,is_no_show bit
    ,has_discount bit
    ,has_tip bit
)
create table [dbo].[Orders](
[OrderId] int,
[OrderDate] Date,
CustomerName varchar(100),
[CustomerCity] varchar(100),
[OrderAmount] Money
)

go

-- Script to insert 200 rows into the Orders table with Indian names and city names fixed

-- Declare variables for dynamic insertion
DECLARE @Counter INT = 1;
DECLARE @MaxRows INT = 200;

WHILE @Counter <= @MaxRows
BEGIN
    INSERT INTO [dbo].[Orders] ([OrderId], [OrderDate], [CustomerName], [CustomerCity], [OrderAmount])
    VALUES (
        @Counter,
        DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE() - 365), -- Random date within the last year
        (SELECT TOP 1 Name FROM (VALUES 
            ('Arjun Singh'), 
            ('Sneha Sharma'), 
            ('Vikram Kumar'), 
            ('Priya Patel'), 
            ('Rohan Mehta')
        ) AS Names(Name) ORDER BY NEWID()), -- Random Indian name
        (SELECT TOP 1 City FROM (VALUES 
            ('Mumbai'), 
            ('Delhi'), 
            ('Bangalore'), 
            ('Chennai'), 
            ('Hyderabad')
        ) AS Cities(City) ORDER BY NEWID()), -- Random Indian city
        CAST((ABS(CHECKSUM(NEWID())) % 9000) + 1000 AS MONEY) -- Random order amount between 1000 and 10000
    );

    SET @Counter = @Counter + 1;
END;

go


select 
	customerCity,AVG(OrderAmount) as AverageOrderAmount,
	Min(OrderAmount) as MinimumOrderAmount,
	Max(OrderAmount) as MaxOrderAmount
from orders 
	group by customerCity

select 
	customerCity,
	CustomerName,
	ROW_NUMBER() over(partition by customerCity order by OrderAmount) as 'Row Number',
	OrderAmount,
	count(orderid) over(partition by customerCity) as CountOfOrders,
	AVG(OrderAmount) over(partition by customerCity) as AverageOrderAmount,
	Min(OrderAmount) over(partition by customerCity) as MinimumOrderAmount,
	Max(OrderAmount) over(partition by customerCity) as MaxOrderAmount
from orders 
	


	update orders set customerCity = 'Hosiarpur' where customerCity = 'Hyderabad'
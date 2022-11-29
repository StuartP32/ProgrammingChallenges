USE [master]
GO

-- Drop the existing SQL_Challenge database
DROP DATABASE [SQL_Challenge]
GO

-- Create the SQL_Challenge database
CREATE DATABASE [SQL_Challenge]

 ON  PRIMARY 
( NAME = N'SQL_Challenge_Data', FILENAME = N'C:\SQL\SQL_Challenge_Data.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'SQL_Challenge_Log', FILENAME = N'C:\SQL\SQL_Challenge_Log.ldf' , SIZE = 13312KB , MAXSIZE = 2048GB , FILEGROWTH = 1024KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

-- If the store_revenue table exists, drop it
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[store_revenue]') AND type in (N'U'))
DROP TABLE [store_revenue]
GO

--Create the store_revenue table
CREATE TABLE store_revenue(
	id int PRIMARY KEY not null,
	date datetime,
	brand_id int,
	store_location varchar (250),
	revenue float	
)
GO

-- Load store_revenue data
BULK INSERT store_revenue
FROM 'C:\SQL\store_revenue.csv'
WITH
(
	FIRSTROW = 2,
	FORMAT = 'CSV'
)
 
 --	Verify load
SELECT *
FROM store_revenue

-- If the marketing_data table exists, drop it
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[marketing_data]') AND type in (N'U'))
DROP TABLE [marketing_data]
GO

-- Create marketing_data table
 CREATE TABLE marketing_data(
	id int PRIMARY KEY not null,
	date datetime,
	geo varchar (2),
	impressions float,
	clicks float
)
GO

-- Load marketing_data table
BULK INSERT marketing_data
FROM 'C:\SQL\marketing_data.csv'
WITH
(
	FIRSTROW = 2,
	FORMAT = 'CSV'
)
 
 -- Verify load
SELECT *
FROM marketing_data

--Question #0 (Already done for you as an example) Select the first 2 rows from the marketing data​
--select * from marketing_data limit 2;

--Question #1 Generate a query to get the sum of the clicks of the marketing data​
select sum(clicks) as [Total # of clicks]
from marketing_data

--Question #2 Generate a query to gather the sum of revenue by store_location from the store_revenue table​
select distinct store_location, sum(revenue) as [Total Revenue]
from store_revenue
group by store_location

--Question #3 Merge these two datasets so we can see impressions, clicks, and revenue together by date and geo. 
--Please ensure all records from each table are accounted for.​
select *
from store_revenue sr INNER JOIN marketing_data md on sr.id = md.id

--Question #4 In your opinion, what is the most efficient store and why?​

select id, revenue
from store_revenue
order by revenue desc

--Store with id = 22 becasue it has the most revenue


--Question #5 (Challenge) Generate a query to rank in order the top 10 revenue producing states​
select store_location, sum(revenue) as [Revenue]
from store_revenue
group by store_location
order by sum(revenue) desc
-- note: there are only 3 states

select distinct geo
from marketing_data
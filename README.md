# Online Store Dashboard

An online shopping store request to improve their current sales report from static report to dynamic visual reports / dashboard. Additionally, they want to include in the new dashboard their latest online sales report and compared it from the previous year. They want to see how many products are being sold, where it was sold and how many of them are sold to a specific customer.

## Business Demand 

### Overview

- Requested by: Sales Manager
- Change Request: Visual dynamic dashboards with improvde Sales reporting metrics
- Application/Software: Power BI, SQL, Excel
- Other relevant Infos: Excel dataset (Budget 2021), SQL Database access

<b>Key points:</b>
- Analyze into more details the following KPIs Total sales, total budget alloted, difference of alloted budget from sales, total sold product.
- Display how much products sold to which client and how it has been over time.
- Sales manager / Sales person (viewer and user) should be able to filter reports by date, months, customer, product, category and city.
- Provide dashboard to display all the reports that can be refreshed every time they have new data.

### User Stories

<b>Role: Sales Manager</b>

<b>Request:</b> Detail overview of Online Sales

<b>Value / Purpose:</b>
  - To continuously follow the progress on which customers and products sells the best
  - To monitor sales over time against budget alloted for the year
    
<b>Proposal:</b> Power BI Dashboard with dynamic reports using graphs, tables and KPIs


<b>Role: Sales Representative</b>

<b>Request:</b> Detail overview of Online Sales specifically on Customers and Products

<b>Value / Purpose:</b>
  - To closely monitor customers that buy the most products
  - To monitor sales of products that sells the best
    
<b>Proposal:</b> Power BI Dashboard with filterable reports

## Metrics
- Total Sales
- Total Product Sold
- Total Budget
- Sales Budget Difference
- Top Customer and Products

## Data Visualization
Full page link of the Interactive Power BI Dashboard click this link - [App Power BI link](https://app.powerbi.com/view?r=eyJrIjoiNjUwMDdlMGMtNzdmNS00ZDEzLTkwNzgtY2M1OGM5OTY0YWRkIiwidCI6ImE0ZTc4YjgxLTg3NGEtNDgzMi04OGYwLTEyYmQxNjMxMDhmNCIsImMiOjEwfQ%3D%3D)

![OnlineStoreDB](OnlineStoreDashboard.PNG)

![OnlineStoreDB2](OnlineStoreDashboard2.PNG)

## Data Structure
Online store sales data structure consists of 5 tables (FACT_InternetSales, FACT_Budget, DIM_Customers, DIM_Products, DIM_Calendar) and 2 measure tables (Top10, _All measures) with a total of row count of 60,000 records.

![data_structure_1](data_structure_1.PNG)

## Data Access

<b>A one time SQL Database access was given to extract the needed data for the reports using following SQL queries:</b>

InternetSales Table 

        SELECT 
          [ProductKey], 
          [OrderDateKey], 
          [DueDateKey], 
          [ShipDateKey], 
          [CustomerKey], 
          [SalesOrderNumber], 
          [SalesAmount] 
        FROM 
          [AdventureWorksDW2019].[dbo].[FactInternetSales]
        WHERE 
          LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -2 -- Ensures we always only bring two years of date from extraction.
        ORDER BY
          OrderDateKey ASC

Product Table 

        SELECT 
          p.[ProductKey], 
          p.[ProductAlternateKey] AS ProductItemCode, 
          p.[EnglishProductName] AS [Product Name], 
          ps.EnglishProductSubcategoryName AS [Sub Category], -- Joined in from Sub Category Table
          pc.EnglishProductCategoryName AS [Product Category], -- Joined in from Category Table
          p.[Color] AS [Product Color], 
          p.[Size] AS [Product Size], 
          p.[ProductLine] AS [Product Line], 
          p.[ModelName] AS [Product Model Name], 
          p.[EnglishDescription] AS [Product Description], 
          ISNULL (p.Status, 'Outdated') AS [Product Status] 
        FROM 
          [AdventureWorksDW2019].[dbo].[DimProduct] as p
          LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
          LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey 
        ORDER BY 
          p.ProductKey asc

          
Customer Table

        SELECT 
          c.customerkey AS CustomerKey, 
          c.firstname AS [First Name],  
          c.lastname AS [Last Name], 
          c.firstname + ' ' + lastname AS [Full Name], 
          CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
          c.datefirstpurchase AS DateFirstPurchase, 
          g.city AS [Customer City] -- Joined in Customer City from Geography Table
        FROM 
          [AdventureWorksDW2019].[dbo].[DimCustomer] as c
          LEFT JOIN dbo.dimgeography AS g ON g.geographykey = c.geographykey 
        ORDER BY 
          CustomerKey ASC -- Ordered List by CustomerKey
      

Calendar Table 

        SELECT 
          [DateKey], 
          [FullDateAlternateKey] AS Date, 
          [EnglishDayNameOfWeek] AS Day, 
          [EnglishMonthName] AS Month, 
          Left([EnglishMonthName], 3) AS MonthShort,   -- Useful for front end date navigation and front end graphs.
          [MonthNumberOfYear] AS MonthNo, 
          [CalendarQuarter] AS Quarter, 
          [CalendarYear] AS Year --[CalendarSemester] 
        FROM 
         [AdventureWorksDW2019].[dbo].[DimDate]
        WHERE 
          CalendarYear >= 2019

## Summary of Insights

  - Online Sales for 2020 (16.35M) surpass the total budget of 15.3M
  - A difference of 1.05M between Sales and Budget, which can be considered as gross profit for the year 2020
  - Total sold product, 52,801, most of it comes from Bikes category which is 15M in sales 94% of the total sales
  - The most total sales was in December (1.87M), but it didn't surpass the budget for that month (2M)
  - The highest sales month which surpass the budget is in Jun (1.64M) with budget of 1.1M. Considered a 0.5M gross profit in June
  - London has the most sales where customers a buying
  - Top customers are Jordan Turner with 11.5K spent on products, followed by Maurice Shan(10.8K) and Janet Munoz(10.4K)
  - Top 10 products where all sold from Bike category
    

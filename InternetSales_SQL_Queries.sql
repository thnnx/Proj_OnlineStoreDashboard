-- InternetSales Table 
    
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

-- Product Table

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

-- Customer Table

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

-- Calendar Table
    
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
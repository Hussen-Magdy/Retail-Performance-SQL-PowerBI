CREATE TABLE FactSales1997 (
    transaction_date DATE,
    stock_date DATE,
    product_id INT,
    customer_id INT,
    store_id INT,
    quantity INT
);
GO

CREATE TABLE FactSales1998 (
    transaction_date DATE,
    stock_date DATE,
    product_id INT,
    customer_id INT,
    store_id INT,
    quantity INT
);
GO

Select * from FactSales1998
Select * from FactSales1997
Select * from FactSales



INSERT INTO FactSales (transaction_date, stock_date, product_id, customer_id, store_id, quantity)
SELECT transaction_date, stock_date, product_id, customer_id, store_id, quantity FROM FactSales1998
UNION ALL
SELECT transaction_date, stock_date, product_id, customer_id, store_id, quantity FROM FactSales1997;


CREATE TABLE TempRegions (
    region_id INT PRIMARY KEY,
    sales_region VARCHAR(50),
    sales_district VARCHAR(50)
);
GO

ALTER TABLE DimStores
DROP COLUMN sales_district, sales_region;
GO



SELECT 
    s.*,               
    r.sales_region,   
    r.sales_district   
INTO DimStores_Final
FROM DimStores s
LEFT JOIN TempRegions r ON s.region_id = r.region_id;
GO

Select * from DimStores_Final
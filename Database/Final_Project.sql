CREATE DATABASE Retail_Store_DB;
GO

USE Retail_Store_DB;
GO

CREATE TABLE DimProducts (
    product_id INT PRIMARY KEY,
    product_brand VARCHAR(100),
    product_name VARCHAR(255),
    product_sku BIGINT,
    product_retail_price DECIMAL(10, 2),
    product_cost DECIMAL(10, 2),
    product_weight DECIMAL(10, 2),
    recyclable INT,
    low_fat INT
);
GO

CREATE TABLE DimStores (
    store_id INT PRIMARY KEY,
    region_id INT,                
    store_type VARCHAR(50),
    store_name VARCHAR(100),
    store_street_address VARCHAR(255),
    store_city VARCHAR(100),
    store_state VARCHAR(100),
    store_country VARCHAR(100),
    store_phone VARCHAR(50),
    first_opened_date DATE,
    last_remodel_date DATE,
    total_sqft DECIMAL(10, 2),    
    grocery_sqft DECIMAL(10, 2)   
);
GO

CREATE TABLE TempRegions (
    region_id INT PRIMARY KEY,
    sales_region VARCHAR(50),
    sales_district VARCHAR(50)
);
GO

SELECT 
    s.*,               
    r.sales_region,   
    r.sales_district   
INTO DimStores_Final
FROM DimStores s
LEFT JOIN TempRegions r ON s.region_id = r.region_id;
GO

ALTER TABLE DimStores_Final ADD CONSTRAINT PK_DimStores_Final PRIMARY KEY (store_id);
GO


CREATE TABLE DimCustomers (
    customer_id INT PRIMARY KEY,
    customer_acct_num BIGINT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    customer_address VARCHAR(150),
    customer_city VARCHAR(50),
    customer_state_province VARCHAR(50),
    customer_postal_code VARCHAR(50),
    customer_country VARCHAR(50),
    birthdate DATE,
    marital_status VARCHAR(10),        
    yearly_income VARCHAR(50),  
    gender VARCHAR(10),                
    total_children INT,
    num_children_at_home INT,   
    education VARCHAR(50),
    acct_open_date DATE,
    member_card VARCHAR(50),      
    occupation VARCHAR(50),
    homeowner VARCHAR(10)           
);
GO

CREATE TABLE DimCalendar (
    date DATE PRIMARY KEY

);
GO


CREATE TABLE FactSales (
    sales_key INT IDENTITY(1,1) PRIMARY KEY, 
    transaction_date DATE,
    stock_date DATE,
    product_id INT,
    customer_id INT,
    store_id INT,
    quantity INT,
    
    CONSTRAINT FK_Sales_Calendar FOREIGN KEY (transaction_date) REFERENCES DimCalendar(date),
    CONSTRAINT FK_Sales_Products FOREIGN KEY (product_id) REFERENCES DimProducts(product_id),
    CONSTRAINT FK_Sales_Customers FOREIGN KEY (customer_id) REFERENCES DimCustomers(customer_id),
    CONSTRAINT FK_Sales_Stores FOREIGN KEY (store_id) REFERENCES DimStores(store_id)
);
GO



ALTER TABLE FactSales 
DROP CONSTRAINT FK_Sales_Stores;
GO

ALTER TABLE FactSales 
ADD CONSTRAINT FK_Sales_Stores 
FOREIGN KEY (store_id) REFERENCES DimStores_Final(store_id);
GO



CREATE TABLE FactReturns (
    return_key INT IDENTITY(1,1) PRIMARY KEY, 
    return_date DATE,
    product_id INT,
    store_id INT,
    quantity INT,
    
    CONSTRAINT FK_Returns_Calendar FOREIGN KEY (return_date) REFERENCES DimCalendar(date),
    CONSTRAINT FK_Returns_Products FOREIGN KEY (product_id) REFERENCES DimProducts(product_id),
    CONSTRAINT FK_Returns_Stores FOREIGN KEY (store_id) REFERENCES DimStores(store_id)
);
GO


ALTER TABLE FactReturns 
DROP CONSTRAINT FK_Returns_Stores;
GO

ALTER TABLE FactReturns 
ADD CONSTRAINT FK_Returns_Stores 
FOREIGN KEY (store_id) REFERENCES DimStores_Final(store_id);
GO








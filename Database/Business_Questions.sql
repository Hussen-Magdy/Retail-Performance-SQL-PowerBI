
-- PAGE 2: EXECUTIVE OVERVIEW 

-- Q1: Top 5 Underperforming Products (Lowest Net Profit)
SELECT TOP 5
    product_name,
    product_brand,
    SUM(Total_Revenue) AS Total_Revenue
FROM v_FactSales
GROUP BY product_name, product_brand
ORDER BY Total_Revenue ASC;
-- Q2: Which product brands drive the highest revenue for the business?
SELECT TOP 10
    product_brand,
    SUM(Total_Revenue) AS Total_Revenue
FROM v_FactSales
GROUP BY product_brand
ORDER BY Total_Revenue DESC;

-- Q3: Bottom 5 Underperforming Sales Regions
SELECT TOP 5
    st.sales_region,
    SUM(s.Net_Profit) AS Total_Net_Profit
FROM v_FactSales s
JOIN DimStores_Final st ON s.store_id = st.store_id
GROUP BY st.sales_region
ORDER BY Total_Net_Profit ASC;

-- Q4: What is the overall Return Rate, and which year recorded a higher volume of returns?

-- Part A: Overall Return Rate
SELECT 
    CAST(SUM(Returned_Quantity) AS FLOAT) / 
    NULLIF((SELECT SUM(quantity) FROM v_FactSales), 0) * 100 AS Overall_Return_Rate_Percent
FROM v_FactReturns;

-- Part B: Returns Volume across Years
SELECT 
    YEAR(return_date)       AS Return_Year,
    SUM(Returned_Quantity)  AS Total_Returned_Quantity
FROM v_FactReturns
GROUP BY YEAR(return_date)
ORDER BY Return_Year;


-- PAGE 3: SALES & PRODUCT ANALYSIS 

-- Q1: What is the Average Order Value (AOV) across different transaction periods?
SELECT 
    YEAR(transaction_date)                          AS Transaction_Year,
    SUM(Total_Revenue) / COUNT(DISTINCT sales_key)  AS Average_Order_Value_AOV
FROM v_FactSales
GROUP BY YEAR(transaction_date)
ORDER BY Transaction_Year;

-- Q2: Which are the top 10 products generating the highest sales revenue?
SELECT TOP 10
    product_name,
	product_id,
    SUM(Total_Revenue) AS Total_Revenue
FROM v_FactSales
GROUP BY product_id, product_name
ORDER BY Total_Revenue DESC;


-- Q3: Which product brands record the highest number of returned quantities?
SELECT TOP 10
    product_brand,
    SUM(Returned_Quantity) AS Total_Returned_Quantity
FROM v_FactReturns
GROUP BY product_brand
ORDER BY Total_Returned_Quantity DESC;

-- Q4: Top 10 products comparison: Net Profit VS Cost

SELECT TOP 10
    product_id,
    product_name,
    SUM(Net_Profit) AS Total_Net_Profit,
    SUM(Total_Cost) AS Total_Cost
FROM v_FactSales
GROUP BY product_id, product_name
ORDER BY Total_Net_Profit DESC;


--PAGE 4: CUSTOMER ANALYSIS 

-- Q1: Which customer occupations generate the highest sales revenue?
SELECT 
    occupation,
    SUM(Total_Revenue) AS Total_Revenue
FROM v_FactSales
GROUP BY occupation
ORDER BY Total_Revenue DESC;

-- Q2: Average Order Value by Education Level
SELECT 
    education,
    SUM(Total_Revenue) / COUNT(DISTINCT sales_key) AS Avg_Order_Value
FROM v_FactSales
GROUP BY education
ORDER BY Avg_Order_Value DESC;

-- Q3: Do homeowners tend to spend more compared to non-homeowners?
SELECT 
    homeowner,
    SUM(Total_Revenue)          AS Total_Spending,
    COUNT(DISTINCT sales_key)   AS Total_Orders
FROM v_FactSales
GROUP BY homeowner;

-- Q4: How are customers segmented based on their yearly income versus their actual total spending?
SELECT 
    yearly_income               AS Income_Segment,
    SUM(Total_Revenue)          AS Total_Spending,
    COUNT(DISTINCT customer_id) AS Unique_Customer_Count
FROM v_FactSales
GROUP BY yearly_income
ORDER BY Total_Spending DESC;

-- Q5: How does the customer's member card type influence their total purchasing volume?
SELECT 
    member_card,
    SUM(quantity)       AS Total_Purchased_Volume,
    SUM(Total_Revenue)  AS Total_Revenue
FROM v_FactSales
GROUP BY member_card
ORDER BY Total_Purchased_Volume DESC;


--PAGE 5: REGIONAL ANALYSIS 
-- Q1: How are total sales distributed geographically across different store countries?
SELECT 
    st.store_country,
    SUM(s.Total_Revenue) AS Total_Sales_Revenue
FROM v_FactSales s
JOIN DimStores_Final st ON s.store_id = st.store_id
GROUP BY st.store_country
ORDER BY Total_Sales_Revenue DESC;

-- Q2: What are the top-performing cities in terms of total sales revenue?
SELECT TOP 10
    st.store_city,
    st.store_country,
    SUM(s.Total_Revenue) AS Total_Sales_Revenue
FROM v_FactSales s
JOIN DimStores_Final st ON s.store_id = st.store_id
GROUP BY st.store_city, st.store_country
ORDER BY Total_Sales_Revenue DESC;

-- Q3: How do the major sales regions  in overall performance?
SELECT 
    st.sales_region,
    SUM(s.Total_Revenue) AS Total_Sales_Revenue,
    SUM(s.Net_Profit)    AS Total_Net_Profit
FROM v_FactSales s
JOIN DimStores_Final st ON s.store_id = st.store_id
GROUP BY st.sales_region
ORDER BY st.sales_region, Total_Sales_Revenue DESC;

-- Q4: Which store type generates the highest revenue?
SELECT 
    st.store_type,
    SUM(s.Total_Revenue) AS Total_Sales_Revenue
FROM v_FactSales s
JOIN DimStores_Final st ON s.store_id = st.store_id
GROUP BY st.store_type
ORDER BY Total_Sales_Revenue DESC;



--------- KPI Validation
SELECT
    SUM(Total_Revenue)          AS Total_Sales,
    COUNT(DISTINCT sales_key)   AS Total_Orders,
    SUM(Total_Revenue) / COUNT(DISTINCT sales_key) AS Avg_Order_Value,
    SUM(Net_Profit)             AS Total_Net_Profit
FROM v_FactSales;


    -- Avg_Spending_per_Customer / Total_Stores / Total_Customers
SELECT 
    COUNT(DISTINCT customer_id) AS Total_Customers,
    COUNT(DISTINCT store_id) AS Total_Stores,
    SUM(Total_Revenue) / NULLIF(COUNT(DISTINCT customer_id), 0) AS Avg_Spending_per_Customer
FROM v_FactSales;

-- Top country in Sales
SELECT TOP 1 
    store_country, 
    SUM(Total_Revenue) AS Total_Sales
FROM v_FactSales
GROUP BY store_country
ORDER BY Total_Sales DESC;
    


--Total Returned_Quantity
Select SUM(Returned_Quantity) As Total_Returns
From v_FactReturns

--Return Rate %
SELECT 
    CAST(SUM(Returned_Quantity) AS FLOAT)
    / NULLIF((SELECT SUM(quantity) FROM v_FactSales), 0) * 100 
    AS Overall_Return_Rate_Percent
FROM v_FactReturns;



--Year-over-Year (YoY) Growth
WITH YearlySales AS (
    SELECT 
        YEAR(transaction_date) AS Sales_Year,
        SUM(Total_Revenue) AS Total_Revenue
    FROM v_FactSales
    GROUP BY YEAR(transaction_date)
)
SELECT 
    Sales_Year,
    Total_Revenue,
    LAG(Total_Revenue) OVER (ORDER BY Sales_Year) AS Previous_Year_Revenue,
    
    CAST(
        (Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Sales_Year))
        / NULLIF(LAG(Total_Revenue) OVER (ORDER BY Sales_Year), 0) * 100
        AS DECIMAL(10,2)
    ) AS YoY_Growth_Percent
FROM YearlySales;


--Month-over-Month Growth

  WITH MonthlySales AS (
    SELECT 
        YEAR(transaction_date) AS Sales_Year,
        MONTH(transaction_date) AS Sales_Month,
        SUM(Total_Revenue) AS Total_Revenue
    FROM v_FactSales
    GROUP BY YEAR(transaction_date), MONTH(transaction_date)
)
SELECT 
    Sales_Year,
    Sales_Month,
    Total_Revenue,
    
    LAG(Total_Revenue) OVER (
        ORDER BY Sales_Year, Sales_Month
    ) AS Previous_Month_Revenue,

    CAST(
        (Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Sales_Year, Sales_Month))
        / NULLIF(LAG(Total_Revenue) OVER (ORDER BY Sales_Year, Sales_Month), 0) * 100
        AS DECIMAL(10,2)
    ) AS MoM_Growth_Percent
FROM MonthlySales;


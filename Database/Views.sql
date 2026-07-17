-- 2. v_FactSales 

CREATE OR ALTER VIEW v_FactSales AS
SELECT 
    s.sales_key,
    s.transaction_date,
    s.stock_date,
    s.store_id,
    s.product_id,
    s.customer_id,
    s.quantity,

    p.product_name,
    p.product_brand,

    cu.occupation,
    cu.education,
    cu.homeowner,
    cu.member_card,
    cu.yearly_income,

    st.store_name,
    st.store_type,
    st.store_city,
    st.store_country,
    st.sales_region,
    st.sales_district,

    CAST(s.quantity * p.product_retail_price AS DECIMAL(18,2)) AS Total_Revenue,
    CAST(s.quantity * p.product_cost AS DECIMAL(18,2)) AS Total_Cost,
    CAST(
        s.quantity * (p.product_retail_price - p.product_cost)
        AS DECIMAL(18,2)
    ) AS Net_Profit
FROM FactSales s
JOIN DimProducts p ON s.product_id = p.product_id
JOIN DimCustomers cu ON s.customer_id = cu.customer_id
JOIN DimStores_Final st ON s.store_id = st.store_id;
GO

-- 2. v_FactReturns 
CREATE OR ALTER VIEW v_FactReturns AS
SELECT 
    r.return_key,
    r.return_date,
    r.store_id,
    r.product_id,
    r.quantity AS Returned_Quantity,

    p.product_name,
    p.product_brand,

    st.store_name,
    st.store_type,
    st.store_city,
    st.store_country,
    st.sales_region,
    st.sales_district,

    CAST(r.quantity * p.product_retail_price AS DECIMAL(18,2)) AS Returned_Revenue,
    CAST(r.quantity * p.product_cost AS DECIMAL(18,2)) AS Returned_Cost
FROM FactReturns r
JOIN DimProducts p ON r.product_id = p.product_id
JOIN DimStores_Final st ON r.store_id = st.store_id;
GO
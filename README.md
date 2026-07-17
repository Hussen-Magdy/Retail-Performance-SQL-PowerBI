# NexusMart Retail Analytics

An end-to-end retail analytics project covering data modeling, ETL, and business intelligence for a fictional multi-country retail chain, **NexusMart**, using data from fiscal years 1997–1998.

The project takes raw CSV data through a full pipeline: SQL Server data warehouse design (Galaxy Schema) → Python-based data cleaning and loading → an interactive 5-page Power BI dashboard with DAX-driven KPIs and business insights.

---

## Tech Stack

- **SQL Server** (T-SQL, SSMS) — data warehouse, schema design, business queries
- **Python** (Pandas, SQLAlchemy, ODBC) — data cleaning and ETL
- **Power BI** (Power Query, DAX) — interactive dashboard and reporting

---

## Project Structure

```
├── sql/
│   ├── Final_Project.sql          # Database & table creation (schema definition)
│   ├── Merge.sql                  # Merges Sales 1997 + 1998, builds DimStores_Final
│   ├── Views.sql                  # v_FactSales & v_FactReturns analytical views
│   └── Business_Questions.sql     # 16 business queries powering the dashboard
├── python/
│   ├── Missing_Values.ipynb       # Scans all datasets for missing values
│   ├── Handle_Missing_Values.ipynb# Cleans and fills missing values
│   └── Load_Data.ipynb            # Loads cleaned data into SQL Server
├── powerbi/
│   └── NexusMart_Dashboard.pbix   # 5-page interactive Power BI report
├── report/
│   └── NexusMart_Insights_Report.docx  # Business insights & recommendations
└── README.md
```

---

## Data Model — Galaxy Schema

The warehouse uses a **Galaxy Schema** (fact constellation) with two fact tables sharing common dimensions:

**Fact Tables**
- `FactSales` — sales transactions
- `FactReturns` — product returns

**Dimension Tables**
- `DimProducts`, `DimCustomers`, `DimCalendar`, `DimStores_Final` (stores merged with regional data)

Two SQL views (`v_FactSales`, `v_FactReturns`) pre-join facts with dimensions and compute core measures such as `Total_Revenue`, `Total_Cost`, `Net_Profit`, and `Returned_Revenue`, simplifying both querying and the Power BI data model.

---

## ETL Pipeline (Python)

1. **Missing_Values.ipynb** — audits all 8 source CSV files for NULLs and produces a summary report.
2. **Handle_Missing_Values.ipynb** — cleans identified gaps (e.g. filling missing `last_name`, `recyclable`, `low_fat` values) and saves clean CSVs.
3. **Load_Data.ipynb** — connects to SQL Server via SQLAlchemy/ODBC, parses and validates date fields, and loads the cleaned `DimCustomers` data into the warehouse.

---

## Power BI Dashboard

A 5-page interactive report connected live to SQL Server:

| Page | Focus |
|---|---|
| **Home** | High-level KPIs: Total Revenue, Net Profit, Total Cost, Returns, navigation menu |
| **Executive Overview** | Underperforming products/regions, top brands, return rate trends |
| **Sales & Product** | AOV trends, top products, returns by brand, profit vs. cost |
| **Customer Analysis** | Revenue by occupation, education, homeowner status, income segment, membership tier |
| **Regional Analysis** | Revenue by country, city, sales region, and store type |

DAX measures are organized into logical folders: **Core KPIs**, **Customer & Regional KPIs**, **Time KPIs (YoY/MoM Growth)**, and **Returns Analysis KPIs**.

---

## Key Business Insights

- **Growth:** Revenue reached **$1.76M** with **212.18% YoY growth**, driven by the Hermanos brand, the Professional customer segment, and the North West region.
- **Underperformance:** Central West region generated only **$9K** in net profit; the five weakest products each sold under 253 units.
- **Returns:** Return rate held steady at **0.99%** (8,289 units, ~3.1% of revenue) across both years — no major quality or seasonal issue detected.
- **Recommendation:** Prioritize investment in the North West/USA market and the Professional/homeowner customer segment, while reviewing operations in Central West and rationalizing low-performing SKUs.

Full analysis and supporting data are available in `report/NexusMart_Insights_Report.docx`.

---

## How to Reproduce

1. Run `sql/Final_Project.sql` to create the database and schema.
2. Run `sql/Merge.sql` to merge yearly sales data and build the final store dimension.
3. Run `sql/Views.sql` to create the analytical views.
4. Run the Python notebooks in order (`Missing_Values` → `Handle_Missing_Values` → `Load_Data`) to clean and load the data.
5. Open `powerbi/NexusMart_Dashboard.pbix` and point the SQL Server connection to your local instance.

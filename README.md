# Olist E-Commerce Data Analysis & Interactive Dashboard

An end-to-end e-commerce data analysis project using **SQL Server** and **Power BI**, covering data cleaning, exploratory data analysis, data validation, data modeling, and interactive business intelligence reporting.

The project analyzes Olist's e-commerce operations to understand sales performance, customer behavior, product performance, seller activity, payment methods, customer reviews, and delivery efficiency.

---

## Interactive Power BI Dashboard

**[Click here to explore the interactive Olist Dashboard](https://app.powerbi.com/view?r=eyJrIjoiNWIxNmYxNmItMTYxYy00OWMzLWE4YzMtYzBhYzUxYjRmMzEzIiwidCI6IjJiYjZlNWJjLWMxMDktNDdmYi05NDMzLWMxYzZmNGZhMzNmZiIsImMiOjl9)**

Explore the report directly through Power BI Service. The dashboard includes interactive filters, navigation, KPI cards, analytical charts, and drill-through analysis.

---

## Project Overview

The objective of this project was to transform raw e-commerce data into meaningful business insights through SQL analysis and an interactive Power BI dashboard.

The project follows an end-to-end analytical workflow:

1. Data exploration and understanding.
2. Data cleaning and preparation using SQL Server.
3. Exploratory Data Analysis (EDA).
4. Data validation and relationship checks.
5. Data modeling and analytical measure development.
6. Interactive dashboard design and business analysis.

## Tools & Technologies

- **SQL Server** – Data exploration, cleaning, validation, and business analysis.
- **Power BI** – Data modeling, DAX measures, visualization, and interactive reporting.
- **DAX** – Business calculations and analytical KPIs.
- **Power Query** – Data preparation and transformation.
- **GitHub** – Project documentation and version control.

---

## Dataset Description

The project uses nine original Olist CSV datasets:

| Dataset | Description |
|---|---|
| Olist Customers | Customer information and location identifiers |
| Olist Orders | Order details and timestamps |
| Olist Order Items | Products, sellers, prices, and freight values |
| Olist Order Payments | Payment methods, values, and installments |
| Olist Order Reviews | Customer review scores and comments |
| Olist Products | Product information and categories |
| Olist Sellers | Seller information and locations |
| Olist Geolocation | Geographic coordinates and ZIP code prefixes |
| Product Category Translation | Portuguese-to-English category translation |

The datasets were used to build a connected analytical model while preserving the original business-level granularity of the tables.

---

## SQL Analysis

SQL Server was used to prepare, investigate, and validate the data before building the Power BI report.

### 1. Data Cleaning & Preparation

- Explored the original tables and their record counts.
- Created staging tables to preserve the original raw data.
- Checked for duplicate records.
- Identified and investigated missing values.
- Reviewed invalid and inconsistent values.
- Checked date fields and data formats.
- Removed exact duplicate geolocation records where appropriate.
- Preserved records when the correct value could not be reliably determined.

### 2. Exploratory Data Analysis (EDA)

Performed business-focused analysis to answer questions related to:

- Overall sales performance.
- Monthly and yearly sales trends.
- Product category performance.
- Top-performing products and sellers.
- Customer purchasing behavior.
- Payment methods and installments.
- Customer review scores.
- Order statuses and delivery performance.
- Late delivery patterns.

### 3. Data Validation

Performed validation checks across the main business entities and relationships:

- Customers and Orders.
- Orders and Order Items.
- Orders and Payments.
- Orders and Reviews.
- Products and Order Items.
- Sellers and Order Items.

Also investigated orders without associated items or payment records.

Records with unexplained missing information were preserved rather than modified using unsupported assumptions.

### SQL Scripts

The SQL folder contains the three main project scripts:

| Script | Purpose |
|---|---|
| Dat Cleaning.sql | Initial exploration, staging, and data cleaning |
| EDA.sql | Exploratory data analysis and business insights |
| Data_Validation.sql | Relationship checks and data validation |

---

## Power BI Dashboard

The Power BI report was designed as an interactive analytical solution with a consistent dark navy visual theme.

### Dashboard Features

- Eight main analytical report pages.
- One hidden drill-through page for detailed performance investigation.
- 96 explicit DAX measures organized into subject-based folders.
- Interactive filtering by date, year, month, state, category, product, seller, and customer context.
- KPI cards and analytical visualizations.
- Dynamic insights and contextual titles.
- Reset Filters functionality.
- Navigation between report pages.
- Drill-through analysis using a Decomposition Tree.

The report was developed in an editable Power BI Project (PBIP) format. The original PBIP project files are not included in this repository; dashboard screenshots and the interactive Power BI Service link are provided instead.

### Data Modeling

The analytical model includes:

- Fact and dimension relationships.
- A dedicated Date dimension.
- Supporting geography and lookup tables.
- Derived fields organized separately from original source fields.
- Separate order, item, payment, and review tables to preserve their original granularity.

Special care was taken to avoid double-counting financial values when orders contain multiple items, payment records, or reviews.

### Important Business Metric Definitions

- **Merchandise Sales:** Calculated using product item prices.
- **Freight Value:** Kept separate from merchandise sales.
- **Payment Value:** Represents recorded payment values in the source data.
- **Total Order Value:** Merchandise sales plus freight value.

The report does not claim to calculate profit, cost, or profit margin because the required cost information is not available in the source datasets.

---

## Dashboard Screenshots

### 1. Overview
Executive summary of the overall e-commerce performance, including key KPIs, sales trends, customer distribution, payment methods, and delivery indicators.

![Overview Dashboard](Dashboard_Screenshots/Overview.png)

### 2. Sales Analysis
Analyzes sales performance over time, product categories, geographic distribution, order status, and sales trends.

![Sales Dashboard](Dashboard_Screenshots/Sales.png)

### 3. Customers Analysis
Explores unique customers, repeat purchasing behavior, customer distribution, and customer sales performance.

![Customers Dashboard](Dashboard_Screenshots/Customers.png)

### 4. Products Analysis
Examines product sales, category performance, average item prices, top products, and product-related shipping patterns.

![Products Dashboard](Dashboard_Screenshots/Products.png)

### 5. Sellers Analysis
Analyzes active sellers, seller sales performance, product categories, geographic distribution, and related delivery and review outcomes.

![Sellers Dashboard](Dashboard_Screenshots/Sellers.png)

### 6. Payments Analysis
Explores payment values, payment methods, installments, payment records, and payment reconciliation.

![Payments Dashboard](Dashboard_Screenshots/Payments.png)

### 7. Reviews Analysis
Examines review scores, positive and negative ratings, customer feedback, and the relationship between delivery performance and customer satisfaction.

![Reviews Dashboard](Dashboard_Screenshots/Reviews.png)

### 8. Delivery Analysis
Analyzes delivery duration, on-time and late delivery rates, delivery performance, and differences between estimated and actual delivery dates.

![Delivery Dashboard](Dashboard_Screenshots/Delivery.png)

### 9. Performance Analysis – Drill-through
A dedicated hidden drill-through page that investigates selected sales performance through a Decomposition Tree and contextual KPIs.

![Performance Analysis](Dashboard_Screenshots/Performance_Analysis.png)

### 10. Data Model
Shows the analytical data model and the relationships connecting the main business entities.

![Data Model](Dashboard_Screenshots/Data%20Modeling.png)

---

## Key Business Findings

The SQL exploratory analysis identified the following overall results:

| Metric | Result |
|---|---:|
| Total Orders | 98,666 |
| Merchandise Sales | 13,591,643.70 |
| Freight Value | 2,251,909.54 |
| Total Order Value | 15,843,553.24 |
| Average Delivery Time | 9.28 days |
| Late Delivery Rate | 7.87% |

### Additional Observations

- 2018 recorded the highest total order value in the analyzed period.
- Health & Beauty was among the highest-performing product categories.
- Freight represents a significant additional component of order value.
- Delivery performance and customer review scores provide useful perspectives on customer experience.
- Payment analysis highlights the importance of examining both payment methods and installment behavior.

*Financial values are presented in the dataset's original currency (Brazilian Real – BRL).*

---

## Repository Structure

```text
Olist-Ecommerce-Data-Analysis/
│
├── README.md
│
├── Data/
│   ├── olist_customers_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   └── product_category_name_translation.csv
│
├── SQL/
│   ├── Dat Cleaning.sql
│   ├── EDA.sql
│   └── Data_Validation.sql
│
└── Dashboard_Screenshots/
    ├── Overview.png
    ├── Sales.png
    ├── Customers.png
    ├── Products.png
    ├── Sellers.png
    ├── Payments.png
    ├── Reviews.png
    ├── Delivery.png
    ├── Performance_Analysis.png
    └── Data Modeling.png
```

---

## Project Outcome

This project demonstrates an end-to-end data analytics workflow, combining SQL-based data preparation and business analysis with Power BI data modeling, DAX calculations, and interactive visualization.

It provides a structured view of e-commerce performance and demonstrates how raw transactional data can be transformed into useful business insights.

**Technologies:** SQL Server | Power BI | DAX | Power Query | GitHub

**Dashboard:** [Explore the Interactive Olist Dashboard](https://app.powerbi.com/view?r=eyJrIjoiNWIxNmYxNmItMTYxYy00OWMzLWE4YzMtYzBhYzUxYjRmMzEzIiwidCI6IjJiYjZlNWJjLWMxMDktNDdmYi05NDMzLWMxYzZmNGZhMzNmZiIsImMiOjl9)

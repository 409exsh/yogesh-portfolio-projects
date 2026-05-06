# 🗄️ SQL E-Commerce Analytics Project

End-to-end e-commerce data analysis project covering **database design, SQL analytics, cohort retention, and customer segmentation (RFM)**.

This project simulates how a data analyst would work with real business data to generate insights and support decision-making.

---

## 📌 Problem Statement

An e-commerce company lacks visibility into:

* Revenue trends over time
* Customer purchasing behavior
* Product performance and profitability
* Customer retention and churn patterns

As a result, business decisions are made without data-driven insights.

---

## ❓ Key Business Questions

* What is total revenue, average order value, and growth trend?
* Which products and categories generate the most revenue and profit?
* Who are the most valuable customers (CLV)?
* How many customers are new vs returning over time?
* What does customer retention look like (cohort analysis)?
* Which regions/states drive the most revenue?

---

## ⚙️ Approach

### 1. Database Design

* Designed a **relational schema** with normalized tables:

  * Customers
  * Orders
  * Order Items
  * Products
  * Reviews

### 2. Data Preparation

* Created structured schema using MySQL
* Inserted sample data for realistic simulation

### 3. SQL Analysis

* Wrote advanced SQL queries using:

  * Aggregations (`SUM`, `AVG`, `COUNT`)
  * Window functions (`LAG`, `OVER`)
  * Joins across multiple tables
  * Grouping and filtering

### 4. Customer Analytics

* Calculated **Customer Lifetime Value (CLV)**
* Identified **new vs returning customers**

### 5. Cohort Retention Analysis

* Grouped customers by first purchase month
* Measured retention over time (Month 0 → Month 5)

### 6. Customer Segmentation (Python)

* Performed **RFM analysis**
* Applied **K-Means clustering**
* Evaluated clusters using **Silhouette Score**

---

## 📊 Key Insights

* A small group of customers contributes a large portion of total revenue
* Revenue shows clear monthly and quarterly trends
* Electronics category dominates total revenue
* Customer retention drops significantly after the first 2–3 months
* Returning customers generate higher average order value than new customers

---

## 📈 Analysis Modules

### 🔹 Revenue Overview

* Total revenue, orders, customers
* Monthly trends with MoM change
* Quarterly breakdown

### 🔹 Product Performance

* Top 10 products by revenue
* Profit and margin analysis
* Category-level revenue share
* Low-stock alerts

### 🔹 Customer Analytics

* Customer Lifetime Value (Top 20)
* New vs returning customers per month
* Customer acquisition trends

### 🔹 Order Funnel

* Order status distribution
* Average order value and shipping cost

### 🔹 Geographic Analysis

* Revenue by state (Top 10)

### 🔹 Product Ratings

* Average rating per product
* Rating distribution

---

## 📊 Cohort Retention

* Customers grouped by first purchase month
* Tracks repeat purchases over time
* Helps identify churn patterns

📌 Insight:
Retention typically declines from **100% to ~30% by Month 3**, indicating a need for early engagement strategies.

---

## 🧠 Customer Segmentation (RFM)

### Metrics:

* **Recency** → Days since last purchase
* **Frequency** → Number of orders
* **Monetary** → Total spend

### Segments:

* 🟢 Champions (high value, frequent buyers)
* 🔵 Loyal Customers
* 🟠 Promising / New
* 🔴 At Risk / Lost

---

## 🎯 Business Impact

* Enables **data-driven decision making**
* Identifies **high-value customers for retention**
* Improves **marketing targeting strategies**
* Highlights **product and region performance**
* Supports **inventory and pricing optimization**

---

## 📂 Project Structure

```
03_sql_ecommerce_analysis/
│
├── data/
│   └── sample_data_insert.sql
│
├── schema.sql
├── analysis_queries.sql
├── cohort_retention.sql
│
├── rfm_clustering.py
├── rfm_results.csv
│
├── elbow_silhouette.png
├── rfm_scatter.png
├── rfm_segments_bar.png
│
├── requirements.txt
└── README.md
```

---

## ▶️ How to Run

### 1. Setup Database

```bash
mysql -u root -p < schema.sql
mysql -u root -p ecommerce_db < data/sample_data_insert.sql
```

---

### 2. Run SQL Analysis

```bash
mysql -u root -p ecommerce_db < analysis_queries.sql
mysql -u root -p ecommerce_db < cohort_retention.sql
```

---

### 3. Run RFM Segmentation

```bash
pip install -r requirements.txt
python rfm_clustering.py
```

---

## 📊 Outputs

* `rfm_results.csv` → Customer segments
* `elbow_silhouette.png` → Optimal cluster selection
* `rfm_scatter.png` → Cluster visualization
* `rfm_segments_bar.png` → Segment comparison

---

## ⚠️ Limitations

* Dataset is synthetic/small-scale for demonstration purposes
* Real-world datasets would provide more distinct clustering and deeper insights

---

## 🛠 Tech Stack

* MySQL 8
* Python (Pandas, NumPy)
* Scikit-learn
* Matplotlib & Seaborn
* SQLAlchemy + PyMySQL

---

## 🚀 Conclusion

This project demonstrates how SQL and Python can be combined to perform **end-to-end business analytics**, from raw data to actionable insights.

It reflects real-world workflows used by data analysts in e-commerce and product-based companies.

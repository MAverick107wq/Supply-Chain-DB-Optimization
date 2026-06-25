# 🚛 Supply Chain & Logistics Database Optimization

## 📌 Project Overview
This project packages a massive, 100,000+ row logistics operations database into a portable SQLite workflow. It demonstrates end-to-end backend data extraction capabilities, including the full relational schema design, ingestion-ready DDL, performance-oriented indexing, and complex analytical SQL patterns designed for operational decision support.

**Tech Stack:** SQLite, Python (Google Colab / pandas for execution testing), Advanced SQL (CTEs, Window Functions)

---

## 🗄️ Entity Relationship Schema
The data model is highly normalized, centering on core operational entities and transactional facts.

### Core Master Data
* **`drivers`**: Driver identity and employment attributes.
* **`trucks`**: Fleet equipment and mechanical details.
* **`trailers`**: Trailer inventory and current status.
* **`customers`**: Customer account and routing attributes.
* **`facilities`**: Terminal and warehouse location data.
* **`routes`**: Lane definitions and pricing structures.

### Transactional & Aggregated Tables
* **Operational Flow:** `loads` ➔ `trips` ➔ `delivery_events`.
* **Friction Tracking:** `safety_incidents` and `maintenance_records`.
* **Financials:** `fuel_purchases`.
* **Aggregations:** `driver_monthly_metrics` and `truck_utilization_metrics` utilizing composite keys for fast dashboard querying.

---

## 📊 Business Problems Solved

### 1. Driver Reliability and Risk Assessment
* **The Logic:** Aggregates safety incidents by driver and utilizes **Window Functions** (`DENSE_RANK()`) to rank the most reliable and least reliable cohorts by incident volume.
* **The Impact:** Allows fleet managers to immediately identify high-risk drivers for retraining and reward top performers.

### 2. Operational Cost Volatility
* **The Logic:** Converts raw fuel purchases to a daily grain, then computes a rolling 30-day moving average using advanced `OVER()` partitions to expose cost spikes while smoothing out short-term market noise.
* **The Impact:** Provides financial analysts with a clear view of fuel expenditure trends against historical baselines.

### 3. Active SLA Breach Detection
* **The Logic:** Utilizes **Common Table Expressions (CTEs)** to isolate delivery events that missed their planned timestamps, joining facility metadata to expose the exact operational bottleneck.
* **The Impact:** Enables real-time logistical troubleshooting by pinpointing exactly where and why shipments are delayed.

---

## ⚙️ SQL Optimization Techniques
To ensure these queries run efficiently in a production environment, several backend engineering principles were applied:

* **CTEs (Common Table Expressions):** Used to break down complex temporal logic (like time-delta calculations) into stable, readable intermediate steps, optimizing the query execution plan.
* **Index Strategy:** The database avoids full-table scans by deploying targeted B-Tree indexes:
  * **Foreign Key Indexes:** Applied to `trips.driver_id`, `delivery_events.trip_id`, etc., to accelerate heavy `JOIN` operations.
  * **Time Series Indexes:** Applied to `purchase_date` and `actual_datetime` to rapidly speed up range scans and rolling time-window queries.
  * **Composite Indexes:** Deployed on combinations like `(driver_id, incident_date)` to support common multi-filter analytical access patterns.

---

## 🚀 How to Execute
The provided `schema_and_queries.sql` file contains the complete DDL, index creation statements, and the portfolio queries. 

To test this logic live:
1. Initialize a local SQLite environment or connect via Python `sqlite3`.
2. Run the DDL statements to generate the schema.
3. Execute the analytical queries. *(Note: Query outputs have been independently verified using pandas dataframes in Google Colab).*

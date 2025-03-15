# **Build Data Warehouse for Analytics and Business Insights**

This project uses **Microsoft SQL Server** to build a **Data Warehouse** from scratch, integrating data from **CRM and ERP sources**. The **ETL process** extracts raw data, performs **data cleansing and transformation**, and loads **structured data** into a star schema for business analytics.

---

## **Data Architecture**  
The data architecture follows the **Medallion Architecture** with **Bronze, Silver, and Gold layers**:  
![image](https://github.com/user-attachments/assets/4f353d0c-8bf3-4ea9-a4bf-6e83081c8029)


1. **Bronze Layer**: Stores raw data **as-is** from the CRM and ERP sources. Data is ingested into SQL Server using **CSV files**.  
2. **Silver Layer**: Processes **data cleansing, standardization, and normalization** to enhance data quality and consistency.  
3. **Gold Layer**: Stores **business-ready** data, structured into a **star schema** for analytics and reporting.

---

## **Data Flow**  
![image](https://github.com/user-attachments/assets/de2f7b38-4a81-47d0-9b4a-5c782f0bf97c)


The data flow starts with **source systems (CRM & ERP)**, where raw data is collected and stored in the **Bronze Layer**. Next, in the **Silver Layer**, the data undergoes **cleansing, standardization, and integration** to remove inconsistencies. Finally, in the **Gold Layer**, transformed data is **modeled** into fact and dimension tables, making it **ready for business intelligence and reporting**.

### **Key Steps in the Data Flow:**  
1. **Extract**: Data is pulled from CRM and ERP in **CSV format**.  
2. **Transform**: The data undergoes **deduplication, formatting, and standardization**.  
3. **Load**: The cleaned data is stored in **fact and dimension tables** for efficient querying.  

---

## **Key Relationships and Integration:**  
![image](https://github.com/user-attachments/assets/61a9d9e2-2aae-4b08-a748-bd647ff0833e)


- **CRM Data** includes **sales transactions, customer details, and product history**.  
- **ERP Data** provides **customer locations, product categories, and additional customer attributes**.  
- **Primary and Foreign Keys** establish relationships between **customers, products, and sales** across both sources.

From the diagram, we can observe:  
- **Two ERP tables** provide **customer information** that links to the **CRM customer table**.  
- **Another ERP table** provides **product category details** that relate to **CRM product data**.  

To create a meaningful business schema, we integrate these sources following the **schema structure** shown in the diagram, ensuring accuracy and consistency for analysis and reporting.
---

## **Data Model**  
![image](https://github.com/user-attachments/assets/446fb80b-8732-413f-8f7d-c031a0ba8fd1)


The **final data model** follows a **Star Schema**, consisting of:  
- **Fact Table (`fact_sales`)**: Contains **transactional sales data** with references to dimension tables.  
- **Dimension Tables**:  
  - `dim_customers` → Stores **customer details** from CRM & ERP.  
  - `dim_products` → Combines **product history and categories**.  

This model optimizes query performance, enabling **fast and efficient reporting** for business analytics.


---
## **Deployment Guide**  
Follow the **SQL scripts** to deploy the project step by step:

1. **Initialize Database & Environment**:  
   - Navigate to the `scripts` folder.
   - Run `init_database.sql` to set up the **database and schemas**.

2. **Bronze Layer - Raw Data Storage**:  
   - Go to the `bronze` folder.
   - Run `ddl_bronze.sql` to **create tables** and **define constraints** (e.g., `id INT`, `name NVARCHAR(50)`).
   - Execute `proc_load_bronze.sql` to **load data from CRM and ERP sources** into the Bronze Layer tables.

3. **Silver Layer - Data Cleansing & Transformation**:  
   - Navigate to the `silver` folder.
   - Run `ddl_silver.sql` to **create tables** for the Silver Layer (following the same steps as in the Bronze Layer).
   - Execute `proc_load_silver.sql` to **transform data from the Bronze Layer and apply data cleansing**.
   - At this stage, data in the Silver Layer is **clean and structured**.

4. **Gold Layer - Business-Ready Data Model**:  
   - Navigate to the `gold` folder.
   - Run `ddl_gold.sql` to **combine tables** based on **key relationships and integration** from the previous layers.
   - The final **star schema** is deployed, making data **ready for analytics and business insights**.

---
## **Conclusion**  
This project demonstrates how to **build a scalable data warehouse** using SQL Server, following **best practices in ETL, data modeling, and star schema design**. The structured data enables data analysts and business users to derive meaningful insights for decision-making.

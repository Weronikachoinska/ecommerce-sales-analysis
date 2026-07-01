# Pharmacy Sales Analysis
## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Dashboard Pages](#dashboard)
- [Tools & Technologies](#tools--technologies)
- [Methodology](#methodology)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [How to Run](#-how-to-run)
  
## Project overview
This project demonstrate end-to-end analysis using  Olist e-commerce dataset covering data from 09/2016 to 11/2018.

**The goal of the analysis was to:**

- Understand revenue patterns and seasonality
- Analyze customer purchasing behavior
- Analyze customer retention
- Examine impact of Black Friday season on sales
- Identify states where improves of sales are needed
- Analyze delivery factors
- Provide feasible business recommendations
  
## Dataset

The dataset was sourced from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/code). Data was imported to Python and then stored in the SQL Database.
Due to file size limitations, the raw dataset is not included in this repository.

![The dataset follows a presented below schema](olist_data_schema.png)

### Data Model
![Data Model](powerbi/data_model.png)

## Dashboard 
Dashboard is fully interacted.
![](dashboard/dashboard.gif)

 ### Dashboard Pages
![Overview](dashboard/overview_page.png)
![Customer](dashboard/customer_page.png)
![Delivery](dashboard/delivery_page.png)
![Black Friday](dashboard/black_friday_page.png)

[View dashboard PDF](Ecommerce_dashboard.pdf)

## Tools & Technologies:
- Python (Pandas, NumPy, Matplotlib)
- Jupyter Notebook
- SQL (PostgreSQL)
- Power BI 
- DAX
- Data Modeling

## Methodology

### Python
- Python was used to:
- Importing data
- Data cleaning and preprocessing(handling missing values, removing duplcates, fixing data types)
- Future Engineering
- Performing RFM and Cohort analyses

See [Jupyter Notebook](python/ecommerce-sales-analysis.ipynb)

Cleaned dataset was exported to the PostgreSQL database where data is stored.
Further analyses were performed directly in PgAdmin.

SQl was used to conduct:
- Sales Performance Analysis ([Sales Analysis](sql_analysis/Sales_performance_queries.sql))
- Product Analysis 
- Delivery Performance Analysis
- Seller Analysis
- Customer Behaviour Analysis (using customer segments from RFM analysis)
- Black Friday Analysis


SQL Analysis required using:
- JOINS
- CTE
- Window Functions
- View

PowerBi was used to:
- Presenting performed analysis in the interactive dashboard form
- Creating KPI's (using DAX measures)

See [DAX Measures](powerbi/DAX_measures.txt)



## Key insights

- Most customer purchased only once, the repeat customer rate ~3,12%.
- The largest segments are New Customers and Lost Customers, indicating a high customer turnover rate.
- Big Spenders place high-value orders despite low purchase frequency
- Weekend sales performance is weaker than weekdays.
- Increase in sales during November (Black Friday season) is observed.
- Black Friday Analysis (comparing October, November and December months) demonstrate significant impact of Black Friday season on revenue and order volume.
- During Black Friday season increase average delivery days and overall delay rate what resulted in decline average review score.
- Most orders are delivered before estimated time, while delayed orders constitute 6,77%.
- Delivery Performance analysis proves that delayed orders significantly impact on reviews.
 	

## Business Recommendations

- Consider targeted promotions and marketing campaing to customer specific, considering to which RFM segments their belong:
- Increasing Big Spender purchase frequency could significantly increase revenue.
- Loyal Customers purchase consistently and provide stable revenue. Rewarding loyalty may help maintain engagement.
- Regular customers have growth potential. Personalized promotions could encourage more frequent purchases.
- New Customers make up the largest customer segment. Converting first-time buyers into repeat customers represents the greatest opportunity for long-term growth..
- Consider targeted weekend campaigns to increase weekend sales performance
- Investigate the reason behind the significantly lower performance of some states and expand successful practices where possible.
- Control the states with the worst delay rate and the longest average delivery date and improve this to increase average review score.

## How to run

pip install -r requirements.txt


# 🎯 Kickstarter Crowdfunding Analysis 

*End-to-End Data Analytics Project using MySQL | Python | Tableau | Excel 

## 📘 Project Overview  
This project explores **Kickstarter crowdfunding campaigns** to uncover key factors influencing project success, funding goals, and backer engagement trends.  
The analysis covers the full **data analytics pipeline** — from cleaning and transforming raw data, to executing SQL-based insights, and visualizing results in professional BI dashboards.

**Dataset Size:** 365,000+ records  
**Key Attributes:** Project category, goal, pledged amount, currency, country, backers, and timestamps.

## 🧩 Objectives  
- Identify factors that drive project success across different categories and countries.  
- Analyze funding goals, pledged amounts, and backer trends over time.  
- Build interactive dashboards to communicate insights effectively to stakeholders.  
- Handle large-scale data integration challenges using SQL and Python ETL.

## 🛠 Tools & Technologies  

| Tool | Purpose |
|------|----------|
| **Excel** | Data exploration, cleaning, and KPI dashboard (Success vs Failure analysis) |
| **MySQL** | Data modeling, cleaning, and analytical queries |
| **Python** | ETL scripting and preprocessing for database ingestion |
| **Tableau** | Year-wise and goal-based trend visualization |



### Implementation

📊 **Excel — Data Cleaning & KPI Foundation**

Used Excel and Power Query for initial data cleaning, removing blanks, standardizing dates, and creating a calendar table. Built pivot dashboards to analyze success % by category, location, and goal range.
Outcome: Identified that projects with smaller goals (<$5K) and creative categories had the highest success rates.



🧮 **SQL + Python — Data Modeling & Analysis**

Python (Pandas) handled ETL: cleaned 365K+ records, converted epoch timestamps, and loaded data into MySQL. In SQL, built structured tables and queries for success %, top projects, and goal–pledge comparisons.
Outcome: Established a reliable data foundation and extracted key KPIs like success by category, goal range performance, and average campaign duration

📈 **Tableau — Trend & Story Visualization**

In Tableau created dynamic dashboards for yearly trends, goal vs pledged insights, and category success. Added filters and parameters for interactive YOY analysis.
Outcome: Highlighted post-2016 plateau in success, Q2–Q3 peaks, and the correlation between realistic goals and campaign success.



### ⚙️ **Workflow Summary**

| Step | Tool | Focus |
|------|------|-------|
| 1️⃣ Data Cleaning | **Excel** | Explore & define KPIs |
| 2️⃣ ETL & Analysis | **Python + SQL** | Clean, model & query data |
| 3️⃣ Visualization | **Tableau** | Present interactive insights |


## 🔍 Key Findings & Insights

1.**Goal Optimization Drives Success** – Campaigns with realistic goals (< $5,000) had a 40–50% higher success rate than those with larger funding targets.

2.**Category Matters** – Art, Music, and Design projects showed consistently higher success rates compared to tech-heavy categories like Hardware or Games.

3.**Geographic Impact** – The US dominated in campaign count and total funds raised, but smaller regions achieved higher average success percentages.

4.**Backer Engagement** – Projects with higher communication and early backer activity were 2× more likely to succeed.

5.**Seasonal & Yearly Trends** – Tableau timeline analysis showed Q2–Q3 spikes in new projects and funding volume, with post-2016 stabilization in success trends.

## Snapshots And Demos
### MYSQL Table Schema Snapshot

![MySQL Table Schema Snapshot](https://github.com/Suyashhh-yadav/Kick-starters_crowdfunding_analysis/blob/main/Table%20Schema%20Snapshots.png?raw=true)

### Query Analysis Snapshot
![Query Analysis Snapshot]("D:\Crowdfunding Project\Query Analysis Snapshots.png")


![Tabluea Dashboard Snapshot]("D:\Crowdfunding Project\Tableau dashboard snapshot.png")


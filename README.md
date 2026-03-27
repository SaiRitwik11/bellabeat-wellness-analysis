# Bellabeat Smart Device Usage Analysis

**Google Data Analytics Professional Certificate — Capstone Project**

| | |
|---|---|
| **Author** | Jannu Sai Ritwik |
| **Tools Used** | MySQL 8.0 · Python 3 · Microsoft Power BI |
| **Dataset** | FitBit Fitness Tracker Data — 33 users, April–May 2016 |
| **Live Dashboard** | [View Interactive Dashboard →](https://tinyurl.com/bellabeat-ritwik) |
| **Full Case Study** | [Read the Report →](./report/Bellabeat_Capstone_Jannu_Sai_Ritwik.pdf) |

---

## What This Project Is About

Bellabeat is a women's wellness technology company that makes smart fitness trackers, apps, and health-monitoring devices. Like most companies in this space, they have a wealth of product data — but the real question is: *how are people actually using these devices, and what does that tell us about where the product needs to go?*

This project uses publicly available FitBit fitness tracker data to answer that question. By analyzing real user behavior across daily activity, sleep patterns, and hourly movement — and then building an interactive dashboard to communicate the findings — the goal is to give Bellabeat's team something they can actually act on.

The analysis follows Google's six-phase data analytics framework: **Ask → Prepare → Process → Analyze → Share → Act.**

---

## The Core Findings

I went in expecting to find that more active users sleep better. The data disagreed.

Here is what the numbers actually showed:

| Metric | Value | What It Means |
|---|---|---|
| Average daily steps | 7,638 | 24% below the WHO-recommended 10,000 |
| Days hitting the step goal | 32.2% | Users miss the target on 2 out of 3 days |
| Average nightly sleep | 6h 59m | Just under the 7-hour health benchmark |
| Sleep efficiency | 91.46% | Users fall asleep quickly — duration is the real gap |
| Average sedentary time | 991 minutes/day | That is over 16 hours of inactivity daily |
| Sedentary vs. very active ratio | 47 : 1 | 991 minutes sedentary vs. 21 minutes very active |
| Peak activity hour | 6:00 PM (weekdays) | Shifts to 1:00 PM on weekends |
| Steps vs. sleep correlation | −0.22 | Weak negative — more active users do not sleep better |

The last finding was the most important one. A correlation of −0.22 between steps and sleep means the two are essentially independent. That single number changes how Bellabeat should think about its product.

---

## Three Recommendations for Bellabeat

**1. Shift gamification from "Total Steps" to "Active Minutes"**

The scatter plot tells a clear story: at the 10,000-step mark, calorie burn varies wildly from person to person. A user can hit 10,000 steps by walking slowly for 3 hours or by running hard for 30 minutes — the health outcomes are completely different. The 47:1 sedentary-to-active ratio also suggests that Bellabeat's biggest opportunity isn't getting users to walk more, it's getting them to *move with more intensity*. Rewarding Active Minutes instead of total steps would reflect what the data actually values.

**2. Deploy day-type-specific push notifications**

The activity heatmap (Day × Hour) reveals something that a simple average completely masks: user behavior differs fundamentally between weekdays and weekends. On weekdays, the peak is at 6:00 PM — post-work exercise. On weekends, it shifts to 1:00 PM — midday activity. A single notification schedule for all 7 days ignores this. Notifications sent at 5:45 PM on weekdays and 12:45 PM on weekends would intercept users exactly 15 minutes before their historically proven activity windows.

**3. Build two independent coaching algorithms — one for activity, one for sleep**

The most common assumption in the fitness app space is that if you help users move more, they'll sleep better. This dataset disproves it. With a steps-to-sleep correlation of −0.22, Bellabeat cannot assume that activity coaching will automatically improve sleep. The two dimensions need their own logic, their own goals, and their own communication strategies inside the app.

---

## How the Analysis Was Built

This project was intentionally structured to mirror how an analyst at a real company would approach this problem — not just one tool, but the right tool for each job.

### Phase 1 — Ask
Defined the business task: analyze competitor FitBit data to identify how consumers use smart fitness devices, and use those insights to guide Bellabeat's marketing strategy.

**Stakeholders:** Urška Sršen (Co-founder & CCO) and Sando Mur (Co-founder, Executive Team)

### Phase 2 — Prepare
Assessed the data before touching it. Key limitations acknowledged upfront:
- Sample size of 33 users is below statistical significance threshold
- Data is from 2016 and may not reflect current device behavior
- No demographic information available (age, gender, location)
- Sleep data covers only 24 of 33 users (72.7% coverage)
- Self-selection bias possible — motivated users may be overrepresented

These limitations do not make the data useless. They make the findings *directional*, not definitive — which is clearly stated throughout the analysis.

**Data source:** FitBit Fitness Tracker Dataset via Kaggle, licensed under public domain by Motivate International Inc.

### Phase 3 — Process (SQL)
**Tool:** MySQL 8.0 via MySQL Workbench

Used SQL for the first layer of analysis — validating the dataset, establishing benchmarks, and answering 8 structured business questions on `dailyActivity_merged.csv`. Every query is documented with a business purpose comment explaining *why* the query was written, not just what it does.

Key SQL techniques used: `COUNT DISTINCT`, `GROUP BY`, `ORDER BY`, `STR_TO_DATE`, `DAYNAME`, `CTE (WITH clause)`, `CASE WHEN`, `ROUND`

→ See [`sql/bellabeat_exploration.sql`](./sql/bellabeat_exploration.sql)  
→ Query screenshots: [`sql/outputs/`](./sql/outputs/)

### Phase 4 — Analyze (Python)
**Tool:** Python 3 via Google Colab  
**Libraries:** pandas, matplotlib

Ran 14 analyses across three datasets — daily activity, sleep, and hourly steps. This phase went deeper than SQL: segmenting users by activity level, merging datasets to test cross-variable relationships, and generating the 5 charts that feed directly into the Power BI dashboard.

The most important analysis was Q14 — the scatter plot of steps vs. sleep hours. Most people doing this project assume a positive correlation and build their recommendations around it. The data says otherwise.

Key Python techniques: `pd.read_csv`, `groupby`, `merge`, `cut`, `dt.day_name`, `dt.hour`, `matplotlib bar/line/scatter`, `axhline`

→ See [`python/bellabeat_analysis.ipynb`](./python/bellabeat_analysis.ipynb)  
→ Output charts: [`python/charts/`](./python/charts/)

### Phase 5 — Share (Power BI)
**Tool:** Microsoft Power BI Desktop  
**Live link:** [Interactive Dashboard](https://tinyurl.com/bellabeat-ritwik)

Built a 4-page interactive dashboard with a left-side navigation bar, consistent navy theme, inline insight text boxes on every visual, and a data source footer on every page. Each page is designed for a different audience.

**Page 1 — Executive Summary**
For the CEO and CMO. Three KPI gauges show the core wellness gap in under 10 seconds. Donut chart segments users by activity level. Time-of-day bar chart identifies the engagement windows.

**Page 2 — Manager Dashboard**
For product and analytics managers. The 47:1 sedentary-to-active bar chart is the centrepiece. Sleep quality distribution, weekly step trend (with a visible plateau), and a steps-vs-calories scatter showing why volume alone is the wrong metric.

**Page 3 — User Engagement & Hourly Trends**
The most differentiated page in the dashboard. A custom Activity Heatmap (Day × Hour matrix) with conditional color formatting reveals exactly when users are active across all 7 days and 24 hours. Most Bellabeat capstone submissions do not have this visual. The weekday vs. weekend behavioral split only becomes visible at this level of granularity.

**Page 4 — Analyst Deep Dive & Data Quality**
For data teams. Transparent data coverage stats (940 activity records, 413 sleep records, 22,099 hourly records). Steps-vs-sleep scatter at the user-average level confirming the −0.22 correlation. Top 5 and Bottom 5 user comparison tables.

DAX measures used: `AVERAGE`, `DIVIDE`, `COUNTROWS`, `SUMMARIZE`, `FILTER`, `MAXX`, `VAR`, `RETURN`, `SWITCH`, `IF`, `ISBLANK`

→ Dashboard screenshots: [`powerbi/`](./powerbi/)  
→ Power BI file: [`powerbi/BellaBeat_Project.pbix`](./powerbi/BellaBeat_Project.pbix)

### Phase 6 — Act
Three strategic recommendations derived directly from the data. See the [Recommendations section above](#three-recommendations-for-bellabeat) or the [full report](./report/Bellabeat_Capstone_Jannu_Sai_Ritwik.pdf) for the complete business case behind each one.

---

## Repository Structure

```
bellabeat-wellness-analysis/
│
├── README.md
│
├── data/
│   └── raw/
│       ├── dailyActivity_merged.csv
│       ├── sleepDay_merged.csv
│       └── hourlySteps_merged.csv
│
├── sql/
│   ├── bellabeat_exploration.sql
│   └── outputs/
│       ├── 1.1_total_users.png
│       ├── 1.2_Date_range_of_data.png
│       ├── 1.3_User_Tracking_Consistency.png
│       ├── 1.4_Average_Daily_Steps_and_Calories.png
│       ├── 1.5_Average_Daily_Time_by_Activity_Level.png
│       ├── 1.6_Overall_dataset_benchmark.png
│       ├── 1.7_Users_meeting_10,000_daily_steps.png
│       └── 1.8_average_steps_by_days_of_week.png
│
├── python/
│   ├── bellabeat_analysis.ipynb
│   └── charts/
│       ├── chart1_steps_by_day_of_week.png
│       ├── chart2_activity_breakdown.png
│       ├── chart3_sleep_by_day_of_week.png
│       ├── chart4_steps_by_hour_of_day.png
│       └── chart5_steps_vs_sleep.png
│
├── powerbi/
│   ├── BellaBeat_Project.pbix
│   ├── dashboard_page1_Executive.png
│   ├── dashboard_page2_manager.png
│   ├── dashboard_page3_Engagement.png
│   └── dashboard_page4_Data_quality.png
│
└── report/
    └── Bellabeat_Capstone_Jannu_Sai_Ritwik.pdf
```

---

## How to Run the SQL Queries

1. Install [MySQL 8.0](https://dev.mysql.com/downloads/) and MySQL Workbench
2. Create a new schema called `bellabeat`
3. Import `data/raw/dailyActivity_merged.csv` as a table called `dailyactivity_merged`
4. Open `sql/bellabeat_exploration.sql` in Workbench
5. Run each section individually — every query has a business purpose comment at the top explaining what it answers

## How to Run the Python Notebook

1. Go to [colab.research.google.com](https://colab.research.google.com)
2. Upload `python/bellabeat_analysis.ipynb`
3. Upload the three CSV files from `data/raw/` when prompted
4. Run all cells from top to bottom — outputs and charts will generate automatically

---

## What I Would Do Differently With More Data

This analysis is built on 33 users over one month in 2016. The findings are directional and the recommendations are grounded in the data — but I want to be honest about what a larger dataset would change:

- A sample of 300+ users would allow statistically significant segment analysis
- Demographic data (age, gender, city) would enable far more targeted recommendations
- A 6–12 month dataset would reveal seasonal behavior patterns currently invisible here
- More recent data (post-2020) would better reflect current device usage habits

These are not reasons to dismiss the findings. They are reasons to treat this as a starting point for a larger research program — which is exactly what a real analyst would recommend to their stakeholders.

---

## About This Project

This capstone was completed as part of the **Google Data Analytics Professional Certificate** (9 courses, March 2026).

The portfolio also includes a completed **Ecommerce Sales Analytics** project using MySQL — 25 business queries across a 5-table database, available at [github.com/SaiRitwik11/ecommerce-sql-analytics](https://github.com/SaiRitwik11/ecommerce-sql-analytics).

---

**Jannu Sai Ritwik** · Data Analyst · Hyderabad, India  
[LinkedIn Profile](https://linkedin.com/in/sai-ritwik-dataanalyst) · [Ecommerce SQL Project](https://github.com/SaiRitwik11/ecommerce-sql-analytics)

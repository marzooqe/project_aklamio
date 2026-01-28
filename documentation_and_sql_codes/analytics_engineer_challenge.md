# Analytics Engineer Challenge: Referral Campaign Performance Analysis

## Overview

This challenge is designed to assess your skills in SQL, data modeling, analytics thinking, and business communication. You should be able to complete this in **3-4 hours**. The focus is on demonstrating your ability to work with real-world data, design meaningful metrics, and communicate insights effectively.

## Business Context

Aklamio's Customer Incentives Platform enables enterprises to enhance their marketing efforts with referral programs. Each customer (company) has a custom recommendation landing page where users can recommend products. We collect event data when users interact with these pages.

**Key Concepts:**
- **Customer**: A company using Aklamio's platform (e.g., IONOS) that offers products/services
- **User**: An individual person who visits a recommendation page and may recommend a product
- **ReferralPageLoad**: Event fired when a user visits a recommendation page
- **ReferralRecommendClick**: Event fired when a user clicks the "Recommend" button
- **Event ID**: The same `event_id` can appear with different `event_type` values, linking related events (e.g., a page load and subsequent click share the same `event_id`)

## The Data

You have been provided with a JSONL file (`aklamio_challenge.json`) containing event data. Each line is a valid JSON object with the following structure:

```
{
  "event_id": "unique-event-identifier",
  "customer_id": 12,
  "user_id": 12345,
  "fired_at": "01/05/2022, 14:23:15",
  "event_type": "ReferralPageLoad",
  "ip": "192.168.1.1",
  "email": "user@example.com"
}
```

**Important Data Characteristics:**
- The same `event_id` may appear multiple times with different `event_type` values. This links related events (e.g., a `ReferralPageLoad` and subsequent `ReferralRecommendClick` may share the same `event_id`).
- The data may contain quality issues (e.g., invalid event types, missing values) that you'll need to identify and handle appropriately.
- Additional event types may be present (e.g., `FaqClick`) that you can optionally include in your analysis.
- Date format is "MM/DD/YYYY, HH:MM:SS" and will need proper parsing for time-based analysis.

## Your Tasks

### Part 1: Exploratory Data Analysis (30-45 minutes)

**Objective**: Understand the data quality, structure, and characteristics.

**Deliverables**:
1. **Data Quality Assessment**: Create a SQL query (or Python script if you prefer) that identifies:
   - Missing/null values by field
   - Duplicate events (if any) - note that the same `event_id` with different `event_type` is expected and represents related events
   - Invalid or unexpected event types (e.g., `EMPTY_VALUE`)
   - Data type inconsistencies
   - Date/time format issues and parsing requirements
   - Any anomalies or unexpected patterns (e.g., events with same `event_id` but different `customer_id` or `user_id`)

2. **Data Summary**: Provide a brief written summary (2-3 paragraphs) describing:
   - Overall data quality and any issues found
   - Your approach to handling nulls, duplicates, and data quality issues
   - Any assumptions you made about the data

**SQL Focus**: Use SQL to perform the data quality checks. If you use Python, keep it minimal and focus on SQL for the actual analysis.

### Part 2: Data Modeling (45-60 minutes)

**Objective**: Design an analytics-ready data model using dimensional modeling principles.

**Requirements**:
1. Design a star schema (fact and dimension tables) suitable for analytics and dashboarding
2. Create SQL DDL statements to create these tables in Snowflake (or PostgreSQL if you prefer)
3. Write SQL transformation queries that:
   - Clean and standardize the raw event data
   - Populate your dimension tables
   - Populate your fact table(s)
   - Handle the data quality issues you identified in Part 1

**Deliverables**:
- SQL DDL for all tables (with comments explaining your design choices)
- SQL transformation queries (with comments explaining your logic)
- A brief explanation (1-2 paragraphs) of your modeling decisions:
  - Why you chose this structure
  - How it supports analytics use cases
  - Any trade-offs you considered

**Key Considerations**:
- Think about how business users will query this data
- Consider time-based analysis (hourly, daily, weekly aggregations)
- Ensure the model is maintainable and extensible

### Part 3: KPI and Metric Design (60-75 minutes)

**Objective**: Design meaningful business metrics and KPIs that answer key business questions.

**Business Questions to Answer**:
1. How effective are our referral campaigns at driving user engagement?
2. Which customers are seeing the best performance from their referral programs?
3. What patterns exist in user behavior (e.g., time of day, day of week)?
4. How can we identify high-performing vs. low-performing campaigns?

**Requirements**:
1. **Define 5-7 KPIs/metrics** that address the business questions above. For each metric:
   - Provide a clear business definition
   - Explain why it's valuable
   - Write the SQL query to calculate it
   - Include any necessary filters or time windows

2. **Calculate the metrics** using SQL queries against your modeled data:
   - Metrics should be calculated at appropriate granularities (e.g., customer + hour, customer + day)
   - Include any necessary aggregations and window functions
   - Ensure calculations are correct and handle edge cases

**Example Metrics** (you should define your own, but these illustrate the type):
- Click-through rate (CTR): Percentage of page loads that result in a recommendation click (hint: you can relate clicks to page loads via `event_id` or by matching `user_id` + `customer_id` within a time window)
- Unique user engagement rate
- Conversion funnel metrics
- Time-to-click metrics

**Note on Relating Events**: You can relate `ReferralRecommendClick` events to `ReferralPageLoad` events using:
- The same `event_id` (if they share one)
- Matching `user_id` + `customer_id` within a reasonable time window
- Or a combination of both approaches

Make a reasonable assumption, document it, and explain your rationale.

**Deliverables**:
- A document listing all metrics with:
  - Metric name
  - Business definition and rationale
  - SQL query
  - Sample results (first 10 rows)
- SQL queries saved as separate files or clearly marked in your submission

### Part 4: Visualization and Delivery (30-45 minutes)

**Objective**: Design a dashboard and visualizations that communicate insights effectively.

**Requirements**:
Since we don't require specific visualization tools, please provide:

1. **Dashboard Design Document**: Describe a dashboard layout with 4-6 visualizations that would help Product and Revenue teams understand referral campaign performance.

2. **For each visualization**, provide:
   - **Chart type** (e.g., line chart, bar chart, table, etc.)
   - **Title and description**
   - **Metrics/dimensions displayed**
   - **Business rationale**: Why this visualization is valuable
   - **SQL query** that would power this visualization
   - **Key insights** you would expect to see or highlight

3. **Executive Summary**: Write a summary (2-3 paragraphs) that:
   - Highlights the top 3-5 insights from your analysis
   - Provides actionable recommendations
   - Explains the business impact

**Example Visualization Structure**:
```
Visualization 1: Campaign Performance Over Time
- Type: Line chart
- Metrics: Daily CTR, Daily unique users
- Dimensions: Date, Customer
- Rationale: Shows trends and helps identify successful campaigns
- SQL: [your query]
- Expected Insights: [what patterns would you look for]
```

## Technical Requirements

### SQL Focus
- All data transformations and calculations should be done in SQL
- Use clear, readable SQL with comments
- Follow SQL best practices (CTEs, proper joins, etc.)
- Optimize for readability and maintainability

### Python (Optional)
- Python may be used for exploratory analysis if you prefer
- If used, keep it minimal and focus on SQL for the core work
- No heavy frameworks required (pandas is fine for exploration)

### Code Quality
- Write production-ready code
- Include comments explaining your logic
- Use meaningful variable/table names
- Handle edge cases appropriately

## Submission Format

Please organize your submission as follows:

```
your_submission/
├── README.md                    # Overview of your approach and any assumptions
├── 01_exploratory_analysis/
│   ├── data_quality_queries.sql
│   ├── data_quality_summary.md
│   └── [optional] exploratory_analysis.py
├── 02_data_modeling/
│   ├── ddl_statements.sql
│   ├── transformation_queries.sql
│   └── modeling_decisions.md
├── 03_metrics_and_kpis/
│   ├── metrics_definitions.md
│   └── metric_queries.sql
├── 04_visualization/
│   ├── dashboard_design.md
│   └── visualization_queries.sql
├── executive_summary.md
└── ai_prompts.md     # If you used AI tools, please include the prompts you used
```

**Note**: If you used AI tools or LLMs during this challenge, please include a file (e.g., `ai_prompts.md`) documenting the prompts you used.

## Evaluation Criteria

Your submission will be evaluated on:

1. **SQL Skills** (30%): Code quality, query optimization, proper use of SQL features
2. **Data Modeling** (25%): Appropriate dimensional modeling, design decisions, maintainability
3. **Analytics Thinking** (25%): Metric design, business understanding, insight quality
4. **Communication** (20%): Clarity of explanations, documentation quality, visualization design

## Important Notes

- **Time Management**: This challenge is designed for 3-4 hours. Focus on demonstrating your thought process and skills rather than perfection.
- **Assumptions**: Make reasonable assumptions and document them clearly. There is no single "correct" answer.
- **LLM Usage**: You may use LLMs or other tools. However, ensure you understand and can explain your solution. We will discuss your approach in detail during the interview. **If you use AI tools, please share the prompts you used** as part of your submission.
- **Questions**: If anything is unclear, make a reasonable assumption and document it in your README.

## Getting Started

1. Review the data file (`aklamio_challenge.json`)
2. Set up a local database (PostgreSQL recommended)
3. Load the data into a staging table
4. Begin with exploratory analysis

## Data Loading Helper

If you need help loading the JSONL file, here's a sample approach:

**PostgreSQL**:
```sql
-- Create staging table
CREATE TABLE raw_events_staging (
    event_data JSONB
);

-- Load data (adjust path as needed)
-- Using psql: \copy raw_events_staging FROM 'aklamio_challenge.json';

-- Parse JSON into structured table with proper date parsing
CREATE TABLE raw_events AS
SELECT
    event_data->>'event_id' AS event_id,
    (event_data->>'customer_id')::INTEGER AS customer_id,
    (event_data->>'user_id')::INTEGER AS user_id,
    -- Parse date: "MM/DD/YYYY, HH:MM:SS" format
    TO_TIMESTAMP(event_data->>'fired_at', 'MM/DD/YYYY, HH24:MI:SS') AS fired_at,
    event_data->>'event_type' AS event_type,
    event_data->>'ip' AS ip,
    event_data->>'email' AS email
FROM raw_events_staging;

-- Alternative date parsing if the above doesn't work in your database:
-- For PostgreSQL, you might need: TO_TIMESTAMP(event_data->>'fired_at', 'MM/DD/YYYY, HH24:MI:SS')
-- For Snowflake: TO_TIMESTAMP(event_data->>'fired_at', 'MM/DD/YYYY, HH24:MI:SS')
-- Check your database documentation for the correct date parsing function
```

**Python (optional)**:
```python
import json
import pandas as pd

# Load JSONL
events = []
with open('aklamio_challenge.json', 'r') as f:
    for line in f:
        events.append(json.loads(line))

df = pd.DataFrame(events)
# Then load to database or work with directly
```

Good luck! We're looking forward to seeing your solution.

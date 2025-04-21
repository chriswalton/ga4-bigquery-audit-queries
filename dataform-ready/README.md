🚀 Deploy This GA4 Audit Framework in Dataform
This folder contains a full Dataform setup for auditing GA4 BigQuery data.

📁 What’s Inside
models/base/ → Cleaned and structured GA4 base tables

assertions/ → Weekly QA checks for data integrity

models/reports/ → Summary tables for dashboards and tracking

utils/ → Shared helper functions and constants

dataform.json → Project config (with dynamic vars)

✅ Setup Instructions
Clone or fork this repo.

Open Dataform Web (https://dataform.co) and create a new project.

Connect to your BigQuery warehouse and grant permission to write to a dataset.

Replace project variables in dataform.json:

json
Copy
Edit
{
  "vars": {
    "project_id": "your-gcp-project-id",
    "dataset": "your_bigquery_dataset"
  }
}
In Dataform, go to the "Files" tab → click “Upload Files” → drag in everything inside the /dataform-ready/ folder.

Click “Compile” and then “Run All”.

🧠 What This Enables
Once deployed, you get:

🧼 Base tables: Clean, queryable GA4 session, user, transaction, and consent data

🔍 Automated assertions: Weekly checks for missing IDs, broken funnels, malformed UTMs, bot-like behaviour, and consent gaps

📊 Rollup reports: High-level QA summaries and performance metrics by source/funnel
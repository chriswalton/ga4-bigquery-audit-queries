# GA4 BigQuery Audit Query Library

This is a curated, production-ready library of BigQuery SQL snippets designed to audit, debug, and optimise your **Google Analytics 4** data.

Each query is built for **dynamic use** and focuses on **data quality, performance bottlenecks, attribution, consent compliance**, and **strategic decision-making**.

---

## 🔍 What’s Inside

| Category | Description |
|----------|-------------|
| [`user-identification`](./queries/user-identification) | Check login loops, missing IDs, consent flags |
| [`ecommerce-validation`](./queries/ecommerce-validation) | Detect broken or misfired e-commerce events |
| [`event-session-quality`](./queries/event-session-quality) | Bounce detection, bot loops, and misfires |
| [`campaign-attribution`](./queries/campaign-attribution) | Flag broken/missing UTM and GCLID parameters |
| [`custom-event-hygiene`](./queries/custom-event-hygiene) | Detect misuse of parameters and high-cost events |
| [`bot-detection`](./queries/bot-detection) | Identify sessions with bot-like behaviour |
| [`timezone-timestamp`](./queries/timezone-timestamp) | Debug clock drift, timestamp spikes |
| [`consent-gdpr`](./queries/consent-gdpr) | See conversion breakdown by consent status |
| [`device-platform`](./queries/device-platform) | Test conversion by browser/OS/device/screen |
| [`broken-pathways`](./queries/broken-pathways) | Analyse traffic to 404s and broken flows |
| [`strategic-insights`](./queries/strategic-insights) | Spot low-converting segments, event ROI |
| [`dataform-ready`](./dataform-ready) | Optional: use these queries in [Dataform](https://dataform.co) pipelines |

---

## 🛠️ How to Use

All queries include dynamic placeholders:

{{PROJECT_ID}} {{DATASET}} {{START_DATE}} {{END_DATE}}


You can:
- Paste into BigQuery directly
- Find + replace placeholders
- Use programmatically (in Looker, Dataform, dbt, etc.)

---

## 💡 Recommended Workflow

1. 🔎 Run audits monthly to spot issues early  
2. 📈 Use strategic queries to improve ROI  
3. 🔐 Regularly check consent + user ID coverage  
4. 🧼 Keep custom events clean to avoid cost/sampling

---

## 🤝 Contributions & Credits

Created by [@chriswalton](https://github.com/chriswalton)  
As part of https://www.netimpression.co.uk/
Feedback, PRs, and ideas welcome!  
Raise an issue or submit a pull request ✌️

---

## License

MIT License — free to use, adapt, and share.

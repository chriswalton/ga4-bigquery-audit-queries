# 🧼 Custom Event & Parameter Hygiene

Ensure your custom events and parameters are well-structured, complete, and not bloating your event volume or exceeding limits.

## Queries

- **Events with Excessive Parameters (High Avg)**  
  Identifies events with a high average number of parameters, which may increase cost or risk quota issues.

- **Top 20 Custom Events (Excludes GA Defaults)**  
  Lists the most fired custom events to help audit naming conventions and track usage.

- **Missing or Invalid eCommerce Parameters**  
  Audits key ecommerce events for required fields like `item_id`, `currency`, `value`, etc., and flags missing or invalid entries.

- **Suspicious or Default Parameter Values**  
  Detects events where parameter values are suspicious (e.g., "null", "undefined", "NaN", or empty strings).

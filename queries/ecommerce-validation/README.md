# 🛒 E-commerce & Transaction Validation

This section helps you identify issues in your purchase funnel, duplicate orders, or mismatches with backend transaction data.

## Queries

- **Duplicate transaction_ids across sessions or days**  
  Flags repeated transaction IDs—useful to detect duplicate tracking or checkout retries.

- **Compare GA4 Revenue to Backend Source**  
  Compares GA4 purchase revenue totals per transaction ID against your backend data to catch discrepancies.

- **Purchases Without Funnel Events**  
  Shows how many purchases occurred without a preceding `add_to_cart` or `begin_checkout`, which could indicate tagging gaps.

- **Purchases Without Items**  
  Flags purchases that are missing item arrays (empty or null), which may result in loss of ecommerce reporting detail.

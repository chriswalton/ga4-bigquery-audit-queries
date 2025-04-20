# 🤖 Bot or Anomaly Detection

This section includes queries to identify suspicious traffic patterns that may indicate bots, misfiring tags, or tracking anomalies. These patterns are helpful to isolate problematic traffic sources or invalid sessions before analysis.

## Queries

- **Abnormally Short or Long Sessions**  
  Detects sessions with either very short durations (<2s) or very long ones (>30min), which may indicate bot behaviour or session misfires.

- **Users with 100+ Sessions in One Day**  
  Flags user_pseudo_ids with an unusually high number of distinct sessions on the same day—a common bot signature.

- **Click Loop: Single Event Type Repeated**  
  Identifies sessions with only one unique event type repeated many times (e.g., >50 times), possibly indicating broken tracking loops.

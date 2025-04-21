# 📊 Campaign & Attribution Issues

This section includes queries to validate campaign tracking integrity and detect common attribution errors such as missing UTM parameters or mismatched sources.

## Queries

- **Malformed or Missing UTM Parameters**  
  Lists events with null or '(not set)' values for traffic_source.source or medium, indicating broken campaign links.

- **Too Many Unique Campaign/Source/Medium**  
  Counts distinct values for traffic_source.name, source, and medium—useful to detect tagging inconsistencies or ungoverned campaign parameters.

- **Sessions with gclid but Not Google as Source**  
  Identifies sessions where a `gclid` is present but the source is not Google, which may point to tracking mismatches or spoofed parameters.

- **ChatGPT Sessions by Day**  
Counts daily sessions where traffic_source.source contains “chatgpt”, highlighting AI‑driven traffic trends over time.
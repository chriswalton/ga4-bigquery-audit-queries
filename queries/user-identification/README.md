# 👤 User Identification & Login

Track how well your platform is identifying users and managing authentication events. Useful for debugging login friction or user stitching issues.

## Queries

- **Anonymous Key Events Breakdown**  
  Compares the number of key events (e.g., `purchase`, `login`) that occur with and without a user_id present.

- **Missing Identifier Coverage by Event**  
  Summarises how often user_id or user_pseudo_id is missing per event.

- **Sessions with Multiple Logins**  
  Flags sessions where the `login` event fires more than once—potential indicator of login loops or friction.

- **Multiple user_ids for One user_pseudo_id**  
  Identifies cases where a single pseudo_id (device) has multiple user_ids assigned—potential issues with user stitching or identity resolution.

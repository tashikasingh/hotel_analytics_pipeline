# Connecting this project to your Snowflake trial

1. Sign up free at https://signup.snowflake.com (no card required, 30-day trial).
2. Note your **account identifier** (shown in the Snowflake URL, e.g. `abcd-xy12345`), your
   **username**, and the **password** you set.
3. In Snowflake's UI, create a warehouse, database, and schema for this project (or use the
   defaults `COMPUTE_WH` / your trial database / `PUBLIC`).
4. Install the Snowflake adapter locally:
   ```bash
   pip install dbt-snowflake
   ```
5. Replace the contents of `~/.dbt/profiles.yml` with:
   ```yaml
   hotel_analytics_pipeline:
     target: dev
     outputs:
       dev:
         type: snowflake
         account: <your_account_identifier>
         user: <your_username>
         password: <your_password>
         role: ACCOUNTADMIN
         database: <your_database>
         warehouse: COMPUTE_WH
         schema: PUBLIC
         threads: 4
   ```
6. Run `dbt seed && dbt run && dbt test` again — same commands, now pointed at real Snowflake.
7. Push the whole project folder to a new GitHub repo, e.g. `hotel-analytics-pipeline`.

Once this is done, everything in the README and every test result is genuinely true for your
Snowflake instance, not just the local build.

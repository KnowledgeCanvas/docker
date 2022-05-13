# Knowledge Canvas Docker
A self-hosted (Docker) solution for common Knowledge Canvas dependencies.

## What's included?
- Tika: Text and metadata extraction
- Elastic stack: 
  - Elasticsearch: Provides search capabilities across user documents (Knowledge Sources)
  - Kibana: Provides visualization and dashboards capabilities
  - Enterprise Search: Provides integration with Google Drive, One Drive, etc.

## Setup and Run
1. Modify the `.env` file, supply values for `ELASTIC_PASSWORD` and `KIBANA_PASSWORD`
2. Run `docker-compose up` (v1) or `docker compose up` (v2)
3. Verify Kibana is working by navigating to `localhost:5601` or `127.0.0.1:5601` in your browser.

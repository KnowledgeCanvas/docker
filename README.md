# Knowledge Canvas Docker
A self-hosted (Docker) solution for common Knowledge Canvas dependencies.

## What's included?
- Tika: Text and metadata extraction
- Elastic stack: 
  - Elasticsearch: Provides search capabilities across user documents (Knowledge Sources)
  - Kibana: Provides visualization and dashboards capabilities
  - Enterprise Search: Provides integration with Google Drive, One Drive, etc.

## Setup and Run

### Tika
Run the following commands from the root folder (`./knowledge-canvas-docker/`:
```shell
  docker build -t tika-server .
  docker run -d -p 9998:9998 tika-server
```

### Elastic
1. Modify the `.env` file, supply values for `ELASTIC_PASSWORD` and `KIBANA_PASSWORD`
2. Run:
```shell
docker-compose up #(version 1)

# OR 

docker compose up #(version 2)
```
3. Verify Kibana is working by navigating to `localhost:5601` or `127.0.0.1:5601` in your browser. The username is `elastic`, use the password setup in step 1.

CREATE TABLE IF NOT EXISTS aklamio_challenge (
    id BIGSERIAL PRIMARY KEY,
    payload JSONB NOT NULL,
    ingested_at TIMESTAMP DEFAULT now()
);

TRUNCATE TABLE aklamio_challenge;

COPY aklamio_challenge (payload)
FROM '/docker-entrypoint-initdb.d/aklamio_challenge.json';
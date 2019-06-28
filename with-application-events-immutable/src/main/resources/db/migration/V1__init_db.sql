CREATE TABLE IF NOT EXISTS CREDIT_CARD (
  ID            UUID PRIMARY KEY,
  INITIAL_LIMIT DECIMAL(18,2) NOT NULL,
  USED_LIMIT    DECIMAL(18,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS WITHDRAWAL (
  ID     UUID PRIMARY KEY,
  CARD_ID   UUID    NOT NULL,
  AMOUNT DECIMAL(18,2) NOT NULL
);

INSERT INTO credit_card (ID, INITIAL_LIMIT, USED_LIMIT) VALUES
  ('3a3e99f0-5ad9-47fa-961d-d75fab32ef0e', 10000, 0);

COMMIT;
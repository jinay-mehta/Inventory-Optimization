-- Base schema setup and performance indexes for Urban Retail Co.
-- PostgreSQL schema definitions aligned with assets/erd_2.png

-- Raw daily inventory, sales, forecast, pricing, and external factor records
CREATE TABLE IF NOT EXISTS inventory_facts (
    date DATE,
    store_id TEXT,
    product_id TEXT,
    category TEXT,
    region TEXT,
    inventory_level INTEGER,
    units_sold INTEGER,
    units_ordered INTEGER,
    demand_forecast NUMERIC,
    price NUMERIC,
    discount INTEGER,
    weather_condition TEXT,
    "holiday/promotion" INTEGER,
    competitor_pricing NUMERIC,
    seasonality TEXT
);

-- Enriched inventory table extending inventory_facts with available stock
CREATE TABLE IF NOT EXISTS productinventory (
    date DATE,
    store_id TEXT,
    product_id TEXT,
    category TEXT,
    region TEXT,
    inventory_level INTEGER,
    units_sold INTEGER,
    units_ordered INTEGER,
    demand_forecast NUMERIC,
    price NUMERIC,
    discount INTEGER,
    weather_condition TEXT,
    "holiday/promotion" INTEGER,
    competitor_pricing NUMERIC,
    seasonality TEXT,
    available_stock INTEGER
);

-- Query performance indexes on common filter and grouping dimensions
CREATE INDEX IF NOT EXISTS idx_inventory_facts_date
    ON inventory_facts (date);

CREATE INDEX IF NOT EXISTS idx_inventory_facts_store_product
    ON inventory_facts (store_id, product_id);

CREATE INDEX IF NOT EXISTS idx_inventory_facts_date_store_product_region
    ON inventory_facts (date, store_id, product_id, region);

CREATE INDEX IF NOT EXISTS idx_productinventory_dims
    ON productinventory (product_id, category, region, store_id);

CREATE INDEX IF NOT EXISTS idx_productinventory_store
    ON productinventory (store_id);

CREATE INDEX IF NOT EXISTS idx_productinventory_category
    ON productinventory (category);

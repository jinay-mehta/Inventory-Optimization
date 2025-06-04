-- Inventory Turnover & COGS Analysis
-- Evaluates turnover efficiency across products, stores, categories, and combined dimensions

-- 1. Product-level inventory turnover
DROP TABLE IF EXISTS product_turnover_analysis;

CREATE TABLE product_turnover_analysis AS
WITH ProductStats AS (
    SELECT
        product_id,
        SUM(units_sold * price) AS cogs,
        AVG(inventory_level) AS avg_inventory
    FROM
        productinventory
    GROUP BY
        product_id
),
Turnover AS (
    SELECT
        product_id,
        cogs,
        avg_inventory,
        CASE
            WHEN avg_inventory > 0 THEN cogs / avg_inventory
            ELSE NULL
        END AS inventory_turnover
    FROM
        ProductStats
)
SELECT
    product_id,
    cogs,
    avg_inventory,
    inventory_turnover
FROM
    Turnover
ORDER BY
    inventory_turnover DESC;

-- 2. Store-level inventory turnover
DROP TABLE IF EXISTS store_turnover_analysis;

CREATE TABLE store_turnover_analysis AS
WITH StoreStats AS (
    SELECT
        store_id,
        SUM(units_sold * price) AS cogs,
        AVG(inventory_level) AS avg_inventory
    FROM
        productinventory
    GROUP BY
        store_id
),
Turnover AS (
    SELECT
        store_id,
        cogs,
        avg_inventory,
        CASE
            WHEN avg_inventory > 0 THEN cogs / avg_inventory
            ELSE NULL
        END AS inventory_turnover
    FROM
        StoreStats
)
SELECT
    store_id,
    cogs,
    avg_inventory,
    inventory_turnover
FROM
    Turnover
ORDER BY
    inventory_turnover DESC;

-- 3. Category-level inventory turnover
DROP TABLE IF EXISTS category_turnover_analysis;

CREATE TABLE category_turnover_analysis AS
WITH CategoryStats AS (
    SELECT
        category,
        SUM(units_sold * price) AS cogs,
        AVG(inventory_level) AS avg_inventory
    FROM
        productinventory
    GROUP BY
        category
),
Turnover AS (
    SELECT
        category,
        cogs,
        avg_inventory,
        CASE
            WHEN avg_inventory > 0 THEN cogs / avg_inventory
            ELSE NULL
        END AS inventory_turnover
    FROM
        CategoryStats
)
SELECT
    category,
    cogs,
    avg_inventory,
    inventory_turnover
FROM
    Turnover
ORDER BY
    inventory_turnover DESC;

-- 4. Multi-dimensional inventory turnover (product, category, store, and region)
DROP TABLE IF EXISTS inventory_turnover_analysis_2;

CREATE TABLE inventory_turnover_analysis_2 AS
WITH InventoryStats AS (
    SELECT
        product_id,
        category,
        region,
        store_id,
        SUM(units_sold * price) AS cogs, -- Approximate Cost of Goods Sold
        AVG(inventory_level) AS avg_inventory -- Average Inventory Level
    FROM
        productinventory
    GROUP BY
        product_id, category, region, store_id
),
Turnover AS (
    SELECT
        product_id,
        category,
        store_id,
        region,
        cogs,
        avg_inventory,
        CASE
            WHEN avg_inventory > 0 THEN cogs / avg_inventory
            ELSE NULL -- Avoid division by zero
        END AS inventory_turnover
    FROM
        InventoryStats
)
SELECT
    product_id,
    category,
    store_id,
    region,
    cogs,
    avg_inventory,
    inventory_turnover
FROM
    Turnover
ORDER BY
    inventory_turnover DESC; -- High turnover indicates fast-moving products

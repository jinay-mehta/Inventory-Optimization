-- Stock Adjustment & Replenishment Optimization
-- Identifies overstocked/understocked SKUs and calculates daily adjustment quantities

-- 1. Categorical stock adjustment recommendations by product, category, and region
DROP TABLE IF EXISTS stock_adjustment_recommendations;

CREATE TABLE stock_adjustment_recommendations AS
SELECT
    product_id,
    category,
    region,
    AVG(inventory_level) AS avg_inventory,
    SUM(units_sold) AS total_units_sold,
    CASE
        WHEN SUM(units_sold) < AVG(inventory_level) * 0.5 THEN 'Reduce Stock'
        WHEN SUM(units_sold) > AVG(inventory_level) * 1.5 THEN 'Increase Stock'
        ELSE 'Stock Level Optimal'
    END AS stock_adjustment_recommendation
FROM
    productinventory
GROUP BY
    product_id, category, region
ORDER BY
    product_id;

-- 2. Daily store-product stock projection and quantitative adjustment recommendation
DROP TABLE IF EXISTS stock_adjustment;

CREATE TABLE stock_adjustment AS
SELECT
    date,
    store_id,
    product_id,
    inventory_level,
    units_sold,
    units_ordered,
    demand_forecast,

    -- Calculate projected stock after sales
    inventory_level - units_sold AS projected_inventory,

    -- Adjustment suggestion
    CASE
        WHEN inventory_level - units_sold < demand_forecast THEN
            CEIL(demand_forecast - (inventory_level - units_sold)) -- Need to restock
        WHEN inventory_level > demand_forecast * 1.5 THEN
            -CEIL(inventory_level - demand_forecast * 1.2) -- Over-stocked, reduce future orders
        ELSE 0 -- Stock level is fine
    END AS stock_adjustment_recommendation
FROM
    inventory_facts;

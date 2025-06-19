-- Supplier Performance & Delivery Gap Analysis
-- Compares ordered vs. sold quantities against forecasted demand to flag fulfillment risks

DROP TABLE IF EXISTS supplier_performance;

CREATE TABLE supplier_performance AS
SELECT
    date,
    store_id,
    product_id,
    region,
    SUM(units_ordered) AS total_ordered,
    SUM(units_sold) AS total_sold,
    SUM(units_ordered - units_sold) AS delivery_gap,
    AVG(demand_forecast) AS avg_forecast,
    SUM(inventory_level) AS stock_available,
    CASE
        WHEN SUM(units_ordered) - SUM(units_sold) > 30 THEN 'Possible Overstock'
        WHEN SUM(units_ordered) - SUM(units_sold) < -30 THEN 'Possible Stockout (Supplier Delay)'
        ELSE 'Normal'
    END AS supplier_performance_flag
FROM
    inventory_facts
GROUP BY
    date, store_id, product_id, region;

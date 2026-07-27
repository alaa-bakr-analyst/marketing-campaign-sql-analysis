-- Marketing Campaign Performance Analysis
-- PostgreSQL / Neon compatible

DROP TABLE IF EXISTS marketing_campaigns;

CREATE TABLE marketing_campaigns (
    campaign_id INTEGER PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    channel VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    device VARCHAR(20) NOT NULL,
    spend NUMERIC(10,2) NOT NULL,
    impressions INTEGER NOT NULL,
    clicks INTEGER NOT NULL,
    conversions INTEGER NOT NULL,
    revenue NUMERIC(10,2) NOT NULL,
    campaign_date DATE NOT NULL
);

INSERT INTO marketing_campaigns (
    campaign_id, campaign_name, channel, country, device,
    spend, impressions, clicks, conversions, revenue, campaign_date
)
VALUES
(1, 'Summer Sale', 'Google Ads', 'UAE', 'Mobile', 1200, 24000, 960, 72, 7200, '2026-01-05'),
(2, 'Summer Sale', 'Instagram', 'UAE', 'Mobile', 800, 21000, 840, 58, 5100, '2026-01-06'),
(3, 'New Year Offers', 'Facebook', 'Saudi Arabia', 'Desktop', 950, 18000, 720, 45, 4300, '2026-01-08'),
(4, 'New Year Offers', 'Google Ads', 'Saudi Arabia', 'Mobile', 1350, 27000, 1080, 81, 8600, '2026-01-10'),
(5, 'Brand Awareness', 'LinkedIn', 'UAE', 'Desktop', 700, 12000, 360, 18, 1900, '2026-01-12'),
(6, 'Winter Deals', 'Instagram', 'Egypt', 'Mobile', 600, 17000, 680, 39, 3300, '2026-01-14'),
(7, 'Winter Deals', 'Facebook', 'Egypt', 'Desktop', 650, 16000, 560, 31, 2700, '2026-01-16'),
(8, 'App Promotion', 'Google Ads', 'UAE', 'Mobile', 1100, 23000, 920, 69, 6900, '2026-01-18'),
(9, 'App Promotion', 'Instagram', 'Saudi Arabia', 'Mobile', 900, 22000, 880, 62, 5900, '2026-01-20'),
(10, 'Lead Generation', 'LinkedIn', 'Saudi Arabia', 'Desktop', 1000, 15000, 450, 29, 4100, '2026-01-22'),
(11, 'Flash Sale', 'Facebook', 'UAE', 'Mobile', 750, 19000, 760, 51, 4800, '2026-02-02'),
(12, 'Flash Sale', 'Google Ads', 'Egypt', 'Desktop', 980, 20000, 800, 56, 5700, '2026-02-04'),
(13, 'Valentine Offers', 'Instagram', 'UAE', 'Mobile', 850, 21500, 860, 64, 6200, '2026-02-06'),
(14, 'Valentine Offers', 'Facebook', 'Saudi Arabia', 'Mobile', 780, 19500, 780, 48, 4500, '2026-02-08'),
(15, 'Lead Generation', 'LinkedIn', 'Egypt', 'Desktop', 620, 11000, 330, 16, 2100, '2026-02-10'),
(16, 'Retargeting', 'Google Ads', 'UAE', 'Desktop', 900, 16500, 660, 54, 6000, '2026-02-12'),
(17, 'Retargeting', 'Facebook', 'Saudi Arabia', 'Mobile', 720, 17500, 700, 46, 4200, '2026-02-14'),
(18, 'Brand Awareness', 'Instagram', 'Egypt', 'Mobile', 500, 14500, 580, 27, 2300, '2026-02-16'),
(19, 'Product Launch', 'Google Ads', 'Saudi Arabia', 'Desktop', 1500, 30000, 1200, 92, 9800, '2026-02-18'),
(20, 'Product Launch', 'Instagram', 'UAE', 'Mobile', 1050, 25500, 1020, 76, 7600, '2026-02-20');

-- 1) Check that the data was loaded
SELECT *
FROM marketing_campaigns
ORDER BY campaign_id;

-- 2) Overall KPIs
SELECT
    SUM(spend) AS total_spend,
    SUM(revenue) AS total_revenue,
    SUM(revenue - spend) AS total_profit,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_percentage,
    ROUND(SUM(conversions) * 100.0 / SUM(clicks), 2) AS conversion_rate_percentage,
    ROUND((SUM(revenue) - SUM(spend)) * 100.0 / SUM(spend), 2) AS roi_percentage
FROM marketing_campaigns;

-- 3) Revenue and ROI by channel
SELECT
    channel,
    SUM(spend) AS total_spend,
    SUM(revenue) AS total_revenue,
    SUM(revenue - spend) AS total_profit,
    ROUND((SUM(revenue) - SUM(spend)) * 100.0 / SUM(spend), 2) AS roi_percentage
FROM marketing_campaigns
GROUP BY channel
ORDER BY roi_percentage DESC;

-- 4) Performance by country
SELECT
    country,
    SUM(revenue) AS total_revenue,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(conversions) * 100.0 / SUM(clicks), 2) AS conversion_rate_percentage
FROM marketing_campaigns
GROUP BY country
ORDER BY total_revenue DESC;

-- 5) Top 5 campaigns by revenue
SELECT
    campaign_name,
    SUM(revenue) AS total_revenue,
    SUM(conversions) AS total_conversions
FROM marketing_campaigns
GROUP BY campaign_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 6) Device performance
SELECT
    device,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(revenue) AS total_revenue,
    ROUND(SUM(conversions) * 100.0 / SUM(clicks), 2) AS conversion_rate_percentage
FROM marketing_campaigns
GROUP BY device
ORDER BY total_revenue DESC;

-- 7) Campaign rows that lost money
SELECT
    campaign_id,
    campaign_name,
    channel,
    spend,
    revenue,
    revenue - spend AS profit
FROM marketing_campaigns
WHERE revenue < spend
ORDER BY profit ASC;

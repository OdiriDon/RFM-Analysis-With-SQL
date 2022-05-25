--Getting a preview of the data we would be working with

SELECT * 
FROM RFMOnlineRetailShop..onlineretail

--Selecting the data we would be working with and removing all any invoiceno which is null

SELECT customerid, MAX(invoicedate) AS last_order_date, COUNT(*) AS count_order,
SUM(unitprice * quantity) AS totalprice
FROM RFMOnlineRetailShop..onlineretail
WHERE invoiceno IS NOT NULL
AND customerid IS NOT NULL
AND unitprice != 0
GROUP BY customerid
ORDER BY customerid 

--The data is now ready for RFM analysis with 4 groups showing their last order date, count of orders and total amount spent
--The query for customer RFM
SELECT customerid,
rfm_recency, rfm_frequency, rfm_monetary 
FROM 
(SELECT customerid, 
NTILE(4) OVER (ORDER BY last_order_date) AS rfm_recency, 
NTILE(4) OVER (ORDER BY count_order) AS rfm_frequency,
NTILE(4) OVER (ORDER BY total_price) AS rfm_monetary
FROM 
(SELECT customerid, MAX(invoicedate) AS last_order_date, COUNT(*) AS count_order,
SUM(unitprice * quantity) AS total_price
FROM RFMOnlineRetailShop..onlineretail
WHERE invoiceno IS NOT NULL
AND customerid IS NOT NULL
AND unitprice != 0
GROUP BY customerid 
) AS rfm) AS final_rfm

-- The data is now ready for RFM analysis with 4 groups showing their last order date, count of orders, and total amount spent
-- The combined query for customer RFM

SELECT customerid,
rfm_recency * 100 + rfm_frequency * 10 + rfm_monetary AS rfm_combined
FROM 
(SELECT customerid, 
NTILE(4) OVER (ORDER BY last_order_date) AS rfm_recency, 
NTILE(4) OVER (ORDER BY count_order) AS rfm_frequency,
NTILE(4) OVER (ORDER BY total_price) AS rfm_monetary
FROM 
(SELECT customerid, MAX(invoicedate) AS last_order_date, COUNT(*) AS count_order,
SUM(unitprice * quantity) AS total_price
FROM RFMOnlineRetailShop..onlineretail
WHERE invoiceno IS NOT NULL
AND customerid IS NOT NULL
AND unitprice != 0
GROUP BY customerid 
) AS rfm) AS final_rfm



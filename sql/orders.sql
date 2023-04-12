WITH unique_ages AS (
  SELECT DISTINCT
    Age AS age
  FROM
    CustomerList1
  UNION
  SELECT DISTINCT
    Age AS age
  FROM
    CustomerList2
),
unique_ages_segmented AS (
  SELECT
    age AS segment_age,
    CASE
      WHEN age >=0 AND age < 18 THEN '0-18'
      WHEN age >=18 AND age < 25 THEN '18-25'
      WHEN age >=25 AND age < 30 THEN '25-30'
      WHEN age >=30 AND age < 35 THEN '30-35'
      WHEN age >=35 AND age < 40 THEN '35-40'
      WHEN age >=40 AND age < 50 THEN '40-50'
      WHEN age >=50 AND age < 60 THEN '50-60'
      WHEN age >=60 AND age < 70 THEN '60-70'
      WHEN age >=70 AND age < 80 THEN '70-80'
      WHEN age >=80 THEN '80+'
    END AS age_segment
  FROM
    unique_ages
),
unique_customers_grouped AS (
  SELECT
    CAST(cl1.Customer_id AS INT)                   AS customer_id,
    CAST(cl1.Age AS INT)                           AS age,
    IFNULL(Gender, 'unknown')                      AS gender,
    country                                        AS country,
    IFNULL(ua.age_segment, 'N/A')                  AS age_segment,
    RTRIM(Name || ' ' || IFNULL(Surname, ''), ' ') AS full_name
  FROM
    CustomerList1 cl1
  LEFT JOIN unique_ages_segmented ua ON ua.segment_age = cl1.Age
  WHERE
    customer_id IS NOT NULL
  UNION
  SELECT
    CAST(cl2.Customer_id AS INT)                   AS customer_id,
    CAST(cl2.Age AS INT)                           AS age,
    IFNULL(Gender, 'unknown')                      AS gender,
    country                                        AS country,
    IFNULL(ua.age_segment, 'N/A')                  AS age_segment,
    RTRIM(Name || ' ' || IFNULL(Surname, ''), ' ') AS full_name
  FROM
   CustomerList2 cl2
  LEFT JOIN unique_ages_segmented ua ON ua.segment_age = cl2.Age
  WHERE
    customer_id IS NOT NULL
)
SELECT
  c.customer_id                                    AS customer_id,
  c.full_name                                      AS full_name,
  c.age                                            AS age,
  c.gender                                         AS gender,
  c.country                                        AS country,
  c.age_segment                                    AS age_segment,
  o.'Order ID'                                     AS order_id,
  b.'Product Name'                                 AS product_name,
  CAST(b.'Discount per product' AS FLOAT)          AS discount_per_product,
  CASE
    WHEN IFNULL(CAST(b.'Discount per product' AS FLOAT), 0) = 0 THEN 'no_discount'
    WHEN 5 > CAST(b.'Discount per product' AS FLOAT)> 0 THEN '0-5'
    WHEN 10 > CAST(b.'Discount per product' AS FLOAT)>= 5 THEN '5-10'
    WHEN 15 > CAST(b.'Discount per product' AS FLOAT) >= 10 THEN '10-15'
    WHEN 20 > CAST(b.'Discount per product' AS FLOAT) >= 15 THEN '15-20'
    ELSE '20+'
  END AS discount_category,
  CAST(b.'Total revenue before discount' AS FLOAT) AS total_revenue_before_discount,
  CAST(b.'Total quantity' AS FLOAT)                AS quantity,
  b.Category                                       AS category
FROM
  unique_customers_grouped c
LEFT JOIN ListOfOrders o ON c.full_name = o.'Customer Name'
LEFT JOIN OrderBreakdown b ON b.'Order ID' = o.'Order ID'
;

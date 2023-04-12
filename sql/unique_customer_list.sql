-- Get unique ages that exist within the dataset
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
-- Segment these ages based on intervals
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
-- Joined the age segments to the Customers Table, adding an `age_segment` flag
unique_customers_grouped AS (
    SELECT
      CAST(cl1.Customer_id AS INT)   AS customer_id,
      CAST(cl1.Age AS INT)           AS age,
      IFNULL(Gender, 'unknown')      AS gender,
      IFNULL(seg.age_segment, 'N/A') AS age_segment
    FROM
      CustomerList1 cl1
    LEFT JOIN unique_ages_segmented seg ON seg.segment_age = cl1.Age
    WHERE
      customer_id IS NOT NULL
    UNION
    SELECT
      CAST(cl2.Customer_id AS INT)   AS customer_id,
      CAST(cl2.Age AS INT)           AS age,
      IFNULL(Gender, 'unknown')      AS gender,
      IFNULL(seg.age_segment, 'N/A') AS age_segment
    FROM
     CustomerList2 cl2
    LEFT JOIN unique_ages_segmented seg ON seg.segment_age = cl2.Age
    WHERE
      customer_id IS NOT NULL
)
-- Count the number of customer_ids grouped by `age_segment` and `gender`
SELECT
  age_segment                 AS age_segment,
  gender                      AS gender,
  COUNT(DISTINCT customer_id) AS customer_count
FROM
  unique_customers_grouped
GROUP BY 1, 2
;
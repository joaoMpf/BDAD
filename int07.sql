.mode columns
.headers on
.nullvalue NULL

--Faturação total em abril de 2019

SELECT
  SUM(price) AS total
FROM Demand
WHERE
  strftime('%Y', date) = '2019'
  AND strftime('%m', date) = '04'
ORDER BY
  total DESC
LIMIT 5;

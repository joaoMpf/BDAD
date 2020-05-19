.mode columns
.headers on
.nullvalue NULL

--Mês com mais faturação

SELECT
  strftime('%Y', date) AS year,
  strftime('%m', date) AS month,
  SUM(price) AS total
FROM Demand
GROUP BY
  strftime('%m', date)
ORDER BY
  total DESC
LIMIT 1;

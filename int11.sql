.mode columns
.headers on
.nullvalue NULL

--Mês com mais faturação

SELECT
  strftime('%Y-%m', date) AS month,
  SUM(price) AS total
FROM Demand
GROUP BY
  strftime('%Y-%m', date)
ORDER BY
  total DESC
LIMIT 1;

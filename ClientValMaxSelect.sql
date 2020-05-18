.mode columns
.headers on
.nullvalue NULL


SELECT
  SUM(Demand.price) AS total,
  NIF, 
  name
from Person
INNER JOIN Demand ON Person.NIF = Demand.customerNIF
GROUP BY
  customerNIF
ORDER BY 
  total DESC
LIMIT 5;

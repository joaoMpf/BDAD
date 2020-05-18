.mode columns
.headers on
.nullvalue NULL


SELECT
  COUNT(customerNIF) AS occurrence,
  NIF, 
  name
from Person
INNER JOIN Demand ON Person.NIF = Demand.customerNIF
GROUP BY
  customerNIF
ORDER BY 
  occurrence DESC
LIMIT 5;

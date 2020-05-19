.mode columns
.headers on
.nullvalue NULL

--5 clientes com maior gasto

SELECT
  SUM(Demand.price) AS total,
  NIF,
  name
from Person
INNER JOIN Demand ON Person.NIF = Demand.customerNIF
GROUP BY
  Person.NIF
ORDER BY
  total DESC
LIMIT 5;

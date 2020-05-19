.mode columns
.headers on
.nullvalue NULL

--Clientes que não são drivers

SELECT
  CustomerNIF
from Customer
EXCEPT
SELECT
  driverNIF
from Driver;

.mode columns
.headers on
.nullvalue NULL

SELECT
  CustomerNIF
from Customer
EXCEPT
SELECT
  driverNIF
from Driver;
.mode columns
.headers on
.nullvalue NULL

-- SELECT
--   Customer.customerNIF,
--   Person.name
-- from Customer
-- INNER JOIN Person ON Customer.customerNIF = Person.NIF
-- EXCEPT
SELECT
  Customer.customerNIF,
  Person.name,
  Restaurant.restaurantID,
  COUNT(Customer.customerNIF) AS 'demands from restaurant'
from Customer
INNER JOIN Person ON Customer.customerNIF = Person.NIF
INNER JOIN Demand ON Customer.customerNIF = Demand.customerNIF
INNER JOIN Demanded ON Demand.demandID = Demanded.demandID
INNER JOIN Food ON Demanded.foodID = Food.foodID
INNER JOIN Restaurant ON Food.restaurantID = Restaurant.restaurantID
-- WHERE
--   Restaurant.restaurantID = 7
GROUP BY
  Customer.customerNIF --AND Restaurant.restaurantID
  ORDER BY 'demands from restaurant' DESC;

-- SELECT
--   Customer.customerNIF,
--   Person.name
-- from Customer
-- INNER JOIN Person ON Customer.customerNIF = Person.NIF
-- INNER JOIN Demand ON Customer.customerNIF = Demand.customerNIF
-- INNER JOIN Demanded ON Demand.demandID = Demanded.demandID
-- INNER JOIN Food ON Demanded.foodID = Food.foodID
-- INNER JOIN Restaurant ON Food.restaurantID = Restaurant.restaurantID
-- WHERE
--   Restaurant.restaurantID = 7;
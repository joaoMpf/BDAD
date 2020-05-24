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
  Restaurant.name AS 'restaurant name',
  COUNT(DISTINCT Restaurant.restaurantID) AS 'number of restaurant oredered'
  -- COUNT(DISTINCT Customer.customerNIF, Restaurant.restaurantID) AS 'demands from restaurant'
from Customer
INNER JOIN Person ON Customer.customerNIF = Person.NIF
INNER JOIN Demand ON Customer.customerNIF = Demand.customerNIF
INNER JOIN Demanded ON Demand.demandID = Demanded.demandID
INNER JOIN Food ON Demanded.foodID = Food.foodID
INNER JOIN Restaurant ON Food.restaurantID = Restaurant.restaurantID
-- WHERE(
--   Customer.customerNIF = Customer.customerNIF AND Restaurant.restaurantID = Restaurant.restaurantID
--   -- GROUP BY
--   --   Customer.customerNIF
-- )
-- WHERE
--   Restaurant.restaurantID = 7
-- WHERE
--   'number of restaurant oredered' > 10
GROUP BY
  Customer.customerNIF--, Restaurant.restaurantID

  ORDER BY Customer.customerNIF DESC;

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

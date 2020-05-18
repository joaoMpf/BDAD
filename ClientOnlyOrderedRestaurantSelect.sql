.mode columns
.headers on
.nullvalue NULL

SELECT
  Customer.customerNIF,
  Person.name,
  Restaurant.restaurantID,
  Restaurant.name  AS 'restaurant name',
  COUNT(DISTINCT Restaurant.restaurantID) AS 'number of restaurant oredered'
from Customer
INNER JOIN Person ON Customer.customerNIF = Person.NIF
INNER JOIN Demand ON Customer.customerNIF = Demand.customerNIF
INNER JOIN Demanded ON Demand.demandID = Demanded.demandID
INNER JOIN Food ON Demanded.foodID = Food.foodID
INNER JOIN Restaurant ON Food.restaurantID = Restaurant.restaurantID
GROUP BY
  Customer.customerNIF
HAVING
  COUNT(DISTINCT Restaurant.restaurantID) = 1
ORDER BY
  COUNT(DISTINCT Restaurant.restaurantID) ASC;

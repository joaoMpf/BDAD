.mode columns
.headers on
.nullvalue NULL

--Comidas nunca encomendadas

SELECT
  Food.name AS 'food name',
  Restaurant.name AS 'restaurant name'
FROM Food
INNER JOIN Restaurant ON Restaurant.restaurantID = Food.restaurantID
EXCEPT
SELECT
  Food.name,
  Restaurant.name
FROM Food
INNER JOIN Demanded ON Food.foodID = Demanded.foodID
INNER JOIN Restaurant ON Restaurant.restaurantID = Food.restaurantID
ORDER BY
  Restaurant.name;

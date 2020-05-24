.mode columns
.headers on
.nullvalue NULL

--Total de faturação por tipo de restaurante

SELECT
  RestaurantType.type,
  SUM(Food.price * Demanded.quantity) AS total
FROM Demanded
INNER JOIN Food ON Demanded.foodID = Food.foodID
INNER JOIN Restaurant ON Restaurant.restaurantID = Food.restaurantID
INNER JOIN RestaurantType ON RestaurantType.restaurantTypeID = Restaurant.restaurantTypeID
GROUP BY
  RestaurantType.restaurantTypeID
ORDER BY
  total DESC;

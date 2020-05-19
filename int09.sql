.mode columns
.headers on
.nullvalue NULL

--5 restaurantes com maior numero de encomendas

SELECT
  RestaurantType.type,
  COUNT(Restaurant.restaurantID) AS 'numer of orders'
FROM Demanded
INNER JOIN Food ON Demanded.foodID = Food.foodID
INNER JOIN Restaurant ON Restaurant.restaurantID = Food.restaurantID
INNER JOIN RestaurantType ON RestaurantType.restaurantTypeID = Restaurant.restaurantTypeID
GROUP BY
  RestaurantType.restaurantTypeID
ORDER BY
  'numer of orders' DESC;

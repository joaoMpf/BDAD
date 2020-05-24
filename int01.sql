.mode columns
.headers on
.nullvalue NULL

--info relacionada com a demand

SELECT
  Demand.demandId,
  date,
  delivery_fee,
  Demand.price AS 'demand total price',
  PaymentType.type AS 'payment type',
  Location.street_name,
  customerNIF,
  Person.name AS 'customer name',
  Driver.ss_number AS 'driver ss_number',
  Food.name AS 'food',
  Demanded.quantity,
  Restaurant.name AS 'restaurant',
  RestaurantType.type AS 'restaurant type'
from Demand
INNER JOIN PaymentType ON Demand.paymentTypeID = PaymentType.paymentTypeID
INNER JOIN Location ON Demand.locationID = Location.locationID
INNER JOIN Person ON Demand.customerNIF = Person.NIF
INNER JOIN Driver ON Demand.driverNIF = Driver.driverNIF
INNER JOIN Demanded ON Demand.demandID = Demanded.demandID
INNER JOIN Food ON Demanded.foodID = Food.foodID
INNER JOIN Restaurant ON Restaurant.restaurantID = Food.restaurantID
INNER JOIN RestaurantType ON RestaurantType.restaurantTypeID = Restaurant.restaurantTypeID
WHERE(Demand.demandID = 20);

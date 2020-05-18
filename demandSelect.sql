.mode columns
.headers on
.nullvalue NULL

SELECT
  Demand.demandId,
  date,
  delivery_fee,
  Demand.price AS 'demand total price',
  PaymentType.type,
  Location.street_name,
  customerNIF,
  Person.name AS 'customer name',
  Demand.driverNIF,
  Driver.ss_number AS 'driver ss_number',
  Food.name,
  Demanded.quantity
from Demand
INNER JOIN PaymentType ON Demand.paymentTypeID = PaymentType.paymentTypeID
INNER JOIN Location ON Demand.locationID = Location.locationID
INNER JOIN Person ON Demand.customerNIF = Person.NIF
INNER JOIN Driver ON Demand.driverNIF = Driver.driverNIF
INNER JOIN Demanded ON Demand.demandID = Demanded.demandID
INNER JOIN Food ON Demanded.foodID = Food.foodID
WHERE(Demand.demandID = 20);
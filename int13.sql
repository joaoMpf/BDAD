.mode columns
.headers on
.nullvalue NULL

--Tipo de pagamento mais usado por cidade

SELECT
  city,
  payment_method AS 'most used payment method',
  MAX(num_method) AS 'number of uses'
FROM(
    SELECT
      Location.city AS city,
      PaymentType.type AS payment_method,
      COUNT(Demand.paymentTypeID) AS num_method
    from Demand
    INNER JOIN Location ON Location.locationID = Demand.locationID
    INNER JOIN PaymentType ON PaymentType.paymentTypeID = Demand.paymentTypeID
    GROUP BY
      Location.city,
      Demand.paymentTypeID
  )
GROUP BY
  city;
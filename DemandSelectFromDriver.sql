.mode columns
.headers on
.nullvalue NULL

SELECT
MAX(Driver.rating_average)
FROM Driver
WHERE
  (
    Driver.driverNIF = Review.demandId;
  )
ORDER BY
  begin_date ASC;

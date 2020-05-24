.mode columns
.headers on
.nullvalue NULL

SELECT
  *
FROM VehicleDriver
WHERE
  (
    VehicleDriver.end_date > "2020-00-00 00:00:00"
  )
ORDER BY
  begin_date ASC;

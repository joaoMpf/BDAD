/*drivers' average rating calculations*/
CREATE TRIGGER aft_insert_review
AFTER
INSERT ON Review BEGIN
UPDATE Driver
SET
  rating_average = (
    SELECT
      AVG(Review.rating)
    FROM Demand
    JOIN Review
    WHERE
      (
        Demand.driverNIF = Driver.driverNIF
        AND Demand.demandID = Review.demandID
      )
  )
WHERE
  driverNIF = Driver.driverNIF;
END;
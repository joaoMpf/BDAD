/*restaurants' average rating calculations*/
CREATE TRIGGER aft_insert_rating
AFTER
INSERT ON Rating BEGIN
UPDATE Restaurant
SET
  rating_average = (
    SELECT
      AVG(Rating.rating)
    FROM Demand
    JOIN Rating
    WHERE
      (Rating.restaurantID = Restaurant.restaurantID)
  )
WHERE
  restaurantID = Restaurant.restaurantID;
END;
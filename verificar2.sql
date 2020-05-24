INSERT INTO RestaurantType(restaurantTypeID, type) VALUES
(1,"Ethnic"),
(2,"Fast food");

INSERT INTO Location (locationID,city,street_name,postal_code) VALUES
(1,"Aurora","P.O. Box 191, 9735 Curabitur Rd.","838888"),
(2,"Tavistock","754-3456 Massa. Rd.","745341");

INSERT INTO Restaurant (restaurantID, name,NIF,locationID, rating_average, restaurantTypeID) VALUES
(1,"Mac Ethnic",100000000,1,-1,1),
(2,"KFC",109999999,2,-1,2);




SELECT "";
SELECT "Restaurants' average rating before reviews are inserted:";
SELECT "";
SELECT rating_average FROM Restaurant;



INSERT INTO Rating (ratingID,rating,restaurantID) VALUES
(1,4,1),
(2,3,1),
(3,4,1),
(4,2,1),
(5,3,1),

(6,4,2),
(7,4,2),
(8,4,2),
(9,3,2),
(10,5,2);


SELECT "";
SELECT "Restaurant 1 ratings: ";
SELECT "";

SELECT rating FROM Rating WHERE ratingID <= 5;

SELECT "";
SELECT "Restaurant 2 ratings: ";
SELECT "";

SELECT rating FROM Rating WHERE ratingID > 5;


SELECT "";
SELECT "Restaurants' average rating after reviews are inserted:";
SELECT "";
SELECT rating_average FROM Restaurant;
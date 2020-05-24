.nullvalue NULL

INSERT INTO Person (NIF,name,birth_date,email,phone,password) VALUES
(100000001,"Zé","1970-03-14","ze@sitametorci.org","268099833","1QC97NBB0QR"),
(100000002,"André","1970-03-15","Ingfd@sitametorci.org","268099834","2QC97NBB0QR"),
(100000003,"Tozé","1970-03-16","Inyhrte@sitametorci.org","268066546","7QC97NBB0QR"),
(100000004,"Tondré","1970-03-17","Itn@sitametorci.org","268099887","6QC97NBB0QR");

INSERT INTO Driver (driverNIF,start_date,ss_number,rating_average) VALUES 
(100000001,"2016-11-25",21715040225,-1),
(100000002,"2014-01-25",70935725271,-1);

INSERT INTO Customer (customerNIF) VALUES
(100000003),
(100000004);

INSERT INTO Location (locationID,city,street_name,postal_code) VALUES 
(1,"Aurora","P.O. Box 191, 9735 Curabitur Rd.","838888"),
(2,"Tavistock","754-3456 Massa. Rd.","745341");

INSERT INTO PaymentType (paymentTypeID,type) VALUES (1,"Credit Card"),(2,"Cash");

INSERT INTO RestaurantType(restaurantTypeID, type) VALUES
(1,"Ethnic"),
(2,"Fast food");

INSERT INTO Restaurant (restaurantID, name,NIF,locationID, rating_average, restaurantTypeID) VALUES
(1,"Nec Tellus Associates",100000000,1,-1,1),
(2,"Nec Urna Et Limited",109999999,2,-1,2);

INSERT INTO Food (foodID,name,price,restaurantID) VALUES
(1,"Hamburguer",5.99,1),
(2,"Hamburguer",3.99,2);

INSERT INTO Demand (demandID,date,specification,delivery_fee,customerNIF,driverNIF,locationID,paymentTypeID) VALUES 
(1,"2020-04-15 08:56:46","pellentesque eget, dictum","6.25",100000003,100000001,1,2),
(2,"2019-06-23 04:12:51","enim, sit amet ornare lectus justo eu arcu. Morbi sit","2.77",100000004,100000001,1,1),
(3,"2019-10-07 05:11:34","eu nibh vulputate mauris sagittis placerat.","4.79",100000003,100000001,1,2);



SELECT "";
SELECT "Demands' price before Demandeds are inserted: ";
SELECT price FROM Demand; 
SELECT "";

INSERT INTO Demanded (demandedID,foodID,demandID,quantity) VALUES
(1,1,1,9),
(2,1,2,1),
(3,2,3,5);

SELECT "";
SELECT "Demanded 1:";
SELECT "";
SELECT "Food price: ";
SELECT price FROM Food WHERE foodID = 1;
SELECT "Quantity: ";
SELECT quantity FROM Demanded WHERE demandedID = 1;
SELECT "Delivery Fee: ";
SELECT delivery_fee FROM Demand WHERE demandID = 1;
SELECT "";

SELECT "";
SELECT "Demanded 2:";
SELECT "";
SELECT "Food price: ";
SELECT price FROM Food WHERE foodID = 1;
SELECT "Quantity: ";
SELECT quantity FROM Demanded WHERE demandedID = 2;
SELECT "Delivery Fee: ";
SELECT delivery_fee FROM Demand WHERE demandID = 2;
SELECT "";

SELECT "";
SELECT "Demanded 3:";
SELECT "";
SELECT "Food price: ";
SELECT price FROM Food WHERE foodID = 2;
SELECT "Quantity: ";
SELECT quantity FROM Demanded WHERE demandedID = 3;
SELECT "Delivery Fee: ";
SELECT delivery_fee FROM Demand WHERE demandID = 3;
SELECT "";


SELECT "Demands' price after Demanded are inserted:";
SELECT price FROM Demand;
SELECT "";
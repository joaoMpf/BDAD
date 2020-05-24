.mode columns
.nullvalue NULL
.headers off


INSERT INTO Person (NIF,name,birth_date,email,phone,password) VALUES
(100000001,"Zé","1970-03-14","ze@sitametorci.org","268099833","1QC97NBB0QR"),
(100000003,"Tozé","1970-03-16","Inyhrte@sitametorci.org","268066546","7QC97NBB0QR"),
(100000004,"Tondré","1970-03-17","Itn@sitametorci.org","268099887","6QC97NBB0QR");

INSERT INTO Driver (driverNIF,start_date,ss_number,rating_average) VALUES   
(100000001,"2016-11-25",21715040225,-1);

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


INSERT INTO CreditCard (number_cc, cvv, exp_date, card_type, customerNIF) VALUES
(1234567890121,226,"2019-12-25","Visa Electron",100000003),
(1234567890122,113,"2020-12-23","MasterCard Neutron",100000004);


SELECT "";
SELECT "CreditCards' number_cc and expriation date before Demand insertions: ";
SELECT number_cc, exp_date FROM CreditCard;
SELECT "";

INSERT INTO Demand (demandID,date,specification,delivery_fee,customerNIF,driverNIF,locationID,paymentTypeID) VALUES 
(1,"2020-04-15 08:56:46","pellentesque eget, dictum","6.25",100000003,100000001,1,2), 
(2,"2019-06-23 04:12:51","enim, sit amet ornare lectus justo eu arcu. Morbi sit","2.77",100000004,100000001,1,1);

SELECT "";
SELECT "Demands' number_cc after Demand insertions: ";
.headers on
SELECT demandID, number_cc, PaymentType.type, date FROM Demand
INNER JOIN PaymentType ON PaymentType.paymentTypeID = Demand.paymentTypeID;
.headers off
SELECT "";


SELECT "";
SELECT "Raise after expired CreditCard with expiration date of 2019-12-25 added to Demand with date 2020-05-15 12:56:46";
SELECT "";
INSERT INTO Demand (demandID,date,specification,delivery_fee,customerNIF,driverNIF,locationID,paymentTypeID) VALUES 
(3,"2020-05-15 12:56:46","enim, sit amet ornare lectus","6.25",100000003,100000001,1,1);
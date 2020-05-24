INSERT INTO Person (NIF,name,birth_date,email,phone,password) VALUES
(100000001,"Zé","1970-03-14","ze@sitametorci.org","268099833","1QC97NBB0QR"),
(100000002,"André","1970-03-15","Ingfd@sitametorci.org","268099834","2QC97NBB0QR"),
(100000003,"Tozé","1970-03-16","Inyhrte@sitametorci.org","268066546","7QC97NBB0QR"),
(100000004,"Tondré","1970-03-17","Itn@sitametorci.org","268099887","6QC97NBB0QR");


INSERT INTO Driver (driverNIF,start_date,ss_number,rating_average) VALUES 
(100000001,"2016-11-25",21715040225,-1),
(100000002,"2014-01-25",70935725271,-1);







SELECT "";
SELECT "Drivers' average rating before reviews are inserted:";
SELECT "";
SELECT rating_average FROM Driver;









INSERT INTO Customer (customerNIF) VALUES
(100000003),
(100000004);


INSERT INTO Location (locationID,city,street_name,postal_code) VALUES 
(1,"Aurora","P.O. Box 191, 9735 Curabitur Rd.","838888"),
(2,"Tavistock","754-3456 Massa. Rd.","745341");

INSERT INTO PaymentType (paymentTypeID,type) VALUES (1,"Credit Card"),(2,"Cash");

INSERT INTO Demand (demandID,date,specification,delivery_fee,customerNIF,driverNIF,locationID,paymentTypeID) VALUES 
(1,"2020-04-15 08:56:46","pellentesque eget, dictum","6.25",100000003,100000001,1,2),
(2,"2019-06-23 04:12:51","enim, sit amet ornare lectus justo eu arcu. Morbi sit","2.77",100000004,100000001,1,1),
(3,"2019-10-07 05:11:34","eu nibh vulputate mauris sagittis placerat.","4.79",100000003,100000001,1,2),
(4,"2019-08-01 01:26:03","mauris blandit mattis. Cras","2.52",100000004,100000001,1,1),
(5,"2019-08-26 19:56:12","eu","6.93",100000003,100000001,1,2),

(6,"2020-01-15 07:41:05","tempor","1.91",100000004,100000002,1,2),
(7,"2019-04-20 08:19:06","non, hendrerit","9.28",100000003,100000002,1,2),
(8,"2019-07-03 12:23:28","ac nulla. In tincidunt","1.45",100000004,100000002,1,2),
(9,"2020-01-22 01:11:21","dictum augue malesuada malesuada. Integer","5.48",100000003,100000002,1,2),
(10,"2019-11-22 15:54:30","tristique neque","3.52",100000004,100000002,2,2);


INSERT INTO Review (reviewID,rating,description,demandID) VALUES
(1,2,"sit amet orci.",1),
(2,3,"Morbi sit",2),
(3,2,"ridiculus",3),
(4,1,"sit",4),
(5,1,"ornare. Fusce mollis. Duis sit amet",5),

(6,4,"egestas nunc sed libero. Proin sed turpis nec mauris",6),
(7,5,"turpis. Nulla aliquet.",7),
(8,5,"tempus",8),
(9,2,"pede ac urna. Ut tincidunt vehicula risus. Nulla eget",9),
(10,3,"enim diam",10);






SELECT "";
SELECT "Driver 1 ratings: ";
SELECT "";

SELECT rating FROM Review WHERE reviewID <= 5;

SELECT "";
SELECT "Driver 2 ratings: ";
SELECT "";

SELECT rating FROM Review WHERE reviewID > 5;


SELECT "";
SELECT "Drivers' average rating after reviews are inserted:";
SELECT "";
SELECT rating_average FROM Driver;
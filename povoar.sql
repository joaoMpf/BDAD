PRAGMA foreign_keys = ON;
PRAGMA encoding = "UTF-8";

/*----------------------------VALUE INSERTIONS-----------------------------*/


INSERT INTO Person VALUES(1,"Joao","01-01-01","joao@email.com",912345678,"1234");
INSERT INTO Person VALUES(2,"Jose","02-02-02","jose@email.com",923456781,"1234");
INSERT INTO Person VALUES(3,"Miguel","03-03-03","miguel@email.com",9345678912,"1234");

--SELECT * FROM Person;

INSERT INTO Driver VALUES(1,"01-01-01",12345678901, -1);
INSERT INTO Driver VALUES(2,"02-02-02",12345678902, -1);
INSERT INTO Driver VALUES(3,"03-03-03",12345678903, -1);

--SELECT * FROM Driver;

--SELECT name FROM Person JOIN Driver WHERE NIF = driverNIF;

INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (1,"01-01-01",1,2,1);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (2,"01-01-01",1,2,2);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (3,"01-01-01",1,2,3);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (4,"01-01-01",1,2,1);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (5,"01-01-01",1,2,2);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (6,"01-01-01",1,2,3);

--SELECT * FROM Demand;

INSERT INTO Review(reviewID, rating, demandID) VALUES(1,1,1);
INSERT INTO Review(reviewID, rating, demandID) VALUES(1,5,2);
INSERT INTO Review(reviewID, rating, demandID) VALUES(2,4,3);
INSERT INTO Review(reviewID, rating, demandID) VALUES(2,3,4);
INSERT INTO Review(reviewID, rating, demandID) VALUES(3,5,5);
INSERT INTO Review(reviewID, rating, demandID) VALUES(3,4,6);




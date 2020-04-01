PRAGMA foreign_keys = ON;
PRAGMA encoding = "UTF-8";
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS TeamLeader;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS VehicleDriver;
DROP TABLE IF EXISTS CreditCard;
DROP TABLE IF EXISTS Demand;
DROP TABLE IF EXISTS PaymentType;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Food;
DROP TABLE IF EXISTS Restaurant;
DROP TABLE IF EXISTS RestaurantType;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Invoice;
DROP TABLE IF EXISTS InvoiceLine;

CREATE TABLE Person (
  NIF INTEGER NOT NULL,
  name TEXT NOT NULL,
  birth_date DATE NOT NULL,
  email TEXT,
  phone INTEGER NOT NULL CHECK(length(phone) >= 9),
  password TEXT NOT NULL,
  CONSTRAINT person_pk PRIMARY KEY (NIF)
);
CREATE TABLE Customer (
  customerNIF INTEGER,
  FOREIGN KEY(customerNIF) REFERENCES Person(NIF),
  CONSTRAINT customer_pk PRIMARY KEY (customerNIF)
);
CREATE TABLE Driver (
  driverNIF INTEGER REFERENCES Person(NIF),
  start_date DATE NOT NULL,
  ss_number INTEGER NOT NULL CHECK(length(ss_number) >= 11),
  rating_average REAL DEFAULT NULL,
  CONSTRAINT driver_pk PRIMARY KEY (driverNIF)
);

CREATE TABLE Vehicle (
  license_plate INTEGER NOT NULL CHECK(length(license_plate) >= 6),
  make TEXT NOT NULL,
  model TEXT NOT NULL,
  driverNIF INTEGER,
  FOREIGN KEY(driverNIF) REFERENCES Driver(driverNIF),
  CONSTRAINT vehicle_pk PRIMARY KEY (license_plate)
);
CREATE TABLE VehicleDriver (
  driver1NIF INTEGER REFERENCES Driver(driverNIF),
  driver2NIF INTEGER REFERENCES Driver(driverNIF),
  begin_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  CHECK(begin_date < end_date)
);
CREATE TABLE CreditCard (
  number_cc INTEGER NOT NULL CHECK(
    length(number_cc) >= 13
    AND length(number_cc) <= 19
  ),
  cvv INTEGER NOT NULL CHECK(length(cvv) = 3),
  exp_date TEXT NOT NULL,
  card_type TEXT NOT NULL,
  customerNIF INTEGER,
  FOREIGN KEY(customerNIF) REFERENCES Customer(customerNIF),
  CONSTRAINT credit_card_pk PRIMARY KEY (number_cc)
);
CREATE TABLE Demand (
  demandID INTEGER,
  date TEXT NOT NULL,
  specification TEXT,
  delivery_fee INTEGER NOT NULL CHECK(delivery_fee >= 0),
  price INTEGER NOT NULL CHECK(price >= delivery_fee),
  customerNIF INTEGER REFERENCES Customer(customerNIF),
  driverNIF INTEGER REFERENCES Driver(driverNIF),
  locationID INTEGER REFERENCES Location(locationID),
  paymentTypeID INTEGER REFERENCES PaymentType(paymentTypeID),
  foodID INTEGER,
  FOREIGN KEY(foodID) REFERENCES Food(foodID),
  CONSTRAINT Demand_pk PRIMARY KEY (DemandID)
);
CREATE TABLE PaymentType (
  paymentTypeID INTEGER PRIMARY KEY,
  type TEXT NOT NULL
);
CREATE TABLE Review (
  reviewID INTEGER, --PRIMARY KEY,
  rating INTEGER CHECK(
    rating > 0
    AND rating <= 5
  ),
  description TEXT,
  DemandID INTEGER,
  FOREIGN KEY(DemandID) REFERENCES Demand(DemandID)
);
CREATE TABLE Rating (
  ratingID INTEGER PRIMARY KEY,
  rating INTEGER CHECK(
    rating > 0
    AND rating <= 5
  )
);
CREATE TABLE Restaurant (
  restaurantID INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  NIF INTEGER NOT NULL CHECK(length(NIF) = 9),
  locationID INTEGER REFERENCES Location(locationID),
  rating_average INTEGER,  --TODO: meter calculos
  restaurantTypeID INTEGER,
  FOREIGN KEY(restaurantTypeID) REFERENCES RestaurantType(restaurantTypeID)
);
CREATE TABLE RestaurantType (
  restaurantTypeID INTEGER PRIMARY KEY,
  type TEXT NOT NULL
);
CREATE TABLE Food (
  foodID INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  price INTEGER NOT NULL CHECK(price > 0),
  restaurantID INTEGER,
  FOREIGN KEY(restaurantID) REFERENCES Restaurant(restaurantID)
);
CREATE TABLE Location (
  locationID INTEGER PRIMARY KEY,
  city TEXT NOT NULL,
  street_name TEXT NOT NULL,
  street_number TEXT NOT NULL,
  postal_code TEXT NOT NULL
);
CREATE TABLE Invoice (
  invoiceID INTEGER,
  total INTEGER NOT NULL, --TODO: meter calculos
  date TEXT NOT NULL,
  DemandID INTEGER,
  FOREIGN KEY(DemandID) REFERENCES Demand(DemandID),
  CONSTRAINT invoice_pk PRIMARY KEY (InvoiceID)
);
CREATE TABLE InvoiceLine (
  invoice_lineID INTEGER,
  quantity INTEGER NOT NULL,
  foodID INTEGER REFERENCES Food(foodID),
  invoiceID INTEGER,
  FOREIGN KEY(invoiceID) REFERENCES Invoice(invoiceID),
  CONSTRAINT invoice_line_pk PRIMARY KEY (invoice_lineID)
);

INSERT INTO Person VALUES(1,"Joao","01-01-01","joao@email.com",912345678,"1234");
INSERT INTO Person VALUES(2,"Jose","02-02-02","jose@email.com",923456781,"1234");
INSERT INTO Person VALUES(3,"Miguel","03-03-03","miguel@email.com",9345678912,"1234");

--SELECT * FROM Person;

INSERT INTO Driver VALUES(1,"01-01-01",12345678901, -1);
INSERT INTO Driver VALUES(2,"02-02-02",12345678902, -1);
INSERT INTO Driver VALUES(3,"03-03-03",12345678903, -1);

--SELECT * FROM Driver;

INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (1,"01-01-01",1,2,1);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (2,"01-01-01",1,2,1);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (3,"01-01-01",1,2,2);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (4,"01-01-01",1,2,1);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (5,"01-01-01",1,2,1);
INSERT INTO Demand(DemandID, date, delivery_fee, price, driverNIF) VALUES (6,"01-01-01",1,2,2);

--SELECT * FROM Demand;

INSERT INTO Review(reviewID, rating, demandID) VALUES(1,1,1);
INSERT INTO Review(reviewID, rating, demandID) VALUES(1,5,2);
INSERT INTO Review(reviewID, rating, demandID) VALUES(2,4,3);
INSERT INTO Review(reviewID, rating, demandID) VALUES(2,3,4);
INSERT INTO Review(reviewID, rating, demandID) VALUES(3,5,5);
INSERT INTO Review(reviewID, rating, demandID) VALUES(3,4,6);
/*
UPDATE Driver
  SET rating_average = (
    SELECT AVG(rating) FROM Review WHERE DemandID IN (
      SELECT demandID FROM Demand WHERE DriverNIF = 1
    )
  )
  WHERE DriverNIF = 1;

UPDATE Driver
  SET rating_average = (
    SELECT AVG(r.rating) FROM Demand as d JOIN Review as r WHERE d.demandID = r.demandID AND d.driverNIF = 1;  
  )
  WHERE DriverNIF = 1;
*/

--SELECT * FROM Demand;

UPDATE Driver
  SET rating_average = (
    SELECT AVG(r.rating) FROM Demand as d JOIN Review as r WHERE d.demandID = r.demandID AND d.driverNIF = driverNIF
  );

SELECT * FROM Driver;
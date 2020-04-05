PRAGMA foreign_keys = ON;
PRAGMA encoding = "UTF-8";
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS VehicleDriver;
DROP TABLE IF EXISTS CreditCard;
DROP TABLE IF EXISTS Demand;
DROP TABLE IF EXISTS Demanded;
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
CREATE TABLE Team (
  driverNIF integer,
  leaderNIF integer,
  FOREIGN KEY(driverNIF) REFERENCES Person(NIF),
  FOREIGN KEY(leaderNIF) REFERENCES Person(NIF),
  CONSTRAINT team_pk PRIMARY KEY (driverNIF)
);
CREATE TABLE Vehicle (
  license_plate TEXT NOT NULL CHECK(length(license_plate) >= 6),
  make TEXT NOT NULL,
  model TEXT NOT NULL,
  CONSTRAINT vehicle_pk PRIMARY KEY (license_plate)
);
CREATE TABLE VehicleDriver (
  driverNIF INTEGER REFERENCES Driver(driverNIF),
  license_plate TEXT REFERENCES Vehicle(license_plate),
  begin_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  CHECK(begin_date < end_date),
  CONSTRAINT vehicleDriver_pk PRIMARY KEY (begin_date, driverNIF)
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
  CONSTRAINT credit_card_pk PRIMARY KEY (customerNIF, number_cc)
);
CREATE TABLE Demand (
  demandID INTEGER,
  date TEXT NOT NULL,
  specification TEXT,
  delivery_fee REAL NOT NULL CHECK(delivery_fee >= 0),
  price REAL NOT NULL CHECK(price >= delivery_fee),
  --TODO: meter calculos
  customerNIF INTEGER REFERENCES Customer(customerNIF),
  driverNIF INTEGER REFERENCES Driver(driverNIF),
  locationID INTEGER REFERENCES Location(locationID),
  paymentTypeID INTEGER REFERENCES PaymentType(paymentTypeID),
  CONSTRAINT demand_pk PRIMARY KEY (demandID)
);
CREATE TABLE Demanded (
  foodID INTEGER,
  demandID INTEGER,
  quantity INTEGER NOT NULL,
  FOREIGN KEY(foodID) REFERENCES Food(foodID),
  FOREIGN KEY(demandID) REFERENCES Demand(demandID),
  CONSTRAINT demanded_pk PRIMARY KEY (demandID, foodID)
);
CREATE TABLE PaymentType (
  paymentTypeID INTEGER PRIMARY KEY,
  type TEXT NOT NULL
);
CREATE TABLE Review (
  reviewID INTEGER PRIMARY KEY,
  rating INTEGER CHECK(
    rating > 0
    AND rating <= 5
  ),
  description TEXT,
  demandID INTEGER,
  FOREIGN KEY(DemandID) REFERENCES Demand(demandID)
);
CREATE TABLE Rating (
  ratingID INTEGER PRIMARY KEY,
  rating INTEGER CHECK(
    rating > 0
    AND rating <= 5
  ),
  restaurantID INTEGER,
  FOREIGN KEY(restaurantID) REFERENCES Restaurant(restaurantID)
);
CREATE TABLE Restaurant (
  restaurantID INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  NIF INTEGER NOT NULL CHECK(length(NIF) = 9),
  locationID INTEGER REFERENCES Location(locationID),
  rating_average INTEGER,
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
  price REAL NOT NULL CHECK(price > 0),
  restaurantID INTEGER,
  FOREIGN KEY(restaurantID) REFERENCES Restaurant(restaurantID)
);
CREATE TABLE Location (
  locationID INTEGER PRIMARY KEY,
  city TEXT NOT NULL,
  street_name TEXT NOT NULL,
  postal_code TEXT NOT NULL
);
CREATE TABLE Invoice (
  invoiceID INTEGER,
  total REAL NOT NULL,
  --TODO: meter calculos
  date TEXT NOT NULL,
  DemandID INTEGER,
  FOREIGN KEY(DemandID) REFERENCES Demand(DemandID),
  CONSTRAINT invoice_pk PRIMARY KEY (InvoiceID)
);
CREATE TABLE InvoiceLine (
  invoice_lineID INTEGER,
  DemandedID INTEGER,
  invoiceID INTEGER,
  FOREIGN KEY(DemandedID) REFERENCES Demanded(DemandID),
  FOREIGN KEY(invoiceID) REFERENCES Invoice(invoiceID),
  CONSTRAINT invoice_line_pk PRIMARY KEY (invoice_lineID)
);
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
/*Show Driver table*/
SELECT
  *
FROM Driver;
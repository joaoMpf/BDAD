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
  birth_date INTEGER NOT NULL,
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
  start_date TEXT NOT NULL,
  ss_number INTEGER NOT NULL CHECK(length(ss_number) >= 11),
  rating_average INTEGER DEFAULT NULL, --TODO: meter calculos
  CONSTRAINT driver_pk PRIMARY KEY (driverNIF)
);
CREATE TABLE TeamLeader (
  --! será que é assim?
  driver1NIF INTEGER REFERENCES Person(NIF),
  driver2NIF INTEGER REFERENCES Person(NIF)
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
  DemandID INTEGER,
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
  reviewID INTEGER PRIMARY KEY,
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

INSERT INTO Person VALUES(1,"stay",1,"at",218430500,"home");
INSERT INTO Person VALUES(2,"stay",1,"at",218430500,"home");

SELECT * FROM Person;
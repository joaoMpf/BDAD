DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS TeamLeader;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS VehicleDriver;
DROP TABLE IF EXISTS CreditCard;
DROP TABLE IF EXISTS Order;
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
  NIF integer primary key,
  name text NOTNULL,
  birth_date integer NOTNULL,
  email text,
  phone integer NOTNULL CHECK(length(phone) >= 9),
  password text NOTNULL
);
CREATE TABLE Customer (
  customerNIF integer,
  FOREIGN KEY(customerNIF) REFERENCES Person(NIF)
);
CREATE TABLE Driver (
  driverNIF integer,
  FOREIGN KEY(driverNIF) REFERENCES Person(NIF),
  ss_number integer NOTNULL CHECK(length(ss_number) = 11),
  start_date text NOTNULL,
  --rating_average integer DEFAULT NULL --TODO: meter calculos
);
CREATE TABLE TeamLeader (
  --! será que é assim?
  driver1NIF integer,
  FOREIGN KEY(driver1NIF) REFERENCES Person(NIF),
  driver2NIF integer,
  FOREIGN KEY(driver2NIF) REFERENCES Person(NIF)
);
CREATE TABLE Vehicle (
  license_plate integer NOTNULL CHECK(length(license_plate) >= 6),
  make text NOTNULL,
  model text NOTNULL,
  driverNIF integer,
  FOREIGN KEY(driverNIF) REFERENCES Driver(driverNIF)
);
CREATE TABLE VehicleDriver (
  driver1NIF integer,
  FOREIGN KEY(driver1NIF) REFERENCES Driver(driverNIF),
  driver2NIF integer,
  FOREIGN KEY(driver2NIF) REFERENCES Driver(driverNIF),
  begin_date text NOTNULL,
  end_date text NOTNULL,
  CHECK(begin_date < end_date)
);
CREATE TABLE CreditCard (
  number_cc integer NOTNULL CHECK(
    length(number_cc) >= 13
    AND length(number_cc) <= 19
  ),
  cvv integer NOTNULL CHECK(length(cvv) = 3),
  exp_date text NOTNULL,
  card_type text NOTNULL,
  customerNIF integer,
  FOREIGN KEY(customerNIF) REFERENCES Customer(customerNIF)
);
CREATE TABLE Order (
  orderID integer PRIMARY KEY,
  date text NOTNULL,
  price integer NOTNULL CHECK(price > delivery_fee),
  especification text,
  delivery_fee integer CHECK(delivery_fee >= 0),
  customerNIF integer,
  FOREIGN KEY(customerNIF) REFERENCES Customer(customerNIF),
  driverNIF integer,
  FOREIGN KEY(driverNIF) REFERENCES Driver(driverNIF),
  locationID integer,
  FOREIGN KEY(locationID) REFERENCES Location(locationID),
  paymentTypeID integer,
  FOREIGN KEY(paymentTypeID) REFERENCES PaymentType(paymentTypeID),
  foodID integer,
  FOREIGN KEY(foodID) REFERENCES Food(foodID),
);
CREATE TABLE PaymentType (
  paymentTypeID integer PRIMARY KEY,
  type text NOTNULL,
);
CREATE TABLE Review (
  reviewID integer PRIMARY KEY,
  rating integer CHECK(
    rating > 0
    AND rating <= 5
  ),
  description text,
  orderID integer,
  FOREIGN KEY(orderID) REFERENCES Order(orderID)
);
CREATE TABLE Rating (
  ratingID integer PRIMARY KEY,
  rating integer CHECK(
    rating > 0
    AND rating <= 5
  )
);
CREATE TABLE Food (
  foodID integer PRIMARY KEY,
  name text NOTNULL,
  price integer NOTNULL CHECK(price > 0),
  restaurantID integer,
  FOREIGN KEY(restaurantID) REFERENCES Restaurant(restaurantID)
);
CREATE TABLE Restaurant (
  restaurantID integer PRIMARY KEY,
  name text NOTNULL,
  NIF integer NOTNULL CHECK(length(NIF) = 9),
  locationID integer,
  FOREIGN KEY(locationID) REFERENCES Location(locationID),
  --rating_average integer,  --TODO: meter calculos
  restaurantTypeID integer,
  FOREIGN KEY(restaurantTypeID) REFERENCES RestaurantType(restaurantTypeID)
);
CREATE TABLE RestaurantType (
  restaurantTypeID integer PRIMARY KEY,
  type text NOTNULL
);
CREATE TABLE Location (
  locationID integer PRIMARY KEY,
  city text NOTNULL,
  street_name text NOTNULL,
  street_number text NOTNULL,
  postal_code text NOTNULL
);
CREATE TABLE Invoice (
  invoiceID integer PRIMARY KEY,
  --total integer NOTNULL, --TODO: meter calculos
  date text NOTNULL,
  orderID integer,
  FOREIGN KEY(orderID) REFERENCES Order(orderID)
);
CREATE TABLE InvoiceLine (
  invoice_lineID integer PRIMARY KEY,
  quantity integer NOTNULL,
  foodID integer,
  FOREIGN KEY(foodID) REFERENCES Food(foodID),
  invoiceID integer,
  FOREIGN KEY(invoiceID) REFERENCES Invoice(invoiceID)
);
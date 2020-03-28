CREATE TABLE Person (
  NIF integer primary key,
  name text,
  birth_date integer,
  email text,
  phone integer,
  password text
);
CREATE TABLE Customer (
  customerNIF integer,
  FOREIGN KEY(customerNIF) REFERENCES Person(NIF)
);
CREATE TABLE Driver (
  driverNIF integer,
  FOREIGN KEY(driverNIF) REFERENCES Person(NIF),
  ss_number integer,
  start_date text,
  rating_average integer,
  --TODO: meter calculos
);
CREATE TABLE TeamLeader (
  --! será que é assim?
  driver1NIF integer,
  FOREIGN KEY(driver1NIF) REFERENCES Person(NIF),
  driver2NIF integer,
  FOREIGN KEY(driver2NIF) REFERENCES Person(NIF),
);
CREATE TABLE Vehicle (
  license_plate integer,
  make text,
  model text,
  driverNIF integer,
  FOREIGN KEY(driverNIF) REFERENCES Driver(driverNIF),
);
CREATE TABLE VehicleDriver (
  driver1NIF integer,
  FOREIGN KEY(driver1NIF) REFERENCES Driver(driverNIF),
  driver2NIF integer,
  FOREIGN KEY(driver2NIF) REFERENCES Driver(driverNIF),
  begin text,
end text --TODO: begin < end
);
CREATE TABLE CreditCard (
  number integer,
  cvv integer,
  exp_date text,
  card_type text,
  customerNIF integer,
  FOREIGN KEY(customerNIF) REFERENCES Customer(customerNIF)
);
CREATE TABLE Order (
  orderID integer PRIMARY KEY,
  date text,
  price integer,
  especification text,
  delivery_fee integer,
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
  type text,
);
CREATE TABLE Review (
  reviewID integer PRIMARY KEY,
  rating integer,
  --TODO: meter restições
  description text,
  orderID integer,
  FOREIGN KEY(orderID) REFERENCES Order(orderID)
);
CREATE TABLE Rating (
  ratingID integer PRIMARY KEY,
  rating integer --TODO: meter calculos
);
CREATE TABLE Food (
  foodID integer PRIMARY KEY,
  name text,
  price integer,
  restaurantID integer,
  FOREIGN KEY(restaurantID) REFERENCES Restaurant(restaurantID)
);
CREATE TABLE Restaurant (
  restaurantID integer PRIMARY KEY,
  name text,
  NIF integer,
  locationID integer,
  FOREIGN KEY(locationID) REFERENCES Location(locationID),
  rating_average integer,
  --TODO: meter calculos
  restaurantTypeID integer,
  FOREIGN KEY(restaurantTypeID) REFERENCES RestaurantType(restaurantTypeID)
);
CREATE TABLE RestaurantType (
  restaurantTypeID integer PRIMARY KEY,
  type text
);
CREATE TABLE Location (
  locationID integer PRIMARY KEY,
  city text,
  street_name text,
  street_number text,
  postal_code text
);
CREATE TABLE Invoice (
  invoiceID integer PRIMARY KEY,
  total integer,
  --TODO: meter calculos
  date text,
  orderID integer,
  FOREIGN KEY(orderID) REFERENCES Order(orderID)
);
CREATE TABLE InvoiceLine (
  invoice_lineID integer PRIMARY KEY,
  quantity integer,
  foodID integer,
  FOREIGN KEY(foodID) REFERENCES Food(foodID),
  invoiceID integer,
  FOREIGN KEY(invoiceID) REFERENCES Invoice(invoiceID)
);
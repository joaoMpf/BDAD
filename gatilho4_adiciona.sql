/*Update Demand with customer's credit card if he paid with credit card*/
CREATE TRIGGER aft_insert_demand
AFTER
INSERT ON Demand BEGIN
UPDATE Demand
SET
  number_cc = (
    SELECT
      CreditCard.number_cc
    FROM CreditCard
    WHERE
      CreditCard.customerNIF = Demand.customerNIF
      AND Demand.paymentTypeID = 1 
      AND strftime('%Y-%m-%d', CreditCard.exp_date) < strftime('%Y-%m-%d', Demand.date)
  );
END;
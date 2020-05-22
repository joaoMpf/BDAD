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
      -- AND strftime('%Y', CreditCard.exp_date) > strftime('%Y', Demand.date)
      -- AND strftime('%m', CreditCard.exp_date) > strftime('%m', Demand.date)
      -- AND strftime('%d', CreditCard.exp_date) > strftime('%d', Demand.date)
  );
END;
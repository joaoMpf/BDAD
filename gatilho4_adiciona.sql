/*Update Demand with customer's credit card if he paid with credit card*/
CREATE TRIGGER aft_insert_demand
BEFORE
INSERT ON Demand BEGIN
UPDATE Demand
SET
  number_cc = (
    SELECT
    CASE
      WHEN strftime('%Y-%m-%d', CreditCard.exp_date) > strftime('%Y-%m-%d', Demand.date)  THEN RAISE(ABORT, 'Credit Card expired')
      ELSE CreditCard.number_cc
      END
    FROM CreditCard
    WHERE
      CreditCard.customerNIF = Demand.customerNIF
      AND Demand.paymentTypeID = 1
  );
END;

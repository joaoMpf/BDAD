/*restaurants' average rating calculations*/
CREATE TRIGGER aft_insert_demand
AFTER
INSERT ON Demand BEGIN
UPDATE Demand
SET
  number_cc = (
    SELECT
      number_cc
    FROM CreditCard
    INNER JOIN CreditCard ON CreditCard.customerNIF = Demand.customerNIF
    WHERE
      strftime('%Y', CreditCard.exp_date) > strftime('%Y', Demand.date)
      AND strftime('%m', CreditCard.exp_date) > strftime('%m', Demand.date)
      AND strftime('%d', CreditCard.exp_date) > strftime('%d', Demand.date)
  )
WHERE
  demandID = Demand.demandID;
END;
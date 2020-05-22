/*restaurants' average rating calculations*/
CREATE TRIGGER aft_update_Demand
AFTER
UPDATE ON Demand BEGIN
UPDATE Invoice
SET
  total = (
    SELECT
      price
    FROM Demand
    WHERE
      Invoice.demandID = Demand.demandID
  );
END;
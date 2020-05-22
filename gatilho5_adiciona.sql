/*Update total in Invoice*/
CREATE TRIGGER aft_insert_InvoiceLine
AFTER
INSERT ON InvoiceLine BEGIN
UPDATE Invoice
SET
  total = (
    SELECT
      SUM(Demanded.quantity * Food.price) + Demand.delivery_fee
    FROM Demand
    INNER JOIN Demanded ON Demanded.demandID = Demand.demandID
    INNER JOIN Food ON Food.foodID = Demanded.foodID
    WHERE
      Invoice.demandID = Demand.demandID
  );
END;
/*Update Demand price according to demanded associated with each Demand*/
CREATE TRIGGER aft_insert_demanded
AFTER
INSERT ON Demanded BEGIN
UPDATE Demand
SET
  price = (
    SELECT
      SUM(Demanded.quantity * Food.price) + Demand.delivery_fee
    FROM Demanded
    INNER JOIN Food ON Food.foodID = Demanded.foodID
    WHERE
      Demanded.demandID = Demand.demandID
  )
WHERE
  demandID = Demand.demandID;
END;
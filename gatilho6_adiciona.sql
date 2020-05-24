/*Creat InvoiceLine*/
CREATE TRIGGER aft_insert_Demanded_create_InvoiceLine
AFTER
INSERT ON Demanded BEGIN
INSERT INTO InvoiceLine (demandedID, invoiceID)
VALUES
  (NEW.demandedID, NEW.demandID);
END;
/*Creat InvoiceLine*/
CREATE TRIGGER aft_insert_Demand_create_Invoice
AFTER
INSERT ON Demand BEGIN
INSERT INTO Invoice (invoiceID, date, DemandID)
VALUES
  (NEW.demandID, NEW.date, NEW.demandID);
END;
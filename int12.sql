.mode columns
.headers on
.nullvalue NULL


DROP VIEW IF EXISTS TeamDrivers;
DROP VIEW IF EXISTS NonTeamDrivers;

--Demands feitas por condutores que pertencem a equipas
CREATE VIEW TeamDrivers (
  demandID
)
AS
SELECT
  Driver.driverNIF
FROM Driver
INNER JOIN Team ON Team.driverNIF = Driver.driverNIF
                    OR Team.leaderNIF = Driver.driverNIF
GROUP BY
  Driver.driverNIF;


--Demands feitas por condutores que não pertencem a equipas
CREATE VIEW NonTeamDrivers (
  demandID
)
AS
SELECT
  Driver.driverNIF
FROM Driver
EXCEPT
SELECT
  Driver.driverNIF
FROM Driver
INNER JOIN Team ON Team.driverNIF = Driver.driverNIF
                    OR Team.leaderNIF = Driver.driverNIF
GROUP BY
  Driver.driverNIF;


--Ganho médio por condutor que pertence a uma equipa
SELECT
  Demand.demandID,
  COUNT(Demand.demandID),
  SUM(price)
FROM Driver
INNER JOIN TeamDemands ON TeamDemands.demandID = Demand.demandID;


--Ganho médio por condutor que não pertence a uma equipa
SELECT
  Demand.demandID,
  COUNT(Demand.demandID),
  AVG(price)
FROM Demand
INNER JOIN NonTeamDemands ON NonTeamDemands.demandID = Demand.demandID;

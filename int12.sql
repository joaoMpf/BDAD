.mode columns
.headers on
.nullvalue NULL


DROP VIEW IF EXISTS TeamDrivers;
DROP VIEW IF EXISTS NonTeamDrivers;

--Demands feitas por condutores que pertencem a equipas
CREATE VIEW TeamDrivers (
  driverNIF
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
  driverNIF
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

  SELECT
    COUNT(TeamDrivers.driverNIF)
  FROM TeamDrivers;
--Ganho médio por condutor que pertence a uma equipa
SELECT
  COUNT(TeamDrivers.driverNIF),
  AVG(Demand.price)
FROM TeamDrivers
INNER JOIN Demand ON Demand.driverNIF = TeamDrivers.driverNIF;

SELECT
  COUNT(NonTeamDrivers.driverNIF)
FROM NonTeamDrivers;
--Ganho médio por condutor que não pertence a uma equipa
SELECT
  COUNT(NonTeamDrivers.driverNIF),
  AVG(Demand.price)
FROM NonTeamDrivers
INNER JOIN Demand ON Demand.driverNIF = NonTeamDrivers.driverNIF;

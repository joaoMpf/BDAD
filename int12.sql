.mode columns
.headers on
.nullvalue NULL

DROP VIEW IF EXISTS TeamDrivers;
DROP VIEW IF EXISTS NumTeamDrivers;
DROP VIEW IF EXISTS AvgSalaryTeamDrivers;

DROP VIEW IF EXISTS NonTeamDrivers;
DROP VIEW IF EXISTS NumNonTeamDrivers;
DROP VIEW IF EXISTS AvgSalaryNonTeamDrivers;

--É melhor trabalhar em equipa ou sozinho?


--Condutores que pertencem a equipas
CREATE VIEW TeamDrivers (driverNIF) AS
SELECT
  Driver.driverNIF
FROM Driver
INNER JOIN Team ON Team.driverNIF = Driver.driverNIF
  OR Team.leaderNIF = Driver.driverNIF
GROUP BY
  Driver.driverNIF;

--Número de condutores que pertencem a equipas
CREATE VIEW NumTeamDrivers (num_teamDrivers) AS
SELECT
  COUNT(TeamDrivers.driverNIF)
FROM TeamDrivers;

--Ganho médio por condutor que pertence a uma equipa
CREATE VIEW AvgSalaryTeamDrivers (avgSalary_TeamDrivers) AS
SELECT
  SUM(Demand.price) / NumTeamDrivers.num_teamDrivers
FROM TeamDrivers
INNER JOIN Demand ON Demand.driverNIF = TeamDrivers.driverNIF
INNER JOIN NumTeamDrivers;



--Condutores que não pertencem a equipas
CREATE VIEW NonTeamDrivers (driverNIF) AS
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

--Número de condutores que não pertencem a equipas
CREATE VIEW NumNonTeamDrivers (num_nonTeamDrivers) AS
SELECT
  COUNT(NonTeamDrivers.driverNIF)
FROM NonTeamDrivers;

--Ganho médio por condutor que não pertence a uma equipa
CREATE VIEW AvgSalaryNonTeamDrivers (avgSalary_nonTeamDrivers) AS
SELECT
  SUM(Demand.price) / NumNonTeamDrivers.num_nonTeamDrivers
FROM NonTeamDrivers
INNER JOIN Demand ON Demand.driverNIF = NonTeamDrivers.driverNIF
INNER JOIN NumNonTeamDrivers;


--Para decidir se vale a pena trabalhar em equipa, compara os ganhos médios por condutor que pertencem ou não a uma equipa, e toma uma conclusão a partir de o maior.
SELECT
  AvgSalaryTeamDrivers.avgSalary_TeamDrivers,
  AvgSalaryNonTeamDrivers.avgSalary_nonTeamDrivers,
  CASE
    WHEN AvgSalaryTeamDrivers.avgSalary_TeamDrivers > AvgSalaryNonTeamDrivers.avgSalary_nonTeamDrivers THEN 'Working in a team is better'
    WHEN AvgSalaryTeamDrivers.avgSalary_TeamDrivers < AvgSalaryNonTeamDrivers.avgSalary_nonTeamDrivers THEN 'Working alone is better'
    ELSE 'It is the same working in a team or alone'
  END AS 'Conclusion'
FROM AvgSalaryTeamDrivers
INNER JOIN AvgSalaryNonTeamDrivers;

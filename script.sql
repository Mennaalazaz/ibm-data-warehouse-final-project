--  Scenario
-- You are a data engineer hired by a solid waste management company. The company collects and 
-- recycles solid waste across major cities in the country of Brazil. 
-- The company operates hundreds of trucks of different types to collect and transport solid waste. 
-- The company would like to create a data warehouse so that it can create reports like:

	-- Total waste collected per year per city
	-- Total waste collected per month per city
	-- Total waste collected per quarter per city
	-- Total waste collected per year per truck type
	-- Total waste collected per truck type per city
	-- Total waste collected per truck type per station per city 

CREATE DATABASE WasteDataWarehouse;

CREATE TABLE public.MyDimDate(
    Dateid INT PRIMARY KEY,
    DateValue DATE,
    Year INT,
    Quarter INT,
    QuarterName VARCHAR(2),
    Month INT,
    MonthName VARCHAR(15),
    Day INT,
    Weekday INT,
    WeekdayName VARCHAR(20)
);

CREATE TABLE public.DimTruck(
    Truckid INT PRIMARY KEY,
    TruckType VARCHAR(50)
);

CREATE TABLE public.DimStation(
    Stationid INT PRIMARY KEY,
    City VARCHAR(50)
);

CREATE TABLE public.FactTrips(
    Tripid INT PRIMARY KEY,
    Dateid INT,
    Stationid INT,
    Truckid INT,
    WasteCollected NUMERIC(10,2),

    CONSTRAINT fk_date
        FOREIGN KEY (Dateid)
        REFERENCES public.MyDimDate(Dateid),

    CONSTRAINT fk_station
        FOREIGN KEY (Stationid)
        REFERENCES public.DimStation(Stationid),

    CONSTRAINT fk_truck
        FOREIGN KEY (Truckid)
        REFERENCES public.DimTruck(Truckid)
);

--- THEN loading data from csv files 

--- Create a grouping sets query using the columns stationid, trucktype, total waste collected.
SELECT
    F.Stationid,
    T.TruckType,
    SUM(F.WasteCollected) AS "Total waste collected"
FROM FactTrips F
JOIN DimTruck T
ON F.Truckid = T.Truckid
GROUP BY GROUPING SETS
(
    (F.Stationid, T.TruckType),
    (F.Stationid),
    (T.TruckType),
    ()
);

--- Create a rollup query using the columns year, city, stationid, and total waste collected
SELECT
    D.Year,
    S.City,
    F.Stationid,
    SUM(F.WasteCollected) AS "Total waste collected"
FROM FactTrips F
JOIN MyDimDate D
ON F.Dateid = D.Dateid
JOIN DimStation S
ON F.Stationid = S.Stationid
GROUP BY ROLLUP
(
    D.Year,
    S.City,
    F.Stationid
);

--- Create a cube query using the columns year, city, stationid, and average waste collected.
SELECT
    D.Year,
    S.City,
    F.Stationid,
    ROUND(AVG(F.WasteCollected),2) AS "Average waste collected"
FROM FactTrips F
JOIN MyDimDate D
ON F.Dateid = D.Dateid
JOIN DimStation S
ON F.Stationid = S.Stationid
GROUP BY CUBE
(
    D.Year,
    S.City,
    F.Stationid
);


--- Create a materialized view named max_waste_stats using the columns city, stationid, trucktype, and max waste collected.
CREATE MATERIALIZED VIEW max_waste_stats AS 
SELECT City, F.Stationid , TruckType , MAX(WasteCollected) AS "Max waste collected"
FROM FactTrips F
INNER JOIN DimStation S
ON F.Stationid = S.Stationid
INNER JOIN DimTruck T
ON F.Truckid = T.Truckid
GROUP BY City, F.Stationid , TruckType

SELECT * FROM max_waste_stats;

-- to refresh data in materialized view
REFRESH MATERIALIZED VIEW max_waste_stats;


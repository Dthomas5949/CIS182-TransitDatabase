/* 
durias thomas
cis182
*/
USE master 
GO
DROP DATABASE DrivingCompany
GO
/*
Homework #1
Create a database with the following tables, correctly identifying the data type for each field and 
implementing constraints as described. Primary keys and relationships will be added in the next assignment.
*/
CREATE DATABASE DrivingCompany
GO
USE DrivingCompany

/*
Operators(Seniority Number, First Name, Last Name, Hire Date). All fields are required. 
Seniority number is four digits. Hire date must be less than tomorrow.
*/
CREATE TABLE Operators
(
	SeniorityNumber		char(4)		NOT NULL
			CONSTRAINT ck_Operators_Seniority 
			CHECK (SeniorityNumber LIKE '[0-9][0-9][0-9][0-9]'), 
	FirstName				varchar(25)	NOT NULL, 
	LastName				varchar(35)	NOT NULL, 
	HireDate					smalldatetime
			CONSTRAINT ck_Operators_HireDate CHECK (HireDate <=Getdate())
)

/*
Trips(Route Number, Start Location, Start Time, End Location, End Time, Effective Date) 
All fields are required. End Time must be greater than Start Time. Effective Date must be 
on or after January 1, 2000.
*/
CREATE TABLE Trips
(
	RouteNumber			varchar(4)		NOT NULL, 
	StartLocation			varchar(50)	NOT NULL, 
	StartTime				time				NOT NULL, 
	EndLocation			varchar(50)	NOT NULL, 
	EndTime					time				NOT NULL,
	EffectiveDate			smalldatetime	NOT NULL
		CHECK (EffectiveDate >= cast('1/1/2000' as smalldatetime)),
	CONSTRAINT ck_Trips_StartEnd CHECK (EndTime > StartTime)
)

/*
Vehicle(Manufacturer, Model, Model Year, Purchase Date). Default value for Manufacturer is 
'Gillig'; default value for Model Year is the current year. Model year must be less than or equal 
to the current year.
*/
CREATE TABLE Vehicles
(
	Manufacturer			varchar(50)
		DEFAULT 'Gillig',
	Model					varchar(50), 
	ModelYear				int
		DEFAULT DatePart(yyyy,GetDate())
		CHECK (ModelYear <= DatePart(yyyy,GetDate())),
	PurchaseDate			smalldatetime
)
	/* homework #2 
	Use the ALTER command to add primary keys to the Operators, 
	Vehicles and Trips tables created in Homework #1. The primary 
	key for each table should be based on an identity field.
	*/
	GO
	ALTER TABLE Operators
		ADD OperatorID int IDENTITY --Primary Key
	
	GO
	ALTER TABLE Operators
		ADD CONSTRAINT pkOperators Primary key (OperatorID)
	
	ALTER TABLE Vehicles
		ADD VehicleID	int IDENTITY Primary Key
	
	ALTER TABLE Trips
		ADD TripID		int IDENTITY Primary key
	GO
	
/*
Run Table: Each operator can have many work assignments, called runs. 
Each run needs an identifier, and belongs to an operator. Use an identity 
field for the run identifier, and include a field to serve as a foreign key for 
the operator table. All fields are required. The Bid Date field cannot be 
more than six months in the future.
*/	
CREATE TABLE Runs
(
	RunID			int		IDENTITY		NOT NULL		Primary Key,
	OperatorID	int		NOT NULL		REFERENCES Operators,
	BidDate		date	NOT NULL		
		CONSTRAINT ckRunBidDate CHECK
		(biddate <= dateadd(mm,6,getdate())) --getdate() + 180
)
GO
/*
Schedule Table: A schedule identifies the vehicle that will perform each trip, 
with each schedule entry belonging to a run. Create a table that has an identity 
field as a primary key, and a foreign key to identify the run the schedule belongs 
to, and the vehicle performing that schedule (there are two foreign keys). 
All fields are required.
*/	
CREATE TABLE Schedules
(
	ScheduleID	int		IDENTITY		Primary Key,
	RunID			int		NOT NULL,
	VehicleID		int		NOT NULL,
	CONSTRAINT fk_Schedules_Runs FOREIGN KEY (RunID)
		REFERENCES Runs(RunID),
	CONSTRAINT fk_Schedules_Vehicles FOREIGN KEY (VehicleID)
		REFERENCES Vehicles
)	

/*
Modify the Trip table: Add a field to identify the schedule that the trip 
belongs to; this field is not required. Add a new constraint that Start 
time must fall between 5:30am and 11:50pm.
*/	
ALTER TABLE Trips
	ADD ScheduleID	int	NULL REFERENCES Schedules

ALTER TABLE Trips
	ADD CONSTRAINT ckTripsStartTime CHECK
	(StartTime BETWEEN cast('05:30 am' as time) AND cast('11:50 pm' as time))


/* homework #3 - editing data */

-- insert operators
INSERT INTO Operators(SeniorityNumber, FirstName, LastName, HireDate)
	VALUES('0001', 'David', 'Letterman', '1/1/01')

INSERT INTO Operators(SeniorityNumber, FirstName, LastName, HireDate)
	VALUES('0002', 'Tony', 'Bennet', '1/10/01')

INSERT INTO Operators(SeniorityNumber, FirstName, LastName, HireDate)
	VALUES('0003', 'Shirley', 'Temple','2/15/02')

INSERT INTO Operators(SeniorityNumber, FirstName, LastName, HireDate)
	VALUES('0004', 'John', 'Adams', '6/15/02')

INSERT INTO Operators(SeniorityNumber, FirstName, LastName, HireDate)
	VALUES('0005', 'Tanya', 'Tucker', '8/19/03')

INSERT INTO Operators(SeniorityNumber, FirstName, LastName, HireDate)
	VALUES('0006', 'Peter', 'Parker', '5/5/04')

-- insert vehicles
INSERT INTO Vehicles(Manufacturer, Model, ModelYear, PurchaseDate)
	VALUES('Gillig', '40 foot', '1998', '3/20/98')

INSERT INTO Vehicles(Manufacturer, Model, ModelYear, PurchaseDate)
	VALUES('Gillig', '40 foot', '1998', '3/20/98')

INSERT INTO Vehicles(Manufacturer, Model, ModelYear, PurchaseDate)
	VALUES('Gillig', '40 foot', '1998', '3/20/98')

INSERT INTO Vehicles(Manufacturer, Model, ModelYear, PurchaseDate)
	VALUES('Gillig', '40 foot', '1998', '3/20/98')

INSERT INTO Vehicles(Manufacturer, Model, ModelYear, PurchaseDate)
	VALUES('Gillig', 'Phantom', '1992', '11/15/02')

INSERT INTO Vehicles(Manufacturer, Model, ModelYear, PurchaseDate)
	VALUES('Gillig', 'Phantom', '1992', '11/15/02')

-- insert runs
INSERT INTO Runs(OperatorID, BidDate)
	VALUES(1, '9/1/04')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(2, '9/1/04')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(3, '9/1/04')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(4, '9/1/04')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(5, '9/1/04')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(1, '1/1/05')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(2, '1/1/05')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(3, '1/1/05')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(4, '1/1/05')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(5, '1/1/05')

INSERT INTO Runs(OperatorID, BidDate)
	VALUES(6, '1/1/05')

-- insert schedules
INSERT INTO Schedules(RunID, VehicleID)
	VALUES(1, 6)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(2, 5)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(3, 2)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(4, 3)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(5, 4)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(6, 1)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(7, 2)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(8, 3)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(9, 4)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(10, 5)

INSERT INTO Schedules(RunID, VehicleID)
	VALUES(11, 6)

-- insert trips
INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(1, '15', 'Olympia', '8:00 AM', 'L&I', '8:52 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(1, '15', 'L&I', '9:00 AM', 'Olympia', '9:49 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(2, '15', 'Olympia', '8:30 AM', 'L&I', '9:22 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(2, '15', 'L&I', '9:30 AM', 'Olympia', '10:29 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(3, '94', 'Lacey', '7:00 AM', 'Yelm', '8:11 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(4, '94', 'Lacey', '8:00 AM', 'Yelm', '9:11 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(3, '94', 'Yelm', '8:15 AM', 'Lacey', '9:26 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(4, '94', 'Yelm', '9:15 AM', 'Lacey', '10:26 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(5, '44', 'Olympia', '7:30 AM', 'Capital Mall', '8:19 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(6, '44', 'Olympia', '8:00 AM', 'Capital Mall', '8:49 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(5, '44', 'Capital Mall', '8:30 AM', 'Olympia', '9:21 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(6, '44', 'Capital Mall', '9:00 AM', 'Capital Mall', '9:51 AM', '9/1/04')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(1, '15', 'Olympia', '8:00 AM', 'L&I', '8:52 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(1, '15', 'L&I', '9:00 AM', 'Olympia', '9:49 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(2, '15', 'Olympia', '8:30 AM', 'L&I', '9:22 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(2, '15', 'L&I', '9:30 AM', 'Olympia', '10:29 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(3, '94', 'Lacey', '7:00 AM', 'Yelm', '8:11 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(4, '94', 'Lacey', '8:00 AM', 'Yelm', '9:11 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(3, '94', 'Yelm', '8:15 AM', 'Lacey', '9:26 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(4, '94', 'Yelm', '9:15 AM', 'Lacey', '10:26 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(5, '44', 'Olympia', '7:30 AM', 'Capital Mall', '8:19 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(6, '44', 'Olympia', '8:00 AM', 'Capital Mall', '8:49 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(5, '44', 'Capital Mall', '8:30 AM', 'Olympia', '9:21 AM', '1/1/05')

INSERT INTO Trips (ScheduleID, RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate)
	VALUES(6, '44', 'Capital Mall', '9:00 AM', 'Capital Mall', '9:51 AM', '1/1/05')

-- In the Trips table, change Capital Mall to Westfield Shopping Mall
-- using an Update command for all trips with an effective date after 10/1/04. 
UPDATE Trips
	Set StartLocation = 'Westfield Shopping Mall'
	WHERE StartLocation = 'Capital Mall'
	AND EffectiveDate > '10/1/2004'
	
UPDATE Trips
	Set EndLocation = 'Westfield Shopping Mall'
	WHERE EndLocation = 'Capital Mall'
	AND EffectiveDate > '10/1/2004'

-- alternative using a CASE statement as a single command
/*
UPDATE Trips
	SET StartLocation = CASE StartLocation 
		WHEN 'Capital Mall' THEN 'Westfield Shopping Mall' 
			ELSE StartLocation,
		EndLocation = CASE EndLocation
		WHEN 'Capital Mall' THEN 'Westfield Shopping Mall'
			ELSE EndLocation
		END
	WHERE (StartLocation = 'Capital Mall' OR EndLocation = 'Capital Mall')
		AND EffectiveDate > '10/1/2004'

*/	
-- Change the model year for all phantoms to 1994 using an Update command.
UPDATE Vehicles
	SET ModelYear = 1994
	WHERE Model = 'Phantom'
	
-- Delete the 9/1/04 9:15 departure from Yelm using a Delete command.
DELETE FROM Trips
	WHERE StartTime = '9:15 AM' 
	AND StartLocation = 'Yelm'
	AND EffectiveDate = '9/1/2004'

	-- Delete operator 4. Don't forget referential integrity, but do not delete any trips or vehicles. (5 points)
-- this assumes that IDENTITY values all start at 1 and increase by 1:
-- Find run ID for operator #4: 4, 9
-- Find schedule ID's for run ID's 4, 9: 4, 9
-- Set schedule id in trips to Null for those schedules
SELECT * FROM Operators
SELECT * FROM Runs 
SELECT * FROM schedules


UPDATE Trips
	SET ScheduleID = Null
	WHERE ScheduleID = 4 OR ScheduleID = 9

-- Delete those schedules:
DELETE FROM Schedules
	WHERE ScheduleID = 4 OR ScheduleID = 9

-- Delete Runs of operator 4
DELETE FROM Runs
	WHERE OperatorID = 4

-- Delete operator 4
DELETE FROM Operators
	WHERE OperatorID = 4

/*
homework 4 complete the following queries
*/
SELECT * FROM Trips
SELECT * FROM Operators
SELECT * FROM Schedules
SELECT * FROM Runs
SELECT * FROM Vehicles
--1
--a. Display all 2005 trips departing from the Olympia Transit Center sorted by departure time.
SELECT RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate, TripID 
-- will not allow me to select ScheduleID unless i use an * not sure what the problem is...couldnt find an answer online
	FROM Trips
		WHERE StartLocation = 'Olympia'
		AND EffectiveDate BETWEEN '1/1/2005' AND '12/31/2005'
			ORDER BY StartTime

--b. Display all trips for route 15 sorted by effective date, starting location and start time.
Select RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate, TripID
	FROM Trips
		WHERE RouteNumber = '15'
			ORDER BY EffectiveDate, StartLocation, StartTime

--c. Display all September 2004 trips which start before 8:00 sorted by starting location, start time, and route number.
Select RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate, TripID	
	FROM Trips
		WHERE EffectiveDate BETWEEN '09/01/2004' AND '09/30/2004'
		AND StartTime < '8:00AM'
			ORDER BY StartLocation, StartTime, RouteNumber

--d. Display the full name (as one field) and hire date of all operators hired during 2002.
SELECT FirstName + ' ' + LastName AS EmployeeName, HireDate
	FROM Operators
		WHERE HireDate BETWEEN '1/1/2002' AND '12/31/2002'
--2
--a.Display the elapsed trip time for all trips. 
SELECT * FROM Trips
SELECT  CAST(DATEDIFF(second, StartTime, EndTime) / 60 / 60 % 24  AS nvarchar(50)) + ' hours, ' + -- get the amount of hours a trip has taken
		CAST(DATEDIFF(second, StartTime, EndTime) / 60 % 60 AS nvarchar(50)) + 'minutes' AS TripTime,-- get the amount of minutes a trip has taken and combine them into one column
		RouteNumber, StartLocation, StartTime, EndLocation, EndTime, EffectiveDate, TripID
	FROM Trips


--b. Display route number, start location – end location (one field), and start time for trips departing between 8:00am and 4:00pm in January 2005.
SELECT RouteNumber + ' ' + StartLocation + '-' + EndLocation AS RouteInfo, StartTime, EffectiveDate
	FROM Trips
		WHERE StartTime BETWEEN '8:00AM' AND '4:00PM'
		AND EffectiveDate BETWEEN '1/1/2005' AND '1/31/2005'

--c. Calculate the length of service in years for all operators (difference between hire date and the current date)
SELECT FirstName + '' + LastName AS OperatorName,
		 DATEDIFF(year, HireDate, GetDate()) AS LengthofEmployment, HireDate -- get the difference between the hiredate and current date and display it in years
	FROM Operators

--3
--a.How many 2005 trips start or end in Yelm? 
SELECT COUNT(*) AS TotalTrips
	FROM Trips
		WHERE EffectiveDate BETWEEN '1/1/2005'AND'12/31/2005'
		AND StartLocation = 'yelm'
		OR EndLocation = 'yelm'

--b. Display the total number of operators hired each year. 
SELECT Count(*) AS EmployeesHired, DATEPART(year, HireDate) AS [Year]
	FROM Operators
		GROUP BY DATEPART(year, HireDate)

--c. Display the number of operators hired in each year where more than one operator was hired. 
SELECT Count(*) AS EmployeesHired, DATEPART(year, HireDate) AS [Year]
	FROM Operators
			GROUP BY DATEPART(year, HireDate)
				HAVING Count(*) >1

--d. How many operators have worked for more than three years?
SELECT Count(*) AS OperatorCount
	FROM Operators
		WHERE DATEDIFF(year, HireDate, GETDATE()) > 3

--e. What is the total elapsed time for all September 2004 trips serving Westfield Shopping Mall?
SELECT * FROM Trips
 SELECT Sum(DATEDIFF(minute,StartTime, EndTime)) / 60 AS [Hours], Sum(DATEDIFF(minute,StartTime, EndTime)) % 60 AS [Minutes]
	FROM Trips
		WHERE StartLocation LIKE '%westfield%'
		OR EndLocation LIKE '%westfield%'
		AND EffectiveDate BETWEEN '9/1/2004'AND'9/30/2016'
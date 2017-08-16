

/*homework#2 implementing relationships
cis182
durias thomas
*/

CREATE DATABASE DrivingCompany
GO

USE DrivingCompany
GO

CREATE TABLE Operators
(
	seniorityNumber			varchar(4)	not null
			CHECK	(seniorityNumber LIKE '[0-9][0-9][0-9][0-9]'),
	firstName				varchar(25) not null,
	lastName				varchar(35) not null,
	hireDate				smalldatetime not null
			CHECK	(hireDate < (GetDate()+1))
) 
GO

CREATE TABLE Trips 
(
	routeNumber				varchar(4) not null,
	startLocation			varchar(50) not null,
	endLocation				varchar(50) not null,
	startTime				time not null,
	endTime					time not null,
			CHECK	(endTime > startTime),
	effectiveDate			smalldatetime not null
			CHECK	(effectiveDate >= cast('1/1/2000' as smalldatetime))
)
GO

CREATE TABLE Vehicle
(
	manufacturer			varchar(15) DEFAULT 'Gillig',
	model					varchar(15), 
	modelYear				int DEFAULT DatePart(yyyy,GetDate())
				CHECK (modelYear <= DatePart(yyyy, GetDate())), 
	purchaseDate			smalldatetime
	
)
GO

		--add primary key to operators table
ALTER TABLE Operators
	ADD operatorID int IDENTITY(1,1)
	CONSTRAINT pk_Operators PRIMARY KEY (operatorID) 
GO
		--add primary key to trips table
ALTER TABLE Trips
	ADD tripID int IDENTITY(1,1) 
		CONSTRAINT pk_Trips PRIMARY KEY (tripID) 
GO
		--add primary key to vehicles table
ALTER TABLE Vehicle
	ADD vehicleID int IDENTITY(1,1) 
		CONSTRAINT pk_Vehicle PRIMARY KEY (vehicleID) 
GO
		/*Run Table: One operator has many work assignments, called runs.
		 Each run needs an identifier, and belongs to an operator; use an identity field for the run identifier, 
		 and include a field to serve as a foreign key for the operator table. All fields are required. 
		 The Bid Date field cannot be more than six months in the future.
		 */
CREATE TABLE Runs
(
	runID				int IDENTITY(1,1) not null,
	bidDate				date not null
				CHECK (bidDate < DateAdd(mm,6,GetDate())),
				CONSTRAINT pk_Runs PRIMARY KEY (runID),
	operatorNumber int not null,
			CONSTRAINT fk_RunsOperator FOREIGN KEY (operatorNumber)
					REFERENCES Operators(operatorID)
)
GO
		/*
		Schedule Table: A schedule identifies the vehicle that will perform each trip, with each schedule entry belonging to a run.
		Create a table that has an identity field as a primary key, and a foreign key to identify the run the schedule belongs to, and the vehicle performing that schedule. 
		All fields are required. 
		*/

CREATE TABLE Schedule
(
	scheduleID		int IDENTITY(1,1) not null,
		CONSTRAINT pk_Schedule PRIMARY KEY (scheduleID),
	runNumber		int not null,
	vehicleNumber	int not null,
		CONSTRAINT fk_ScheduleRuns FOREIGN KEY (runNumber)
			REFERENCES Runs(runID),
		CONSTRAINT fk_ScheduleVehicles FOREIGN KEY (vehicleNumber)
			REFERENCES Vehicle(vehicleID)

)
GO

		--Modify the Trip table: Add a field to identify the schedule that the trip belongs to; this field is not required.
ALTER TABLE Trips
	ADD scheduleID int null REFERENCES Schedule
		--Add a new constraint that Start time must fall between 5:30am and 11:50pm.
ALTER TABLE Trips
	ADD CHECK (startTime Between '5:30 am' and '11:50 pm')
GO

/*
Homework #6 solution
*/
-- subqueries
-- a.	Which drivers begin trips at Olympia with an Effective Date in January 2005?
-- subquery
SELECT *
	FROM operators 
		WHERE operatorid IN
			(SELECT operatorid 
				FROM Runs 
					WHERE RunID IN
						(SELECT RunID 
							FROM Schedules
								WHERE ScheduleID IN
									(SELECT ScheduleID 
										FROM Trips	
											WHERE EffectiveDate BETWEEN '1/1/2005' and '1/31/2005'
											AND StartLocation = 'Olympia')))
											
SELECT DISTINCT o.*
	FROM Operators o JOIN Runs r ON o.OperatorID = r.OperatorID 
	JOIN Schedules s ON r.RunID=s.RunID 
	JOIN Trips t ON s.ScheduleID = t.ScheduleID 
		WHERE EffectiveDate BETWEEN '1/1/2005' and '1/31/2005'
		AND StartLocation = 'Olympia'

--	b.	Do any drivers use more than one bus on their run where the Bid Date is in September 2004?
SELECT *
	FROM Operators 
		WHERE OperatorID IN
			(SELECT OperatorID 
				FROM Runs 
					WHERE BidDate between '9/1/2004' and '9/30/2004' 
					AND RunID IN
						(SELECT RunID 
							FROM Schedules 
								GROUP BY RunID 
									HAVING COUNT(distinct vehicleid)>1))
									
SELECT o.operatorid, firstname, lastname
	FROM Operators o JOIN Runs r ON o.OperatorID = r.OperatorID 
	JOIN Schedules s ON r.RunID = s.ScheduleID 
		WHERE BidDate between '9/1/2004' and '9/30/2004'
			GROUP BY o.OperatorID, FirstName, LastName, r.runid 
				HAVING COUNT(distinct vehicleID) >1 								

--	c.	Which drivers make trips that last longer than 45 minutes?
SELECT *
	FROM Operators 
		WHERE OperatorID IN
			(SELECT OperatorID 
				FROM Runs 
					WHERE RunID IN
						(SELECT RunID
							FROM Schedules 
								WHERE ScheduleID IN
									(SELECT ScheduleID 
										FROM Trips 
											WHERE DATEDIFF(mi,starttime,EndTime)>45)))

SELECT DISTINCT o.*
	FROM Operators o JOIN Runs r ON o.OperatorID = r.OperatorID 
	JOIN Schedules s ON r.RunID = s.RunID 
	JOIN Trips t on s.ScheduleID = t.ScheduleID 
		WHERE DATEDIFF(mi,starttime,EndTime)>45

--	d.	Which trips are operated by Phantoms and have an Effective Date in 2005?
SELECT *
	FROM Trips
		WHERE EffectiveDate Between '1/1/2005' AND '12/31/2005'
		AND ScheduleID IN
			(SELECT ScheduleID 
				FROM Schedules 
					WHERE VehicleID IN
						(SELECT VehicleID 
							FROM Vehicles 
								WHERE model = 'Phantom'))

SELECT t.*
	FROM Trips t JOIN Schedules s ON t.ScheduleID = s.ScheduleID 
	JOIN Vehicles v ON s.VehicleID=v.VehicleID 
		WHERE model='phantom'
		AND EffectiveDate Between '1/1/2005' AND '12/31/2005'
		
-- Display trips with an Effective Date in 2005 made by Operators with less than three years on the job.
-- this can be done with all subqueries - no reason to use JOIN
-- read notes from the bottom up (precedence!)
SELECT *
	FROM Trips
		WHERE EffectiveDate >= '1/1/2005' AND EffectiveDate < '1/1/2006'
		AND ScheduleID IN							-- get trips in those schedules
			(SELECT ScheduleID							-- get schedules for runs for those operators
				FROM Schedules
					WHERE RunID IN
						(SELECT RunID						-- get runs for those operators
							FROM Runs
								WHERE OperatorID IN
									(SELECT OperatorID	-- build list of operators with less than three years on job
										FROM Operators 
											WHERE DATEDIFF(YY,HireDate,GETDATE())<3)))

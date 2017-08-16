/*
1	Each query is worth two points.
a.	Display the Run ID and all fields from the trips table for each trip using an inner-join.
b.	Display the vehicle name used for each trip, and all fields from the trip table, using a natural join.
c.	Display each Operator and the vehicles that he/she drives using an inner-join (operator name, manufacturer, model, vehicle id).
*/
SELECT runid, t.*
	FROM Trips t JOIN Schedules s ON t.ScheduleID = s.ScheduleID 

SELECT Model, t.*
	FROM Vehicles v, Schedules s, Trips t
		WHERE v.VehicleID=s.VehicleID 
		AND s.ScheduleID=t.ScheduleID 

SELECT firstname + ' ' + lastname Operator, model, Modelyear
	FROM Operators o JOIN Runs r ON o.OperatorID = r.OperatorID 
	JOIN Schedules s ON r.RunID =s.RunID 
	JOIN Vehicles v ON s.VehicleID = v.VehicleID 
/*
2.	Each query is worth three points.
a.	Display the count of trips for each January 2005 run using a natural join (test the Bid Date field in Runs).
b.	Calculate the number of trips Vehicle #3 made in September 2004's schedule using an inner-join (you may need to refer to assignment #1 for the correct vehicle, depending on identity values) (use the Effective Date in Trips).
c.	List any routes that have more than one bus operating trips grouped by Effective Date.
d.	Calculate the number of Operators who start at or arrive at Lacey in January 2005 (use Effective Date in Trips).
e.	Insert a new vehicle (CityCruiser, 35 foot, 1996); create a list of buses and trip details, including all buses.
*/
SELECT r.runid, COUNT(*) TripCount
	FROM Runs r, Schedules s, Trips t
		WHERE r.RunID = s.RunID and s.ScheduleID= t.ScheduleID 
		AND r.BidDate between '1/1/2005' and '1/31/2005'
			GROUP BY r.RunID 

SELECT COUNT(*) Vehicle3Trips
	FROM Trips t JOIN Schedules s ON t.ScheduleID=s.ScheduleID
		WHERE VehicleID = '3'
		AND t.EffectiveDate between '9/1/2004' and '9/30/2004'

SELECT routenumber, EffectiveDate, COUNT(distinct vehicleid) VehicleCount 
	FROM Trips t JOIN Schedules s ON t.ScheduleID = s.ScheduleID 
		GROUP BY RouteNumber, EffectiveDate 
			HAVING COUNT(distinct vehicleid)>1

SELECT COUNT(distinct operatorid) DifferentOperators
	FROM Trips t JOIN Schedules s ON t.ScheduleID= s.ScheduleID 
	JOIN Runs r ON s.RunID = r.RunID 
		WHERE (StartLocation like '%lacey%' OR EndLocation LIKE '%lacey%') 
		AND EffectiveDate between '1/1/2005' and '1/31/2005'		

INSERT INTO Vehicles(Manufacturer, Model, ModelYear, PurchaseDate)
	VALUES('CityCruiser', '35 foot', 1996,'11/20/2009')
	
SELECT v.*, t.*
	FROM Vehicles v LEFT OUTER JOIN Schedules s ON v.VehicleID=s.VehicleID
	LEFT OUTER JOIN Trips t ON s.ScheduleID=t.ScheduleID 

/*
3.	Four points:
Display the Operator name, vehicle model, start location, and start time for all trips starting after 9:00 am in September 2004.
*/
SELECT firstname + ' ' +  lastname Operator, model, startlocation, endlocation, starttime
	FROM Operators o JOIN Runs r ON o.OperatorID = r.OperatorID 
	JOIN Schedules s ON r.RunID = s.RunID 
	JOIN Vehicles v ON s.VehicleID = v.VehicleID 
	RIGHT OUTER JOIN Trips t ON s.ScheduleID = t.ScheduleID 
		WHERE StartTime > '9:00 am'
		AND EffectiveDate Between '9/1/2004' and '9/30/2004'
		

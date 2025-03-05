--1)How can you retrieve all the information from the cd.facilities table
SELECT * FROM cd.facilities;

--2)You want to print out a list of all of the facilities and their cost to members.How would you retrieve a list of only facility names and costs?
SELECT name,membercost FROM cd.facilities;

--3)How can you produce a list of facilities that charge a fee to members
SELECT name,membercost FROM cd.facilities
WHERE membercost > 0;

--4)How can you produce a list of facilities that charge a fee to members and that fee is less than 1/50th of the monthly maintenance cost
--Return the facid,facilityname membercost and monthly maintenance
SELECT facid,name,membercost,monthlymaintenance FROM cd.facilities
WHERE membercost > 0 AND (monthlymaintenance/50) > membercost;

--5)How you can produce a list of all facilities the word Tennis in their name
SELECT * FROM cd.facilities
WHERE name LIKE '%Tennis%';

--6)How can you retrieve the details of facilities with ID 1 and 5
SELECT * FROM cd.facilities
WHERE facid = 1 OR facid = 5;
--2nd solution with IN
SELECT * FROM cd.facilities
WHERE facid IN (1,5);

--7)How can you produce a list of members who joined after the start of September 2012 ? Return the memid,surname,firstname and joindate
SELECT memid,surname,firstname,joindate FROM cd.members
WHERE joindate >= '2012-09-01';

--8) How can you produce an orrdered list of the first 10 surnames in the members table do not contain duplicates
SELECT DISTINCT(surname) FROM cd.members
ORDER BY surname ASC 
LIMIT 10;

--9)signup date of your last member
SELECT MAX(joindate) FROM cd.members;

--10)Produce a count of the number of facilities that have a cost to guest of 10 or more
SELECT COUNT(guestcost) FROM cd.facilities
WHERE guestcost >= 10.0;

--11)Produce a list of the total numbers of slots booked per facility in the month of September 2012
--Produce an output table consisting of facility id and slots sorted the number of slots
SELECT facid,SUM(slots) AS total_slots
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND 
starttime <= '2012-10-01'
GROUP BY facid ORDER BY SUM(slots);

--12)Produce a list of facilities with more than 1000 slots booked.Produce an output table consisting of facility id and total slots sorted by facility id
SELECT facid,SUM(slots) AS total_slots
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid;

--13)How can you produce a list of the start times for bookings for tennis courts for the date '2012-09-21'
--return a list of start time and facility name pairings ordered by time
SELECT cd.facilities.name,cd.bookings.starttime FROM cd.bookings
INNER JOIN cd.facilities
ON cd.bookings.facid = cd.facilities.facid
WHERE cd.facilities.name IN ('Tennis Court 1','Tennis Court 2')
AND cd.bookings.starttime >= '2012-09-21'
AND cd.bookings.starttime < '2012-09-22'
ORDER BY cd.bookings.starttime;

--14) How can you produce a list of the start times for bookings by members named 'David Farrll'
SELECT cd.bookings.starttime
FROM cd.bookings
INNER JOIN cd.members ON 
cd.members.memid = cd.bookings.memid
WHERE cd.members.firstname = 'David' AND
cd.members.surname = 'Farrell'





/* -----------------------------------------------------*/
/*         SQL Primer: Taxi Trip Data Example           */
/*  Do Taxi Rides Take Longer with Multipe Passengers?  */
/* -----------------------------------------------------*/

/* ------------------------*/
/* 1.) Create a Data Table */
CREATE TABLE taxi (
  trip_id INTEGER PRIMARY KEY,
  taxi_id INTEGER,
  trip_date DATE, 
  trip_dist INTEGER,
  trip_time INTEGER,  
  passengers INTEGER
   );

/* Populate the Table with Data */
INSERT INTO taxi VALUES (10001, 101, '2013-05-21', 3, 15, 2);
INSERT INTO taxi VALUES (10002, 109, '2013-05-21', 5, 18, 1);
INSERT INTO taxi VALUES (10003, 115, '2013-05-21', 10, 17, 1);
INSERT INTO taxi VALUES (10004, 101, '2013-05-21', 1, 5, 1);
INSERT INTO taxi VALUES (10005, 113, '2013-05-22', 4, 35, 3);
INSERT INTO taxi VALUES (10006, 101, '2013-05-22', 1, 8, 2);
INSERT INTO taxi VALUES (10007, 109, '2013-05-22', 10, 10, 1);
INSERT INTO taxi VALUES (10008, 109, '2013-05-23', 4, 10, 1);
INSERT INTO taxi VALUES (10009, 113, '2013-05-23', 4, 25, 2);
INSERT INTO taxi VALUES (10010, 115, '2013-05-24', 9, 35, 2);


/* Retrieve Full Data Table */
SELECT * FROM taxi;


/* Retrieve a subset of the Table */
SELECT * FROM taxi LIMIT 5;


/* Order Data by Passengers */
SELECT * FROM taxi ORDER BY passengers DESC;


/* ------------------*/
/* 2.) Basic Queries */


/* How many taxi drivers are observed? */
SELECT taxi_id, COUNT(trip_id) FROM taxi GROUP BY taxi_id;


/* How many trips were made by day? */
SELECT trip_date, COUNT(trip_id) FROM taxi GROUP BY trip_date;


/* How many taxi rides had 2 or more passengers? */
SELECT * FROM taxi WHERE passengers > 1;



/* How many trips took longer than 0.4 miles per minute? */
/* Create a Variable with an ALIAS */
SELECT trip_id, taxi_id, trip_date, passengers, trip_dist/trip_time AS trip_MPM FROM taxi;

SELECT trip_id, taxi_id, trip_date, passengers, trip_dist/trip_time AS trip_MPM 
  FROM taxi 
  WHERE trip_dist/trip_time > 0.3;


/* ----------*/
/* 3.) Joins */

CREATE TABLE weather (
  trip_date DATE, 
  conditions TEXT
   );

INSERT INTO weather VALUES ('2013-05-21', 'sunny' );
INSERT INTO weather VALUES ('2013-05-22', 'heavy rain');
INSERT INTO weather VALUES ('2013-05-23', 'cloudy');

SELECT * FROM weather;


/* Cross Join */
SELECT * FROM taxi, weather;


/* Inner Join */
SELECT * FROM taxi
  JOIN weather
  ON taxi.trip_date = weather.trip_date;


/* Outer Join (Left) */
SELECT * FROM taxi
  LEFT OUTER JOIN weather
  ON taxi.trip_date = weather.trip_date;


/* ---------------------------*/
/* 4.) Subsetting Merged Data */


/* First 5 observations of merged Taxi Trips */
SELECT * FROM taxi
  LEFT OUTER JOIN weather
  ON taxi.trip_date = weather.trip_date
  LIMIT 5;

/* Merged Taxi Trips with Multiple Passengers */
SELECT * FROM taxi
  LEFT OUTER JOIN weather
  ON taxi.trip_date = weather.trip_date
  WHERE taxi.passengers >1;


/* Merged Taxi Trips on Specific Dates */
SELECT * FROM taxi
  LEFT OUTER JOIN weather
  ON taxi.trip_date = weather.trip_date
  WHERE taxi.trip_date IN ("2013-05-21", "2013-05-22");







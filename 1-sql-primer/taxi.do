*##########################################*
*### SQL Primer: Taxi Trip Data Example ###*
*###     Accessing KDC Data from R      ###*
*##########################################*

*# Main Questions: Are Taxi Rides Faster on Sunny Days?

*# 1.) Import Taxi Data from KDC
*# 2.) Reformat Data to Answer Question
*#     a. Separate Dropoff_DateTime into 2 variables for date and time
*#     b. Calculate a variable for trip_MPS (Miles per Second)
*#     c. Merge taxi data with weather data (not on KDC)
*# 3.) Run a Linear Regression
*# 4.) Plot the data

*---------------------------------------------
* clear workspace
clear

* Create a login.do file within your home directory 
* local usern "kellogg\<net_id>"
* local passw "<net id password>"

*------------------------------------------------------------------
* 1.) Import Taxi Data and Run General Queries (Select Statements)
*------------------------------------------------------------------

* run password file and clear results screen
do "~/login.do"
cls

* setup ODBC connection for a general query
set odbcmgr unixodbc
odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("SELECT COUNT(*) as fare_count FROM TAXI_NYC.dbo.SRC_FareData")
list fare_count
drop fare_count

* separate the query into a separate text variable
local odcmd "SELECT COUNT(*) as fare_count FROM TAXI_NYC.dbo.SRC_FareData"
odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("`odcmd'")
list fare_count
drop fare_count

* write query using SQL syntax
local odcmd ///
	SELECT ///
		COUNT(*) as fare_count ///
	FROM TAXI_NYC.dbo.SRC_FareData ///

odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("`odcmd'")
list fare_count
drop fare_count

* write a query on the second table
local odcmd ///
	SELECT ///
		COUNT(*) as trip_count ///
	FROM TAXI_NYC.dbo.SRC_TripData ///

odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("`odcmd'")
list trip_count
drop trip_count

* take a cursory look at the data tables; what variables are included
odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("SELECT TOP 1000 * FROM TAXI_NYC.dbo.SRC_FareData")
describe
drop _all

odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("SELECT TOP 1000 * FROM TAXI_NYC.dbo.SRC_TripData")
describe
drop _all


* combine the tables (what happened?)
local odcmd ///
SELECT TOP(1000) ///
t.hack_license, ///
f.[ hack_license], ///
t.medallion, ///
f.medallion, ///
t.vendor_id, ///
f.[ vendor_id], ///
t.pickup_datetime, ///
f.[ pickup_datetime], ///
t.dropoff_datetime, ///
t.trip_distance, ///
t.trip_time_in_secs, ///
t.passenger_count, ///
f.[ fare_amount] ///
FROM TAXI_NYC.dbo.SRC_TripData as t ///
LEFT OUTER JOIN TAXI_NYC.dbo.SRC_FareData as f ///
ON (t.hack_license = f.[ hack_license]) ///
AND (t.medallion = f.medallion) ///
AND (t.vendor_id = f.[ vendor_id]) ///
AND (t.pickup_datetime = f.[ pickup_datetime]) ///

* establish connection to run query
odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("`odcmd'")
describe

* Explanation of Error: https://www.stata.com/statalist/archive/2011-06/msg00265.html

* remove duplicated variable
local odcmd ///
SELECT TOP(1000) ///
t.hack_license, ///
f.[ hack_license], ///
t.vendor_id, ///
f.[ vendor_id], ///
t.pickup_datetime, ///
f.[ pickup_datetime], ///
t.dropoff_datetime, ///
t.trip_distance, ///
t.trip_time_in_secs, ///
t.passenger_count, ///
f.[ fare_amount] ///
FROM TAXI_NYC.dbo.SRC_TripData as t ///
LEFT OUTER JOIN TAXI_NYC.dbo.SRC_FareData as f ///
ON (t.hack_license = f.[ hack_license]) ///
AND (t.vendor_id = f.[ vendor_id]) ///
AND (t.pickup_datetime = f.[ pickup_datetime]) ///

* establish connection to run query
odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("`odcmd'")
describe

import delimited using /kellogg/proj/awc6034/Training/Workshop_2020/taxi_trip.csv

*-----------------------------
* 2.) Reformat the Taxi Data 
*-----------------------------
* Remove Invalid time observations
drop if trip_time_in_secs == 0


* a.) Separate Pickup_DateTime into Two Variables for Date and Time

rename pickup_datetime pickup
rename dropoff_datetime dropoff

split pickup, p(" ")
rename pickup1 pickup_date
rename pickup2 pickup_time

split dropoff, p(" ")
rename dropoff1 dropoff_date
rename dropoff2 dropoff_time

* b.) Create a miles per hour variable
gen trip_MPH = trip_distance/((trip_time_in_secs/60)/60)

drop if trip_MPH > 75
drop if passenger_count > 5

tempfile taxi
save taxi.dta
clear

* c.) Merge Taxi data with Weather Data
import delimited using /kellogg/proj/awc6034/Training/Workshop_2020/weather.csv
rename v1 pickup_date
rename v2 condition


* merge datasets
merge 1:m pickup_date using taxi.dta

*-----------------------------
* 3.) Run a Regression
*-----------------------------

xi: regress trip_MPH i.condition passenger_count

*taxi.predict <- cbind(taxi, predict(taxi.mod, interval = 'confidence'))

*-----------------------------
* 4.) Plot the data 
*-----------------------------

lfit (passenger_count trip_MPH)




















*##########################################*
*### SQL Primer: Taxi Trip Data Example ###*
*###     Accessing KDC Data from STATA  ###*
*##########################################*

*# Main Questions: Are Taxi Rides Faster on Sunny Days?

*# 1.) Import Taxi Data from KDC
*# 2.) Reformat Data to Answer Question
*#     a. Separate Dropoff_DateTime into 2 variables for date and time
*#     b. Calculate a variable for trip_MPS (Miles per Second)
*#     c. Merge taxi data with weather data (not on KDC)
*# 3.) Run a Linear Regression and plot the data

*---------------------------------------------
* Connecting on KLC

* From a GNOME terminal session on FastX, type the following:
* export ODBCSYSINI=~/.odbc/
* module load stata/15
* xstata-mp

*---------------------------------------------
* clear workspace
clear

* Create a login.do file within your home directory 
*local usern "kellogg\<your_netID>"
*local passw "<your_password>"

* To see the contents of an object
*display "`passw'"

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


* combine the tables for trips on 5/20/13
local odcmd ///
SELECT TOP(1000) ///
t.hack_license, ///
t.medallion, ///
t.vendor_id, ///
t.pickup_datetime, ///
t.dropoff_datetime, ///
t.trip_distance, ///
t.trip_time_in_secs, ///
t.passenger_count, ///
f.[ fare_amount] ///
FROM TAXI_NYC.dbo.SRC_TripData as t ///
LEFT OUTER JOIN TAXI_NYC.dbo.SRC_FareData as f ///
ON (t.hack_license = f.[ hack_license]) ///
AND (t.medallion = f.[medallion]) ///
AND (t.vendor_id = f.[ vendor_id]) ///
AND (t.pickup_datetime = f.[ pickup_datetime]) ///
WHERE t.pickup_datetime LIKE '2013-05-20%' ///
ORDER BY t.pickup_datetime ///

* establish connection to run query
odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("`odcmd'")
describe

tempfile taxi1
save taxi1.dta, replace
clear

* combine the tables for trips on 6/20/13
local odcmd ///
SELECT TOP(1000) ///
t.hack_license, ///
t.medallion, ///
t.vendor_id, ///
t.pickup_datetime, ///
t.dropoff_datetime, ///
t.trip_distance, ///
t.trip_time_in_secs, ///
t.passenger_count, ///
f.[ fare_amount] ///
FROM TAXI_NYC.dbo.SRC_TripData as t ///
LEFT OUTER JOIN TAXI_NYC.dbo.SRC_FareData as f ///
ON (t.hack_license = f.[ hack_license]) ///
AND (t.medallion = f.[medallion]) ///
AND (t.vendor_id = f.[ vendor_id]) ///
AND (t.pickup_datetime = f.[ pickup_datetime]) ///
WHERE t.pickup_datetime LIKE '2013-06-20%' ///
ORDER BY t.pickup_datetime ///

* establish connection to run query
odbc load, dsn("kdc-tds") user("`usern'") password("`passw'") exec("`odcmd'")
describe

* combine taxi data for two dates
append using taxi1.dta
destring , replace

drop _all
import delimited using taxi_backup.csv

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
drop if passenger_count > 4

tempfile taxi
save taxi.dta, replace
clear

* c.) Merge Taxi data with Weather Data
import delimited using weather.csv
rename v1 pickup_date
rename v2 condition


* merge datasets
merge 1:m pickup_date using taxi.dta

*-----------------------------
* 3.) Run a Regression
*-----------------------------

xi: regress trip_MPH i.condition passenger_count

*ssc inst sepscatter
sepscatter trip_MPH passenger_count , sep(condition) mc(red blue) addplot(qfitci trip_MPH passenger_count if condition=="cloudy_rain", lc(red) || qfitci trip_MPH passenger_count if condition=="sunny", lc(blue)) legend(order(1 2))



















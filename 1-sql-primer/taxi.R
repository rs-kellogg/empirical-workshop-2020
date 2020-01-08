##########################################
### SQL Primer: Taxi Trip Data Example ###
###     Accessing KDC Data from R      ###
##########################################

# Main Questions: Are Taxi Rides Faster on Sunny Days?
# 1.) Import Taxi Data from KDC
# 2.) Reformat Data to Answer Question
#     a. Separate Dropoff_DateTime into 2 variables for date and time
#     b. Calculate a variable for trip_MPS (Miles per Second)
#     c. Merge taxi data with weather data (not on KDC)
# 3.) Run a Linear Regression and Graph Results

#####################################
# Connecting on KLC

# From a FastX webbrowser or Desktop client
# Select R/3.3.1 from the bookmarks

# clear workspace
rm(list=ls())

#####################################
# 1.) Import Taxi Data

# Install Packages
#install.packages("RODBC")
#install.packages("getPass")
Sys.setenv(ODBCSYSINI = '/home/<your_netID>/.odbc')


# Establish an ODBC connection
library(RODBC)
library(getPass)

conn <- odbcConnect("kdc-tds", uid="kellogg\\<your_netID>", pwd=getPass())

# Preview the Data: Number of Observations in the Trip and Fare databases 
taxi_fare_count <- sqlQuery(conn, "SELECT COUNT(*) FROM TAXI_NYC.dbo.SRC_FareData")
taxi_fare_count

taxi_trip_count <- sqlQuery(conn, "SELECT COUNT(*) FROM TAXI_NYC.dbo.SRC_TripData")
taxi_trip_count

rm(taxi_fare_count, taxi_trip_count)


# Preview the first 1000 Observations in 3 ways

# (I.)
taxi_fare <- sqlQuery(conn, "SELECT * FROM TAXI_NYC.dbo.SRC_FareData", max = 1000)
taxi_trip <- sqlQuery(conn, "SELECT * FROM TAXI_NYC.dbo.SRC_TripData", max = 1000)

# (II.)
taxi_fare <- sqlQuery(conn, "SELECT TOP 1000 * FROM TAXI_NYC.dbo.SRC_FareData")
taxi_trip <- sqlQuery(conn, "SELECT TOP 1000 * FROM TAXI_NYC.dbo.SRC_TripData")

# (II.)
query1 <-
"
  SELECT TOP 1000 *
    FROM TAXI_NYC.dbo.SRC_FareData
"
taxi_fare <- sqlQuery(conn, gsub("\\n\\s+", " ", query1), max = 1000)

# Import the Entire Dataset
# taxi_fare <- sqlQuery(conn, "SELECT * FROM TAXI_NYC.dbo.SRC_FareData")
# taxi_trip <- sqlQuery(conn, "SELECT * FROM TAXI_NYC.dbo.SRC_TripData")

rm(taxi_trip, taxi_fare, query1)

# Join the Fare and Trip Datasets for trips on 5/20/13

query2 <- 
"
  SELECT 
    Trip.hack_license,
    Trip.medallion,
    Trip.vendor_id,
    Trip.pickup_datetime,
    Trip.dropoff_datetime,
    Trip.trip_distance,
    Trip.trip_time_in_secs,
    Trip.passenger_count,
    Fare.[ fare_amount] 
    FROM TAXI_NYC.dbo.SRC_TripData as Trip
    LEFT OUTER JOIN TAXI_NYC.dbo.SRC_FareData as Fare
    ON (Trip.hack_license = Fare.[ hack_license])
    AND (Trip.medallion = Fare.medallion)
    AND (Trip.vendor_id = Fare.[ vendor_id])
    AND (Trip.pickup_datetime = Fare.[ pickup_datetime])
    WHERE Trip.pickup_datetime LIKE '2013-05-20%'
    ORDER BY Trip.pickup_datetime
"

taxi1 <- sqlQuery(conn, gsub("\\n\\s+", " ", query2), max = 1000)

# trips on 6/20/13
query3 <- 
  "
  SELECT 
    Trip.hack_license,
    Trip.medallion,
    Trip.vendor_id,
    Trip.pickup_datetime,
    Trip.dropoff_datetime,
    Trip.trip_distance,
    Trip.trip_time_in_secs,
    Trip.passenger_count,
    Fare.[ fare_amount] 
    FROM TAXI_NYC.dbo.SRC_TripData as Trip
    LEFT OUTER JOIN TAXI_NYC.dbo.SRC_FareData as Fare
    ON (Trip.hack_license = Fare.[ hack_license])
    AND (Trip.medallion = Fare.medallion)
    AND (Trip.vendor_id = Fare.[ vendor_id])
    AND (Trip.pickup_datetime = Fare.[ pickup_datetime])
    Where Trip.pickup_datetime LIKE '2013-06-20%'
    ORDER BY Trip.pickup_datetime
"

taxi2 <- sqlQuery(conn, gsub("\\n\\s+", " ", query3), max = 1000)


taxi <- rbind(taxi1, taxi2)
rm(taxi1, taxi2, query2, query3)

# Just in case the query takes too long, read in the dataframe
taxi <- read.csv(file="taxi_backup.csv", header=TRUE, sep=",")


#####################################
# 2.) Reformat the Taxi Data

# Remove Invalid time observations
taxi <- subset(taxi, taxi$trip_time_in_secs > 0) 

# Separate Pickup_DateTime into Two Variables for Date and Time
colnames(taxi)
library(plyr); library(tidyr)

taxi <- rename(taxi, c("pickup_datetime" = "pickup"))
taxi <- rename(taxi, c("dropoff_datetime" = "dropoff"))

taxi <- separate(taxi, pickup, into = c("pickup_date", "pickup_time"), sep = " ")
taxi <- separate(taxi, dropoff, into = c("dropoff_date", "dropoff_time"), sep = " ")

# Create a miles per hour variable
taxi$trip_MPH <- taxi$trip_distance/((taxi$trip_time_in_secs/60)/60)

taxi <- subset(taxi, taxi$trip_MPH <75 & taxi$passenger_count < 5)


# Merge Taxi data with Weather Data
weather <- data.frame(pickup_date=c("2013-05-20", "2013-06-20"), 
                      condition=c('sunny', 'cloudy/rain'))

taxi <- join(taxi, weather, by="pickup_date", type="left", match="all")


#####################################
# 3.) Run a Regression and graph results
taxi.mod <- lm(trip_MPH ~ passenger_count + factor(condition), data=taxi)
summary(taxi.mod)

taxi.predict <- cbind(taxi, predict(taxi.mod, interval = 'confidence'))

library(ggplot2)
ggplot(taxi.predict, aes(y=trip_MPH, x= passenger_count, color=condition)) +
  geom_point()+
  geom_line(aes(passenger_count,fit))+
  geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.3)+
  xlab("Passengers") + ylab("Trip MPH")

odbcClose(conn)

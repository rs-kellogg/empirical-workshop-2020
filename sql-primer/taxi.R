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
# 3.) Run a Linear Regression


# clear workspace
rm(list=ls())

#####################################
# 1.) Import Taxi Data

# Install Packages
#install.packages("RODBC")
#install.packages("getPass")
Sys.setenv(ODBCSYSINI = '/home/awc6034/.odbc')


# Establish an ODBC connection
library(RODBC)
library(getPass)
passwordAC <- getPass()

conn <- odbcConnect("kdc-tds", uid="kellogg\\awc6034", pwd=passwordAC)
rm(passwordAC)

# Preview the Data: Number of Observations in the Trip and Fare databases 
taxi_fare_count <- sqlQuery(conn, "SELECT COUNT(*) FROM TAXI_NYC.dbo.SRC_FareData")
taxi_fare_count

taxi_trip_count <- sqlQuery(conn, "SELECT COUNT(*) FROM TAXI_NYC.dbo.SRC_TripData")
taxi_trip_count

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

# Join the Fare and Trip Datasets
query2 <- 
"
  SELECT * FROM TAXI_NYC.dbo.SRC_TripData as Trip
    LEFT OUTER JOIN TAXI_NYC.dbo.SRC_FareData as Fare
    ON (Trip.hack_license = Fare.[ hack_license])
    AND (Trip.medallion = Fare.medallion)
    AND (Trip.vendor_id = Fare.[ vendor_id])
    AND (Trip.pickup_datetime = Fare.[ pickup_datetime])
"

taxi <- sqlQuery(conn, gsub("\\n\\s+", " ", query2), max = 1000)

# Just in case the query takes too long
taxi <- read.csv(file="/kellogg/proj/awc6034/Training/Fellows/KDC/taxi_trip.csv", 
                 header=TRUE, sep=",")

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
weather <- data.frame(pickup_date=c("5/21/13", "5/20/13", "6/21/13", "6/20/13"), 
                      condition=c('heavy rain', 'heavy rain', 'sunny', 'sunny'))

taxi <- join(taxi, weather, by="pickup_date", type="left", match="all")

#####################################
# 3.) Run a Regression 
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

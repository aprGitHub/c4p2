################################
# QUESTION 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008. 
# For deeper explanation turn to: https://github.com/aprGitHub/c4p2
################################
library(plyr)
###################################
# MAIN ROUTINE: plot1.R
# 1. Ad-hoc function to download the data for this exercise, be patient, it takes a while:-! 
source("downloadAndUnzip.R")
data <- downloadAndUnzip()

# 2. Get the sub-set required, summing up the Emmissions 
dataSumEmissionsByYear <- ddply(data, .(year), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))
rm(data) # Remove the object (otherwise my old laptop may run out of memory:)

# 3. Plot and save the file
plot(dataSumEmissionsByYear$year,dataSumEmissionsByYear$sumEmissions,type="b",xlab="Year",ylab="PM25-PRI Emissions",main="Emissions by Year")
pngFile <- "plot1.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
###################################

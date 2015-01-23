################################
# QUESTION 2:Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.
# For deeper explanation turn to: https://github.com/aprGitHub/c4p2
################################

library(plyr)
###################################
# MAIN ROUTINE: plot2.R
# 1. Ad-hoc function to download the data for this exercise, be patient, it takes a while:-! 
source("downloadAndUnzip.R")
data <- downloadAndUnzip()

# 2. Get the data associated to Baltimore (i.e. fips == "24510")
dataBaltimore <- subset(data, fips == "24510", select=c(year, Emissions)) 
rm(data) 

# 3. Get the sum of the emissions by year
dataSumEmissionsByYear <- ddply(dataBaltimore, .(year), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))

# 4. Plot and save the file
plot(dataSumEmissionsByYear$year,dataSumEmissionsByYear$sumEmissions,type="b",xlab="Year",ylab="PM25-PRI Emissions",main="Emissions by Year in Baltimore City")
# axis 

pngFile <- "plot2.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
###################################



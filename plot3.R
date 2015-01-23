################################
# QUESTION 3: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.
################################
library(plyr)
library(ggplot2)
###################################
# MAIN ROUTINE: plot3.R
# 1. Ad-hoc function to download the data for this exercise, be patient, it takes a while:-! 
source("downloadAndUnzip.R")
data <- downloadAndUnzip()

# 2. Get the data associated to Baltimore (i.e. fips == "24510")
dataBaltimore <- subset(data, fips == "24510",select=c(year, type, Emissions)) 
rm(data)

# 3. Get the sum of the emissions by year  
dataSumEmissionsByYearType <- ddply(dataBaltimore, .(year,type), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))

# 4.  Plot and save the file
ggplot(dataSumEmissionsByYearType, aes(year, sumEmissions))  + facet_grid(. ~ type)  + ggtitle("Emissions in Baltimore City for each type of source") + geom_point() + geom_line() + geom_line(aes(colour=type)) + ylab("Emissions")
# This is also a nice plot: qplot(year,data=dataBaltimore,facets=.~type,binwidth=0.5)

pngFile <- "plot3.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
###################################

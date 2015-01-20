library(plyr)
library(ggplot2)

source("downloadFromURLAndUnzip.R")

# 1. Ad-hoc function to download the data for this exercise 
downloadFromURLAndUnzip()

# 2. Read the data into R objects. This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# 3. Merge the data add the Short.Name related to the SCC code
SCCsub <- subset(SCC,select=c(SCC,Short.Name))
NEIsub <- subset(NEI,select=-c(Pollutant))# remove Pollutant because it is redundant: unique(data$Pollutant)="PM25-PRI" allways
rm(NEI,SCC) # Remove the object (otherwise my old laptop may run out of memory:)

data <- merge(SCCsub, NEIsub,by="SCC") 
rm(NEIsub,SCCsub) # Remove the object (otherwise my old laptop may run out of memory:)

# 4. Get the data associated to Baltimore (i.e. fips == "24510")
dataBaltimore <- subset(data, fips == "24510",select=c(year, type)) # 
rm(data)

# 5.  Plot and save the file
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question. 
qplot(year,data=dataBaltimore,facets=.~type,binwidth=0.5)
#qplot(year,data=dataBaltimore,fill=type,geom="density") 
#qplot(year,data=dataBaltimore,facets=.~type,geom="density")

pngFile <- "plot3.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
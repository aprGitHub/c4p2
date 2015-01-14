library(plyr)
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
rm(NEIsub,NEIsub) # Remove the object (otherwise my old laptop may run out of memory:)

# 4. Get the data associated to Baltimore (i.e. fips == "24510")
dataBaltimore <- subset(data, fips == "24510",select=c(year, Emissions)) # 
rm(data)

# 5. Get the sum of the emissions by year
dataSumEmissionsByYear <- ddply(dataBaltimore, .(year), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))

# 6. Plot and save the file
plot(dataSumEmissionsByYear$year,dataSumEmissionsByYear$sumEmissions,type="b",xlab="Year",ylab="PM25-PRI Emissions",main="Emissions by Year in Baltimore City")
#Plot the x-axis that contains the year
axis(1, at=as.integer(aggData$Year), las=1)

pngFile <- "plot2.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
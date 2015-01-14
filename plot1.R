library(plyr)
source("downloadFromURLAndUnzip.R")

# 1. Ad-hoc function to download the data for this exercise 
downloadFromURLAndUnzip()

# 2. Read the data into R objects. This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# 3. Merge the data add the Short.Name related to the SCC code
SCCSubset<-subset(SCC,select=c(SCC,Short.Name))
data<-merge(SCCSubset,NEI,by="SCC")
#dataSumEmissionsByYear <- ddply(data, .(year), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))
dataSumEmissionsByYear <- ddply(data, .(year), sumEmissions = sum(Emissions, na.rm = TRUE))
# 4. Remove the object (otherwise my old laptop may run out of memory:)
rm(data)

# 5. Plot and save the file
plot(dataSumEmissionsByYear$year,dataSumEmissionsByYear$sumEmissions,type="b",xlab="Year",ylab="PM25-PRI Emissions",main="Emissions by Year")
pngFile <- "plot1.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
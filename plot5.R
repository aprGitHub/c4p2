# 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
library(plyr)
library(ggplot2)
################################
# SUB-ROUTINE: downloadFromURLAndUnzip
# Ad-hoc routine to download and unzip (if it was not done before) the data from "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# 
downloadFromURLAndUnzip <- function() 
{
  # SET HERE THE VARIABLES:
  workdirPath <- "./data"
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  destZipFile <- paste(paste(workdirPath,"exdata_Fdata_FNEI_data.zip", sep="/"))
  # The aforementioned zip should contain two rds files that should be placed in the following path
  NEIfile <- paste(workdirPath,"summarySCC_PM25.rds", sep="/")
  SCCfile <- paste(workdirPath,"Source_Classification_Code.rds", sep="/")
  
  
  ## Step 1: Create the directory if necessary
  if(!file.exists(workdirPath))
  {
    dir.create(workdirPath)
  }
  
  ## Step 2: Download and unzip the files if necessary
  if(!(file.exists(NEIfile)&file.exists(SCCfile)))
  {
    download.file(fileUrl, destfile=destZipFile, method="curl")
    unzip(zipfile=destZipFile, exdir=workdirPath) 
    dateDownloaded <- date()
    print(paste("INFO: the data file was downloaded on: ", dateDownloaded))
  }
  print("Download and Unzip: Done!")
}
###################################
###################################
# MAIN ROUTINE: 
# 1. Ad-hoc function to download the data for this exercise 
downloadFromURLAndUnzip()


# 2. Read the data into R objects. This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")


# 3. Merge the data add the Short.Name related to the SCC code
SCCsub <- subset(SCC,select=c(SCC,EI.Sector))
NEIsub <- subset(NEI,select=-c(Pollutant)) # remove Pollutant because it is redundant: unique(data$Pollutant)="PM25-PRI" allways
rm(NEI,SCC) # Remove the object (otherwise my old laptop may run out of memory:)

data <- merge(SCCsub, NEIsub,by="SCC")   
rm(NEIsub,SCCsub) # Remove the object (otherwise my old laptop may run out of memory:)


# 4. Get the instances associated to COAL
dataBaltimoreVehicles <- subset(data, 
                                    subset=grepl("24510",data$fips)&grepl("Vehicles",data$EI.Sector, ignore.case = TRUE),
                                    select=c(year,Emissions)) 
rm(data) # Remove the object (otherwise my old laptop may run out of memory:)


# 5. Get the sum of the emissions by year  
dataBaltimoreVehiclesArranged <- ddply(dataBaltimoreVehicles, .(year), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))

# 6. Plot and save the file
lp <- ggplot(data=dataBaltimoreVehiclesArranged, aes(x=year, y=sumEmissions)) + geom_point() + geom_line( ) + ggtitle("Emissions from motor vehicle sources in Baltimore") # Basic plot
lp # show the result
# lp <- lp + scale_colour_discrete(name  ="City",breaks=c("06037", "24510"),labels=c("Los Angeles", "Baltimore"))+ scale_shape_discrete(name  ="City",breaks=c("06037", "24510"),labels=c("Los Angeles", "Baltimore")) # Arrange the legend
# lp # show the result
lp <- lp + ylab("Emissions") # arrange the y-label
lp # show the result

pngFile <- "plot5.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
###################################



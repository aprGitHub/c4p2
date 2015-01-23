################################
# QUESTION 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
################################

library(plyr)
library(ggplot2)

###################################
# MAIN ROUTINE: plot5.R
# 1. Ad-hoc function to download the data for this exercise, be patient, it takes a while:-! 
source("downloadAndUnzip.R")
data <- downloadAndUnzip()

# 2. Get the instances associated to COAL
dataBaltimoreVehicles <- subset(data, 
                                    subset=grepl("24510",data$fips)&grepl("Vehicles",data$EI.Sector, ignore.case = TRUE),
                                    select=c(year,Emissions)) 
rm(data) # Remove the object (otherwise my old laptop may run out of memory:)


# 3. Get the sum of the emissions by year  
dataBaltimoreVehiclesArranged <- ddply(dataBaltimoreVehicles, .(year), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))

# 4. Plot and save the file
lp <- ggplot(data=dataBaltimoreVehiclesArranged, aes(x=year, y=sumEmissions)) + geom_point() + geom_line( ) + ggtitle("Emissions from motor vehicle sources in Baltimore") # Basic plot
#lp # show the result
lp <- lp + ylab("Emissions") # arrange the y-label
lp # show the result

pngFile <- "plot5.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
###################################

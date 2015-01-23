################################
# QUESTION 6. Compare emissions from motor vehicle sources in Baltimore City (fips == "24510")
# with emissions from motor vehicle sources in Los Angeles County, California ( fips == "06037" ). 
# Which city has seen greater changes over time in motor vehicle emissions?
################################
library(plyr)
library(ggplot2)

###################################
# MAIN ROUTINE: plot6.R
# 1. Ad-hoc function to download the data for this exercise, be patient, it takes a while:-! 
source("downloadAndUnzip.R")
data <- downloadAndUnzip()


# 2. Get the instances associated to either Baltimore or Los Angeles, and caused by Vehicles 
data_B_LA_Vehcles <- subset(data,   
                            subset=grepl("24510|06037",data$fips) & grepl("Vehicles",data$EI.Sector, ignore.case = TRUE),   
                            select=c(year,Emissions,fips)) 
rm(data) # Remove the object (otherwise my old laptop may run out of memory:)


# 3. Get the sum of the emissions by year  
data_B_LA_VehclesArranged <- ddply(data_B_LA_Vehcles, .(year,fips), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))

# 4. Plot and save the file
lp <- ggplot(data=data_B_LA_VehclesArranged, aes(x=year, y=sumEmissions,shape=fips,group=fips)) + geom_point(aes(colour=fips)) + geom_line(aes(colour=fips)) + ggtitle("Emissions from motor vehicle sources") # Basic plot
lp # show the result
lp <- lp + scale_colour_discrete(name  ="City",breaks=c("06037", "24510"),labels=c("Los Angeles", "Baltimore"))+ scale_shape_discrete(name  ="City",breaks=c("06037", "24510"),labels=c("Los Angeles", "Baltimore")) # Arrange the legend
lp # show the result
lp <- lp + ylab("Emissions") # arrange the y-label
lp # show the result

pngFile <- "plot6.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
###################################

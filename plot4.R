################################
# QUESTION 4: Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999–2008?
################################
library(plyr)
library(ggplot2)

###################################
# MAIN ROUTINE: plot4.R
# 1. Ad-hoc function to download the data for this exercise, be patient, it takes a while:-! 
source("downloadAndUnzip.R")
data <- downloadAndUnzip()

# 2. Get the instances associated to COAL
dataCoal <- subset(data, subset=grepl("Coal",data$EI.Sector, ignore.case = TRUE), select=c(year,Emissions))
rm(data)

# 3. Get the sum of the emissions by year  
dataCoalArranged <- ddply(dataCoal, .(year), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))

# 4. Plot and save the file
ggplot(data=dataCoalArranged, aes(x=year, y=sumEmissions))  + geom_point() + geom_line( ) + ggtitle("Emissions from coal combustion") + xlab("Year") + ylab("PM25-PRI Emissions")

pngFile <- "plot4.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
###################################

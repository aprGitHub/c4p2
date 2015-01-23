
# Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the [EPA National Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

# Data

The data for this assignment are available from the course web site as a single zip file:

* [Data for Peer Assessment [29Mb]](https://github.com/rdpeng/ExData_Plotting1)

The zip file contains two files: `summarySCC_PM25.rds` and `Source_Classification_Code.rds`. The content of each file is as follows:

<b> 1. PM2.5 Emissions Data (`summarySCC_PM25.rds`):</b>

This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.
```{r}
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
```
Each instance is described by the following attributes:
* fips: A five-digit number (represented as a string) indicating the U.S. county
* SCC: The name of the source as indicated by a digit string (see source code classification table)
* Pollutant: A string indicating the pollutant
* Emissions: Amount of PM2.5 emitted, in tons
* type: The type of source (point, non-point, on-road, or non-road)
* year: The year of emissions recorded

<b> 2.  Source Classification Code Table (`Source_Classification_Code.rds`):</b>

This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.


<b>Reading `.rds` files</b>

You can read each of the two files using the readRDS() function in R. For example, reading in each file can be done with the following code:
```{r}
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```
as long as each of those files is in your current working directory (check by calling dir() and see if those files are in the listing).


# Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

## Questions

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

### Question 1
<b>Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.</b>

The code to tackle this is as follows:
```{r}
# ROUTINE: plot1.R
library(plyr)
source("downloadAndUnzip.R")
# 1. Ad-hoc function to download the data for this exercise 
data <- downloadAndUnzip()

# 2. Get the sub-set required, summing up the Emmissions 
dataSumEmissionsByYear <- ddply(data, .(year), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))
#rm(data) # Remove the object (otherwise my old laptop may run out of memory:)

# 3. Plot and save the file
plot(dataSumEmissionsByYear$year,dataSumEmissionsByYear$sumEmissions,type="b",xlab="Year",ylab="PM25-PRI Emissions",main="Emissions by Year")
pngFile <- "plot1.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
```

![show plot1](plot1.png)

### Question 2
<b>Have total emissions from PM2.5 decreased in the  <b>Baltimore City, Maryland </b> (`fips == "24510"`) from 1999 to 2008? Use the base plotting system to make a plot answering this question.</b>

![show plot2](plot2.png)

There are some things pending, such as tidying up the x axis.

### Question 3
<b>Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the `ggplot2` plotting system to make a plot answer this question.</b>

![show plot3](plot3.png)


### Question 4 
<b>Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?</b>

![show plot4](plot4.png)

### Question 5
<b>How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?</b>

![show plot5](plot5.png)


### Question 6
<b>Compare emissions from motor vehicle sources in <b>Baltimore City</b> with emissions from motor vehicle sources in  <b>Los Angeles County, California </b> (`fips == "06037"`). Which city has seen greater changes over time in motor vehicle emissions?</b>

```{r}
# ROUTINE: plot6.R
library(plyr)
library(ggplot2)

# 0. Load the data
source("downloadAndUnzip.R")

# 1. Ad-hoc function to download the data for this exercise 
data <- downloadAndUnzip()

# 2. Get the instances associated to either Baltimore or Los Angeles, and caused by Vehicles 
data_B_LA_Vehcles <- subset(data, subset=grepl("24510|06037",data$fips) & grepl("Vehicles",data$EI.Sector, ignore.case = TRUE), select=c(year,Emissions,fips)) 
rm(data) # Remove the object (otherwise my old laptop may run out of memory:)

# 3. Get the sum of the emissions by year  
data_B_LA_VehclesArranged <- ddply(data_B_LA_Vehcles, .(year,fips), summarise, sumEmissions = sum(Emissions, na.rm = TRUE))

# 4. Plot and save the file
lp <- ggplot(data=data_B_LA_VehclesArranged, aes(x=year, y=sumEmissions,shape=fips,group=fips)) 
      + geom_point(aes(colour=fips)) + geom_line(aes(colour=fips)) 
      + ggtitle("Emissions from motor vehicle sources") 
      + scale_colour_discrete(name  ="City",breaks=c("06037", "24510"),labels=c("Los Angeles", "Baltimore"))
      + scale_shape_discrete(name  ="City",breaks=c("06037", "24510"),labels=c("Los Angeles", "Baltimore")) 
      + ylab("Emissions") # arrange the y-label
lp # show the result

pngFile <- "plot6.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
```

![show plot6](plot6.png)


## Making and Submitting Plots

For each plot you should:
* Construct the plot and save it to a PNG file.
* Create a separate R code file (`plot1.R`, `plot2.R`, etc.) that constructs the corresponding plot, i.e. code in `plot1.R` constructs the `plot1.png` plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You should also include the code that creates the PNG file. Only include the code for a single plot (i.e. `plot1.R` should only include code for producing `plot1.png`)
* Upload the PNG file on the Assignment submission page
* Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.

# R Code
There is a sub-routine (`downloadAndUnzip.R`) that allows to download, unzip, and load the data into an R object, a data frame, that combines both NEI and SCC. The function was made ad-hoc for this particular data. This sub-routine is being used for all the routines required in this assignment: `plot1.R`,..., `plot6.R` (see line `source("downloadAndUnzip.R")`). Next, each routine works with a particular sub-set of the data and the required plot is yielded.

```{r}
################################
# SUB-ROUTINE: downloadAndUnzip
# Ad-hoc routine to download and unzip (if it was not done before) the data 
# from "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# It merges both data files (NEI, SCC) into a data frame that is returned
downloadAndUnzip <- function() 
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
  
  ## Step 3: Read the data into R objects. This first line will likely take a few seconds. Be patient!
  NEI <- readRDS(NEIfile)
  SCC <- readRDS(SCCfile)
  
  ## Step 4:  Merge the data 
  data <- merge(SCC,NEI,by="SCC")
  
  ## Step 5: Return the data
  return(data)
}
```


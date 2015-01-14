
# Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the [EPA National Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

# Data

The data for this assignment are available from the course web site as a single zip file:

* [Data for Peer Assessment [29Mb]](https://github.com/rdpeng/ExData_Plotting1)

The zip file contains two files:

PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.
```{r}
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
```
* fips: A five-digit number (represented as a string) indicating the U.S. county
* SCC: The name of the source as indicated by a digit string (see source code classification table)
* Pollutant: A string indicating the pollutant
* Emissions: Amount of PM2.5 emitted, in tons
* type: The type of source (point, non-point, on-road, or non-road)
* year: The year of emissions recorded

Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.

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
<b>Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.<b>
![show plot1](plot1.png)

### Question 2
<b>Have total emissions from PM2.5 decreased in the  <b>Baltimore City, Maryland </b> (`fips == "24510"`) from 1999 to 2008? Use the base plotting system to make a plot answering this question.<b>
This is the content of my `plot2.R` file (whatch out! it is far from being elegant:( but it works:)
```{r}
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
# TO-DO: tidy up the x axis

pngFile <- "plot2.png"
dev.copy(png, file = pngFile,  bg = "white")
dev.off()
```
And the `plot2.R` generated is as follows:
![show plot2](plot2.png)
There are some things pending, such as tidying up the x axis.

### Question 3
Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the `ggplot2` plotting system to make a plot answer this question.

### Question 4 
Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

### Question 5
How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

### Question 6
Compare emissions from motor vehicle sources in <b>Baltimore City</b> with emissions from motor vehicle sources in  <b>Los Angeles County, California </b> (`fips == "06037"`). Which city has seen greater changes over time in motor vehicle emissions?


## Making and Submitting Plots

For each plot you should:
* Construct the plot and save it to a PNG file.
* Create a separate R code file (`plot1.R`, `plot2.R`, etc.) that constructs the corresponding plot, i.e. code in `plot1.R` constructs the `plot1.png` plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You should also include the code that creates the PNG file. Only include the code for a single plot (i.e. `plot1.R` should only include code for producing `plot1.png`)
* Upload the PNG file on the Assignment submission page
* Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.


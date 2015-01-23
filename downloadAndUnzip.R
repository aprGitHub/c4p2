################################
# SUB-ROUTINE: downloadAndUnzip
# Ad-hoc routine to download and unzip (if it was not done before) the data 
# from "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# It merges both data files (NEI, SCC) into a data frame that is returned
################################
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
  
  # 4. Return the data
  return(data)
}

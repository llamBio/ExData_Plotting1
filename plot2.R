##=============================================================================
# plot2.R Global Active Power Line Graph Day of Week
##=============================================================================
library(dplyr)
load_house_electric_data <- function(file.input="") {
  ## 1. download electric power consumption data to working directory
  ## 2. unzip file
  ## 3. load the data frame
  
  ## Return the data frame for the data set
  
  #download file if input is not provided
  df.power <- data.frame()
  if(file.input==""){
    fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(fileUrl,destfile='exdata-data-household_power_consumption.zip',method='curl')
    df.power <- read.table(unz("exdata-data-household_power_consumption.zip","household_power_consumption.txt"),header=T,sep=";",na.strings = "?")
  }else{
    df.power <- read.table(file=file.input,header=T,sep=";",na.strings = "?")
  }
  
  df.power <- mutate(df.power,Date=as.Date(Date,"%d/%m/%Y")) %>% 
    filter(Date >= "2007-02-01" & Date <= "2007-02-02")
  
  df.power <- mutate(df.power,DateTime=paste(Date,Time))
  DateTimeNew <- strptime(df.power$DateTime,"%Y-%m-%d %H:%M:%S")
  df.power <- cbind(df.power,DateTimeNew)
  
  return(df.power)
}

#load power consumption data
df.data <- load_house_electric_data()

#plot histogram of global power
png(file="plot2.png",width = 480, height = 480)
plot(df.data$DateTimeNew,df.data$Global_active_power, type="l",xlab = "",ylab = "Global Active Power (kilowatts)")
dev.off()
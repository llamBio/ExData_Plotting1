##=============================================================================
# plot4.R multi panel line plots
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
png(file="plot4.png",width = 480, height = 480)
par(mfrow=c(2,2))
#sub plot 1
plot(df.data$DateTimeNew,df.data$Global_active_power, type="l",xlab = "",ylab = "Global Active Power")
#sub plot 2
plot(df.data$DateTimeNew,df.data$Voltage, type="l",xlab = "datetime",ylab = "Voltage")
#sub plot 3
plot(df.data$DateTimeNew,df.data$Sub_metering_1, type="l",xlab = "",ylab = "Energy sub meeting")
lines(df.data$DateTimeNew,df.data$Sub_metering_2,type="l",col="red")
lines(df.data$DateTimeNew,df.data$Sub_metering_3,type="l",col="blue")
legend('topright','',c("Sub_meeting_1","Sub_meeting_2","Sub_meeting_3"), lty = c(1,1,1),col=c('black','red','blue'),ncol=1,bty ="n")
#sub plot 4
plot(df.data$DateTimeNew,df.data$Global_reactive_power, type="l",xlab = "datetime",ylab = "Global_reactive_power")
dev.off()
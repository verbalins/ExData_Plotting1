# Plots data as in figure/unnamed-chunk-4.png
plot3 <- function(){
        # Load data
        dat <- loadData()
        png(file = "plot3.png", width = 480, height = 480) # Open graphics device
        
        # Start building plot.
        with(dat, plot(Date_Time, Sub_metering_1, col = "black", type = "l", ylab = "Energy sub meeting", xlab = ""))
        with(dat, lines(Date_Time, Sub_metering_2, col = "red"))
        with(dat, lines(Date_Time, Sub_metering_3, col = "blue"))
        legend("topright", colnames(dat)[7:9], col = c("black", "red", "blue"), lty = 1, lwd = 1)
        
        dev.off() # Save plot
}

# Downloads, opens, mutates, filters and returns data to be plotted
loadData <- function(){
        if(!file.exists("data")) { dir.create("data") }
        
        if (!file.exists("data/filtered.rds")) { 
                # Download the data if not found.
                if (!file.exists("data/PowerConsumption.zip")){
                        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "data/PowerConsumption.zip", method = "curl")
                }
                
                # Only load data between 2007-02-01 and 2007-02-02
                dat <- read.table(unz("data/PowerConsumption.zip", "household_power_consumption.txt"), header = TRUE, sep=";", na.strings = "?")
                dat$Date <- strptime(as.Date(dat$Date, format = "%d/%m/%Y"), format = "%Y-%m-%d")
                filtered <- dat[which(dat$Date >= strptime("2007-02-01", format = "%Y-%m-%d") & dat$Date <= strptime("2007-02-02", format = "%Y-%m-%d")),]
                filtered$Date_Time <- strptime(paste(filtered$Date, filtered$Time, sep = " "), format = "%Y-%m-%d %H:%M:%S")
                saveRDS(filtered, "data/filtered.rds")
                filtered
        } else { readRDS("data/filtered.rds")} # To speed up loading data between experiments.
}
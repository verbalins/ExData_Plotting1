# Plots data as in figure/unnamed-chunk-3.png
plot2 <- function(){
        # Load data
        dat <- loadData()
        png(file = "plot2.png", width = 480, height = 480) # Open graphics device
        
        # Start building plot.
        with(dat, plot(Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "", xaxt = "n"))
        axis(side=1, labels=c("Thu", "Fri", "Sat"), at=c(0, nrow(dat)/2, nrow(dat))) 
        
        dev.off() # Save plot
}

# Downloads, opens, mutates, filters and returns data to be plotted
loadData <- function(){
        if(!file.exists("data")) { dir.create("data") }
        
        if (!file.exists("data/filtered.txt")) { 
                # Download the data if not found.
                if (!file.exists("data/PowerConsumption.zip")){
                        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "data/PowerConsumption.zip", method = "curl")
                }
                
                # Only load data between 2007-02-01 and 2007-02-02
                dat <- read.table(unz("data/PowerConsumption.zip", "household_power_consumption.txt"), header = TRUE, sep=";", na.strings = "?")
                dat$Date <- strptime(as.Date(dat$Date, format = "%d/%m/%Y"), format = "%Y-%m-%d")
                filtered <- dat[which(dat$Date >= strptime("2007-02-01", format = "%Y-%m-%d") & dat$Date <= strptime("2007-02-02", format = "%Y-%m-%d")),]
                write.table(filtered, "data/filtered.txt")
                filtered
        } else { read.table("data/filtered.txt", header = TRUE)} # To speed up loading data between experiments.
}
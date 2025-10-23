install.packages(c("tidyverse", "xts", "forecast", "lubridate"))
library(tidyverse)
library(xts)
library(forecast)
library(lubridate)
install.packages("ggplot2")
library(ggplot2)

# Assuming you have a CSV file named 'bitcoin_data.csv'
bitcoin_data <- read.csv("bitcoin_dataset.csv")

#Remove all null values
bit_data <- na.omit(bitcoin_data)

# Check the structure of your data
str(bit_data)

bit_data$Timestamps <- as.POSIXct(bit_data$Timestamp, format = "%Y-%m-%d %H:%M:%S", origin="1970-01-01")

bit_data <- bit_data[complete.cases(bit_data$Price, bit_data$Timestamps), ]

bit_data$Timestamps <- as.numeric(bit_data$Timestamps)

library(xts)

# Assuming Timestamps is in seconds, adjust if in milliseconds
ts_bit_data <- xts(bit_data$Price, order.by = as.POSIXct(bit_data$Timestamps, origin = "1970-01-01"))

bit_data$Timestamps <- as.numeric(bit_data$Timestamps)
ts_bit_data <- xts(bit_data$Price, order.by = as.POSIXct(bit_data$Timestamps, origin = "1970-01-01"))

bit_data$Timestamps <- as.numeric(bit_data$Timestamps) / 1000
ts_bit_data <- xts(bit_data$Price, order.by = as.POSIXct(bit_data$Timestamps, origin = "1970-01-01"))


ts_bit_data <- xts(bit_data$Price, order.by = bit_data$Timestamps)

######### Assuming your date variable is named 'Date'
bit_data$Timestamps <- as.Date(bit_data$Timestamp,origin="1970-01-01")
ts_bit_data <- xts(bit_data$Close, order.by = bit_data$Timestamps)

print(bit_data$Timestamps)############

# Example: Time series plot
plot(ts_bit_data, main = "Bitcoin Price Time Series", ylab = "Price (USD)")


# Assuming you want to use the last 90 observations as a test set
train_data <- head(ts_bit_data, n = length(ts_bit_data) - 90)
test_data <- tail(ts_bit_data, n = 90)

# Example: Using auto.arima for automatic ARIMA model selection
model <- auto.arima(train_data)

# Forecast future values
forecast_values <- forecast(model, h = 90)  # 90 periods ahead for the test set

# Example: Calculate accuracy measures
accuracy(forecast_values, test_data)

#actual vs. predicted values
plot(forecast_values, main = "Actual vs. Predicted Bitcoin Prices", ylab = "Price (USD)", col = "blue")
lines(test_data, col = "red")
legend("topright", legend = c("Actual", "Predicted"), col = c("red", "blue"), lty = 1)

#Forecasting 30 periods into the future
future_forecast <- forecast(model, h = 30)



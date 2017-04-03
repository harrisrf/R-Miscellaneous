library(prophet)
library(dplyr)
library(lubridate)

ds <- seq(as.Date("2012-08-01"),length=55,by="months")-1

# add data in here for manual input
y <- c()

df <- data.frame(ds, y)

m <- prophet(df)

future <- make_future_dataframe(m, periods = 17, freq = 'm')

forecast <- predict(m, future)

tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')], n = 17)

plot(m, forecast)

prophet_plot_components(m, forecast)

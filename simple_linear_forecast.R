library(forecast)

myvector <- c(<DATA>)
myts <- ts(myvector, start=c(<YEAR>, <MONTH>), end=c(<YEAR>, <MONTH>), frequency=12) 
fit1 <- tslm(myts ~ trend + season)
forecast1 <- forecast(fit1)
show(forecast1)

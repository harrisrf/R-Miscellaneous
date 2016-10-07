library(cluster)

#Read in data
x <- read.csv(file = 'D:\\MEDIODS.csv',header = T, stringsAsFactors = F)

#Exclude account numbers
x <- subset(x, select = - c(CO_CDE, MRCH_ACCT_NO, UQMRCHNO) )

#Model using the CLARA algo - 20 clusters - 1000 samples to ensure results are rigorous
clarax <- clara(x = x, k = 20, samples = 1000)

#Create a summary file of the medoid details
output <- cbind(clarax$clusinfo[, 1], clarax$medoids)

#Write the file to disk for analysis
write.csv(x = output, file = "D:\\mediod_output.csv")

library(cluster)
library(tsne)
library(ggplot2)
library(doParallel)

#Read in data
df <- read.csv(file = 'D:\\MEDIODS.csv',header = T, stringsAsFactors = F)

#Exclude account numbers & bsp
dfSub <- subset(df, select = - c(CO_CDE, MRCH_ACCT_NO, UQMRCHNO, bsp, bulk_file) )

#Take to ensure enough memory to compute dissimilarity
dfSample <- dfSub[sample(nrow(dfSub), size = 5000), ]
rm(dfSub)

#Create a dissimilarity matrix
gowerDist <- daisy(x = dfSample, metric="gower", type = list(asymm=c(2, 4, 5, 6, 7, 8, 9, 10), logratio = c(11, 12, 13)))
gowerMat <- as.matrix(gowerDist)

#Data is large so need to run the analysis in parallel
#Calculate the cluster using various k values. Save their average silhouette widths
cl <- makeCluster(4)
registerDoParallel(cl)

sil_width <- foreach(i = 2:15, .packages = 'cluster', .combine = rbind) %dopar% {
  claraFit <- clara(x = gowerMat, k = i, samples = 50, rngR = T, pamLike = T)
  c(i, claraFit$silinfo$avg.width)
}
stopCluster(cl)

#Plot average silhouette widths for various cluster sizes. Higher is better.
silWidth <- as.data.frame(sil_width)
colnames(silWidth) <- c("X","Y")
ggplot(aes(x = X, y = Y ), data = silWidth) + geom_point() + geom_line()

#Since 15 clusters had the highest width we use 15. 3 clusters would also be a good simple choice.
clarax <- clara(x = gowerMat, k = 15, samples = 50, rngR = T, pamLike = T)

#Convert high dimensional model into a two dimesional space to show separation in data
tsneObj <- tsne(gowerDist)
tsneData <- as.data.frame(tsneObj)
cluster <- factor(clarax$clustering)
ggplot(aes(x = V1, y = V2), data = tsneData) + geom_point(aes(color=cluster))

#Create a summary file of the medoid details
output <- cbind(clarax$clusinfo[, 1], df[rownames(clarax$medoids), ])

#Write the file to disk for analysis
write.csv(x = output, file = "D:\\mediod_output.csv")

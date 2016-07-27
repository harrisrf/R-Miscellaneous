library(RODBC)

merchants <- read.csv(file=paste("D:\\Users\\", Sys.getenv("USERNAME"), "\\Documents\\R\\Customers.csv", sep = ""),
                      header = T,
                      stringsAsFactors = F)

dbhandle <- odbcConnect('DSN')
result <- sqlQuery(dbhandle, 
                'SELECT T1."Customer", count(*) as Entries
                FROM "DB".DB.TABLE T1 
                GROUP BY T1."Customer"')

export_df <- merge(x = merchants, 
                y = result, 
                by.x = "Customer",
                by.y = "Customer", 
                all.x = T)

write.csv(x = export_df,
          file = paste("D:\\Users\\", Sys.getenv("USERNAME"), "\\Documents\\R\\Customers_Entries.csv", sep = ""))


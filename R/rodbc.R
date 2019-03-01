library(RODBC)

cn <- odbcDriverConnect(connection="Driver={SQL Server Native Client 11.0};server=MAXIMILIAN-III;database=teste;trusted_connection=yes;")

dataSQLQueryEUR <- sqlQuery(cn, "select * from dbo.carros")

class(dataSQLQueryEUR)


sqlSave(cn, dataSQLQueryEUR, tablename = "dbo.carros3")

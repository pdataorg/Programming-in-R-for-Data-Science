#Reading from SQL databases}

library(RODBC)
connStr <- paste(
  "Server=msedxeus.database.windows.net",
  "Database=DAT209x01",
  "uid=RLogin",
  "pwd=P@ssw0rd",
  "Driver={SQL Server}",
  sep=";"
)

if(.Platform$OS.type != "windows"){
  connStr <- paste(
    "Server=msedxeus.database.windows.net",
    "Database=DAT205x01",
    "uid=PBIlogin",
    "pwd=P@ssw0rd",
    "Driver=FreeTDS",
    "TDS_Version=8.0",
    "Port=1433",
    sep=";"
  )    
}

conn <- odbcDriverConnect(connStr)

\end{itemize}
\end{itemize}
\end{frame}


\begin{frame}[fragile]%%\linespread{0.9}
\frametitle{Connecting to a local SQL Database on your harddisk:}
\begin{itemize}
\item Replace server name with the SQL server name on the local machine;

\item With the default SQL installation, this is equal to the {\bf name of the local machine}:
  
  
  \begin{Sinput}
>connStr <- paste(
  +    "Server=My_Machine",
  +    "Database=DAT205x01",
  +    "uid=PBIlogin",
  +    "pwd=P@ssw0rd",
  +    "Driver={SQL Server}",
  +    sep=";"
  +    )

connStr <- paste(
  "Server=msedxeus.database.windows.net",
  "Database=DAT209x01",
  "uid=PBIlogin",
  "pwd=P@ssw0rd",
  "Driver=FreeTDS",
  "TDS_Version=8.0",
  "Port=1433",
  sep=";"
)

conn <- odbcDriverConnect(connStr)

#A first query

tab <- sqlTables(conn)
head(tab)

#Getting a table

mf <- sqlFetch(conn,"bi.manufacturer")
mf

#Submit real SQL

query <- "
SELECT Manufacturer
FROM   bi.manufacturer 
WHERE  ManufacturerID < 10
"
sqlQuery(conn, query)

#Large tables

sqlQuery(conn, "SELECT COUNT(*) FROM bi.salesFact")
sqlColumns(conn,"bi.salesFact")[c("COLUMN_NAME","TYPE_NAME")]
sqlQuery(conn, "SELECT TOP 2 * FROM bi.salesFact")

df <- sqlQuery(conn, "SELECT * FROM bi.salesFact WHERE Zip='30116'")
dim(df)

sapply(df, class)

#SQL summary statistics

df <- sqlQuery(conn,
               "SELECT    AVG(Revenue), STDEV(Revenue), Zip
   FROM      bi.salesFact
   GROUP BY  Zip"
)
colnames(df) <- c("AVG(Revenue)", "STDEV(Revenue)", "Zip")

close(conn)



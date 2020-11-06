-- Shrinks the database log. Execute this before and after a log file backup (with truncate option set to true)
-- This only works when recovery model of the database is "Simple", otherwise, use SQL Management Studio: https://www.mssqltips.com/sqlservertutorial/3311/how-to-shrink-the-transaction-log/

DBCC SHRINKFILE(Tfs_DefaultCollection_log, 1)

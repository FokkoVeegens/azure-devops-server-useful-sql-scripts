-- Shrinks the database log. Execute this before and after a log file backup (with truncate option set to true)

DBCC SHRINKFILE(Tfs_DefaultCollection_log, 1)

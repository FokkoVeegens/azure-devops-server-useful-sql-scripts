-- Source: https://jessehouwing.net/tfs-clean-up-your-project-collection/
-- Cleans up data that is deleted. This is normally done by jobs in Azure DevOps, but these don't run very frequently

EXEC prc_CleanupDeletedFileContent 1

-- Run this multiple times, it performs a batch of 100000
EXEC prc_DeleteUnusedFiles 1, 0, 100000

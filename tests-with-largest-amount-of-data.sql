-- Source: https://developercommunity.visualstudio.com/content/problem/382983/tfs-2018-update-2-database-growing-too-large.html
-- which tests produce the largest amount of attachment data?

SELECT TOP 10
    B.DefinitionName, TCase.AutomatedTestName, TRes.TestRunId, TRes.TestResultId, SUM(FM.CompressedLength)/1024.0/1024.0 [MBofData]
FROM Build.tbl_Definition B
JOIN tbl_BuildConfiguration BC ON BC.BuildDefinitionID = B.DefinitionID
JOIN tbl_TestRun TR ON TR.BuildConfigurationID = BC.BuildConfigurationID
JOIN tbl_Attachment A ON A.TestRunId = TR.TestRunId
JOIN TestResult.tbl_TestResult TRes ON TRes.TestRunId = TR.TestRunId AND TRes.TestResultId = A.TestResultId
JOIN TestResult.tbl_TestCaseReference TCase ON TCase.TestCaseRefId = TRes.TestCaseRefId 
JOIN tbl_FileReference FR ON FR.FileId = A.TfsFileId
JOIN tbl_FileMetadata FM ON FM.PartitionId = FR.PartitionId and FM.ResourceId = FR.ResourceId
WHERE FR.PartitionId = 1/*there seems to only ever be one partitionID, and this improves query performance*/
GROUP BY B.DefinitionName, TCase.AutomatedTestName, TRes.TestRunId, TRes.TestResultId
ORDER BY SUM(FM.CompressedLength) DESC

-- This query retrieves the size of the build artifacts and logs per Build Pipeline (Definition)
-- It is not yet optimized for big databases, so be careful when executing these
-- The queries are based on a query written by Jesse Houwing and it can be found here: https://jessehouwing.net/tfs-clean-up-your-project-collection/

DECLARE @partitionId INT = 1
 
select d.DefinitionId,
             d.DefinitionName,
             SUM(cast(ci.FileLength as decimal(38)))/1024.0/1024.0 AS ArtifactSizeInMb,
             d.Deleted
from tbl_Container c
       left outer join    (
            SELECT  ci.FileId,
                    ci.DataspaceId,
                    MAX(ci.FileLength) AS FileLength,
                    MAX(ci.ContainerId) AS ContainerId
            FROM    tbl_ContainerItem ci
            WHERE   ci.PartitionId = @partitionId
            GROUP BY ci.FileId, ci.DataspaceId
        ) AS ci ON ci.ContainerId = c.ContainerId
       inner join Build.tbl_Build b on convert(int, replace(c.ArtifactUri,'vstfs:///Build/Build/','')) = b.BuildId
       inner join Build.tbl_Definition d on b.DefinitionId = d.DefinitionId
where c.ArtifactUri like 'vstfs:///Build/Build/%'
GROUP BY d.DefinitionId,
             d.DefinitionName,
             d.Deleted
 
select d.DefinitionId,
             d.DefinitionName,
             SUM(cast(ci.FileLength as decimal(38)))/1024.0/1024.0 AS LogSizeInMb,
             d.Deleted
from tbl_Container c
       left outer join    (
            SELECT  ci.FileId,
                    ci.DataspaceId,
                    MAX(ci.FileLength) AS FileLength,
                    MAX(ci.ContainerId) AS ContainerId
            FROM    tbl_ContainerItem ci
            WHERE   ci.PartitionId = @partitionId
            GROUP BY ci.FileId, ci.DataspaceId
        ) AS ci ON ci.ContainerId = c.ContainerId
       inner join Build.tbl_Build b on convert(int, replace(c.SecurityToken,'vstfs:///Build/Build/','')) = b.BuildId
       inner join Build.tbl_Definition d on b.DefinitionId = d.DefinitionId
where c.ArtifactUri like 'pipelines://build/%'
GROUP BY d.DefinitionId,
             d.DefinitionName,
             d.Deleted

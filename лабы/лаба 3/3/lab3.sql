use mshoad
go

-- ���������� ������� �������������� ����
ALTER TABLE KnowledgeBase 
add nodee hierarchyid,
LEVELL as nodee.GetLevel() persisted;

-- ���������� ������ � ������� KnowledgeBase
INSERT INTO KnowledgeBase VALUES
    (7, '������ 7', '���������� ������ 7', '��������� 1', GETDATE(), hierarchyid::GetRoot()),
    (8, '������ 8', '���������� ������ 8', '��������� 2', GETDATE(), hierarchyid::GetRoot()),
    (9, '������ 9', '���������� ������ 9', '��������� 1', GETDATE(), hierarchyid::GetRoot())
go

-- ����������� ������������� ����
DECLARE @ParentNodePath hierarchyid;
SET @ParentNodePath = hierarchyid::Parse('/');

DECLARE @NewNodePath hierarchyid;
SET @NewNodePath = @ParentNodePath.GetDescendant(NULL, NULL);

INSERT INTO KnowledgeBase VALUES (10, '����������� ������3215', '���������� ����������� ������1325', '��������� 10', GETDATE(), @NewNodePath);
select * from KnowledgeBase;
go

-- 2 Task
CREATE PROCEDURE DisplayChildKnowledgeBase
    @NodePath hierarchyid
AS
BEGIN
    -- ����� ����������� ����� ��� ����������� � ��������� ����
    SELECT
        ArticleID,
        Title,
        nodee.ToString() AS NodePath,
        nodee.GetLevel() AS NodeLevel
    FROM
        KnowledgeBase
    WHERE
        nodee.IsDescendantOf(@NodePath) = 1
    ORDER BY nodee;
END;


drop procedure DisplayChildKnowledgeBase
go


DECLARE @NodePath hierarchyid;
SET @NodePath = hierarchyid::Parse('/');

EXEC DisplayChildKnowledgeBase @NodePath;
go


-- 3 Task
CREATE PROCEDURE AddChildNode
    @ParentNodePath hierarchyid, 
    @NewNodeName NVARCHAR(100)
AS
BEGIN
  DECLARE @LastChild hierarchyid;

  DECLARE @NewArtic1eId INT;
  SET @NewArtic1eId = CAST(CAST(CONVERT(uniqueidentifier, NEWID()) AS VARBINARY) AS INT);

    -- Get the last child node under the parent
    SELECT TOP 1 @LastChild = nodee
    FROM KnowledgeBase
    WHERE nodee.GetAncestor(1) = @ParentNodePath
    ORDER BY nodee DESC;

    DECLARE @NewNodePath hierarchyid;
    -- Use the last child as the first parameter to GetDescendant
    SET @NewNodePath = @ParentNodePath.GetDescendant(@LastChild, NULL);

    INSERT INTO KnowledgeBase (ArticleID, Title, nodee)
    VALUES (@NewArtic1eId, @NewNodeName, @NewNodePath);
END;
go


drop procedure AddChildNode
go

DECLARE @ParentNodePath hierarchyid;
SET @ParentNodePath = hierarchyid::Parse('/'); 

EXEC AddChildNode @ParentNodePath, '����� ������ 4 ���';

select * from KnowledgeBase;
go


-- 4 Task
CREATE PROCEDURE MoveSubtree
    @SourceNodePath hierarchyid,
    @DestinationNodePath hierarchyid
AS
BEGIN
    -- ����������� ���� ����������� �����
    UPDATE KnowledgeBase
    SET nodee = nodee.GetReparentedValue(@SourceNodePath, @DestinationNodePath)
    WHERE nodee.IsDescendantOf(@SourceNodePath) = 1;
END;
go

DECLARE @SourceNodePath hierarchyid;
SET @SourceNodePath = hierarchyid::Parse('/1/'); 

DECLARE @DestinationNodePath hierarchyid;
SET @DestinationNodePath = hierarchyid::Parse('/1/1/'); 

EXEC MoveSubtree @SourceNodePath, @DestinationNodePath;

drop procedure MoveSubtree;

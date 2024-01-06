use mshoad
go

-- Добавление столбца иерархического типа
ALTER TABLE KnowledgeBase 
add nodee hierarchyid,
LEVELL as nodee.GetLevel() persisted;

-- Добавление данных в таблицу KnowledgeBase
INSERT INTO KnowledgeBase VALUES
    (7, 'Статья 7', 'Содержание статьи 7', 'Категория 1', GETDATE(), hierarchyid::GetRoot()),
    (8, 'Статья 8', 'Содержание статьи 8', 'Категория 2', GETDATE(), hierarchyid::GetRoot()),
    (9, 'Статья 9', 'Содержание статьи 9', 'Категория 1', GETDATE(), hierarchyid::GetRoot())
go

-- Определение родительского узла
DECLARE @ParentNodePath hierarchyid;
SET @ParentNodePath = hierarchyid::Parse('/');

DECLARE @NewNodePath hierarchyid;
SET @NewNodePath = @ParentNodePath.GetDescendant(NULL, NULL);

INSERT INTO KnowledgeBase VALUES (10, 'Подчиненная статья3215', 'Содержание подчиненной статьи1325', 'Категория 10', GETDATE(), @NewNodePath);
select * from KnowledgeBase;
go

-- 2 Task
CREATE PROCEDURE DisplayChildKnowledgeBase
    @NodePath hierarchyid
AS
BEGIN
    -- Вывод подчиненных узлов для переданного в параметре узла
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

EXEC AddChildNode @ParentNodePath, 'Новая статья 4 зад';

select * from KnowledgeBase;
go


-- 4 Task
CREATE PROCEDURE MoveSubtree
    @SourceNodePath hierarchyid,
    @DestinationNodePath hierarchyid
AS
BEGIN
    -- Перемещение всей подчиненной ветки
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

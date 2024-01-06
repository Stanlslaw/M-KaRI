-- Добавление столбца данных иерархического типа в таблицу Licensees
use SoftwareLicenses;
ALTER TABLE Licensees
ADD hierarchy_path hierarchyid,
LEVELL as hierarchy_path.GetLevel() persisted;

truncate table Licensees

-- Вставка корневого элемента
INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details, hierarchy_path)
VALUES (1, 'Имя1', 'Фамилия1', 'Организация1', 'Контакт1', 'Детали1', hierarchyid::GetRoot());


-- Определение родительского узла (например, родительского элемента с licensee_id = 1)
DECLARE @parentHierarchy hierarchyid;
SET @parentHierarchy = hierarchyid::Parse('/');

DECLARE @NewNodePath hierarchyid;
SET @NewNodePath = @parentHierarchy.GetDescendant(NULL, NULL);


SELECT @parentHierarchy = hierarchy_path
FROM Licensees
WHERE licensee_id = 1;


-- Вставка новых данных с указанием родительского узла
INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details, hierarchy_path)
VALUES (2, 'Имя2', 'Фамилия2', 'Организация2', 'Контакт2', 'Детали2', @parentHierarchy.GetDescendant(null, null));

--начальный и конечный диапазоны (null означает использовать следующий доступный)

select * from Licensees



truncate table licensees
select * from licensees

delete from Licensees




--2


select * from sys.procedures

drop procedure AddSubordinateNode
drop procedure DisplayChildLicensees

create procedure DisplayChildLicensees
	@NodePath hierarchyid
as
begin
	select 
		licensee_id, 
		name, 
		surname, 
		organization, 
		contact, 
		add_details, 
		hierarchy_path.ToString() as nodePath, 
		hierarchy_path.GetLevel() as nodeLevel
	from Licensees
	where hierarchy_path.IsDescendantOf(@NodePath) = 1
	order by hierarchy_path
end;

drop procedure DisplayChildLicensees
go
		





declare @NodePath hierarchyid;
set @NodePath = hierarchyid::Parse('/');

exec DisplayChildLicensees @NodePath;

--3

drop PROCEDURE AddSubordinateNode;


go
CREATE PROCEDURE AddSubordinateNode (
	@ParentNodePath hierarchyid,
    @name NVARCHAR(10),
    @surname NVARCHAR(10),
    @organization NVARCHAR(20),
    @contact NVARCHAR(20),
    @add_details NVARCHAR(20)
)
AS
BEGIN
    DECLARE @LastChild hierarchyid;

	DECLARE @new_licensee_id INT;
  SET @new_licensee_id = (select top 1 licensee_id from Licensees order by licensee_id desc) + 1;

	-- Get the last child node under the parent
    SELECT TOP 1 @LastChild = hierarchy_path
    FROM Licensees
    WHERE hierarchy_path.GetAncestor(1) = @ParentNodePath
    ORDER BY hierarchy_path DESC;

    DECLARE @NewNodePath hierarchyid;
    -- Use the last child as the first parameter to GetDescendant
    SET @NewNodePath = @ParentNodePath.GetDescendant(@LastChild, NULL);

	 INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details, hierarchy_path)
    VALUES (@new_licensee_id, @name, @surname, @organization, @contact, @add_details, @NewNodePath)

END;


DECLARE @ParentNodePath hierarchyid;
SET @ParentNodePath = hierarchyid::Parse('/'); 

EXEC AddSubordinateNode @ParentNodePath, 'Имя10', 'Фамилия3', 'Организация3', 'Контакт3', 'Детали3';




drop PROCEDURE MoveSubtree;

--4


create procedure MoveSubtree
	@SourceNodePath hierarchyid,
	@DestinationNodePath hierarchyid
as
begin
	update Licensees
	set hierarchy_path = hierarchy_path.GetReparentedValue(@SourceNodePath, @DestinationNodePath)
	where hierarchy_path.IsDescendantOf(@SourceNodePath) = 1;
end;
go



declare @SourceNodePath hierarchyid;
set @SourceNodePath = hierarchyid::Parse('/2/');

declare @DestinationNodePath hierarchyid;
set @DestinationNodePath = hierarchyid::Parse('/1/');


exec MoveSubtree @SourceNodePath, @DestinationNodePath;


select * from Licensees
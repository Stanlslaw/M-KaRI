CREATE TABLE MyHierarchy (
    node_id NUMBER PRIMARY KEY,
    node_name VARCHAR2(50),
    parent_node_id NUMBER
);

select * from MyHierarchy
insert into MyHierarchy (node_id, node_name, parent_node_id)
values (1, 'Root', null);
insert into MyHierarchy (node_id, node_name, parent_node_id)
values (2, 'Child 1', 1);
insert into MyHierarchy (node_id, node_name, parent_node_id)
values (3, 'Child 2', 1);

SELECT node_id, node_name, LEVEL
FROM MyHierarchy
CONNECT BY PRIOR node_id = parent_node_id
START WITH parent_node_id is null;

SELECT node_id, node_name, parent_node_id
FROM MyHierarchy

truncate table MyHierarchy


--2


create or replace procedure DisplayChildLicensees (
	ParentId in number
) as
begin
	for RecursiveHierarchy in (
        select node_id, parent_node_id, node_name, LEVEL
        from MyHierarchy
        start with node_id = ParentId
        connect by nocycle prior node_id = parent_node_id
    ) loop
        dbms_output.put_line('NodeID: ' || RecursiveHierarchy.node_id || ', ParentNodeId: ' || RecursiveHierarchy.parent_node_id || ', NodeName: ' || RecursiveHierarchy.node_name || ', HierarchyLevel: ' || RecursiveHierarchy.Level);
        end loop;
end;


begin
    DisplayChildLicensees(2);
end;




--3
create or replace procedure AddChildNode(
    ParentNodeID in number,
    NewNodeId in number,
    NewNodeName in varchar2,
    Result out varchar2
) as
begin
    insert into MyHierarchy (node_id, parent_node_id, node_name)
    values (NewNodeId, ParentNodeID, NewNodeName);
    
    declare
        NodeAdded number;
    begin
        select count(*)
        into NodeAdded
        from MyHierarchy
        where node_id = NewNodeID;
        
        if NodeAdded = 1 then
            Result := 'Success';
        else
            Result := 'Error';
        end if;
    end;
end;


declare 
    ResultMsg varchar2(100);
begin
    AddChildNode(1,5,'Child 4', ResultMsg);
    dbms_output.put_line(ResultMsg);
end;

select * from MyHierarchy







--4
create or replace procedure MoveSubtree(p_MovingNodeID in number, p_TargetNodeID in number) is
begin
	update MyHierarchy
	set parent_node_id = p_TargetNodeID
	where node_id in (
        select node_id
        from MyHierarchy
        start with node_id = p_MovingNodeID
        CONNECT BY NOCYCLE PRIOR node_id = parent_node_id
    );
    commit;
exception
    when others then
        rollback;
        raise;
end;

begin
    MoveSubtree(1,2);
end;

select * from MyHierarchy


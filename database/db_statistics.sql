prompt statistics.sql
----------------------------------------------------------------------------------------
--
-- Script generated gives a quick overview regarding the different objects in the schema
--
----------------------------------------------------------------------------------------

set feedback off pagesize 10000 head on

alter session set current_schema=MOS;
select sys_context( 'userenv', 'current_schema' ) as current_schema from dual;

prompt
prompt
prompt =========================================================================
prompt Full schema report...
prompt =========================================================================


column object_type format a20
column object_name format a70
column status format a10
select object_type, owner || '.' || object_name as object_name, status
from all_objects
where 1=1
    and owner = sys_context('userenv','current_schema')
order by owner, object_type, object_name;

alter session set current_schema=MOS;

prompt
prompt
prompt =========================================================================
prompt Counting LoC...
prompt =========================================================================


select type as object_type, count(*) as "LoC"
from all_source
where owner = sys_context('userenv','current_schema')
group by type
order by type;

prompt
prompt
prompt =========================================================================
prompt Counting schema objects...
prompt =========================================================================


select
    object_type as "Type",
    actual_count as "Total",
    invalid_count as "Invalid",
    nvl(
        case when actual_count != expected_count then 'WARNING: expected ' || expected_count || ';' end
        ||
        case when invalid_count > 0 then 'WARNING: invalid' end
    ,'OK')
    as "Summary"
from (select
        object_type,
        case object_type
        when 'PACKAGE' then 64
        when 'PACKAGE BODY' then 64
        when 'TABLE' then 154
        when 'TRIGGER' then 65
        when 'TYPE' then 0
        when 'TYPE BODY' then 0
        when 'VIEW' then 80
        end as expected_count,
        count(*) as actual_count,
        count(nullif(status,'VALID')) as invalid_count
    from all_objects
    where owner = sys_context('userenv','current_schema')
    and secondary = 'N'
    and object_name not in ('HTMLDB_PLAN_TABLE')
    and object_name not like 'DBMSHP%'
    and object_name not like 'AQ$%'
    and object_name not like '%#%'
    group by object_type)
order by 1;

set head off

select 'Invalid ' || object_type || ': ' || object_name
from all_objects
where owner = sys_context('userenv','current_schema')
and status = 'INVALID'
order by 1;

select 'ERROR in ' || initcap(type) || ' ' || name || ' line# ' || line || ': ' || text from all_errors where owner = sys_context('userenv','current_schema') order by 1;

-- the UTIL_SCHEMA package should only have limited dependencies on logger;
-- i.e. no dependencies on other packages that get created later by the
-- install / upgrade scripts
select
    initcap(type) || ' ' || name
    || ' has a dependency on '
    || initcap(referenced_type) || ' ' || referenced_name
    as "Package Dependency Warning"
from all_dependencies
where referenced_owner = sys_context('userenv','current_schema')
and name = 'UTIL_SCHEMA'
and referenced_name != name
and referenced_name not in ('LOGGER', 'LOGGER_LOGS') /* allowed dependencies */
order by type, name, referenced_type, referenced_name;

prompt
prompt
prompt =========================================================================
prompt Compilation Error Summary
prompt =========================================================================


set head on

column owner format a30
select owner, count(*) as invalid_objects
from all_errors
group by owner
order by owner;

declare
    l_error_count number;
begin
    select count(*) 
        into l_error_count
    from all_errors
    where 1=1
        and name not like 'BIN$%'
        and owner like 'MOS%';
    
    if l_error_count > 0 then
        raise_application_error(-20000, 'Installation fail: ' || l_error_count || ' compilation errors');
    end if;
end;
/

prompt
prompt
prompt =========================================================================

column queue_table format a30
column object_type format a70
column queue_name format a30
column subscription_name format a70
column consumer_name format a30
column callback format a70

prompt Queue Tables
select queue_table, object_type
from all_queue_tables
where owner = sys_context('userenv','current_schema')
order by queue_table;

prompt Queues
select name as queue_name, queue_table, queue_type, max_retries, retry_delay, enqueue_enabled, dequeue_enabled
from all_queues
where owner = sys_context('userenv','current_schema')
order by name;

prompt Queue Subscribers
select queue_name, queue_table, consumer_name
from all_queue_subscribers
where owner = sys_context('userenv','current_schema')
order by queue_name;

-- prompt Queue Callback Registrations
-- select subscription_name, location_name as callback
-- from dba_subscr_registrations
-- where subscription_name like '"' || sys_context('userenv','current_schema') || '"%'
-- order by 1;

prompt
prompt
prompt =========================================================================
prompt Counting the number of each object in the database
prompt =========================================================================


SELECT object_type, COUNT(*) AS object_count
FROM all_objects
WHERE owner = sys_context('userenv','current_schema')
GROUP BY object_type;




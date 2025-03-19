

--
-- Testing the table function
-- 

select * from simple_reporting.reporting_patient_states_table_function ( date) 
select * from simple_reporting.reporting_patient_states_table_function(date_trunc('month', current_date)::date);

select * from public.reporting_patient_states where month_date = date_trunc('month', current_date)::date;
select * from public.reporting_patient_states




create view public.reporting_patient_states as select * from simple_reporting.reporting_patient_states;

--
-- Testing ATTACH unitarily 
--

DROP TABLE IF EXISTS SHARD_TEST_001;
DROP TABLE IF EXISTS SHARD_TEST_002;
DROP TABLE IF EXISTS SHARD_TEST_003;

CREATE TABLE SHARD_TEST_001 as 
select * from simple_reporting.reporting_patient_states_table_function(date_trunc('month', current_date)::date);
CREATE UNIQUE INDEX IF NOT EXISTS patient_states_month_date_patient_id ON SHARD_TEST_001 USING btree (patient_id);
ALTER TABLE SHARD_TEST_001 ADD CONSTRAINT SHARD_TEST_001_check CHECK (month_date = date_trunc('month', current_date)::date);

ALTER TABLE simple_reporting.reporting_patient_states ATTACH PARTITION SHARD_TEST_001
    FOR VALUES in  (date_trunc('month', current_date)::date);

CREATE TABLE SHARD_TEST_002 as 
select * from simple_reporting.reporting_patient_states_table_function(date_trunc('month', current_date - interval '1 month')::date);
CREATE UNIQUE INDEX IF NOT EXISTS patient_states_month_date_patient_id ON SHARD_TEST_002 USING btree (patient_id);
ALTER TABLE SHARD_TEST_002 ADD CONSTRAINT SHARD_TEST_003_check CHECK (month_date = date_trunc('month', current_date - interval '1 month')::date);

ALTER TABLE simple_reporting.reporting_patient_states ATTACH PARTITION SHARD_TEST_002
    FOR VALUES in  (date_trunc('month', current_date - interval '1 month')::date);

CREATE TABLE SHARD_TEST_003 as 
select * from simple_reporting.reporting_patient_states_table_function(date_trunc('month', current_date - interval '2 month')::date);
CREATE UNIQUE INDEX IF NOT EXISTS patient_states_month_date_patient_id ON SHARD_TEST_003 USING btree (patient_id);
ALTER TABLE SHARD_TEST_003 ADD CONSTRAINT SHARD_TEST_003_check CHECK (month_date = date_trunc('month', current_date - interval '2 month')::date);


ALTER TABLE simple_reporting.reporting_patient_states ATTACH PARTITION SHARD_TEST_003
    FOR VALUES in  (date_trunc('month', current_date - interval '2 month')::date);


DROP TABLE IF EXISTS SHARD_TEST_001;
DROP TABLE IF EXISTS SHARD_TEST_002;
DROP TABLE IF EXISTS SHARD_TEST_003;

--
-- Testing the procedure
--
call simple_reporting.reporting_patient_states_add_shard(current_date);
call simple_reporting.reporting_patient_states_add_shard((current_date - interval '1 month' )::date) ;
call simple_reporting.reporting_patient_states_add_shard((current_date - interval '2 month' )::date) ;
call simple_reporting.reporting_patient_states_add_shard((current_date - interval '3 month' )::date) ;
call simple_reporting.reporting_patient_states_add_shard((current_date - interval '4 month' )::date) ;
call simple_reporting.reporting_patient_states_add_shard((current_date - interval '5 month' )::date) ;


--
-- Looking at audit table
-- 
select * from simple_reporting.SIMPLE_REPORTING_RUNS order by end_date desc;


--
-- Checking Execution plans for various queries to validate indexes are taken in account
-- 

explain select * from simple_reporting.reporting_patient_states where patient_id  ='0044112d-70d5-4d8e-8a8a-1eac37d110ad';
explain select sum(age) from simple_reporting.reporting_patient_states where age > 20;
explain select sum(age) from simple_reporting.reporting_patient_states where age > 90;
explain select sum(age) from simple_reporting.reporting_patient_states where month_date > (current_date - interval '2 month');
explain select sum(age) from simple_reporting.reporting_patient_states where month_date > (current_date - interval '2 month') and age > 90;

update simple_reporting.reporting_patient_states
set assigned_facility_id= '0044112d-70d5-4d8e-8a8a-1eac37d110ad'
 where patient_id  ='0044112d-70d5-4d8e-8a8a-1eac37d110ad';
commit;
--
-- Looking at children of the table
--
SELECT
    *
FROM pg_inherits
    JOIN pg_class parent            ON pg_inherits.inhparent = parent.oid
    JOIN pg_class child             ON pg_inherits.inhrelid   = child.oid
    JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
    JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace
WHERE parent.relname='reporting_patient_states';

--
-- Looking at audit table
-- 
select * from simple_reporting.SIMPLE_REPORTING_RUNS order by end_date desc;

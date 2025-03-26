--
-- Runs the procedure for each REPORTING_MONTH
--
call simple_reporting.reporting_patient_states_add_all_shards();

--
-- Tests Refreshing the Old MVIEW
--
CALL simple_reporting.MONITORED_EXECUTE(gen_random_uuid (), 'REPORTING_PATIENT_STATE_MATVIEW_ALL',
    'REFRESH MATERIALIZED VIEW public.reporting_patient_states');
--
--
-- Refreshes only the current month with partitions
CALL simple_reporting.reporting_patient_states_add_shard(current_date);

--
-- Looking at audit table
-- 
select * from simple_reporting.SIMPLE_REPORTING_RUNS order by start_date desc;

--
-- Checking Execution plans for various queries to validate indexes are taken in account
-- 

explain select * from simple_reporting.reporting_patient_states where patient_id  ='0044112d-70d5-4d8e-8a8a-1eac37d110ad';
explain select sum(age) from simple_reporting.reporting_patient_states where age > 20;
explain select sum(age) from simple_reporting.reporting_patient_states where age > 90;
explain select sum(age) from simple_reporting.reporting_patient_states where month_date > (current_date - interval '2 month');
explain select sum(age) from simple_reporting.reporting_patient_states where month_date > (current_date - interval '2 month') and age > 90;
explain select sum(age) from           public.reporting_patient_states where month_date > (current_date - interval '2 month') and age > 90;

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

--
-- compare with old MView
--
REFRESH MATERIALIZED VIEW public.reporting_patient_states;



call simple_reporting.reporting_patient_states_add_shard(TO_DATE('2018-07', 'YYYY-MM'));


explain analyse select sum(systolic) from simple_reporting.reporting_patient_states where month_date > (current_date - interval '12 month'); ;
explain analyse select sum(systolic) from           public.reporting_patient_states where month_date > (current_date - interval '12 month'); ;

SET max_parallel_workers_per_gather = 12;

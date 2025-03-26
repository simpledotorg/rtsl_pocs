--
-- Sets max number of workers
-- 
SET max_parallel_workers_per_gather = 2;
SET max_parallel_workers_per_gather = 8;

--
-- Sets the schema in which we want to test
--
SET SEARCH_PATH = simple_reporting;
SET SEARCH_PATH = public;

--
--
-- Check volumes
select month_date, count(*) from reporting_patient_states group by month_date order by 1 desc;

--
-- A few queries to check performances
--
explain analyse select count(*) from reporting_patient_states;
explain analyse select sum(systolic) from reporting_patient_states where month_date > (current_date - interval '12 month') and age > 200;
explain analyse select sum(systolic) from reporting_patient_states where month_date > (current_date - interval '12 month');


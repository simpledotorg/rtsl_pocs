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


explain analyse select sum(systolic) from reporting_patient_states where month_date > (current_date - interval '12 month') and age > 90; ;
explain analyse select sum(systolic) from reporting_patient_states where month_date > (current_date - interval '12 month'); ;

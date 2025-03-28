

--
-- Testing the table function
-- 

select * from simple_reporting.reporting_patient_states_table_function ( date) 
select * from simple_reporting.reporting_patient_states_table_function(date_trunc('month', current_date)::date);

select * from public.reporting_patient_states where month_date = date_trunc('month', current_date)::date;
select * from public.reporting_patient_states;




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
-- Run all the shards at once
--
select count(*) from information_schema.tables where table_name like '%shard%';

call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201812','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201811','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201810','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201809','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201808','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201807','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201806','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201805','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201804','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201803','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201802','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201801','YYYYMM')) ;

call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201912','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201911','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201910','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201909','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201908','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201907','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201906','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201905','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201904','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201903','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201902','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('201901','YYYYMM')) ;

call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202012','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202011','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202010','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202009','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202008','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202007','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202006','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202005','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202004','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202003','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202002','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202001','YYYYMM')) ;

call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202112','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202111','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202110','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202109','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202108','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202107','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202106','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202105','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202104','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202103','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202102','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202101','YYYYMM')) ;

call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202212','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202211','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202210','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202209','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202208','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202207','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202206','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202205','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202204','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202203','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202202','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202201','YYYYMM')) ;

call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202312','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202311','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202310','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202309','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202308','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202307','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202306','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202305','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202304','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202303','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202302','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202301','YYYYMM')) ;

call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202412','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202411','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202410','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202409','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202408','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202407','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202406','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202405','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202404','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202403','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202402','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202401','YYYYMM')) ;


call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202501','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202502','YYYYMM')) ;
call simple_reporting.reporting_patient_states_add_shard(TO_DATE('202503','YYYYMM')) ;

--
-- REFRESH MATVIEW
--
CALL simple_reporting.MONITORED_EXECUTE(gen_random_uuid (), 'REPORTING_PATIENT_STATE_MATVIEW_ALL',
    'REFRESH MATERIALIZED VIEW public.reporting_patient_states');

--
-- GETTING TABLE SIZES
--
select schemaname, sum(pg_relation_size('' || schemaname||'.' || tablename) )
FROM pg_catalog.pg_tables where tablename like '%states%'  group by schemaname;

select pg_relation_size('public.reporting_patient_states'); 

--
-- INDEX SIZES
--
select schemaname,sum(pg_relation_size('' || schemaname||'.' || indexname))
 from pg_indexes where tablename like '%states%'
  group by schemaname
order by schemaname desc;


--
-- number of lines
--
with 
PARTABLE_DATA as 
(select month_date, count(*) as NB_PARTABLE_LINES from simple_reporting.reporting_patient_states group by month_date order by 1 desc),
MATVIEW_DATA as
(select month_date, count(*) as NB_MATVIEW_LINES from public.reporting_patient_states group by month_date order by 1 desc)
select *,  NB_PARTABLE_LINES - NB_MATVIEW_LINES as gap
from MATVIEW_DATA
full outer join PARTABLE_DATA on PARTABLE_DATA.month_date = MATVIEW_DATA.month_date
order by 1 desc;



select simple_reporting.reporting_patient_states.month_date, count(*)
from simple_reporting.reporting_patient_states
full outer join public.reporting_patient_states on (
    simple_reporting.reporting_patient_states.patient_id = public.reporting_patient_states.patient_id 
    and simple_reporting.reporting_patient_states.month_date = public.reporting_patient_states.month_date )
group  by simple_reporting.reporting_patient_states.month_date
order by 1 desc;

--
-- MISSING LINES
-- 

with
MATVIEW_DATA as 
(select * from public.reporting_patient_states where month_date= TO_DATE('202501','YYYYMM')),
PARTABLE_DATA as
(select * from simple_reporting.reporting_patient_states where month_date= TO_DATE('202501','YYYYMM'))
select sum(MATVIEW_DATA.systolic), sum(PARTABLE_DATA.systolic)
from PARTABLE_DATA
full outer join MATVIEW_DATA on (MATVIEW_DATA.patient_id =PARTABLE_DATA.patient_id);

with
MATVIEW_DATA as 
(select * from public.reporting_patient_states where month_date= TO_DATE('202501','YYYYMM')),
PARTABLE_DATA as
(select * from simple_reporting.reporting_patient_states where month_date= TO_DATE('202501','YYYYMM'))
select PARTABLE_DATA.recorded_at,PARTABLE_DATA.recorded_at::timestamp at time zone 'utc',*
from PARTABLE_DATA
full outer join MATVIEW_DATA on (MATVIEW_DATA.patient_id =PARTABLE_DATA.patient_id)
where MATVIEW_DATA.patient_id is null or PARTABLE_DATA.patient_id is null;

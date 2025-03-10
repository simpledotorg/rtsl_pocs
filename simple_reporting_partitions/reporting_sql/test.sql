CREATE TABLE measurement (
    city_id         int not null,
    logdate         date not null,
    peaktemp        int,
    unitsales       int
) PARTITION BY RANGE (logdate);

CREATE TABLE measurement_y2006m02 PARTITION OF measurement
    FOR VALUES FROM ('2006-02-01') TO ('2006-03-01');

CREATE TABLE measurement_y2006m03 PARTITION OF measurement
    FOR VALUES FROM ('2006-03-01') TO ('2006-04-01');


CREATE TABLE measurement_y2007m11 PARTITION OF measurement
    FOR VALUES FROM ('2007-11-01') TO ('2007-12-01');

CREATE TABLE measurement_y2007m12 PARTITION OF measurement
    FOR VALUES FROM ('2007-12-01') TO ('2008-01-01');

CREATE TABLE measurement_y2008m01 PARTITION OF measurement
    FOR VALUES FROM ('2008-01-01') TO ('2008-02-01')
    WITH (parallel_workers = 4);



insert into measurement (city_id, logdate, peaktemp, unitsales) 
VALUES (32, '2006-02-15', 12, 13);
commit;

CREATE SCHEMA reporting; 
commit;

select * from measurement;

select * from measurement_y2006m02;
select * from measurement_y2007m12;


drop table measurement_y2006m02;
drop table measurement_y2006m03;
drop table measurement_y2007m11;
drop table measurement_y2008m01;

drop table measurement;

select  SELECT current_database();

select count(*) from public.reporting_patient_states;


Create or replace Function Example( date) 
returns table ( col1 int, col2 int, col3 date )
language plpgsql
as $$
begin
	return query
		Select 1,2, current_date 
end;


$$;

--
--
-- 
Create or replace Function Example2 ( date) 
returns setof simple_reporting.reporting_patient_states
language plpgsql
as $$
begin return query
    Select 1,2, current_date ;
end;
$$;



select * from Example2(current_date);



select * from simple_reporting.reporting_patient_states_table_function ( date) 


select * from simple_reporting.reporting_patient_states_table_function2(date_trunc('month', current_date)::date);

select * from public.reporting_patient_states where month_date = date_trunc('month', current_date)::date;


select * from public.reporting_patient_states







-- HAHA 

DROP TABLE SHARD_TEST_001;
DROP TABLE SHARD_TEST_002;
DROP TABLE SHARD_TEST_003;

CREATE TABLE SHARD_TEST_001 as 
select * from simple_reporting.reporting_patient_states_table_function(date_trunc('month', current_date)::date);
ALTER TABLE SHARD_TEST_001 ADD CONSTRAINT SHARD_TEST_001_check CHECK (month_date = date_trunc('month', current_date)::date);

ALTER TABLE simple_reporting.reporting_patient_states ATTACH PARTITION SHARD_TEST_001
    FOR VALUES in  (date_trunc('month', current_date)::date);



CREATE TABLE SHARD_TEST_002 as 
select * from simple_reporting.reporting_patient_states_table_function(date_trunc('month', current_date - interval '1 month')::date);
ALTER TABLE SHARD_TEST_002 ADD CONSTRAINT SHARD_TEST_003_check CHECK (month_date = date_trunc('month', current_date - interval '1 month')::date);

ALTER TABLE simple_reporting.reporting_patient_states ATTACH PARTITION SHARD_TEST_002
    FOR VALUES in  (date_trunc('month', current_date - interval '1 month')::date);


CREATE TABLE SHARD_TEST_003 as 
select * from simple_reporting.reporting_patient_states_table_function(date_trunc('month', current_date - interval '2 month')::date);
ALTER TABLE SHARD_TEST_003 ADD CONSTRAINT SHARD_TEST_003_check CHECK (month_date = date_trunc('month', current_date - interval '2 month')::date);


ALTER TABLE simple_reporting.reporting_patient_states ATTACH PARTITION SHARD_TEST_003
    FOR VALUES in  (date_trunc('month', current_date - interval '2 month')::date);


-- CREATE INDEX IF NOT EXISTS index_reporting_patient_states_on_age_SHARD_TEST_001 ON SHARD_TEST_001 USING btree (age);
-- CREATE INDEX IF NOT EXISTS index_reporting_patient_states_on_age_SHARD_TEST_002 ON SHARD_TEST_002 USING btree (age);




explain select * from SHARD_TEST_001 where age > 40;;



select * from simple_reporting.reporting_patient_states;

explain select * from simple_reporting.reporting_patient_states where month_date = (date_trunc('month', current_date)::date);

explain select * from simple_reporting.reporting_patient_states;

explain select * from simple_reporting.reporting_patient_states where age > 40;
explain select * from simple_reporting.reporting_patient_states where month_date > (date_trunc('month', current_date - interval '2 month')::date) and age > 40;





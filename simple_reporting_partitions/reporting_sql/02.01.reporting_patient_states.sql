CREATE TABLE IF NOT EXISTS simple_reporting.reporting_patient_states (
    patient_id uuid,
    recorded_at timestamp without time zone,
    status character varying,
    gender character varying,
    age integer,
    age_updated_at timestamp without time zone,
    date_of_birth date,
    current_age double precision,
    month_date date,
    month double precision,
    quarter double precision,
    year double precision,
    month_string text,
    quarter_string text,
    hypertension text,
    prior_heart_attack text,
    prior_stroke text,
    chronic_kidney_disease text,
    receiving_treatment_for_hypertension text,
    diabetes text,
    assigned_facility_id uuid,
    assigned_facility_size character varying,
    assigned_facility_type character varying,
    assigned_facility_slug character varying,
    assigned_facility_region_id uuid,
    assigned_block_slug character varying,
    assigned_block_region_id uuid,
    assigned_district_slug character varying,
    assigned_district_region_id uuid,
    assigned_state_slug character varying,
    assigned_state_region_id uuid,
    assigned_organization_slug character varying,
    assigned_organization_region_id uuid,
    registration_facility_id uuid,
    registration_facility_size character varying,
    registration_facility_type character varying,
    registration_facility_slug character varying,
    registration_facility_region_id uuid,
    registration_block_slug character varying,
    registration_block_region_id uuid,
    registration_district_slug character varying,
    registration_district_region_id uuid,
    registration_state_slug character varying,
    registration_state_region_id uuid,
    registration_organization_slug character varying,
    registration_organization_region_id uuid,
    blood_pressure_id uuid,
    bp_facility_id uuid,
    bp_recorded_at timestamp without time zone,
    systolic integer,
    diastolic integer,
    blood_sugar_id uuid,
    bs_facility_id uuid,
    bs_recorded_at timestamp without time zone,
    blood_sugar_type character varying,
    blood_sugar_value numeric,
    blood_sugar_risk_state text,
    encounter_id uuid,
    encounter_recorded_at timestamp without time zone,
    prescription_drug_id uuid,
    prescription_drug_recorded_at timestamp without time zone,
    appointment_id uuid,
    appointment_recorded_at timestamp without time zone,
    visited_facility_ids uuid[],
    months_since_registration double precision,
    quarters_since_registration double precision,
    months_since_visit double precision,
    quarters_since_visit double precision,
    months_since_bp double precision,
    quarters_since_bp double precision,
    months_since_bs double precision,
    quarters_since_bs double precision,
    last_bp_state text,
    htn_care_state text,
    htn_treatment_outcome_in_last_3_months text,
    htn_treatment_outcome_in_last_2_months text,
    htn_treatment_outcome_in_quarter text,
    diabetes_treatment_outcome_in_last_3_months text,
    diabetes_treatment_outcome_in_last_2_months text,
    diabetes_treatment_outcome_in_quarter text,
    titrated boolean
) partition by list (month_date);


CREATE UNIQUE INDEX IF NOT EXISTS patient_states_month_date_patient_id ON simple_reporting.reporting_patient_states USING btree (month_date, patient_id);
CREATE INDEX IF NOT EXISTS index_reporting_patient_states_on_age ON simple_reporting.reporting_patient_states USING btree (age);
CREATE INDEX IF NOT EXISTS index_reporting_patient_states_on_gender ON simple_reporting.reporting_patient_states USING btree (gender);
CREATE INDEX IF NOT EXISTS index_reporting_patient_states_on_gender_and_age ON simple_reporting.reporting_patient_states USING btree (gender, age);
CREATE INDEX IF NOT EXISTS patient_states_assigned_block ON simple_reporting.reporting_patient_states USING btree (assigned_block_region_id);
CREATE INDEX IF NOT EXISTS patient_states_assigned_district ON simple_reporting.reporting_patient_states USING btree (assigned_district_region_id);
CREATE INDEX IF NOT EXISTS patient_states_assigned_facility ON simple_reporting.reporting_patient_states USING btree (assigned_facility_region_id);
CREATE INDEX IF NOT EXISTS patient_states_assigned_state ON simple_reporting.reporting_patient_states USING btree (assigned_state_region_id);
CREATE INDEX IF NOT EXISTS patient_states_care_state ON simple_reporting.reporting_patient_states USING btree (hypertension, htn_care_state, htn_treatment_outcome_in_last_3_months);
CREATE INDEX IF NOT EXISTS patient_states_month_date_assigned_facility ON simple_reporting.reporting_patient_states USING btree (month_date, assigned_facility_id);
CREATE INDEX IF NOT EXISTS patient_states_month_date_assigned_facility_region ON simple_reporting.reporting_patient_states USING btree (month_date, assigned_facility_region_id);
CREATE INDEX IF NOT EXISTS patient_states_month_date_registration_facility ON simple_reporting.reporting_patient_states USING btree (month_date, registration_facility_id);
CREATE INDEX IF NOT EXISTS patient_states_month_date_registration_facility_region ON simple_reporting.reporting_patient_states USING btree (month_date, registration_facility_region_id);
CREATE INDEX IF NOT EXISTS reporting_patient_states_bp_facility_id ON simple_reporting.reporting_patient_states USING btree (bp_facility_id);
CREATE INDEX IF NOT EXISTS reporting_patient_states_titrated ON simple_reporting.reporting_patient_states USING btree (titrated);



--
-- CREATES THE TABLE FUNCTION TO BE USED FOR AGGREGATION
--
Create or replace Function simple_reporting.reporting_patient_states_table_function ( date) 
returns setof simple_reporting.reporting_patient_states
language plpgsql
as $$
begin return query
SELECT
    DISTINCT ON (p.id)
    ------------------------------------------------------------
    -- basic patient identifiers
    p.id as patient_id,
    p.recorded_at AT TIME ZONE 'UTC' AT TIME ZONE 'UTC' as recorded_at,
    p.status,
    p.gender,
    p.age,
    p.age_updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'UTC' AS age_updated_at,
    p.date_of_birth,
    EXTRACT(YEAR
        FROM COALESCE(
            age(p.date_of_birth),
            make_interval(years => p.age) + age(p.age_updated_at)
        )
    )::float8  AS current_age,

    ------------------------------------------------------------
    -- data for the month of
    cal.month_date,
    cal.month,
    cal.quarter,
    cal.year,
    cal.month_string,
    cal.quarter_string,

    ------------------------------------------------------------
    -- medical history
    mh.hypertension as hypertension,
    mh.prior_heart_attack as prior_heart_attack,
    mh.prior_stroke as prior_stroke,
    mh.chronic_kidney_disease as chronic_kidney_disease,
    mh.receiving_treatment_for_hypertension as receiving_treatment_for_hypertension,
    mh.diabetes as diabetes,

    ------------------------------------------------------------
    -- information on assigned facility and parent regions
    p.assigned_facility_id AS assigned_facility_id,
    assigned_facility.facility_size as assigned_facility_size,
    assigned_facility.facility_type as assigned_facility_type,
    assigned_facility.facility_region_slug as assigned_facility_slug,
    assigned_facility.facility_region_id as assigned_facility_region_id,
    assigned_facility.block_slug as assigned_block_slug,
    assigned_facility.block_region_id as assigned_block_region_id,
    assigned_facility.district_slug as assigned_district_slug,
    assigned_facility.district_region_id as assigned_district_region_id,
    assigned_facility.state_slug as assigned_state_slug,
    assigned_facility.state_region_id as assigned_state_region_id,
    assigned_facility.organization_slug as assigned_organization_slug,
    assigned_facility.organization_region_id as assigned_organization_region_id,

    ------------------------------------------------------------
    -- information on registration facility and parent regions
    p.registration_facility_id AS registration_facility_id,
    registration_facility.facility_size as registration_facility_size,
    registration_facility.facility_type as registration_facility_type,
    registration_facility.facility_region_slug as registration_facility_slug,
    registration_facility.facility_region_id as registration_facility_region_id,
    registration_facility.block_slug as registration_block_slug,
    registration_facility.block_region_id as registration_block_region_id,
    registration_facility.district_slug as registration_district_slug,
    registration_facility.district_region_id as registration_district_region_id,
    registration_facility.state_slug as registration_state_slug,
    registration_facility.state_region_id as registration_state_region_id,
    registration_facility.organization_slug as registration_organization_slug,
    registration_facility.organization_region_id as registration_organization_region_id,

    ------------------------------------------------------------
    -- details of the visit: latest BP, BS, encounter, prescription drug and appointment
    bps.blood_pressure_id as blood_pressure_id,
    bps.blood_pressure_facility_id AS bp_facility_id,
    bps.blood_pressure_recorded_at AS bp_recorded_at,
    bps.systolic,
    bps.diastolic,

    bss.blood_sugar_id as blood_sugar_id,
    bss.blood_sugar_facility_id as bs_facility_id,
    bss.blood_sugar_recorded_at as bs_recorded_at,
    bss.blood_sugar_type as blood_sugar_type,
    bss.blood_sugar_value as blood_sugar_value,
    bss.blood_sugar_risk_state as blood_sugar_risk_state,

    visits.encounter_id AS encounter_id,
    visits.encounter_recorded_at AS encounter_recorded_at,

    visits.prescription_drug_id AS prescription_drug_id,
    visits.prescription_drug_recorded_at AS prescription_drug_recorded_at,

    visits.appointment_id AS appointment_id,
    visits.appointment_recorded_at AS appointment_recorded_at,

    visits.visited_facility_ids as visited_facility_ids,
    ------------------------------------------------------------
    -- relative time calculations

    (cal.year - DATE_PART('year', p.recorded_at AT TIME ZONE 'UTC' AT TIME ZONE (SELECT current_setting('TIMEZONE')))) * 12 +
    (cal.month - DATE_PART('month', p.recorded_at AT TIME ZONE 'UTC' AT TIME ZONE (SELECT current_setting('TIMEZONE'))))
    AS months_since_registration,

    (cal.year - DATE_PART('year', p.recorded_at AT TIME ZONE 'UTC' AT TIME ZONE (SELECT current_setting('TIMEZONE')))) * 4 +
    (cal.quarter - DATE_PART('quarter', p.recorded_at AT TIME ZONE 'UTC' AT TIME ZONE (SELECT current_setting('TIMEZONE'))))
    AS quarters_since_registration,

    visits.months_since_visit AS months_since_visit,
    visits.quarters_since_visit AS quarters_since_visit,
    bps.months_since_bp AS months_since_bp,
    bps.quarters_since_bp AS quarters_since_bp,
    bss.months_since_bs AS months_since_bs,
    bss.quarters_since_bs AS quarters_since_bs,

    ------------------------------------------------------------
    -- indicators
    CASE
        WHEN (bps.systolic IS NULL OR bps.diastolic IS NULL) THEN 'unknown'
        WHEN (bps.systolic < 140 AND bps.diastolic < 90) THEN 'controlled'
        ELSE 'uncontrolled'
        END
        AS last_bp_state,

    CASE
        WHEN p.status = 'dead' THEN 'dead'
        WHEN (
          -- months_since_registration
          (cal.year - DATE_PART('year', p.recorded_at AT TIME ZONE 'UTC' AT TIME ZONE (SELECT current_setting('TIMEZONE')))) * 12 +
          (cal.month - DATE_PART('month', p.recorded_at AT TIME ZONE 'UTC' AT TIME ZONE (SELECT current_setting('TIMEZONE')))) < 12

          OR

          visits.months_since_visit < 12
        ) THEN 'under_care'
        ELSE 'lost_to_follow_up'
        END
        AS htn_care_state,

    CASE
        WHEN (visits.months_since_visit >= 3 OR visits.months_since_visit is NULL) THEN 'missed_visit'
        WHEN (bps.months_since_bp >= 3 OR bps.months_since_bp is NULL) THEN 'visited_no_bp'
        WHEN (bps.systolic < 140 AND bps.diastolic < 90) THEN 'controlled'
        ELSE 'uncontrolled'
        END
        AS htn_treatment_outcome_in_last_3_months,

    CASE
        WHEN (visits.months_since_visit >= 2 OR visits.months_since_visit is NULL) THEN 'missed_visit'
        WHEN (bps.months_since_bp >= 2 OR bps.months_since_bp is NULL) THEN 'visited_no_bp'
        WHEN (bps.systolic < 140 AND bps.diastolic < 90) THEN 'controlled'
        ELSE 'uncontrolled'
        END
        AS htn_treatment_outcome_in_last_2_months,

    CASE
        WHEN (visits.quarters_since_visit >= 1 OR visits.quarters_since_visit is NULL) THEN 'missed_visit'
        WHEN (bps.quarters_since_bp >= 1 OR bps.quarters_since_bp is NULL) THEN 'visited_no_bp'
        WHEN (bps.systolic < 140 AND bps.diastolic < 90) THEN 'controlled'
        ELSE 'uncontrolled'
        END
        AS htn_treatment_outcome_in_quarter,

    CASE
        WHEN (visits.months_since_visit >= 3 OR visits.months_since_visit is NULL) THEN 'missed_visit'
        WHEN (bss.months_since_bs >= 3 OR bss.months_since_bs is NULL) THEN 'visited_no_bs'
        ELSE bss.blood_sugar_risk_state
        END
        AS diabetes_treatment_outcome_in_last_3_months,

    CASE
        WHEN (visits.months_since_visit >= 2 OR visits.months_since_visit is NULL) THEN 'missed_visit'
        WHEN (bss.months_since_bs >= 2 OR bss.months_since_bs is NULL) THEN 'visited_no_bs'
        ELSE bss.blood_sugar_risk_state
        END
        AS diabetes_treatment_outcome_in_last_2_months,

    CASE
        WHEN (visits.quarters_since_visit >= 1 OR visits.quarters_since_visit is NULL) THEN 'missed_visit'
        WHEN (bss.quarters_since_bs >= 1 OR bss.quarters_since_bs is NULL) THEN 'visited_no_bs'
        ELSE bss.blood_sugar_risk_state
        END
        AS diabetes_treatment_outcome_in_quarter,

    (current_meds.amlodipine > past_meds.amlodipine
        OR current_meds.telmisartan > past_meds.telmisartan
        OR current_meds.losartan > past_meds.losartan
        OR current_meds.atenolol > past_meds.atenolol
        OR current_meds.enalapril > past_meds.enalapril
        OR current_meds.chlorthalidone > past_meds.chlorthalidone
        OR current_meds.hydrochlorothiazide > past_meds.hydrochlorothiazide) AS titrated

FROM public.patients p
JOIN public.reporting_months cal on
    cal.month_date = $1 
    and p.recorded_at <= cal.month_date + interval '1 month' + interval '1 day' 
    --and p.recorded_at::timestamp at time zone 'utc' <= cal.month_date + interval '1 month'
    and ((to_char(timezone(( SELECT current_setting('TIMEZONE'::text) AS current_setting), timezone('UTC'::text, p.recorded_at)), 'YYYY-MM'::text) <= to_char((cal.month_date)::timestamp with time zone, 'YYYY-MM'::text)))
   -- TODO: manage small timezone gap
-- Only fetch BPs and visits that happened on or before the selected calendar month
-- We use year and month comparisons to avoid timezone errors
LEFT OUTER JOIN public.reporting_patient_blood_pressures bps
    ON p.id = bps.patient_id AND cal.month = bps.month AND cal.year = bps.year -- not using index ? why ?
LEFT OUTER JOIN public.reporting_patient_blood_sugars bss
    ON p.id = bss.patient_id AND cal.month = bss.month AND cal.year = bss.year -- not using index ? why ?
LEFT OUTER JOIN public.reporting_patient_visits visits
    ON p.id = visits.patient_id AND cal.month = visits.month AND cal.year = visits.year -- not using index ? why ?
LEFT OUTER JOIN public.medical_histories mh
    ON p.id = mh.patient_id
    AND mh.deleted_at IS NULL
LEFT OUTER JOIN public.reporting_prescriptions current_meds
    ON current_meds.patient_id = p.id
    AND cal.month_date = current_meds.month_date
LEFT OUTER JOIN public.reporting_prescriptions past_meds
    ON past_meds.patient_id = p.id
    AND cal.month_date = (past_meds.month_date + '1 month'::interval)
INNER JOIN public.reporting_facilities registration_facility
    ON registration_facility.facility_id = p.registration_facility_id
INNER JOIN public.reporting_facilities assigned_facility
    ON assigned_facility.facility_id = p.assigned_facility_id
WHERE p.deleted_at IS NULL;

end;
$$;



CREATE OR REPLACE PROCEDURE simple_reporting.reporting_patient_states_add_shard_internal (date)
language plpgsql
as $$
DECLARE
    TARGET_REFERENCE_DATE date := date_trunc('month', $1)::date;
    TARGET_TABLE_KEY varchar := TO_CHAR(TARGET_REFERENCE_DATE,'YYYYMMDD');
    TARGET_TO_DATE varchar := 'date_trunc(''month'', TO_DATE('''|| TARGET_TABLE_KEY ||''', ''YYYYMMDD''))::date' ;
    TARGET_TABLE_NAME varchar := 'simple_reporting.reporting_patient_states_shard_' || TARGET_TABLE_KEY;
    DROP_STATEMENT varchar := 'DROP TABLE IF EXISTS ' || TARGET_TABLE_NAME || ';'; 
    CTAS_STATEMENT varchar := 'CREATE TABLE ' || TARGET_TABLE_NAME 
        || ' AS SELECT * FROM simple_reporting.reporting_patient_states_table_function(' 
        || TARGET_TO_DATE || ');';
    UIND_STATEMENT varchar := 'CREATE UNIQUE INDEX IF NOT EXISTS patient_states_month_date_patient_shard_uind_'
        || TARGET_TABLE_KEY || ' ON ' 
        || TARGET_TABLE_NAME
        || ' USING btree (patient_id);'; 
    CHECK_STATEMENT varchar := 'ALTER TABLE ' || TARGET_TABLE_NAME 
        || ' ADD CONSTRAINT patient_states_month_date_patient_shard_check CHECK (month_date = ' 
        || TARGET_TO_DATE || ');';
    SHARD_STATEMENT varchar := 'ALTER TABLE simple_reporting.reporting_patient_states ATTACH PARTITION ' || TARGET_TABLE_NAME 
        || ' FOR VALUES in  (' 
        || TARGET_TO_DATE || ');';
    RUN_KEY uuid := gen_random_uuid ();
BEGIN
    CALL simple_reporting.MONITORED_EXECUTE(RUN_KEY, 'REPORTING_PATIENT_STATE_PARTITION_DROP ', DROP_STATEMENT);
    CALL simple_reporting.MONITORED_EXECUTE(RUN_KEY, 'REPORTING_PATIENT_STATE_PARTITION_CTAS ', CTAS_STATEMENT);
    CALL simple_reporting.MONITORED_EXECUTE(RUN_KEY, 'REPORTING_PATIENT_STATE_PARTITION_UIND ', UIND_STATEMENT);
    CALL simple_reporting.MONITORED_EXECUTE(RUN_KEY, 'REPORTING_PATIENT_STATE_PARTITION_CHECK', CHECK_STATEMENT);
    CALL simple_reporting.MONITORED_EXECUTE(RUN_KEY, 'REPORTING_PATIENT_STATE_PARTITION_SHARD', SHARD_STATEMENT);
END;
$$;

--
-- The main procedure, that refreshes one given month
--
CREATE OR REPLACE PROCEDURE simple_reporting.reporting_patient_states_add_shard (date)
language plpgsql
as $$
DECLARE
    CALL_INTERNAL_STATEMENT varchar := 'call simple_reporting.reporting_patient_states_add_shard_internal(TO_DATE(''' 
        || TO_CHAR($1, 'YYYY-MM')
        || ''', ''YYYY-MM''));';
BEGIN
    CALL simple_reporting.MONITORED_EXECUTE(gen_random_uuid (), 'REPORTING_PATIENT_STATE_PARTITION_ALL', CALL_INTERNAL_STATEMENT);
END;
$$;

--
-- HELPER FUNCTION TO ADD ALL SHARDS
--
CREATE OR REPLACE PROCEDURE simple_reporting.reporting_patient_states_add_all_shards ()
language plpgsql
as $$
DECLARE
   target_month_date date;
BEGIN
FOR target_month_date IN (SELECT MONTH_DATE FROM public.reporting_months order by MONTH_DATE desc)
LOOP
    call simple_reporting.reporting_patient_states_add_shard(target_month_date);
    commit;
END LOOP;
END;
$$;

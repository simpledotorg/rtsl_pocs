# Prometheus POC

## Challenge

Reporting in Simple is done inside the production database witf matview which are refreshed every day. This approach is not viable on the long term as 

## Purpose and Goal

The purpose of this POC is to verify is Prometheus and Grafana can be used to generate high level business reporting. 

## Running the POC locally



### Starting the docker system locally

pull this repo, then

```
cd prometheus_poc
docker compose up --no-start
docker compose start 
```

This will start a very basic system with the following services 

| Service  | image | Comment | Relevant URL |
| ------------- | ------------- | ------------- | ------------- |
| grafana | grafana/grafana | out-of-the-box grafana instance default password is admin/admin | http://localhost:3001/|
| prometheus | prom/prometheus | out-of-the-box prometheus instance | http://localhost:9090/ |
| tomcat | tomcat:11 | used as a simple way to serve metrics in HTTP | http://localhost:8080/static/metrics|
| blackboxexporter | quay.io/prometheus/blackbox-exporter:latest | **Not related to this POC** | http://localhost:9115/ |
| postgres | postgres:14-alpine |  | |


### Check the Dashboards !

The following dashboards shows the kind of rendering we can obtain:

| Example  | Dashboard | Comment |
| ------------- | ------------- | ------------- |
| Region report  | http://localhost:3001/d/eec1xgb9to83ke | All facilities in the region are aggregated |






## Under the hood

### 


### Getting metrics from (Example)

The following report is an example of what we can obtain with 
- https://metabase.bd.simple.org/question/980-test-prom-reporting

It includes metrics like

```
reporting_patient_states_by_month{country="test_country", date="2018-01-01", region="c438510d-a235-492a-b55d-95711bccb136", facility="2e7a4917-be56-4d2e-aee6-4c9738ab8a9b", gender="female", htn_care_state="lost_to_follow_up", htn_treatment_outcome_in_last_3_months="missed_visit", status="active"} 4
reporting_patient_states_by_month{country="test_country", date="2018-01-01", region="1a67c5a4-f680-44b0-bfd1-48fc911a9346", facility="5190c94f-5b69-454c-93e3-b596b43418cf", gender="female", htn_care_state="lost_to_follow_up", htn_treatment_outcome_in_last_3_months="missed_visit", status="active"} 1
reporting_patient_states_by_month{country="test_country", date="2018-01-01", region="8ada97f0-7d52-44c6-b04f-d1a08d66792a", facility="793cc6d9-f441-44cc-bae0-e4c2b5493fb2", gender="female", htn_care_state="lost_to_follow_up", htn_treatment_outcome_in_last_3_months="missed_visit", status="active"} 1
reporting_patient_states_by_month{country="test_country", date="2018-01-01", region="f88beb57-cb70-4dc0-b1f9-afa3490eecdf", facility="7a97c593-cff2-4d62-8e5d-9f9558b496aa", gender="female", htn_care_state="lost_to_follow_up", htn_treatment_outcome_in_last_3_months="missed_visit", status="active"} 1
reporting_patient_states_by_month{country="test_country", date="2018-01-01", region="52dd5dd0-c5df-4f3e-9a26-98ab69a0ddcb", facility="8ac5e9e2-695b-4e09-a7ac-e66e295406e5", gender="female", htn_care_state="lost_to_follow_up", htn_treatment_outcome_in_last_3_months="missed_visit", status="active"} 1
reporting_patient_states_by_month{country="test_country", date="2018-01-01", region="f7fd0bf3-7308-4aa7-b6a5-19bf6bf4c90b", facility="cc98c651-ce8b-4019-be6b-012f52d0cb21", gender="female", htn_care_state="lost_to_follow_up", htn_treatment_outcome_in_last_3_months="missed_visit", status="active"} 1
reporting_patient_states_by_month{country="test_country", date="2018-01-01", region="0aab4761-4850-4bcd-a7d9-dc43ebc0f993", facility="d0e24032-fcd7-4c9a-a380-8e7af80da9df", gender="female", htn_care_state="lost_to_follow_up", htn_treatment_outcome_in_last_3_months="missed_visit", status="active"} 1
```

The concept is to have a field **date** that contains the corresponding reporting month, plus any numbrer of other dimentions that make sense for the business (here **country**, **region**, **facility**, **gender**, **htn_care_state**, **htn_treatment_outcome_in_last_3_months**, **status**)

The result should be placed in file `prometheus_poc/metrics/metrics`

## Grafana Transformations

TODO

## The most overkill workaround ever

TODO

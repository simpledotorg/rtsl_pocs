# Using Partitions for Simple Reporting

## Challenge
Reporting in simple currently relies on Materialized Views, wich are refreshed every day. Some of these materialized views have a line per month and per patient, or a line per month and per facility, 
and are refreshed fully each day even if only a tiny 
fraction of the data has changed.

There are also significant challenges around refresh time (> 10 hours on some systems), which is only getting worse with the time.

In order to have a reliable 

## Constraints of the POC
The solution tested in that POC works within the following constraints:
- the solution should be backward compatible with the existing reporting solution
    - this means that we should not have to touch any report in Metabase or Simple Dashboards
- The data should be identical to the one obtained with the Materialized Views
- the solution should have a better refresh time than the existing solution
- the solution should have comparable data fetch time on routinely used queries

## Details of the solution

### SIMPLE_REPORTING Schema

In order to keep things properly separated, we keep everything related to the POC in a new schema **SIMPLE REPORTING**, without touching anything in the original **PUBLIC** schema.

Possibly this could be duplicated for the real implementation in order to have a clear separation between application data and reporting data.

### SIMPLE_REPORTING_RUNS Audit Table

In order to be able to get the calculation time/status easily, and audit table has been created in **SIMPLE REPORTING** schema, along with a few helper function. 

Possibly this could be duplicated for the real implementation in order to facilitate monitoring and investigation. This will likely need to be improved by adding a few more useful columns. 

### Replacement of the Materialized View

The materialize view is replaced with the following elements:




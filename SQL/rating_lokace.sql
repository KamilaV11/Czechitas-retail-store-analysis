-- uprava dat z clever maps
create or replace temporary table exposure_table AS
select *
     , cast("exp_index" as decimal)   as EXPOSURE_INDEX
     , cast("demog_index" as decimal) as DEMOGRAPHIC_INDEX
FROM VSECHNY_POBOCKY_EXPOS_DEMOG;

-- rating exposure index
create or replace temporary table rating_exposure AS
select "store_id"
     , exposure_index
     , (select min(exposure_index) from exposure_table)                     as minimum
     , (select max(exposure_index) from exposure_table)                     as maximum
     , (select avg(exposure_index) from exposure_table)                     as average
     , round((((exposure_index - minimum) / (maximum - minimum)) * 100), 1) as rating_exposure
from exposure_table;

-- rating demography
create or replace temporary table rating_demography AS
select "store_id"
     , demographic_index
     , (select min(demographic_index) from exposure_table)                     as minimum
     , (select max(demographic_index) from exposure_table)                     as maximum
     , (select avg(demographic_index) from exposure_table)                     as average
     , round((((demographic_index - minimum) / (maximum - minimum)) * 100), 1) as rating_demography
from exposure_table;


CREATE OR REPLACE TABLE STORE_METRICS_RATING_CLEVER AS
SELECT V."store_id"
     , concat(V."store_id", '_', A.YEAR) as "store_year_id"
     , A.YEAR
     , A.RATING_REVENUE
     , A.RATING_PROFIT_GOODS
     , A.RATING_GROSS_PROFIT_GOODS
     , A.RATING_PROFIT
     , A.RATING_GROSS_MARGIN
     , A.RATING_REVENUE_PER_M2
     , A.RATING_FIX_COST_VS_REVENUE_PERCENT
     , E.RATING_EXPOSURE
     , D.RATING_DEMOGRAPHY
FROM STORE_METRICS_RATING AS A

         LEFT JOIN RATING_EXPOSURE AS E
                   ON A.STORE_ID = E."store_id"

         LEFT JOIN RATING_DEMOGRAPHY AS D
                   ON A.STORE_ID = D."store_id"

         LEFT JOIN VSECHNY_POBOCKY_EXPOS_DEMOG AS V
                   ON A.STORE_ID = V."store_id";
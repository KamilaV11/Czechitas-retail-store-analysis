-- odstraneni let
create or replace temporary table metrics_bez_let as
select "store_id"
     , "store_id"          as                  "store_year_id"
     , 2020                as                  year
     , avg(RATING_REVENUE) as                  rating_revenue
     , avg(RATING_PROFIT_GOODS)                rating_profit_goods
     , avg(RATING_GROSS_PROFIT_GOODS)          rating_gross_profit_goods
     , avg(RATING_PROFIT)  as                  rating_profit
     , avg(RATING_GROSS_MARGIN)                rating_gross_margin
     , avg(RATING_REVENUE_PER_M2)              rating_revenue_per_m
     , avg(RATING_FIX_COST_VS_REVENUE_PERCENT) rating_fix_cost_vs_revenue
     , avg(RATING_EXPOSURE)                    rating_exposure
     , avg(RATING_DEMOGRAPHY)                  rating_demography
from STORE_METRICS_RATING_CLEVER
group by 1;

--  hodnoceni

create or replace table STORE_METRICS_RATING_CLEVER2 as
select *
     , (rating_revenue + RATING_PROFIT + RATING_GROSS_MARGIN + RATING_REVENUE_PER_M) / 400 as rating_finance_avg
     , (RATING_EXPOSURE + RATING_DEMOGRAPHY) / 200                                         as rating_lokace_avg
     , CASE
           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.1 then 5
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.1 then 5
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.1 then 5
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.1 then 5
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.1 then 4
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.1 then 4
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.1 then 4
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.1 then 4
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.1 then 4
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.1 then 4

           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.2 then 5
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.2 then 5
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.2 then 5
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.2 then 5
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.2 then 4
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.2 then 4
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.2 then 3
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.2 then 3
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.2 then 3
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.2 then 3

           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.3 then 5
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.3 then 5
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.3 then 4
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.3 then 4
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.3 then 4
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.3 then 3
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.3 then 3
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.3 then 3
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.3 then 3
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.3 then 3

           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.4 then 4
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.4 then 4
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.4 then 3
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.4 then 3
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.4 then 3
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.4 then 2
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.4 then 2
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.4 then 2
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.4 then 2
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.4 then 2

           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.5 then 3
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.5 then 3
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.5 then 2
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.5 then 2
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.5 then 2
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.5 then 2
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.5 then 2
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.5 then 2
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.5 then 2
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.5 then 2

           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.6 then 2
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.6 then 2
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.6 then 1
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.6 then 1
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.6 then 1
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.6 then 1
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.6 then 1
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.6 then 1
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.6 then 1
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.6 then 1

           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.7 then 2
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.7 then 2
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.7 then 1
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.7 then 1
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.7 then 1
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.7 then 1
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.7 then 1
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.7 then 1
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.7 then 1
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.7 then 1

           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.8 then 2
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.8 then 2
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.8 then 1
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.8 then 1
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.8 then 1
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.8 then 1
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.8 then 1
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.8 then 1
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.8 then 1
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.8 then 1

           when rating_lokace_avg < 0.1 and rating_finance_avg < 0.9 then 2
           when rating_lokace_avg < 0.2 and rating_finance_avg < 0.9 then 2
           when rating_lokace_avg < 0.3 and rating_finance_avg < 0.9 then 1
           when rating_lokace_avg < 0.4 and rating_finance_avg < 0.9 then 1
           when rating_lokace_avg < 0.5 and rating_finance_avg < 0.9 then 1
           when rating_lokace_avg < 0.6 and rating_finance_avg < 0.9 then 1
           when rating_lokace_avg < 0.7 and rating_finance_avg < 0.9 then 1
           when rating_lokace_avg < 0.8 and rating_finance_avg < 0.9 then 1
           when rating_lokace_avg < 0.9 and rating_finance_avg < 0.9 then 1
           when rating_lokace_avg <= 1 and rating_finance_avg < 0.9 then 1

           when rating_lokace_avg < 0.1 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg < 0.2 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg < 0.3 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg < 0.4 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg < 0.5 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg < 0.6 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg < 0.7 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg < 0.8 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg < 0.9 and rating_finance_avg <= 1 then 1
           when rating_lokace_avg <= 1 and rating_finance_avg <= 1 then 1
    end                                                                                    as doporuceni_rating

     , case
           when RATING_LOKACE_AVG < 0.23 then '5.very bad'
           when RATING_LOKACE_AVG < 0.28 then '4.bad'
           when RATING_LOKACE_AVG < 0.4 then '3.good'
           when RATING_LOKACE_AVG < 0.7 then '2.very good'
           when RATING_LOKACE_AVG <= 1 then '1.excellent'
    end                                                                                    as hodnoceni_lokace

     , case
           when rating_finance_avg < 0.25 then '5.very bad'
           when rating_finance_avg < 0.35 then '4.bad'
           when rating_finance_avg < 0.5 then '3.good'
           when rating_finance_avg < 0.7 then '2.very good'
           when rating_finance_avg <= 1 then '1.excellent'
    end                                                                                    as hodnoceni_finance

     , case
           when hodnoceni_finance = '1.excellent' and hodnoceni_lokace = '1.excellent' then '1.Cherish'

           when hodnoceni_finance = '2.very good' and hodnoceni_lokace = '2.very good' then '2.Maintain or Growth'
           when hodnoceni_finance = '2.very good' and hodnoceni_lokace = '3.good' then '2.Maintain or Growth'
           when hodnoceni_finance = '2.very good' and hodnoceni_lokace = '4.bad' then '3.Consider Relocation'

           when hodnoceni_finance = '3.good' and hodnoceni_lokace = '2.very good' then '2.Maintain or Growth'
           when hodnoceni_finance = '3.good' and hodnoceni_lokace = '3.good' then '2.Maintain or Growth'
           when hodnoceni_finance = '3.good' and hodnoceni_lokace = '4.bad' then '3.Consider Relocation'
           when hodnoceni_finance = '3.good' and hodnoceni_lokace = '5.very bad' then '3.Consider Relocation'

           when hodnoceni_finance = '4.bad' and hodnoceni_lokace = '1.excellent' then '4.High Cost to Sales'
           when hodnoceni_finance = '4.bad' and hodnoceni_lokace = '2.very good' then '4.High Cost to Sales'
           when hodnoceni_finance = '4.bad' and hodnoceni_lokace = '3.good' then '4.High Cost to Sales'
           when hodnoceni_finance = '4.bad' and hodnoceni_lokace = '4.bad' then '5.Relocate or Close'
           when hodnoceni_finance = '4.bad' and hodnoceni_lokace = '5.very bad' then '5.Relocate or Close'

           when hodnoceni_finance = '5.very bad' and hodnoceni_lokace = '3.good' then '6.Close'
           else 'ups chybi data, trhnete si nohou, trochu tu prodluzuju text, aby se zvetsila delka varchar'
    end                                                                                    as recommendation_txt

from metrics_bez_let;
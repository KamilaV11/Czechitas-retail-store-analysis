-- rating Revenue
create or replace temporary table rating_revenue AS
select store_id
     , year
     , revenue
     , (select min(revenue) from store_metrics)                                                      as minimum
     , (select max(revenue) from store_metrics)                                                      as maximum
     , (select avg(revenue) from store_metrics)                                                      as average
     , round((((revenue - minimum + (average / 2)) / (maximum - minimum + (average / 2))) * 100), 1) as rating_revenue
from store_metrics;

-- rating Profit from goods
create or replace temporary table rating_profit_goods AS
select store_id
     , year
     , profit_goods
     , (select min(profit_goods) from store_metrics) as minimum
     , (select max(profit_goods) from store_metrics) as maximum
     , (select avg(profit_goods) from store_metrics) as average
     , round((((profit_goods - minimum + (average / 2)) / (maximum - minimum + (average / 2))) * 100),
             1)                                      as rating_profit_goods
from store_metrics;

-- rating GROSS_PROFIT_GOODS
create or replace temporary table rating_GROSS_PROFIT_GOODS AS
select store_id
     , year
     , GROSS_PROFIT_GOODS
     , (select min(GROSS_PROFIT_GOODS) from store_metrics) as minimum
     , (select max(GROSS_PROFIT_GOODS) from store_metrics) as maximum
     , (select avg(GROSS_PROFIT_GOODS) from store_metrics) as average
     , round((((GROSS_PROFIT_GOODS - minimum + (average / 2)) / (maximum - minimum + (average / 2))) * 100),
             1)                                            as rating_GROSS_PROFIT_GOODS
from store_metrics;

-- rating profit
create or replace temporary table rating_profit AS
select store_id
     , year
     , profit
     , (select min(profit) from store_metrics)                                                      as minimum
     , (select max(profit) from store_metrics)                                                      as maximum
     , (select avg(profit) from store_metrics)                                                      as average
     , round((((profit - minimum + (average / 2)) / (maximum - minimum + (average / 2))) * 100), 1) as rating_profit
from store_metrics;

-- rating GROSS_MARGIN
create or replace temporary table rating_GROSS_MARGIN AS
select store_id
     , year
     , GROSS_MARGIN
     , (select min(GROSS_MARGIN) from store_metrics) as minimum
     , (select max(GROSS_MARGIN) from store_metrics) as maximum
     , (select avg(GROSS_MARGIN) from store_metrics) as average
     , round(((GROSS_MARGIN - minimum + abs((average / 2))) / (maximum - minimum + abs((average / 2))) * 100),
             1)                                      as rating_GROSS_MARGIN
from store_metrics;

-- rating REVENUE_PER_M2
create or replace temporary table rating_REVENUE_PER_M2 AS
select store_id
     , year
     , REVENUE_PER_M2
     , (select min(REVENUE_PER_M2) from store_metrics) as minimum
     , (select max(REVENUE_PER_M2) from store_metrics) as maximum
     , (select avg(REVENUE_PER_M2) from store_metrics) as average
     , round((((REVENUE_PER_M2 - minimum + (average / 2)) / (maximum - minimum + (average / 2))) * 100),
             1)                                        as rating_REVENUE_PER_M2
from store_metrics;

-- rating FIX_COST_VS_REVENUE_PERCENT
create or replace temporary table rating_FIX_COST_VS_REVENUE_PERCENT AS
select store_id
     , year
     , FIX_COST_VS_REVENUE_PERCENT
     , (select min(FIX_COST_VS_REVENUE_PERCENT) from store_metrics) as minimum
     , (select max(FIX_COST_VS_REVENUE_PERCENT) from store_metrics) as maximum
     , (select avg(FIX_COST_VS_REVENUE_PERCENT) from store_metrics) as average
     , round((-((FIX_COST_VS_REVENUE_PERCENT - minimum) / (maximum - minimum + (average / 2))) * 100), 1) +
       100                                                          as rating_FIX_COST_VS_REVENUE_PERCENT
from store_metrics;

create or replace table STORE_RATING AS
select rr.store_id
     , rr.year
     , rr.rating_revenue
     , rpg.rating_profit_goods
     , rgpg.rating_GROSS_PROFIT_GOODS
     , rp.rating_profit
     , rgm.rating_GROSS_MARGIN
     , rrpm.rating_REVENUE_PER_M2
     , rfcr.rating_FIX_COST_VS_REVENUE_PERCENT
from rating_revenue as rr
         left join rating_profit_goods as rpg
                   ON rr.store_id = rpg.store_id AND
                      rr.year = rpg.year
         left join rating_GROSS_PROFIT_GOODS as rgpg
                   ON rr.store_id = rgpg.store_id AND
                      rr.year = rgpg.year
         left join rating_profit as rp
                   ON rr.store_id = rp.store_id AND
                      rr.year = rp.year
         left join rating_GROSS_MARGIN as rgm
                   ON rr.store_id = rgm.store_id AND
                      rr.year = rgm.year
         left join rating_REVENUE_PER_M2 as rrpm
                   ON rr.store_id = rrpm.store_id AND
                      rr.year = rrpm.year
         left join rating_FIX_COST_VS_REVENUE_PERCENT as rfcr
                   ON rr.store_id = rfcr.store_id AND
                      rr.year = rfcr.year;
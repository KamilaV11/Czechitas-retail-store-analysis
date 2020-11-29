-- naklady na jednu pobocku na 1 mesic provozu
CREATE OR REPLACE TEMPORARY TABLE STORE_COST_AGG AS
SELECT s.store_id,
       s.name,
       s.area_m2,
       r.rent_per_m2 * s.area_m2              as RENT,
       w.wage * e.number_of_employees * 1.338 as WAGE_PER_STORE
FROM store AS s
         LEFT JOIN employment AS e
                   ON s.store_id = e.store_id
         LEFT JOIN wage_category AS w
                   ON e.category_id = w.category_id
         LEFT JOIN rent AS r
                   ON s.rent_id = r.rent_id;

-- vytvoreni tabulky s agregovanymi vynosy a naklady z transaction, dle roku, spojeno s STORE_COST_AGG
CREATE TEMPORARY TABLE TRANSACTION_REVENUE_COST AS
SELECT b.store_id,
       b.YEAR,
       sum(b.wage_per_store)                          as WAGE_PER_STORE,
       sum(b.rent)                                    as RENT,
       sum(b.revenue)                                 as REVENUE,
       sum(b.cost)                                    AS COST,
       sum(b.profit)                                  AS PROFIT,
       round(sum(b.profit) / sum(b.revenue), 3) * 100 as GROSS_MARGIN
from (
         SELECT t.STORE_ID,
                EXTRACT(YEAR FROM date)                    AS YEAR,
                EXTRACT(MONTH FROM date)                   AS MONTH,
                s.WAGE_PER_STORE,
                s.rent,
                SUM(SELLING_PRICE_VAT)                     AS REVENUE,
                SUM(COST_PRICE)                            AS COST,
                revenue - cost - s.rent - s.wage_per_store AS PROFIT
         FROM TRANSACTIONS as t
                  INNER JOIN STORE_COST_AGG as s
                             ON t.store_id = s.store_id
         GROUP BY 1, 2, 3, 4, 5
     ) b
group by 1, 2;

-- temporary table prumerna vynosnost z 1 uctenky
CREATE OR REPLACE TEMPORARY TABLE AVG_TRANSACTION_REVENUE AS
select STORE_ID
     , EXTRACT(YEAR FROM date)                              AS YEAR
     , SUM(SELLING_PRICE_VAT)                               AS REVENUE
     , ROUND(REVENUE / count(distinct (transaction_id)), 1) as AVG_TRANSACTION_REVENUE
FROM transactions
group by store_id, year;

-- vynosnost na 1m2
create or replace temporary table REVENUE_PER_M as
with revenue_agg as
         (select STORE_ID,
                 EXTRACT(YEAR FROM date) AS YEAR,
                 SUM(SELLING_PRICE_VAT)  AS REVENUE
          from transactions as t
          group by 1, 2)
select r.store_id,
       r.year,
       round(revenue / sca.rent, 1) AS REVENUE_PER_M2
from revenue_agg as r
         LEFT JOIN store as s
                   ON r.store_id = s.store_id
         left join store_cost_agg as sca
                   ON r.store_id = sca.store_id;

-- počet účtenek (nákupů, zákazníků) na prodejne v daném roce
CREATE OR REPLACE TEMPORARY TABLE COUNT_TRANSACTION_ID AS
SELECT STORE_ID
     , EXTRACT(YEAR FROM date)          AS YEAR
     , count(distinct (transaction_id)) AS count_transaction_id
FROM transactions
group by store_id, year;

-- obrat / rezijni naklady
CREATE or replace TEMPORARY TABLE FIX_COST_VS_REVENUE
AS
SELECT store_id
     , year
     , round(((wage_per_store + rent) / revenue) * 100, 1) AS FIX_COST_VS_REVENUE_PERCENT
FROM TRANSACTION_REVENUE_COST;

-- počet různých produků k obratu = obrat/ počet unikatnich pordukt id - diverzifikace
CREATE OR REPLACE TEMPORARY TABLE REVENUE_DIVERSIFICATION AS
SELECT store_id
     , EXTRACT(YEAR FROM date)              AS YEAR
     , count(distinct (product_id))         as COUNT_PRODUCTS
     , count(product_id)                    as COUNT_PRODUCTS_TOTAL
     , sum(SELLING_PRICE_VAT)               AS REVENUE
     , round((revenue / count_products), 1) as REVENUE_DIVERSIFICATION
     , round((revenue / sum(quantity)), 1)  as AVG_REVENUE_PER_PRODUCT
from transactions
group by store_id,
         year;

CREATE OR REPLACE TEMPORARY TABLE MED_PRICES AS
select store_id
     , EXTRACT(YEAR FROM date)                  AS YEAR
     , ROUND(MEDIAN(SELLING_PRICE_CALC_VAT), 0) AS MED_PRICE_CALC_VAT
     , ROUND(AVG(SELLING_PRICE_CALC_VAT), 0)    AS AVG_PRICE_CALC_VAT
     , ROUND(MEDIAN(SELLING_PRICE_VAT), 0)      AS MED_PRICE_VAT
     , ROUND(AVG(SELLING_PRICE_VAT), 0)         AS AVG_PRICE_VAT
FROM TRANSACTIONS
WHERE COST_PRICE > 5
GROUP BY store_id, year;

-- mega vystupni tabulka z hackatonu
CREATE OR REPLACE TABLE STORE_METRICS AS
SELECT trc.store_id,
       trc.year,
       trc.revenue,
       trc.cost,
       trc.revenue - trc.cost                                     AS profit_goods,
       round((((trc.revenue - trc.cost) / trc.revenue) * 100), 1) AS gross_profit_goods,
       trc.profit,
       trc.gross_margin,
       atr.AVG_TRANSACTION_REVENUE,
       rpm.revenue_per_m2,
       cti.count_transaction_id,
       fcvr.FIX_COST_VS_REVENUE_PERCENT,
       rd.revenue_diversification,
       rd.avg_revenue_per_product,
       md.MED_PRICE_CALC_VAT,
       md.AVG_PRICE_CALC_VAT,
       md.MED_PRICE_VAT,
       md.AVG_PRICE_VAT

FROM TRANSACTION_REVENUE_COST as trc

         LEFT JOIN AVG_TRANSACTION_REVENUE as atr
                   ON trc.store_id = atr.store_id
                       AND trc.year = atr.year

         LEFT JOIN REVENUE_PER_M as rpm
                   ON trc.store_id = rpm.store_id
                       AND trc.year = rpm.year

         LEFT JOIN count_transaction_id as cti
                   ON trc.store_id = cti.store_id
                       AND trc.year = cti.year

         LEFT JOIN fix_cost_vs_revenue as fcvr
                   ON trc.store_id = fcvr.store_id
                       AND trc.year = fcvr.year

         LEFT JOIN revenue_diversification as rd
                   ON trc.store_id = rd.store_id
                       AND trc.year = rd.year

         LEFT JOIN med_prices as md
                   ON trc.store_id = md.store_id
                       AND trc.year = md.year
;
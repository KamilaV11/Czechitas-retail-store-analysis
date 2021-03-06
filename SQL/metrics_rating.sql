CREATE OR REPLACE TABLE STORE_METRICS_RATING AS
SELECT A.STORE_ID
     , A.YEAR
     , A.REVENUE
     , B.RATING_REVENUE
     , A.COST
     , A.PROFIT_GOODS
     , B.RATING_PROFIT_GOODS
     , A.GROSS_PROFIT_GOODS
     , B.RATING_GROSS_PROFIT_GOODS
     , A.PROFIT
     , B.RATING_PROFIT
     , A.GROSS_MARGIN
     , B.RATING_GROSS_MARGIN
     , A.AVG_TRANSACTION_REVENUE
     , A.REVENUE_PER_M2
     , B.RATING_REVENUE_PER_M2
     , A.COUNT_TRANSACTION_ID
     , A.FIX_COST_VS_REVENUE_PERCENT
     , B.RATING_FIX_COST_VS_REVENUE_PERCENT
     , A.REVENUE_DIVERSIFICATION
     , A.AVG_REVENUE_PER_PRODUCT
     , A.MED_PRICE_CALC_VAT
     , A.AVG_PRICE_CALC_VAT
     , A.MED_PRICE_VAT
     , A.AVG_PRICE_VAT
FROM STORE_METRICS AS A

         LEFT JOIN STORE_RATING AS B
                   ON A.STORE_ID = B.STORE_ID
                       and A.YEAR = B.YEAR;
-- vytvoreni temp table s uctenkami leden-10.cervenec 2019 vcetne
CREATE OR REPLACE TEMPORARY TABLE TRANS_2019_JAN_JUL AS
select CAST("cislo_doklad" AS varchar(350))                                                                   TRANSACTION_ID,
       CAST("cislo_zbozi" AS varchar(350))                                                                    PRODUCT_ID,
       CAST("Filialka" AS int)                                                                                STORE_ID,
       date_from_parts(GET(split("Datum", '.'), 2), GET(split("Datum", '.'), 1), GET(split("Datum", '.'), 0)) DATE,
       CAST("cas_Jmeno" AS varchar(350))                                                                      TIME,
       CAST("PRODEJ_MNO" AS int)                                                                              QUANTITY,
       CAST(replace("PRODEJ_PCKALK_DPH", ',', '.') AS float)                                                  SELLING_PRICE_CALC_VAT,
       CAST(replace("PRODEJ_PC_DPH", ',', '.') AS float)                                                      SELLING_PRICE_VAT,
       CAST(replace("PRODEJ_NC", ',', '.') AS float)                                                          COST_PRICE
from "Pompo_uctenky_2019_do_cervence"
where date < '2019-07-11';

-- vytvoreni temp table s uctenkami leden-cerven 2020
CREATE OR REPLACE TEMPORARY TABLE TRANS_2020_JAN_JUN_2020 AS
select CAST("cislo_doklad" AS varchar(350))                                                                   TRANSACTION_ID,
       CAST("cislo_zbozi" AS varchar(350))                                                                    PRODUCT_ID,
       CAST("Filialka" AS int)                                                                                STORE_ID,
       date_from_parts(GET(split("Datum", '.'), 2), GET(split("Datum", '.'), 1), GET(split("Datum", '.'), 0)) DATE,
       CAST("cas_Jmeno" AS varchar(350))                                                                      TIME,
       CAST("PRODEJ_MNO" AS int)                                                                              QUANTITY,
       CAST(replace("PRODEJ_PCKALK_DPH", ',', '.') AS float)                                                  SELLING_PRICE_CALC_VAT,
       CAST(replace("PRODEJ_PC_DPH", ',', '.') AS float)                                                      SELLING_PRICE_VAT,
       CAST(replace("PRODEJ_NC", ',', '.') AS float)                                                          COST_PRICE
from pompo_2020_01_09
where date < '2020-07-01';

-- vytvoreni temp table s uctenkami cervenec-zari 2020
CREATE OR REPLACE temporary TABLE TRANS_2020_JUL_SEP AS
select CAST("cislo_dokladu" AS varchar(350))                                                                  TRANSACTION_ID,
       CAST("cislo_zbozi" AS varchar(350))                                                                    PRODUCT_ID,
       CAST("Filialka" AS int)                                                                                STORE_ID,
       date_from_parts(GET(split("Datum", '.'), 2), GET(split("Datum", '.'), 1), GET(split("Datum", '.'), 0)) DATE,
       CAST("cas_Jmeno" AS varchar(350))                                                                      TIME,
       CAST("PRODEJ_MNO" AS int)                                                                              QUANTITY,
       CAST(replace("PRODEJ_PCKALK_DPH", ',', '.') AS float)                                                  SELLING_PRICE_CALC_VAT,
       CAST(replace("PRODEJ_PC_DPH", ',', '.') AS float)                                                      SELLING_PRICE_VAT,
       CAST(replace("PRODEJ_NC", ',', '.') AS float)                                                          COST_PRICE
from "Transakce_Jul-Sep-2020";

-- vytvoreni finalni tabulky
CREATE OR REPLACE TABLE TRANSACTIONS AS
select *
from TRANS_2019_JAN_JUL
union
select *
from TRANS_2020_JAN_JUN_2020
union
select *
from TRANS_2020_JUL_SEP;

-- nahodne jsme vyfiltrovali pres row number skupinu nebo kategorii, aby bylo product_id unikatni
-- vytvoreni tabulky s ciselnikem produktu

create or replace table PRODUCTS AS
with a as (
    select CAST("cislo_zbozi" AS varchar(350))         PRODUCT_ID,
           CAST("cislo_zbozi_Jmeno" AS varchar(350))   PRODUCT_NAME,
           CAST("Skupina_zbozi" AS varchar(350))       PRODUCT_GROUP,
           CAST("Skupina_zbozi_Jmeno" AS varchar(350)) PRODUCT_GROUP_ID,
           CAST("Produktova_rada" AS varchar(350))     PRODUCT_SUBGROUP
    from "Transakce_Jul-Sep-2020"
    group by 1, 2, 3, 4, 5)
select *
from a
    qualify row_number() over (partition by product_id order by PRODUCT_GROUP) = 1;
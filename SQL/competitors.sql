-- prubezne, bez geolokace

create or replace table COMPETITORS AS
WITH c AS (
    select "Name"       NAME,
           "Street"     STREET,
           "City"       CITY,
           "ZIP"        ZIP,
           'BAMBULE' AS "COMPETITOR"
    from "bambule_clean"
    union
    select "Name"      NAME,
           "Street"    STREET,
           "City"      CITY,
           null     as "ZIP",
           'DRACIK' AS "COMPETITOR"
    from "dracik_clean-csv"
    union
    select "Name"       NAME,
           "Street"     STREET,
           "City"       CITY,
           null      as "ZIP",
           'SPARKYS' AS "COMPETITOR"
    from "sparkys_clean"
    union
    select "Name"    NAME,
           "Street"  STREET,
           "City"    CITY,
           "ZIP",
           'WIKY' AS "COMPETITOR"
    from "wiky_clean")
SELECT cast(COMPETITOR AS VARCHAR(350)) COMPETITOR,
       cast(NAME AS varchar(350))       NAME,
       cast(STREET AS varchar(350))     STREET,
       cast(CITY AS varchar(350))       CITY,
       cast(ZIP AS varchar(350))        ZIP
FROM c;

CREATE OR REPLACE TABLE COMPETITORS_ADDRESS AS
select concat(city, ',', street) as adress,
       competitor,
       name,
       street,
       city
from COMPETITORS
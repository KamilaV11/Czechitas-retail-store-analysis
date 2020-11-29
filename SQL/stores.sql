CREATE OR REPLACE TABLE EMPLOYMENT AS
SELECT CAST(stroe_ID AS int)                                 STORE_ID,
       CAST(category_ID AS int)                              CATEGORY_ID,
       CAST(replace(number_of_employees, ',', '.') AS float) NUMBER_OF_EMPLOYEES
FROM EMPLOYMENT1;

CREATE OR REPLACE TABLE RENT AS
SELECT CAST(rent_id as int)     RENT_ID,
       CAST(rent_per_m2 as int) RENT_PER_M2
FROM RENT1;

CREATE OR REPLACE TABLE STORE AS
SELECT CAST(store_id as int)             STORE_ID,
       CAST(name as varchar(350))        NAME,
       CAST(city as VARCHAR(350))        CITY,
       CAST(adress as VARCHAR(350))      ADRESS,
       CAST(postal_code as VARCHAR(350)) POSTAL_CODE,
       CAST(latitude as number(10, 8))   LATITUDE,
       CAST(longitude as number(10, 8))  LONGITUDE,
       CAST(area_m2 as float)            AREA_M2,
       CAST(rent_id AS int)              RENT_ID
FROM STORE1;

CREATE OR REPLACE TABLE WAGE_CATEGORY AS
SELECT CAST(category_id as int) CATEGORY_ID,
       CAST(wage as int)        WAGE
FROM "WAGE-CATEGORY1";
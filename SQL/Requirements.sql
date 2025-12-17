

INSERT INTO DW.DATE_DIM
WITH DATES AS (
  SELECT 
    DATEADD(DAY, SEQ4(), DATE('2000-01-01')) AS DATE_KEY
  FROM TABLE(GENERATOR(ROWCOUNT => 365 * 30))  
)
SELECT
  TO_NUMBER(TO_CHAR(DATE_KEY, 'YYYYMMDD'))          AS DATE_KEY,
  DATE_KEY                                          AS FULL_DATE,
  DAY(DATE_KEY)                                     AS DAY_NUM,
  TO_CHAR(DATE_KEY, 'DY')                           AS WEEKDAY_ABBR,
  DAYOFWEEK(DATE_KEY)                               AS WEEKDAY_NUM,
  DAYOFYEAR(DATE_KEY)                               AS DAY_OF_YEAR_NUM,
  WEEKOFYEAR(DATE_KEY)                              AS WEEK_OF_YEAR,
  MONTH(DATE_KEY)                                   AS MONTH_NUM,
  TO_CHAR(DATE_KEY, 'MON')                          AS MONTH_ABBR,
  QUARTER(DATE_KEY)                                 AS QUARTER_NUM,
  CASE QUARTER(DATE_KEY)
  WHEN 1 THEN 'Q1'
  WHEN 2 THEN 'Q2'
  WHEN 3 THEN 'Q3'
  WHEN 4 THEN 'Q4'
  END QUARTER_NAME,
  YEAR(DATE_KEY)                                    AS YEAR_NUM,
  DATE_TRUNC('MONTH', DATE_KEY)                     AS FIRST_DAY_OF_MONTH,
  LAST_DAY(DATE_KEY)                                AS LAST_DAY_OF_MONTH,
  CASE WHEN DAYOFWEEK(DATE_KEY) IN (1,7) THEN 'Y' ELSE 'N' END AS IS_WEEKEND
FROM DATES;



INSERT INTO DW.TIME_DIM 
WITH H AS(
	SELECT SEQ4() AS Hr FROM TABLE(GENERATOR(ROWCOUNT => 24))
),
M AS (
	SELECT SEQ4() AS Mi FROM TABLE(GENERATOR(ROWCOUNT => 60))
)
SELECT 
	LPAD(H.hr,2,'0') || LPAD(M.mi,2,'0') AS TIME_KEY,
	H.hr,
	M.mi,
	LPAD(H.hr,2,'0') || ':' || LPAD(M.mi,2,'0') AS TIME_24_HR
FROM H, M;





MERGE INTO DW.SALES_FACT t
USING (
  SELECT
      c.CUSTOMER_KEY,
      i.InvoiceId                                             AS INVOICE_ID,
      TO_NUMBER(TO_CHAR(DATE_TRUNC('day', i.InvoiceDate), 'YYYYMMDD')) AS DATE_DIM_KEY,
      i.Total                                                 AS TOTAL_SALE_AMT,
      'ADF'                                                   AS SOURCE_ID,
      CURRENT_TIMESTAMP()                                     AS DATE_TO_WAREHOUSE
  FROM CHINOOK_STAGE.INVOICE i
  JOIN DW.CUSTOMER_DIM c
    ON c.CUSTOMER_ID = i.CustomerId
  JOIN DW.DATE_DIM d
    ON d.DATE_KEY = TO_NUMBER(TO_CHAR(DATE_TRUNC('day', i.InvoiceDate), 'YYYYMMDD'))
) s
ON t.INVOICE_ID = s.INVOICE_ID
WHEN MATCHED THEN UPDATE SET
  t.CUSTOMER_KEY      = s.CUSTOMER_KEY,
  t.DATE_DIM_KEY      = s.DATE_DIM_KEY,
  t.TOTAL_SALE_AMT    = s.TOTAL_SALE_AMT,
  t.SOURCE_ID         = s.SOURCE_ID,
  t.DATE_TO_WAREHOUSE = s.DATE_TO_WAREHOUSE
WHEN NOT MATCHED THEN INSERT
  (SALES_KEY, CUSTOMER_KEY, INVOICE_ID, DATE_DIM_KEY, TOTAL_SALE_AMT, SOURCE_ID, DATE_TO_WAREHOUSE)
VALUES
  (DEFAULT,  s.CUSTOMER_KEY, s.INVOICE_ID, s.DATE_DIM_KEY, s.TOTAL_SALE_AMT, s.SOURCE_ID, s.DATE_TO_WAREHOUSE);


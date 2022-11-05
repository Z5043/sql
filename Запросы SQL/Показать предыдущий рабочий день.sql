SELECT
															ID_DATE, CAL_DATE,
															LAG (ID_DATE,1) over (ORDER BY ID_DATE) AS prev_order_date
															FROM kdw.DWD_CALENDAR dc 
															WHERE CAL_DATE BETWEEN  TRUNC(SYSDATE)-7 AND TRUNC(SYSDATE)
															AND WORK_DAY = 1) t
															WHERE t.CAL_DATE = TRUNC(SYSDATE)
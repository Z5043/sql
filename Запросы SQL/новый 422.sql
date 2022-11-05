SELECT  
r_r_date.CAL_DATE, 
  rl_c.CUST_NUM,
  rl.Z_NUM,
  COUNT(*)
FROM
KDW.DWD_CALENDAR  r_r_date,
  KDW.DWD_CUSTOMER  rl_c,
  KDW.DWF_REESTR_L  rl,
  KDW.DWD_SHIP_VIA  rl_sv,
  
   ( select 
ros.REESTR_ID, ros.SERVICE_CUST_ID, ros.ID_REESTR_DATE
from
  KDW.DWF_REESTR_ORD_SERVICE ros
WHERE
 ros.id_reestr_date  BETWEEN (SELECT kdw.getDateID(TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual) AND (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual)   
) r_os
WHERE
  ( rl.ID_SHIP_VIA=rl_sv.ID_SHIP_VIA  )
  AND ( rl.ID_REESTR_DATE=r_r_date.ID_DATE  )
  AND  ( rl_c.ID_CUSTOMER=rl.ID_CUSTOMER  )
  AND  (
  ( rl.id_reestr_date BETWEEN (SELECT kdw.getDateID(TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual) AND (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual)  )
  AND  ( rl_sv.DELIV = 2  )
  )
  AND ( r_os.SERVICE_CUST_ID = 13  )
   AND  ( r_os.REESTR_ID(+)=rl.REESTR_ID )
GROUP BY
r_r_date.CAL_DATE, 
  rl_c.CUST_NUM, 
  rl.Z_NUM



SELECT   
 r_r_date.CAL_DATE,
  r_c.CUST_NUM,
  nvl2(r_os.SERVICE_CUST_ID, 'Y','N'),
  r.Z_NUM,
r_os.SERVICE_CUST_ID ,
  SUM(( r.PACK_CARTONS )),
  SUM(( r.NUM_OF_CARTONS ))
FROM
  KDW.DWD_CALENDAR  r_r_date,
  KDW.DWD_CUSTOMER  r_c,
  ( select 
ros.REESTR_ID, ros.SERVICE_CUST_ID, ros.ID_REESTR_DATE
from
  KDW.DWF_REESTR_ORD_SERVICE ros
WHERE
 ros.id_reestr_date  BETWEEN (SELECT kdw.getDateID(TO_DATE(@Prompt('1. Äàòà íà÷àëà ïåðèîäà','A',,mono,free), 'DD.MM.YYYY')) FROM dual) AND (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Äàòà îêîí÷àíèÿ ïåðèîäà','A',,mono,free), 'DD.MM.YYYY')) FROM dual)   
) r_os,
  KDW.DWF_REESTR  r,
  KDW.DWD_SHIP_VIA  r_sv
WHERE
  ( r.ID_REESTR_DATE=r_r_date.ID_DATE  )
  AND  ( r.ID_SHIP_VIA=r_sv.ID_SHIP_VIA  )
  AND  ( r_c.ID_CUSTOMER=r.ID_CUSTOMER  )
  AND  ( r_os.REESTR_ID(+)=r.REESTR_ID
  )
  AND  ( r_os.SERVICE_CUST_ID = 13  )
  AND  (
  ( r.id_reestr_date BETWEEN (SELECT kdw.getDateID(TO_DATE(@Prompt('1. Äàòà íà÷àëà ïåðèîäà','A',,mono,free), 'DD.MM.YYYY')) FROM dual) AND (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Äàòà îêîí÷àíèÿ ïåðèîäà','A',,mono,free), 'DD.MM.YYYY')) FROM dual)  )
  AND  ( r_sv.DELIV = 2  )
  )
GROUP BY
  r_r_date.CAL_DATE, 
  r_c.CUST_NUM, 
  nvl2(r_os.SERVICE_CUST_ID, 'Y','N'), 
  r.Z_NUM,
r_os.SERVICE_CUST_ID 
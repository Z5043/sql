select item_num, sum(comit) comit, sum(alloc+ship) transfer_in, sum(t4) t4
from
(
SELECT   
  KDW.DWE_WHSE_T_L.ITEM_NUM,
  sum(KDW.DWE_WHSE_T_L.qty_committed) comit, 0 alloc, 0 ship, sum(case when KDW.DWE_WHSE_T_H.TRANS_TYPE='4' then KDW.DWE_WHSE_T_L.qty_committed else 0 end) t4
FROM
  KDW.DWE_WHSE_T_L,
  KDW.DWE_WHSE_T_H,
  KDW.DWE_ITEM_HIST,
  kdw.dwd_whse from_whs
WHERE
  ( KDW.DWE_WHSE_T_H.BO_NUM=KDW.DWE_WHSE_T_L.BO_NUM and KDW.DWE_WHSE_T_H.ORDER_DATE=KDW.DWE_WHSE_T_L.ORDER_DATE and KDW.DWE_WHSE_T_H.TRANSFER_NUM=KDW.DWE_WHSE_T_L.TRANSFER_NUM  )
  AND  ( KDW.DWE_ITEM_HIST.ITEM_NUM=KDW.DWE_WHSE_T_L.ITEM_NUM and KDW.DWE_WHSE_T_L.ORDER_DATE between KDW.DWE_ITEM_HIST.B_DATE and KDW.DWE_ITEM_HIST.E_DATE  )
  AND  (
  KDW.DWE_ITEM_HIST.STAT  IN  ('A')
  AND  ( KDW.DWE_WHSE_T_L.ORDER_DATE  BETWEEN 
TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY') AND  
TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
--  AND  ( KDW.DWE_WHSE_T_H.FROM_WHSE_CODE IN  @Prompt('Склад-донор','A',,multi,free))
 and ( from_whs.WHSE_CODE=KDW.DWE_WHSE_T_H.FROM_WHSE_CODE  )
  AND  (
  from_whs.TERR_CODE  =  '0'
  AND  from_whs.WHSE_TYPE  =  1
  )
  AND  ( KDW.DWE_WHSE_T_H.TO_WHSE_CODE IN @Prompt('Склад-получатель','A',,multi,free))
  )
   and   KDW.DWE_WHSE_T_H.TRANS_status= 1
GROUP BY
  KDW.DWE_WHSE_T_L.ITEM_NUM
union all
SELECT   
  KDW.DWE_WHSE_T_L.ITEM_NUM,
  0 comit, 
  sum(KDW.DWE_WHSE_T_L.qty_allocated) alloc, 0 ship, sum(case when KDW.DWE_WHSE_T_H.TRANS_TYPE='4' then KDW.DWE_WHSE_T_L.qty_allocated else 0 end) t4
FROM
  KDW.DWE_WHSE_T_L,
  KDW.DWE_WHSE_T_H,
  KDW.DWE_ITEM_HIST,
  kdw.dwd_whse from_whs
WHERE
  ( KDW.DWE_WHSE_T_H.BO_NUM=KDW.DWE_WHSE_T_L.BO_NUM and KDW.DWE_WHSE_T_H.ORDER_DATE=KDW.DWE_WHSE_T_L.ORDER_DATE and KDW.DWE_WHSE_T_H.TRANSFER_NUM=KDW.DWE_WHSE_T_L.TRANSFER_NUM  )
  AND  ( KDW.DWE_ITEM_HIST.ITEM_NUM=KDW.DWE_WHSE_T_L.ITEM_NUM and KDW.DWE_WHSE_T_L.ORDER_DATE between KDW.DWE_ITEM_HIST.B_DATE and KDW.DWE_ITEM_HIST.E_DATE  )
  AND  (
  KDW.DWE_ITEM_HIST.DIV_CODE  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
  AND  KDW.DWE_ITEM_HIST.STAT  =  'A'
  AND  ( KDW.DWE_WHSE_T_H.ORDER_DATE  BETWEEN 
TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY') AND  
TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
--  AND  ( KDW.DWE_WHSE_T_H.FROM_WHSE_CODE IN  @Prompt('Склад-донор','A',,multi,free)
--  )
 and ( from_whs.WHSE_CODE=KDW.DWE_WHSE_T_H.FROM_WHSE_CODE  )
  AND  (
  from_whs.TERR_CODE  =  '0'
  AND  from_whs.WHSE_TYPE  =  1
  )
  AND  ( KDW.DWE_WHSE_T_H.TO_WHSE_CODE IN @Prompt('Склад-получатель','A',,multi,free))
  )
    and KDW.DWE_WHSE_T_H.TRANS_status in (2)
GROUP BY
  KDW.DWE_WHSE_T_L.ITEM_NUM
union all
SELECT   
  KDW.DWE_WHSE_T_L.ITEM_NUM,0 comit,0 alloc,
  sum(KDW.DWE_WHSE_T_L.QTY_SHIPPED) ship, sum(case when KDW.DWE_WHSE_T_H.TRANS_TYPE='4' then KDW.DWE_WHSE_T_L.QTY_SHIPPED else 0 end) t4
FROM
  KDW.DWE_WHSE_T_L,
  KDW.DWE_WHSE_T_H,
  KDW.DWE_ITEM_HIST,
  kdw.dwd_whse from_whs
WHERE
  ( KDW.DWE_WHSE_T_H.BO_NUM=KDW.DWE_WHSE_T_L.BO_NUM and KDW.DWE_WHSE_T_H.ORDER_DATE=KDW.DWE_WHSE_T_L.ORDER_DATE and KDW.DWE_WHSE_T_H.TRANSFER_NUM=KDW.DWE_WHSE_T_L.TRANSFER_NUM  )
  AND  ( KDW.DWE_ITEM_HIST.ITEM_NUM=KDW.DWE_WHSE_T_L.ITEM_NUM and KDW.DWE_WHSE_T_L.ORDER_DATE between KDW.DWE_ITEM_HIST.B_DATE and KDW.DWE_ITEM_HIST.E_DATE  )
  AND  (
  KDW.DWE_ITEM_HIST.DIV_CODE  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
  AND  KDW.DWE_ITEM_HIST.STAT  =  'A'
  AND  ( KDW.DWE_WHSE_T_H.ORDER_DATE  BETWEEN 
TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY') AND  
TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
--  AND  ( KDW.DWE_WHSE_T_H.FROM_WHSE_CODE IN  @Prompt('Склад-донор','A',,multi,free)
--  )
 and ( from_whs.WHSE_CODE=KDW.DWE_WHSE_T_H.FROM_WHSE_CODE  )
  AND  (
  from_whs.TERR_CODE  =  '0'
  AND  from_whs.WHSE_TYPE  =  1
  )
  AND  ( KDW.DWE_WHSE_T_H.TO_WHSE_CODE IN @Prompt('Склад-получатель','A',,multi,free)
  )
  )  and KDW.DWE_WHSE_T_H.TRANS_status in (4)
GROUP BY
  KDW.DWE_WHSE_T_L.ITEM_NUM
)
group by 
item_num

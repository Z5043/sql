SELECT   
  M2_WHSE.TERR_NAME Название_региона,
  M2_WHSE.TERR_CODE Код_региона,
  m2_cust.CUST_NAME Название_клиента,
  m2_cust.STAT_CUST_NUM Код_осн_клиент,
  KDW.DWE_ITEM_DIV_M2.CUST_NUM Код_клиента,
  M2C.YYYY_MM Год_мес,
  COUNT( DISTINCT KDW.DWE_ITEM_DIV_M2.ITEM_NUM) Кол_во_товаров,
  count( distinct KDW.DWE_ITEM_DIV_M2.DOC_NUM) Кол_во_счетов,
  SUM(KDW.DWE_ITEM_DIV_M2.SUMR_BNUL) Расход,
  m2_cust.NETWORK_NAME Наименование_сети,
  m2_cust.NETWORK_ID Код_сети,
  m2_tar_seg.DESC_SEG Наименование_цел_сегмента,
  m2_cust.tar_code Код_цел_сегмента,
  m2_cust.P_SEGMENT Потенциальный_сегмент,
  KDW.DWE_ITEM_DIV_M2.ITEM_TS ТС,
  m2_cust.STAT_CUST_NAME Имя_осн_клиента,
  E_DIV_TS.NAME_1 Название_ТС,
 
  m2_cust.MA_NAME ФИО_ТП,
  KDW.DWE_ITEM_DIV_M2.TRANSIT Транзитная_отгрузка
 
FROM
  KDW.DWD_WHSE  M2_WHSE,
  KDW.DWD_CUSTOMER  m2_cust,
  KDW.DWE_ITEM_DIV_M2,
  KDW.DWD_CALENDAR  M2C,
  KDW.DWD_TAR_SEG  m2_tar_seg,
  KDW.DWE_DIVISION  E_DIV_TS,
  KDW.DW_PRICE_HISTORY  M2_PH
WHERE
  ( KDW.DWE_ITEM_DIV_M2.ITEM_TS=E_DIV_TS.DIV_CODE(+)  )
  AND  ( KDW.DWE_ITEM_DIV_M2.ITEM_NUM=M2_PH.ITEM_NUM and KDW.DWE_ITEM_DIV_M2.ITEM_DATE=M2_PH.B_DATE  )
  AND  ( m2_cust.CUST_NUM (+) = KDW.DWE_ITEM_DIV_M2.CUST_NUM and m2_cust.DATA_SRC (+) = KDW.DWE_ITEM_DIV_M2.DATA_SRC and KDW.DWE_ITEM_DIV_M2.TRANS_DATE BETWEEN m2_cust.B_DATE (+) and m2_cust.E_DATE (+)  )
  AND  ( M2C.CAL_DATE=KDW.DWE_ITEM_DIV_M2.TRANS_DATE  )
  AND  ( m2_tar_seg.CODE(+)=m2_cust.TAR_CODE AND m2_tar_seg.seg_code(+)='CS'  )
  AND  ( M2_WHSE.WHSE_CODE=KDW.DWE_ITEM_DIV_M2.WHSE_CODE  )
  AND  (
  M2_WHSE.WHSE_TYPE  =  1
  AND  ( KDW.DWE_ITEM_DIV_M2.TRANS_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')   AND  
TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
  AND  ( (KDW.DWE_ITEM_DIV_M2.MOVE_TYPE IN(4,5,9) OR KDW.DWE_ITEM_DIV_M2.CAUSE_CODE = '0060' AND KDW.DWE_ITEM_DIV_M2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY'))  )
  AND  KDW.DWE_ITEM_DIV_M2.ITEM_TS  !=  'Т44'
  --AND  m2_cust.CUST_NUM  IN  ('2056589', '1786302', '2093340', '1160590', '440455', '1512201', '2056589', '2502616', '1197279', '2568757', '293754', '2227720', '586821', '204637', '2606785', '1549604', '1867012', '750265', '2267029', '1714312', '2591887', '440455', '2587458', '1307811', '427135', '852933', '733327', '285966', '1149955')
  AND  M2_PH.hsz  =  '064'
  AND  m2_cust.STAT_CUST_NUM  =  @variable('Главкод')
  )
GROUP BY
  M2_WHSE.TERR_NAME, 
  m2_cust.CUST_NAME, 
  m2_cust.STAT_CUST_NUM, 
  KDW.DWE_ITEM_DIV_M2.CUST_NUM, 
  M2C.YYYY_MM, 
  m2_cust.NETWORK_NAME, 
  m2_cust.NETWORK_ID, 
  m2_tar_seg.DESC_SEG, 
  m2_cust.tar_code, 
  m2_cust.P_SEGMENT, 
  KDW.DWE_ITEM_DIV_M2.ITEM_TS, 
  m2_cust.STAT_CUST_NAME, 
  E_DIV_TS.NAME_1,
  m2_cust.MA_NAME,
  KDW.DWE_ITEM_DIV_M2.TRANSIT,
  M2_WHSE.TERR_CODE

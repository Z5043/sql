SELECT   
  ol.ORD_L_ID,
  ol_w.WHSE_CODE,
  ol.COMMITTED_QTY,
  ol.SHIPPED_QTY,
  ol_od.CAL_DATE,
  ol.ITEM_NUM,
  ol_i.IND_CATEGORY,
  ol_main_v.VENDOR_NUM,
  ol_main_v.VENDOR_NAME,
  ol_main_v.STOCK_CONTROL,
  ol_main_v.LEAD_TIME,
  ol_g.PROD_MANAGER,
  oj.ORDER_NUM,
  oj.DIV_CODE
  FROM
  KDW.DWF_ORD_L  ol,
  KDW.DWD_WHSE  ol_w,
  KDW.DWD_CALENDAR  ol_od,
  KDW.DWD_ITEM  ol_i,
  KDW.DWE_MAIN_ITEM_V  ol_main_v,
  KDW.DWE_ITEM_G  ol_g,
  KDW.DWF_ORD_L_CD_J  oj
WHERE
  ( ol_od.ID_DATE=ol.ID_ORDER_DATE  )
  AND  ( ol.ID_WHSE=ol_w.ID_WHSE  )
  AND  ( ol.ID_ITEM=ol_i.ID_ITEM  )
  AND  ( ol.ITEM_NUM=ol_g.ITEM_NUM  )
  AND  ( ol.ITEM_NUM=ol_main_v.ITEM_NUM  )
  AND  ( oj.ORD_L_ID=ol.ORD_L_ID )
  AND  (
  ( ol.ID_ORDER_DATE BETWEEN (SELECT kdw.getDateID(TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual) AND  (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual )  )
  AND  ( ol.ITEM_NUM IN @Prompt('5. Артикул','A',,multi,free) OR 'все' IN @Prompt('5. Артикул','A',,multi,free)  )
  )
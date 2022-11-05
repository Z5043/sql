SELECT   
  R_ITEM.ITEM_NUM,
  R_ITEM.ITEM_NAME,
  R_ITEM.IND_CATEGORY,
  SUM(( (ITEM_R.ON_HAND + ITEM_R.DAMAGED) )),
  SUM(( ITEM_R.COMMITTED_QTY )),
  R_WHSE.TERR_CODE,
  R_WHSE.TERR_NAME,
  SUM(( ITEM_R.NUM_OUT ))
FROM
  KDW.DWD_ITEM  R_ITEM,
  KDW.DWF_ITEM_R  ITEM_R,
  KDW.DWD_WHSE  R_WHSE,
  KDW.DWD_CALENDAR  R_CAL
WHERE
  ( ITEM_R.ID_DATE=R_CAL.ID_DATE  )
  AND  ( R_ITEM.ID_ITEM=ITEM_R.ID_ITEM  )
  AND  ( ITEM_R.ID_WHSE=R_WHSE.ID_WHSE  )
  AND  (
  ( (R_WHSE.WHSE_CODE IN @Prompt('7. Код склада','A',  'Склады (121)\Код склада (12101)' ,multi,free) OR 'все' IN @Prompt('7. Код склада','A',  'Склады (121)\Код склада (12101)' ,multi,free))  )
  AND  ( R_ITEM.ITEM_NUM IN (select SET_VALUE from KDW.W_SET_VALUES where set_id  =@Prompt('22. Список товаров','A','Список товаров (188)\Идентификатор набора (18802)',mono,free))  )
  AND  ( R_CAL.IS_CURRENT = 'Y'  )
  AND  R_ITEM.STATE  =  1
  )
GROUP BY
  R_ITEM.ITEM_NUM, 
  R_ITEM.ITEM_NAME, 
  R_ITEM.IND_CATEGORY, 
  R_WHSE.TERR_CODE, 
  R_WHSE.TERR_NAME

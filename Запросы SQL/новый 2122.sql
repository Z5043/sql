SELECT   
  M2C.YYYY_MM,
  DIV_M2.ITEM_NUM,
  M2_GOODS.ITEM_NAME,
  SUM(( DIV_M2.KOLR_BAR + DIV_M2.KOLR_BNUL + DIV_M2.KOLR_NUL + DIV_M2.KOLR_PRO + DIV_M2.KOLR_SPIS + DIV_M2.KOLR_VNUT )) Общий_расход
FROM
  KDW.DWD_CALENDAR  M2C,
  KDW.DWE_ITEM_DIV_M2 DIV_M2,
  KDW.DW_GOODS  M2_GOODS
WHERE
  ( DIV_M2.ITEM_NUM=M2_GOODS.ITEM_NUM(+)  )
  AND  ( M2C.CAL_DATE=DIV_M2.TRANS_DATE  )
  AND  (
  ( DIV_M2.TRANS_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')   AND  
TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
  AND  ( (DIV_M2.WHSE_CODE IN @Prompt('7.Код склада','A',,multi,free) OR  'все'  IN @Prompt('7.Код склада','A',,multi,free))  )
  AND  ( DIV_M2.ITEM_NUM IN (select set_value from KDW.W_SET_VALUES where set_id  = @Prompt('22. Список товаров','A',,mono,free))  )
  AND  (( (DIV_M2.MOVE_TYPE IN(4,5,9) OR DIV_M2.CAUSE_CODE = '0060' AND DIV_M2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY'))  )
  OR   ( DIV_M2.MOVE_TYPE = 4  )
  OR   ( DIV_M2.MOVE_TYPE = 5  ))
  )
GROUP BY
  M2C.YYYY_MM, 
  DIV_M2.ITEM_NUM, 
  M2_GOODS.ITEM_NAME

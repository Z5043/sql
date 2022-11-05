SELECT   
  ITEM_PO_L.ITEM_NUM as "Артикул",
  SUM(( PO_L.QTY_RECEIVED )) as "Количество шт",
  SUM(( PO_L.QTY_RECEIVED * ( PRICE_LIST_PO_L.ZCU_BNAL *  DECODE(PRICE_LIST_PO_L.CURR_CODE, 'Д', ( USD_RATE_PO_L.REG_RATE ), ( USD_RATE_PO_L.INNER_RATE )  ) ) )) as " Сумма в руб"
FROM
  KDW.DWD_ITEM  ITEM_PO_L,
  KDW.DWF_PO_L  PO_L,
  KDW.DWD_PRICE_LIST  PRICE_LIST_PO_L,
  KDW.DWD_USD_RATE  USD_RATE_PO_L,
  KDW.DWD_CALENDAR  PO_DATE_PO_L,
  KDW.DWD_WHSE  WHSE_PO_L,
  KDW.DWE_ITEM_G  po_l_g,
  KDW.DWD_VENDOR  VENDOR_PO_L
WHERE
  ( PO_L.ID_PO_DATE=PO_DATE_PO_L.ID_DATE  )
  AND  ( PRICE_LIST_PO_L.ID_PRICE_LIST=PO_L.ID_PRICE_LIST  )
  AND  ( ITEM_PO_L.ID_ITEM=PO_L.ID_ITEM  )
  AND  ( PO_L.ID_WHSE=WHSE_PO_L.ID_WHSE  )
  AND  ( USD_RATE_PO_L.ID_DATE=PO_L.ID_PO_DATE  )
  AND  ( PO_L.ID_VENDOR=VENDOR_PO_L.ID_VENDOR  )
  AND  ( po_l_g.ITEM_NUM=PO_L.ITEM_NUM  )
  AND  (
  ( PO_DATE_PO_L.CAL_DATE  BETWEEN 
TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY') AND  
TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
  AND  ( WHSE_PO_L.WHSE_CODE  IN @Prompt('4. Склады','A',,multi,free) or 'все' IN @Prompt('4. Склады','A',,multi,free)  )
  AND  ( VENDOR_PO_L.VENDOR_NUM IN @Prompt('6. Код поставщика','A',,multi,free))
  AND  ( po_l_g.TRADE_MARK_NAME IN @Prompt('7. Название ТМ','A',,multi,free) )
  )
GROUP BY
  ITEM_PO_L.ITEM_NUM
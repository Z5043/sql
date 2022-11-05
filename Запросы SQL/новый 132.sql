SELECT   
  VENDOR_PO_L.VENDOR_NUM,
  VENDOR_PO_L.VEND_NAME,
  PO_L.PO_NUM,
  po_l_mig.MAN_LOGIST,
  po_l_mig_logist.user_name,
  po_l_mig.VENDOR_NUM,
  po_l_mig_v.VEND_NAME
FROM
  KDW.DWD_VENDOR  VENDOR_PO_L,
  KDW.DWF_PO_L  PO_L,
  KDW.DWF_MAIN_ITEM_G  po_l_mig,
  KDW.DWD_U_OPER  po_l_mig_logist,
  KDW.DWD_VENDOR  po_l_mig_v,
  KDW.DWD_CALENDAR  PO_DATE_PO_L,
  KDW.DWD_WHSE  WHSE_PO_L
WHERE
  ( PO_L.ID_PO_DATE=PO_DATE_PO_L.ID_DATE  )
  AND  ( PO_L.ID_WHSE=WHSE_PO_L.ID_WHSE  )
  AND  ( PO_L.ID_VENDOR=VENDOR_PO_L.ID_VENDOR  )
  AND  ( PO_L.ITEM_NUM=po_l_mig.ITEM_NUM(+)  )
  AND  ( po_l_mig.ID_DATE=(SELECT kdw.getDateID(trunc(TO_DATE(@Prompt('3. Дата информации о товаре','A',,mono,free), 'DD.MM.YYYY'),'MM')) FROM dual)  )
  AND  ( po_l_mig_logist.USER_CODE (+) = po_l_mig.MAN_LOGIST AND po_l_mig_logist.DATA_SRC (+) = 'E'  )
  AND  ( po_l_mig_v.VENDOR_NUM (+) = po_l_mig.VENDOR_NUM AND po_l_mig_v.DATA_SRC (+) = 'E'  )
  AND  (
  ( PO_DATE_PO_L.CAL_DATE  BETWEEN 
TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY') AND  
TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
  AND  ( WHSE_PO_L.WHSE_CODE  IN @Prompt('4. Склады','A','Cклад (060205)\Код склада (06020501)',multi,free) or 'все' IN @Prompt('4. Склады','A','Cклад (060205)\Код склада (06020501)',multi,free)  )
  )

SELECT   
  ol.ORD_L_ID,
  ol_w.WHSE_CODE,
  oj.SUPPLY_TYPE,
  ol.OPEN_ORD_QTY,
  ol.COMMITTED_QTY
FROM
  KDW.DWF_ORD_L  ol,
  KDW.DWD_WHSE  ol_w,
  KDW.DWF_ORD_L_CD_J  oj
WHERE
  ( ol.ID_WHSE=ol_w.ID_WHSE  )


SELECT   
  oj.ORDER_NUM,
  oj.DIV_CODE,
  oj_i.ITEM_NAME,
  oj.ITEM_NUM,
  oj_ju.USER_CODE,
  oj_ju.USER_NAME
FROM
  KDW.DWF_ORD_L_CD_J  oj,
  KDW.DWD_ITEM  oj_i,
  KDW.DWD_U_OPER  oj_ju
WHERE
  ( oj_i.ID_ITEM=oj.ID_ITEM  )
  AND  ( oj_ju.ID_U_OPER=oj.ID_J_USER  )
SELECT   
  g_item_g.PROD_MANAGER,
  g_item_g.PROD_MANAGER_NAME,
  KDW.DW_GOODS.BAYER,
  g_oper.USER_NAME,
  KDW.DW_GOODS.ITEM_NUM
FROM
  KDW.DWE_ITEM_G  g_item_g,
  KDW.DWD_U_OPER  g_oper
WHERE
  ( g_item_g.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM  )
  AND  ( g_oper.user_code(+)=KDW.DW_GOODS.bayer  )

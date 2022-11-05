SELECT   
  mvw.ITEM_NUM,
  mvw_i.ITEM_NAME,
  mvw.VENDOR_NAME,
  mvw.VENDOR_NUM,
  mvw.PROD_MANAGER_NAME,
  mvw.PROD_MANAGER,
  mvw_goods.IND_CATEGORY,

  -- mvw_goods.ITEM_NUM
  mvw.VENDOR_ITEM
FROM
  KDW.DWE_MAIN_VEND_WHSE  mvw,
  KDW.DWD_ITEM  mvw_i,
  KDW.DW_GOODS  mvw_goods,
  KDW.DWD_WHSE  mvw_w
WHERE
  ( mvw_i.ITEM_NUM = mvw.ITEM_NUM AND mvw_i.IS_CURRENT = 'Y'  )
  AND  ( mvw.ID_WHSE=mvw_w.ID_WHSE  )
  AND  ( mvw.VEND_WHSE_STATUS <> 'D'  )
  AND  ( mvw.ITEM_NUM=mvw_goods.ITEM_NUM  )
  AND  (
  ( mvw.VENDOR_NUM IN @Prompt('7. Код поставщика','A',,multi,free)  )
  AND  mvw_goods.IND_CATEGORY  IN  ('О', 'K', 'D', 'Б', 'И', 'Т', 'E')
  AND  mvw_w.TERR_CODE  =  '0'
  )

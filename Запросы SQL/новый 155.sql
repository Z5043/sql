SELECT
  mvw.ITEM_NUM,
  max( mvw.STOCK_CONTROL) STOCK_CONTROL,
  max(mvw.LEAD_TIME) LEAD_TIME,
  max( mvw.quota) quota,
  max( mvw.VENDOR_NAME) VENDOR_NAME,
  max(mvw.VENDOR_NUM) VENDOR_NUM,
  max( mvw.PROD_MANAGER_NAME) PROD_MANAGER_NAME,
  max(mvw.PROD_MANAGER) PROD_MANAGER
FROM
  KDW.DWE_MAIN_VEND_WHSE mvw,
  KDW.DWD_WHSE mvw_w,
  KDW.DW_GOODS mvw_goods
WHERE
       
( mvw_w.WHSE_CODE = mvw_goods.SKL_OSN  or  mvw_w.TERR_CODE = '0')

  AND ( mvw.WHSE_CODE = mvw_w.WHSE_GROUP )
  
  AND ( mvw.ITEM_NUM = mvw_goods.ITEM_NUM )
  AND ( mvw.VEND_WHSE_STATUS <> 'D' )
  
  -- AND ( mvw.ITEM_NUM = '914586' )
  AND ( mvw.PROD_MANAGER IN @Prompt('МЛ','A',,multi,free) )

group by
mvw.ITEM_NUM
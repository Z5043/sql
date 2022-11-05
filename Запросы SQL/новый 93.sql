SELECT
  mvw_goods.ITEM_NUM Артикул,
  mvw_goods.ITEM_NAME Название_товара,
  mvw_goods.UNIT Ед_изм,
  mvw_goods.DIV_CODE Код_ТР,
  mvw_goods_TS.DIV_NAME Название_ТР,
  mvw_goods.IND_CATEGORY Признак_категория,
  mvw_goods.SKL_OSN СОХ,
  mvw_goods.HSZ ХСЗ,
  
  main_v.VENDOR_NUM,
  main_v.VENDOR_NAME,
  
  
  mvw.VENDOR_NUM Код_поставщика,
  mvw.VENDOR_NAME Название_поставщика,
  DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NUM, mvw.VEND_PARENT_NUM) Код_факт_поставщика,
  DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NAME, mvw.VEND_PARENT_NAME) Название_факт_поставщика,
  mvw.PROD_MANAGER Код_МЛ,
  mvw.PROD_MANAGER_NAME Название_МЛ,
  mvw.STOCK_CONTROL ЧКЗ,
  mvw.LEAD_TIME СП,
  mvw.TIME_GARANT ГВД,
  mvw.quota МТП,
  mvw.SUPPLY_TYPE Форма_снабжения,
  mvw.period_stock_a Период_запаса_А,
  mvw.period_stock_b Период_запаса_В,
  mvw.period_stock_c Период_запаса_С
FROM
  KDW.DW_GOODS mvw_goods,
  KDW.DWD_DIVISION mvw_goods_TS,
  KDW.DWE_MAIN_VEND_WHSE mvw,
  KDW.DWE_MAIN_ITEM_V mvw_main_item_v,
  KDW.DWD_WHSE mvw_w,
  KDW.DWE_MAIN_ITEM_V main_v
WHERE
      ( mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.IS_CURRENT = 'Y' )
	  AND ( mvw_goods.STATE='1' )
	 --  AND mvw_goods_TS.DIV_TYPE = 2

  
  AND ( mvw_goods.ITEM_NUM = mvw.ITEM_NUM(+) )
   AND ( mvw_goods.ITEM_NUM=main_v.ITEM_NUM)
  AND ( mvw.VEND_WHSE_STATUS <> 'D' )
  AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
  
  AND ( mvw_goods.SKL_OSN = mvw_w.WHSE_CODE )
  -- AND ( mvw_w.WHSE_GROUP = mvw.WHSE_CODE )
  
  AND ( mvw_goods_TS.DIV_CODE IN @Prompt('31. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free)
                     OR 'все' IN @Prompt('31. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free) )
  
  


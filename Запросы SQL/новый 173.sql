Select 
  t1.Артикул,
  t1.Название_товара,
  t1.Ед_изм,
  t1.Код_ТР,
  t1.Название_ТР,
  t1.Признак_категория,
  t1.СОХ,
  t1.ХСЗ,
  t1.Код_поставщика_5,
  t1.Название_поставщика_5,
  t1.Код_факт_поставщика_5,
  t1.Название_факт_поставщика_5,
  t2.Название_КМ,
  t2.Код_поставщика_16,
  t2.Название_поставщика_16,
  t2.Код_факт_поставщика_16,
  t2.Название_факт_поставщика_16,
  t1.Прод_менеджер,
  t1.Имя_прод_менеджер,
  t1.Байер,
  t1.Имя_байер,
  t2.МЛ,
  t2.Имя_МЛ,
  t1.СП,
  t1.ГВД,
  t1.ЧКЗ,
  t2.МТП,
  t2.Форма_снабжения,
  t2.Период_запаса_А,
  t2.Период_запаса_В,
  t2.Период_запаса_С
  from
(SELECT
  mvw_goods.ITEM_NUM Артикул,
  mvw_goods.ITEM_NAME Название_товара,
  mvw_goods.UNIT Ед_изм,
  mvw_goods.DIV_CODE Код_ТР,
  mvw_goods_TS.DIV_NAME Название_ТР,
  mvw_goods.IND_CATEGORY Признак_категория,
  mvw_goods.SKL_OSN СОХ,
  mvw_goods.HSZ ХСЗ,
  main_v.VENDOR_NUM Код_поставщика_5,
  main_v.VENDOR_NAME Название_поставщика_5,
  main_v.LEAD_TIME СП,
  main_v.TIME_GARANT ГВД,
  main_v.STOCK_CONTROL ЧКЗ,
  main_v.VEND_PARENT_NUM Код_факт_поставщика_5,
  main_v.VEND_PARENT_NAME Название_факт_поставщика_5,
  g_item_g.PROD_MANAGER Прод_менеджер,
  g_item_g.PROD_MANAGER_NAME Имя_прод_менеджер,
  mvw_goods.BAYER Байер,
  g_oper.USER_NAME Имя_байер
  FROM
  KDW.DW_GOODS mvw_goods,
  KDW.DWD_DIVISION mvw_goods_TS,
  KDW.DWD_WHSE mvw_w,
  KDW.DWE_MAIN_ITEM_V main_v,
  KDW.DWE_ITEM_G  g_item_g,
  KDW.DWD_U_OPER  g_oper
WHERE
( mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.IS_CURRENT = 'Y' )
  AND ( mvw_goods.ITEM_NUM = main_v.ITEM_NUM )
  AND ( g_item_g.ITEM_NUM(+)=mvw_goods.ITEM_NUM  )
  AND  ( g_oper.user_code(+)=mvw_goods.bayer  )
  AND ( mvw_goods.SKL_OSN = mvw_w.WHSE_CODE )
  AND ( mvw_goods_TS.DIV_CODE IN @Prompt('1. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free)
                     OR 'все' IN @Prompt('1. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free) )
  AND ( mvw_goods.STATE='1')
  AND ( mvw_goods.IND_CATEGORY IN @Prompt('2. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free)
                      OR 'все' IN @Prompt('2. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free) )
  
  ) t1
  
LEFT JOIN 

( SELECT
  mvw_goods.ITEM_NUM Артикул,
  mvw_item_g.PROD_MANAGER_NAME Название_КМ,
  mvw.VENDOR_NUM Код_поставщика_16,
  mvw.VENDOR_NAME Название_поставщика_16,
  DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NUM, mvw.VEND_PARENT_NUM) Код_факт_поставщика_16,
  DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NAME, mvw.VEND_PARENT_NAME) Название_факт_поставщика_16,
  mvw.PROD_MANAGER МЛ,
  mvw.PROD_MANAGER_NAME Имя_МЛ,
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
  KDW.DWE_ITEM_G mvw_item_g,
  KDW.DWE_MAIN_VEND_WHSE mvw,
  KDW.DWE_MAIN_ITEM_V mvw_main_item_v,
  KDW.DWD_WHSE mvw_w    
  WHERE 
  (mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.IS_CURRENT = 'Y' )
  AND ( mvw_goods.ITEM_NUM = mvw_item_g.ITEM_NUM )
  
  AND ( mvw_goods.ITEM_NUM = mvw.ITEM_NUM )
  AND ( mvw.VEND_WHSE_STATUS <> 'D' )
  AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
  AND ( mvw_goods.SKL_OSN = mvw_w.WHSE_CODE )
  AND ( mvw_w.WHSE_GROUP = mvw.WHSE_CODE )
  AND ( mvw_goods_TS.DIV_CODE IN @Prompt('1. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free)
                     OR 'все' IN @Prompt('1. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free) )
  AND ( mvw_goods.STATE='1')
  AND ( mvw_goods.IND_CATEGORY IN @Prompt('2. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free)
                      OR 'все' IN @Prompt('2. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free) )
  
  ) t2 
  on t1.Артикул=t2.Артикул
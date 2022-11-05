SELECT
  mvw_goods.ITEM_NUM Артикул,
  mvw_goods.ITEM_NAME Название_товара,
  mvw_goods.UNIT Ед_изм,
  mvw_goods.DIV_CODE Код_ТР,
  mvw_goods_TS.DIV_NAME Название_ТР,
  mvw_goods.IND_CATEGORY Признак_категория,
  mvw_goods.SKL_OSN СОХ,
  mvw_goods.HSZ ХСЗ,
  
  mvw_item_g.DESC_1 Название_ТН,
  mvw_item_g.DESC_2 Название_ТК,
  mvw_item_g.DESC_3 Название_ТГ,
  mvw_item_g.DESC_4 Название_АГ,
  mvw_item_g.DESC_5 Название_группы_5,
  mvw_item_g.DESC_6 Название_группы_6,
  
  mvw_g_oper.USER_NAME Название_байера,
  mvw_item_g.PROD_MANAGER_NAME Название_КМ,
  
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
  mvw.SUPPLY_TYPE Форма_снабжения
FROM
  KDW.DW_GOODS mvw_goods,
  KDW.DWD_DIVISION mvw_goods_TS,
  KDW.DWE_ITEM_G mvw_item_g,
  KDW.DWD_U_OPER mvw_g_oper,
  KDW.DWE_MAIN_VEND_WHSE mvw,
  KDW.DWE_MAIN_ITEM_V mvw_main_item_v,
  KDW.DWD_WHSE mvw_w
WHERE
      ( mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.DIV_TYPE = 2 AND mvw_goods_TS.IS_CURRENT = 'Y' )
  AND ( mvw_goods.ITEM_NUM = mvw_item_g.ITEM_NUM )
  AND ( mvw_goods.bayer = mvw_g_oper.user_code(+) )
  
  AND ( mvw_goods.ITEM_NUM = mvw.ITEM_NUM )
  AND ( mvw.VEND_WHSE_STATUS <> 'D' )
  AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
  
  AND ( mvw_goods.SKL_OSN = mvw_w.WHSE_CODE )
  AND ( mvw_w.WHSE_GROUP = mvw.WHSE_CODE )
  
  AND ( mvw_goods.SKL_OSN IN @Prompt('21. Код склада','A',{'все', '060', '00D', '0QR', '0D0', '0Q0', '00J', '00G', '0C0', '1DR', '1LE', '1DW', '1DH', '1DE', '1DQ', '092', 'CKL', '0MX', '05H', '1L5', '02V', '0B3', '01R', '0K3', '01B', '02M', '04P'},multi,free)
                 OR 'все' IN @Prompt('21. Код склада','A',{'все', '060', '00D', '0QR', '0D0', '0Q0', '00J', '00G', '0C0', '1DR', '1LE', '1DW', '1DH', '1DE', '1DQ', '092', 'CKL', '0MX', '05H', '1L5', '02V', '0B3', '01R', '0K3', '01B', '02M', '04P'},multi,free) )
  
  AND ( mvw_goods_TS.DIV_CODE IN @Prompt('31. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free)
                     OR 'все' IN @Prompt('31. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free) )
  
  AND ( mvw_goods.STATE IN @Prompt('36. Состояние товара','A',{'все', '1', '2'},multi,free)
               OR 'все' IN @Prompt('36. Состояние товара','A',{'все', '1', '2'},multi,free) )
  
  AND ( mvw_goods.IND_CATEGORY IN @Prompt('34. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free)
                      OR 'все' IN @Prompt('34. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free) )
  
  AND ( mvw_goods.HSZ IN @Prompt('35. ХСЗ','A',{'все', '064', 'Т33'},multi,free)
             OR 'все' IN @Prompt('35. ХСЗ','A',{'все', '064', 'Т33'},multi,free) )
  
  AND ( mvw_goods.ITEM_NUM IN @Prompt('37. Артикул','A',{'все', '120', '32033'},multi,free)
                  OR 'все' IN @Prompt('37. Артикул','A',{'все', '120', '32033'},multi,free) )

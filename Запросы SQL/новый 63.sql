 vt_catalog_tovara_kdw_other_16 AS
    (   SELECT /*+ materialize */
      mvw_goods.ITEM_NUM Артикул,
      mvw_goods.ITEM_NAME Название_товара,
      mvw_goods.UNIT Ед_изм,
      mvw_goods.DIV_CODE Код_ТР,
      mvw_goods_TS.DIV_NAME Название_ТР,
      mvw_goods.IND_CATEGORY Признак_категория,
      mvw_goods.SKL_OSN СОХ,
      mvw_goods.HSZ ХСЗ,
      mvw_goods.VOLUME Объём_см3,
      
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
      
      mvw.LEAD_TIME + mvw.STOCK_CONTROL СП_ЧКЗ,
      
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
      
      AND ( mvw_goods.ITEM_NUM = mvw.ITEM_NUM(+) )
      AND ( mvw.VEND_WHSE_STATUS <> 'D' )
      AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
      
      AND ( mvw_goods.SKL_OSN = mvw_w.WHSE_CODE )
      AND ( mvw_w.WHSE_GROUP = mvw.WHSE_CODE )
      and  (mvw_goods.DIV_CODE='Т93')
	)
      
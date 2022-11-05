 WITH     vt_whse_code AS
    (
    SELECT
      mvw_w.ID_WHSE ID_Кода_склада,
      mvw_w.WHSE_CODE Код_склада,
      mvw_w.WHSE_GROUP Код_группы_склада,
      mvw_w.TERR_CODE Код_региона
    FROM
      KDW.DWD_WHSE mvw_w
    WHERE mvw_w.TERR_CODE = 0
        AND mvw_w.CLP = 'Y'          
    )
  ,
 vt_catalog_tovara_kdw_other_16 AS
    (
  SELECT /*+ materialize */
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
      mvw_item_g.PROD_MANAGER_NAME Название_КМ
	
    FROM
      KDW.DW_GOODS mvw_goods,
      KDW.DWD_DIVISION mvw_goods_TS,
      KDW.DWE_ITEM_G mvw_item_g,
      KDW.DWD_U_OPER mvw_g_oper,
      vt_whse_code
 
    WHERE
          ( mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.DIV_TYPE = 2 AND mvw_goods_TS.IS_CURRENT = 'Y' )
      AND ( mvw_goods.ITEM_NUM = mvw_item_g.ITEM_NUM )
	  AND ( mvw_goods.ITEM_NUM IN  (select SET_VALUE from KDW.W_SET_VALUES where set_id  =@Prompt('22. Список товаров','A',,mono,free)))
      AND ( mvw_goods.bayer = mvw_g_oper.user_code(+) )
     
      AND ( mvw_goods.SKL_OSN = vt_whse_code.Код_склада )
	
    ),
	
	logist as
	
	(
	
	Select /*+ leading(vt_catalog_tovara_kdw_other_16) use_hash(vt_catalog_tovara_kdw_other_16 mvw) */
	  mvw.ITEM_NUM Артикул, 
	  mvw.VENDOR_NUM Код_поставщика,
      mvw.VENDOR_NAME Название_поставщика,
      DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NUM, mvw.VEND_PARENT_NUM) Код_факт_поставщика,
      DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NAME, mvw.VEND_PARENT_NAME) Название_факт_поставщика,
      mvw.PROD_MANAGER Код_МЛ,
      mvw.PROD_MANAGER_NAME Название_МЛ,
      
      mvw.LEAD_TIME + mvw.STOCK_CONTROL СП_ЧКЗ,
      mvw.LEAD_TIME СП,
	  
      mvw.quota МТП,
      mvw.SUPPLY_TYPE Форма_снабжения
	  
	  from 
	     KDW.DWE_MAIN_VEND_WHSE mvw,
         KDW.DWE_MAIN_ITEM_V mvw_main_item_v,
         vt_whse_code,
		 vt_catalog_tovara_kdw_other_16
	  where 
	   ( vt_catalog_tovara_kdw_other_16.Артикул = mvw.ITEM_NUM(+) )
      AND ( mvw.VEND_WHSE_STATUS <> 'D' )
      AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
      AND ( vt_catalog_tovara_kdw_other_16.СОХ = vt_whse_code.Код_склада )
      AND ( vt_whse_code.Код_группы_склада = mvw.WHSE_CODE )
	), 
	
   vt_abc AS
   
    (
    SELECT
      zs.ITEM_NUM Артикул,
      zso.ABC_VOLUME ABC_по_объёму,
      zso.ABC_COST ABC_по_себ_руб,
	  zso.ABC0 ABC_по_встречаемости
    FROM
      (
      SELECT /*+ leading(vt_whse_code) use_nl(vt_whse_code zs) materialize */ *
      FROM
        KDW.DWF_ZGL_STAT zs JOIN vt_whse_code
                              ON ( zs.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( zs.id_date = (SELECT kdw.getZGLDateID FROM dual ) )
      ) zs JOIN vt_catalog_tovara_kdw_other_16
             ON ( zs.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
           JOIN KDW.DWD_ZGL_STAT_OTHER zso
             ON ( zs.ID_ZGL_STAT_OTHER = zso.ID_ZGL_STAT_OTHER )
    )
  ,
    vt_mo as(
  SELECT
  dis.ITEM_NUM Артикул,
  dis.MO МО,
  dis.CCC3 ССР_10
  
 FROM
  KDW.V_ITN_STATS dis,
  vt_catalog_tovara_kdw_other_16,
  vt_whse_code
  WHERE
   dis.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул
  AND vt_whse_code.Код_склада = dis.WHSE_CODE
  )
  
  
  
  
  
  SELECT
    vt_catalog_tovara_kdw_other_16.Артикул,
    vt_catalog_tovara_kdw_other_16.Название_товара,
    vt_catalog_tovara_kdw_other_16.Признак_категория,
    vt_catalog_tovara_kdw_other_16.СОХ,
    vt_catalog_tovara_kdw_other_16.ХСЗ,
	vt_catalog_tovara_kdw_other_16.Код_ТР,
    vt_catalog_tovara_kdw_other_16.Название_ТР,
	vt_catalog_tovara_kdw_other_16.Название_ТК,
	vt_catalog_tovara_kdw_other_16.Название_байера,
    vt_catalog_tovara_kdw_other_16.Название_КМ,

	vt_abc.ABC_по_встречаемости,
	
	logist.Код_МЛ,
    logist.Название_МЛ,
    
   
	vt_mo.МО, 
	vt_mo.ССР_10
	
	  FROM
    vt_catalog_tovara_kdw_other_16,
    vt_abc,
	vt_mo,
	logist
  WHERE
       ( vt_catalog_tovara_kdw_other_16.Артикул = vt_abc.Артикул(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_mo.Артикул(+))
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = logist.Артикул(+))
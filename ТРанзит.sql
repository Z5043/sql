WITH 
vt_catalog_tovara_kdw_other_16 AS
    (
  SELECT   
      mvw_goods.ART_GL Корневой_артикул,
      mvw.ITEM_NUM Артикул,
      mvw_goods.ITEM_NAME Название_товара,
      mvw_goods.DIV_CODE Код_ТР,
      mvw_goods_TS.DIV_NAME Название_ТР,
      mvw_goods.GL_IND_CATEGORY Признак_категория,
      mvw.WHSE_CODE Код_склада ,
      R_WHSE.WHSE_NAME Название_склада ,
	  R_WHSE.TERR_CODE Регион,
      mvw.SUPPLY_TYPE Тип_поставки,
      mvw_g_oper.USER_NAME Название_байера,
    mvw.VENDOR_NUM Код_поставщика,
    mvw.VENDOR_NAME Название_поставщика,
    DECODE(NVL(mvw.vend_whse_status,'D'),'D',mvw_main_item_v.PROD_MANAGER,mvw.PROD_MANAGER) Код_МЛ,
    DECODE(NVL(mvw.vend_whse_status,'D'),'D',mvw_main_item_v.PROD_MANAGER_NAME,mvw.PROD_MANAGER_NAME)  Название_МЛ
  FROM
    KDW.DWE_MAIN_VEND_WHSE  mvw,
    KDW.DW_GOODS  mvw_goods,
    KDW.DWD_U_OPER mvw_g_oper,
    KDW.DWD_DIVISION mvw_goods_TS,
    KDW.DWD_WHSE  R_WHSE,
    KDW.DWE_MAIN_ITEM_V mvw_main_item_v
  WHERE
    ( mvw.ITEM_NUM=mvw_goods.ITEM_NUM  )
    AND  mvw.WHSE_CODE IN (@Prompt('1. Код склада','A',,multi,free))
    AND  ( mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.DIV_TYPE = 2 AND mvw_goods_TS.IS_CURRENT = 'Y' )
    AND ( mvw.VEND_WHSE_STATUS <> 'D' )
    AND mvw.SUPPLY_TYPE IN ('1','3')
    AND mvw_goods.STATE = 1
    AND mvw_goods.HSZ in ('064','Т33')
    AND ( mvw_goods.bayer = mvw_g_oper.user_code(+) )
    AND R_WHSE.WHSE_CODE = mvw.WHSE_CODE
    AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
    )
, 
vt_catalog_tovara_kdw_other_27 as(
  SELECT   
    rel_item.MAIN_ITEM_NUM Главный_артикул,
    rel_goods.IND_CATEGORY Признак_категория_главного,
    rel_item.SUB_ITEM_NUM Артикул,
    rel_sub_goods.IND_CATEGORY Признак_категория_подчиненного,
    rel_goods.ITEM_NAME Название_товара_главного,
    rel_sub_goods.ITEM_NAME Название_товара_подчиненного,
    rel_goods.DIV_CODE Код_ТР,
    rel_div.DIV_NAME Название_ТР,
    mvw_g_oper.USER_NAME Название_байера,
    rel_item.TAX_REGION Регион,
    w.WHSE_CODE Код_склада,
    rel_oper2.USER_NAME Имя_создавшего,
    rel_item.TIME_CREATED Дата_создания
  FROM
    KDW.DWD_BDT_ITEM_RELATION  rel_item,
    KDW.DW_GOODS  rel_goods,
    KDW.DW_GOODS  rel_sub_goods,
    KDW.DWD_DIVISION  rel_div,
    KDW.DWD_DIVISION  rel_sub_div,
    KDW.DWE_U_OPER  rel_oper2,
    kdw.dwe_whse w,
    KDW.DWD_U_OPER mvw_g_oper
  WHERE
    ( rel_item.SUB_ITEM_NUM=rel_sub_goods.ITEM_NUM  )
    AND  ( rel_item.MAIN_ITEM_NUM=rel_goods.ITEM_NUM  )
    AND  ( rel_div.IS_CURRENT='Y'  )
    AND  w.WHSE_CODE = '0B3'
    AND w.TERR_CODE = rel_item.TAX_REGION
    AND  ( rel_div.DIV_CODE=rel_goods.DIV_CODE  )
    AND  ( rel_item.USER_CREATED=rel_oper2.USER_CODE(+)  )
    AND  ( rel_sub_goods.DIV_CODE=rel_sub_div.DIV_CODE AND rel_sub_div.IS_CURRENT='Y'  )
    AND  ( rel_sub_div.DIV_CODE=rel_sub_goods.DIV_CODE  )
    AND  rel_item.REL_TYPE_ID  =  3
    AND  (rel_goods.IND_CATEGORY  !=  'H' OR   rel_sub_goods.IND_CATEGORY  !=  'H')
    AND rel_item.TIME_DELETED is null
    AND ( rel_sub_goods.bayer = mvw_g_oper.user_code(+) )
),
vt_table_full as
(
select 
t.Артикул Артикул,
t.Название_товара,
t.Код_склада Код_склада,
t.Главный_артикул Главный_артикул,
t.Признак_категория,
t.Код_ТР Код_ТР,
t.Название_ТР Название_ТР,
t.Название_байера Название_байера,
t.Регион Регион,
t.МЛ_Имя_создавшего МЛ_Имя_создавшего
from (
    select 
    vt_catalog_tovara_kdw_other_16.Артикул Артикул,
	vt_catalog_tovara_kdw_other_16.Название_товара Название_товара,
	vt_catalog_tovara_kdw_other_16.Корневой_артикул Главный_артикул,
	vt_catalog_tovara_kdw_other_16.Признак_категория Признак_категория,
    vt_catalog_tovara_kdw_other_16.Код_склада Код_склада,
	vt_catalog_tovara_kdw_other_16.Код_ТР Код_ТР,
    vt_catalog_tovara_kdw_other_16.Название_ТР Название_ТР,
    vt_catalog_tovara_kdw_other_16.Название_байера Название_байера,
    vt_catalog_tovara_kdw_other_16.Регион Регион,
    vt_catalog_tovara_kdw_other_16.Название_МЛ МЛ_Имя_создавшего
    from 
    vt_catalog_tovara_kdw_other_16
    UNION 
    select 
    vt_catalog_tovara_kdw_other_27.Артикул Артикул,
	vt_catalog_tovara_kdw_other_27.Название_товара_подчиненного Название_товара,
	vt_catalog_tovara_kdw_other_27.Главный_артикул Главный_артикул,
	vt_catalog_tovara_kdw_other_27.Признак_категория_главного Признак_категория,
    vt_catalog_tovara_kdw_other_27.Код_склада Код_склада,
	vt_catalog_tovara_kdw_other_27.Код_ТР Код_ТР,
    vt_catalog_tovara_kdw_other_27.Название_ТР Название_ТР,
    vt_catalog_tovara_kdw_other_27.Название_байера Название_байера,
    vt_catalog_tovara_kdw_other_27.Регион Регион,
    vt_catalog_tovara_kdw_other_27.Имя_создавшего МЛ_Имя_создавшего
    from 
    vt_catalog_tovara_kdw_other_27) t 
),
ostatok_vt_table as (
  SELECT  
    SUM(( ITEM_R.ON_HAND )) В_наличии,
    R_WHSE.WHSE_CODE Код_склада,
    R_WHSE.TERR_CODE Регион,
    ITEM_R.ITEM_NUM Артикул
  FROM
    KDW.DWF_ITEM_R  ITEM_R,
    KDW.DWD_WHSE  R_WHSE,
    vt_table_full
  WHERE
    ITEM_R.ID_WHSE=R_WHSE.ID_WHSE
    AND  ( ITEM_R.ID_DATE = (SELECT kdw.getDateID(sysdate-1) FROM dual)  )
    AND  ( ITEM_R.ITEM_NUM = vt_table_full.Артикул)
    AND vt_table_full.Код_склада = R_WHSE.WHSE_CODE
    AND  R_WHSE.WHSE_CODE IN (@Prompt('1. Код склада','A',,multi,free))
  GROUP BY
    R_WHSE.WHSE_CODE,
    ITEM_R.ITEM_NUM,
    R_WHSE.TERR_CODE
 )
,
mo_vt_table as (
  SELECT --+ MATERIALIZE
    zs.ITEM_NUM Артикул,
    zs.MO МО,
    zs_w.WHSE_CODE Код_склада
  FROM
    kdw.DWF_ITN_STATS  zs,
    KDW.DWD_WHSE  zs_w,
    vt_table_full
  WHERE
    ( zs.ID_WHSE=zs_w.ID_WHSE  )
    AND  ( zs.id_stat_date = (SELECT kdw.getZGLDateID FROM dual )  )
    AND  ( zs.ITEM_NUM = vt_table_full.Артикул  )
    AND vt_table_full.Код_склада = zs_w.WHSE_CODE
    AND  zs_w.WHSE_CODE IN (@Prompt('1. Код склада','A',,multi,free))
  )
  ,
priznak_zvp as (
  SELECT --+ MATERIALIZE
    zvp.ITEM_NUM Артикул,
    w.whse_code Код_склада,
    case
    when zvp.VALUE='Y' then 'Запрещен'
    when zvp.VALUE='N' then 'Разрешен'
    end zvp
  FROM
    kdw.DWE_ZAPRET_VP_HISTORY zvp,
    kdw.dwe_whse w ,
    vt_table_full
  WHERE
    ( zvp.WHSE_CODE  =  w.WHSE_CODE)
    AND (sysdate-1)  BETWEEN zvp.b_date AND zvp.e_date  
    AND  w.WHSE_CODE IN (@Prompt('1. Код склада','A',,multi,free))
    and zvp.ITEM_NUM = vt_table_full.Артикул
    AND vt_table_full.Код_склада = w.whse_code
  )
,
priznak_vp as (
  SELECT --+ MATERIALIZE
    KDW.DWE_ORD_TRANSFER.ITEM_NUM Артикул,
    KDW.DWE_ORD_TRANSFER.VALUE Разрешен_под_заказ,
    KDW.DWE_ORD_TRANSFER.WHSE_CODE Код_склада
  FROM
    KDW.DWE_ORD_TRANSFER,
    vt_table_full
  WHERE
  KDW.DWE_ORD_TRANSFER.ITEM_NUM = vt_table_full.Артикул
  AND vt_table_full.Код_склада = KDW.DWE_ORD_TRANSFER.WHSE_CODE
    AND   KDW.DWE_ORD_TRANSFER.WHSE_CODE IN (@Prompt('1. Код склада','A',,multi,free))
    AND  sysdate-1 between KDW.DWE_ORD_TRANSFER.B_DATE  AND KDW.DWE_ORD_TRANSFER.E_DATE  
)


select 
vt_table_full.Артикул Артикул,
vt_table_full.Название_товара,
vt_table_full.Признак_категория,
vt_table_full.Код_склада Код_склада,
vt_table_full.Главный_артикул Главный_артикул,
vt_table_full.Код_ТР Код_ТР,
vt_table_full.Название_ТР Название_ТР,
vt_table_full.Название_байера Название_байера,
vt_table_full.Регион Регион,
vt_table_full.МЛ_Имя_создавшего МЛ_Имя_создавшего,
vt_catalog_tovara_kdw_other_16.Тип_поставки,
vt_catalog_tovara_kdw_other_16.Название_склада,
vt_catalog_tovara_kdw_other_16.Код_поставщика,
vt_catalog_tovara_kdw_other_16.Название_поставщика,

ostatok_vt_table.В_наличии,

mo_vt_table.МО,

priznak_zvp.zvp,

priznak_vp.Разрешен_под_заказ

from 
vt_table_full
LEFT JOIN vt_catalog_tovara_kdw_other_16 on (vt_table_full.Артикул = vt_catalog_tovara_kdw_other_16.Артикул) AND (vt_table_full.Код_склада = vt_catalog_tovara_kdw_other_16.Код_склада)
LEFT JOIN vt_catalog_tovara_kdw_other_27 on (vt_table_full.Артикул = vt_catalog_tovara_kdw_other_27.Артикул) AND (vt_table_full.Код_склада = vt_catalog_tovara_kdw_other_27.Код_склада)
LEFT JOIN ostatok_vt_table on (vt_table_full.Артикул = ostatok_vt_table.Артикул) AND (vt_table_full.Код_склада = ostatok_vt_table.Код_склада)
LEFT JOIN mo_vt_table on (vt_table_full.Артикул = mo_vt_table.Артикул) AND (vt_table_full.Код_склада = mo_vt_table.Код_склада)
LEFT JOIN priznak_zvp on (vt_table_full.Артикул = priznak_zvp.Артикул) AND (vt_table_full.Код_склада = priznak_zvp.Код_склада)
LEFT JOIN priznak_vp on (vt_table_full.Артикул = priznak_vp.Артикул) AND (vt_table_full.Код_склада = priznak_vp.Код_склада)
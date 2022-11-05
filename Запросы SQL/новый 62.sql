Select distinct
it.item_num, item_name, unit, grp_name, ind_category, volume, weight_gross, div_code,
skl_osn, regcatalog, koef, batch, div_pack_qty, type_div_pack, zena, EDITION_TYPE_CODE, work_life, it.PACKAGE_SCHEMA_DESC,
it.LEVEL_COUNT, it.PS_PACK_MIN, it.PS_PACK_MAX, it.PS_PLACE_MIN,
it.PS_PLACE_MAX, it.PS_PALLET_MIN, it.PS_PALLET_MAX, safe_stock, NVL(on_hand,0) on_hand, NVL(committed_qty,0) committed_qty, NVL(cust_orders,0) cust_orders,
m, g, k, ABC_vol, ABC_cost, ABC, tnn, TRADE_MARK_NAME, HSZ, mpa,
logist, VENDOR_NUM, VENDOR_NAME, STOCK_CONTROL, LEAD_TIME, garant_level,
period_stock_a, period_stock_b, period_stock_c, quota, it.art_gl, seb, vend_vp, vend_name_vp, tnn2,
ig.PACKAGE_SCHEMA_DESC gl_PACKAGE_SCHEMA_DESC,
ig.LEVEL_COUNT gl_LEVEL_COUNT, ig.PS_PACK_MIN gl_PS_PACK_MIN,
ig.PS_PACK_MAX gl_PS_PACK_MAX, ig.PS_PLACE_MIN gl_PS_PLACE_MIN,
ig.PS_PLACE_MAX gl_PS_PLACE_MAX, ig.PS_PALLET_MIN gl_PS_PALLET_MIN,
ig.PS_PALLET_MAX gl_PS_PALLET_MAX, it.whse_code, value,
parent, parentn, supply_type, terr_code
from
(Select 
items.item_num, item_name, unit, grp_name, ind_category, volume, weight_gross, div_code,
skl_osn, regcatalog, koef, batch, div_pack_qty, type_div_pack, zena, EDITION_TYPE_CODE, work_life, PACKAGE_SCHEMA_DESC,
LEVEL_COUNT, PS_PACK_MIN, PS_PACK_MAX, PS_PLACE_MIN,
PS_PLACE_MAX, PS_PALLET_MIN, PS_PALLET_MAX, safe_stock, NVL(on_hand,0) on_hand, NVL(committed_qty,0) committed_qty, NVL(cust_orders,0) cust_orders,
m, g, k, ABC_vol, ABC_cost, ABC, tnn, TRADE_MARK_NAME, HSZ, mpa,
logist, VENDOR_NUM, VENDOR_NAME, STOCK_CONTROL, LEAD_TIME, garant_level,
period_stock_a, period_stock_b, period_stock_c, quota, art_gl, seb, vend_vp, vend_name_vp, tnn2, items.whse_code, items.value,
parent, parentn, supply_type, terr_code
from
(
Select 
artt1.item_num, item_name, unit, grp_name, ind_category, volume, weight_gross, div_code,
skl_osn, regcatalog, koef, batch, div_pack_qty, type_div_pack, zena, EDITION_TYPE_CODE, work_life, PACKAGE_SCHEMA_DESC,
LEVEL_COUNT, PS_PACK_MIN, PS_PACK_MAX, PS_PLACE_MIN,
PS_PLACE_MAX, PS_PALLET_MIN, PS_PALLET_MAX, m, g, k, ABC_vol, ABC_cost, ABC, tnn, TRADE_MARK_NAME, HSZ, mpa,
logist, VENDOR_NUM, VENDOR_NAME, STOCK_CONTROL, LEAD_TIME, garant_level,
period_stock_a, period_stock_b, period_stock_c, quota, art_gl, seb, vend_vp, vend_name_vp, tnn2, artt1.whse_code, artt1.value,
parent, parentn, artt1.supply_type, artt1.terr_code
from
-------------------------------------------------------------------------------------------------
(
SELECT   
  KDW.DW_GOODS.ITEM_NUM,
  KDW.DW_GOODS.ITEM_NAME,
  KDW.DW_GOODS.UNIT,
  NVL(SGROUPS.GRP_NAME, 'Подгруппа ' || KDW.DW_GOODS.SGRP_CODE) grp_name,
  KDW.DW_GOODS.IND_CATEGORY,
  KDW.DW_GOODS.VOLUME,
  KDW.DW_GOODS.WEIGHT_GROSS,
  KDW.DW_GOODS.DIV_CODE,
  KDW.DW_GOODS.SKL_OSN,
  KDW.DW_GOODS.REGCATALOG,
  g_ph.KOEF,
  KDW.DW_GOODS.BATCH,
  KDW.DW_GOODS.div_pack_qty,
  KDW.DW_GOODS.type_div_pack,
  round(g_ph.C_BNAL* DECODE(g_ph.CURR_CODE, 'Д',  g_rates.INNER_RATE, 1),2) zena,
  g_ph.ZCU_BNAL * DECODE(g_ph.CURR_CODE, 'Д',  (g_rates.reg_rate), (g_rates.inner_rate)) seb,
  g_item_g.EDITION_TYPE_CODE,
  G_MAIN_ITEM_V.work_life,
  ARTICLE_PM.PACKAGE_SCHEMA_DESC,
  ARTICLE_PM.LEVEL_COUNT,
  ARTICLE_PM.PS_PACK_MIN,
  ARTICLE_PM.PS_PACK_MAX,
  ARTICLE_PM.PS_PLACE_MIN,
  ARTICLE_PM.PS_PLACE_MAX,
  ARTICLE_PM.PS_PALLET_MIN,
  ARTICLE_PM.PS_PALLET_MAX,
  g_item_g.DESC_1 tnn,
  g_item_g.ITEM_G1 tnn2,
  g_item_g.TRADE_MARK_NAME,
  KDW.DW_GOODS.HSZ,
  KDW.DW_GOODS.ART_GL,
  lika.vendor_num vend_vp,--G_MAIN_ITEM_V.VENDOR_NUM vend_vp,
  NVL(lika.quota,1) quota, lika.STOCK_CONTROL, lika.LEAD_TIME,
  lika.VENDOR_NAME vend_name_vp,--G_MAIN_ITEM_V.VENDOR_NAME vend_name_vp,
  lika.whse_code,
  lika.supply_type,
  lika.value, 
  lika.terr_code
  FROM
  KDW.DW_GOODS,
  KDW.DW_GROUPS  SGROUPS,
  KDW.DW_PRICE_HISTORY  g_ph,
  KDW.DWE_CURR_RATE2  g_rates,
  KDW.DWE_ITEM_G  g_item_g,
  KDW.DWE_MAIN_ITEM_V  G_MAIN_ITEM_V,
  KDW.DWE_ARTICLE_PM  ARTICLE_PM,
  (select
 w.whse_code whse_code, w.item_num ITEM_NUM, w.vendor_num, w.VENDOR_NAME, w.supply_type supply_type, w.quota quota,   w.STOCK_CONTROL STOCK_CONTROL,
  w.LEAD_TIME LEAD_TIME, 'прямая поставка' value, R_WHSE.terr_code
from
 kdw.dwe_main_vend_whse w,
 KDW.DWD_WHSE  R_WHSE
where
 w.supply_type in (1, 2, 3) 
 and R_WHSE.whse_code=w.whse_code
 and
 (w.whse_code in   @Prompt('Склад-получатель','A',,multi,free)  ) and
w.vend_whse_status='A'
  ) lika  
WHERE
  ( KDW.DW_GOODS.SGRP_CODE=SGROUPS.GRP_CODE(+)  )
  AND  ( KDW.DW_GOODS.ITEM_NUM=g_item_g.ITEM_NUM  )
  AND  ( G_MAIN_ITEM_V.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM  )
  AND  ( g_rates.CURR_CODE='USD'  )
 and (KDW.DW_GOODS.IND_CATEGORY in ('О', 'D', 'Т', 'Л', 'U', 'И', 'K'))
  AND  ( g_rates.RATE_DATE=trunc(SYSDATE)-1  )
  AND  ( g_ph.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM AND TRUNC(SYSDATE) - 1 BETWEEN g_ph.B_DATE AND g_ph.e_date  )
  AND ( ARTICLE_PM.ITEM_NUM(+)=KDW.DW_GOODS.ITEM_NUM  )
  AND  (KDW.DW_GOODS.STATE  =  1)
  AND ( KDW.DW_GOODS.SKL_OSN IN @Prompt('Склад-донор','A',,multi,free))
  AND  lika.item_num = KDW.DW_GOODS.ITEM_NUM (+)  
  ) artt1,
(
 SELECT   
  zvp.ITEM_NUM art,
  zvp.whse_code,
  zvp.VALUE zvp
FROM
  kdw.DWE_ZAPRET_VP_HISTORY zvp,
(select
z.item_num ITEM_NUM,
z.whse_code
from
 kdw.dwe_main_vend_whse z
where
 z.supply_type in (1, 2, 3) and
 (z.whse_code in   @Prompt('Склад-получатель','A',,multi,free)  ) and
 z.vend_whse_status='A'
 group by z.item_num, z.whse_code) d
WHERE
  ( zvp.WHSE_CODE  =  d.WHSE_CODE)
  AND TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  BETWEEN zvp.b_date AND zvp.e_date  
  and (zvp.item_num=d.item_num)
 )  artt, 
--------------------------------------------------------------------------------
(
SELECT   
  zs_w.WHSE_CODE, --------------
 -- case when  zs.MOVE_DAYS < 50 then zs.MO_ALL else zs.MO end as M,
  zs_new.MO M,
  --zs_new.VO,
  zs.G,
  zs.K,
  zs.ITEM_NUM,
  zso.ABC_VOLUME || '(' || zso.ts_parent || ')' ABC_vol,
  zso.ABC_COST || '(' || zso.ts_parent || ')' ABC_cost,
  zso.ABC || '(' || zso.ts_parent || ')' ABC,
zs_i.item_ts,
  zso.MPA  
FROM
  KDW.DWF_ZGL_STAT  zs,
  KDW.DWD_ZGL_STAT_OTHER  zso,
  KDW.DWD_ITEM  zs_i,
  KDW.DWD_WHSE  zs_w,
  kdw.DWF_ITN_STATS zs_new
WHERE
  ( zs.ID_ZGL_STAT_OTHER=zso.ID_ZGL_STAT_OTHER  )
  AND  ( zs.ID_ITEM=zs_i.ID_ITEM  )
  AND  (zs.item_num=zs_new.item_num )
  AND  ( zs.ID_WHSE=zs_w.ID_WHSE  )
  AND  ( zs_new.id_whse=zs_w.id_whse )
  AND  (
  zs_i.STATE  =  1
  AND  ( zs.id_date = (SELECT kdw.getZGLDateID FROM dual )  )
  AND ( zs_new.id_stat_date = (SELECT kdw.getZGLDateID FROM dual )  )
  AND  ( zs_w.WHSE_CODE  IN  @Prompt('Склад-получатель','A',,multi,free))
  AND  (zs.ITEM_NUM  IN (select
w.item_num ITEM_NUM
from
 kdw.dwe_main_vend_whse w
where
 w.supply_type in (1, 2, 3) and
 (w.whse_code in   @Prompt('Склад-получатель','A',,multi,free)  ) and
 w.vend_whse_status='A'
 ))
  )
) mo,
(
SELECT   distinct
  mvw.PROD_MANAGER_NAME logist,
  mvw.vend_parent_num parent,
  mvw.vend_parent_name parentn,
  mvw.VENDOR_NUM,
  mvw.VENDOR_NAME,
  --mvw.STOCK_CONTROL,
  --mvw.LEAD_TIME,
  mvw.garant_level,
  mvw.period_stock_a,
  mvw.period_stock_b,
  mvw.period_stock_c,
  --NVL(mvw.quota,1) quota,
  mvw.ITEM_NUM,
  mvw_w.GRP_COUNT
FROM
  KDW.DWE_MAIN_VEND_WHSE  mvw,
  kdw.dwe_main_item_v m,
  KDW.DWD_WHSE  mvw_w,
  KDW.DWD_ITEM  mvw_i
WHERE
   ( mvw_i.ITEM_NUM = mvw.ITEM_NUM AND mvw_i.IS_CURRENT = 'Y'  )
  AND  ( mvw_w.ID_WHSE=mvw.ID_WHSE  )
  AND  ( mvw.VEND_WHSE_STATUS <> 'D'  )
 and mvw_w.GRP_COUNT in @Prompt('Склад-получатель','A',,multi,free)
 and mvw.actual_info = 'Y'
AND  (
  mvw.STOCK_CONTROL  IS NOT NULL  
  AND  ( mvw_i.STATE  =  1) and
	(mvw.item_num=m.item_num) 
--and (mvw.vendor_num=m.vendor_num)
and (mvw.whse_code  IN @Prompt('Склад-получатель','A',,multi,free))
  and (mvw.supply_type in (1, 2, 3))
  )
) vend
where artt1.item_num = artt.art(+)
and artt1.item_num =  mo.item_num(+)
and artt1.item_num =  vend.item_num(+)
and zvp = 'N'
--------------
AND artt1.whse_code = artt.whse_code(+)
and artt1.whse_code = mo.whse_code(+)
and artt1.whse_code = vend.grp_count(+)

) items,
(
SELECT   
  R_ITEM.ITEM_NUM,
  R_WHSE.WHSE_CODE,
  SUM(R_ITEM_W.SAFE_STOCK) safe_stock,
  SUM(( ITEM_R.ON_HAND )) on_hand,
  SUM(( ITEM_R.COMMITTED_QTY )) committed_qty,
  case when(SUM(( ITEM_R.CUST_ORDERS )) - SUM((ITEM_R.MARKETING_QTY)) + SUM(( ITEM_R.TFER_OUT )))<0 then 0 else
           SUM(( ITEM_R.CUST_ORDERS )) - SUM((ITEM_R.MARKETING_QTY)) + SUM(( ITEM_R.TFER_OUT )) end cust_orders
FROM
  KDW.DWD_ITEM  R_ITEM,
  KDW.DWD_ITEM_W  R_ITEM_W,
  KDW.DWF_ITEM_R  ITEM_R,
  KDW.DWD_WHSE  R_WHSE
WHERE
  ( R_ITEM.ID_ITEM=ITEM_R.ID_ITEM  )
  AND  ( R_ITEM_W.ID_ITEM_W=ITEM_R.ID_ITEM_W  )
  AND  ( ITEM_R.ID_WHSE=R_WHSE.ID_WHSE  )
  AND  (
  ( ITEM_R.ID_DATE IN (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual)  )
  AND  ( (R_WHSE.WHSE_CODE IN @Prompt('Склад-получатель','A',,multi,free))  )
 AND  ( R_ITEM.STATE  =  1)
 AND ( R_ITEM.ITEM_NUM IN (select
w.item_num ITEM_NUM
from
 kdw.dwe_main_vend_whse w
where
 w.supply_type in (1, 2, 3) and
 (w.whse_code in   @Prompt('Склад-получатель','A',,multi,free)  ) and
 w.vend_whse_status='A'))
 
  )
GROUP BY
  R_ITEM.ITEM_NUM,
  R_WHSE.WHSE_CODE
) ost
where items.item_num = ost.item_num(+) 

and (items.whse_code = ost.whse_code (+))
) it,
(

SELECT

KDW.DW_GOODS.ITEM_NUM,   

  NVL(ARTICLE_PM.PACKAGE_SCHEMA_DESC, GL_ART_PM.PACKAGE_SCHEMA_DESC) as PACKAGE_SCHEMA_DESC

  ,NVL(ARTICLE_PM.LEVEL_COUNT, GL_ART_PM.LEVEL_COUNT) as LEVEL_COUNT

  ,NVL(ARTICLE_PM.PS_PACK_MIN, GL_ART_PM.PS_PACK_MIN) as PS_PACK_MIN

  ,NVL(ARTICLE_PM.PS_PACK_MAX, GL_ART_PM.PS_PACK_MAX) as PS_PACK_MAX

  ,NVL(ARTICLE_PM.PS_PLACE_MIN, GL_ART_PM.PS_PLACE_MIN) as PS_PLACE_MIN

  ,NVL(ARTICLE_PM.PS_PLACE_MAX, GL_ART_PM.PS_PLACE_MAX) as PS_PLACE_MAX

  ,NVL(ARTICLE_PM.PS_PALLET_MIN, GL_ART_PM.PS_PALLET_MIN) as PS_PALLET_MIN

  ,NVL(ARTICLE_PM.PS_PALLET_MAX, GL_ART_PM.PS_PALLET_MAX) as PS_PALLET_MAX

  ,KDW.DW_GOODS.ART_GL

FROM

  KDW.DW_GOODS

  INNER JOIN KDW.DWE_ARTICLE_PM  ARTICLE_PM on  ARTICLE_PM.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM

  INNEr JOIN KDW.DWE_ARTICLE_PM  GL_ART_PM on  GL_ART_PM.ITEM_NUM=KDW.DW_GOODS.ART_GL

WHERE

  KDW.DW_GOODS.STATE  =  1 

  AND  ( KDW.DW_GOODS.SKL_OSN IN @Prompt('Склад-донор','A',,multi,free))
  AND  ( KDW.DW_GOODS.ITEM_NUM IN (select
w.item_num ITEM_NUM
from
 kdw.dwe_main_vend_whse w
where
 w.supply_type in (1, 2, 3) and
 (w.whse_code in   @Prompt('Склад-получатель','A',,multi,free)  ) and
 w.vend_whse_status='A'))

) ig
where it.ITEM_NUM= ig.ITEM_NUM(+)
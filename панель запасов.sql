WITH category_plus AS (
       SELECT
         CASE WHEN @Prompt('Регион', 'A', {'Регионы (кроме СПб)', 'СПб'}, mono, constrained) = 'СПб' THEN 'П' ELSE NULL END category
       FROM
       dual
      )	 

Select 
it.item_num, item_name, unit, grp_name, ind_category, volume, weight_gross, div_code,
skl_osn, regcatalog, koef, batch, div_pack_qty, type_div_pack, zena, EDITION_TYPE_CODE, 
case work_life
  when 0 then null
  when null then null
  else work_life
  end work_life, it.PACKAGE_SCHEMA_DESC,
it.LEVEL_COUNT, it.PS_PACK_MIN, it.PS_PACK_MAX, it.PS_PLACE_MIN,
it.PS_PLACE_MAX, it.PS_PALLET_MIN, it.PS_PALLET_MAX, safe_stock, NVL(on_hand,0) on_hand, NVL(committed_qty,0) committed_qty, NVL(cust_orders,0) cust_orders,
m, mo, g, k, ABC_vol, ABC_cost, ABC, tnn, TRADE_MARK_NAME, HSZ, mpa,
logist, VENDOR_NUM, VENDOR_NAME, STOCK_CONTROL, LEAD_TIME, garant_level,
period_stock_a, period_stock_b, period_stock_c, quota, it.art_gl, seb, vend_vp, vend_name_vp, tnn2,
ig.PACKAGE_SCHEMA_DESC gl_PACKAGE_SCHEMA_DESC,
ig.LEVEL_COUNT gl_LEVEL_COUNT, ig.PS_PACK_MIN gl_PS_PACK_MIN,
ig.PS_PACK_MAX gl_PS_PACK_MAX, ig.PS_PLACE_MIN gl_PS_PLACE_MIN,
ig.PS_PLACE_MAX gl_PS_PLACE_MAX, ig.PS_PALLET_MIN gl_PS_PALLET_MIN,
ig.PS_PALLET_MAX gl_PS_PALLET_MAX, b_date,  @variable('Склад-получатель ВП') sff, NVL(it.deal_limit,0) deal_limit, it.Тип_расчёта
from
(Select 
items.item_num, item_name, unit, grp_name, ind_category, volume, weight_gross, div_code,
skl_osn, regcatalog, koef, batch, div_pack_qty, type_div_pack, zena, EDITION_TYPE_CODE, work_life, PACKAGE_SCHEMA_DESC,
LEVEL_COUNT, PS_PACK_MIN, PS_PACK_MAX, PS_PLACE_MIN,
PS_PLACE_MAX, PS_PALLET_MIN, PS_PALLET_MAX, safe_stock, NVL(on_hand,0) on_hand, NVL(committed_qty,0) committed_qty, NVL(cust_orders,0) cust_orders,
m, mo, g, k, ABC_vol, ABC_cost, ABC, tnn, TRADE_MARK_NAME, HSZ, mpa,
logist, VENDOR_NUM, VENDOR_NAME, STOCK_CONTROL, LEAD_TIME, garant_level,
period_stock_a, period_stock_b, period_stock_c, quota, items.art_gl, seb, vend_vp, vend_name_vp, tnn2, b_date, items.deal_limit, items.Тип_расчёта
from
(
Select 
artt1.item_num, item_name, unit, grp_name, ind_category, volume, weight_gross, div_code,
skl_osn, regcatalog, koef, batch, div_pack_qty, type_div_pack, zena, EDITION_TYPE_CODE,  PACKAGE_SCHEMA_DESC,
LEVEL_COUNT, PS_PACK_MIN, PS_PACK_MAX, PS_PLACE_MIN,
PS_PLACE_MAX, PS_PALLET_MIN, PS_PALLET_MAX, m, mo, g, k, ABC_vol, ABC_cost, ABC, tnn, TRADE_MARK_NAME, HSZ, mpa,
logist, VENDOR_NUM, VENDOR_NAME, STOCK_CONTROL, LEAD_TIME, garant_level,
period_stock_a, period_stock_b, period_stock_c, quota, artt1.art_gl, seb, vend_vp, vend_name_vp, tnn2, artt.b_date, artt1.deal_limit, artt1.Тип_расчёта
from
( SELECT   
  zvp.ITEM_NUM art,
  zvp.b_date b_date,
  zvp.VALUE zvp
FROM
  kdw.DWE_ZAPRET_VP_HISTORY zvp,
  kdw.dwe_whse w 
WHERE
  (zvp.WHSE_CODE  =  w.WHSE_CODE)
  AND TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  BETWEEN zvp.b_date AND zvp.e_date  
  AND  w.WHSE_CODE = @variable('Склад-получатель ВП')
)  artt,
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
  case G_MAIN_ITEM_V.work_life
  when 0 then null
  when null then null
  else G_MAIN_ITEM_V.work_life
  end work_life,
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
  G_MAIN_ITEM_V.VENDOR_NUM vend_vp,
  G_MAIN_ITEM_V.VENDOR_NAME vend_name_vp,
  ll.deal_limit,
  
  tr.Тип_расчёта
FROM
  KDW.DW_GOODS,
  
  (
  SELECT
    CASE WHEN @Prompt('Тип расчёта', 'A', {'Общая', 'Летняя'}, mono, constrained) = 'Общая' THEN 1 ELSE 2 END Тип_расчёта
  FROM
    dual
  ) tr,
  
  KDW.DW_GROUPS  SGROUPS,
  KDW.DW_PRICE_HISTORY  g_ph,
  KDW.DWE_CURR_RATE2  g_rates,
  KDW.DWE_ITEM_G  g_item_g,
  KDW.DWE_MAIN_ITEM_V  G_MAIN_ITEM_V,
  KDW.DWE_ARTICLE_PM  ARTICLE_PM,
  (select item_num, whse_code, deal_limit from kdw.dwd_item_w where is_current='Y' and TYPE_LIMIT=0)  ll,
  category_plus
WHERE
  ( KDW.DW_GOODS.SGRP_CODE=SGROUPS.GRP_CODE(+)  )
  AND  ( KDW.DW_GOODS.ITEM_NUM=g_item_g.ITEM_NUM  )
  and ll.item_num(+)=KDW.DW_GOODS.ITEM_NUM and ll.whse_code(+)=KDW.DW_GOODS.SKL_OSN
  AND  ( G_MAIN_ITEM_V.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM  )
  AND  ( g_rates.CURR_CODE='USD'  )
  AND  ( g_rates.RATE_DATE=trunc(SYSDATE)-1  )
  AND  ( g_ph.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM AND TRUNC(SYSDATE) - 1 BETWEEN g_ph.B_DATE AND g_ph.e_date  )
AND ( ARTICLE_PM.ITEM_NUM(+)=KDW.DW_GOODS.ITEM_NUM  )
  AND  (
  KDW.DW_GOODS.STATE  =  1
    AND  KDW.DW_GOODS.SKL_OSN IN @Prompt('Склад-донор','A',,multi,free)
  )
And 
( KDW.DW_GOODS.DIV_CODE  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
AND  (KDW.DW_GOODS.IND_CATEGORY  IN  ('О', 'O', 'D', 'U', 'Т', 'T', 'L','W','Б')
      OR KDW.DW_GOODS.IND_CATEGORY = category_plus.category)
)
) artt1,
(
select
q.ITEM_NUM,
q.WHSE_CODE,
q.ART_GL,
q.item_ts,
q.MPA,
sum(q.m) over (partition by q.ART_GL, q.WHSE_CODE) as m,
max(q.k) over (partition by q.ART_GL, q.WHSE_CODE) as k,
max(q.g) over (partition by q.ART_GL, q.WHSE_CODE) as g,
min(q.ABC_vol) over (partition by q.ART_GL, q.WHSE_CODE) as ABC_vol,
min(q.ABC_cost) over (partition by q.ART_GL, q.WHSE_CODE) as ABC_cost,
min(q.ABC) over (partition by q.ART_GL, q.WHSE_CODE) as ABC
from
  (SELECT   
    zs_w.WHSE_CODE,
    zs.M,
    zs.G,
    zs.K,
    zs.ITEM_NUM,
    zs_i.ART_GL,
    zso.ABC_VOLUME || '(' || zso.ts_parent || ')' ABC_vol,
    zso.ABC_COST || '(' || zso.ts_parent || ')' ABC_cost,
    zso.ABC || '(' || zso.ts_parent || ')' ABC,
    zs_i.item_ts,
    zso.MPA  
  FROM
    KDW.DWF_ZGL_STAT  zs,
    KDW.DWD_ZGL_STAT_OTHER  zso,
    KDW.DWD_ITEM  zs_i,
    KDW.DWD_WHSE  zs_w
  WHERE
    ( zs.ID_ZGL_STAT_OTHER=zso.ID_ZGL_STAT_OTHER  )
    AND  ( zs.ID_ITEM=zs_i.ID_ITEM  )
    AND  ( zs.ID_WHSE=zs_w.ID_WHSE  )
    AND  (
    zs_i.STATE  =  1
    AND  zs_i.item_ts  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
    AND  ( zs.id_date = (SELECT kdw.getZGLDateID FROM dual )  )
    AND  zs_w.WHSE_CODE  =  @variable('Склад-получатель ВП')
    AND  zso.ts_parent  in  ('UTM', '0PF', '0ME')
    )) q
group by
q.ITEM_NUM,q.WHSE_CODE,q.ART_GL,q.item_ts,q.MPA,q.m,q.k,q.g,q.ABC_vol,q.ABC_cost,q.ABC
) mo,


(


select
   q1.item_num,
   q1.ART_GL,
   q1.WHSE_CODE,
   --sum(q1.mo) over (partition by q1.ART_GL, q1.WHSE_CODE) as mo,   
  -- sum(case when q2.mo>q1.mo then q2.mo else q1.mo end ) over (partition by q1.ART_GL, q1.WHSE_CODE) as moe,
    case when q2.mo>q1.mo then q2.mo else q1.mo end as mo
from
(



select
   zs.item_num,
   case when  zs.MOVE_DAYS < 50 then zs.MO_ALL else zs.MO end as MO,
   zs_i.ART_GL,
   zs_defw.WHSE_CODE
   from
   kdw.v_itn_stats zs,
   KDW.DWD_ITEM  zs_i,
   KDW.DWD_WHSE  zs_defw
   where
   zs.item_num=zs_i.item_num
   and zs_i.IS_CURRENT='Y'
   and zs.WHSE_CODE=zs_defw.GRP_COUNT
   AND zs_defw.WHSE_CODE =  @variable('Склад-получатель')
   AND  zs_i.item_ts  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
    AND zs_i.STATE  =  1
  --and zs.MOVE_DAYS >= 20
  

  
    ) q1,
  
  (



select
   zs_i.ART_GL,
   zs_defw.WHSE_CODE,
   sum (case when  zs.MOVE_DAYS < 50 then zs.MO_ALL else zs.MO end) as MO
   
   from
   kdw.v_itn_stats zs,
   KDW.DWD_ITEM  zs_i,
   KDW.DWD_WHSE  zs_defw
   where
   zs.item_num=zs_i.item_num
   and zs_i.IS_CURRENT='Y'
   and zs.WHSE_CODE=zs_defw.GRP_COUNT
   AND zs_defw.WHSE_CODE =  @variable('Склад-получатель')
   AND  zs_i.item_ts  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
    AND zs_i.STATE  =  1
  and zs.MOVE_DAYS >= 20
  
  group by 
   zs_i.ART_GL,
   zs_defw.WHSE_CODE
  
    ) q2
  
  
  
  
  
  
  
  
where 

q1.ART_GL=q2.ART_GL(+)
and q1.WHSE_CODE=q2.WHSE_CODE(+)



--and (q1.item_num='116616' /*or  q1.ART_GL='116616'*/  )



group by
q1.ITEM_NUM,q1.WHSE_CODE,q1.ART_GL,q1.mo,q2.mo
 

) mon,

(
SELECT   distinct
  mvw.PROD_MANAGER_NAME logist,
  mvw.VENDOR_NUM,
  mvw.VENDOR_NAME,
  mvw.STOCK_CONTROL,
  mvw.LEAD_TIME,
  mvw.garant_level,
  mvw.period_stock_a,
  mvw.period_stock_b,
  mvw.period_stock_c,
  NVL(mvw.quota,1) quota,
  mvw.ITEM_NUM
FROM
  KDW.DWE_MAIN_VEND_WHSE  mvw,
  KDW.DWD_WHSE  mvw_w,
  KDW.DWD_ITEM  mvw_i
WHERE
   ( mvw_i.ITEM_NUM = mvw.ITEM_NUM AND mvw_i.IS_CURRENT = 'Y'  )
  AND  ( mvw_w.ID_WHSE=mvw.ID_WHSE  )
  AND  ( mvw.VEND_WHSE_STATUS <> 'D'  )
 and mvw_w.GRP_COUNT in (@variable('Склад-получатель'))
 and mvw.actual_info = 'Y'
AND  (
  mvw.STOCK_CONTROL  IS NOT NULL  
  AND  mvw_i.STATE  =  1 
and mvw_i.item_ts in ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
and SKL_OSN IN @Prompt('Склад-донор','A',,multi,free)
  )
) vend
where artt1.item_num = artt.art
and artt1.item_num =  mo.item_num(+)
and artt1.item_num =  mon.item_num(+)
and artt1.item_num =  vend.item_num(+)
and zvp = 'N'
) items,
(
select
  ITEM_NUM, ART_GL,
  max(safe_stock) over (partition by ART_GL) as safe_stock,
  sum(on_hand) over (partition by ART_GL) as on_hand,
  sum(committed_qty) over (partition by ART_GL) as committed_qty,
  sum(cust_orders) over (partition by ART_GL) as cust_orders
  from
  (SELECT   
    R_ITEM.ITEM_NUM,
    R_ITEM.ART_GL,
    SUM(R_ITEM_W.SAFE_STOCK) safe_stock,
    SUM(( ITEM_R.ON_HAND )) on_hand,
    SUM(( ITEM_R.COMMITTED_QTY )) committed_qty,
    SUM(( ITEM_R.CUST_ORDERS )) - SUM((ITEM_R.MARKETING_QTY)) + SUM(( ITEM_R.TFER_OUT )) cust_orders
  FROM
    KDW.DWD_ITEM  R_ITEM,
    KDW.DWD_ITEM_W  R_ITEM_W,
    KDW.DWF_ITEM_R  ITEM_R,
    KDW.DWD_WHSE  R_WHSE,
	category_plus
  WHERE
    ( R_ITEM.ID_ITEM=ITEM_R.ID_ITEM  )
    AND  ( R_ITEM_W.ID_ITEM_W=ITEM_R.ID_ITEM_W  )
    AND  ( ITEM_R.ID_WHSE=R_WHSE.ID_WHSE  )
    AND  (
    ( ITEM_R.ID_DATE IN (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual)  )
    AND  ( (R_WHSE.WHSE_CODE IN @variable('Склад-получатель'))  )
   AND  R_ITEM.STATE  =  1
   and (R_ITEM.IND_CATEGORY  IN  ('О', 'O', 'D', 'U', 'Т', 'T', 'L','W','Б')
        OR R_ITEM.IND_CATEGORY = category_plus.category)
    AND  R_ITEM.ITEM_TS  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
    )
  GROUP BY
    R_ITEM.ITEM_NUM,
    R_ITEM.ART_GL)
) ost,
(
SELECT   
  KDW.DW_GOODS.ITEM_NUM,
  nvl(g_item_k1.VALUE*30, g_item_k2.VALUE) work_life
FROM
  KDW.DW_GOODS,
  KDW.DWD_DIVISION  goods_TS,
  KDW.DWE_BDT_MAIN_ITEM_PR  g_item_pr1,
  KDW.DWE_BDT_MAIN_ITEM_K_PR  g_item_k1,
  KDW.DWE_BDT_MAIN_ITEM_PR  g_item_pr2,
  KDW.DWE_BDT_MAIN_ITEM_K_PR  g_item_k2
WHERE
  ( goods_TS.DIV_CODE=KDW.DW_GOODS.DIV_CODE and goods_TS.DIV_TYPE=2  AND goods_TS.IS_CURRENT = 'Y'  )
  AND  ( g_item_k1.ITEM_NUM(+)  =KDW.DW_GOODS.ITEM_NUM AND g_item_k1.PR_NUM (+) = '4818'  )
  AND  ( g_item_k1.PR_NUM  =g_item_pr1.PR_NUM(+)  )
  AND  ( g_item_k2.ITEM_NUM(+)  =KDW.DW_GOODS.ITEM_NUM AND g_item_k2.PR_NUM (+) = '4800'  )
  AND  ( g_item_pr2.PR_NUM(+)  =g_item_k2.PR_NUM  )
  AND  (
  KDW.DW_GOODS.STATE  =  1
  AND  (g_item_k1.VALUE  IS NOT NULL  
  OR   g_item_k2.VALUE  IS NOT NULL  )
  )
) wl

where items.item_num = ost.item_num(+) 
and items.item_num = wl.item_num(+) 

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

  INNEr JOIN KDW.DWE_ARTICLE_PM  GL_ART_PM on  GL_ART_PM.ITEM_NUM=KDW.DW_GOODS.ART_GL,
  
  category_plus			   

WHERE

  KDW.DW_GOODS.STATE  =  1 

  AND  KDW.DW_GOODS.SKL_OSN IN @Prompt('Склад-донор','A',,multi,free)

And 

( KDW.DW_GOODS.DIV_CODE  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')

AND  (KDW.DW_GOODS.IND_CATEGORY  IN  ('О', 'O', 'D', 'U', 'Т', 'T', 'L','W','Б')
      OR KDW.DW_GOODS.IND_CATEGORY = category_plus.category)
)

) ig
where it.ITEM_NUM= ig.ITEM_NUM(+)

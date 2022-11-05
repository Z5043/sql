with ts_spis as
(select SET_VALUE ts from KDW.W_SET_VALUES where set_id=68642436), /*список ТС гаслп изменять под логином dev_scm*/
pzk as
(select
 p.item_num,
 max(case when p.PR_NUM = '4106' then p.VALUE else null end) tender_kernel,/*тендерное_ядро*/
 max(case when p.PR_NUM = '3655' then p.VALUE else null end) delivery_time,/*время_доставки*/
 max(case when p.PR_NUM = '3139' then p.VALUE else null end) delivery_terms,/*условия_доставки*/
 max(case when p.PR_NUM = '1646' then p.VALUE else null end) tst,/*технически сложный товар*/
 max(case when p.PR_NUM = '4512' then p.VALUE else null end) sea_bayer,/*байер юва*/
 nvl(30*max(case when p.PR_NUM = '4818' then p.VALUE else null end), max(case when p.PR_NUM = '4800' then p.VALUE else null end)) work_life,/*срок годности*/
 CASE 
  WHEN
   trunc(sysdate) BETWEEN max(dg.first_date)
    AND max(dg.first_date)+30*max(case when p.PR_NUM='4292' then NVL(DECODE(p.VALUE,'N/A',0,to_number(replace(p.VALUE, ',', '.'),'999999.999999')),0) else null end) THEN 'Н' 
  WHEN
   trunc(sysdate) BETWEEN max(dg.first_date)+30*max(case when p.PR_NUM='4292' then NVL(DECODE(p.VALUE,'N/A',0,to_number(replace(p.VALUE, ',', '.'),'999999.999999')),0) else null end)
    AND max(dg.first_date)
	+30*max(case when p.PR_NUM='4292' then NVL(DECODE(p.VALUE,'N/A',0,to_number(replace(p.VALUE, ',', '.'),'999999.999999')),0) else null end)
	+30*max(case when p.PR_NUM='4293' then NVL(DECODE(p.VALUE,'N/A',0,to_number(replace(p.VALUE, ',', '.'),'999999.999999')),0) else null end) THEN 'З' 
  WHEN
   trunc(sysdate) > max(dg.first_date)
    +30*max(case when p.PR_NUM='4292' then NVL(DECODE(p.VALUE,'N/A',0,to_number(replace(p.VALUE, ',', '.'),'999999.999999')),0) else null end)
    +30*max(case when p.PR_NUM='4293' then NVL(DECODE(p.VALUE,'N/A',0,to_number(replace(p.VALUE, ',', '.'),'999999.999999')),0) else null end) THEN 'С' 
  ELSE 'Н/Д'
 END glc,/*жизненный цикл товара*/
 max(case when p.PR_NUM = '6036' then p.VALUE else null end) ostrodeficit,
 max(case when p.PR_NUM = '7488' then p.VALUE else null end) byer_ord
from
 KDW.DWE_BDT_MAIN_ITEM_K_PR p, KDW.DW_GOODS dg
where
 p.ITEM_NUM=dg.ITEM_NUM
 and p.VALUE is not null
group by
 p.item_num),
hnm as 
 (select s.ITEM_NUM, max(s.MOVE_DAYS) MOVE_DAYS from kdw.DWF_ITN_STATS s, KDW.DWD_WHSE w, KDW.DWD_CALENDAR k
 where w.ID_WHSE=s.ID_WHSE and w.TERR_CODE='0' and k.ID_DATE=s.ID_STAT_DATE and k.CAL_DATE=trunc(sysdate-1, 'MM')
 group by s.ITEM_NUM)

SELECT   
  KDW.DW_GOODS.ITEM_NUM,
  R_ITEM.SGRP_NAME,
  KDW.DW_GOODS.ITEM_NAME название_артикула,
  KDW.DW_GOODS.DIV_CODE item_ts,
  KDW.DW_GOODS.SKL_OSN,
  s.ON_HAND+nvl(ctvp.cdtvp,0) on_hand,
  s.COMMITTED_QTY,
  KDW.DW_GOODS.IND_CATEGORY,
  R_ITEM.AVAIL_CALC_METHOD,  
  KDW.DW_GOODS.UNIT,
  nvl(tg.PROD_MANAGER_NAME,g.logist_name) PROD_MANAGER_NAME,
  nvl(tg.PROD_MANAGER,g.PROD_MANAGER) logist,
  nvl(tg.VENDOR_NUM,g.VENDOR_NUM) VENDOR_NUM,
  nvl(tg.VENDOR_NAME,g.VENDOR_NAME) VENDOR_NAME,
  g_oper.USER_NAME,
  KDW.DW_GOODS.VOLUME,
  nvl(tg.LEAD_TIME,g.LEAD_TIME) LEAD_TIME,
  nvl(tg.TIME_GARANT,g.TIME_GARANT) TIME_GARANT,
  g_ph.cross_docking,
  KDW.DW_GOODS.WEIGHT_GROSS,
  KDW.DW_GOODS.HSZ,
  pzk.delivery_time,
  pzk.delivery_terms,
  nvl(KDW.DW_GOODS.FIRST_DATE,  KDW.DW_GOODS.INS_DATE) first_date,
  ITEM_G1,
  g_item_g.DESC_1,
  w.terr_code terr_code_soh,
  nvl(tg.email, g.email) email,
  stat.M,
  stat.G,
  stat.V,
  stat.H,
  KDW.DW_GOODS.art_gl,
  stat.ABC0 abc,
  g_item_g.DESC_2,
  goods_TS.DIV_NAME,
  g.prod_name prod,
  pzk.glc,
  nvl(tg.STOCK_CONTROL,g.STOCK_CONTROL) STOCK_CONTROL,
  KDW.DW_GOODS.bayer,
  KDW.DW_GOODS.div_pack_qty,
  null max_lot,
  null analog,
  null analog1,
  null t,
  g_item_g.DESC_4 ass_grp,
  g_item_g.ITEM_G4 ass_code,
  pzk.tst,
  pzk.work_life,
  g_ph.ZCU_BNAL * DECODE(g_ph.CURR_CODE, 'Д',  (r_rate.reg_rate), (r_rate.inner_rate)) seb,
  round(g_ph.C_BNAL* DECODE(g_ph.CURR_CODE, 'Д',  r_rate.INNER_RATE, 1),2) zena,
  g_item_g.EDITION_TYPE_CODE,
  vz.vozvrat,
  ARTICLE_PM.PLACE_QNT,
  ARTICLE_PM.PALLET_QNT,
  ARTICLE_PM.LEVEL_COUNT,
  stats.MO mn,
  stats.MO_ALL MO_ALL,
  stats.var31_all dm,
  stats.VAR32_ALL dl,
  stats.VAR22 ds,
  g_item_g.DESC_3, /*название товарной группы*/
  g_item_g.ITEM_G3, /*код товарной группы*/
  stats.CCC3 CCC3,
  stats.CCC2 CCC2,
  stats.CCC1 CCC1,
  stats.IS_INFORM IS_INFORM,
  pzk.tender_kernel,
  pma.promoa_start,
  pma.promoa_end,
  pma.promoa_name,
  pzk.sea_bayer,
  stats.SEL_DAY_CNT_ALL SEL_DAY_CNT_ALL,
  pzk.ostrodeficit,
  nvl(KDW.DW_GOODS.P_NDS,0) P_NDS,
  hnm.MOVE_DAYS,
  pzk.byer_ord
FROM
  ts_spis,
  pzk,
  hnm,
  KDW.DW_GOODS,
  kdw.dwd_whse w,
  KDW.DWE_ITEM_G  g_item_g,
  KDW.DWD_U_OPER  g_oper,
  KDW.DW_PRICE_HISTORY  g_ph,
  kdw.dwd_usd_rate r_rate,
  KDW.DWD_DIVISION  goods_TS,
  KDW.DWE_ARTICLE_PM  ARTICLE_PM,
  (select
  ITEM_R.item_num,
  R_WHSE.WHSE_CODE,
  ITEM_R.ON_HAND,
  ITEM_R.COMMITTED_QTY
  from
  KDW.DWF_ITEM_R  ITEM_R,
  KDW.DWD_WHSE  R_WHSE
  where
  ITEM_R.ID_WHSE=R_WHSE.ID_WHSE
  and ( ITEM_R.ID_DATE = (SELECT kdw.getDateID(TRUNC(SYSDATE)) FROM dual)  )) s,
  (SELECT SUM(porl.CURRENT_REC_QTY) cdtvp,  porl.ITEM_NUM
  FROM  KDW.DWF_H_PO_R_L  porl,  KDW.DWD_WHSE  porl_w
  WHERE  porl.ID_CLOSED_DATE=(SELECT kdw.getDateID(trunc(sysdate)) FROM dual)
   AND  porl.ID_WHSE=porl_w.ID_WHSE and porl_w.CLP='Y' and porl_w.terr_code=0
  GROUP BY  porl.ITEM_NUM) ctvp,
  (SELECT   
  KDW.DW_GOODS.ITEM_NUM,
  g_item_g.PROD_MANAGER_NAME prod_name,
  G_MAIN_ITEM_V.PROD_MANAGER_NAME logist_name,
  G_MAIN_ITEM_V.LEAD_TIME,
  G_MAIN_ITEM_V.TIME_GARANT,
  G_MAIN_ITEM_V.VENDOR_NUM,
  G_MAIN_ITEM_V.VENDOR_NAME,
  G_MAIN_ITEM_V.STOCK_CONTROL,
  l_oper.email,
  G_MAIN_ITEM_V.PROD_MANAGER
  FROM
  KDW.DWE_ITEM_G  g_item_g,
  KDW.DWE_MAIN_ITEM_V  G_MAIN_ITEM_V,
  KDW.DW_GOODS,
  (select q.USER_CODE, q.email
   from
   (select USER_CODE, email, LAST_UPDATED,
    max(LAST_UPDATED) over (partition by USER_CODE) as n
    from KDW.DWD_U_OPER
    where email is not null and USER_CODE is not null
    group by
    USER_CODE, email, LAST_UPDATED) q
   where
   q.LAST_UPDATED=q.n)  l_oper
   WHERE
  ( g_item_g.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM  )
  AND ( KDW.DW_GOODS.ITEM_NUM=G_MAIN_ITEM_V.ITEM_NUM  )
  and G_MAIN_ITEM_V.PROD_MANAGER = l_oper.USER_CODE(+)) g,
   (SELECT   
   zs.ITEM_NUM,
   zs.M,
   zs.G,
   zs.V,
   zs.H,
   zso.ABC0
   FROM
   KDW.DWF_ZGL_STAT  zs,
   KDW.DWD_ZGL_STAT_OTHER  zso,
   KDW.DWD_WHSE  zs_w,
   KDW.DWD_WHSE  zs_defw,
   KDW.DWD_ITEM  zs_i
   WHERE
   ( zs.ID_ITEM=zs_i.ID_ITEM  )
   and (zso.ID_ZGL_STAT_OTHER=zs.ID_ZGL_STAT_OTHER)
   AND  ( zs.ID_WHSE=zs_w.ID_WHSE  )
   AND  ( zs_i.SKL_OSN=zs_defw.WHSE_CODE  )
   AND  ( zs_w.WHSE_CODE  =  zs_defw.GRP_COUNT
   AND  ( zs.id_date = (SELECT kdw.getZGLDateID FROM dual )))) stat,
   (select
   zs.item_num,
   max(zs.MO) MO,
   max(zs.MO_ALL) MO_ALL,
   max(zs.var31_all) var31_all,
   max(zs.VAR32_ALL) VAR32_ALL,
   max(zs.VAR22) VAR22,
   max(zs.CCC3) CCC3,
   max(zs.CCC2) CCC2,
   max(zs.CCC1) CCC1,
   max(zs.IS_INFORM) IS_INFORM,
   max(zs.SEL_DAY_CNT_ALL) SEL_DAY_CNT_ALL
   from
   kdw.v_itn_stats zs,
   KDW.DWD_WHSE  zs_defw
   where /*раньше была связка по группе складов сох или сох*/
   zs_defw.TERR_CODE='0'
   and zs.WHSE_CODE=zs_defw.WHSE_CODE
   group by zs.item_num) stats,
  KDW.DWD_ITEM  R_ITEM,
  (select
   w.item_num,
   w.VENDOR_NUM,
   w.VENDOR_NAME,
   gs.whse_code,
   w.STOCK_CONTROL,
   w.PROD_MANAGER_NAME,
   w.LEAD_TIME,
   w.TIME_GARANT,
   l_oper.email,
   w.PROD_MANAGER
  from
   kdw.dwe_main_vend_whse w,
   kdw.dwd_whse gs,
  (select q.USER_CODE, q.email
   from
   (select USER_CODE, email, LAST_UPDATED,
    max(LAST_UPDATED) over (partition by USER_CODE) as n
    from KDW.DWD_U_OPER
    where email is not null and USER_CODE is not null
    group by
    USER_CODE, email, LAST_UPDATED) q
   where
   q.LAST_UPDATED=q.n)  l_oper
  where
   w.whse_code=gs.GRP_COUNT
   and w.vend_whse_status='A'
   /*and w.actual_info='Y'*/
   and w.PROD_MANAGER=l_oper.USER_CODE(+)) tg,
 (SELECT
  vt.item_num, sum(vt.qty_ordered) vozvrat
 FROM
  kdw.dwe_whse_t_ilh_to vt, KDW.DWD_DIVISION_CUR dc, kdw.DWE_WHSE w
 where
  (vt.ORDER_DATE BETWEEN TRUNC(SYSDATE-365) AND  TRUNC(sysdate)) and vt.FROM_WHSE_CODE = '000' and vt.TRANS_status = 1 and w.whse_type=1 and dc.parent_div = '0LC'
  and dc.div_code = w.whse_code and vt.TO_WHSE_CODE = w.WHSE_CODE and w.terr_code=0
 group by
  vt.item_num) vz,
  (select
		pa.item_num item_num,
		pa.start_date promoa_start,
		pa.end_date promoa_end,
		pa.PROMOA_NAME promoa_name
	from
		(select
			p.item_num,
			max(p.item_promoa_id) mi
		from
			kdw.DWE_ITEM_PROMOA p
		where
			p.END_DATE > trunc(sysdate)
			and p.item_num!='N/A'
			and p.ACTION_TYPE=3
			and p.PROMOA_NAME not like 'Упак%'
			and p.PROMOA_NAME not like '%Упак%'
			and p.PROMOA_NAME not like '%упак%'
			and p.PROMOA_NAME not like 'Упак_'
			and p.PROMOA_NAME not like '_упак_'
			and p.PROMOA_NAME not like '_упак%'
		group by p.item_num) pp,
		kdw.DWE_ITEM_PROMOA pa
	where
		pa.item_promoa_id=pp.mi
		and pa.item_num=pp.item_num) pma
WHERE
  ( g_item_g.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM  )
  AND  ( goods_TS.DIV_CODE=KDW.DW_GOODS.DIV_CODE and goods_TS.DIV_TYPE=2  AND goods_TS.IS_CURRENT = 'Y'  )
  AND  ( KDW.DW_GOODS.ITEM_NUM=g.ITEM_NUM(+)  )
  AND  (KDW.DW_GOODS.ITEM_NUM=vz.ITEM_NUM(+))
  and   KDW.DW_GOODS.ITEM_NUM=ARTICLE_PM.ITEM_NUM(+)
  AND  ( g_ph.ITEM_NUM=KDW.DW_GOODS.ITEM_NUM AND TRUNC(SYSDATE) BETWEEN g_ph.B_DATE AND g_ph.e_date  )
  AND  ( g_oper.user_code(+)=KDW.DW_GOODS.bayer )
  and KDW.DW_GOODS.ITEM_NUM=R_ITEM.ITEM_NUM(+)
  and  ( KDW.DW_GOODS.item_num=stat.item_num (+) )
  and KDW.DW_GOODS.item_num=hnm.item_num (+)
  and  ( KDW.DW_GOODS.item_num=tg.item_num (+) )
  and  ( (case when KDW.DW_GOODS.skl_osn ='0D0' then '00D' else KDW.DW_GOODS.skl_osn end) = tg.whse_code (+) )
  AND  s.WHSE_CODE(+) =  KDW.DW_GOODS.SKL_OSN
  and  ( KDW.DW_GOODS.item_num=s.item_num (+) )  
  and (SELECT kdw.getDateID(TRUNC(SYSDATE)) FROM dual) BETWEEN R_ITEM.id_b_date AND R_ITEM.id_e_date
  AND  (KDW.DW_GOODS.STATE  =  1
  AND  KDW.DW_GOODS.DIV_CODE=ts_spis.ts)
  and KDW.DW_GOODS.SKL_OSN=w.whse_code
  and KDW.DW_GOODS.item_num=pzk.item_num(+)
  and r_rate.id_date=(SELECT kdw.getDateID(TRUNC(SYSDATE)) FROM dual)
  and ( KDW.DW_GOODS.item_num=stats.item_num (+) )
  and ( KDW.DW_GOODS.item_num=pma.item_num (+) )
  and ( KDW.DW_GOODS.item_num=ctvp.item_num (+) )
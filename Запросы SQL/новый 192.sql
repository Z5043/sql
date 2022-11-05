with
i
as
  (
   SELECT   
     R_CAL.yyyy_w,
     R_ITEM.sgrp_name,
     R_ITEM.short_name,
     R_ITEM.regcatalog,
     R_ITEM.ind_category,
     R_ITEM.item_num,
     R_ITEM.item_ts ts,
     R_ITEM.ITEM_TS_NAME ts_name,
    R_CAL.ID_DATE,
    g_main_item_v.vendor_num,
    g_main_item_v.vendor_name,
    g_main_item_v.prod_manager,
    g_main_item_v.prod_manager_name,
    g_item_g.item_g1,
    g_item_g.desc_1,
    g_item_g.item_g2,
    g_item_g.desc_2,
    g_item_g.item_g3,
    g_item_g.desc_3,
    g_item_g.item_g4,
    g_item_g.desc_4,
    g_item_g.item_g5,
    g_item_g.desc_5,
  --  R_item.avail_calc_method,
    g_item_g.BRAND_ID, 
    g_item_g.BRAND_NAME, 
    g_item_g.TRADE_MARK_ID, 
    g_item_g.TRADE_MARK_NAME,
    g_item_g.Prod_manager_NAME bayer, 
    r_cal.cal_date
  FROM
    KDW.DWD_ITEM  R_ITEM,
    KDW.DWD_CALENDAR  R_CAL,
    kdw.DWE_MAIN_VEND_WHSE g_main_item_v,
    kdw.dwe_item_g g_item_g
 WHERE
    ( r_cal.id_date BETWEEN R_ITEM.id_b_date AND R_ITEM.id_e_date  )
    and (g_main_item_v.item_num = R_ITEM.item_num)
       AND (R_ITEM.item_num = g_item_g.item_num)
and (g_main_item_v.vend_whse_status='A')
	   and (R_ITEM.SKL_OSN=g_main_item_v.WHSE_CODE(+) )
   AND  
    R_CAL.CAL_DATE BETWEEN TO_DATE(
 @Prompt('1. Дата начала периода','A',,mono,free)
            , 'DD.MM.YYYY')
             AND TO_DATE(
@Prompt('2. Дата окончания периода','A',,mono,free)
            , 'DD.MM.YYYY')
   AND  R_ITEM.IND_CATEGORY  in ('О', 'D')
   AND R_CAL.WORK_DAY=1
   AND   STATE = 1
   AND  (R_ITEM.item_ts in 
 ('Т100','Т32','Т35','Т33','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93','Т90','Т94','Т95','Т96','Т97','Т98','Т99','Т70', 'Т109', 'Т110', 'Т111', 'Т112', 'Т113', 'Т114', 'Т115')
   ) 
)
,
o as
(
  SELECT   
--/*+ INDEX(ITEM_R,i1_item_r_f) */    
    R_CAL.yyyy_w,
    R_ITEM.item_num,
    R_CAL.ID_DATE, 
    SUM(ITEM_R.ON_HAND) ost,
    SUM(ITEM_R.COMMITTED_QTY) videl,
    SUM(R_ITEM_W.Safe_stock) rz,
CASE WHEN SUM(ITEM_R.tfer_in)<0 THEN 0 ELSE SUM(ITEM_R.tfer_in) end as tfer_in,
    r_cal.work_day,
    max(NVL(R_item_w.avail_calc_method,0)) avail_calc_method
  FROM
    KDW.DWD_ITEM  R_ITEM,
    KDW.DWD_WHSE  R_WHSE,
    KDW.DWF_ITEM_R  ITEM_R,
    KDW.DWD_CALENDAR  R_CAL,
    kdw.dwd_item_w r_item_w
 WHERE
   ( ITEM_R.ID_DATE=R_CAL.ID_DATE  )
   AND  ( ITEM_R.ID_ITEM=R_ITEM.ID_ITEM )
   AND  ( ITEM_R.ID_WHSE=R_WHSE.ID_WHSE )
   and (r_item_w.id_item_w = item_r.id_item_w) 
   AND R_CAL.CAL_DATE BETWEEN TO_DATE(
@Prompt('1. Дата начала периода','A',,mono,free)
            , 'DD.MM.YYYY')
             AND TO_DATE(
 @Prompt('2. Дата окончания периода','A',,mono,free)
            , 'DD.MM.YYYY')
   AND  R_ITEM.IND_CATEGORY  in ('О', 'D')
   and R_WHSE.terr_code = '0' and r_whse.clp = 'Y'
   AND R_CAL.WORK_DAY=1
   AND  (R_ITEM.item_ts in 
 ('Т100','Т32','Т35','Т33','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93','Т90','Т94','Т95','Т96','Т97','Т98','Т99','Т70', 'Т109', 'Т110', 'Т111', 'Т112', 'Т113', 'Т114', 'Т115')
   ) 
   GROUP BY
   R_ITEM.item_num, 
   R_CAL.ID_DAte,
   r_cal.work_day,
   R_CAL.yyyy_w 
) ,
  VP_FIKTIV AS
  (
  SELECT
    KDW.DWE_OPEN_WHSE_T_L.OPEN_DATE - 1 AS OPEN_DATE_CORRECT,
    KDW.DWE_OPEN_WHSE_T_L.ITEM_NUM,
    KDW.DWE_OPEN_WHSE_T_L.QTY_ORDERED
  FROM
    KDW.DWE_OPEN_WHSE_T_L,
    KDW.DW_GOODS ow_g,
    KDW.DW_PRICE_HISTORY ow_ph,
    KDW.DWD_WHSE ow_fw,
    KDW.DWD_WHSE ow_tw
  WHERE
        ( KDW.DWE_OPEN_WHSE_T_L.FROM_WHSE_CODE = ow_fw.WHSE_CODE )
    AND ( KDW.DWE_OPEN_WHSE_T_L.TO_WHSE_CODE = ow_tw.WHSE_CODE )
    AND ( KDW.DWE_OPEN_WHSE_T_L.ITEM_NUM = ow_g.ITEM_NUM )
    AND ( KDW.DWE_OPEN_WHSE_T_L.ITEM_NUM = ow_ph.ITEM_NUM AND KDW.DWE_OPEN_WHSE_T_L.OPEN_DATE BETWEEN ow_ph.B_DATE AND ow_ph.E_DATE )
    AND ( KDW.DWE_OPEN_WHSE_T_L.OPEN_DATE BETWEEN (TO_DATE(@Prompt('1. Дата начала периода ','A',,mono,free), 'DD.MM.YYYY')+1)
                                              AND (TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')+1) )
    AND ( ow_ph.STATE = 1 )
    AND ( ow_fw.WHSE_CODE = '000' )
    AND ( ow_ph.DIV_CODE IN  ('Т32','Т35','Т33','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93','Т90','Т94','Т95','Т96','Т97','Т98','Т99','Т70','Т100','Т109', 'Т110', 'Т111', 'Т112', 'Т113', 'Т114', 'Т115') )
    AND ( ow_tw.terr_code = '0' and ow_tw.clp = 'Y'  )
),
Stat as
(   SELECT   
     s.item_num,
     sum(NVL(s.m, 0)) AS m,
     sum(NVL(s.f, 0)) AS f,
     sum(NVL(s.v, 0)) AS v
   FROM
     KDW.DWD_WHSE  R_WHSE,
     kdw.dwf_zgl_stat s
   WHERE
      s.id_whse = R_WHSE.id_whse 
     AND  R_WHSE. terr_code = '0' and r_whse.clp = 'Y' 
       AND s.id_date =(SELECT kdw.getZGLDateID(to_date(
       @Prompt('2. Дата окончания периода','A',,mono,free)
       ,'DD.MM.YYYY')) from dual)
        and s.N>5
   group by s.item_num
  ) ,
  a as
 (  SELECT i.ts, i.ts_name, i.item_num, i.sgrp_name, i.short_name, i.regcatalog, i.ind_category, o.id_date, o.work_day,
               NVL(m,0) m, NVL(f,0) f, NVL(v,0) v, 
               i.vendor_num, i.vendor_name,
               i.prod_manager, i.prod_manager_name, i.item_g1, i.desc_1, i.item_g2, i.desc_2, i.item_g3, i.desc_3,
               i.item_g4, i.desc_4, i.item_g5, i.desc_5,  i.bayer,
               CASE 
                 WHEN  o.avail_calc_method <> 5 THEN NVL(ost,0) - NVL(videl,0)
                 WHEN   o.avail_calc_method = 5 THEN NVL(ost,0) - NVL(videl,0) + NVL(VP_FIKTIV.QTY_ORDERED,0)
                ELSE 99999999 end ost,
BRAND_ID,  BRAND_NAME, TRADE_MARK_ID, TRADE_MARK_NAME, i.yyyy_w
  FROM
i,
o,
VP_FIKTIV,
stat
 WHERE i.item_num = o.item_num(+) and i.item_num = stat.item_num(+)
        and  i.id_date = o.id_date(+) and i.yyyy_w=o.yyyy_w(+) and
        i.item_num = VP_FIKTIV.item_num (+) and i.cal_date = VP_FIKTIV.OPEN_DATE_CORRECT(+)
 ), 
Top as
(
SELECT g.ITEM_NUM articul,
              '1_канцтов'  list_attr
FROM
  KDW.DW_GOODS g
WHERE
  ( g.ITEM_NUM IN (SELECT SET_VALUE FROM KDW.W_SET_VALUES WHERE set_id IN @Prompt('38. Список товаров','A',{'122115231'},multi,free)) )
UNION
SELECT
  g.ITEM_NUM  articul,
  '2_мебель'  list_attr
FROM
  KDW.DW_GOODS g
WHERE
  ( g.ITEM_NUM IN (SELECT SET_VALUE FROM KDW.W_SET_VALUES WHERE set_id IN @Prompt('39. Список товаров','A',{'53791673'},multi,free)) )
union
SELECT
  g.ITEM_NUM  articul,
  '3_ро_сиз'  list_attr
FROM
  KDW.DW_GOODS g
WHERE
  ( g.ITEM_NUM IN (SELECT SET_VALUE FROM KDW.W_SET_VALUES WHERE set_id IN @Prompt('40. Список товаров','A',{'122681456'},multi,free)) )
),
dd
as
(
SELECT SUM(work_day) wd, yyyy_w FROM   KDW.DWD_CALENDAR
           WHERE CAL_DATE BETWEEN TO_DATE(
 @Prompt('1. Дата начала периода','A',,mono,free)
            , 'DD.MM.YYYY')
             AND TO_DATE(
 @Prompt('2. Дата окончания периода','A',,mono,free)
            , 'DD.MM.YYYY')
group by yyyy_w
) 
SELECT item_num,ts, ts_name, sgrp_name, short_name, regcatalog, ind_category, m, f, v, arto,
             fo, vo, art_kr, f_krt, v_krt,
             vend, prod_manager,  prod_manager_name,
             item_g1, item_g2, item_g3, item_g4, item_g5, it,
             BRAND_ID,  BRAND_NAME, TRADE_MARK_ID, TRADE_MARK_NAME,
            yyyy_w, list_attr, 
            case when art_kr = 0 then 0 else 1 end arttt, bayer
from (
SELECT item_num,ts, ts_name, sgrp_name, short_name, regcatalog, ind_category, m, f, v, dd.wd arto,
             dd.wd*f fo, dd.wd*v vo,   
                      SUM((CASE WHEN ost < 0.5*m OR (ost=0 AND m=0) THEN 1
                                WHEN ost = 0.5*m THEN 0.5
                                WHEN ost > 0.5*m and ost <= 0.8*m then 0.2 
                           ELSE 0 END)) art_kr,
                      f*SUM(CASE WHEN ost < 0.5*m OR (ost=0 AND m=0) THEN 1
                                WHEN ost = 0.5*m THEN 0.5
                                WHEN ost > 0.5*m and ost <= 0.8*m then 0.2 
                           ELSE 0 END) f_krt,
                      v*SUM(CASE WHEN ost < 0.5*m OR (ost=0 AND m=0) THEN 1
                                WHEN ost = 0.5*m THEN 0.5
                                WHEN ost > 0.5*m and ost <= 0.8*m then 0.2 
                           ELSE 0 END) v_krt,
 vendor_num||' '||vendor_name vend, prod_manager,  prod_manager_name,
             item_g1||' '||desc_1 item_g1, item_g2||' '||desc_2 item_g2, item_g3||' '||desc_3 item_g3,
             item_g4||' '||desc_4 item_g4, item_g5||' '||desc_5 item_g5, item_num||' '||short_name it,
             BRAND_ID,  BRAND_NAME, TRADE_MARK_ID, TRADE_MARK_NAME,
            a.yyyy_w, bayer, top.list_attr
 FROM a, dd, top
where a.yyyy_w = dd.yyyy_w and
(prod_manager in (
@Prompt('6. Логист','A',{'все'},mono,free)
) or 'все' = 
@Prompt('6. Логист','A',{'все'},mono,free)
) and a.item_num = top.articul(+) 
GROUP BY item_num,ts, ts_name, sgrp_name, short_name, regcatalog, ind_category, 
m, f, v, dd.wd, dd.wd*f, dd.wd*v, vendor_num, vendor_name,
               prod_manager, prod_manager_name, item_g1, desc_1, item_g2, desc_2, item_g3, desc_3, item_g4, desc_4, item_g5, desc_5,
               BRAND_ID,  BRAND_NAME, TRADE_MARK_ID, TRADE_MARK_NAME, a.yyyy_w, bayer, top.list_attr
)
WHERE ts in (@Prompt('ТС','A',{'Т35','Т33','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93','Т90','Т94','Т95','Т96','Т97','Т98','Т99','Т70','Т32','Т100', 'Т109', 'Т110', 'Т111', 'Т112', 'Т113', 'Т114', 'Т115'},multi,free))

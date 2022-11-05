with ts_spis as
(select SET_VALUE ts from KDW.W_SET_VALUES where set_id=68642436), /*список ТС гаслп изменять под логином dev_scm*/
R_WHSE as
(select SET_VALUE WHSE_CODE from KDW.W_SET_VALUES where set_id=131009482),/*список складов ОРЛ изменять под логином dev_scm*/
cal as
(SELECT CAL_DNI.WORK_DAY, CAL_DNI.CAL_DATE, CAL_DNI.YYYY_W FROM KDW.DWD_CALENDAR CAL_DNI)

select a.region, a.dep, a.COMMITTED_QTY, a.com_vlm, a.cdate, b.ON_HAND, b.oh_vlm, cal.YYYY_W year_week
from
                (SELECT   
                  oo_w.TERR_CODE region, 1 dep, SUM(ol.COMMITTED_QTY * g.VOLUME /1000000) com_vlm, ol.OPEN_DATE cdate,
                  SUM(ol.COMMITTED_QTY * oo_ph.ZCU_BNAL * DECODE(oo_ph.CURR_CODE,'Д', cr.REG_RATE, cr.INNER_RATE)) COMMITTED_QTY
                FROM
                  KDW.DWD_WHSE  oo_w, KDW.DW_GOODS g, KDW.DWE_OPEN_ORD_L ol, KDW.DWE_CURR_RATE2 cr, KDW.DW_PRICE_HISTORY oo_ph,
                  ts_spis, R_WHSE
                WHERE
                  cr.CURR_CODE='USD' AND ol.ORDER_DATE=cr.RATE_DATE and ol.ITEM_NUM = g.ITEM_NUM
                  AND ol.WHSE_CODE=oo_w.WHSE_CODE AND ol.ITEM_NUM = oo_ph.ITEM_NUM and ol.ORDER_DATE BETWEEN oo_ph.B_DATE and oo_ph.E_DATE AND ol.OPEN_DATE=trunc(sysdate) AND ol.WHSE_CODE=R_WHSE.WHSE_CODE AND oo_ph.DIV_CODE=ts_spis.ts and ol.DIV_CODE = '0HQ'
                GROUP BY oo_w.TERR_CODE, ol.OPEN_DATE
                  union all
                SELECT   
                  oo_w.TERR_CODE region,  0 dep, SUM(ol.COMMITTED_QTY * g.VOLUME /1000000) com_vlm, ol.OPEN_DATE cdate,
                  SUM(ol.COMMITTED_QTY * oo_ph.ZCU_BNAL * DECODE(oo_ph.CURR_CODE,'Д',  cr.REG_RATE, cr.INNER_RATE)) COMMITTED_QTY
                FROM
                  KDW.DWD_WHSE  oo_w,  KDW.DW_GOODS g,  KDW.DWE_OPEN_ORD_L ol,  KDW.DWE_CURR_RATE2 cr,  KDW.DW_PRICE_HISTORY  oo_ph,
                  ts_spis, R_WHSE
                WHERE
                  cr.CURR_CODE='USD'  AND ol.ORDER_DATE=cr.RATE_DATE and ol.ITEM_NUM = g.ITEM_NUM
                  AND ol.WHSE_CODE=oo_w.WHSE_CODE AND ol.ITEM_NUM = oo_ph.ITEM_NUM and ol.ORDER_DATE BETWEEN oo_ph.B_DATE and oo_ph.E_DATE AND ol.OPEN_DATE=trunc(sysdate) AND ol.WHSE_CODE=R_WHSE.WHSE_CODE AND  oo_ph.DIV_CODE=ts_spis.ts
                GROUP BY oo_w.TERR_CODE, ol.OPEN_DATE) a,
                (select
                  skl.TERR_CODE, SUM(ITEM_R.ON_HAND*g.VOLUME/1000000) oh_vlm,
                  SUM(ITEM_R.ON_HAND*oo_ph.ZCU_BNAL * DECODE(oo_ph.CURR_CODE,'Д',  cr.REG_RATE, cr.INNER_RATE)) ON_HAND
                from
                  KDW.DWF_ITEM_R ITEM_R, KDW.DW_GOODS g, KDW.DWD_WHSE  skl, KDW.DWE_CURR_RATE2 cr, KDW.DW_PRICE_HISTORY  oo_ph,
                  ts_spis, R_WHSE
                where
                  ITEM_R.ID_WHSE=skl.ID_WHSE and cr.CURR_CODE='USD' AND  cr.RATE_DATE=trunc(sysdate) and ITEM_R.ITEM_NUM = g.ITEM_NUM
                  and ITEM_R.ID_DATE = (SELECT kdw.getDateID(trunc(sysdate)) FROM dual)  AND oo_ph.DIV_CODE=ts_spis.ts
                  and trunc(sysdate) BETWEEN oo_ph.B_DATE and oo_ph.E_DATE AND ITEM_R.ITEM_NUM = oo_ph.ITEM_NUM AND skl.WHSE_CODE=R_WHSE.WHSE_CODE
                GROUP BY skl.TERR_CODE) b,
                cal
where a.region=b.TERR_CODE and a.cdate=cal.CAL_DATE

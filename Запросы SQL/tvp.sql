with
reg_spis as
(select SET_VALUE reg from KDW.W_SET_VALUES where set_id=68733702), /*список регионов гаслп изменять под логином dev_scm*/ 
whs_spis as
(select j.terr_code reg, j.ID_WHSE, j.whse_code  from KDW.DWD_WHSE j,
 (select SET_VALUE from KDW.W_SET_VALUES where set_id=70917967) k
 where j.terr_code='0' and k.SET_VALUE=j.whse_code
		union all
	 select w.terr_code reg, w.ID_WHSE, w.whse_code from KDW.DWD_WHSE w, reg_spis
	  where w.terr_code!='0' and w.whse_type=1 and CLP='Y' and w.terr_code=reg_spis.reg)

select
reg REGION, ITEM_NUM, tvp qty, nvl(prih,trunc(sysdate+1)) date_r, 0 imp, sts, lev, proxima, spec_id, spec_l_id, ds spec_date
from
(select vp.*,
row_number () over (partition by vp.reg, vp.ITEM_NUM order by vp.ITEM_NUM, vp.prih) proxima
from
(SELECT/*блок заказов*/
  ws.reg, SPEC_ITEM.ITEM_NUM, max(nvl(SPEC_L.EXP_DATE,SPEC_CAL.CAL_DATE)) prih,
  case when sum(nvl(SPEC_L.IN_PO_QTY,0))>sum(nvl(Prih_L.QTY_ORDERED,0))
  then SUM(SPEC_L.REQ_QTY)- sum(nvl(SPEC_L.IN_PO_QTY,0))
  else SUM(SPEC_L.REQ_QTY)- sum(nvl(Prih_L.QTY_ORDERED,0))
  end tvp,
  '1' sts, SPEC_L.spec_id, SPEC_L.spec_l_id, min(sd.CAL_DATE) ds, 1 lev
FROM
  (select rr.item_num, /*rr.spec_id,*/ rr.spec_l_id_sp, sum(rr.QTY_ORDERED) QTY_ORDERED
	from KDW.DWF_PO_L rr, KDW.DWD_CALENDAR jj, KDW.DWD_PO_L_OTHER OTHER_PO_L
	where rr.ID_PO_DATE=jj.ID_DATE and jj.CAL_DATE > SYSDATE - 400
		AND OTHER_PO_L.ID_PO_L_OTHER = rr.ID_PO_L_OTHER AND OTHER_PO_L.PO_STATUS <= '6' /*and rr.ID_FACTUR_DATE=1*/
	group by rr.item_num, /*rr.spec_id,*/ rr.spec_l_id_sp) Prih_L,
  KDW.DWD_ITEM  SPEC_ITEM,
  KDW.DWF_SPEC_L  SPEC_L, KDW.DWD_SPEC_PO  SPEC_PO, KDW.DWD_CALENDAR  SPEC_CAL, KDW.DWD_SPEC_OTHER SPEC_OTHER, KDW.DWD_DIVISION  SPEC_L_DIV_WHSE,
  KDW.DWD_CALENDAR sd, whs_spis ws
WHERE
 SPEC_L.spec_l_id = Prih_L.spec_l_id_sp (+)
 and (SPEC_CAL.ID_DATE=SPEC_PO.ID_PERFORM_DATE)
 and SPEC_L.item_num=Prih_L.item_num (+) /*and SPEC_L.spec_id=Prih_L.spec_id (+)*/
 AND (SPEC_ITEM.ID_ITEM=SPEC_L.ID_ITEM) AND (SPEC_L.ID_SPEC_PO=SPEC_PO.ID_SPEC_PO) AND (SPEC_L.ID_SPEC_OTHER=SPEC_OTHER.ID_SPEC_OTHER)
 AND (SPEC_L.ID_SPEC_OTHER IN(SELECT id_spec_other FROM kdw.dwd_spec_other WHERE is_spec_line = 'Y'))
 AND (SPEC_L_DIV_WHSE.ID_DIV=SPEC_L.ID_DIV_WHSE) AND SPEC_OTHER.SHIP_FLAG='0' AND sd.CAL_DATE>sysdate-400
 AND SPEC_L_DIV_WHSE.DIV_CODE=ws.whse_code and SPEC_L.ID_SPEC_DATE=sd.ID_DATE and SPEC_OTHER.ship_flag_l!='2'
GROUP BY
  ws.reg, SPEC_ITEM.ITEM_NUM, SPEC_L.spec_id, SPEC_L.spec_l_id
having
  case when sum(nvl(SPEC_L.IN_PO_QTY,0))>sum(nvl(Prih_L.QTY_ORDERED,0))
  then SUM(SPEC_L.REQ_QTY)- sum(nvl(SPEC_L.IN_PO_QTY,0))
  else SUM(SPEC_L.REQ_QTY)- sum(nvl(Prih_L.QTY_ORDERED,0))
  end > 0
			union all
SELECT/*блок заданий на приход*/
  ws.reg, ITEM_PO_L.ITEM_NUM, PO_DATE_PO_L.CAL_DATE prih,
  SUM(PO_L.QTY_ORDERED)-sum(PO_L.QTY_RECEIVED) tvp,
  max(OTHER_PO_L.PO_STATUS) sts, PO_L.spec_id, PO_L.spec_l_id_sp spec_l_id, min(sd.CAL_DATE) ds, 4 lev
FROM
  KDW.DWD_ITEM ITEM_PO_L, KDW.DWD_CALENDAR PO_DATE_PO_L, KDW.DWF_PO_L PO_L,
  KDW.DWD_PO_L_OTHER OTHER_PO_L, whs_spis ws, KDW.DWD_CALENDAR sd
WHERE
 PO_L.ID_REQUEST_DATE=PO_DATE_PO_L.ID_DATE  AND OTHER_PO_L.ID_PO_L_OTHER=PO_L.ID_PO_L_OTHER AND ITEM_PO_L.ID_ITEM=PO_L.ID_ITEM
 AND PO_L.ID_WHSE=ws.ID_WHSE AND sd.CAL_DATE>sysdate-400 and PO_L.ID_PO_DATE=sd.ID_DATE
 AND OTHER_PO_L.PO_STATUS < '4'
GROUP BY
 ws.reg, ITEM_PO_L.ITEM_NUM, PO_L.spec_id, PO_L.spec_l_id_sp, PO_DATE_PO_L.CAL_DATE
having
 SUM(PO_L.QTY_ORDERED)-sum(PO_L.QTY_RECEIVED)>0) vp)
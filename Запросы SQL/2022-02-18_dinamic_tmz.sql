WITH d AS /*список логинов импортлогистов изменять под логином dev_scm*/
  (SELECT SET_VALUE 
     FROM KDW.W_SET_VALUES 
     WHERE set_id = 69197877
  )
, whs_spis AS
  (SELECT w.whse_code, w.ID_WHSE
     FROM KDW.DWD_WHSE w, KDW.DWD_DIVISION_CUR dc
     WHERE w.terr_code = '0'
       AND w.whse_type = 1
       AND dc.div_code = w.whse_code
       AND dc.parent_div = '0LC'
  )
, vp AS
  (   SELECT/*блок заказов*/

  SPEC_ITEM.ITEM_NUM,
  max(nvl(SPEC_L.EXP_DATE,SPEC_CAL.CAL_DATE)) prih,
  case when sum(nvl(SPEC_L.IN_PO_QTY,0))>sum(nvl(Prih_L.QTY_ORDERED,0))
  then SUM(SPEC_L.REQ_QTY)- sum(nvl(SPEC_L.IN_PO_QTY,0))
  else SUM(SPEC_L.REQ_QTY)- sum(nvl(Prih_L.QTY_ORDERED,0))
  end tvp,
  '1' sts, 
  SPEC_L.spec_id,
  min(sd.CAL_DATE) ds, 
  1 lev
FROM
  (select
  rr.item_num, /*rr.spec_id,*/ 
  rr.spec_l_id_sp, 
  sum(rr.QTY_ORDERED) QTY_ORDERED
	from 
	KDW.DWF_PO_L rr,
	KDW.DWD_CALENDAR jj,
	KDW.DWD_PO_L_OTHER OTHER_PO_L
	where 
	rr.ID_PO_DATE=jj.ID_DATE and jj.CAL_DATE > SYSDATE - 400
		AND OTHER_PO_L.ID_PO_L_OTHER = rr.ID_PO_L_OTHER AND OTHER_PO_L.PO_STATUS <= '6' /*and rr.ID_FACTUR_DATE=1*/
	group by rr.item_num, /*rr.spec_id,*/ rr.spec_l_id_sp) Prih_L,
  KDW.DWD_ITEM  SPEC_ITEM,
  KDW.DWF_SPEC_L  SPEC_L, KDW.DWD_SPEC_PO  SPEC_PO, KDW.DWD_CALENDAR  SPEC_CAL, KDW.DWD_SPEC_OTHER SPEC_OTHER, KDW.DWD_DIVISION  SPEC_L_DIV_WHSE,
  KDW.DWD_CALENDAR sd
WHERE
 SPEC_L.spec_l_id = Prih_L.spec_l_id_sp (+)
 and (SPEC_CAL.ID_DATE=SPEC_PO.ID_PERFORM_DATE)
 and SPEC_L.item_num=Prih_L.item_num (+) /*and SPEC_L.spec_id=Prih_L.spec_id (+)*/

 AND (SPEC_ITEM.ID_ITEM=SPEC_L.ID_ITEM) AND (SPEC_L.ID_SPEC_PO=SPEC_PO.ID_SPEC_PO) AND (SPEC_L.ID_SPEC_OTHER=SPEC_OTHER.ID_SPEC_OTHER)
 AND (SPEC_L.ID_SPEC_OTHER IN(SELECT id_spec_other FROM kdw.dwd_spec_other WHERE is_spec_line = 'Y'))
 AND (SPEC_L_DIV_WHSE.ID_DIV=SPEC_L.ID_DIV_WHSE) AND SPEC_OTHER.SHIP_FLAG='0' AND sd.CAL_DATE>sysdate-400
 and SPEC_L.ID_SPEC_DATE=sd.ID_DATE and SPEC_OTHER.ship_flag_l!='2'
GROUP BY
  SPEC_ITEM.ITEM_NUM, SPEC_L.spec_id, SPEC_L.spec_l_id
having
  case when sum(nvl(SPEC_L.IN_PO_QTY,0))>sum(nvl(Prih_L.QTY_ORDERED,0))
  then SUM(SPEC_L.REQ_QTY)- sum(nvl(SPEC_L.IN_PO_QTY,0))
  else SUM(SPEC_L.REQ_QTY)- sum(nvl(Prih_L.QTY_ORDERED,0))
  end > 0
    UNION ALL
    SELECT /*блок заданий на приход*/
            ITEM_PO_L.ITEM_NUM, PO_DATE_PO_L.CAL_DATE prih,
            SUM((PO_L.QTY_ORDERED)) - SUM((PO_L.QTY_RECEIVED)) tvp,
            MAX(OTHER_PO_L.PO_STATUS) sts, PO_L.spec_id,
            sd.CAL_DATE ds, 4 lev
      FROM KDW.DWD_ITEM ITEM_PO_L,
          KDW.DWD_CALENDAR PO_DATE_PO_L, KDW.DWF_PO_L PO_L,
          KDW.DWD_PO_L_OTHER OTHER_PO_L, whs_spis wh,
          KDW.DWD_CALENDAR sd
    WHERE (PO_L.ID_REQUEST_DATE = PO_DATE_PO_L.ID_DATE)
      AND (OTHER_PO_L.ID_PO_L_OTHER = PO_L.ID_PO_L_OTHER)
      AND (ITEM_PO_L.ID_ITEM = PO_L.ID_ITEM)
      AND (PO_L.ID_WHSE = wh.ID_WHSE)
      AND (PO_DATE_PO_L.CAL_DATE > SYSDATE - 90 
           AND OTHER_PO_L.PO_STATUS <= '4'
          )
      AND PO_L.ID_SPEC_DATE = sd.ID_DATE
    GROUP BY ITEM_PO_L.ITEM_NUM, PO_DATE_PO_L.CAL_DATE,
             PO_L.spec_id, sd.CAL_DATE
    HAVING SUM((PO_L.QTY_ORDERED)) - SUM((PO_L.QTY_RECEIVED)) > 0
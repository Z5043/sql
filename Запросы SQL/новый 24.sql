 WITH     vt_whse_code AS
    (
    SELECT
      mvw_w.ID_WHSE ID_Кода_склада,
      mvw_w.WHSE_CODE Код_склада,
      mvw_w.WHSE_GROUP Код_группы_склада,
      mvw_w.TERR_CODE Код_региона
    FROM
      KDW.DWD_WHSE mvw_w
    WHERE 
		mvw_w.TERR_CODE = 0
        AND mvw_w.CLP = 'Y'  
		AND mvw_w.WHSE_TYPE = '1'
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
	  mvw.VENDOR_ITEM Артикул_поставщика,
      mvw.quota МТП,
      mvw.SUPPLY_TYPE Форма_снабжения
	  
	from 
	    KDW.DWE_MAIN_VEND_WHSE mvw,
        KDW.DWE_MAIN_ITEM_V mvw_main_item_v,
        vt_whse_code
		
	where
      ( mvw.VEND_WHSE_STATUS <> 'D' )
      AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
      AND ( vt_whse_code.Код_группы_склада = mvw.WHSE_CODE )
	  AND  mvw.PROD_MANAGER in ('dnv64', 'kvp64', 'kta_su', 'pad64', 'sint15')
	),
 
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
	  mvw_goods.BATCH Кратность_упаковки,
	  mvw_goods.WEIGHT_NET Вес_нетто,
      
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
	  logist
 
    WHERE
          ( mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.DIV_TYPE = 2 AND mvw_goods_TS.IS_CURRENT = 'Y' )
      AND ( mvw_goods.ITEM_NUM = mvw_item_g.ITEM_NUM )
	  AND ( mvw_goods.ITEM_NUM = logist.Артикул )
      AND ( mvw_goods.bayer = mvw_g_oper.user_code(+) )
	
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
      SELECT *
      FROM
        KDW.DWF_ZGL_STAT zs JOIN KDW.DWD_WHSE  R_WHSE
                              ON ( zs.ID_WHSE = R_WHSE.ID_WHSE AND R_WHSE.WHSE_CODE = '05H')
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
	KDW.DWD_WHSE whse
 WHERE
	dis.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул
	AND whse.WHSE_CODE = dis.WHSE_CODE
	AND whse.TERR_CODE = '14' 
	AND whse.WHSE_TYPE  = '1'
  )
  ,
  
  vt_zapas as 
  
  (
    SELECT  
		ITEM_R.item_num Артикул,
		case  when sum(ITEM_R.ON_HAND) is null then 0 else sum(ITEM_R.ON_HAND) end  ТЗ_наличии,
		case  when sum(ITEM_R.COMMITTED_QTY) is null then 0 else sum(ITEM_R.COMMITTED_QTY) end Выделено
	FROM
		KDW.DWF_ITEM_R item_r,
		vt_whse_code,
		vt_catalog_tovara_kdw_other_16
	WHERE 
		ITEM_R.id_date = (SELECT kdw.getDateID(trunc(SYSDATE)) FROM dual )
		AND ITEM_R.item_num = vt_catalog_tovara_kdw_other_16.Артикул
		AND  ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
	GROUP BY 
		ITEM_R.item_num
  ),
  
  vt_rashod AS
  
  (
	SELECT   
	  M2C.YYYY_MM Год_месяц,
	  DIV_M2.ITEM_NUM Артикул,
	  SUM(( DIV_M2.KOLR_BAR + DIV_M2.KOLR_BNUL + DIV_M2.KOLR_NUL + DIV_M2.KOLR_PRO + DIV_M2.KOLR_SPIS + DIV_M2.KOLR_VNUT )) Общий_расход
	FROM
	  KDW.DWD_CALENDAR  M2C,
	  KDW.DWE_ITEM_DIV_M2 DIV_M2,
	  KDW.DW_GOODS  M2_GOODS,
	  KDW.DWD_WHSE R_WHSE,
	  vt_catalog_tovara_kdw_other_16
	WHERE
		( DIV_M2.ITEM_NUM=M2_GOODS.ITEM_NUM(+)  )
		AND  ( M2C.CAL_DATE=DIV_M2.TRANS_DATE  )
		AND  (
		( DIV_M2.TRANS_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')   AND  
		TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  ))
		AND  (DIV_M2.WHSE_CODE = R_WHSE.WHSE_CODE )
		AND  ( DIV_M2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
		AND  ( (DIV_M2.MOVE_TYPE IN(4,5,9) OR DIV_M2.CAUSE_CODE = '0060' AND DIV_M2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY'))  )
		AND  R_WHSE.TERR_CODE  =  '14'
		AND  R_WHSE.WHSE_TYPE  = '1'
	  
	GROUP BY
	  M2C.YYYY_MM, 
	  DIV_M2.ITEM_NUM
	
  ),
  
  vt_zapas_ural as (
  
   SELECT
		ITEM_R.item_num Артикул,
		case  when sum(ITEM_R.ON_HAND) is null then 0 else sum(ITEM_R.ON_HAND) end  ТЗ_наличии_Урал,
		case  when sum(ITEM_R.COMMITTED_QTY) is null then 0 else sum(ITEM_R.COMMITTED_QTY) end Выделено
	FROM
		KDW.DWF_ITEM_R item_r,
		KDW.DWD_WHSE  R_WHSE,
		vt_catalog_tovara_kdw_other_16
	WHERE 
		ITEM_R.id_date = (SELECT kdw.getDateID(trunc(SYSDATE)) FROM dual )
		AND ITEM_R.item_num = vt_catalog_tovara_kdw_other_16.Артикул
		AND ( R_WHSE.TERR_CODE  =  '14' AND  R_WHSE.WHSE_TYPE  = 1)
		AND  ( ITEM_R.ID_WHSE=R_WHSE.ID_WHSE  )
	GROUP BY 
		ITEM_R.item_num
	)
  ,
  whs_spis as
(select j.terr_code reg, j.ID_WHSE, j.whse_code  from KDW.DWD_WHSE j,
 (select SET_VALUE from KDW.W_SET_VALUES where set_id=70917967) k
 where j.terr_code='0' and k.SET_VALUE=j.whse_code
		union all
	 select w.terr_code reg, w.ID_WHSE, w.whse_code from KDW.DWD_WHSE w
	  where w.terr_code ='14' and w.whse_type=1 and CLP='Y'),
	  
vt_qty_ural as
(
select
reg REGION, ITEM_NUM Артикул, SUM(tvp) qty
from
(select vp.*
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
 SUM(PO_L.QTY_ORDERED)-sum(PO_L.QTY_RECEIVED)>0) vp) Where reg = '14' GROUP BY ITEM_NUM, reg ),
 
 vt_qty_msk as
 
 ( select
reg REGION, ITEM_NUM Артикул, SUM(tvp) qty
from
(select vp.*
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
 SUM(PO_L.QTY_ORDERED)-sum(PO_L.QTY_RECEIVED)>0) vp) Where reg = '0' GROUP BY ITEM_NUM, reg
 )
  
  
  
SELECT
    vt_catalog_tovara_kdw_other_16.Артикул,
    vt_catalog_tovara_kdw_other_16.Название_товара,
    vt_catalog_tovara_kdw_other_16.Признак_категория,
    vt_catalog_tovara_kdw_other_16.СОХ,
	vt_catalog_tovara_kdw_other_16.Кратность_упаковки,
	vt_catalog_tovara_kdw_other_16.Код_ТР,
	vt_catalog_tovara_kdw_other_16.Ед_изм,
	vt_catalog_tovara_kdw_other_16.Название_АГ,
	vt_catalog_tovara_kdw_other_16.Название_байера,
    vt_catalog_tovara_kdw_other_16.Название_КМ,
	vt_catalog_tovara_kdw_other_16.Объём_см3 / 1000000 Объём_м3,
	vt_catalog_tovara_kdw_other_16.Вес_нетто,
	vt_catalog_tovara_kdw_other_16.Название_байера,
    vt_catalog_tovara_kdw_other_16.Название_КМ,

	vt_abc.ABC_по_встречаемости,
	vt_abc.ABC_по_объёму,
	vt_abc.ABC_по_себ_руб,
	
	
    logist.Название_МЛ,
	logist.Артикул_поставщика,
	logist.Код_поставщика,
    logist.Код_факт_поставщика,
    logist.Название_факт_поставщика,
    logist.МТП,

	vt_mo.ССР_10,
	
	vt_zapas.ТЗ_наличии,
	vt_zapas.ТЗ_наличии - vt_zapas.Выделено Свободный_остаток,
	
	vt_zapas_ural.ТЗ_наличии_Урал,
	vt_zapas_ural.ТЗ_наличии_Урал - vt_zapas.Выделено Свободный_остаток_Урал,
	
	
	vt_qty_msk.qty ТВП_МСК,
	vt_qty_ural.qty ТВП_Урал,
	
	
	
	vt_rashod.Год_месяц,
	vt_rashod.Общий_расход
	
FROM
	vt_catalog_tovara_kdw_other_16,
	vt_abc,
	vt_mo,
	logist,
	vt_zapas,
	vt_rashod,
	vt_zapas_ural,
	vt_qty_msk,
	vt_qty_ural
WHERE
	( vt_catalog_tovara_kdw_other_16.Артикул = vt_abc.Артикул(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_mo.Артикул(+))
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = logist.Артикул(+))
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_zapas.Артикул(+))
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_rashod.Артикул(+))
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_zapas_ural.Артикул(+))
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_qty_msk.Артикул(+))
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_qty_ural.Артикул(+))
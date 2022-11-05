with
reg_spis as
(select SET_VALUE reg from KDW.W_SET_VALUES where set_id=68733702), /*список регионов гаслп изменять под логином dev_scm*/ 
whs_spis as
(select j.terr_code reg, j.ID_WHSE, j.whse_code  from KDW.DWD_WHSE j,
 (select SET_VALUE from KDW.W_SET_VALUES where set_id=70917967) k
 where j.terr_code='0' and k.SET_VALUE=j.whse_code),
 
     vt_whse_code AS
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
		AND mvw_w.WHSE_TYPE = '1'
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
      AND ( mvw_goods.bayer = mvw_g_oper.user_code(+) )
      AND  (  mvw_goods.STATE  =  1)
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
	vt_table as (
select
	reg REGION,
	ITEM_NUM Артикул,
	tvp qty,
	nvl(prih,trunc(sysdate+1)) date_r,
	0 imp,
	sts,
	lev,
	proxima,
	spec_id,
	spec_l_id,
	ds spec_date,
	order_num Номер_заказа_САП,
	SPEC_NUM Номер_специцикации,
	USER_CODE Код_МЛ,
	USER_NAME МЛ,
	VENDOR_NUM Код_поставщика,
	VEND_NAME Поставщик
from
(select vp.*,
row_number () over (partition by vp.reg, vp.ITEM_NUM order by vp.ITEM_NUM, vp.prih) proxima
from
(SELECT/*блок заказов*/
	  ws.reg,
	  SPEC_ITEM.ITEM_NUM ITEM_NUM,
	  max(nvl(SPEC_L.EXP_DATE,SPEC_CAL.CAL_DATE)) prih,
	  case when sum(nvl(SPEC_L.IN_PO_QTY,0))>sum(nvl(Prih_L.QTY_ORDERED,0))
	  then SUM(SPEC_L.REQ_QTY)- sum(nvl(SPEC_L.IN_PO_QTY,0))
	  else SUM(SPEC_L.REQ_QTY)- sum(nvl(Prih_L.QTY_ORDERED,0))
	  end tvp,
	  '1' sts, 
	  SPEC_L.spec_id spec_id,
	  SPEC_L.spec_l_id spec_l_id,
	  min(sd.CAL_DATE) ds,
	  1 lev,
	  SPEC_L.ORDER_NUM order_num,
	  SPEC_L.SPEC_NUM SPEC_NUM,
	  SPEC_U_OPER.USER_CODE USER_CODE,
	  SPEC_U_OPER.USER_NAME USER_NAME,
	  SPEC_SHIP_VEND.VENDOR_NUM VENDOR_NUM,
	  SPEC_SHIP_VEND.VEND_NAME VEND_NAME
FROM
  (select rr.item_num, /*rr.spec_id,*/ rr.spec_l_id_sp, sum(rr.QTY_ORDERED) QTY_ORDERED
	from KDW.DWF_PO_L rr, KDW.DWD_CALENDAR jj, KDW.DWD_PO_L_OTHER OTHER_PO_L
	where rr.ID_PO_DATE=jj.ID_DATE and jj.CAL_DATE > SYSDATE - 4
		AND OTHER_PO_L.ID_PO_L_OTHER = rr.ID_PO_L_OTHER AND OTHER_PO_L.PO_STATUS <= '6' /*and rr.ID_FACTUR_DATE=1*/
	group by rr.item_num, /*rr.spec_id,*/ rr.spec_l_id_sp) Prih_L,
	  KDW.DWD_ITEM  SPEC_ITEM,
	  KDW.DWF_SPEC_L  SPEC_L,
	  KDW.DWD_SPEC_PO  SPEC_PO,
	  KDW.DWD_CALENDAR  SPEC_CAL,
	  KDW.DWD_SPEC_OTHER SPEC_OTHER,
	  KDW.DWD_DIVISION  SPEC_L_DIV_WHSE,
	  KDW.DWD_CALENDAR sd,
	  KDW.DWD_U_OPER  SPEC_U_OPER,
	  KDW.DWD_VENDOR  SPEC_SHIP_VEND,
	  whs_spis ws
WHERE
	 SPEC_L.spec_l_id = Prih_L.spec_l_id_sp (+)
	 and (SPEC_CAL.ID_DATE=SPEC_PO.ID_PERFORM_DATE)
	 and SPEC_L.item_num=Prih_L.item_num (+) /*and SPEC_L.spec_id=Prih_L.spec_id (+)*/
	 AND (SPEC_ITEM.ID_ITEM=SPEC_L.ID_ITEM) 
	 AND (SPEC_L.ID_SPEC_PO=SPEC_PO.ID_SPEC_PO)
	 AND (SPEC_L.ID_SPEC_OTHER=SPEC_OTHER.ID_SPEC_OTHER)
	 AND (SPEC_L.ID_SPEC_OTHER IN(SELECT id_spec_other FROM kdw.dwd_spec_other WHERE is_spec_line = 'Y'))
	 AND (SPEC_L_DIV_WHSE.ID_DIV=SPEC_L.ID_DIV_WHSE)
	 AND SPEC_OTHER.SHIP_FLAG='0'
	 AND sd.CAL_DATE>sysdate-4
	 AND SPEC_L_DIV_WHSE.DIV_CODE=ws.whse_code 
	 and SPEC_L.ID_SPEC_DATE=sd.ID_DATE 
	 and SPEC_OTHER.ship_flag_l!='2'
	 AND  ( SPEC_L.ID_USER=SPEC_U_OPER.ID_U_OPER  )
	 AND  ( SPEC_SHIP_VEND.ID_VENDOR=SPEC_L.ID_SHIP_VENDOR  )
GROUP BY
	ws.reg,
	SPEC_ITEM.ITEM_NUM, 
	SPEC_L.spec_id,
	SPEC_L.spec_l_id, 
	SPEC_L.ORDER_NUM,
	SPEC_L.SPEC_NUM,
	SPEC_U_OPER.USER_CODE,
	SPEC_U_OPER.USER_NAME,
	SPEC_SHIP_VEND.VENDOR_NUM,
	SPEC_SHIP_VEND.VEND_NAME
having
	  case when sum(nvl(SPEC_L.IN_PO_QTY,0))>sum(nvl(Prih_L.QTY_ORDERED,0))
	  then SUM(SPEC_L.REQ_QTY)- sum(nvl(SPEC_L.IN_PO_QTY,0))
	  else SUM(SPEC_L.REQ_QTY)- sum(nvl(Prih_L.QTY_ORDERED,0))
	  end > 0
	  
			union all
			
SELECT/*блок заданий на приход*/
	  ws.reg, 
	  ITEM_PO_L.ITEM_NUM,
	  PO_DATE_PO_L.CAL_DATE prih,
	  SUM(PO_L.QTY_ORDERED)-sum(PO_L.QTY_RECEIVED) tvp,
	  max(OTHER_PO_L.PO_STATUS) sts, 
	  PO_L.spec_id,
	  PO_L.spec_l_id_sp spec_l_id,
	  min(sd.CAL_DATE) ds, 
	  4 lev,
	  '0' order_num,
	  '0' SPEC_NUM,
	  '0' USER_CODE,
	  '0' USER_NAME,
	  '0' VENDOR_NUM,
	  '0' VEND_NAME
FROM
	  KDW.DWD_ITEM ITEM_PO_L,
	  KDW.DWD_CALENDAR PO_DATE_PO_L,
	  KDW.DWF_PO_L PO_L,
	  KDW.DWD_PO_L_OTHER OTHER_PO_L,
	  whs_spis ws,
	  KDW.DWD_CALENDAR sd
WHERE
	 PO_L.ID_REQUEST_DATE=PO_DATE_PO_L.ID_DATE 
	 AND OTHER_PO_L.ID_PO_L_OTHER=PO_L.ID_PO_L_OTHER 
	 AND ITEM_PO_L.ID_ITEM=PO_L.ID_ITEM
	 AND PO_L.ID_WHSE=ws.ID_WHSE 
	 AND sd.CAL_DATE>sysdate-4 
	 and PO_L.ID_PO_DATE=sd.ID_DATE
	 AND OTHER_PO_L.PO_STATUS < '4'
GROUP BY
	 ws.reg, 
	 ITEM_PO_L.ITEM_NUM,
	 PO_L.spec_id, 
	 PO_L.spec_l_id_sp, 
	 PO_DATE_PO_L.CAL_DATE
having
	SUM(PO_L.QTY_ORDERED)-sum(PO_L.QTY_RECEIVED)>0) vp) )
	
	SELECT
	vt_table.*,
	
	vt_catalog_tovara_kdw_other_16.Признак_категория,
	
	logist.Код_МЛ,
	logist.Название_МЛ
	FROM 
		vt_table,
		vt_catalog_tovara_kdw_other_16,
		logist
	
	WHERE 
		vt_table.Артикул = vt_catalog_tovara_kdw_other_16.Артикул(+)
		AND vt_table.Артикул = logist.Артикул(+)


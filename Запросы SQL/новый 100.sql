select *
From 
(SELECT 
 ol_w.WHSE_CODE as Склад_заказа,
 ol_i.skl_osn as  СОХ,
 ol.ORDER_NUM as  N_Зак_ВП,
 oj.DIV_CODE as  Отдел,
 ol.ITEM_NUM as  Товар,
 ol_i.IND_CATEGORY as  К,
 ol_i.ITEM_NAME as  Наименование,
 ol.SHIPPED_QTY as  Выписано,
 ol.COMMITTED_QTY as  Выделено,
 oj.NEW_STAT as  С,
 oj.NEW_STAT_NAME as  Статус,
 op.USER_CODE as  Менеджер,
 op.USER_NAME as  ФИО_Менеджера,
 oj.REQUEST_DATE as  Поставка,
 ol.ID_ORDER_DATE as Дата
FROM
  KDW.DWF_ORD_L  ol,
  KDW.DWD_WHSE  ol_w,
  KDW.DWD_ITEM  ol_i,
  KDW.DWF_ORD_L_CD_J  oj,
  KDW.DWD_U_OPER op
WHERE 
		( ol.ITEM_NUM IN (select SET_VALUE from KDW.W_SET_VALUES where set_id=@Variable('3. Список товаров'))  )
	AND	( ol.ID_WHSE=ol_w.ID_WHSE )
	AND ( op.ID_U_OPER(+)=ol.ID_USER_CREATED )
	AND ( ol.ID_ITEM=ol_i.ID_ITEM  )
	AND ( oj.ORD_L_ID(+)=ol.ORD_L_ID )
	AND (oj.NEW_STAT=1 OR oj.NEW_STAT=2 )
	AND ( ol.ID_ORDER_DATE BETWEEN (SELECT kdw.getDateID(TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual) AND  (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual )  ) 
	AND ( ol_w.CLP  =  'Y' )
	AND ( ol_w.terr_code  = '0' )
	) t1
	LEFT JOIN 
(SELECT
  mvw.STOCK_CONTROL + mvw.LEAD_TIME as  Дн,
  mvw_main_item_v.VENDOR_NUM as  Код_пост,
  mvw_main_item_v.VENDOR_NAME as  Наименование_поставщика,
  DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NAME, mvw.VEND_PARENT_NAME) as  Наименование_грузоотправителя,
  DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NUM, mvw.VEND_PARENT_NUM) as  Код_груз,
  mvw.ITEM_NUM as Артикул
FROM
  KDW.DWE_MAIN_VEND_WHSE  mvw,
  KDW.DWE_MAIN_ITEM_V  mvw_main_item_v,
  KDW.DW_GOODS g
WHERE
  ( mvw.ITEM_NUM IN (select SET_VALUE from KDW.W_SET_VALUES where set_id=@Variable('3. Список товаров'))  )
  AND 	( mvw.VEND_WHSE_STATUS <> 'D' )
  AND   ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
  AND   ( mvw.whse_code=g.skl_osn )
 
  ) t2
  LEFT JOIN
  (SELECT  
  DWD_ITEM_CAL.item_num as Артикул,
  DWD_ITEM_CAL.cross_docking as ИП,
  wls.MIP as МИП
FROM
  KDW.DWD_ITEM_CAL  DWD_ITEM_CAL,
  KDW.DWF_ITEM_WLS  wls,
  KDW.DWD_WHSE  wls_whse,
  KDW.DWD_CALENDAR  CAL_DNI19
WHERE
	   ( DWD_ITEM_CAL.item_num IN (select SET_VALUE from KDW.W_SET_VALUES where set_id=@Variable('3. Список товаров'))  )
  AND  ( wls.WHSE_CODE=wls_whse.WHSE_CODE  )
  AND  ( DWD_ITEM_CAL.ITEM_NUM=wls.ITEM_NUM(+) )
  AND  ( DWD_ITEM_CAL.ID_DATE between wls.ID_B_DATE(+) 
								  and wls.ID_E_DATE(+) )
  AND  ( CAL_DNI19.ID_DATE=DWD_ITEM_CAL.ID_DATE  )
  AND  ( CAL_DNI19.CAL_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')  AND  TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
  AND  ( wls.WHSE_CODE  =  DWD_ITEM_CAL.SKL_OSN )
  AND  ( wls_whse.CLP  =  'Y' )
  AND  ( wls_whse.terr_code  = '0' )
  ) t3 ON t1.Товар=t3.Артикул=t2=Артикул
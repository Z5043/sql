WITH 
count_day_vt_table as (
	SELECT   
	  count(case when CAL_DNI.CAL_DATE BETWEEN  
	TO_DATE(@Prompt( '1. Дата начала периода' , 'A',,mono, free) , 'DD.MM.YYYY') AND 
	TO_DATE(@Prompt( '2. Дата окончания периода' , 'A',,mono, free) , 'DD.MM.YYYY') then  CAL_DNI.ID_DATE else to_number(NULL) end) count_day,
	  CAL_DNI.YYYY_MM
	FROM
	  KDW.DWD_CALENDAR  CAL_DNI
	WHERE 
		CAL_DNI.CAL_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')  AND  TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  
	GROUP BY
	  CAL_DNI.YYYY_MM
)
,
pob_ostatok_vt_table as (
	SELECT   
	  TO_CHAR(pob.MONTH_DATE, 'YYYY_MM') Год_месяц,
	  SUM(CASE WHEN pob.row_type = 1 AND pob.move_type = 0 THEN pob.cost_amt*pob_rate.CB_RATE ELSE 0 END) Средний_ост_руб,
	  w_pob.TERR_CODE Код_территории,
	  w_pob.terr_name Название_территории,
	  SUM(CASE WHEN pob.row_type = 1 AND pob.move_type = 0 THEN pob.NUM_QTY ELSE 0 END * ( ph_dz_pob.VOLUME )) Средний_обьем,
	  SUM(ph_d_pob.VOLUME) Обьем,
	  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', iv_pob.VENDOR_NAME, vw_pob.VENDOR_NAME) Название_поставщика,
	  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', iv_pob.VENDOR_NUM, vw_pob.VENDOR_NUM) Код_поставщика,
	  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', iv_pob.PROD_MANAGER_NAME, vw_pob.PROD_MANAGER_NAME) МЛ,
	  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', iv_pob.PROD_MANAGER, vw_pob.PROD_MANAGER) Код_МЛ
	FROM
	  KDW.DWE_ITEM_R_AVG  pob,
	  KDW.DWE_CURR_RATE2  pob_rate,
	  KDW.DWD_WHSE  w_pob,
	  KDW.DW_PRICE_HISTORY  ph_dz_pob,
	  KDW.DW_GOODS  goods_pob,
	  KDW.DW_PRICE_HISTORY  ph_d_pob,
	  KDW.DWE_MAIN_ITEM_V  iv_pob,
	  KDW.DWE_MAIN_VEND_WHSE  vw_pob,
	  KDW.DW_PRICE_HISTORY  ph_pob,
	  KDW.DWD_DIVISION  HISTORY_TS2
	WHERE
	  ( pob_rate.CURR_CODE = 'USD'  )
	  AND  ( pob.ITEM_NUM=goods_pob.ITEM_NUM  )
	  AND  ( ph_pob.ITEM_NUM = pob.ITEM_NUM and pob.CALC_DATE between ph_pob.B_DATE and ph_pob.E_DATE  )
	  AND  ( pob_rate.RATE_DATE = DECODE(pob.MONTH_DATE, TRUNC(SYSDATE, 'MM'), TRUNC(SYSDATE),  LAST_DAY(pob.MONTH_DATE))  )
	  AND  ( pob.ITEM_NUM=iv_pob.ITEM_NUM  )
	  AND  ( pob.WHSE_CODE=w_pob.WHSE_CODE  )
	  AND  ( pob.ITEM_NUM = vw_pob.ITEM_NUM (+) and pob.WHSE_CODE = vw_pob.WHSE_CODE (+)  )
	  AND  ( pob.ITEM_NUM=ph_d_pob.ITEM_NUM(+)  AND 
	TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY') BETWEEN
	ph_d_pob.B_DATE(+) AND ph_d_pob.E_DATE(+)  )
	  AND  ( pob.ITEM_NUM=ph_dz_pob.ITEM_NUM(+)  AND 
	TO_DATE(@Prompt('3. Дата информации о товаре','A',,mono,free), 'DD.MM.YYYY')  BETWEEN
	ph_dz_pob.B_DATE(+) AND ph_dz_pob.E_DATE(+)  )
	  AND  ph_pob.STATE  =  1
	  AND  ( pob.MONTH_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY') AND TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
	  AND ( HISTORY_TS2.div_type=2  
	  AND HISTORY_TS2.IS_CURRENT = 'Y'  )
	  AND  HISTORY_TS2.CLP_TS  =  'Y'
	  AND  ph_dz_pob.DIV_CODE = HISTORY_TS2.DIV_CODE
	  AND  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', TO_NUMBER(NULL), vw_pob.SUPPLY_TYPE)  IN  (1, 2, 3)
	  AND  w_pob.TERR_CODE  !=  '0'
	  AND  w_pob.CLP  =  'Y'
	GROUP BY
	  TO_CHAR(pob.MONTH_DATE, 'YYYY_MM'), 
	  w_pob.TERR_CODE, 
	  w_pob.terr_name,
	  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', iv_pob.VENDOR_NAME, vw_pob.VENDOR_NAME), 
	  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', iv_pob.VENDOR_NUM, vw_pob.VENDOR_NUM), 
	  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', iv_pob.PROD_MANAGER_NAME, vw_pob.PROD_MANAGER_NAME), 
	  DECODE(NVL(vw_pob.vend_whse_status, 'D'), 'D', iv_pob.PROD_MANAGER, vw_pob.PROD_MANAGER)
)
,
rashod_cs_region as (
	SELECT   
		M2C.YYYY_MM Год_месяц,
		SUM(( case when ( KDW.DWE_ITEM_DIV_M2.MOVE_TYPE )  IN(2, 4, 5, 7, 9, 10) then -KDW.DWE_ITEM_DIV_M2.cost_amt*( M2_CURR_RATE_2.REG_RATE ) else 0 end)) Общий_расход,
		M2_WHSE.TERR_CODE Код_территории,
		SUM(( (KDW.DWE_ITEM_DIV_M2.KOLR_BAR + KDW.DWE_ITEM_DIV_M2.KOLR_BNUL + KDW.DWE_ITEM_DIV_M2.KOLR_NUL + KDW.DWE_ITEM_DIV_M2.KOLR_PRO + KDW.DWE_ITEM_DIV_M2.KOLR_SPIS + KDW.DWE_ITEM_DIV_M2.KOLR_VNUT) * ( M2_PH.VOLUME ) )) Общий_расход_обьем,
		SUM(( (KDW.DWE_ITEM_DIV_M2.KOLR_BAR + KDW.DWE_ITEM_DIV_M2.KOLR_BNUL + KDW.DWE_ITEM_DIV_M2.KOLR_NUL + KDW.DWE_ITEM_DIV_M2.KOLR_PRO + KDW.DWE_ITEM_DIV_M2.KOLR_SPIS + KDW.DWE_ITEM_DIV_M2.KOLR_VNUT) * ( M2_PH_DZ.VOLUME ) )) Общий_расход_обьем_дата,
		DECODE(NVL(m2_MVW.vend_whse_status, 'D'),'D', m2_MIV.VENDOR_NUM, m2_MVW.VENDOR_NUM) Код_поставщика
	FROM
	  KDW.DWD_CALENDAR  M2C,
	  KDW.DWE_ITEM_DIV_M2,
	  KDW.DWE_CURR_RATE2  M2_CURR_RATE_2,
	  KDW.DWD_WHSE  M2_WHSE,
	  KDW.DW_PRICE_HISTORY  M2_PH_DZ,
	  KDW.DW_PRICE_HISTORY  M2_PH,
	  KDW.DWD_DIVISION  HISTORY_TS2,
	  KDW.DWE_MAIN_ITEM_V  m2_MIV,
	  KDW.DWE_MAIN_VEND_WHSE  m2_MVW
	WHERE
	  ( M2_CURR_RATE_2.CURR_CODE='USD'  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.TRANS_DATE=M2_CURR_RATE_2.RATE_DATE  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.ITEM_NUM=M2_PH.ITEM_NUM and KDW.DWE_ITEM_DIV_M2.ITEM_DATE=M2_PH.B_DATE  )
	  AND  ( M2C.CAL_DATE=KDW.DWE_ITEM_DIV_M2.TRANS_DATE  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.ITEM_NUM=m2_MIV.ITEM_NUM  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.ITEM_NUM=m2_MVW.ITEM_NUM(+) and KDW.DWE_ITEM_DIV_M2.WHSE_CODE=m2_MVW.WHSE_CODE(+)  )
	  AND  ( M2_PH_DZ.ITEM_NUM(+)= KDW.DWE_ITEM_DIV_M2.ITEM_NUM  AND 
		TO_DATE(@Prompt('3. Дата информации о товаре','A',,mono,free), 'DD.MM.YYYY') 
		BETWEEN M2_PH_DZ.B_DATE(+) AND M2_PH_DZ.E_DATE(+)  )
		AND  ( HISTORY_TS2.DIV_CODE = M2_PH_DZ.DIV_CODE  )
		  AND ( HISTORY_TS2.div_type=2  
		  AND HISTORY_TS2.IS_CURRENT = 'Y'  )
		  AND  HISTORY_TS2.CLP_TS  =  'Y'
	  AND  ( M2_WHSE.WHSE_CODE=KDW.DWE_ITEM_DIV_M2.WHSE_CODE  )
	  AND  (
	  M2_WHSE.TERR_CODE != '0'
	  AND  M2_WHSE.CLP  =  'Y'
	  AND  M2_PH.STATE  =  1
	  AND  ( KDW.DWE_ITEM_DIV_M2.TRANS_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')   AND  
		TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
	  AND  ( (KDW.DWE_ITEM_DIV_M2.MOVE_TYPE IN(4,5,9) OR KDW.DWE_ITEM_DIV_M2.CAUSE_CODE = '0060' AND KDW.DWE_ITEM_DIV_M2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY'))  )
	  AND  case when ( KDW.DWE_ITEM_DIV_M2.MOVE_TYPE )  IN(2, 4, 5, 7, 9, 10) then -KDW.DWE_ITEM_DIV_M2.cost_amt*( M2_CURR_RATE_2.REG_RATE ) else 0 end
	  >  0
	  )
	GROUP BY
	  M2C.YYYY_MM, 
	  M2_WHSE.TERR_CODE,
	  DECODE(NVL(m2_MVW.vend_whse_status, 'D'),'D', m2_MIV.VENDOR_NUM, m2_MVW.VENDOR_NUM)
)
,
rashod_diler as (
	SELECT   
	  M2C.YYYY_MM Год_месяц,
	  SUM(( case when ( KDW.DWE_ITEM_DIV_M2.MOVE_TYPE )  IN(2, 4, 5, 7, 9, 10) then -KDW.DWE_ITEM_DIV_M2.cost_amt*( M2_CURR_RATE_2.REG_RATE ) else 0 end)) Общий_расход,
	  M2_WHSE.TERR_CODE,
	  SUM(( (KDW.DWE_ITEM_DIV_M2.KOLR_BAR + KDW.DWE_ITEM_DIV_M2.KOLR_BNUL + KDW.DWE_ITEM_DIV_M2.KOLR_NUL + KDW.DWE_ITEM_DIV_M2.KOLR_PRO + KDW.DWE_ITEM_DIV_M2.KOLR_SPIS + KDW.DWE_ITEM_DIV_M2.KOLR_VNUT) * ( M2_PH.VOLUME ) )) Общий_расход_обьем,
	  SUM(( (KDW.DWE_ITEM_DIV_M2.KOLR_BAR + KDW.DWE_ITEM_DIV_M2.KOLR_BNUL + KDW.DWE_ITEM_DIV_M2.KOLR_NUL + KDW.DWE_ITEM_DIV_M2.KOLR_PRO + KDW.DWE_ITEM_DIV_M2.KOLR_SPIS + KDW.DWE_ITEM_DIV_M2.KOLR_VNUT) * ( M2_PH_DZ.VOLUME ) )) Общий_расход_обьем_дата,
		DECODE(NVL(m2_MVW.vend_whse_status, 'D'),'D', m2_MIV.VENDOR_NUM, m2_MVW.VENDOR_NUM) Код_поставщика
	FROM
	  KDW.DWD_CALENDAR  M2C,
	  KDW.DWE_ITEM_DIV_M2,
	  KDW.DWE_CURR_RATE2  M2_CURR_RATE_2,
	  KDW.DWD_WHSE  M2_WHSE,
	  KDW.DW_PRICE_HISTORY  M2_PH_DZ,
	  KDW.DW_PRICE_HISTORY  M2_PH,
	  KDW.DWE_WHSE  WHSE_CUST,
	  KDW.DWD_DIVISION  HISTORY_TS2,
	  KDW.DWE_MAIN_ITEM_V  m2_MIV,
	  KDW.DWE_MAIN_VEND_WHSE  m2_MVW
	WHERE
	  ( M2_CURR_RATE_2.CURR_CODE='USD'  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.TRANS_DATE=M2_CURR_RATE_2.RATE_DATE  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.ITEM_NUM=M2_PH.ITEM_NUM and KDW.DWE_ITEM_DIV_M2.ITEM_DATE=M2_PH.B_DATE  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.CUST_NUM=WHSE_CUST.WHSE_CODE(+)  )
	  AND  ( M2C.CAL_DATE=KDW.DWE_ITEM_DIV_M2.TRANS_DATE  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.ITEM_NUM=m2_MVW.ITEM_NUM(+) and KDW.DWE_ITEM_DIV_M2.WHSE_CODE=m2_MVW.WHSE_CODE(+)  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.ITEM_NUM=m2_MIV.ITEM_NUM  )
	  AND  ( M2_PH_DZ.ITEM_NUM(+)= KDW.DWE_ITEM_DIV_M2.ITEM_NUM  AND 
	TO_DATE(@Prompt('3. Дата информации о товаре','A',,mono,free), 'DD.MM.YYYY') 
	BETWEEN M2_PH_DZ.B_DATE(+) AND M2_PH_DZ.E_DATE(+)  )
	  AND  ( M2_WHSE.WHSE_CODE=KDW.DWE_ITEM_DIV_M2.WHSE_CODE  )
	  AND  (
	  ( KDW.DWE_ITEM_DIV_M2.TRANS_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')   AND  
	TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
	  AND  ( KDW.DWE_ITEM_DIV_M2.MOVE_TYPE = 2  )
	  AND  KDW.DWE_ITEM_DIV_M2.WHSE_CODE  IN  ('0MX', '092', '01B', '01R', '02M', '02V', '04P', '05H', '0K3', '0B3', '1L5', '0N4', 'CKL', 'FRE', '1Q5')
	  AND  M2_WHSE.WHSE_TYPE  =  1
	  AND  ( HISTORY_TS2.DIV_CODE = M2_PH_DZ.DIV_CODE  )
		AND ( HISTORY_TS2.div_type = 2  
		AND HISTORY_TS2.IS_CURRENT = 'Y'  )
		AND  HISTORY_TS2.CLP_TS  =  'Y'
	  AND  M2_WHSE.TERR_CODE  !=  '0'
	  AND  WHSE_CUST.TERR_CODE  !=  '0'
	  AND  WHSE_CUST.WHSE_TYPE  IN  (3, 4)
		)
	GROUP BY
	  M2C.YYYY_MM, 
	  M2_WHSE.TERR_CODE,
	  DECODE(NVL(m2_MVW.vend_whse_status, 'D'),'D', m2_MIV.VENDOR_NUM, m2_MVW.VENDOR_NUM) 
)
SELECT
*
FROM
pob_ostatok_vt_table,
rashod_cs_region,
rashod_diler,
count_day_vt_table
WHERE 
pob_ostatok_vt_table.Код_поставщика = rashod_cs_region.Код_поставщика(+)
AND pob_ostatok_vt_table.Код_поставщика = rashod_diler.Код_поставщика(+)

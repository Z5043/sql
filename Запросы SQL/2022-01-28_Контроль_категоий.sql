with art1 as (
		SELECT 
			DISTINCT ITEM_NUM Артикул
		FROM KDW.DW_PRICE_HISTORY
		WHERE 
			V_DATE  BETWEEN 	trunc(SYSDATE, 'DDD')-1
							 AND trunc(SYSDATE, 'DDD')-1 
			and state='1'
			and (HSZ='064' or HSZ='Т33')
			AND ( DIV_CODE IN @Prompt('1. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free)
						 OR 'все' IN @Prompt('1. ТР','A',{'все', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т91', 'Т92', 'Т93', 'Т33', 'Т32', 'Т21', 'Т90', 'Т94', 'Т96', 'Т97', 'Т98', 'Т99', 'Т95', 'Т100'},multi,free) )
			),
	art2 as (
		SELECT   
			DISTINCT
			KDW.DW_PRICE_HISTORY.ITEM_NUM Артикул,
			KDW.DW_PRICE_HISTORY.IND_CATEGORY категория,
			KDW.DW_PRICE_HISTORY.STATE статус,
			KDW.DW_PRICE_HISTORY.V_DATE дата
		FROM
			KDW.DWD_CALENDAR  HISTORY_CAL,
			KDW.DW_PRICE_HISTORY
		WHERE
			 ( HISTORY_CAL.CAL_DATE BETWEEN 	KDW.DW_PRICE_HISTORY.B_DATE 
												AND KDW.DW_PRICE_HISTORY.E_DATE  )
			AND  (HISTORY_CAL.CAL_DATE  BETWEEN 	trunc(SYSDATE, 'DDD')-1
													AND trunc(SYSDATE, 'DDD')-1 )
			) ,
art3 as (
		SELECT   
		  DISTINCT
		  KDW.DW_PRICE_HISTORY.ITEM_NUM Артикул,
		  KDW.DW_PRICE_HISTORY.IND_CATEGORY категория,
		  KDW.DW_PRICE_HISTORY.STATE статус,
		  KDW.DW_PRICE_HISTORY.V_DATE дата
		FROM
		  KDW.DWD_CALENDAR  HISTORY_CAL,
		  KDW.DW_PRICE_HISTORY
		WHERE
		  ( HISTORY_CAL.CAL_DATE BETWEEN 	KDW.DW_PRICE_HISTORY.B_DATE 
											AND KDW.DW_PRICE_HISTORY.E_DATE  )
		  AND  ( HISTORY_CAL.CAL_DATE  BETWEEN 		trunc(SYSDATE, 'DDD')-2
													AND trunc(SYSDATE, 'DDD')-2 )
		)
Select 
	art1.Артикул,
	art3.дата,
	art3.категория,
	art2.дата,
	art2.категория
FROM
	art1, art2, art3
	Where 
		art1.Артикул=art2.Артикул
		AND art1.Артикул=art3.Артикул




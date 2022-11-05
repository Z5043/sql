SELECT  
  DWD_ITEM_CAL.item_num as Артикул,
  DWD_ITEM_CAL.cross_docking as ИП,
  wls.MIP as МИП
FROM
  KDW.DWD_ITEM_CAL  DWD_ITEM_CAL,
  KDW.DWF_ITEM_WLS  wls,
  KDW.DWD_WHSE  wls_whse,
  KDW.DWD_CALENDAR  CAL_DNI19
WHERE
	
	AND( wls.WHSE_CODE=wls_whse.WHSE_CODE  )
	AND( DWD_ITEM_CAL.ITEM_NUM=wls.ITEM_NUM(+) )
	AND( DWD_ITEM_CAL.ID_DATE between wls.ID_B_DATE(+) 
								  and wls.ID_E_DATE(+) )
	AND( CAL_DNI19.ID_DATE=DWD_ITEM_CAL.ID_DATE  )
	AND( CAL_DNI19.CAL_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')  AND  TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
	AND( wls.WHSE_CODE  =  DWD_ITEM_CAL.SKL_OSN )
	--AND( wls_whse.CLP  =  'Y' )
	--AND( wls_whse.terr_code  = '0' )
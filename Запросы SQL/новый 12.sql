WITH ost as(
SELECT   
  R_ITEM.ITEM_NUM as Артикул,
  R_ITEM.ITEM_NAME as Имя,
  R_WHSE.TERR_CODE as Регион,
  R_WHSE.WHSE_CODE as Склад,
  R_ITEM.IND_CATEGORY as Категория,
  SUM(( (ITEM_R.ON_HAND + ITEM_R.DAMAGED) )) as Сумма
FROM
  KDW.DWD_ITEM  R_ITEM,
  KDW.DWD_WHSE  R_WHSE,
  KDW.DWF_ITEM_R  ITEM_R
WHERE
  ( R_ITEM.ID_ITEM=ITEM_R.ID_ITEM  )
  AND  ( ITEM_R.ID_WHSE=R_WHSE.ID_WHSE  )
  AND  (
  R_WHSE.TERR_CODE  IN  @variable('Регион')
  AND  R_ITEM.IND_CATEGORY  IN  ('В', 'П')
  AND  ( ITEM_R.ID_DATE = (SELECT kdw.getDateID(TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')) FROM dual)  )
  AND  R_WHSE.WHSE_TYPE  =  1
  )
GROUP BY
  R_ITEM.ITEM_NUM, 
  R_ITEM.ITEM_NAME, 
  R_WHSE.TERR_CODE, 
  R_WHSE.WHSE_CODE,
  R_ITEM.IND_CATEGORY
HAVING
  ( 
  SUM(( (ITEM_R.ON_HAND + ITEM_R.DAMAGED) ))  >  0
  )
  ),
 ip as(
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
		( wls.WHSE_CODE=wls_whse.WHSE_CODE  )
	AND( DWD_ITEM_CAL.ITEM_NUM=wls.ITEM_NUM(+) )
	AND( DWD_ITEM_CAL.ID_DATE between wls.ID_B_DATE(+) 
									and wls.ID_E_DATE(+) )
	AND( CAL_DNI19.ID_DATE=DWD_ITEM_CAL.ID_DATE  )
	AND( CAL_DNI19.CAL_DATE BETWEEN TO_DATE(@Prompt('1. Дата начала периода','A',,mono,free), 'DD.MM.YYYY') 
									AND  TO_DATE(@Prompt('2. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY')  )
	AND(DWD_ITEM_CAL.IND_CATEGORY ='В' OR DWD_ITEM_CAL.IND_CATEGORY = 'П')
	AND(wls.MIP='Y' OR DWD_ITEM_CAL.cross_docking='Y')
	AND(wls_whse.WHSE_TYPE  =  '1')
	AND(DWD_ITEM_CAL.IS_CURRENT='Y')
 )
 SELECT 
 ost.Артикул,
  ost.Имя,
  ost.Регион,
  ost.Склад,
 ost.Категория,
  ip.Артикул,
  ip.ИП,
  ip.МИП,
 ost.Сумма
 FROM
 ost,
 ip
 where 
 ost.Артикул=ip.Артикул

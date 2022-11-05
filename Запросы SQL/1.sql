select

item_num,
sum(tvpm3) В_пути_всего_м3,
sum(В_пути_опаздываетМ) В_пути_опаздывает_м3,
sum(В_пути_Эта_неделяМ) В_пути_эта_неделя_м3,
sum(В_пути_Эта_След_НедМ) В_пути_след_неделя_м3,
sum(В_пути_Эта_Через_НедМ) В_пути_через_неделю_м3,
sum(В_пути_на_приемкеМ3)  В_пути_на_приемкеМ3
from

(

select 
a.ITEM_NUM, 
a.qty, 
a.date_r, 
a.import, 
a.sts, 
a.lev, 
a.REGION, 
a.proxima, 
a.spec_id,
 a.spec_date,
  b.VOLUME,
  b.DIV_CODE,
  g_item_g.ITEM_G1,
  g_item_g.DESC_1,
  g_item_g.ITEM_G2,
  g_item_g.DESC_2,
  (a.qty * b.VOLUME)/1000000 tvpM3,
  
   CASE WHEN a.lev=4 and a.sts IN ('3', '4')  then (a.qty * b.VOLUME)/1000000 else 0 end as В_пути_на_приемкеМ3,
  
  
   g_ph.ZCU_BNAL * DECODE(g_ph.CURR_CODE, 'Д', g_rates2.REG_RATE,  g_rates2.INNER_RATE ),
   a.qty * g_ph.ZCU_BNAL * DECODE(g_ph.CURR_CODE, 'Д', g_rates2.REG_RATE,  g_rates2.INNER_RATE ) tvpS, 
   
   CEIL(((TO_CHAR(a.date_r , 'DDD') + 1 + TRUNC(a.date_r, 'YEAR') - TRUNC(TRUNC(a.date_r, 'YEAR'),'IW'))-1)/7) week_number,
  CEIL(((TO_CHAR(a.date_r , 'DDD') + 1 + TRUNC(a.date_r, 'YEAR') - TRUNC(TRUNC(a.date_r, 'YEAR'),'IW'))-1)/7)+1 week_number2,
  
  CASE WHEN CEIL(((TO_CHAR(a.date_r , 'DDD') + 1 + TRUNC(a.date_r, 'YEAR') - TRUNC(TRUNC(a.date_r, 'YEAR'),'IW'))-1)/7) < CEIL(((TO_CHAR(SYSDATE , 'DDD') + 1 + TRUNC(SYSDATE, 'YEAR') - TRUNC(TRUNC(SYSDATE, 'YEAR'),'IW'))-1)/7) then (a.qty * b.VOLUME)/1000000 else 0 end as В_пути_опаздываетМ,
  
  CASE WHEN CEIL(((TO_CHAR(a.date_r , 'DDD') + 1 + TRUNC(a.date_r, 'YEAR') - TRUNC(TRUNC(a.date_r, 'YEAR'),'IW'))-1)/7) = CEIL(((TO_CHAR(SYSDATE , 'DDD') + 1 + TRUNC(SYSDATE, 'YEAR') - TRUNC(TRUNC(SYSDATE, 'YEAR'),'IW'))-1)/7) then (a.qty * b.VOLUME)/1000000 else 0 end -  CASE WHEN a.lev=4 and a.sts IN ('3', '4')  then (a.qty * b.VOLUME)/1000000 else 0 end as В_пути_Эта_неделяМ,
  
  CASE WHEN CEIL(((TO_CHAR(a.date_r , 'DDD') + 1 + TRUNC(a.date_r, 'YEAR') - TRUNC(TRUNC(a.date_r, 'YEAR'),'IW'))-1)/7) = CEIL(((TO_CHAR(SYSDATE , 'DDD') + 1 + TRUNC(SYSDATE, 'YEAR') - TRUNC(TRUNC(SYSDATE, 'YEAR'),'IW'))-1)/7)+1 then (a.qty * b.VOLUME)/1000000 else 0 end as В_пути_Эта_След_НедМ,

  CASE WHEN CEIL(((TO_CHAR(a.date_r , 'DDD') + 1 + TRUNC(a.date_r, 'YEAR') - TRUNC(TRUNC(a.date_r, 'YEAR'),'IW'))-1)/7) = CEIL(((TO_CHAR(SYSDATE , 'DDD') + 1 + TRUNC(SYSDATE, 'YEAR') - TRUNC(TRUNC(SYSDATE, 'YEAR'),'IW'))-1)/7)+2 then (a.qty * b.VOLUME)/1000000 else 0 end as В_пути_Эта_Через_НедМ

  
  
from

(
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
  (SELECT/*блок заказов*/
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
	group by
		rr.item_num, /*rr.spec_id,*/ rr.spec_l_id_sp) Prih_L,
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
  )
, items AS
  (SELECT /*блок артикулов */
         DISTINCT lg.ITEM_NUM
     FROM KDW.DWE_MAIN_ITEM_V lg
     WHERE NOT EXISTS
       (SELECT 1 
          FROM d
          WHERE d.SET_VALUE = lg.PROD_MANAGER
       
       )
  )
, items2 AS
  (SELECT /*блок артикулов 2 */
          DISTINCT lg.ITEM_NUM
     FROM KDW.DWE_MAIN_ITEM_V lg, d
     WHERE lg.PROD_MANAGER = d.SET_VALUE
  )
, zakaz AS                                               
  (SELECT /*блок заказов*/
            SPEC_L.SPEC_NUM AS SPECIFICACIA,
            CAL.CAL_DATE AS DATA_ISPOLNENIA,
            ITEM.ITEM_NUM,
            SUM((SPEC_L.REQ_QTY)) -
             SUM((SPEC_L.IN_PO_QTY)) AS QTY_REQ,
             /*в заказах*/
            SPEC_L.spec_id,
            SPEC_OTHER.SHIP_FLAG,
            CL.CAL_DATE ds, 1 lev
  FROM KDW.DWF_SPEC_L SPEC_L
  INNER JOIN KDW.DWD_ITEM item
     ON ITEM.ID_ITEM = SPEC_L.ID_ITEM
  INNER JOIN KDW.DWD_SPEC_PO SPEC_PO
     ON SPEC_L.ID_SPEC_PO = SPEC_PO.ID_SPEC_PO
  INNER JOIN KDW.DWD_SPEC_OTHER SPEC_OTHER
     ON SPEC_L.ID_SPEC_OTHER = SPEC_OTHER.ID_SPEC_OTHER
  INNER JOIN KDW.DWD_CALENDAR CAL
     ON SPEC_PO.ID_PERFORM_DATE = CAL.ID_DATE
  INNER JOIN KDW.DWD_CALENDAR CL
     ON SPEC_L.ID_SPEC_DATE = CL.ID_DATE
  WHERE SPEC_OTHER.is_spec_line = 'Y'
  GROUP BY SPEC_L.SPEC_NUM,
           CAL.CAL_DATE,
           ITEM.ITEM_NUM,
           SPEC_L.spec_id,
           CL.CAL_DATE,
           SPEC_OTHER.SHIP_FLAG
  )
, nakl AS
  (SELECT /*блок ннакладных*/
            ITEM.ITEM_NUM, SS_L.spec_id,
            SUM((SS_L.TRANSIT_QTY)) AS QTY_REQ,
             /*в накладных*/
            CAL.CAL_DATE AS DATA_ISPOLNENIA,
            shp_status, 2 lev
     FROM KDW.DWF_SPEC_SHP_L SS_L
     INNER JOIN KDW.DWD_ITEM ITEM
        ON ITEM.ID_ITEM = SS_L.ID_ITEM
    INNER JOIN KDW.DWD_CALENDAR cal
       ON CAL.ID_DATE = SS_L.ID_PLAN_DATE
   /*INNER JOIN KDW.DWE_MAIN_ITEM_V  ITEM_V on ITEM_V.ITEM_NUM=SS_L.ITEM_NUM
   INNER JOIN KDW.DWD_WHSE w on SS_L.ID_WHSE = w.ID_WHSE*/
    INNER JOIN kdw.dwd_spec_shp_other o
       ON O.ID_SPEC_SHP_OTHER = SS_L.ID_SPEC_SHP_OTHER
    GROUP BY ITEM.ITEM_NUM,
             SS_L.spec_id,
             CAL.CAL_DATE,
             shp_status
  ) 
, preinv AS                                                             
  (SELECT ITEM.ITEM_NUM,
         CAL.CAL_DATE AS DATA_D,
         SUM((COM_INV_L.IN_CUSTOM_QTY)) AS QTY_REQ,
          /*в инвойсах*/
         COM_INV_L.SPEC_ID
     FROM KDW.DWF_COMMON_INV_L COM_INV_L
     INNER JOIN KDW.DWD_ITEM ITEM
        ON COM_INV_L.ID_ITEM =
         ITEM.ID_ITEM
     INNER JOIN KDW.DWD_CALENDAR CAL
        ON CAL.ID_DATE =
         COM_INV_L.ID_PLAN_DATE
     GROUP BY ITEM.ITEM_NUM,
            CAL.CAL_DATE,
            COM_INV_L.SPEC_ID
  )
, MainZP AS
  (SELECT PO_NUM,
          SPEC_ID,
          MIN(ID_SPEC_DATE) AS dat,
          1 AS ID_Mother
     FROM KDW.DWF_PO_L_F
     GROUP BY PO_NUM, SPEC_ID
  ) 
, checkdat AS
  (SELECT po.PO_NUM,
          po.SPEC_ID,
          po.SPEC_NUM,
          po.ID_SPEC_DATE,
          po.ITEM_NUM,
          po.qty_ordered,
          nvl(ID_MOTHER
              ,0) AS ID_MOTHER
     FROM KDW.DWF_PO_L_F po
     FULL JOIN MainZP
       ON (    po.PO_NUM = MainZP.PO_NUM
           AND PO.ID_SPEC_DATE = MainZP.dat
           AND PO.SPEC_ID = MainZP.SPEC_ID
          )
     WHERE po.qty_ordered > 0
  )
, invoice AS
  /*блок инвойсов*/
  (SELECT preinv.*
        , nvl(ID_MOTHER, 1) AS ID_MOTHER
        , 3 lev
     FROM preinv
     LEFT OUTER JOIN checkdat
       ON (    checkdat.SPEC_ID = preinv.SPEC_ID
           AND checkdat.ITEM_NUM = preinv.ITEM_NUM
          )
  )
, zp AS                                               
  (SELECT /*блок приходов*/
          ITEM.ITEM_NUM,
          SUM((PO_L.QTY_ORDERED)) -
          SUM((PO_L.QTY_RECEIVED)) AS QTY_REQ,
          /*в приходах*/
          r_caL.CAL_DATE AS DATA_D,
          PO_L.spec_id,
          OTHER_PO_L.PO_STATUS, 4 lev
     FROM KDW.DWF_PO_L PO_L
     INNER JOIN KDW.DWD_ITEM ITEM
        ON ITEM.ID_ITEM = PO_L.ID_ITEM
     INNER JOIN KDW.DWD_PO_L_OTHER OTHER_PO_L
        ON OTHER_PO_L.ID_PO_L_OTHER = PO_L.ID_PO_L_OTHER
     INNER JOIN KDW.DWD_CALENDAR R_CAL
        ON r_caL.ID_DATE = PO_L.ID_REQUEST_DATE
           /*INNER JOIN KDW.DWD_WHSE w on PO_L.ID_WHSE = w.ID_WHSE*/
     GROUP BY ITEM.ITEM_NUM,
              r_caL.CAL_DATE,
              PO_L.spec_id,
              OTHER_PO_L.PO_STATUS
  )  
, spec AS
  (SELECT Specificacia, items2.ITEM_NUM,
          NVL(ZP.QTY_REQ
              ,NVL(Invoice.QTY_REQ
                  ,NVL(Nakl.QTY_REQ
                      ,zakaz.Qty_REQ))) AS QTY,
          NVL(ZP.DATA_D
              ,NVL(Invoice.DATA_D
                  ,NVL(Nakl.DATA_ISPOLNENIA
                      ,zakaz.DATA_ISPOLNENIA))) AS DATE_R,
          CASE
            WHEN ZP.QTY_REQ IS NOT NULL THEN
             'zp'
            ELSE
             CASE
               WHEN INVOICE.QTY_REQ IS NOT NULL THEN
                'i'
               ELSE
                CASE
                  WHEN nakl.QTY_REQ IS NOT NULL THEN
                   'n'
                  ELSE
                   'zkz'
                END
             END
          END AS Doc
          , zp.PO_STATUS
          , zakaz.SHIP_FLAG
          , ID_MOTHER
          , shp_status,
          CASE
            WHEN ZP.QTY_REQ IS NOT NULL THEN
             zp.spec_id
            ELSE
             CASE
               WHEN INVOICE.QTY_REQ IS NOT NULL THEN
                INVOICE.spec_id
               ELSE
                CASE
                  WHEN nakl.QTY_REQ IS NOT NULL THEN
                   nakl.spec_id
                  ELSE
                   zakaz.spec_id
                END
             END
          END AS spec_id, zakaz.ds,
          nvl(zp.lev
              ,nvl(invoice.lev
                  ,nvl(nakl.lev, zakaz.lev))) lev
     FROM items2
     LEFT OUTER JOIN zakaz
       ON items2.ITEM_NUM = zakaz.ITEM_NUM
     LEFT OUTER JOIN nakl
       ON (    zakaz.spec_id = nakl.spec_id
           AND nakl.ITEM_NUM = items2.ITEM_NUM
          )
     LEFT OUTER JOIN invoice
       ON (    zakaz.spec_id = invoice.spec_id
           AND invoice.ITEM_NUM = items2.ITEM_NUM
          )
     LEFT JOIN zp
       ON (    zakaz.spec_id = zp.spec_id
           AND zp.ITEM_NUM = items2.ITEM_NUM
          )
    WHERE Specificacia IS NOT NULL
      AND NVL(ZP.QTY_REQ
             ,NVL(Invoice.QTY_REQ
                 ,NVL(Nakl.QTY_REQ
                     ,zakaz.Qty_REQ))) > 0
      AND nvl(zp.PO_STATUS, '1') IN ('1', '2', '3', '4')
      AND nvl(invoice.ID_MOTHER, 1) = 1
  )
, spec1 AS 
  (SELECT spec.item_num,
          first_value(spec.qty) over(PARTITION BY spec.item_num, spec.PO_STATUS, spec.date_r, spec.spec_id) qty,
          spec.date_r,
          row_number() over(PARTITION BY spec.item_num, spec.PO_STATUS, spec.date_r, spec.spec_id ORDER BY spec.item_num, spec.date_r) qw,
          nvl(spec.PO_STATUS, '1') sts, spec.spec_id, spec.ds, spec.lev
     FROM spec
     WHERE CASE
             WHEN doc = 'zkz' THEN
              SHIP_FLAG
             ELSE
              '0'
           END = '0'
       AND CASE
             WHEN doc = 'n' THEN
              SHP_STATUS
             ELSE
              '0'
           END < '4'
       AND DATE_R > SYSDATE - 90
  )
SELECT ITEM_NUM, qty, date_r, import, sts, lev, REGION, proxima, spec_id, ds AS spec_date
  FROM 
   (SELECT ITEM_NUM, tvp AS qty, prih AS date_r, 0 AS import, sts, 0 AS region, proxima, spec_id, ds, lev
      FROM (SELECT vp.ITEM_NUM, vp.prih, vp.tvp, vp.sts,
                   row_number() over(PARTITION BY vp.ITEM_NUM ORDER BY vp.ITEM_NUM, vp.prih) proxima,
                   vp.spec_id, vp.ds, vp.lev
              FROM vp
              JOIN items
                ON (vp.item_num = items.item_num)
           )
    UNION ALL
    SELECT item_num, qty, date_r, 1 AS import, sts, 0 AS region, proxima, spec_id, ds, lev
      FROM 
        (SELECT item_num, date_r, sts, SUM(qty) qty,
                row_number() over(PARTITION BY item_num, sts ORDER BY item_num, sts, date_r) proxima,
                spec_id, ds, lev
           FROM 
             (SELECT *
                FROM spec1
                WHERE spec1.qw = '1'
                ORDER BY spec1.ITEM_NUM, spec1.date_r, spec1.sts, spec1.qw
             )
           GROUP BY ITEM_NUM, date_r, sts, spec_id, ds, lev
        )
  )
ORDER BY ITEM_NUM, sts

) a, 

 KDW.DW_GOODS b,
 KDW.DWE_ITEM_G  g_item_g,
 
  KDW.DW_PRICE_HISTORY  g_ph,
  KDW.DWE_CURR_RATE2  g_rates2

  
where 
a.item_num=b.ITEM_NUM  
and a.item_num='112338'
and a.region=0
and ( g_item_g.ITEM_NUM=b.ITEM_NUM  )
AND (g_rates2.RATE_DATE =trunc(SYSDATE) AND g_rates2.CURR_CODE='USD'  )
  AND  ( g_ph.ITEM_NUM=b.ITEM_NUM AND TRUNC(SYSDATE) BETWEEN g_ph.B_DATE AND g_ph.e_date  )
  
  
  )
  
  group by 
  item_num
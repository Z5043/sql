01R;02V;04P;02M;05H;01B;0B3;092;0N4;0K3
01R;02V;04P;02M;05H;01B;0B3;092;0N4;0K3
65337663
---------------------------------------
= If <Мат. ожидание текущее (827)>=0 Or IsNull(<Мат. ожидание текущее (827)>) Then 999999
Else <Общий (15101)>/<Мат. ожидание текущее (827)>
----------------------------------------
SELECT   
  zs.ITEM_NUM,
  zs.M,
  zs_w.TERR_CODE
FROM
  KDW.DWF_ZGL_STAT  zs,
  KDW.DWD_WHSE  zs_w,
  KDW.DWD_ITEM  zs_i
WHERE
  ( zs.ID_ITEM=zs_i.ID_ITEM  )
  AND  ( zs.ID_WHSE=zs_w.ID_WHSE  )
  AND  (
  ( zs_w.whse_code IN @Prompt('7. Код склада','A',,multi,free) OR 'все' IN @Prompt('7. Код склада','A',,multi,free)  )
  AND  ( zs.id_date = (SELECT kdw.getZGLDateID FROM dual )  )
  AND  ( zs_i.ART_GL IN (select SET_VALUE from KDW.W_SET_VALUES where set_id  =@Prompt('22. Список товаров','A',,mono,free))  )
  AND  zs_i.STATE  =  1
  )
-----------------------------------------------

  
  WITH vt_cal_period_rd AS
  (
  SELECT
    cal.YYYY_MM Год_месяц,
    cal.YYYY_W Год_неделя,
    cal.ID_DATE ID_Даты,
    cal.CAL_DATE Дата,
    cal.WORK_DAY Р_день
  FROM
    KDW.DWD_CALENDAR cal
  WHERE
        ( cal.CAL_DATE BETWEEN TO_DATE(@Prompt('11. Дата начала периода ПД','A',,mono,free), 'DD.MM.YYYY')
                           AND TO_DATE(@Prompt('12. Дата окончания периода ПД','A',,mono,free), 'DD.MM.YYYY') )
    AND ( cal.WORK_DAY = 1 )
  )
, vt_cal_period_rd_min AS
  (
  SELECT
    MIN(vt_cal_period_rd.Год_месяц) Год_месяц_Минимум,
    MIN(vt_cal_period_rd.ID_Даты) ID_Даты_Минимум,
    MIN(vt_cal_period_rd.Дата) Дата_Минимум
  FROM
    vt_cal_period_rd
  )
,
  vt_cal_period_rd_max AS
  (
  SELECT
    MAX(vt_cal_period_rd.Год_месяц) Год_месяц_Максимум,
    MAX(vt_cal_period_rd.ID_Даты) ID_Даты_Максимум,
    MAX(vt_cal_period_rd.Дата) Дата_Максимум
  FROM
    vt_cal_period_rd
  )
,
  vt_cal_period_rd_count AS
  (
  SELECT
    COUNT(*) Кол_р_дней
  FROM
    vt_cal_period_rd
  WHERE
    ( vt_cal_period_rd.Р_день = 1 )
  )
,
  vt_min_dual_yyyy_mm AS
  (
  SELECT
    (SELECT vt_cal_period_rd_min.Год_месяц_Минимум FROM vt_cal_period_rd_min) Год_месяц_1
  FROM
    dual
  )
,
  vt_min_dual_id_date AS
  (
  SELECT
    (SELECT vt_cal_period_rd_min.ID_Даты_Минимум FROM vt_cal_period_rd_min) ID_Даты_1
  FROM
    dual
  )
,
  vt_min_dual_date AS
  (
  SELECT
    (SELECT vt_cal_period_rd_min.Дата_Минимум FROM vt_cal_period_rd_min) Дата_1
  FROM
    dual
  )
,
  vt_max_dual_yyyy_mm AS
  (
  SELECT
    (SELECT vt_cal_period_rd_max.Год_месяц_Максимум FROM vt_cal_period_rd_max) Год_месяц_2
  FROM
    dual
  )
,
  vt_max_dual_id_date AS
  (
  SELECT
    (SELECT vt_cal_period_rd_max.ID_Даты_Максимум FROM vt_cal_period_rd_max) ID_Даты_2
  FROM
    dual
  )
,
  vt_max_dual_date AS
  (
  SELECT
    (SELECT vt_cal_period_rd_max.Дата_Максимум FROM vt_cal_period_rd_max) Дата_2
  FROM
    dual
  )
  ,
vt_01_min_dual_date_002 AS
  (
  SELECT
    (SELECT TRUNC(vt_cal_period_rd_min.Дата_Минимум, 'MONTH') FROM vt_cal_period_rd_min) Дата_1
  FROM
    dual
  )
,
  vt_cal_min_01mmyyyy AS
  (
  SELECT
    cal.YYYY_MM Год_месяц,
    cal.ID_DATE ID_Даты,
    cal.CAL_DATE Дата,
    cal.WORK_DAY Р_день
  FROM
    KDW.DWD_CALENDAR cal,
    vt_01_min_dual_date_002
  WHERE
    ( cal.CAL_DATE = vt_01_min_dual_date_002.Дата_1 )
  )
,
  vt_01_min_dual_id_date_002 AS
  (
  SELECT
    (SELECT vt_cal_min_01mmyyyy.ID_Даты FROM vt_cal_min_01mmyyyy) ID_Даты_1
  FROM
    dual
  )
,
vt_01_max_dual_date_002 AS
  (
  SELECT
    (SELECT TRUNC(vt_cal_period_rd_max.Дата_Максимум, 'MONTH') FROM vt_cal_period_rd_max) Дата_2
  FROM
    dual
  )
,
  vt_cal_max_01mmyyyy AS
  (
  SELECT
    cal.YYYY_MM Год_месяц,
    cal.ID_DATE ID_Даты,
    cal.CAL_DATE Дата,
    cal.WORK_DAY Р_день
  FROM
    KDW.DWD_CALENDAR cal,
    vt_01_max_dual_date_002
  WHERE
    ( cal.CAL_DATE = vt_01_max_dual_date_002.Дата_2 )
  ),
  vt_01_max_dual_id_date_002 AS /*Используется для определения ID первого числа последнего месяца в периоде */
  (
  SELECT
    (SELECT vt_cal_max_01mmyyyy.ID_Даты FROM vt_cal_max_01mmyyyy) ID_Даты_2
  FROM
    dual
  )
,
vt_whse_code AS
  (
  SELECT
    mvw_w.ID_WHSE ID_Кода_склада,
    mvw_w.WHSE_CODE Код_склада,
    mvw_w.WHSE_GROUP Код_группы_склада,
    mvw_w.TERR_CODE Код_региона
  FROM
    KDW.DWD_WHSE mvw_w
  WHERE
        --( mvw_w.clp = 'Y' )
    --AND ( mvw_w.TERR_CODE = 0 )
	--AND
	( mvw_w.WHSE_CODE IN @Prompt('7. Код склада','A',,multi,free) OR 'все' IN @Prompt('7. Код склада','A',,multi,free)  )
  )
SELECT
  dis.ITEM_NUM Артикул,
  dis.MO МО,
  vt_whse_code.Код_региона
  from 
  KDW.DWF_ITN_STATS dis,
  vt_01_max_dual_id_date_002,
vt_whse_code,
KDW.DWD_ITEM  zs_i
  where
  ( dis.ITEM_NUM = zs_i.ID_ITEM  )
   AND dis.ID_STAT_DATE=vt_01_max_dual_id_date_002.ID_Даты_2
  AND dis.ID_WHSE=vt_whse_code.ID_Кода_склада
  AND  ( zs_i.ART_GL IN (select SET_VALUE from KDW.W_SET_VALUES where set_id=@Prompt('22. Список товаров','A',,mono,free))  )
  AND  zs_i.STATE  =  1
  
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
        ( cal.CAL_DATE BETWEEN TO_DATE(@Prompt('11. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')
                           AND TO_DATE(@Prompt('12. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY') )
    AND ( cal.WORK_DAY = 1 )
  )
,
  vt_cal_01mmyyyy AS
  (
  SELECT
    vt_cal_period_rd.Год_месяц,
    vt_cal_period_rd.ID_Даты,
    vt_cal_period_rd.Дата,
    vt_cal_period_rd.Р_день
  FROM
    vt_cal_period_rd
  WHERE
    ( EXTRACT(DAY FROM vt_cal_period_rd.Дата) = 1 )
  )
,
  vt_01_max_dual_yyyy_mm AS
  (
  SELECT
    (SELECT MAX(vt_cal_01mmyyyy.Год_месяц) FROM vt_cal_01mmyyyy) Год_месяц_2
  FROM
    dual
  )
,
  vt_01_max_dual_id_date AS
  (
  SELECT
    (SELECT MAX(vt_cal_01mmyyyy.ID_Даты) FROM vt_cal_01mmyyyy) ID_Даты_2
  FROM
    dual
  )
,
  vt_01_max_dual_date AS
  (
  SELECT
    (SELECT MAX(vt_cal_01mmyyyy.Дата) FROM vt_cal_01mmyyyy) Дата_2
  FROM
    dual
  )
,
  vt_cal_period_rd_min AS
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
  vt_01_max_dual_date_002 AS
  (
  SELECT
    (SELECT TRUNC(vt_cal_period_rd_max.Дата_Максимум, 'MONTH') FROM vt_cal_period_rd_max) Дата_2
  FROM
    dual
  )
,
  vt_cal_01mmyyyy_002 AS
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
  )
,
  vt_01_max_dual_id_date_002 AS
  (
  SELECT
    (SELECT vt_cal_01mmyyyy_002.ID_Даты FROM vt_cal_01mmyyyy_002) ID_Даты_2
  FROM
    dual
  )






  SELECT /*+ index(dost,A_DOSTUPNOST_ID_DATE_IDX) */
    dost.YYYY_MM Год_месяц,
    dost.YYYY_WEEK Год_неделя,
    dost.ID_DATE ID_Даты,
    dost.CAL_DATE Дата,
    dost.WORK_DAY Р_день,
    
    dost.ITEM_NUM Артикул,
    dost.ITEM_NAME Название_товара,
    dost.DIV_CODE Код_ТР,
    dost.DIV_NAME Название_ТР,
    dost.IND_CATEGORY Признак_категория,
    dost.SKL_OSN СОХ,
    dost.HSZ ХСЗ,
    dost.INS_DATE Дата_ввода_товара,
    
    dost.TN Название_ТН,
    dost.TK Название_ТК,
    dost.TG Название_ТГ,
    dost.AG Название_АГ,
    dost.GR5 Название_группы_5,
    dost.GR6 Название_группы_6,
    dost.BRAND_NAME Название_бренда,
    dost.TM_NAME Название_ТМ,
    dost.TM_TYPE Название_типа_ТМ,
    
    dost.BAYER_NAME Название_байера,
    dost.KM_NAME Название_КМ,
    
    dost.VENDOR_NUM Код_поставщика,
    dost.VENDOR_NAME Название_поставщика,
    dost.VENDOR_NUM_FACT Код_факт_поставщика,
    dost.VENDOR_NAME_FACT Название_факт_поставщика,
    dost.ML_CODE Код_МЛ,
    dost.ML_NAME Название_МЛ,
    
    dost.DEPARTMENT Отдел,
    dost.DEPARTMENT_GR Группа,
    
    dost.LEADTIME СП,
    dost.STOCK_CONTROL ЧКЗ,
    dost.GARANT_TIME СП_по_договору,
    dost.QUOTA МТП,
    dost.SUPPLY_TYPE Форма_снабжения,
    dost.VENDOR_ITEM Артикул_поставщика,
    
    dost.TERR_CODE Код_региона,
    dost.TERR_NAME Регион,
    
    
    dost.TZ_FREE_UTRO ТЗ_свободный_на_утро,
    dost.QTY_FICT_VP Кол_фиктивного_ВП,
    
    dost.PR ПР,
    
    dost.MEDIANA Медиана,
    dost.MEDIAN_CORR Медиана_корр,
    
    dost.CNT_PD_PR_MORE_NULL Общее_кол_ПД_с_ПР_больше_нуля,
    
    dost.M_N М_Н,
    dost.M_N_ALL_PD М_Н_все_ПД,
    dost.M М,
    
    dost.V_N В_Н,
    dost.V_N_ALL_PD В_Н_все_ПД,
    dost.V В,
    
    dost.SSR50_PD ССР_50_ПД,
    dost.SSR21_PD ССР_21_ПД,
    dost.SSR10_PD ССР_10_ПД,
    
    dost.CNT_WORKDAY Кол_РД,
    dost.CNT_PD Кол_ПД
  FROM
    LSPOST.A_DOSTUPNOST dost
  WHERE
        ( dost.CAL_DATE BETWEEN TO_DATE(@Prompt('11. Дата начала периода','A',,mono,free), 'DD.MM.YYYY')
                            AND TO_DATE(@Prompt('12. Дата окончания периода','A',,mono,free), 'DD.MM.YYYY') )
    
    AND ( dost.TERR_CODE = 0 )
    
    AND ( dost.DIV_CODE IN @Prompt('31. ТР','A',{'все', 'Т21', 'Т32', 'Т33', 'Т35', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т61', 'Т62', 'Т63', 'Т64', 'Т65', 'Т66', 'Т67', 'Т68', 'Т69', 'Т70', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т90', 'Т91', 'Т92', 'Т93', 'Т94', 'Т95', 'Т96', 'Т97', 'Т98', 'Т99', 'Т100', 'Т109', 'Т110', 'Т111', 'Т112', 'Т113', 'Т114', 'Т115'},multi,free)
               OR 'все' IN @Prompt('31. ТР','A',{'все', 'Т21', 'Т32', 'Т33', 'Т35', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т61', 'Т62', 'Т63', 'Т64', 'Т65', 'Т66', 'Т67', 'Т68', 'Т69', 'Т70', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т90', 'Т91', 'Т92', 'Т93', 'Т94', 'Т95', 'Т96', 'Т97', 'Т98', 'Т99', 'Т100', 'Т109', 'Т110', 'Т111', 'Т112', 'Т113', 'Т114', 'Т115'},multi,free) )
    
    AND ( dost.IND_CATEGORY IN @Prompt('34. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'Б', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free)
                   OR 'все' IN @Prompt('34. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'Б', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free) )
    
    AND ( dost.HSZ IN @Prompt('35. ХСЗ','A',{'все', '064', 'Т33', 'Т10'},multi,free)
          OR 'все' IN @Prompt('35. ХСЗ','A',{'все', '064', 'Т33', 'Т10'},multi,free) )
    
    AND ( dost.ITEM_NUM IN @Prompt('37. Артикул','A',{'все', '120', '32033'},multi,free)
               OR 'все' IN @Prompt('37. Артикул','A',{'все', '120', '32033'},multi,free) )

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
,



  vt_whse_code AS
  (
  SELECT
    mvw_w.ID_WHSE ID_Кода_склада,
    mvw_w.WHSE_CODE Код_склада,
    mvw_w.WHSE_GROUP Код_группы_склада,
    mvw_w.TERR_CODE Код_региона,
    
    CASE
    WHEN mvw_w.TERR_CODE = 0 THEN 'Москва'
    WHEN mvw_w.TERR_CODE = 1 THEN 'С.-Петербург'
    WHEN mvw_w.TERR_CODE = 2 THEN 'Краснодар'
    WHEN mvw_w.TERR_CODE = 3 THEN 'Челябинск'
    WHEN mvw_w.TERR_CODE = 4 THEN 'Н.Новгород'
    WHEN mvw_w.TERR_CODE = 5 THEN 'Новосибирск'
    WHEN mvw_w.TERR_CODE = 6 THEN 'Казань'
    WHEN mvw_w.TERR_CODE = 7 THEN 'Волгоград'
    WHEN mvw_w.TERR_CODE = 8 THEN 'Казань'
    WHEN mvw_w.TERR_CODE = 9 THEN 'Волгоград'
    WHEN mvw_w.TERR_CODE = 10 THEN 'Казань'
    WHEN mvw_w.TERR_CODE = 11 THEN 'Волгоград'
    WHEN mvw_w.TERR_CODE = 12 THEN 'Пермь'
    WHEN mvw_w.TERR_CODE = 13 THEN 'Омск'
    WHEN mvw_w.TERR_CODE = 14 THEN 'Челябинск'
    ELSE 'Не определён' END Регион
    
  FROM
    KDW.DWD_WHSE mvw_w
  WHERE
    ( mvw_w.clp = 'Y' )
  )
,



  vt_tr AS
  (
  SELECT
    d.DIV_CODE Код_ТР,
    d.DIV_NAME Название_ТР
  FROM
    KDW.DWD_DIVISION d
  WHERE
        ( d.DIV_TYPE = '2' )
    AND ( d.IS_CURRENT = 'Y' )
    AND ( d.DIV_CODE IN @Prompt('31. ТР','A',{'все', 'Т21', 'Т32', 'Т33', 'Т35', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т61', 'Т62', 'Т63', 'Т64', 'Т65', 'Т66', 'Т67', 'Т68', 'Т69', 'Т70', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т90', 'Т91', 'Т92', 'Т93', 'Т94', 'Т95', 'Т96', 'Т97', 'Т98', 'Т99', 'Т100', 'Т109', 'Т110', 'Т111'},multi,free)
            OR 'все' IN @Prompt('31. ТР','A',{'все', 'Т21', 'Т32', 'Т33', 'Т35', 'Т44', 'Т45', 'Т46', 'Т50', 'Т51', 'Т54', 'Т55', 'Т56', 'Т57', 'Т58', 'Т59', 'Т61', 'Т62', 'Т63', 'Т64', 'Т65', 'Т66', 'Т67', 'Т68', 'Т69', 'Т70', 'Т78', 'Т79', 'Т80', 'Т81', 'Т82', 'Т83', 'Т84', 'Т85', 'Т86', 'Т87', 'Т90', 'Т91', 'Т92', 'Т93', 'Т94', 'Т95', 'Т96', 'Т97', 'Т98', 'Т99', 'Т100', 'Т109', 'Т110', 'Т111'},multi,free) )
  )
,



  vt_item_num AS
  (
  SELECT /*+ materialize */
    vt_cal_period_rd.Год_месяц,
    vt_cal_period_rd.Год_неделя,
    vt_cal_period_rd.ID_Даты,
    vt_cal_period_rd.Дата,
    vt_cal_period_rd.Р_день,
    
    r_item.ITEM_NUM Артикул,
    r_item.ITEM_NAME Название_товара,
    r_item.ITEM_TS Код_ТР,
    r_item.ITEM_TS_NAME Название_ТР,
    r_item.IND_CATEGORY Признак_категория,
    r_item.SKL_OSN СОХ,
    r_item.HSZ ХСЗ,
    r_item.BAYER Код_байера,
    
    r_item.ART_GL Арт_корн,
    r_item.ART_GL_NAME Название_арт_корн,
    r_item.GL_ITEM_TS Код_ТР_арт_корн,
    r_item.GL_ITEM_TS_NAME Название_ТР_арт_корн,
    r_item.GL_IND_CATEGORY Признак_кат_арт_корн
  FROM
    KDW.DWD_ITEM r_item,
    vt_cal_period_rd,
    vt_whse_code,
    vt_tr
  WHERE
        ( vt_cal_period_rd.ID_Даты BETWEEN r_item.ID_B_DATE
                                       AND r_item.ID_E_DATE )
    AND ( r_item.SKL_OSN = vt_whse_code.Код_склада )
    AND ( r_item.ITEM_TS = vt_tr.Код_ТР )
    
    AND ( r_item.STATE IN @Prompt('36. Состояние товара','A',{'все', '1', '2'},multi,free)
              OR 'все' IN @Prompt('36. Состояние товара','A',{'все', '1', '2'},multi,free) )
    
    AND ( r_item.IND_CATEGORY IN @Prompt('34. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'Б', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free)
                     OR 'все' IN @Prompt('34. Признак категория','A',{'все', 'D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'Б', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У'},multi,free) )
    
    AND ( r_item.HSZ IN @Prompt('35. ХСЗ','A',{'все', '064', 'Т33', 'Т10'},multi,free)
            OR 'все' IN @Prompt('35. ХСЗ','A',{'все', '064', 'Т33', 'Т10'},multi,free) )
    
    AND ( r_item.ITEM_NUM IN @Prompt('37. Артикул','A',{'все', '120', '32033'},multi,free)
                 OR 'все' IN @Prompt('37. Артикул','A',{'все', '120', '32033'},multi,free) )
 )
,
  vt_item_num_2 AS
  (
  SELECT /*+ materialize */
    g.ITEM_NUM Артикул,
    g.SKL_OSN СОХ,
    g.INS_DATE Дата_ввода_товара
  FROM
    KDW.DW_GOODS g,
    vt_item_num
  WHERE
    ( g.ITEM_NUM = vt_item_num.Артикул )
  )
,



  vt_reg_soh AS
  (
  SELECT distinct /*+ full(reg_soh) no_merge use_hash(reg_soh vt_item_num) use_hash(reg_soh vt_whse_code) */
    vt_cal_period_rd.ID_Даты,
    vt_cal_period_rd.Дата,
    
    vt_whse_code.ID_Кода_склада,
    vt_whse_code.Код_склада,
    vt_whse_code.Код_группы_склада,
    vt_whse_code.Код_региона,
    vt_whse_code.Регион,
    vt_item_num.Артикул,
    vt_item_num.Арт_корн
  FROM
    KDW.DWD_ITEM_DEF_WHSE reg_soh JOIN vt_whse_code
                                    ON ( reg_soh.WHSE_CODE = vt_whse_code.Код_склада )
                                  JOIN vt_item_num
                                    ON ( reg_soh.ITEM_NUM = vt_item_num.Артикул )
                                  JOIN vt_cal_period_rd
                                    ON ( vt_cal_period_rd.ID_Даты >= reg_soh.ID_B_DATE AND vt_cal_period_rd.ID_Даты <= reg_soh.ID_E_DATE )
  WHERE
        ( reg_soh.DEF_WHSE_TYPE = '3' )
    AND ( reg_soh.TAX_REGION <> '4' )
  )
,



  vt_zapret_VP AS
  (
  SELECT /*+ full(ezvp) no_merge use_hash(ezvp vt_item_num) use_hash(ezvp vt_whse_code) */
    vt_cal_period_rd.ID_Даты,
    vt_cal_period_rd.Дата,
    
    vt_whse_code.ID_Кода_склада,
    vt_whse_code.Код_склада,
    vt_whse_code.Код_группы_склада,
    vt_whse_code.Код_региона,
    vt_whse_code.Регион,
    
    vt_item_num.Артикул,
    
    ezvp.VALUE Запрет_ВП,
    ezvp.IS_CURRENT Текущее_значение
  FROM
    KDW.DWE_ZAPRET_VP_HISTORY ezvp JOIN vt_whse_code
                                     ON ( ezvp.WHSE_CODE = vt_whse_code.Код_склада )
                                   JOIN vt_item_num
                                     ON ( ezvp.ITEM_NUM = vt_item_num.Артикул )
                                   JOIN vt_cal_period_rd
                                     ON ( vt_cal_period_rd.ID_Даты >= ezvp.ID_B_DATE AND vt_cal_period_rd.ID_Даты <= ezvp.ID_E_DATE )
  WHERE
        ( ezvp.VALUE = 'N' )
    AND ( vt_whse_code.Регион <> 'Москва' )
  )
,
  vt_zapret_VP_2 AS
  (
  SELECT distinct
    vt_zapret_VP.ID_Даты,
    vt_zapret_VP.Дата,
    vt_zapret_VP.Регион,
    vt_zapret_VP.Артикул,
    vt_zapret_VP.Запрет_ВП
  FROM
    vt_zapret_VP
  )
,



  vt_reg_soh_vt_zapret_VP AS
  (
  SELECT
    vt_reg_soh.ID_Даты,
    vt_reg_soh.Дата,
    vt_reg_soh.ID_Кода_склада,
    vt_reg_soh.Код_склада,
    vt_reg_soh.Код_группы_склада,
    vt_reg_soh.Код_региона,
    vt_reg_soh.Регион,
    vt_reg_soh.Артикул,
    vt_reg_soh.Арт_корн,
    
    vt_zapret_VP_2.Запрет_ВП
  FROM
    vt_reg_soh,
    vt_zapret_VP_2
  WHERE
        ( vt_reg_soh.ID_Даты = vt_zapret_VP_2.ID_Даты(+) )
    AND ( vt_reg_soh.Регион = vt_zapret_VP_2.Регион(+) )
    AND ( vt_reg_soh.Артикул = vt_zapret_VP_2.Артикул(+) )
    AND ( ( vt_reg_soh.Регион = 'Москва' ) OR ( ( vt_reg_soh.Регион <> 'Москва' ) AND ( vt_zapret_VP_2.Запрет_ВП = 'N' ) ) )
  )
,
  vt_reg_soh_vt_zapret_VP_2 AS
  (
  SELECT distinct
    vt_reg_soh_vt_zapret_VP.ID_Даты,
    vt_reg_soh_vt_zapret_VP.Дата,
    vt_reg_soh_vt_zapret_VP.Код_региона,
    vt_reg_soh_vt_zapret_VP.Регион,
    vt_reg_soh_vt_zapret_VP.Артикул,
    vt_reg_soh_vt_zapret_VP.Арт_корн
  FROM
    vt_reg_soh_vt_zapret_VP
  )
,



  vt_avail_calc_method AS
  (
  SELECT
    vt_reg_soh.ID_Даты,
    vt_reg_soh.Дата,
    vt_reg_soh.ID_Кода_склада,
    vt_reg_soh.Код_склада,
    vt_reg_soh.Код_группы_склада,
    vt_reg_soh.Код_региона,
    vt_reg_soh.Регион,
    vt_reg_soh.Артикул,
    
    R_ITEM_W.avail_calc_method Способ_расчёта_доступности
  FROM
    KDW.DWD_ITEM_W R_ITEM_W,
    vt_reg_soh
  WHERE
        ( vt_reg_soh.ID_Даты BETWEEN R_ITEM_W.ID_B_DATE
                                 AND R_ITEM_W.ID_E_DATE )
    AND ( R_ITEM_W.WHSE_CODE = vt_reg_soh.Код_склада )
    AND ( R_ITEM_W.ITEM_NUM = vt_reg_soh.Артикул )
    AND ( R_ITEM_W.avail_calc_method = 5 )
  )
,
  vt_vp_fiktiv AS
  (
  SELECT
    KDW.DWE_OPEN_WHSE_T_L.OPEN_DATE - 1 AS Дата_фиктивного_ВП,
    
    vt_avail_calc_method.ID_Кода_склада,
    vt_avail_calc_method.Код_склада,
    vt_avail_calc_method.Код_группы_склада,
    vt_avail_calc_method.Код_региона,
    vt_avail_calc_method.Регион,
    vt_avail_calc_method.Артикул,
    
    KDW.DWE_OPEN_WHSE_T_L.QTY_ORDERED Кол_фиктивного_ВП,
    
    vt_avail_calc_method.Способ_расчёта_доступности
  FROM
    KDW.DWE_OPEN_WHSE_T_L,
    vt_avail_calc_method
  WHERE
        ( KDW.DWE_OPEN_WHSE_T_L.OPEN_DATE = vt_avail_calc_method.Дата + 1 )
    AND ( KDW.DWE_OPEN_WHSE_T_L.FROM_WHSE_CODE = '000' )
    AND ( KDW.DWE_OPEN_WHSE_T_L.TO_WHSE_CODE = vt_avail_calc_method.Код_склада )
    AND ( KDW.DWE_OPEN_WHSE_T_L.ITEM_NUM = vt_avail_calc_method.Артикул )
  )
,
  vt_vp_fiktiv_2 AS
  (
  SELECT
    vt_vp_fiktiv.Дата_фиктивного_ВП,
    vt_vp_fiktiv.Регион,
    vt_vp_fiktiv.Артикул,
    SUM(vt_vp_fiktiv.Кол_фиктивного_ВП) Кол_фиктивного_ВП
  FROM
    vt_vp_fiktiv
  GROUP BY
    vt_vp_fiktiv.Дата_фиктивного_ВП,
    vt_vp_fiktiv.Регион,
    vt_vp_fiktiv.Артикул
  )
,



  vt_reg_soh_vt_zapret_VP_f AS
  (
  SELECT
    vt_reg_soh_vt_zapret_VP_2.ID_Даты,
    vt_reg_soh_vt_zapret_VP_2.Дата,
    vt_reg_soh_vt_zapret_VP_2.Код_региона,
    vt_reg_soh_vt_zapret_VP_2.Регион,
    vt_reg_soh_vt_zapret_VP_2.Артикул,
    vt_reg_soh_vt_zapret_VP_2.Арт_корн,
    
    vt_vp_fiktiv_2.Кол_фиктивного_ВП
  FROM
    vt_reg_soh_vt_zapret_VP_2,
    vt_vp_fiktiv_2
  WHERE
        ( vt_reg_soh_vt_zapret_VP_2.Дата = vt_vp_fiktiv_2.Дата_фиктивного_ВП(+) )
    AND ( vt_reg_soh_vt_zapret_VP_2.Регион = vt_vp_fiktiv_2.Регион(+) )
    AND ( vt_reg_soh_vt_zapret_VP_2.Артикул = vt_vp_fiktiv_2.Артикул(+) )
  )
,
  vt_reg_soh_vt_zapret_VP_f_2 AS
  (
  SELECT
    vt_reg_soh_vt_zapret_VP_f.ID_Даты,
    vt_reg_soh_vt_zapret_VP_f.Дата,
    vt_reg_soh_vt_zapret_VP_f.Код_региона,
    vt_reg_soh_vt_zapret_VP_f.Регион,
    vt_reg_soh_vt_zapret_VP_f.Арт_корн,
    SUM(vt_reg_soh_vt_zapret_VP_f.Кол_фиктивного_ВП) Кол_фиктивного_ВП
  FROM
    vt_reg_soh_vt_zapret_VP_f
  GROUP BY
    vt_reg_soh_vt_zapret_VP_f.ID_Даты,
    vt_reg_soh_vt_zapret_VP_f.Дата,
    vt_reg_soh_vt_zapret_VP_f.Код_региона,
    vt_reg_soh_vt_zapret_VP_f.Регион,
    vt_reg_soh_vt_zapret_VP_f.Арт_корн
  )
,



  vt_catalog_tovara_kdw_oth_16_1 AS
  (
  SELECT /*+ materialize */
    vt_item_num_2.Артикул,
    
    mvw.VEND_WHSE_STATUS,
    
    mvw.VENDOR_NUM Код_поставщика_16,
    mvw.VENDOR_NAME Название_поставщика_16,
    mvw.VEND_PARENT_NUM Код_факт_поставщика_16,
    mvw.VEND_PARENT_NAME Название_факт_поставщика_16,
    mvw.PROD_MANAGER Код_МЛ_16,
    mvw.PROD_MANAGER_NAME Название_МЛ_16,
    
    mvw.STOCK_CONTROL ЧКЗ_16,
    mvw.LEAD_TIME СП_16,
    mvw.TIME_GARANT СП_по_договору_16,
    mvw.quota МТП_16,
    mvw.SUPPLY_TYPE Форма_снабжения_16,
    mvw.VENDOR_ITEM Артикул_поставщика_16
  FROM
    KDW.DWE_MAIN_VEND_WHSE mvw,
    KDW.DWD_WHSE mvw_w,
    vt_item_num_2
  WHERE
        ( mvw.VEND_WHSE_STATUS <> 'D' )
    AND ( vt_item_num_2.СОХ = mvw_w.WHSE_CODE )
    AND ( mvw_w.WHSE_GROUP = mvw.WHSE_CODE )
    
    AND ( mvw.ITEM_NUM = vt_item_num_2.Артикул )
  )
,
  vt_catalog_tovara_kdw_oth_16_3 AS
  (
  SELECT /*+ materialize */
    vt_item_num.Год_месяц,
    vt_item_num.Год_неделя,
    vt_item_num.ID_Даты,
    vt_item_num.Дата,
    vt_item_num.Р_день,
    
    vt_item_num.Артикул,
    vt_item_num.Название_товара,
    vt_item_num.Код_ТР,
    vt_item_num.Название_ТР,
    vt_item_num.Признак_категория,
    vt_item_num.СОХ,
    vt_item_num.ХСЗ,
    vt_item_num_2.Дата_ввода_товара,
    
    vt_item_num.Арт_корн,
    vt_item_num.Название_арт_корн,
    vt_item_num.Код_ТР_арт_корн,
    vt_item_num.Название_ТР_арт_корн,
    vt_item_num.Признак_кат_арт_корн,
    
    g_item_g.DESC_1 Название_ТН,
    g_item_g.DESC_2 Название_ТК,
    g_item_g.DESC_3 Название_ТГ,
    g_item_g.DESC_4 Название_АГ,
    g_item_g.DESC_5 Название_группы_5,
    g_item_g.DESC_6 Название_группы_6,
    g_item_g.BRAND_NAME Название_бренда,
    g_item_g.TRADE_MARK_NAME Название_ТМ,
    g_item_g.TM_NAME Название_типа_ТМ,
    
    mvw_g_oper.USER_NAME Название_байера,
    g_item_g.PROD_MANAGER_NAME Название_КМ,
    
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.VENDOR_NUM, vt_catalog_tovara_kdw_oth_16_1.Код_поставщика_16) Код_поставщика,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.VENDOR_NAME, vt_catalog_tovara_kdw_oth_16_1.Название_поставщика_16) Название_поставщика,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NUM, vt_catalog_tovara_kdw_oth_16_1.Код_факт_поставщика_16) Код_факт_поставщика,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NAME, vt_catalog_tovara_kdw_oth_16_1.Название_факт_поставщика_16) Название_факт_поставщика,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.PROD_MANAGER, vt_catalog_tovara_kdw_oth_16_1.Код_МЛ_16) Код_МЛ,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.PROD_MANAGER_NAME, vt_catalog_tovara_kdw_oth_16_1.Название_МЛ_16) Название_МЛ,
    
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.LEAD_TIME, vt_catalog_tovara_kdw_oth_16_1.СП_16) СП,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.STOCK_CONTROL, vt_catalog_tovara_kdw_oth_16_1.ЧКЗ_16) ЧКЗ,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.TIME_GARANT, vt_catalog_tovara_kdw_oth_16_1.СП_по_договору_16) СП_по_договору,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.quota, vt_catalog_tovara_kdw_oth_16_1.МТП_16) МТП,
    DECODE(NVL(vt_catalog_tovara_kdw_oth_16_1.vend_whse_status, 'D'), 'D', mvw_main_item_v.SUPPLY_TYPE, vt_catalog_tovara_kdw_oth_16_1.Форма_снабжения_16) Форма_снабжения,
    vt_catalog_tovara_kdw_oth_16_1.Артикул_поставщика_16 Артикул_поставщика,
    
    g_item_g_art_korn.DESC_1 Название_ТН_арт_корн,
    g_item_g_art_korn.DESC_2 Название_ТК_арт_корн,
    g_item_g_art_korn.DESC_3 Название_ТГ_арт_корн,
    g_item_g_art_korn.DESC_4 Название_АГ_арт_корн,
    g_item_g_art_korn.DESC_5 Название_группы_5_арт_корн,
    g_item_g_art_korn.DESC_6 Название_группы_6_арт_корн,
    g_item_g_art_korn.BRAND_NAME Название_бренда_арт_корн,
    g_item_g_art_korn.TRADE_MARK_NAME Название_ТМ_арт_корн,
    g_item_g_art_korn.TM_NAME Название_типа_ТМ_арт_корн,
    
    g_item_g_art_korn.PROD_MANAGER_NAME Название_КМ_арт_корн
  FROM
    KDW.DWE_ITEM_G g_item_g,
    KDW.DWE_ITEM_G g_item_g_art_korn,
    
    KDW.DWD_U_OPER mvw_g_oper,
    KDW.DWE_MAIN_ITEM_V mvw_main_item_v,
    
    vt_item_num,
    vt_item_num_2,
    vt_catalog_tovara_kdw_oth_16_1
  WHERE
        ( vt_item_num.Артикул = g_item_g.ITEM_NUM )
    AND ( vt_item_num.Арт_корн = g_item_g_art_korn.ITEM_NUM(+) )
    
    AND ( vt_item_num.Код_байера = mvw_g_oper.USER_CODE(+) )
    
    AND ( vt_item_num.Артикул = vt_catalog_tovara_kdw_oth_16_1.Артикул(+) )
    AND ( vt_item_num.Артикул = mvw_main_item_v.ITEM_NUM(+) )
    
    AND ( vt_item_num.Артикул = vt_item_num_2.Артикул(+) )
  )
,
  vt_catalog_tovara_kdw_oth_16_4 AS
  (
  SELECT /*+ materialize */
    vt_catalog_tovara_kdw_oth_16_3.ID_Даты,
    vt_catalog_tovara_kdw_oth_16_3.Арт_корн,
    MIN(vt_catalog_tovara_kdw_oth_16_3.Дата_ввода_товара) Дата_ввода_товара_арт_корн
  FROM
    vt_catalog_tovara_kdw_oth_16_3
  GROUP BY
    vt_catalog_tovara_kdw_oth_16_3.ID_Даты,
    vt_catalog_tovara_kdw_oth_16_3.Арт_корн
  )
,
  vt_catalog_tovara_kdw_oth_16_5 AS
  (
  SELECT /*+ materialize */
    vt_catalog_tovara_kdw_oth_16_3.Год_месяц,
    vt_catalog_tovara_kdw_oth_16_3.Год_неделя,
   vt_catalog_tovara_kdw_oth_16_3.ID_Даты,
    vt_catalog_tovara_kdw_oth_16_3.Дата,
    vt_catalog_tovara_kdw_oth_16_3.Р_день,
    
    vt_catalog_tovara_kdw_oth_16_3.Артикул,
    vt_catalog_tovara_kdw_oth_16_3.Название_товара,
    vt_catalog_tovara_kdw_oth_16_3.Код_ТР,
    vt_catalog_tovara_kdw_oth_16_3.Название_ТР,
    vt_catalog_tovara_kdw_oth_16_3.Признак_категория,
    vt_catalog_tovara_kdw_oth_16_3.СОХ,
    vt_catalog_tovara_kdw_oth_16_3.ХСЗ,
    vt_catalog_tovara_kdw_oth_16_3.Дата_ввода_товара,
    
    vt_catalog_tovara_kdw_oth_16_3.Арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Код_ТР_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_ТР_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Признак_кат_арт_корн,
    
    vt_catalog_tovara_kdw_oth_16_3.Название_ТН,
    vt_catalog_tovara_kdw_oth_16_3.Название_ТК,
    vt_catalog_tovara_kdw_oth_16_3.Название_ТГ,
    vt_catalog_tovara_kdw_oth_16_3.Название_АГ,
    vt_catalog_tovara_kdw_oth_16_3.Название_группы_5,
    vt_catalog_tovara_kdw_oth_16_3.Название_группы_6,
    vt_catalog_tovara_kdw_oth_16_3.Название_бренда,
    vt_catalog_tovara_kdw_oth_16_3.Название_ТМ,
    vt_catalog_tovara_kdw_oth_16_3.Название_типа_ТМ,
    
    vt_catalog_tovara_kdw_oth_16_3.Название_байера,
    vt_catalog_tovara_kdw_oth_16_3.Название_КМ,
    
    vt_catalog_tovara_kdw_oth_16_3.Код_поставщика,
    vt_catalog_tovara_kdw_oth_16_3.Название_поставщика,
    vt_catalog_tovara_kdw_oth_16_3.Код_факт_поставщика,
    vt_catalog_tovara_kdw_oth_16_3.Название_факт_поставщика,
    vt_catalog_tovara_kdw_oth_16_3.Код_МЛ,
    vt_catalog_tovara_kdw_oth_16_3.Название_МЛ,
    
    vt_catalog_tovara_kdw_oth_16_3.СП,
    vt_catalog_tovara_kdw_oth_16_3.ЧКЗ,
    vt_catalog_tovara_kdw_oth_16_3.СП_по_договору,
    vt_catalog_tovara_kdw_oth_16_3.МТП,
    vt_catalog_tovara_kdw_oth_16_3.Форма_снабжения,
    vt_catalog_tovara_kdw_oth_16_3.Артикул_поставщика,
    
    vt_catalog_tovara_kdw_oth_16_3.Название_ТН_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_ТК_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_ТГ_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_АГ_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_группы_5_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_группы_6_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_бренда_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_ТМ_арт_корн,
    vt_catalog_tovara_kdw_oth_16_3.Название_типа_ТМ_арт_корн,
    
    vt_catalog_tovara_kdw_oth_16_3.Название_КМ_арт_корн,
    
    vt_catalog_tovara_kdw_oth_16_4.Дата_ввода_товара_арт_корн
  FROM
    vt_catalog_tovara_kdw_oth_16_3,
    vt_catalog_tovara_kdw_oth_16_4
  WHERE
        ( vt_catalog_tovara_kdw_oth_16_3.ID_Даты = vt_catalog_tovara_kdw_oth_16_4.ID_Даты(+) )
    AND ( vt_catalog_tovara_kdw_oth_16_3.Арт_корн = vt_catalog_tovara_kdw_oth_16_4.Арт_корн(+) )
  )
,



  vt_table_PD_11 AS
  (
  SELECT /*+ index(v_itn_d,I_ITN_DATA_F_ITEM) materialize */
  -- SELECT /*+ full(v_itn_d) no_merge use_hash(v_itn_d vt_item_num) use_hash(v_itn_d vt_whse_code) */
    v_itn_d.ID_DATE ID_Даты,
    vt_whse_code.Код_региона,
    vt_whse_code.Регион,
    vt_item_num.Артикул,
    SUM(v_itn_d.REM_IN) ТЗ_свободный_на_утро,
    SUM(v_itn_d.MOVE_QTY + v_itn_d.ADD_MOVE_QTY) ПР
  FROM
    KDW.V_ITN_DATA v_itn_d JOIN vt_whse_code
                             ON ( v_itn_d.ID_WHSE = vt_whse_code.ID_Кода_склада )
                           JOIN vt_item_num
                             ON ( v_itn_d.ITEM_NUM = vt_item_num.Артикул )
  GROUP BY
    v_itn_d.ID_DATE,
    vt_whse_code.Код_региона,
    vt_whse_code.Регион,
    vt_item_num.Артикул
  )
,
  vt_table_PD_2 AS
  (
  SELECT /*+ materialize */
    vt_table_PD_11.Код_региона,
    vt_table_PD_11.Регион,
    vt_table_PD_11.Артикул,
    MEDIAN(vt_table_PD_11.ПР) Медиана,
    COUNT(*) Общее_кол_ПД_с_ПР_больше_нуля
  FROM
    vt_table_PD_11
  WHERE
    ( vt_table_PD_11.ПР > 0 )
  GROUP BY
    vt_table_PD_11.Код_региона,
    vt_table_PD_11.Регион,
    vt_table_PD_11.Артикул
  )
,



  vt_m_n AS
  (
  SELECT
    vt_whse_code.Код_региона,
    vt_whse_code.Регион,
    vt_item_num.Артикул,
    SUM(zs_n.MO) М_Н,
    SUM(zs_n.MO_ALL) М_Н_все_ПД,
    SUM(zs_n.VO) В_Н,
    SUM(zs_n.VO_ALL) В_Н_все_ПД,
    SUM(zs_n.CCC1) ССР_50_ПД,
    SUM(zs_n.CCC2) ССР_21_ПД,
    SUM(zs_n.CCC3) ССР_10_ПД
  FROM
    KDW.DWF_ITN_STATS zs_n,
    vt_01_max_dual_id_date_002,
    vt_whse_code,
    vt_item_num
  WHERE
        ( zs_n.ID_STAT_DATE = vt_01_max_dual_id_date_002.ID_Даты_2 )
    AND ( zs_n.ID_WHSE = vt_whse_code.ID_Кода_склада )
    AND ( zs_n.ITEM_NUM = vt_item_num.Артикул )
    
  GROUP BY
    vt_whse_code.Код_региона,
    vt_whse_code.Регион,
    vt_item_num.Артикул
  )
,



  vt_m AS
  (
  SELECT
    vt_whse_code.Код_региона,
    vt_whse_code.Регион,
    vt_item_num.Артикул,
    SUM(zs.M) М,
    SUM(zs.V) В
  FROM
    KDW.DWF_ZGL_STAT zs,
    vt_01_max_dual_id_date_002,
    vt_whse_code,
    vt_item_num
  WHERE
        ( zs.ID_DATE = vt_01_max_dual_id_date_002.ID_Даты_2 )
    AND ( zs.ID_WHSE = vt_whse_code.ID_Кода_склада )
    AND ( zs.ITEM_NUM = vt_item_num.Артикул )
    
  GROUP BY
    vt_whse_code.Код_региона,
    vt_whse_code.Регион,
    vt_item_num.Артикул
  )
,



  vt_table_PD_2_vt_m_n_vt_m AS
  (
  SELECT /*+ materialize */
    vt_table_PD_2.Код_региона,
    vt_table_PD_2.Регион,
    vt_table_PD_2.Артикул,
    
    vt_table_PD_2.Медиана,
    vt_table_PD_2.Общее_кол_ПД_с_ПР_больше_нуля,
    
    vt_m_n.М_Н,
    vt_m_n.М_Н_все_ПД,
    vt_m.М,
    
    vt_m_n.В_Н,
    vt_m_n.В_Н_все_ПД,
    vt_m.В,
    
    vt_m_n.ССР_50_ПД,
    vt_m_n.ССР_21_ПД,
    vt_m_n.ССР_10_ПД
  FROM
    vt_table_PD_2,
    vt_m_n,
    vt_m
  WHERE
        ( vt_table_PD_2.Регион = vt_m_n.Регион )
    AND ( vt_table_PD_2.Артикул = vt_m_n.Артикул )
    
    AND ( vt_table_PD_2.Регион = vt_m.Регион(+) )
    AND ( vt_table_PD_2.Артикул = vt_m.Артикул(+) )
  )
,



  vt_table_PD_12 AS
  (
  SELECT /*+ materialize */
    vt_reg_soh_vt_zapret_VP_f.ID_Даты,
    vt_reg_soh_vt_zapret_VP_f.Код_региона,
    vt_reg_soh_vt_zapret_VP_f.Регион,
    vt_reg_soh_vt_zapret_VP_f.Артикул,
    
    NVL(vt_table_PD_11.ТЗ_свободный_на_утро,0) ТЗ_свободный_на_утро,
    NVL(vt_reg_soh_vt_zapret_VP_f.Кол_фиктивного_ВП,0) Кол_фиктивного_ВП,
    
    NVL(vt_table_PD_11.ПР,0) ПР,
    
    NVL(vt_table_PD_2_vt_m_n_vt_m.Медиана,0) Медиана,
    CASE WHEN (NVL(vt_table_PD_2_vt_m_n_vt_m.М_Н,0) < 1) OR (NVL(vt_table_PD_2_vt_m_n_vt_m.Общее_кол_ПД_с_ПР_больше_нуля,0) < 6) THEN 1 ELSE NVL(vt_table_PD_2_vt_m_n_vt_m.Медиана,0) END Медиана_корр,
    
    NVL(vt_table_PD_2_vt_m_n_vt_m.Общее_кол_ПД_с_ПР_больше_нуля,0) Общее_кол_ПД_с_ПР_больше_нуля,
    
    NVL(vt_table_PD_2_vt_m_n_vt_m.М_Н,0) М_Н,
    NVL(vt_table_PD_2_vt_m_n_vt_m.М_Н_все_ПД,0) М_Н_все_ПД,
    NVL(vt_table_PD_2_vt_m_n_vt_m.М,0) М,
    
    NVL(vt_table_PD_2_vt_m_n_vt_m.В_Н,0) В_Н,
    NVL(vt_table_PD_2_vt_m_n_vt_m.В_Н_все_ПД,0) В_Н_все_ПД,
    NVL(vt_table_PD_2_vt_m_n_vt_m.В,0) В,
    
    NVL(vt_table_PD_2_vt_m_n_vt_m.ССР_50_ПД,0) ССР_50_ПД,
    NVL(vt_table_PD_2_vt_m_n_vt_m.ССР_21_ПД,0) ССР_21_ПД,
    NVL(vt_table_PD_2_vt_m_n_vt_m.ССР_10_ПД,0) ССР_10_ПД
    
  FROM
    vt_reg_soh_vt_zapret_VP_f,
    vt_table_PD_11,
    vt_table_PD_2_vt_m_n_vt_m
  WHERE
        ( vt_reg_soh_vt_zapret_VP_f.ID_Даты = vt_table_PD_11.ID_Даты(+) )
    AND ( vt_reg_soh_vt_zapret_VP_f.Регион = vt_table_PD_11.Регион(+) )
    AND ( vt_reg_soh_vt_zapret_VP_f.Артикул = vt_table_PD_11.Артикул(+) )
    
    AND ( vt_reg_soh_vt_zapret_VP_f.Регион = vt_table_PD_2_vt_m_n_vt_m.Регион(+) )
    AND ( vt_reg_soh_vt_zapret_VP_f.Артикул = vt_table_PD_2_vt_m_n_vt_m.Артикул(+) )
  )
,
  vt_table_PD_13 AS
  (
  SELECT /*+ materialize */
    vt_table_PD_12.ID_Даты,
    vt_table_PD_12.Код_региона,
    vt_table_PD_12.Регион,
    vt_table_PD_12.Артикул,
    
    vt_table_PD_12.ТЗ_свободный_на_утро,
    vt_table_PD_12.Кол_фиктивного_ВП,
    
    vt_table_PD_12.ПР,
    
    vt_table_PD_12.Медиана,
    vt_table_PD_12.Медиана_корр,
    
    vt_table_PD_12.Общее_кол_ПД_с_ПР_больше_нуля,
    
    vt_table_PD_12.М_Н,
    vt_table_PD_12.М_Н_все_ПД,
    vt_table_PD_12.М,
    
    vt_table_PD_12.В_Н,
    vt_table_PD_12.В_Н_все_ПД,
    vt_table_PD_12.В,
    
    vt_table_PD_12.ССР_50_ПД,
    vt_table_PD_12.ССР_21_ПД,
    vt_table_PD_12.ССР_10_ПД,
    
    1 Кол_РД,
    
    CASE WHEN (CASE WHEN (vt_table_PD_12.ТЗ_свободный_на_утро + vt_table_PD_12.Кол_фиктивного_ВП) < 0 THEN 0 ELSE (vt_table_PD_12.ТЗ_свободный_на_утро + vt_table_PD_12.Кол_фиктивного_ВП) END) < vt_table_PD_12.Медиана_корр THEN (CASE WHEN (vt_table_PD_12.ТЗ_свободный_на_утро + vt_table_PD_12.Кол_фиктивного_ВП) < 0 THEN 0 ELSE (vt_table_PD_12.ТЗ_свободный_на_утро + vt_table_PD_12.Кол_фиктивного_ВП) END) / vt_table_PD_12.Медиана_корр ELSE 1 END Кол_ПД
  FROM
    vt_table_PD_12
  -- WHERE
  --   ( (vt_table_PD_12.ТЗ_свободный_на_утро + vt_table_PD_12.Кол_фиктивного_ВП) > 0 )
  )
,



  vt_sborka_1 AS
  (
  SELECT /*+ materialize */
    vt_catalog_tovara_kdw_oth_16_5.Год_месяц,
    vt_catalog_tovara_kdw_oth_16_5.Год_неделя,
    vt_catalog_tovara_kdw_oth_16_5.ID_Даты,
    vt_catalog_tovara_kdw_oth_16_5.Дата,
    vt_catalog_tovara_kdw_oth_16_5.Р_день,
    
    vt_catalog_tovara_kdw_oth_16_5.Артикул,
    vt_catalog_tovara_kdw_oth_16_5.Название_товара,
    vt_catalog_tovara_kdw_oth_16_5.Код_ТР,
    vt_catalog_tovara_kdw_oth_16_5.Название_ТР,
    vt_catalog_tovara_kdw_oth_16_5.Признак_категория,
    vt_catalog_tovara_kdw_oth_16_5.СОХ,
    vt_catalog_tovara_kdw_oth_16_5.ХСЗ,
    vt_catalog_tovara_kdw_oth_16_5.Дата_ввода_товара,
    
    vt_catalog_tovara_kdw_oth_16_5.Арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Код_ТР_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_ТР_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Признак_кат_арт_корн,
    
    vt_catalog_tovara_kdw_oth_16_5.Название_ТН,
    vt_catalog_tovara_kdw_oth_16_5.Название_ТК,
    vt_catalog_tovara_kdw_oth_16_5.Название_ТГ,
    vt_catalog_tovara_kdw_oth_16_5.Название_АГ,
    vt_catalog_tovara_kdw_oth_16_5.Название_группы_5,
    vt_catalog_tovara_kdw_oth_16_5.Название_группы_6,
    vt_catalog_tovara_kdw_oth_16_5.Название_бренда,
    vt_catalog_tovara_kdw_oth_16_5.Название_ТМ,
    vt_catalog_tovara_kdw_oth_16_5.Название_типа_ТМ,
    
    vt_catalog_tovara_kdw_oth_16_5.Название_байера,
    vt_catalog_tovara_kdw_oth_16_5.Название_КМ,
    
    vt_catalog_tovara_kdw_oth_16_5.Код_поставщика,
    vt_catalog_tovara_kdw_oth_16_5.Название_поставщика,
    vt_catalog_tovara_kdw_oth_16_5.Код_факт_поставщика,
    vt_catalog_tovara_kdw_oth_16_5.Название_факт_поставщика,
    vt_catalog_tovara_kdw_oth_16_5.Код_МЛ,
    vt_catalog_tovara_kdw_oth_16_5.Название_МЛ,
    
    vt_catalog_tovara_kdw_oth_16_5.СП,
    vt_catalog_tovara_kdw_oth_16_5.ЧКЗ,
    vt_catalog_tovara_kdw_oth_16_5.СП_по_договору,
    vt_catalog_tovara_kdw_oth_16_5.МТП,
    vt_catalog_tovara_kdw_oth_16_5.Форма_снабжения,
    vt_catalog_tovara_kdw_oth_16_5.Артикул_поставщика,
    
    vt_catalog_tovara_kdw_oth_16_5.Название_ТН_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_ТК_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_ТГ_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_АГ_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_группы_5_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_группы_6_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_бренда_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_ТМ_арт_корн,
    vt_catalog_tovara_kdw_oth_16_5.Название_типа_ТМ_арт_корн,
    
    vt_catalog_tovara_kdw_oth_16_5.Название_КМ_арт_корн,
    
    vt_catalog_tovara_kdw_oth_16_5.Дата_ввода_товара_арт_корн,
    
    
    vt_table_PD_13.Код_региона,
    vt_table_PD_13.Регион,
    
    vt_table_PD_13.ТЗ_свободный_на_утро,
    vt_table_PD_13.Кол_фиктивного_ВП,
    
    vt_table_PD_13.ПР,
    
    vt_table_PD_13.Медиана,
    vt_table_PD_13.Медиана_корр,
    
    vt_table_PD_13.Общее_кол_ПД_с_ПР_больше_нуля,
    
    vt_table_PD_13.М_Н,
    vt_table_PD_13.М_Н_все_ПД,
    vt_table_PD_13.М,
    
    vt_table_PD_13.В_Н,
    vt_table_PD_13.В_Н_все_ПД,
    vt_table_PD_13.В,
    
    vt_table_PD_13.ССР_50_ПД,
    vt_table_PD_13.ССР_21_ПД,
    vt_table_PD_13.ССР_10_ПД,
    
    vt_table_PD_13.Кол_РД,
    vt_table_PD_13.Кол_ПД
  FROM
    vt_catalog_tovara_kdw_oth_16_5,
    vt_table_PD_13
  WHERE
        ( vt_catalog_tovara_kdw_oth_16_5.ID_Даты = vt_table_PD_13.ID_Даты(+) )
    AND ( vt_catalog_tovara_kdw_oth_16_5.Артикул = vt_table_PD_13.Артикул(+) )
    
    AND ( ( vt_catalog_tovara_kdw_oth_16_5.Дата >= vt_catalog_tovara_kdw_oth_16_5.Дата_ввода_товара ) OR ( ( vt_catalog_tovara_kdw_oth_16_5.Дата < vt_catalog_tovara_kdw_oth_16_5.Дата_ввода_товара ) AND ( vt_table_PD_13.Кол_ПД IS NOT NULL ) ) )
  )
,



  vt_table_PD_31 AS
  (
  SELECT /*+ materialize */
  -- SELECT /*+ full(vt_table_PD_11) no_merge use_hash(vt_table_PD_11 vt_item_num) */
    vt_table_PD_11.ID_Даты,
    vt_table_PD_11.Код_региона,
    vt_table_PD_11.Регион,
    vt_item_num.Арт_корн,
    SUM(vt_table_PD_11.ТЗ_свободный_на_утро) ТЗ_свободный_на_утро,
    SUM(vt_table_PD_11.ПР) ПР
  FROM
    vt_table_PD_11 JOIN vt_item_num
                     ON ( vt_table_PD_11.Артикул = vt_item_num.Артикул )
  GROUP BY
    vt_table_PD_11.ID_Даты,
    vt_table_PD_11.Код_региона,
    vt_table_PD_11.Регион,
    vt_item_num.Арт_корн
  )
,
  vt_table_PD_4 AS
  (
  SELECT /*+ materialize */
    vt_table_PD_31.Код_региона,
    vt_table_PD_31.Регион,
    vt_table_PD_31.Арт_корн,
    MEDIAN(vt_table_PD_31.ПР) Медиана,
    COUNT(*) Общее_кол_ПД_с_ПР_больше_нуля
  FROM
    vt_table_PD_31
  WHERE
    ( vt_table_PD_31.ПР > 0 )
  GROUP BY
    vt_table_PD_31.Код_региона,
    vt_table_PD_31.Регион,
    vt_table_PD_31.Арт_корн
  )
,



  vt_m_n_k AS
  (
  SELECT
    vt_m_n.Код_региона,
    vt_m_n.Регион,
    vt_item_num.Арт_корн,
    SUM(vt_m_n.М_Н) М_Н,
    SUM(vt_m_n.М_Н_все_ПД) М_Н_все_ПД,
    SUM(vt_m_n.В_Н) В_Н,
    SUM(vt_m_n.В_Н_все_ПД) В_Н_все_ПД,
    SUM(vt_m_n.ССР_50_ПД) ССР_50_ПД,
    SUM(vt_m_n.ССР_21_ПД) ССР_21_ПД,
    SUM(vt_m_n.ССР_10_ПД) ССР_10_ПД
  FROM
    vt_m_n,
    vt_item_num
  WHERE
    ( vt_m_n.Артикул = vt_item_num.Артикул )
  GROUP BY
    vt_m_n.Код_региона,
    vt_m_n.Регион,
    vt_item_num.Арт_корн
  )
,



  vt_m_k AS
  (
  SELECT
    vt_m.Код_региона,
    vt_m.Регион,
    vt_item_num.Арт_корн,
    SUM(vt_m.М) М,
    SUM(vt_m.В) В
  FROM
    vt_m,
    vt_item_num
  WHERE
    ( vt_m.Артикул = vt_item_num.Артикул )
  GROUP BY
    vt_m.Код_региона,
    vt_m.Регион,
    vt_item_num.Арт_корн
  )
,



  vt_table_PD_4_vt_m_n_k_vt_m_k AS
  (
  SELECT /*+ materialize */
    vt_table_PD_4.Код_региона,
    vt_table_PD_4.Регион,
    vt_table_PD_4.Арт_корн,
    
    vt_table_PD_4.Медиана,
    vt_table_PD_4.Общее_кол_ПД_с_ПР_больше_нуля,
    
    vt_m_n_k.М_Н,
    vt_m_n_k.М_Н_все_ПД,
    vt_m_k.М,
    
    vt_m_n_k.В_Н,
    vt_m_n_k.В_Н_все_ПД,
    vt_m_k.В,
    
    vt_m_n_k.ССР_50_ПД,
    vt_m_n_k.ССР_21_ПД,
    vt_m_n_k.ССР_10_ПД
  FROM
    vt_table_PD_4,
    vt_m_n_k,
    vt_m_k
  WHERE
        ( vt_table_PD_4.Регион = vt_m_n_k.Регион )
    AND ( vt_table_PD_4.Арт_корн = vt_m_n_k.Арт_корн )
    
    AND ( vt_table_PD_4.Регион = vt_m_k.Регион(+) )
    AND ( vt_table_PD_4.Арт_корн = vt_m_k.Арт_корн(+) )
  )
,



  vt_table_PD_32 AS
  (
  SELECT /*+ materialize */
    vt_reg_soh_vt_zapret_VP_f_2.ID_Даты,
    vt_reg_soh_vt_zapret_VP_f_2.Код_региона,
    vt_reg_soh_vt_zapret_VP_f_2.Регион,
    vt_reg_soh_vt_zapret_VP_f_2.Арт_корн,
    
    NVL(vt_table_PD_31.ТЗ_свободный_на_утро,0) ТЗ_свободный_на_утро,
    NVL(vt_reg_soh_vt_zapret_VP_f_2.Кол_фиктивного_ВП,0) Кол_фиктивного_ВП,
    
    NVL(vt_table_PD_31.ПР,0) ПР,
    
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.Медиана,0) Медиана,
    CASE WHEN (NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.М_Н,0) < 1) OR (NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.Общее_кол_ПД_с_ПР_больше_нуля,0) < 6) THEN 1 ELSE NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.Медиана,0) END Медиана_корр,
    
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.Общее_кол_ПД_с_ПР_больше_нуля,0) Общее_кол_ПД_с_ПР_больше_нуля,
    
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.М_Н,0) М_Н,
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.М_Н_все_ПД,0) М_Н_все_ПД,
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.М,0) М,
    
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.В_Н,0) В_Н,
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.В_Н_все_ПД,0) В_Н_все_ПД,
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.В,0) В,
    
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.ССР_50_ПД,0) ССР_50_ПД,
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.ССР_21_ПД,0) ССР_21_ПД,
    NVL(vt_table_PD_4_vt_m_n_k_vt_m_k.ССР_10_ПД,0) ССР_10_ПД
    
  FROM
    vt_reg_soh_vt_zapret_VP_f_2,
    vt_table_PD_31,
    vt_table_PD_4_vt_m_n_k_vt_m_k
  WHERE
        ( vt_reg_soh_vt_zapret_VP_f_2.ID_Даты = vt_table_PD_31.ID_Даты(+) )
    AND ( vt_reg_soh_vt_zapret_VP_f_2.Регион = vt_table_PD_31.Регион(+) )
    AND ( vt_reg_soh_vt_zapret_VP_f_2.Арт_корн = vt_table_PD_31.Арт_корн(+) )
    
    AND ( vt_reg_soh_vt_zapret_VP_f_2.Регион = vt_table_PD_4_vt_m_n_k_vt_m_k.Регион(+) )
    AND ( vt_reg_soh_vt_zapret_VP_f_2.Арт_корн = vt_table_PD_4_vt_m_n_k_vt_m_k.Арт_корн(+) )
  )
,
  vt_table_PD_33 AS
  (
  SELECT /*+ materialize */
    vt_table_PD_32.ID_Даты,
    vt_table_PD_32.Код_региона,
    vt_table_PD_32.Регион,
    vt_table_PD_32.Арт_корн,
    
    vt_table_PD_32.ТЗ_свободный_на_утро,
    vt_table_PD_32.Кол_фиктивного_ВП,
    
    vt_table_PD_32.ПР,
    
    vt_table_PD_32.Медиана,
    vt_table_PD_32.Медиана_корр,
    
    vt_table_PD_32.Общее_кол_ПД_с_ПР_больше_нуля,
    
    vt_table_PD_32.М_Н,
    vt_table_PD_32.М_Н_все_ПД,
    vt_table_PD_32.М,
    
    vt_table_PD_32.В_Н,
    vt_table_PD_32.В_Н_все_ПД,
    vt_table_PD_32.В,
    
    vt_table_PD_32.ССР_50_ПД,
    vt_table_PD_32.ССР_21_ПД,
    vt_table_PD_32.ССР_10_ПД,
    
    1 Кол_РД,
    
    CASE WHEN (CASE WHEN (vt_table_PD_32.ТЗ_свободный_на_утро + vt_table_PD_32.Кол_фиктивного_ВП) < 0 THEN 0 ELSE (vt_table_PD_32.ТЗ_свободный_на_утро + vt_table_PD_32.Кол_фиктивного_ВП) END) < vt_table_PD_32.Медиана_корр THEN (CASE WHEN (vt_table_PD_32.ТЗ_свободный_на_утро + vt_table_PD_32.Кол_фиктивного_ВП) < 0 THEN 0 ELSE (vt_table_PD_32.ТЗ_свободный_на_утро + vt_table_PD_32.Кол_фиктивного_ВП) END) / vt_table_PD_32.Медиана_корр ELSE 1 END Кол_ПД
  FROM
    vt_table_PD_32
  -- WHERE
  --   ( (vt_table_PD_32.ТЗ_свободный_на_утро + vt_table_PD_32.Кол_фиктивного_ВП) > 0 )
  )


  SELECT /*+ materialize */
    vt_sborka_1.Год_месяц,
    vt_sborka_1.Год_неделя,
    vt_sborka_1.ID_Даты,
    vt_sborka_1.Дата,
    vt_sborka_1.Р_день,
    
    vt_sborka_1.Артикул,
    vt_sborka_1.Название_товара,
    vt_sborka_1.Код_ТР,
    vt_sborka_1.Название_ТР,
    vt_sborka_1.Признак_категория,
    vt_sborka_1.СОХ,
    vt_sborka_1.ХСЗ,
    vt_sborka_1.Дата_ввода_товара,
    
    vt_sborka_1.Название_ТН,
    vt_sborka_1.Название_ТК,
    vt_sborka_1.Название_ТГ,
    vt_sborka_1.Название_АГ,
    vt_sborka_1.Название_группы_5,
    vt_sborka_1.Название_группы_6,
    vt_sborka_1.Название_бренда,
    vt_sborka_1.Название_ТМ,
    vt_sborka_1.Название_типа_ТМ,
    
    vt_sborka_1.Название_байера,
    vt_sborka_1.Название_КМ,
    
    vt_sborka_1.Код_поставщика,
    vt_sborka_1.Название_поставщика,
    vt_sborka_1.Код_факт_поставщика,
    vt_sborka_1.Название_факт_поставщика,
    vt_sborka_1.Код_МЛ,
    vt_sborka_1.Название_МЛ,
    
    l.V_TEXT Отдел,
    l.WHSE_CODE Группа,
    
    vt_sborka_1.СП,
    vt_sborka_1.ЧКЗ,
    vt_sborka_1.СП_по_договору,
    vt_sborka_1.МТП,
    vt_sborka_1.Форма_снабжения,
    vt_sborka_1.Артикул_поставщика,
    
    vt_sborka_1.Код_региона,
    vt_sborka_1.Регион,
    
    
    vt_sborka_1.ТЗ_свободный_на_утро,
    vt_sborka_1.Кол_фиктивного_ВП,
    
    vt_sborka_1.ПР,
    
    vt_sborka_1.Медиана,
    vt_sborka_1.Медиана_корр,
    
    vt_sborka_1.Общее_кол_ПД_с_ПР_больше_нуля,
    
    vt_sborka_1.М_Н,
    vt_sborka_1.М_Н_все_ПД,
    vt_sborka_1.М,
    
    vt_sborka_1.В_Н,
    vt_sborka_1.В_Н_все_ПД,
    vt_sborka_1.В,
    
    vt_sborka_1.ССР_50_ПД,
    vt_sborka_1.ССР_21_ПД,
    vt_sborka_1.ССР_10_ПД,
    
    vt_sborka_1.Кол_РД,
    vt_sborka_1.Кол_ПД,
    
    
    
    vt_sborka_1.Арт_корн,
    vt_sborka_1.Название_арт_корн,
    vt_sborka_1.Код_ТР_арт_корн,
    vt_sborka_1.Название_ТР_арт_корн,
    vt_sborka_1.Признак_кат_арт_корн,
    vt_sborka_1.Дата_ввода_товара_арт_корн,
    
    vt_sborka_1.Название_ТН_арт_корн,
    vt_sborka_1.Название_ТК_арт_корн,
    vt_sborka_1.Название_ТГ_арт_корн,
    vt_sborka_1.Название_АГ_арт_корн,
    vt_sborka_1.Название_группы_5_арт_корн,
    vt_sborka_1.Название_группы_6_арт_корн,
    vt_sborka_1.Название_бренда_арт_корн,
    vt_sborka_1.Название_ТМ_арт_корн,
    vt_sborka_1.Название_типа_ТМ_арт_корн,
    
    vt_sborka_1.Название_КМ_арт_корн,
    
    
    vt_table_PD_33.ТЗ_свободный_на_утро ТЗ_свободный_на_утро_арт_корн,
    vt_table_PD_33.Кол_фиктивного_ВП Кол_фиктивного_ВП_арт_корн,
    
    vt_table_PD_33.ПР ПР_арт_корн,
    
    vt_table_PD_33.Медиана Медиана_арт_корн,
    vt_table_PD_33.Медиана_корр Медиана_корр_арт_корн,
    
    vt_table_PD_33.Общее_кол_ПД_с_ПР_больше_нуля ПД_с_ПР_больше_нуля_арт_корн,
    
    vt_table_PD_33.М_Н М_Н_арт_корн,
    vt_table_PD_33.М_Н_все_ПД М_Н_все_ПД_арт_корн,
    vt_table_PD_33.М М_арт_корн,
    
    vt_table_PD_33.В_Н В_Н_арт_корн,
    vt_table_PD_33.В_Н_все_ПД В_Н_все_ПД_арт_корн,
    vt_table_PD_33.В В_арт_корн,
    
    vt_table_PD_33.ССР_50_ПД ССР_50_ПД_арт_корн,
    vt_table_PD_33.ССР_21_ПД ССР_21_ПД_арт_корн,
    vt_table_PD_33.ССР_10_ПД ССР_10_ПД_арт_корн,
    
    vt_table_PD_33.Кол_РД Кол_РД_арт_корн,
    
    vt_table_PD_33.Кол_ПД Кол_ПД_арт_корн
  FROM
    KDW.LIKA_VEND l,
    vt_sborka_1,
    vt_table_PD_33
  WHERE
        ( vt_sborka_1.ID_Даты = vt_table_PD_33.ID_Даты(+) )
    AND ( vt_sborka_1.Регион = vt_table_PD_33.Регион(+) )
    AND ( vt_sborka_1.Арт_корн = vt_table_PD_33.Арт_корн(+) )
    AND ( vt_sborka_1.Код_МЛ = l.VENDOR_NUM(+) )
  


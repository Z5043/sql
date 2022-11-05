 SELECT
  a.Артикул,
  a.Название_товара,
  a.Ед_изм,
  a.Код_ТР,
  a.Название_ТР,
  a.Признак_категория,
  a.СОХ,
  a.ХСЗ,
  a.Объём_см3,
  a.Код_склада,
  
  a.ABC_по_объёму,
  a.ABC_по_себ_руб,
  
  a.Название_ТН,
  a.Название_ТК,
  a.Название_ТГ,
  a.Название_АГ,
  a.Название_группы_5,
  a.Название_группы_6,
  
  a.Название_байера,
  a.Название_КМ,
  
  a.Код_поставщика,
  a.Название_поставщика,
  a.Код_факт_поставщика,
  a.Название_факт_поставщика,
  a.Код_МЛ,
  a.Название_МЛ,
  
  a.СП_ЧКЗ,
  
  a.МТП,
  a.Форма_снабжения,
  
  a.Название_признака_1,
  a.Значение_признака_1,
  
  a.Кол_дней_Ср_ТЗ,
  a.Ср_ТЗ_в_наличии_м3,
  a.Ср_ТЗ_выделено_м3,
  a.Ср_ТЗ_свободно_м3,
  
  a.Кол_дней_Ср_ТЗ_0,
  a.Ср_ТЗ_в_наличии_0_м3,
  a.Ср_ТЗ_выделено_0_м3,
  a.Ср_ТЗ_свободно_0_м3,
  
  a.Ср_ТЗ_в_наличии_1_м3,
  a.Ср_ТЗ_выделено_1_м3,
  a.Ср_ТЗ_свободно_1_м3,
  
  a.Ср_ТЗ_в_наличии_2_м3,
  a.Ср_ТЗ_выделено_2_м3,
  a.Ср_ТЗ_свободно_2_м3,
  
  a.Ср_ТЗ_в_наличии_3_м3,
  a.Ср_ТЗ_выделено_3_м3,
  a.Ср_ТЗ_свободно_3_м3,
  
  a.Ср_ТЗ_в_наличии_4_м3,
  a.Ср_ТЗ_выделено_4_м3,
  a.Ср_ТЗ_свободно_4_м3,
  
  a.Ср_ТЗ_в_наличии_5_м3,
  a.Ср_ТЗ_выделено_5_м3,
  a.Ср_ТЗ_свободно_5_м3,
  
   a.Ср_ТЗ_в_наличии_6_м3,
  a.Ср_ТЗ_выделено_6_м3,
  a.Ср_ТЗ_свободно_6_м3,
  
  a.Ср_ТЗ_в_наличии_7_м3,
  a.Ср_ТЗ_выделено_7_м3,
  a.Ср_ТЗ_свободно_7_м3,
  
  a.ССР_м3,
  a.ССР_0_м3,
  a.ССР_1_м3,
  a.ССР_2_м3,
  a.ССР_3_м3,
  a.ССР_4_м3,
  a.ССР_5_м3,
  a.ССР_6_м3,
  a.ССР_7_м3,
  
  
  b.В_пути_всего_м3,
  b.В_пути_опаздывает_м3,
  b.В_пути_эта_неделя_м3,
  b.В_пути_след_неделя_м3,
  b.В_пути_через_неделю_м3,
  b.В_пути_на_приемкеМ3 as В_пути_на_приемке_ст3_М3
FROM
  (
  WITH vt_cal_period_rd AS
    (
    SELECT
      cal.YYYY_MM Год_месяц,
      cal.ID_DATE ID_Даты,
      cal.CAL_DATE Дата,
      cal.WORK_DAY Р_день
    FROM
      KDW.DWD_CALENDAR cal
    WHERE
     ( cal.CAL_DATE BETWEEN (SELECT ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1) FROM DUAL)
                         AND (SELECT TRUNC(SYSDATE,'MM')-1 FROM DUAL) )
    )
  ,
    vt_cal_period_rd_0 AS
    (
    SELECT
      cal.YYYY_MM Год_месяц,
      cal.ID_DATE ID_Даты,
      cal.CAL_DATE Дата,
      cal.WORK_DAY Р_день
    FROM
      KDW.DWD_CALENDAR cal
    WHERE
      ( cal.CAL_DATE BETWEEN trunc(SYSDATE, 'iw')-14
                         AND trunc(SYSDATE, 'iw')-8 )
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
    vt_cal_period_rd_count_0 AS
    (
    SELECT
      COUNT(*) Кол_р_дней
    FROM
      vt_cal_period_rd_0
    WHERE
      ( vt_cal_period_rd_0.Р_день = 1 )
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
    vt_cal_rep_date_1 AS
    (
    SELECT
      cal.YYYY_MM Год_месяц,
      cal.ID_DATE ID_Даты,
      cal.CAL_DATE Дата,
      cal.WORK_DAY Р_день
    FROM
      KDW.DWD_CALENDAR cal
    WHERE
      ( cal.CAL_DATE IN trunc(SYSDATE, 'iw')-7 )
    )
  ,
    vt_dual_rep_id_date_1 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_1.ID_Даты FROM vt_cal_rep_date_1) ID_Даты_3
    FROM
      dual
    )
  ,
    vt_dual_rep_date_1 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_1.Дата FROM vt_cal_rep_date_1) Дата_3
    FROM
      dual
    )
  ,
    vt_cal_rep_date_2 AS
    (
    SELECT
      cal.YYYY_MM Год_месяц,
      cal.ID_DATE ID_Даты,
      cal.CAL_DATE Дата,
      cal.WORK_DAY Р_день
    FROM
      KDW.DWD_CALENDAR cal
    WHERE
      ( cal.CAL_DATE IN trunc(SYSDATE, 'iw')-6 )
    )
  ,
    vt_dual_rep_id_date_2 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_2.ID_Даты FROM vt_cal_rep_date_2) ID_Даты_3
    FROM
      dual
    )
  ,
    vt_dual_rep_date_2 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_2.Дата FROM vt_cal_rep_date_2) Дата_3
    FROM
      dual
    )
  ,
    vt_cal_rep_date_3 AS
    (
    SELECT
      cal.YYYY_MM Год_месяц,
      cal.ID_DATE ID_Даты,
      cal.CAL_DATE Дата,
      cal.WORK_DAY Р_день
    FROM
      KDW.DWD_CALENDAR cal
    WHERE
      ( cal.CAL_DATE IN trunc(SYSDATE, 'iw')-5 )
    )
  ,
    vt_dual_rep_id_date_3 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_3.ID_Даты FROM vt_cal_rep_date_3) ID_Даты_3
    FROM
      dual
    )
  ,
    vt_dual_rep_date_3 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_3.Дата FROM vt_cal_rep_date_3) Дата_3
    FROM
      dual
    )
  ,
    vt_cal_rep_date_4 AS
    (
    SELECT
      cal.YYYY_MM Год_месяц,
      cal.ID_DATE ID_Даты,
      cal.CAL_DATE Дата,
      cal.WORK_DAY Р_день
    FROM
      KDW.DWD_CALENDAR cal
    WHERE
      ( cal.CAL_DATE IN trunc(SYSDATE, 'iw')-4 )
    )
  ,
    vt_dual_rep_id_date_4 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_4.ID_Даты FROM vt_cal_rep_date_4) ID_Даты_3
    FROM
      dual
    )
  ,
    vt_dual_rep_date_4 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_4.Дата FROM vt_cal_rep_date_4) Дата_3
    FROM
      dual
    )
  ,
    vt_cal_rep_date_5 AS
    (
    SELECT
      cal.YYYY_MM Год_месяц,
      cal.ID_DATE ID_Даты,
      cal.CAL_DATE Дата,
      cal.WORK_DAY Р_день
    FROM
      KDW.DWD_CALENDAR cal
    WHERE
      ( cal.CAL_DATE IN trunc(SYSDATE, 'iw')-3 )
    )
  ,
    vt_dual_rep_id_date_5 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_5.ID_Даты FROM vt_cal_rep_date_5) ID_Даты_3
    FROM
      dual
    )
  ,
    vt_dual_rep_date_5 AS
    (
    SELECT
      (SELECT vt_cal_rep_date_5.Дата FROM vt_cal_rep_date_5) Дата_3
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
	  
	  case when mvw_w.WHSE_CODE in ('0D0', '00D') then 'T1'
	       when mvw_w.WHSE_CODE in ('0C0', '00J', '0MB') then 'Т3'
		   when mvw_w.WHSE_CODE in ('1DQ', '2DQ') then 'Т4'
		   when mvw_w.WHSE_CODE in ('1DR', '1DW', '1DH', '1DE') then 'Ям'
		   when mvw_w.WHSE_CODE in ('0QR', '0Q0', '1LE') then 'Реутово'
		   when mvw_w.WHSE_CODE in ('060') then 'Кантемировская'
		   when mvw_w.WHSE_CODE in ('00G') then 'Бумага_Дмд'
		   when mvw_w.WHSE_CODE in ('1DX') then 'Раппал_Дмд'
		   else  mvw_w.WHSE_CODE end Терминал
	  
	  
    FROM
      KDW.DWD_WHSE mvw_w
    WHERE mvw_w.TERR_CODE = 0
        AND mvw_w.CLP = 'Y'          
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
    )
  ,
    vt_item_num AS
    (
    SELECT
      g.ITEM_NUM Артикул,
      vt_tr.Название_ТР
    FROM
      KDW.DW_GOODS g,
      vt_tr
    WHERE
          ( g.DIV_CODE = vt_tr.Код_ТР )
      
      AND ( g.STATE IN ('1') )
          
      
      --AND ( g.IND_CATEGORY IN ('D', 'E', 'G', 'H', 'J', 'K', 'L', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'Z', 'А', 'В', 'И', 'Л', 'М', 'Н', 'О', 'П', 'С', 'Т', 'У', 'Б') )
    )
  ,
    vt_priznak_1 AS
    (
    SELECT
      g_item_k1.ITEM_NUM Артикул,
      g_item_pr1.PR_NAME Название_признака_1,
      g_item_k1.VALUE Значение_признака_1
    FROM
      KDW.DWE_BDT_MAIN_ITEM_PR g_item_pr1,
      KDW.DWE_BDT_MAIN_ITEM_K_PR g_item_k1
    WHERE
          ( g_item_k1.PR_NUM = '6036' )
      AND ( g_item_k1.PR_NUM = g_item_pr1.PR_NUM(+) )
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
	  vt_whse_code2.Код_склада, 
      
      mvw_item_g.DESC_1 Название_ТН,
      mvw_item_g.DESC_2 Название_ТК,
      mvw_item_g.DESC_3 Название_ТГ,
      mvw_item_g.DESC_4 Название_АГ,
      mvw_item_g.DESC_5 Название_группы_5,
      mvw_item_g.DESC_6 Название_группы_6,
 
      mvw_g_oper.USER_NAME Название_байера,
      mvw_item_g.PROD_MANAGER_NAME Название_КМ,
     
      vt_priznak_1.Название_признака_1,
      vt_priznak_1.Значение_признака_1
    FROM
      KDW.DW_GOODS mvw_goods,
      KDW.DWD_DIVISION mvw_goods_TS,
      KDW.DWE_ITEM_G mvw_item_g,
      KDW.DWD_U_OPER mvw_g_oper,
      vt_whse_code,
	  vt_whse_code  vt_whse_code2,
      vt_item_num,
      vt_priznak_1
    WHERE
          ( mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.DIV_TYPE = 2 AND mvw_goods_TS.IS_CURRENT = 'Y' )
      AND ( mvw_goods.ITEM_NUM = mvw_item_g.ITEM_NUM )
      AND ( mvw_goods.bayer = mvw_g_oper.user_code(+) )
     
      AND ( mvw_goods.SKL_OSN = vt_whse_code.Код_склада )
      AND ( mvw_goods.ITEM_NUM = vt_item_num.Артикул )
      AND ( mvw_goods.ITEM_NUM = vt_priznak_1.Артикул(+) )
    ),
	
	logist as
	
	(
	
	Select 
	  mvw.ITEM_NUM Артикул, 
	  mvw.VENDOR_NUM Код_поставщика,
      mvw.VENDOR_NAME Название_поставщика,
      DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NUM, mvw.VEND_PARENT_NUM) Код_факт_поставщика,
      DECODE(NVL(mvw.vend_whse_status, 'D'), 'D', mvw_main_item_v.VEND_PARENT_NAME, mvw.VEND_PARENT_NAME) Название_факт_поставщика,
      mvw.PROD_MANAGER Код_МЛ,
      mvw.PROD_MANAGER_NAME Название_МЛ,
      
      mvw.LEAD_TIME + mvw.STOCK_CONTROL СП_ЧКЗ,
      
      mvw.quota МТП,
      mvw.SUPPLY_TYPE Форма_снабжения
	  
	  from 
	     KDW.DWE_MAIN_VEND_WHSE mvw,
         KDW.DWE_MAIN_ITEM_V mvw_main_item_v,
         KDW.DWD_WHSE mvw_w,
		 vt_catalog_tovara_kdw_other_16
	  

	  where 
	  
	   ( vt_catalog_tovara_kdw_other_16.Артикул = mvw.ITEM_NUM(+) )
      AND ( mvw.VEND_WHSE_STATUS <> 'D' )
      AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
      
      AND ( vt_catalog_tovara_kdw_other_16.СОХ = mvw_w.WHSE_CODE )
      AND ( mvw_w.WHSE_GROUP = mvw.WHSE_CODE )
	
	
	
	)
	
	
  -- ,
  --   vt_abc AS
  --   (
  --   SELECT
  --     zs.ITEM_NUM Артикул,
  --     zso.ABC_VOLUME ABC_по_объёму,
  --     zso.ABC_COST ABC_по_себ_руб
  --   FROM
  --     KDW.DWF_ZGL_STAT zs,
  --     KDW.DWD_ZGL_STAT_OTHER zso,
  --     vt_whse_code,
  --     vt_item_num
  --   WHERE
  --         ( zs.ID_ZGL_STAT_OTHER = zso.ID_ZGL_STAT_OTHER )
  --     AND ( zs.id_date = 9827 )
  --     AND ( zs.ID_WHSE = vt_whse_code.ID_Кода_склада )
  --     AND ( zs.ITEM_NUM = vt_item_num.Артикул )
  --   )
  ,
    vt_abc AS
    (
    SELECT
      zs.ITEM_NUM Артикул,
      zso.ABC_VOLUME ABC_по_объёму,
      zso.ABC_COST ABC_по_себ_руб
    FROM
      (
      SELECT /*+ leading(vt_whse_code) use_nl(vt_whse_code zs) materialize */ *
      FROM
        KDW.DWF_ZGL_STAT zs JOIN vt_whse_code
                              ON ( zs.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( zs.id_date = (SELECT kdw.getZGLDateID FROM dual ) )
      ) zs JOIN vt_catalog_tovara_kdw_other_16
             ON ( zs.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
           JOIN KDW.DWD_ZGL_STAT_OTHER zso
             ON ( zs.ID_ZGL_STAT_OTHER = zso.ID_ZGL_STAT_OTHER )
    )
  ,



    item_r AS
    (
    SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
    FROM
      KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                              ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
    WHERE
     ( ITEM_R.ID_DATE BETWEEN ( SELECT kdw.getDateID((SELECT ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1) FROM DUAL)) FROM dual )
                           AND ( SELECT kdw.getDateID((SELECT TRUNC(SYSDATE,'MM')-1 FROM DUAL)) FROM dual ) )
    )
  ,
    vt_tov_zap AS
    (
    SELECT /*+ leading(vt_catalog_tovara_kdw_other_16) use_hash(vt_catalog_tovara_kdw_other_16 ITEM_R) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      COUNT(DISTINCT ITEM_R.ID_DATE) Кол_дней_Ср_ТЗ,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) / COUNT(DISTINCT ITEM_R.ID_DATE) Ср_ТЗ_в_наличии_м3,
      SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) / COUNT(DISTINCT ITEM_R.ID_DATE) Ср_ТЗ_выделено_м3,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) / COUNT(DISTINCT ITEM_R.ID_DATE) - SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) / COUNT(DISTINCT ITEM_R.ID_DATE) Ср_ТЗ_свободно_м3
      , vt_whse_code.Код_склада
    FROM
      item_r JOIN vt_catalog_tovara_kdw_other_16
               ON ( ITEM_R.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
			 JOIN vt_whse_code
               ON (item_r.ID_WHSE = vt_whse_code.ID_Кода_склада )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(ITEM_R.ON_HAND) > 0
    )
  ,



    item_r_0 AS
    (
    SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
    FROM
      KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                              ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
    WHERE
      ( ITEM_R.ID_DATE BETWEEN ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-14) FROM dual )
                           AND ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-8) FROM dual ) )
    )
  ,
    vt_tov_zap_0 AS
    (
    SELECT /*+ leading(vt_catalog_tovara_kdw_other_16) use_hash(vt_catalog_tovara_kdw_other_16 ITEM_R_0) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      COUNT(DISTINCT ITEM_R_0.ID_DATE) Кол_дней_Ср_ТЗ_0,
      SUM(ITEM_R_0.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) / COUNT(DISTINCT ITEM_R_0.ID_DATE) Ср_ТЗ_в_наличии_0_м3,
      SUM(ITEM_R_0.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) / COUNT(DISTINCT ITEM_R_0.ID_DATE) Ср_ТЗ_выделено_0_м3,
      SUM(ITEM_R_0.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) / COUNT(DISTINCT ITEM_R_0.ID_DATE) - SUM(ITEM_R_0.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) / COUNT(DISTINCT ITEM_R_0.ID_DATE) Ср_ТЗ_свободно_0_м3
      , vt_whse_code.Код_склада
    FROM
      item_r_0 JOIN vt_catalog_tovara_kdw_other_16
                 ON ( ITEM_R_0.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
				 JOIN vt_whse_code
                 ON ( ITEM_R_0.ID_WHSE = vt_whse_code.ID_Кода_склада )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(ITEM_R_0.ON_HAND) > 0
    )
  ,



    vt_tov_zap_1 AS
    (
    SELECT
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_в_наличии_1_м3,
      SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_выделено_1_м3,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) - SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_свободно_1_м3
      , item_r.Код_склада
    FROM
      (
      SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
      FROM
        KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                                ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( ITEM_R.ID_DATE = ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-7) FROM dual ) )
      ) item_r JOIN vt_catalog_tovara_kdw_other_16
                 ON ( ITEM_R.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
			    
	
	GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , item_r.Код_склада
    HAVING
      SUM(ITEM_R.ON_HAND) > 0
    )
  ,
    vt_tov_zap_2 AS
    (
    SELECT
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_в_наличии_2_м3,
      SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_выделено_2_м3,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) - SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_свободно_2_м3
      , item_r.Код_склада
    FROM
      (
      SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
      FROM
        KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                                ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( ITEM_R.ID_DATE = ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-6) FROM dual ) )
      ) item_r JOIN vt_catalog_tovara_kdw_other_16
                 ON ( ITEM_R.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , item_r.Код_склада
    HAVING
      SUM(ITEM_R.ON_HAND) > 0
    )
  ,
    vt_tov_zap_3 AS
    (
    SELECT
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_в_наличии_3_м3,
      SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_выделено_3_м3,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) - SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_свободно_3_м3
      , item_r.Код_склада
    FROM
      (
      SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
      FROM
        KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                                ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( ITEM_R.ID_DATE = ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-5) FROM dual ) )
      ) item_r JOIN vt_catalog_tovara_kdw_other_16
                 ON ( ITEM_R.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , item_r.Код_склада
    HAVING
      SUM(ITEM_R.ON_HAND) > 0
    )
  ,
    vt_tov_zap_4 AS
    (
    SELECT
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_в_наличии_4_м3,
      SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_выделено_4_м3,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) - SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_свободно_4_м3
      , item_r.Код_склада
    FROM
      (
      SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
      FROM
        KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                                ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( ITEM_R.ID_DATE = ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-4) FROM dual ) )
      ) item_r JOIN vt_catalog_tovara_kdw_other_16
                 ON ( ITEM_R.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , item_r.Код_склада
    HAVING
      SUM(ITEM_R.ON_HAND) > 0
    )
  ,
    vt_tov_zap_5 AS
    (
    SELECT
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_в_наличии_5_м3,
      SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_выделено_5_м3,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) - SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_свободно_5_м3
      , item_r.Код_склада
    FROM
      (
      SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
      FROM
        KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                                ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( ITEM_R.ID_DATE = ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-3) FROM dual ) )
      ) item_r JOIN vt_catalog_tovara_kdw_other_16
                 ON ( ITEM_R.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , item_r.Код_склада
    HAVING
      SUM(ITEM_R.ON_HAND) > 0
    )
	
	,
    vt_tov_zap_6 AS
    (
    SELECT
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_в_наличии_6_м3,
      SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_выделено_6_м3,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) - SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_свободно_6_м3
      , item_r.Код_склада
    FROM
      (
      SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
      FROM
        KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                                ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( ITEM_R.ID_DATE = ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-2) FROM dual ) )
      ) item_r JOIN vt_catalog_tovara_kdw_other_16
                 ON ( ITEM_R.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , item_r.Код_склада
    HAVING
      SUM(ITEM_R.ON_HAND) > 0
    )

	,
    vt_tov_zap_7 AS
    (
    SELECT
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_в_наличии_7_м3,
      SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_выделено_7_м3,
      SUM(ITEM_R.ON_HAND * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) - SUM(ITEM_R.COMMITTED_QTY * vt_catalog_tovara_kdw_other_16.Объём_см3 / (1000000)) Ср_ТЗ_свободно_7_м3
      , item_r.Код_склада
    FROM
      (
      SELECT /*+ leading(vt_whse_code) index(ITEM_R I7_ITEM_R_F) use_nl(vt_whse_code item_r) materialize */ *
      FROM
        KDW.DWF_ITEM_R ITEM_R JOIN vt_whse_code
                                ON ( ITEM_R.ID_WHSE = vt_whse_code.ID_Кода_склада )
      WHERE
        ( ITEM_R.ID_DATE = ( SELECT kdw.getDateID(trunc(SYSDATE, 'iw')-1) FROM dual ) )
      ) item_r JOIN vt_catalog_tovara_kdw_other_16
                 ON ( ITEM_R.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , item_r.Код_склада
    HAVING
      SUM(ITEM_R.ON_HAND) > 0
    )
	
  ,



    vt_pr_za_kol_dney AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) / vt_cal_period_rd_count.Кол_р_дней ССР_м3
      , vt_whse_code.Код_склада
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_cal_period_rd_count
                                   ON ( 1 = 1 )
                                 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
         ( i_d_v2.trans_date BETWEEN (SELECT ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1) FROM DUAL)
                                  AND (SELECT TRUNC(SYSDATE,'MM')-1 FROM DUAL) )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_cal_period_rd_count.Кол_р_дней,
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )
  ,



    vt_pr_za_kol_dney_0 AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) / vt_cal_period_rd_count_0.Кол_р_дней ССР_0_м3
      , vt_whse_code.Код_склада
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_cal_period_rd_count_0
                                   ON ( 1 = 1 )
                                 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
          ( i_d_v2.trans_date BETWEEN trunc(SYSDATE, 'iw')-14
                                  AND trunc(SYSDATE, 'iw')-8 )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_cal_period_rd_count_0.Кол_р_дней,
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )
  ,



    vt_pr_za_kol_dney_1 AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) ССР_1_м3
      , vt_whse_code.Код_склада
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
          ( i_d_v2.trans_date = trunc(SYSDATE, 'iw')-7 )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )
  ,
    vt_pr_za_kol_dney_2 AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) ССР_2_м3
      , vt_whse_code.Код_склада
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
          ( i_d_v2.trans_date = trunc(SYSDATE, 'iw')-6 )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )
  ,
    vt_pr_za_kol_dney_3 AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) ССР_3_м3
      , vt_whse_code.Код_склада
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
          ( i_d_v2.trans_date = trunc(SYSDATE, 'iw')-5 )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )
  ,
    vt_pr_za_kol_dney_4 AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) ССР_4_м3
      , vt_whse_code.Код_склада
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
          ( i_d_v2.trans_date = trunc(SYSDATE, 'iw')-4 )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )
  ,
    vt_pr_za_kol_dney_5 AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) ССР_5_м3
      , vt_whse_code.Код_склада
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
          ( i_d_v2.trans_date = trunc(SYSDATE, 'iw')-3 )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )

,
    vt_pr_za_kol_dney_6 AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) ССР_6_м3
      , vt_whse_code.Код_склада
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
          ( i_d_v2.trans_date = trunc(SYSDATE, 'iw')-2 )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )

,
    vt_pr_za_kol_dney_7 AS
    (
    SELECT /*+ full(i_d_v2) no_merge use_hash(i_d_v2 vt_catalog_tovara_kdw_other_16) use_hash(i_d_v2 vt_whse_code) */
      vt_catalog_tovara_kdw_other_16.Артикул,
      SUM((i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) * (vt_catalog_tovara_kdw_other_16.Объём_см3) / (1000000)) ССР_7_м3
	  , vt_whse_code.Код_склада
      
    FROM
      KDW.DWE_ITEM_DIV_M2 i_d_v2 JOIN vt_whse_code
                                   ON (i_d_v2.WHSE_CODE = vt_whse_code.Код_склада )
                                 JOIN vt_catalog_tovara_kdw_other_16
                                   ON ( i_d_v2.ITEM_NUM = vt_catalog_tovara_kdw_other_16.Артикул )
                                 JOIN KDW.DWE_WHSE M2_WHSE
                                   ON ( i_d_v2.WHSE_CODE = M2_WHSE.WHSE_CODE )
                      LEFT OUTER JOIN KDW.DWE_WHSE WHSE_CUST
                                   ON ( i_d_v2.CUST_NUM = WHSE_CUST.WHSE_CODE )
    WHERE
          ( i_d_v2.trans_date = trunc(SYSDATE, 'iw')-1 )
      AND (
          /* 1. Клиентская отгрузка */
          i_d_v2.MOVE_TYPE IN (4,5,9) OR i_d_v2.CAUSE_CODE = '0060' AND i_d_v2.TRANS_DATE < TO_DATE('01.06.2010','DD.MM.YYYY') OR
          /* 2. ВП на склады региона Москва типа 3,4  */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') IN ('0') AND NVL(WHSE_CUST.WHSE_TYPE, 3) IN (3,4) OR
          /* 3. ВП на склады не региона Москва */
          i_d_v2.MOVE_TYPE IN (2) AND NVL(WHSE_CUST.TERR_CODE, '0') NOT IN ('0')
          )
    GROUP BY
      vt_catalog_tovara_kdw_other_16.Артикул
	  , vt_whse_code.Код_склада
    HAVING
      SUM(i_d_v2.KOLR_BAR + i_d_v2.KOLR_BNUL + i_d_v2.KOLR_NUL + i_d_v2.KOLR_PRO + i_d_v2.KOLR_VNUT) > 0
    )






  SELECT
    vt_catalog_tovara_kdw_other_16.Артикул,
    vt_catalog_tovara_kdw_other_16.Название_товара,
    vt_catalog_tovara_kdw_other_16.Ед_изм,
    vt_catalog_tovara_kdw_other_16.Код_ТР,
    vt_catalog_tovara_kdw_other_16.Название_ТР,
    vt_catalog_tovara_kdw_other_16.Признак_категория,
    vt_catalog_tovara_kdw_other_16.СОХ,
    vt_catalog_tovara_kdw_other_16.ХСЗ,
    vt_catalog_tovara_kdw_other_16.Объём_см3,
	vt_catalog_tovara_kdw_other_16.Код_склада,
    
    vt_abc.ABC_по_объёму,
    vt_abc.ABC_по_себ_руб,
    
    vt_catalog_tovara_kdw_other_16.Название_ТН,
    vt_catalog_tovara_kdw_other_16.Название_ТК,
    vt_catalog_tovara_kdw_other_16.Название_ТГ,
    vt_catalog_tovara_kdw_other_16.Название_АГ,
    vt_catalog_tovara_kdw_other_16.Название_группы_5,
    vt_catalog_tovara_kdw_other_16.Название_группы_6,
    
    vt_catalog_tovara_kdw_other_16.Название_байера,
    vt_catalog_tovara_kdw_other_16.Название_КМ,
    
    logist.Код_поставщика,
    logist.Название_поставщика,
    logist.Код_факт_поставщика,
    logist.Название_факт_поставщика,
    logist.Код_МЛ,
    logist.Название_МЛ,
    
    logist.СП_ЧКЗ,
    
    logist.МТП,
    logist.Форма_снабжения,
    
    vt_catalog_tovara_kdw_other_16.Название_признака_1,
    vt_catalog_tovara_kdw_other_16.Значение_признака_1,
    
    vt_tov_zap.Кол_дней_Ср_ТЗ,
    vt_tov_zap.Ср_ТЗ_в_наличии_м3,
    vt_tov_zap.Ср_ТЗ_выделено_м3,
    vt_tov_zap.Ср_ТЗ_свободно_м3,
    
    vt_tov_zap_0.Кол_дней_Ср_ТЗ_0,
    vt_tov_zap_0.Ср_ТЗ_в_наличии_0_м3,
    vt_tov_zap_0.Ср_ТЗ_выделено_0_м3,
    vt_tov_zap_0.Ср_ТЗ_свободно_0_м3,
    
    vt_tov_zap_1.Ср_ТЗ_в_наличии_1_м3,
    vt_tov_zap_1.Ср_ТЗ_выделено_1_м3,
    vt_tov_zap_1.Ср_ТЗ_свободно_1_м3,
    
    vt_tov_zap_2.Ср_ТЗ_в_наличии_2_м3,
    vt_tov_zap_2.Ср_ТЗ_выделено_2_м3,
    vt_tov_zap_2.Ср_ТЗ_свободно_2_м3,
    
    vt_tov_zap_3.Ср_ТЗ_в_наличии_3_м3,
    vt_tov_zap_3.Ср_ТЗ_выделено_3_м3,
    vt_tov_zap_3.Ср_ТЗ_свободно_3_м3,
    
    vt_tov_zap_4.Ср_ТЗ_в_наличии_4_м3,
    vt_tov_zap_4.Ср_ТЗ_выделено_4_м3,
    vt_tov_zap_4.Ср_ТЗ_свободно_4_м3,
    
    vt_tov_zap_5.Ср_ТЗ_в_наличии_5_м3,
    vt_tov_zap_5.Ср_ТЗ_выделено_5_м3,
    vt_tov_zap_5.Ср_ТЗ_свободно_5_м3,
	
	
	vt_tov_zap_6.Ср_ТЗ_в_наличии_6_м3,
    vt_tov_zap_6.Ср_ТЗ_выделено_6_м3,
    vt_tov_zap_6.Ср_ТЗ_свободно_6_м3,
	
	vt_tov_zap_7.Ср_ТЗ_в_наличии_7_м3,
    vt_tov_zap_7.Ср_ТЗ_выделено_7_м3,
    vt_tov_zap_7.Ср_ТЗ_свободно_7_м3,
    
    vt_pr_za_kol_dney.ССР_м3,
    vt_pr_za_kol_dney_0.ССР_0_м3,
    vt_pr_za_kol_dney_1.ССР_1_м3,
    vt_pr_za_kol_dney_2.ССР_2_м3,
    vt_pr_za_kol_dney_3.ССР_3_м3,
    vt_pr_za_kol_dney_4.ССР_4_м3,
    vt_pr_za_kol_dney_5.ССР_5_м3,
	vt_pr_za_kol_dney_6.ССР_6_м3,
	vt_pr_za_kol_dney_7.ССР_7_м3
  FROM
    vt_catalog_tovara_kdw_other_16,
	logist,
    vt_tov_zap,
    vt_tov_zap_0,
    vt_tov_zap_1,
    vt_tov_zap_2,
    vt_tov_zap_3,
    vt_tov_zap_4,
    vt_tov_zap_5,
	vt_tov_zap_6,
	vt_tov_zap_7,
    vt_pr_za_kol_dney,
    vt_pr_za_kol_dney_0,
    vt_pr_za_kol_dney_1,
    vt_pr_za_kol_dney_2,
    vt_pr_za_kol_dney_3,
    vt_pr_za_kol_dney_4,
    vt_pr_za_kol_dney_5,
	vt_pr_za_kol_dney_6,
	vt_pr_za_kol_dney_7,
    vt_abc,
	vt_whse_code
  WHERE
        ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap.Артикул(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = logist.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap_0.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap_1.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap_2.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap_3.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap_4.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap_5.Артикул(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap_6.Артикул(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_tov_zap_7.Артикул(+) )
	
	AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap_0.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap_1.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap_2.Код_склада(+))
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap_3.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap_4.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap_5.Код_склада(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap_6.Код_склада(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_tov_zap_7.Код_склада(+) )
	
	
	
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney_0.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney_1.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney_2.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney_3.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney_4.Артикул(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney_5.Артикул(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney_6.Артикул(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_pr_za_kol_dney_7.Артикул(+) )
	
	AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney_0.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney_1.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney_2.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney_3.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney_4.Код_склада(+) )
    AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney_5.Код_склада(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney_6.Код_склада(+) )
	AND ( vt_catalog_tovara_kdw_other_16.Код_склада = vt_pr_za_kol_dney_7.Код_склада(+) )
	
	
    AND ( vt_catalog_tovara_kdw_other_16.Артикул = vt_abc.Артикул(+) )
  ) a,
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
  (
-----------------------------------------------------
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
  (SELECT /*блок заказов*/
      SPEC_ITEM.ITEM_NUM, SPEC_CAL.CAL_DATE prih,
      SUM((SPEC_L.REQ_QTY)) - SUM((SPEC_L.IN_PO_QTY)) tvp,
      '1' sts, SPEC_L.spec_id, sd.CAL_DATE ds, 1 lev
     FROM KDW.DWD_ITEM SPEC_ITEM, KDW.DWF_SPEC_L SPEC_L,
          KDW.DWD_CALENDAR SPEC_CAL,
          KDW.DWD_SPEC_OTHER SPEC_OTHER,
          KDW.DWD_DIVISION SPEC_L_DIV_WHSE,
          KDW.DWD_SPEC_PO SPEC_PO, whs_spis wh,
          KDW.DWD_CALENDAR sd
    WHERE (SPEC_PO.ID_PERFORM_DATE = SPEC_CAL.ID_DATE)
      AND (SPEC_ITEM.ID_ITEM = SPEC_L.ID_ITEM)
      AND (SPEC_L.ID_SPEC_PO = SPEC_PO.ID_SPEC_PO)
      AND (SPEC_L.ID_SPEC_OTHER =
          SPEC_OTHER.ID_SPEC_OTHER)
      AND EXISTS
        (SELECT 1 
           FROM kdw.dwd_spec_other so
           WHERE so.id_spec_other = SPEC_L.ID_SPEC_OTHER 
             AND so.is_spec_line = 'Y'
        )
      AND (SPEC_L_DIV_WHSE.ID_DIV = SPEC_L.ID_DIV_WHSE)
      AND (SPEC_OTHER.SHIP_FLAG = '0' AND
          SPEC_CAL.CAL_DATE > SYSDATE - 90 AND
          SPEC_L_DIV_WHSE.DIV_CODE = wh.whse_code)
      AND SPEC_L.ID_SPEC_DATE = sd.ID_DATE
    GROUP BY SPEC_ITEM.ITEM_NUM, SPEC_CAL.CAL_DATE,
             SPEC_L.spec_id, sd.CAL_DATE
    HAVING SUM((SPEC_L.REQ_QTY)) - SUM((SPEC_L.IN_PO_QTY)) > 0
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
and a.region=0
and ( g_item_g.ITEM_NUM=b.ITEM_NUM  )
AND (g_rates2.RATE_DATE =trunc(SYSDATE) AND g_rates2.CURR_CODE='USD'  )
  AND  ( g_ph.ITEM_NUM=b.ITEM_NUM AND TRUNC(SYSDATE) BETWEEN g_ph.B_DATE AND g_ph.e_date  )
  
  
  )
  
  group by 
  item_num
-----------------------------------------------------
  ) b
WHERE
  ( a.Артикул = b.item_num(+) )
 vt_pd_pik as (
	SELECT
    dwf_int_m_d_all.ID_STAT_DATE ID_Даты_отчёта,
    dwf_int_m_d_all.ITEM_NUM Артикул,
    vt_whse_code.Код_склада,
	dwf_int_m_d_all.MOVE_QTY,
	dwf_int_m_d_all.ADJ_QTY
  FROM
    KDW.DWF_ITN_MAIN_DATA_ALL dwf_int_m_d_all,
    vt_01_max_dual_id_date_002,
    vt_cal_period_rd,
    vt_cal_period_rd_count,
    vt_whse_code
  WHERE
        ( dwf_int_m_d_all.ID_STAT_DATE = vt_01_max_dual_id_date_002.ID_Даты_2 )
    AND ( dwf_int_m_d_all.ID_DATE = vt_cal_period_rd.ID_Даты )
    AND ( dwf_int_m_d_all.ID_WHSE = vt_whse_code.ID_Кода_склада )
	AND ( dwf_int_m_d_all.MOVE_QTY<>dwf_int_m_d_all.ADJ_QTY )
--     AND ( dwf_int_m_d_all.ITEM_NUM = '120' )
				
  
				
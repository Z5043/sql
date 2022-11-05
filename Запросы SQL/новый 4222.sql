SELECT distinct
  CONCAT(YEAR(n_m.push_date), '_', MONTH(n_m.push_date)) Год_месяц,
  n_m.push_date Дата_нажатия,
  n_m.user_name Код_пользователя,
  n_m.item_num Артикул,
  n_m.item_name Название_товара,
  n_m.qty К_во_товара_ед_изм,
  n_m.s_qty К_во_товара_сумм_ед_изм,
  n_m.whse_num Код_склада_отгрузки,
  n_m.decision Комментарий_решения,
  n_m.decision2 Комментарий_решения2,
  n_m.decision3 Комментарий_решения3,
  n_m.id ID_строки_таблицы,
  n_m.b Код_комментария_решения,
  n_m.sl Признак_наличия_в_стоплисте,
  n_m.som Доступность_ЦС,
  n_m.avg_rem_3m Ср_остаток_ЦС,
  
  ir.logist,
  ir.Vendor_name Поставщик,
  ir.lead_time Срок_поставки,
  ir.ind_category Категория,
  
  tvp3.qty ЗП_ст3_кол_во,
  tvp2.qty ЗП_ст2_кол_во,
  
  case when tvp3.date_r is null then tvp2.date_r else tvp3.date_r end Дата_прихода,
  case when tvp3.imp is null then tvp2.imp else tvp3.imp end Импорт,
  
  tvp0.qty Ожидаемый_приход,
  
  sl.prich Причина_стоплист,
  sl.date_z Дата_окончания_стоплист
 
FROM
  SERVERUS.nika_m n_m
LEFT JOIN SERVERUS.item_ref ir on n_m.item_num = ir.item_num
LEFT JOIN SERVERUS.stoplist sl on n_m.item_num=sl.item_num and n_m.push_date BETWEEN sl.date_n and sl.date_z
LEFT JOIN (SELECT  
	t.dh, 
	t.ITEM_NUM,
	SUM(t.qty) qty,
	t.region,
	MAX(t.date_r) date_r,
	t.imp
  FROM 
	SERVERUS.tvpa t
  where 
	t.lev='4' 
  and t.sts='3'
  GROUP BY 
	t.dh, 
	t.spec_id,
	t.spec_l_id,
	t.ITEM_NUM,
	t.region,
	t.imp) tvp3 on tvp3.item_num = n_m.item_num and date_format(n_m.push_date, "%Y-%m-%d" )=tvp3.dh  and tvp3.region=n_m.region
LEFT JOIN (SELECT 
	t.dh,
	t.ITEM_NUM,
	SUM(t.qty) qty,
	t.region,
	MAX(t.date_r) date_r,
	t.imp
  FROM 
	SERVERUS.tvpa t 
  where
	t.lev='4' 
  and t.sts='2'
   GROUP BY 
	t.dh, 
	t.spec_id,
	t.spec_l_id,
	t.ITEM_NUM,
	t.region,
	t.imp) tvp2 on tvp2.item_num = n_m.item_num and date_format(n_m.push_date, "%Y-%m-%d" )=tvp2.dh and tvp2.region=n_m.region
LEFT JOIN (	SELECT  
	t.dh, 
	t.ITEM_NUM,
	SUM(t.qty) qty,
	t.region,
	MAX(t.date_r) date_r,
	t.imp
  FROM 
	SERVERUS.tvpa t
  where 
	t.lev='4'
	and t.sts not in  ('3', '2')
  GROUP BY 
 	t.dh,
	t.spec_id,
	t.spec_l_id,
	t.ITEM_NUM,
	t.imp,
	t.region) tvp0 on tvp0.item_num = n_m.item_num and date_format(n_m.push_date, "%Y-%m-%d" )=tvp0.dh  and tvp0.region=n_m.region	
WHERE
    ( n_m.push_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')
                          AND str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y') )
	AND ( n_m.user_name NOT IN ('liv64') )
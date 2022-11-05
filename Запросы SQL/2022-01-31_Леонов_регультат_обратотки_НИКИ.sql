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
  n_m.b Код_комментария_решения
FROM
  SERVERUS.nika_m n_m
WHERE
      ( n_m.push_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')
                          AND str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y') )
  AND ( n_m.user_name NOT IN ('liv64') )
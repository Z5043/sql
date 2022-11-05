	 select 
	 DISTINCT
	 vt_date_min.Артикул,
	 vt_date_min.Мин_дата,
	 count(*)
from vt_date_min
where vt_date_min.ПР_ПД='1'
GROUP by  vt_date_min.Артикул,
	 vt_date_min.Мин_дата
select
r.reg_name,
substr(t.year_week,6,2) as week,
t.dep as 'Всего',
t2.dep as '0HQ',
t.COMMITTED_QTY/1000000 as 'Резерв в руб всего',
t2.COMMITTED_QTY/1000000 as 'Резерв в руб  0HQ',
t.oh_vlm as 'Запас в м3 всего',
t2.oh_vlm as 'Запас в м3 0HQ',
t.ON_HAND/1000000 as 'Запаса в руб всего',
t2.ON_HAND/1000000 as 'Запаса в руб 0HQ',
t.com_vlm as 'Резерв в м3 всего',
t2.com_vlm as 'Резерв в м3 0HQ',
t.wdate,
t.id,
t.region,
t.year_week,
t2.com_vlm/t.com_vlm as 'Доля резерва в м3',
t2.ON_HAND/t.ON_HAND as 'Доля запаса в руб',
t2.oh_vlm/t.oh_vlm as 'Доля запаса в м3',
t2.COMMITTED_QTY/t.COMMITTED_QTY as 'Доля резерва в руб '
from
(select * from stock where dep = '0' and year(wdate)>=year(current_date)-2) t
join 
(select * from stock where dep = '1' and year(wdate)>=year(current_date)-2) t2
on t.wdate = t2.wdate and t.region = t2.region
left join 
(select * from regions) r
 on r.region=t.region 
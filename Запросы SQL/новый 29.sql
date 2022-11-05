Select item_num, whse_group, sum(zak) as zak, sum(zp) as zp from 
(
select item_num, sum(qty) as zak, 0 as zp
from tvp
where 
region=0
and lev=1
group by item_num
union all
select item_num, 0 as zak, sum(qty) as zp
from tvp
where 
region=0
and lev=4
group by item_num
) 
as a

left join 
(Select item_num as num, skl_osn from item_ref)
as w on a.item_num=w.num

left join 
(select whse_num, whse_group from whse)
as g on g.whse_num=w.skl_osn



group by item_num, whse_group
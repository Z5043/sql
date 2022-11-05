select 
str_to_date(a.e_date,'%d.%m.%Y') as e_date, a.id, b.order_num, b.item_num, b.m_div, b.ordered_qty, b.deal_limit, c.ord2, c.item_num2, c.div2, c.order2, c.limit2, c.bayer_comment,
d.ord3, d.item_num3, d.div3, d.order3, d.limit3, d.logist_comment, b.svb, b.ad_comment, q.ord4, q.item_num4, q.div4, q.order4,
q.limit4, q.ssc_id4, q.svb4, q.ad_comment4, q.orl_comment4, q.auto_comment4,
w.ord5, w.item_num5, w.div5, w.order5,
w.limit5, w.ssc_id5, w.svb5, w.ad_comment5, w.orl_comment5,
b.ssc_id1,
c.ssc_id2,
d.ssc_id3,
e.ord6, e.item_num6, e.div6, e.order6, e.limit6,  e.ssc_id6, 
e.svb6, e.ad_comment6, e.orl_comment6, e.auto_comment6, e.div_code6, e.ind_category6, e.imp6,
e.LEAD_TIME6, e.STOCK_CONTROL6, e.b6, e.CROSS_DOCKING6, e.whse_code6, e.item_name6, e.unit6, e.m_msk6

from 
(
select date_format(e_date,'%d.%m.%Y') as e_date,  ssc_id from ssc_l  
where 
 e_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y')  

) as z
left join
(
select date_format(e_date,'%d.%m.%Y') as e_date, count(ssc_id) as id from ssc_l  
where 
 e_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y')  
group by date_format(e_date,'%d.%m.%Y')
) as a on z.e_date = a.e_date 
left join
(
select date_format(e_date,'%d.%m.%Y') as e_date, order_num, item_num, m_div, ordered_qty, deal_limit, on_hand_msk-committed_qty_msk as svb, ad_comment, ssc_id as ssc_id1
from 
ssc_l
where
e_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y')  
and segment is null
and orl_comment = 'Выделено в объёме'
) as b on z.e_date = b.e_date and z.ssc_id=b.ssc_id1
left join
(
select date_format(e_date,'%d.%m.%Y') as e_date, order_num as ord2, item_num as item_num2, m_div as div2, ordered_qty as order2, deal_limit as limit2, bayer_comment,ssc_id as ssc_id2
from 
ssc_l
where
segment is null
and e_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y')  
and orl_comment in ('Выделено в полном объёме' , 'Выделено в объёме')
and bayer_comment is not null
) as c on z.e_date = c.e_date and z.ssc_id=c.ssc_id2

left join
(
select date_format(e_date,'%d.%m.%Y') as e_date, order_num as ord3, item_num as item_num3, m_div as div3, ordered_qty as order3, deal_limit as limit3, logist_comment,ssc_id as ssc_id3
from 
ssc_l
where
/*segment is null*/
 e_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y')  
and orl_comment in ('Выделено в полном объёме' , 'Выделено в объёме' , 'Выделено в максимальном объёме, свободный остаток исчерпан')
and logist_out is not null
) as d on z.e_date = d.e_date and z.ssc_id=d.ssc_id3



left join
(
select date_format(e_date,'%d.%m.%Y') as e_date, order_num as ord4, item_num as item_num4, m_div as div4, ordered_qty as order4, deal_limit as limit4,  ssc_id as ssc_id4, deal_limit as deal4, on_hand_msk-committed_qty_msk as svb4, ad_comment as ad_comment4, orl_comment as orl_comment4, auto_comment as auto_comment4
from 
ssc_l
where
segment is not null
and e_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y')  
) as q on z.e_date = q.e_date and z.ssc_id=q.ssc_id4

left join
(
select date_format(e_date,'%d.%m.%Y') as e_date, order_num as ord5, item_num as item_num5, m_div as div5, ordered_qty as order5, deal_limit as limit5,  ssc_id as ssc_id5, deal_limit as deal5, on_hand_msk-committed_qty_msk as svb5, ad_comment as ad_comment5, orl_comment as orl_comment5
from 
ssc_l
where
/*segment is not null*/
orl_comment in (
'Cтатус заказа в использовании',
'Cтатус заказа задержан',
'Cтатус заказа маркетинговый',
'Cтатус заказа отменен',
'Нет товара на ЦС',
'Отсутствие данной позиции в заказе',
'Строка обеспечена по транзитной технологии',
'Строка обеспечена ранее',
'Строка передана в ТС'
)
and e_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y')  
) as w on z.e_date = w.e_date and z.ssc_id=w.ssc_id5

left join
(
select date_format(e_date,'%d.%m.%Y') as e_date, order_num as ord6, item_num as item_num6, m_div as div6, ordered_qty as order6, deal_limit as limit6,  ssc_id as ssc_id6, 
on_hand_msk-committed_qty_msk as svb6, ad_comment as ad_comment6, orl_comment as orl_comment6, auto_comment as auto_comment6, div_code as div_code6, ind_category as ind_category6, imp as imp6,
LEAD_TIME as LEAD_TIME6, STOCK_CONTROL as STOCK_CONTROL6, b as b6, CROSS_DOCKING as CROSS_DOCKING6, whse_code as whse_code6, item_name as item_name6, unit as unit6, m_msk as m_msk6

from 
ssc_l
where
segment is  null
and auto_comment in (
'Выделить в счёт'
)
and e_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y')  
) as e on z.e_date = e.e_date and z.ssc_id=e.ssc_id6
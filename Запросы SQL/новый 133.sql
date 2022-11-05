SELECT
	
	o.item_num,
	o.item_name,
	h.public_num,
	o.units,
	h.ship_period,
From arb_h h, arb_s s, arb_o o, arb_s ar
where 
	h.public_num=o.public_num
	and h.public_num=ar.public_num
	and h.public_num=s.public_num
	And s.status in ('4','6')
	AND (ar.status_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   
							AND str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y') and ar.status='1' ) 

SELECT
	s.status_resp_person,
	o.auto_comment,
	count(*),
	h.public_num
From arb_h h, arb_s s, arb_o o, arb_s ar
where 
	h.public_num=ar.public_num
	and h.public_num=o.public_num
	and h.public_num=s.public_num
	and left(h.public_num,1) in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '_')
	And s.status in ('4','6')
	AND (ar.status_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   
							AND str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y') and ar.status='1' ) 
group by 
s.status_resp_person, o.auto_comment


-------------------------------



SELECT
	s.status_resp_person,
	o.auto_comment,
	count(*)
From arb_as h, arb_s s, arb_o o, arb_s ar 
where 
	h.public_num=ar.public_num
	and h.public_num=o.public_num
	and h.public_num=s.public_num
	and left(h.public_num,1) in ('0','1','2','3','4','5','6','7','8','9','_')
	And s.status in ('4','6')
	AND (ar.status_date BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   
							AND str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y') and ar.status='1' ) 
group by 
s.status_resp_person, o.auto_comment
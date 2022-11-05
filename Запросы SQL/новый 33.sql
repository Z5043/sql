select a.* , u.name  as Заказчик,
a.number as Номер_заявки,
ifnull(concat(s.lastname, " ", s.firstname), '0_Неназначено')  as Аналитик,
t.subject as Тема,
t.datestart as Дата_начала,
STR_TO_DATE(t.datestart, '%Y-%m-%d %H:%i:%S MSK') as Дата_начала2,  
t.plan  as В_план,
t.Otchet as В_отчет,
t.target as Target,
t.times as Срок,
l.stdat Дата_регистрации,
/*ticketos.fnStripTags(l.body) as Ответы,*/
x.name as Текущий_статус,
l.stcom as Описание_задачи,
l.encom as Ответ_аналитика,
l.endat as Дата_ответа,
concat('<a href="', concat('http://logistics.komus.net/ticketos/scp/tickets.php?id=',a.ticket_id) ,'">Ссылка</a>') as Ссылка_в_Ticketos

from 

ticketos. ost_ticket a
left join ticketos.ost_staff s on  a.staff_id=s.staff_id 
left join ticketos.ost_ticket__cdata t on a.ticket_id=t.ticket_id,
ticketos.ost_user u,
ticketos.ost_thread m,
ticketos.ost_ticket_status x,



(select 

ticketos.fnStripTags(c.body) as stcom, 
ticketos.fnStripTags(d.body) as encom, 
c.created as stdat,
d.created as endat,
b.thread_id

from

(
select sum(minid) as minid,  sum(maxid) as maxid, thread_id
from
(
select 0 as minid, max(id) as maxid, thread_id
from ticketos.ost_thread_entry /*where thread_id=134*/
group by thread_id

union 

select min(id) as minid, 0 as maxid, thread_id 
from ticketos.ost_thread_entry /*where thread_id=134*/
group by thread_id
)a 

group by 
thread_id
)b, 
ticketos.ost_thread_entry c,
ticketos.ost_thread_entry d

where 
b.minid=c.id
and b.maxid=d.id
) l




where a.user_id=u.id

/*and a.number=128*/
/*and a.staff_id=s.staff_id */
/*and a.ticket_id=t.ticket_id*/
and  a.ticket_id=m.object_id
and m.id=l.thread_id
and a.status_id=x.id
and (x.id in (1, 7, 8, 9, 10)
or l.endat BETWEEN str_to_date((@Prompt('1. Дата начала периода','A',,mono,free)),'%d.%m.%Y')   AND  DATE_ADD(str_to_date((@Prompt('2. Дата окончания периода','A',,mono,free) ),'%d.%m.%Y'), INTERVAL 1 DAY)  )


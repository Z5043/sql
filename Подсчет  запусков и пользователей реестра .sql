select
	shells.fin_trl_name 'Финальное название (транслит)',
	shells.grp_name 'Группа отчётов' ,
	shells.query_num 'Общее число запросов',
	shells.sql_query 'SQL запрос', 
	shells.datasource 'Источник данных', 
	shells.shell 'id отчёта',
	shells.ispolnitel 'Разработчик',	
	tt2.kol_vhod 'Частота обращения',
	tt.kol_vhod_byuser 'Количество уникальных пользователей'
from shells
left join 
	( SELECT t.shell_name, sum(t.kol_vh) kol_vhod_old, COUNT(t.user_id) kol_vhod_byuser 
	  from 
		( select 
    		shell_name, user_id , count(user_id) kol_vh 
		  from vm 
		  where events != 'вых'
		  group by shell_name, user_id ) t 
	  group by t.shell_name) tt
on shells.shell = tt.shell_name
left join
  ( SELECT  COUNT(t2.user_id) kol_vhod, t2.shell_name
	from 
		(select 
			user_id , shell_name ,
			DATE_FORMAT(  CONCAT(DATE_FORMAT(event_date, '%Y-%m-%d '), DATE_FORMAT(SEC_TO_TIME((TIME_TO_SEC(event_date) DIV 10) * 10), '%H:%i:%s')), '%Y-%m-%d %H:%i:%s') as event_date_unique
		from vm 
		where events != 'вых'
		group by shell_name, user_id ,event_date_unique ) t2 
	group by t2.shell_name) tt2
on shells.shell = tt2.shell_name
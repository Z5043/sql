sum(mp.pr) over (partition by mp.ABC0, mp.WHSE_CODE order by mp.pr desc ) as dolya,

case
when sum(mp.pr) over (partition by mp.ABC0, mp.WHSE_CODE order by mp.pr desc ) <= 0.8 then 'A'
when sum(mp.pr) over (partition by mp.ABC0, mp.WHSE_CODE order by mp.pr desc ) >0.95 then 'C'
else 'B'
end abc
select
   zs.item_num,
   case when  SUM(zs.MOVE_DAYS) < 50 then MAX(zs.MO_ALL) else MAX(zs.MO) end as MO,
   zs_i.ART_GL,
   @variable('Склад-получатель ВП') as WHSE_CODE
   from
   kdw.v_itn_stats zs,
   KDW.DWD_ITEM  zs_i,
   KDW.DWD_WHSE  zs_defw
   where
   zs.item_num=zs_i.item_num
   and zs_i.IS_CURRENT='Y'
   and zs.WHSE_CODE=zs_defw.GRP_COUNT
   AND zs_defw.WHSE_CODE IN @Prompt('Склад-получатель','A',,multi,free)
   AND  zs_i.item_ts  IN  ('Т06','Т15','Т16','Т33','Т35','Т32','Т61','Т62','Т63','Т64','Т65','Т66','Т67','Т68','Т69','Т70','Т44','Т45','Т46','Т50','Т51','Т54','Т55','Т56','Т57','Т58','Т59','Т78','Т79','Т80','Т81','Т82','Т83','Т84','Т85','Т86','Т87','Т91','Т92','Т93', 'Т94', 'Т96', 'Т95', 'Т97', 'Т90', 'Т98', 'Т99', 'Т10', 'Т109', 'Т110', 'Т111', 'Т107','Т112', 'Т113', 'Т114', 'Т115')
    AND zs_i.STATE  =  1
  --and zs.MOVE_DAYS >= 20
  GROUP BY 
  zs.item_num,
  zs_i.ART_GL
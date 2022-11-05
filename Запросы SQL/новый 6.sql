SELECT   
  zs_w.WHSE_CODE,
  zs.ITEM_NUM,
  zs.G,
  zs.M,
  zs.K,
  zso.ABC || '(' || zso.ts_parent || ')',
  zso.ABC_VOLUME || '(' || zso.ts_parent || ')',
  zso.ABC_COST || '(' || zso.ts_parent || ')',
  zso.MPA,
    DECODE(NVL(zs_vw.vend_whse_status, 'D'), 'D', zs_iv.VENDOR_NUM, zs_vw.VENDOR_NUM) vendor_num,
  zs_vw.period_stock_a,
  zs_vw.period_stock_b,
  zs_vw.period_stock_c,	
  s.f ,
  case 
  when s.f='1' then 3
  when zso.ABC_VOLUME='A' or zso.ABC_COST='A' then zs_vw.period_stock_a
  when zso.ABC_VOLUME='B' or zso.ABC_COST='B' then zs_vw.period_stock_b
  when zso.ABC_VOLUME='C' or zso.ABC_COST='C' then zs_vw.period_stock_c
  else zs_vw.period_stock_a
  end pp
  
  
FROM
  KDW.DWD_WHSE  zs_w,
  KDW.DWF_ZGL_STAT  zs,
  KDW.DWD_ZGL_STAT_OTHER  zso,
  KDW.DWE_MAIN_ITEM_V  zs_iv,
  KDW.DWE_MAIN_VEND_WHSE  zs_vw,
  KDW.DWD_ITEM  zs_i,
 (select SET_VALUE, 1 as f from KDW.W_SET_VALUES where set_id  =71303247) s
 /*Ñïèñîê ó Äååâà Å.  - ABCD)*/
WHERE
  ( zs.ID_ZGL_STAT_OTHER=zso.ID_ZGL_STAT_OTHER  )
  AND  ( zs.ID_ITEM=zs_i.ID_ITEM  )
  AND  (s.SET_VALUE(+)=zs.ITEM_NUM )
  AND  ( zs.ID_WHSE=zs_w.ID_WHSE  )
  AND  ( zs_iv.ITEM_NUM=zs.ITEM_NUM  )
  AND  ( zs_vw.ITEM_NUM (+) = zs.ITEM_NUM and zs_vw.ID_WHSE (+) = zs.ID_WHSE  )
  AND  (
  ( zs.id_date = (SELECT kdw.getZGLDateID FROM dual )  )
  AND  DECODE(NVL(zs_vw.vend_whse_status, 'D'), 'D', zs_iv.PROD_MANAGER, zs_vw.PROD_MANAGER)  in  @variable('Ìåíåäæåð-ëîãèñò')
  AND  DECODE(NVL(zs_vw.vend_whse_status, 'D'), 'D', TO_NUMBER(NULL), zs_vw.STOCK_CONTROL)  IS NOT NULL  
  AND  zs_i.STATE  =  1
  )
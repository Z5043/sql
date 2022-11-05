WITH 
vt_catalog_tovara_kdw_other_16 AS
    (
  SELECT   
      mvw_goods.ART_GL ��������_�������,
      mvw.ITEM_NUM �������,
      mvw_goods.ITEM_NAME ��������_������,
      mvw_goods.DIV_CODE ���_��,
      mvw_goods_TS.DIV_NAME ��������_��,
      mvw_goods.IND_CATEGORY �������_���������,
      mvw.WHSE_CODE ���_������ ,
      R_WHSE.WHSE_NAME ��������_������ ,
      mvw.SUPPLY_TYPE ���_��������,
      mvw_g_oper.USER_NAME ��������_������,
    mvw.VENDOR_NUM ���_����������,
    mvw.VENDOR_NAME ��������_����������,
    DECODE(NVL(mvw.vend_whse_status,'D'),'D',mvw_main_item_v.PROD_MANAGER,mvw.PROD_MANAGER) ���_��,
    DECODE(NVL(mvw.vend_whse_status,'D'),'D',mvw_main_item_v.PROD_MANAGER_NAME,mvw.PROD_MANAGER_NAME)  ��������_��
  FROM
    KDW.DWE_MAIN_VEND_WHSE  mvw,
    KDW.DW_GOODS  mvw_goods,
    KDW.DWD_U_OPER mvw_g_oper,
    KDW.DWD_DIVISION mvw_goods_TS,
    KDW.DWD_WHSE  R_WHSE,
    KDW.DWE_MAIN_ITEM_V mvw_main_item_v
  WHERE
    ( mvw.ITEM_NUM=mvw_goods.ITEM_NUM  )
    AND  mvw.WHSE_CODE = '0B3'
    AND  ( mvw_goods_TS.DIV_CODE = mvw_goods.DIV_CODE AND mvw_goods_TS.DIV_TYPE = 2 AND mvw_goods_TS.IS_CURRENT = 'Y' )
    AND ( mvw.VEND_WHSE_STATUS <> 'D' )
    AND mvw.SUPPLY_TYPE IN ('1','3')
    AND mvw_goods.STATE = 1
    AND mvw_goods.HSZ in ('064','�33')
    AND ( mvw_goods.bayer = mvw_g_oper.user_code(+) )
    AND R_WHSE.WHSE_CODE = mvw.WHSE_CODE
    AND ( mvw.ITEM_NUM = mvw_main_item_v.ITEM_NUM )
    )
, 
vt_catalog_tovara_kdw_other_27 as(
  SELECT   
    rel_item.MAIN_ITEM_NUM �������_�������,
    rel_goods.IND_CATEGORY �������_���������_��������,
    rel_item.SUB_ITEM_NUM �������,
    rel_sub_goods.IND_CATEGORY �������_���������_������������,
    rel_goods.ITEM_NAME ��������_������_��������,
    rel_sub_goods.ITEM_NAME ��������_������_������������,
    rel_goods.DIV_CODE ���_��,
    rel_div.DIV_NAME ��������_��,
    mvw_g_oper.USER_NAME ��������_������,
    rel_item.TAX_REGION ������,
    w.WHSE_CODE ���_������,
    rel_oper2.USER_NAME ���_����������,
    rel_item.TIME_CREATED ����_��������
  FROM
    KDW.DWD_BDT_ITEM_RELATION  rel_item,
    KDW.DW_GOODS  rel_goods,
    KDW.DW_GOODS  rel_sub_goods,
    KDW.DWD_DIVISION  rel_div,
    KDW.DWD_DIVISION  rel_sub_div,
    KDW.DWE_U_OPER  rel_oper2,
    kdw.dwe_whse w,
    KDW.DWD_U_OPER mvw_g_oper
  WHERE
    ( rel_item.SUB_ITEM_NUM=rel_sub_goods.ITEM_NUM  )
    AND  ( rel_item.MAIN_ITEM_NUM=rel_goods.ITEM_NUM  )
    AND  ( rel_div.IS_CURRENT='Y'  )
    AND  w.WHSE_CODE = '0B3'
    AND w.TERR_CODE = rel_item.TAX_REGION
    AND  ( rel_div.DIV_CODE=rel_goods.DIV_CODE  )
    AND  ( rel_item.USER_CREATED=rel_oper2.USER_CODE(+)  )
    AND  ( rel_sub_goods.DIV_CODE=rel_sub_div.DIV_CODE AND rel_sub_div.IS_CURRENT='Y'  )
    AND  ( rel_sub_div.DIV_CODE=rel_sub_goods.DIV_CODE  )
    AND  rel_item.REL_TYPE_ID  =  3
    AND  (rel_goods.IND_CATEGORY  !=  'H' OR   rel_sub_goods.IND_CATEGORY  !=  'H')
    AND rel_item.TIME_DELETED is null
    AND ( rel_sub_goods.bayer = mvw_g_oper.user_code(+) )
),
vt_table_full as
(
select 
t.������� �������,
t.���_������ ���_������
from (
    select 
    vt_catalog_tovara_kdw_other_16.������� �������, 
    vt_catalog_tovara_kdw_other_16.���_������ ���_������
    from 
    vt_catalog_tovara_kdw_other_16
    UNION 
    select 
    vt_catalog_tovara_kdw_other_27.������� �������,
    vt_catalog_tovara_kdw_other_27.���_������ ���_������
    from 
    vt_catalog_tovara_kdw_other_27) t
    
),
ostatok_vt_table as (
  SELECT  
    SUM(( ITEM_R.ON_HAND )) �_�������,
    R_WHSE.WHSE_CODE ���_������,
    R_WHSE.TERR_CODE ������,
    ITEM_R.ITEM_NUM �������
  FROM
    KDW.DWF_ITEM_R  ITEM_R,
    KDW.DWD_WHSE  R_WHSE,
    vt_table_full
  WHERE
    ITEM_R.ID_WHSE=R_WHSE.ID_WHSE
    AND  ( ITEM_R.ID_DATE = (SELECT kdw.getDateID(sysdate-1) FROM dual)  )
    AND  ( ITEM_R.ITEM_NUM = vt_table_full.�������)
    AND vt_table_full.���_������ = R_WHSE.WHSE_CODE
    AND  R_WHSE.WHSE_CODE = '0B3'
  GROUP BY
    R_WHSE.WHSE_CODE,
    ITEM_R.ITEM_NUM,
    R_WHSE.TERR_CODE
 )
,
mo_vt_table as (
  SELECT --+ MATERIALIZE
    zs.ITEM_NUM �������,
    zs.MO ��,
    zs_w.WHSE_CODE ���_������
  FROM
    kdw.DWF_ITN_STATS  zs,
    KDW.DWD_WHSE  zs_w,
    vt_table_full
  WHERE
    ( zs.ID_WHSE=zs_w.ID_WHSE  )
    AND  ( zs.id_stat_date = (SELECT kdw.getZGLDateID FROM dual )  )
    AND  ( zs.ITEM_NUM = vt_table_full.�������  )
    AND vt_table_full.���_������ = zs_w.WHSE_CODE
    AND  zs_w.WHSE_CODE = '0B3'
  )
  ,
priznak_zvp as (
  SELECT --+ MATERIALIZE
    zvp.ITEM_NUM �������,
    w.whse_code ���_������,
    case
    when zvp.VALUE='Y' then '��������'
    when zvp.VALUE='N' then '��������'
    end zvp
  FROM
    kdw.DWE_ZAPRET_VP_HISTORY zvp,
    kdw.dwe_whse w ,
    vt_table_full
  WHERE
    ( zvp.WHSE_CODE  =  w.WHSE_CODE)
    AND (sysdate-1)  BETWEEN zvp.b_date AND zvp.e_date  
    AND  w.WHSE_CODE = '0B3'
    and zvp.ITEM_NUM = vt_table_full.�������
    AND vt_table_full.���_������ = w.whse_code
  )
,
priznak_vp as (
  SELECT --+ MATERIALIZE
    KDW.DWE_ORD_TRANSFER.ITEM_NUM �������,
    KDW.DWE_ORD_TRANSFER.VALUE ��������_���_�����,
    KDW.DWE_ORD_TRANSFER.WHSE_CODE ���_������
  FROM
    KDW.DWE_ORD_TRANSFER,
    vt_table_full
  WHERE
  KDW.DWE_ORD_TRANSFER.ITEM_NUM = vt_table_full.�������
  AND vt_table_full.���_������ = KDW.DWE_ORD_TRANSFER.WHSE_CODE
    AND   KDW.DWE_ORD_TRANSFER.WHSE_CODE = '0B3'
    AND  sysdate-1 between KDW.DWE_ORD_TRANSFER.B_DATE  AND KDW.DWE_ORD_TRANSFER.E_DATE  
)


select 
vt_table_full.������� �������,
vt_catalog_tovara_kdw_other_16.��������_�������,
vt_catalog_tovara_kdw_other_16.�������_���������,
vt_catalog_tovara_kdw_other_16.�������,
vt_catalog_tovara_kdw_other_16.��������_������,
vt_catalog_tovara_kdw_other_16.���_��,
vt_catalog_tovara_kdw_other_16.��������_��,
vt_catalog_tovara_kdw_other_16.��������_������,
vt_catalog_tovara_kdw_other_16.���_��������,
vt_catalog_tovara_kdw_other_16.���_������,
vt_catalog_tovara_kdw_other_16.��������_������,
vt_catalog_tovara_kdw_other_16.���_����������,
vt_catalog_tovara_kdw_other_16.��������_����������,
vt_catalog_tovara_kdw_other_16.��������_��,


ostatok_vt_table.�_�������,

mo_vt_table.��,

priznak_zvp.zvp,

priznak_vp.��������_���_�����

from 
vt_table_full
LEFT JOIN vt_catalog_tovara_kdw_other_16 on (vt_table_full.������� = vt_catalog_tovara_kdw_other_16.�������) AND (vt_table_full.���_������ = vt_catalog_tovara_kdw_other_16.���_������)
LEFT JOIN vt_catalog_tovara_kdw_other_27 on (vt_table_full.������� = vt_catalog_tovara_kdw_other_27.�������) AND (vt_table_full.���_������ = vt_catalog_tovara_kdw_other_27.���_������)
LEFT JOIN ostatok_vt_table on (vt_table_full.������� = ostatok_vt_table.�������) AND (vt_table_full.���_������ = ostatok_vt_table.���_������)
LEFT JOIN mo_vt_table on (vt_table_full.������� = mo_vt_table.�������) AND (vt_table_full.���_������ = mo_vt_table.���_������)
LEFT JOIN priznak_zvp on (vt_table_full.������� = priznak_zvp.�������) AND (vt_table_full.���_������ = priznak_zvp.���_������)
LEFT JOIN priznak_vp on (vt_table_full.������� = priznak_vp.�������) AND (vt_table_full.���_������ = priznak_vp.���_������)
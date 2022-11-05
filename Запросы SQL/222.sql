SELECT
  a_l_o_3.PROD_MANAGER_NAME,
  a_l_o_3.item_num,
  a_l_o_3.item_name,
  a_l_o_3.IND_CATEGORY,
  a_l_o_3.SKL_OSN,
  a_l_o_3.ITEM_TS,
  a_l_o_3.vendor_num,
  a_l_o_3.VENDOR_NAME,
  
  
  a_l_o_3.public_num_a_h,
  
  a_l_o_3.units,
  a_l_o_3.logist_comment,
  a_l_o_3.qty_plan,
  a_l_o_3.date_plan,
  a_l_o_3.status_date,

  m_h_v_kp.needly_qty,
  m_h_v_kp.logist_comment,
  m_h_v_kp.qty_plan,
  m_h_v_kp.date_plan,
  m_h_v_kp.status_date,
  m_h_v_kp.allocated,
  m_h_v_kp.shipped,

  m_h_v_kp.ship_period,
  a_l_o_3.kod_region,
  a_l_o_3.REGION,
  m_h_v_kp.whse_num,

  a_l_o_3.lot_num,
  m_h_v_kp.rezult,
  
  m_h_v_kp.account_num_m_h,
  m_h_v_kp.account_num_m_v,
  a_l_o_3.max_status_date,
  a_l_o_3.max_status,
  a_l_o_3.min_status_date,
  a_l_o_3.min_status
  


  --          a_l_o_3.public_num_a_h,
  --          a_l_o_3.lot_num,
  --          a_l_o_3.kod_region,
  --          a_l_o_3.REGION,
  
  --          a_l_o_3.item_num,
  --          a_l_o_3.item_name,
  --          a_l_o_3.IND_CATEGORY,
  --          a_l_o_3.SKL_OSN,
  --          a_l_o_3.ITEM_TS,
  --          a_l_o_3.PROD_MANAGER_NAME,
  --          a_l_o_3.vendor_num,
  --          a_l_o_3.VENDOR_NAME,
  
  --          a_l_o_3.units,
  --          a_l_o_3.logist_comment,
  --          a_l_o_3.qty_plan,
  --          a_l_o_3.date_plan,
  --          a_l_o_3.status_date,
  
  --          a_l_o_3.max_status_date,
  --          a_l_o_3.max_status,
  
  --          a_l_o_3.min_status_date,
  --          a_l_o_3.min_status,
  
  

  --          m_h_v_kp.lot_num,
  --          m_h_v_kp.account_num_m_h,
  --          m_h_v_kp.ship_period,

  --          m_h_v_kp.account_num_m_v,
  --          m_h_v_kp.item_num,
  --          m_h_v_kp.whse_num,
  
  --          m_h_v_kp.kod_region,
  
  --          m_h_v_kp.needly_qty,
  --          m_h_v_kp.logist_comment,
  --          m_h_v_kp.qty_plan,
  --          m_h_v_kp.date_plan,
  --          m_h_v_kp.status_date,
  --          m_h_v_kp.allocated,
  --          m_h_v_kp.shipped,

  --          m_h_v_kp.rezult
FROM
  (
  SELECT
    -- a_h.public_num public_num_a_h,
    GROUP_CONCAT(a_h.public_num SEPARATOR ' :: ') public_num_a_h,
    
    a_h.lot_num,
    a_h.REGION kod_region,
    case a_h.REGION
    when 0 then 'Москва'
    when 1 then 'С.-Петербург'
    when 2 then 'Краснодар'
    when 3 then 'Челябинск'
    when 4 then 'Н.Новгород'
    when 5 then 'Новосибирск'
    when 6 then 'Казань'
    when 7 then 'Волгоград'
    when 8 then 'Казань'
    when 9 then 'Волгоград'
    when 10 then 'Казань'
    when 11 then 'Волгоград'
    when 12 then 'Пермь'
    when 13 then 'Омск'
    when 14 then 'Челябинск'
    else a_h.REGION end AS REGION,

    -- a_l_o_2.public_num public_num_a_l,
    a_l_o_2.item_num,
    a_l_o_2.item_name,
    a_l_o_2.IND_CATEGORY,
    a_l_o_2.SKL_OSN,
    a_l_o_2.ITEM_TS,
    a_l_o_2.PROD_MANAGER_NAME,
    a_l_o_2.vendor_num,
    a_l_o_2.VENDOR_NAME,
    
    -- a_l_o_2.units,
    -- a_l_o_2.logist_comment,
    -- a_l_o_2.qty_plan,
    -- a_l_o_2.date_plan,
    -- a_l_o_2.logist_ans,
    
    -- a_l_o_2.max_status_date,
    -- a_l_o_2.max_status,
    
    -- a_l_o_2.min_status_date,
    -- a_l_o_2.min_status

    GROUP_CONCAT(CONVERT(a_l_o_2.units, CHAR) SEPARATOR ' :: ') units,
    GROUP_CONCAT(a_l_o_2.logist_comment SEPARATOR ' :: ') logist_comment,
    GROUP_CONCAT(CONVERT(a_l_o_2.qty_plan, CHAR) SEPARATOR ' :: ') qty_plan,
    GROUP_CONCAT(a_l_o_2.date_plan SEPARATOR ' :: ') date_plan,
    GROUP_CONCAT(a_s.status_date SEPARATOR ' :: ') status_date,
    -- GROUP_CONCAT(a_l_o_2.logist_ans SEPARATOR ' :: ') logist_ans,

    GROUP_CONCAT(a_l_o_2.max_status_date SEPARATOR ' :: ') max_status_date,
    GROUP_CONCAT(CONVERT(a_l_o_2.max_status, CHAR) SEPARATOR ' :: ') max_status,

    GROUP_CONCAT(a_l_o_2.min_status_date SEPARATOR ' :: ') min_status_date,
    GROUP_CONCAT(CONVERT(a_l_o_2.min_status, CHAR) SEPARATOR ' :: ') min_status
  FROM
    arb_h AS a_h
    INNER JOIN
    (
    SELECT
      a_l_o.public_num,
      a_l_o.item_num,
      a_l_o.item_name,
      a_l_o.IND_CATEGORY,
      a_l_o.SKL_OSN,
      a_l_o.ITEM_TS,
      a_l_o.PROD_MANAGER_NAME,
      a_l_o.vendor_num,
      a_l_o.VENDOR_NAME,
      a_l_o.units,
      a_l_o.logist_comment,
      a_l_o.qty_plan,
      a_l_o.date_plan,
      -- a_l_o.logist_ans,
    
      a_l_o.max_status_date,
      a_l_o.max_status,
    
      a_l_o.min_status_date,
      a_l_o.min_status
    FROM
      (
      (
      SELECT
        a_l.public_num,
        a_l.item_num,
        a_l.item_name,
        a_l.IND_CATEGORY,
        a_l.SKL_OSN,
        a_l.ITEM_TS,
        a_l.PROD_MANAGER_NAME,
        a_l.vendor_num,
        a_l.VENDOR_NAME,
        
        a_l.units,
        a_l.logist_comment,
        a_l.qty_plan,
        a_l.date_plan,
        -- a_l.logist_ans,

        MAX(a_s.status_date) max_status_date,
        MAX(a_s.status) max_status,
    
        MIN(a_s.status_date) min_status_date,
        MIN(a_s.status) min_status
      FROM
        SERVERUS.arb_l a_l,
        (
        SELECT
          a_s_beg.public_num,
          a_s_beg.status,
          MAX(a_s_beg.status_date) status_date
        FROM
          SERVERUS.arb_s a_s_beg
        GROUP BY
          a_s_beg.public_num,
          a_s_beg.status
        ) a_s
       
      WHERE
              a_l.public_num = a_s.public_num
        AND ((a_s.status = 1) OR (a_s.status = 3) OR (a_s.status = 4) OR (a_s.status = 5))
      GROUP BY
        a_l.public_num,
        a_l.item_num,
        a_l.item_name,
        a_l.IND_CATEGORY,
        a_l.SKL_OSN,
        a_l.ITEM_TS,
        a_l.PROD_MANAGER_NAME,
        a_l.vendor_num,
        a_l.VENDOR_NAME,
        a_l.units,
        a_l.logist_comment,
        a_l.qty_plan,
        a_l.date_plan
        -- a_l.logist_ans
      )
      UNION ALL
      (
      SELECT
        a_o_2.public_num,
        a_o_2.item_num,
        a_o_2.item_name,
        a_o_2.IND_CATEGORY,
        a_o_2.SKL_OSN,
        a_o_2.ITEM_TS,
        a_o_2.PROD_MANAGER_NAME,
        a_o_2.vendor_num,
        a_o_2.VENDOR_NAME,
        a_o_2.units,
        a_o_2.logist_comment,
        a_o_2.qty_plan,
        a_o_2.date_plan,
        -- a_o_2.logist_ans,
    
        a_o_2.max_status_date,
        a_o_2.max_status,
    
        a_o_2.min_status_date,
        a_o_2.min_status
      FROM
        (
        SELECT
          a_o.public_num,
          a_o.item_num,
          a_o.item_name,
          a_o.IND_CATEGORY,
          a_o.SKL_OSN,
          a_o.ITEM_TS,
          a_o.PROD_MANAGER_NAME,
          a_o.vendor_num,
          a_o.VENDOR_NAME,
          
          a_o.units,
          a_o.logist_comment,
          a_o.qty_plan,
          a_o.date_plan,
          -- a_o.logist_ans,

          MAX(a_s.status_date) max_status_date,
          MAX(a_s.status) max_status,
    
          MIN(a_s.status_date) min_status_date,
          MIN(a_s.status) min_status
        FROM
          SERVERUS.arb_o a_o,
        (
        SELECT
          a_s_beg.public_num,
          a_s_beg.status,
          MAX(a_s_beg.status_date) status_date
        FROM
          SERVERUS.arb_s a_s_beg
        GROUP BY
          a_s_beg.public_num,
          a_s_beg.status
        ) a_s
          
        WHERE
                a_o.public_num = a_s.public_num
          AND ((a_s.status = 1) OR (a_s.status = 6))
        GROUP BY
          a_o.public_num,
          a_o.item_num,
          a_o.item_name,
          a_o.IND_CATEGORY,
          a_o.SKL_OSN,
          a_o.ITEM_TS,
          a_o.PROD_MANAGER_NAME,
          a_o.vendor_num,
          a_o.VENDOR_NAME,
          a_o.units,
          a_o.logist_comment,
          a_o.qty_plan,
          a_o.date_plan
          -- a_o.logist_ans
        ) a_o_2
    
      WHERE
        a_o_2.max_status = 6
      )
      ) a_l_o
    
    ) AS a_l_o_2 ON a_h.public_num = a_l_o_2.public_num
    LEFT JOIN (
              SELECT
                ar_s.public_num,
                MAX(ar_s.status_date) status_date
              FROM
                SERVERUS.arb_s ar_s
              WHERE
                ar_s.status = 4
              GROUP BY
                ar_s.public_num
              ) AS a_s ON a_h.public_num = a_s.public_num
  GROUP BY
    -- a_h.public_num public_num_a_h,
    a_h.lot_num,
    a_h.REGION,

    -- a_l_o_2.public_num public_num_a_l,
    a_l_o_2.item_num,
    a_l_o_2.item_name,
    a_l_o_2.IND_CATEGORY,
    a_l_o_2.SKL_OSN,
    a_l_o_2.ITEM_TS,
    a_l_o_2.PROD_MANAGER_NAME,
    a_l_o_2.vendor_num,
    a_l_o_2.VENDOR_NAME

  ) a_l_o_3,

  (
  SELECT
    -- m_h.zgl_id zgl_id_m_h,
    m_h.lot_num,
    m_h.account_num account_num_m_h,
    m_h.ship_period,
    
    -- m_v.zgl_id zgl_id_m_v,
    m_v.account_num account_num_m_v,
    m_v.item_num,
    m_v.whse_num,
    
    w.reg_shp kod_region,
    
    -- MAX(m_v.logist_comment) logist_comment,
    -- SUM(m_v.qty_plan) qty_plan,
    -- MAX(m_v.date_plan) date_plan,

    -- SUM(m_v.allocated) allocated,
    -- SUM(m_v.shipped) shipped,

    GROUP_CONCAT(CONVERT(m_v.needly_qty, CHAR) SEPARATOR ' :: ') needly_qty,
    GROUP_CONCAT(m_v.logist_comment SEPARATOR ' :: ') logist_comment,
    GROUP_CONCAT(CONVERT(m_v.qty_plan, CHAR) SEPARATOR ' :: ') qty_plan,
    GROUP_CONCAT(m_v.date_plan SEPARATOR ' :: ') date_plan,
    GROUP_CONCAT(m_s.status_date SEPARATOR ' :: ') status_date,
    GROUP_CONCAT(CONVERT(m_v.allocated, CHAR) SEPARATOR ' :: ') allocated,
    GROUP_CONCAT(CONVERT(m_v.shipped, CHAR) SEPARATOR ' :: ') shipped,
    
    kp.rezult
  FROM
    SERVERUS.mer_h AS m_h INNER JOIN SERVERUS.mer_v AS m_v ON m_h.zgl_id = m_v.zgl_id
                          INNER JOIN SERVERUS.kp AS kp ON m_h.lot_num = kp.lot_num
                          INNER JOIN SERVERUS.whse AS w ON m_v.whse_num = w.whse_num
                          LEFT JOIN (
                                    SELECT
                                      ms.zgl_id,
                                      MAX(ms.status_date) status_date
                                    FROM
                                      SERVERUS.mer_s ms
                                    WHERE
                                      ms.status = 3
                                    GROUP BY
                                      ms.zgl_id
                                    ) AS m_s ON m_h.zgl_id = m_s.zgl_id
  GROUP BY
    m_h.lot_num,
    account_num_m_h,
    m_h.ship_period,

    account_num_m_v,
    m_v.item_num,
    m_v.whse_num,
    
    w.reg_shp,
    
    kp.rezult
    
  ) m_h_v_kp

WHERE
      a_l_o_3.lot_num = m_h_v_kp.lot_num
  AND a_l_o_3.item_num = m_h_v_kp.item_num
  AND a_l_o_3.kod_region = m_h_v_kp.kod_region
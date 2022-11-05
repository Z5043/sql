		with art1 as (
		SELECT 
			 ITEM_NUM Артикул,
			max( V_DATE) Макс_Дата,
				max( V_DATE)-1 Макс_Дата2,
			IND_CATEGORY  новая_категория
		FROM KDW.DW_PRICE_HISTORY
		WHERE 
			V_DATE  BETWEEN 	trunc(SYSDATE, 'DDD')-7
							 AND trunc(SYSDATE, 'DDD')-1 
							 
							 
			and state='1'
			and (HSZ='064' or HSZ='Т33')
			AND ( DIV_CODE='Т33')
			Group by ITEM_NUM,IND_CATEGORY 
			),
art3 as (
		SELECT   
		  price.ITEM_NUM Артикул,
		  price.IND_CATEGORY старая_категория
		  --,price.V_DATE 
		FROM
		  KDW.DW_PRICE_HISTORY price,
		  art1
	
		WHERE
		( art1.Макс_Дата2 BETWEEN 	price.B_DATE AND price.E_DATE  )
			-- and  price.state='1'
			and (price.HSZ='064' or price.HSZ='Т33')
			AND ( DIV_CODE='Т33')
			
		)
			SELECT *
	from art1, art3
	where art1.Артикул=art3.Артикул
---------------------------------
		with art1 as (
		
		
			),
art3 as (
		SELECT   
		  price.ITEM_NUM Артикул,
		  price.IND_CATEGORY старая_категория
		  --,price.V_DATE 
		FROM
		  KDW.DW_PRICE_HISTORY price,
		  art1
	
		WHERE
		( art1.Макс_Дата2 BETWEEN 	price.B_DATE AND price.E_DATE  )
			-- and  price.state='1'
			and (price.HSZ='064' or price.HSZ='Т33')
			AND ( DIV_CODE='Т33')
			
		)
			SELECT *
	from art1, art3
	where art1.Артикул=art3.Артикул
	
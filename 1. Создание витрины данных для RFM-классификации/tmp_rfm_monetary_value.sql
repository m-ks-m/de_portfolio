INSERT INTO analysis.tmp_rfm_monetary_value (
			user_id,
			monetary_value)			
SELECT u.id
	,  NTILE (5) OVER (ORDER BY SUM(cost) ASC NULLS FIRST) AS monetary_value
FROM
users u 
LEFT JOIN 
(SELECT cost
	 ,  user_id
FROM orders 
WHERE status = 4) o 
ON u.id = o.user_id
GROUP BY u.id;
 
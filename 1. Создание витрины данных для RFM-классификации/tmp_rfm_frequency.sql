INSERT INTO analysis.tmp_rfm_frequency (
			user_id,
			frequency)			
SELECT u.id
	,  NTILE (5) OVER (ORDER BY (COUNT(order_id))) AS frequency
FROM
users u 
LEFT JOIN 
(SELECT order_id
	 ,  user_id
FROM orders 
WHERE status = 4) o 
ON u.id = o.user_id
GROUP BY u.id;
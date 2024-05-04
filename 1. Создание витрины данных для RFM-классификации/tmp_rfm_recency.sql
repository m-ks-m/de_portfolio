INSERT INTO analysis.tmp_rfm_recency (
			user_id,
			recency)			
SELECT   u.id  
	  ,  NTILE (5) OVER (ORDER BY MAX(order_ts) ASC NULLS FIRST) AS recency
FROM
users u
LEFT JOIN 
(SELECT order_ts
	 ,  user_id
FROM orders 
WHERE status = 4) o 
ON u.id = o.user_id
GROUP BY u.id;
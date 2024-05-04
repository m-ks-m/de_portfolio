CREATE OR REPLACE VIEW analysis.orders AS 
SELECT orders.order_id,
    	orders.order_ts,
    	orders.user_id,
    	orders.bonus_payment,
    	orders.payment,
    	orders.cost,
    	orders.bonus_grant,
    	os.status
FROM
(SELECT order_id 
	, FIRST_VALUE (status_id) OVER(PARTITION BY order_id ORDER BY dttm DESC) AS status
FROM production.orderstatuslog) os
RIGHT JOIN production.orders orders
ON os.order_id = orders.order_id;
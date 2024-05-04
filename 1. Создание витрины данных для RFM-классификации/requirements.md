# Витрина RFM

## 1.1. Выясните требования к целевой витрине.

**Что сделать:** Необходимо создать витрину данных для RFM-классификации пользователей приложения по доставке еды

Для анализа нужно отобрать только успешно выполненные заказы, то есть заказы со статусом `Closed`

Витрину нужно назвать `dm_rfm_segments`. 

Сохранить в исходной базе данных компании в схеме `analysis.`

**Зачем:** подготовить данные для компании, которая разрабатывает приложение по доставке еды для RFM-классификации клиентов с целью анализа их лояльности для отбора клиентских категорий, на которые стоит направить маркетинговые усилия.

**За какой период:** с начала 2022 года.

**Обновление данных:** не требуется.

**Кому доступна:** всем, но доступ только на чтение.

**Необходимая структура:**

- `user_id` - идентификатор пользователя
- `recency` (число от 1 до 5) - сколько времени прошло с момента последнего заказа.
- `frequency` (число от 1 до 5) - количество заказов.
- `monetary_value` (число от 1 до 5) - сумма затрат клиента.


## 1.2. Изучите структуру исходных данных.

- Для отбора данных по выполненным заказам будет использовано поле `status` таблицы `orders.`
- Для расчёта  `recency` будет использовано поле `order_ts` таблицы `orders`
- Для расчёта`frequency` будет использовано поле `order_id` таблицы `orders`
- Для расчёта `monetary_value` будет использоваться поле `cost` таблицы `orders`


## 1.3. Проанализируйте качество данных

Качество данных позволяет без их очистки преступить к работе по подготовке витрины.
## Оцените, насколько качественные данные хранятся в источнике.
Опишите, как вы проверяли исходные данные и какие выводы сделали.
1. Проверка на дубли не требуется, так как заданные ограничения в таблицах обеспечивают уникальность значений.
2. Пропущенных значений в важных полях также не обнаружена из-за наличия соответствующих ограничений Единственным полем, 
	которое согласну имеющим ограничениям может быть пустым является name таблицы users, но оно не используется в расчётах и не будет использвано.
3. Некорректность типов данных. Типы данных соответсвуют ожиданиям, проверенно пуием запроса к схеме:
 SELECT table_name,
	   column_name,
	   is_nullable,
       data_type
FROM information_schema.COLUMNS
WHERE table_schema = 'production'
4. Форматы данных корректны.
## Укажите, какие инструменты обеспечивают качество данных в источнике.
Ответ запишите в формате таблицы со следующими столбцами:
- `Наименование таблицы` - наименование таблицы, объект которой рассматриваете.
- `Объект` - Здесь укажите название объекта в таблице, на который применён инструмент. Например, здесь стоит перечислить поля таблицы, индексы и т.д.
- `Инструмент` - тип инструмента: первичный ключ, ограничение или что-то ещё.
- `Для чего используется` - здесь в свободной форме опишите, что инструмент делает.

| Таблицы                   | Объект                                                          | Инструмент  | Для чего используется                                                                       |
| ------------------------- | --------------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------- |
| production.users          | id int IS NOT NULL                                              | PRIMARY KEY | Обеспечивает уникальность записей о пользователях                                           |
| production.users          | login IS NOT NULL                                               | CHECK       | Обеспечивает обязательность записей о логине пользователя                                   |
| production.users          | id IS NOT NULL                                                  | CHECK       | Обеспечивает обязательность записей по id пользователя                                      |
| production.products       | id int IS NOT NULL                                              | PRIMARY KEY | Обеспечивает уникальность записей о товарах                                                 |
| production.products       | price IS NOT NULL                                               | CHECK       | Обеспечивает обязательность записей о цене                                                  |
| production.products       | ((price >= (0)::numeric))                                       | CHECK       | Цена товара должна не может быть отрицательной                                              |
| production.products       | id IS NOT NULL                                                  | CHECK       | Обеспечивает обязательность записей по id товаров                                           |
| production.products       | name IS NOT NULL                                                | CHECK       | Обязательность наименования товара                                                          |
| production.orderstatuslog | UNIQUE (order_id, status_id)                                    | UNIQUE      | Обеспечивает уникальность сочитания полей order_id и status_id                              |
| production.orderstatuslog | id int4 NOT NULL GENERATED ALWAYS AS IDENTITY…                  | PRIMARY KEY | Обеспечивает автомаическую генерацию уникальных значений поля id                            |
| production.orderstatuslog | FOREIGN KEY (order_id) REFERENCES production.orders(order_id)   | FOREIGN KEY | Обеспечивает соответсвие значения поля order_id значению поля order_id таблицы orders       |
| production.orderstatuslog | FOREIGN KEY (status_id) REFERENCES production.orderstatuses(id) | FOREIGN KEY | Обеспечивает соответсвие значения поля status_id значению поля id таблицы orderstatuses     |
| production.orderstatuslog | id IS NOT NULL                                                  | CHECK       | Обеспечивает обязательность записи поля id                                                  |
| production.orderstatuslog | order_id IS NOT NULL                                            | CHECK       | Обеспечивает обязательность записи поля order_id                                            |
| production.orderstatuslog | dttm IS NOT NULL                                                | CHECK       | Обеспечивает обязательность записи поля dttm                                                |
| production.orderstatuslog | status_id IS NOT NULL                                           | CHECK       | Обеспечивает обязательность записи поля status_id                                           |
| production.orderstatuses  | id int4 NOT NULL                                                | PRIMARY KEY | Обеспечивает уникальность записей о статусах                                                |
| production.orderstatuses  | id IS NOT NULL                                                  | CHECK       | Обеспечивает обязательность записи поля id                                                  |
| production.orderstatuses  | key IS NOT NULL                                                 | CHECK       | Обеспечивает обязательность записи поля key                                                 |
| production.orders         | order_id IS NOT NULL                                            | PRIMARY KEY | Обеспечивает уникальность записей order_id                                                  |
| production.orders         | cost IS NOT NULL                                                | CHECK       | Обеспечивает обязательность записи поля cost                                                |
| production.orders         | bonus_grant IS NOT NULL                                         | CHECK       | Обеспечивает обязательность записи поля bonus_grant                                         |
| production.orders         | status IS NOT NULL                                              | CHECK       | Обеспечивает обязательность записи поля status                                              |
| production.orders         | payment IS NOT NULL                                             | CHECK       | Обеспечивает обязательность записи поля payment                                             |
| production.orders         | bonus_payment IS NOT NULL                                       | CHECK       | Обеспечивает обязательность записи поля bonus_payment                                       |
| production.orders         | user_id IS NOT NULL                                             | CHECK       | Обеспечивает обязательность записи поля user_id                                             |
| production.orders         | order_ts IS NOT NULL                                            | CHECK       | Обеспечивает обязательность записи поля order_ts                                            |
| production.orders         | ((cost = (payment + bonus_payment)))                            | CHECK       | Обязательность значения поля cost сумме значений полей (payment + bonus_payment)            |
| production.orders         | order_id IS NOT NULL                                            | CHECK       | Обеспечивает обязательность записи поля order_id                                            |
| production.orderitems     | UNIQUE (order_id, product_id)                                   | UNIQUE      | Обеспечивает уникальность сочитания полей order_id и product_id                             |
| production.orderitems     | id int4 NOT NULL GENERATED ALWAYS AS IDENTITY…                  | PRIMARY KEY | Обеспечивает автомаическую генерацию уникальных значений поля id                            |
| production.orderitems     | FOREIGN KEY (order_id) REFERENCES production.orders(order_id)   | FOREIGN KEY | Обеспечивает соответсвие значения поля order_id значению поля order_id таблицы orders       |
| production.orderitems     | FOREIGN KEY (product_id) REFERENCES production.products(id)     | FOREIGN KEY | Обеспечивает соответсвие значения поля product_id значению поля product_id таблицы products |
| production.orderitems     | ((quantity > 0))                                                | CHECK       | Обеспечивает обязательность значения поля quantity больше 0                                 |
| production.orderitems     | quantity IS NOT NULL                                            | CHECK       | Обеспечивает обязательность записи поля quantity                                            |
| production.orderitems     | ((price >= (0)::numeric))                                       | CHECK       | Цена товара должна не может быть отрицательной                                              |
| production.orderitems     | (((discount >= (0)::numeric) AND (discount <= price)))          | CHECK       | Скидка не может быть отрицательной                                                          |
| production.orderitems     | order_id IS NOT NULL                                            | CHECK       | Обеспечивает обязательность записи поля order_id                                            |
| production.orderitems     | discount IS NOT NULL                                            | CHECK       | Обеспечивает обязательность записи поля discount                                            |
| production.orderitems     | id IS NOT NULL                                                  | CHECK       | Обеспечивает обязательность записи поля id                                                  |
| production.orderitems     | name IS NOT NULL                                                | CHECK       | Обеспечивает обязательность записи поля name                                                |
| production.orderitems     | product_id IS NOT NULL                                          | CHECK       | Обеспечивает обязательность записи поля product_id                                          |
| production.orderitems     | price IS NOT NULL                                               | CHECK       | Обеспечивает обязательность записи поля price                                               |


## 1.4. Подготовьте витрину данных

{См. задание на платформе}
### 1.4.1. Сделайте VIEW для таблиц из базы production.**

{См. задание на платформе}
```SCREATE VIEW analysis.Users AS 
SELECT*
FROM production.Users;

CREATE VIEW analysis.OrderItems AS 
SELECT*
FROM production.OrderItems;

CREATE VIEW analysis.OrderStatuses AS 
SELECT*
FROM production.OrderStatuses;

CREATE VIEW analysis.Products AS 
SELECT*
FROM production.Products;

CREATE VIEW analysis.Orders AS 
SELECT*
FROM production.Orders;
```

### 1.4.2. Напишите DDL-запрос для создания витрины.**

{См. задание на платформе}
```
CREATE TABLE analysis.dm_rfm_segments (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5),
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5),
monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

```

### 1.4.3. Напишите SQL запрос для заполнения витрины

{См. задание на платформе}
```
INSERT INTO analysis.tmp_rfm_recency (
			user_id,
			recency)			
SELECT o.user_id  	
	,  NTILE (5) OVER (ORDER BY MAX(order_ts)) AS recency
FROM
orders o 
JOIN orderstatuses o2 
ON o.status = o2.id
WHERE o2."key" = 'Closed'
GROUP BY o.user_id;

INSERT INTO analysis.tmp_rfm_frequency (
			user_id,
			frequency)			
SELECT o.user_id
	,  NTILE (5) OVER (ORDER BY (COUNT(o.order_id))) AS frequency
FROM
orders o 
JOIN orderstatuses o2 
ON o.status = o2.id
WHERE o2."key" = 'Closed'
GROUP BY o.user_id;

INSERT INTO analysis.tmp_rfm_monetary_value (
			user_id,
			monetary_value)			
SELECT o.user_id
	,  NTILE (5) OVER (ORDER BY SUM(o.cost)) AS monetary_value
FROM
orders o 
JOIN orderstatuses o2 
ON o.status = o2.id
WHERE o2."key" = 'Closed'
GROUP BY o.user_id;

INSERT INTO analysis.dm_rfm_segments(
		user_id,
		recency,
		frequency,
		monetary_value)
SELECT trf.user_id AS user_id 
	,  trr.recency AS recency 
	,  trf.frequency AS frequency 
	,  trmv.monetary_value AS monetary_value 
FROM tmp_rfm_frequency trf 
FULL JOIN tmp_rfm_recency trr 
ON trf.user_id = trr.user_id 
FULL JOIN tmp_rfm_monetary_value trmv 
ON trf.user_id =	trmv.user_id;

```

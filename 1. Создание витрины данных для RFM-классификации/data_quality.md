# 1.3. Качество данных
1. Проверка на дубли не требуется, так как заданные ограничения в таблицах обеспечивают уникальность значений.
2. Пропущенных значений в важных полях также не обнаружена из-за наличия соответствующих ограничений Единственным полем, которое согласну имеющим ограничениям может быть пустым является name таблицы users, но оно не используется в расчётах и не будет использвано.
3. Некорректность типов данных. Типы данных соответсвуют ожиданиям, проверенно путем запроса к схеме:
 SELECT table_name,
	   column_name,
	   is_nullable,
       data_type
FROM information_schema.COLUMNS
WHERE table_schema = 'production'
4. Форматы данных корректны.
## Перечень инструментов обеспечивающих качество данных в источнике.

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

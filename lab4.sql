-- 3.1 INSERT
-- a. Без указания списка полей
INSERT INTO barber_can_servise VALUES (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6);

-- b. С указанием списка полей
INSERT INTO barbershop.servise (cost, duration, name) VALUES (1200.0000, '30', 'Pokraska volos');

-- c. С чтением значения из другой таблицы
INSERT INTO client (name, telephone, email, gender, birth_date) SELECT name, telephone, email, gender, birth_date FROM person;

-- 3.2. DELETE
-- a. Всех записей
DELETE FROM person;
-- b. По условию
DELETE FROM person WHERE birth_date < '1999-01-01 00:00:00';

-- 3.3. UPDATE
-- a. Всех записей
UPDATE client SET gender = 1;
-- b. По условию обновляя один атрибут
UPDATE client SET email = '' WHERE email IS NULL;
-- c. По условию обновляя несколько атрибутов
UPDATE client SET email = '', telephone = '', birth_date = NULL WHERE id_client = 2;

-- 3.4. SELECT
SELECT name, address FROM barbershop;
-- b. Со всеми атрибутами (SELECT * FROM...)
SELECT * FROM client;
-- c. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = value)
SELECT * FROM client WHERE birth_date > '1999-01-01 00:00:00';

-- 3.5. SELECT ORDER BY + TOP (LIMIT)
-- a. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT * FROM `client` ORDER BY name ASC LIMIT 5;
-- b. С сортировкой по убыванию DESC
SELECT * FROM `client` ORDER BY name DESC;
-- c. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT * FROM `client` ORDER BY gender, name, birth_date;
-- d. С сортировкой по первому атрибуту, из списка извлекаемых
SELECT name, birth_date FROM `client` ORDER BY 1;

-- 3.6. Работа с датами
-- Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME. Например,
-- таблица авторов может содержать дату рождения автора.
-- a. WHERE по дате
SELECT * FROM `order`
WHERE DATE(date) = '2022-03-10';
-- b. WHERE дата в диапазоне
SELECT * FROM `order`
WHERE date BETWEEN '2022-03-01' AND '2022-03-31';
-- c. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
-- Для этого используется функция YEAR ( https://docs.microsoft.com/en-us/sql/tsql/functions/year-transact-sql?view=sql-server-2017 )
SELECT id_client, name, YEAR(birth_date) FROM `client`;


-- 3.7. Функции агрегации
-- a. Посчитать количество записей в таблице
SELECT COUNT(*) AS clients FROM client;
-- b. Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT id_client) AS active_clients FROM `order`;
-- c. Вывести уникальные значения столбца
SELECT DISTINCT id_client AS active_client_ids FROM `order`;
-- d. Найти максимальное значение столбца
SELECT MAX(price) AS "max_check" FROM `order`;
-- e. Найти минимальное значение столбца
SELECT MIN(birth_date) AS "max_check" FROM `client`;
-- f. Написать запрос COUNT() + GROUP BY
SELECT id_barber, COUNT(id_order) AS "barber_orders_count" FROM `order` GROUP BY id_barber;


-- 3.8. SELECT GROUP BY + HAVING
-- a. Написать 3 разных запроса с использованием GROUP BY + HAVING. Для
-- каждого запроса написать комментарий с пояснением, какую информацию
-- извлекает запрос. Запрос должен быть осмысленным, т.е. находить информацию,
-- которую можно использовать.
-- a) Найти id клиентов, которые получили услуг на сумму больше 1000 р.
SELECT id_client
from `order`
GROUP BY(id_client)
HAVING SUM(price) > 1000;

-- б) Получить значение максимального чека за каждый день
SELECT date, price
FROM `order`
JOIN barbershop
ON `order`.id_barbershop = barbershop.id_barbershop
GROUP BY date
HAVING MAX(price) > 500;

-- в) Найти активных барберов, которые сделали ТРИ и более заказов
SELECT id_barber, COUNT(*) as count_barber_orders
from `order`
GROUP BY id_barber
HAVING count_barber_orders >= 3;

-- 3.9. SELECT JOIN
-- a. LEFT JOIN двух таблиц и WHERE по одному из атрибуто
SELECT `order`.id_barber, barber.name, COUNT(id_order) AS "barber_orders_count" FROM `order`
JOIN barber ON `order`.id_barber = barber.id_barber
GROUP BY `order`.id_barber;
-- b. RIGHT JOIN. Получить такую же выборку, как и в 3.9 a
SELECT `order`.id_barber, barber.name, COUNT(id_order) AS "barber_orders_count" FROM barber
RIGHT JOIN `order` ON `order`.id_barber = barber.id_barber
GROUP BY `order`.id_barber;
-- c. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT `order`.id_order, `order`.id_barber, barber.name, client.name FROM `order`
LEFT JOIN barber ON `order`.id_barber = barber.id_barber
LEFT JOIN client ON `order`.id_client = client.id_client
WHERE `order`.id_barber = 4;
-- d. INNER JOIN двух таблиц
SELECT id_order, `order`.id_barber, name, date, `order`.id_barbershop, price FROM `order`
INNER JOIN barber
ON barber.id_barber = `order`.id_barber
WHERE price > 1000;


-- 3.10. Подзапросы
-- a. Написать запрос с условием WHERE IN (подзапрос)
SELECT name FROM barber
WHERE id_barber IN (
    SELECT id_barber FROM `order`
    WHERE price > 1000
);

-- b. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT id_order, price, date, (
    SELECT address
    FROM barbershop
    WHERE `order`.id_barbershop = id_barbershop
)
FROM `order`;


-- c. Написать запрос вида SELECT * FROM (подзапрос)
SELECT
    *
FROM
    (SELECT
        id_order, price
    FROM
        `order`
    WHERE price > 1000
    ) AS lineitems;
-- d. Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON …
SELECT *
FROM `order`
JOIN (
    SELECT id_barbershop, address
    FROM barbershop
) as address
ON `order`.id_barbershop = address.id_barbershop;













-- c. С чтением значения из другой таблицы
INSERT INTO `order` (id_barber, id_barbershop, id_client, date, price) VALUES (1, SELECT id_barbershop FROM barber WHERE id_barber = 1, 1, '2022-03-14', 700.0000);

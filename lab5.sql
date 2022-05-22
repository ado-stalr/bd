-- 1. Добавить внешние ключи.
ALTER TABLE booking
    ADD CONSTRAINT `booking_client_id_client_fk` FOREIGN KEY (`id_client`) REFERENCES `client` (`id_client`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE room
    ADD CONSTRAINT `room_hotel_id_hotel_fk` FOREIGN KEY (`id_hotel`) REFERENCES `hotel` (`id_hotel`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE room
    ADD CONSTRAINT `room_room_category_id_room_category_fk` FOREIGN KEY (`id_room_category`) REFERENCES `room_category` (`id_room_category`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE room_in_booking
    ADD CONSTRAINT `room_in_booking_booking_id_booking_fk` FOREIGN KEY (`id_booking`) REFERENCES `booking` (`id_booking`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE room_in_booking
    ADD CONSTRAINT `room_in_booking_room_id_room_fk` FOREIGN KEY (`id_room`) REFERENCES `room` (`id_room`) ON DELETE CASCADE ON UPDATE CASCADE;

-- 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г.
SELECT client.name, client.phone from client
JOIN booking ON client.id_client = booking.id_client
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN room_category ON room.id_room_category = room_category.id_room_category
JOIN hotel ON room.id_hotel = hotel.id_hotel
WHERE hotel.name = 'Космос'
    AND room_category.name = 'Люкс'
    AND room_in_booking.checkin_date <= '2019-04-01'
    AND room_in_booking.checkout_date > '2019-04-01';

-- 3. Дать список свободных номеров всех гостиниц на 22 апреля.
SELECT hotel.name, number, id_room from room
JOIN hotel ON room.id_hotel = hotel.id_hotel
WHERE room.id_room NOT IN (
          SELECT DISTINCT room_in_booking.id_room
          FROM room_in_booking
          WHERE room_in_booking.checkin_date <= '2019-04-22' AND room_in_booking.checkout_date > '2019-04-22'
      );

-- 4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров
SELECT room_category.name, COUNT(*) AS Amount
FROM room_in_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE (room_in_booking.checkin_date <= '2019-03-23' AND room_in_booking.checkout_date > '2019-03-23') AND hotel.name = 'Космос'
GROUP BY room.id_room_category;

-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда.
SELECT room.id_room, room.number, client.name, last_checkout FROM room, (
      SELECT room.id_room, MAX(room_in_booking.checkout_date) as last_checkout
      FROM room
               JOIN room_in_booking ON room_in_booking.id_room = room.id_room
               JOIN hotel ON room.id_hotel = hotel.id_hotel
      WHERE room_in_booking.checkout_date >= '2019-04-01'
            AND room_in_booking.checkout_date <= '2019-04-30'
            AND hotel.name = 'Космос'
      GROUP BY room.id_room
  ) AS last_using_room
JOIN room_in_booking ON room_in_booking.id_room = last_using_room.id_room
JOIN booking ON room_in_booking.id_booking = booking.id_booking
JOIN client ON booking.id_client = client.id_client
WHERE last_using_room.id_room = room.id_room AND room_in_booking.checkout_date = last_using_room.last_checkout;

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая.
UPDATE room_in_booking , (
    SELECT room_in_booking.id_room_in_booking, room_in_booking.checkout_date
    FROM room_in_booking
    JOIN room ON room_in_booking.id_room = room.id_room
    JOIN hotel ON room.id_hotel = hotel.id_hotel
    JOIN room_category ON room.id_room_category = room_category.id_room_category
    WHERE  (room_in_booking.checkin_date = '2019-05-10') AND (hotel.name = 'Космос') AND (room_category.name = 'Бизнес')
    ORDER BY room_in_booking.checkout_date DESC
) as T
SET room_in_booking.checkout_date = ADDDATE(room_in_booking.checkout_date, INTERVAL 2 DAY)
WHERE room_in_booking.id_room_in_booking = T.id_room_in_booking;

UPDATE room_in_booking , (
    SELECT room_in_booking.id_room_in_booking, room_in_booking.checkout_date
    FROM room_in_booking
    JOIN room ON room_in_booking.id_room = room.id_room
    JOIN hotel ON room.id_hotel = hotel.id_hotel
    JOIN room_category ON room.id_room_category = room_category.id_room_category
    WHERE  (room_in_booking.checkin_date = '2019-05-10') AND (hotel.name = 'Космос') AND (room_category.name = 'Бизнес')
    ORDER BY room_in_booking.checkout_date DESC
) as T
SET room_in_booking.checkout_date = ADDDATE(room_in_booking.checkout_date, INTERVAL -2 DAY)
WHERE room_in_booking.id_room_in_booking = T.id_room_in_booking;

SELECT * FROM room_in_booking;

-- 7. Найти все "пересекающиеся" варианты проживания. Правильное состояние: не может быть забронирован один номер на одну дату несколько раз, т.к. нельзя заселиться нескольким клиентам в один номер.
-- Записи в таблице room_in_booking с id_room_in_booking = 5 и 2154 являются примером неправильного состояния, которые необходимо найти.
-- Результирующий кортеж выборки должен содержать информацию о двух конфликтующих номерах.
SELECT table1.id_room_in_booking, table1.id_booking, table1.id_room, table1.checkin_date, table1.checkout_date, table2.id_room_in_booking, table2.id_booking, table2.id_room, table2.checkin_date, table2.checkout_date
FROM room_in_booking AS table1
JOIN room_in_booking AS table2 ON table1.id_room = table2.id_room
WHERE
    (
      (table1.checkin_date >= table2.checkin_date AND table1.checkin_date < table2.checkout_date)
       OR ((table1.checkout_date > table2.checkin_date) AND (table1.checkin_date < table2.checkout_date))
    )
    AND (table1.id_room_in_booking != table2.id_room_in_booking);

-- 8. Создать бронирование в транзакции.


-- 9. Добавить необходимые индексы для всех таблиц
create index booking_id_client_index
    on booking (id_client);

create index room_id_hotel_index
    on room (id_hotel);

create index room_id_room_category_index
    on room (id_room_category);

create index room_in_booking_id_booking_index
    on room_in_booking (id_booking);

create index room_in_booking_id_room_index
    on room_in_booking (id_room);




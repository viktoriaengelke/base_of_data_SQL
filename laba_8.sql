DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS halls CASCADE;
DROP TABLE IF EXISTS trainers CASCADE;

CREATE TABLE trainers
(trainer_id INT GENERATED ALWAYS AS IDENTITY,
last_name VARCHAR(15) CONSTRAINT trainers_last_name_nn NOT NULL,
first_name VARCHAR(15) CONSTRAINT trainers_first_name_nn NOT NULL,
phone_number VARCHAR(20) CONSTRAINT trainers_phone_number_uk UNIQUE,
birth_date DATE,
hourly_rate NUMERIC(8,2) DEFAULT 2000 CONSTRAINT trainers_hourly_rate_cc CHECK(hourly_rate >= 0),
hire_date DATE DEFAULT CURRENT_DATE,
CONSTRAINT trainers_trainer_id_pk PRIMARY KEY (trainer_id));

CREATE TABLE halls
(hall_id INT GENERATED ALWAYS AS IDENTITY,
hall_name VARCHAR(20),
floor_type VARCHAR(20),
area NUMERIC(8,2),
CONSTRAINT halls_hall_id_pk PRIMARY KEY (hall_id));

CREATE TABLE bookings
(booking_id INT GENERATED ALWAYS AS IDENTITY,
trainer_id INT,
hall_id INT,
booking_date DATE CONSTRAINT booking_booking_date_nn NOT NULL,
start_time TIME,
end_time TIME,
amount NUMERIC(8,2) CONSTRAINT booking_amount_cc CHECK(amount >= 0),
CONSTRAINT bookings_trainer_id_fk FOREIGN KEY (trainer_id) REFERENCES trainers (trainer_id),
CONSTRAINT bookings_hall_id_fk FOREIGN KEY (hall_id) REFERENCES halls (hall_id),
CONSTRAINT bookings_time_check CHECK (end_time > start_time AND (end_time - start_time) >= INTERVAL '1 hour'),
CONSTRAINT bookings_booking_id_pk PRIMARY KEY (booking_id));

ALTER TABLE halls ALTER COLUMN hall_name TYPE VARCHAR(50);
ALTER TABLE halls ADD COLUMN head_trainer_id INT;

ALTER TABLE halls ADD CONSTRAINT halls_head_trainer_fk 
FOREIGN KEY (head_trainer_id) REFERENCES trainers (trainer_id);

ALTER TABLE halls DROP COLUMN area;

CREATE TABLE test_drop_table (
    id INT,
    name VARCHAR(10)
);

DROP TABLE test_drop_table;

INSERT INTO trainers (last_name, first_name, phone_number, birth_date, hourly_rate) VALUES
('Иванов', 'Иван', '+79991111111', '1990-05-15', 2500),
('Петрова', 'Анна', '+79992222222', '1995-08-20', 3000),
('Сидоров', 'Олег', '+79993333333', '1988-02-10', 2000),
('Смирнова', 'Елена', '+79994444444', '1992-11-30', 2800),
('Кузнецов', 'Дмитрий', '+79995555555', '1985-07-07', 3500),
('Попова', 'Ольга', '+79996666666', '1998-04-12', 1800),
('Васильев', 'Сергей', '+79997777777', '1991-09-25', 2200),
('Михайлова', 'Ирина', '+79998888888', '1994-01-18', 2600),
('Новиков', 'Павел', '+79999999999', '1987-12-05', 3100),
('Федорова', 'Мария', '+79990000000', '1996-06-22', 2400);

INSERT INTO halls (hall_name, floor_type, head_trainer_id) VALUES
('Зеркальный', 'Паркет', 1),
('Большой', 'Ламинат', 2),
('Малый', 'Паркет', 3),
('Светлый', 'Линолеум', 4),
('Черный', 'Ламинат', 5),
('Сцена', 'Спец. покрытие', 6),
('Тренировочный', 'Паркет', 7),
('Йога-зал', 'Ковролин', 8),
('Вип-зал', 'Паркет', 9),
('Детский', 'Мягкое покрытие', 10);

INSERT INTO bookings (trainer_id, hall_id, booking_date, start_time, end_time, amount) VALUES
(1, 1, '2026-11-10', '10:00', '12:00', 3000),
(2, 2, '2026-11-10', '12:00', '14:00', 5000),
(3, 3, '2026-11-11', '09:00', '10:30', 1500),
(4, 4, '2026-11-11', '15:00', '17:00', 2400),
(5, 5, '2026-11-12', '18:00', '20:00', 3600),
(6, 6, '2026-11-12', '10:00', '13:00', 9000),
(7, 7, '2026-11-13', '14:00', '16:00', 2600),
(8, 8, '2026-11-13', '11:00', '12:30', 1650),
(9, 9, '2026-11-14', '16:00', '18:00', 8000),
(10, 10, '2026-11-14', '09:00', '10:00', 900);

SELECT * FROM trainers ORDER BY trainer_id;
SELECT * FROM halls ORDER BY hall_id;
SELECT * FROM bookings ORDER BY booking_id;

-- повышение старвки тренера, если она < 2500 --
UPDATE trainers 
SET hourly_rate = hourly_rate * 1.1 
WHERE hourly_rate < 2500; 

-- изменение покрытия пола --
UPDATE halls 
SET floor_type = 'Спортивный ламинат' 
WHERE floor_type = 'Ламинат';

-- перенос броней, которые были 14 ноября, на 15 ноября --
UPDATE bookings
SET booking_date = '2026-11-15' 
WHERE booking_date = '2026-11-14';

-- допустим, тренер с id=10 уволился, тогда убираем его из главных тренеров по залу, уалем его брони и удаляем строку с его информацией --
UPDATE halls SET head_trainer_id = NULL WHERE head_trainer_id = 10;
DELETE FROM bookings WHERE trainer_id = 10;
DELETE FROM trainers WHERE trainer_id = 10;

SELECT * FROM trainers ORDER BY trainer_id;
SELECT * FROM halls ORDER BY hall_id;
SELECT * FROM bookings ORDER BY booking_id;

-- ошибка 1: нарушение UNIQUE (уникальность телефона) --
INSERT INTO trainers (last_name, first_name, phone_number) 
VALUES ('Дубликатов', 'Тест', '+79991111111'); 

-- ошибка 2: нарушение NOT NULL (пустая фамилия) --
INSERT INTO trainers (last_name, first_name, phone_number) 
VALUES (NULL, 'Безымянный', '+79990000001');

-- ошибка 3: нарушение CHECK (отрицательная ставка) --
INSERT INTO trainers (last_name, first_name, phone_number, hourly_rate) 
VALUES ('Отрицательный', 'Тест', '+79990000002', -500);

-- ошибка 4: нарушение FOREIGN KEY (бронь на несуществующий зал) --
INSERT INTO bookings (trainer_id, hall_id, booking_date, start_time, end_time, amount) 
VALUES (1, 999, '2026-11-20', '10:00', '12:00', 2000);

-- ошибка 5: нарушение CHECK на время (конец раньше начала) --
INSERT INTO bookings (trainer_id, hall_id, booking_date, start_time, end_time, amount) 
VALUES (1, 1, '2026-11-20', '15:00', '14:00', 2000);

-- ошибка 6: нарушение CHECK на время (бронь меньше 1 часа) --
INSERT INTO bookings (trainer_id, hall_id, booking_date, start_time, end_time, amount) 
VALUES (1, 1, '2026-11-20', '10:00', '10:30', 2000);
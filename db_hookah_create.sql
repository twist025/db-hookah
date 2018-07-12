--CREATE TYPE sex AS ENUM ('Муж', 'Жен'); 
--CREATE TYPE _position AS ENUM ('Кальянщик', 'Менеджер'); 

CREATE TABLE IF NOT EXISTS passport ( 
id_passport_data serial NOT NULL PRIMARY KEY, 
series VARCHAR (4) NOT NULL, 
_number VARCHAR (6) NOT NULL, 
issued VARCHAR, 
photo_link VARCHAR, 
surname VARCHAR (30) NOT NULL, 
_name VARCHAR (30) NOT NULL, 
patronymic VARCHAR (30) NOT NULL, 
date_of_birth DATE NOT NULL, 
sex sex NOT NULL, 
registration_address VARCHAR (100) 
); 

CREATE TABLE IF NOT EXISTS staff ( 
id_staff serial NOT NULL PRIMARY KEY, 
passport_data INT, 
contract INT, 
_position _position NOT NULL, 
actual_address VARCHAR (100), 
phone_number VARCHAR(20), 
FOREIGN KEY (passport_data) REFERENCES passport (id_passport_data) 
); 

CREATE TABLE IF NOT EXISTS lk( 
id_staff INT, 
_login VARCHAR, 
_password VARCHAR, 
FOREIGN KEY (id_staff) REFERENCES staff (id_staff) 
); 

CREATE TABLE IF NOT EXISTS wages( 
id_wages serial PRIMARY KEY,
id_staff INT, 
value MONEY, 
FOREIGN KEY (id_staff) REFERENCES staff (id_staff) 
); 

CREATE TABLE IF NOT EXISTS fines ( 
id_fines serial NOT NULL PRIMARY KEY, 
cause VARCHAR (50), 
cost_fines INT 
); 

CREATE TABLE IF NOT EXISTS contests( 
id_contest serial NOT NULL PRIMARY KEY, 
description VARCHAR 
); 

CREATE TABLE IF NOT EXISTS contests_score( 
id_contest_score serial NOT NULL PRIMARY KEY, 
id_contest INT, 
id_staff INT, 
FOREIGN KEY (id_contest) REFERENCES contests (id_contest), 
FOREIGN KEY (id_staff) REFERENCES staff (id_staff) 
); 

CREATE TABLE IF NOT EXISTS filials (
	id_filial serial NOT NULL PRIMARY KEY,
	filial_name VARCHAR (50),
	filial_address VARCHAR (150)
);


CREATE TABLE IF NOT EXISTS workshifts_plan (
id_workshift serial PRIMARY KEY,
id_filial int,
start_date DATE NOT NULL, 
start_time TIME NOT NULL, 
end_date DATE NOT NULL, 
end_time TIME NOT NULL, 
staff_type staff_type, 
FOREIGN KEY (id_filial) REFERENCES filials (id_filial)
);

CREATE TABLE IF NOT EXISTS workshifts_fact (
id_workshift int PRIMARY KEY,
id_filial int,
id_staff INT,
staff_type staff_type, 
FOREIGN KEY (id_filial) REFERENCES filials (id_filial),
FOREIGN KEY (id_workshift) REFERENCES workshifts_plan (id_workshift)
);

CREATE TABLE IF NOT EXISTS staff_workshifts (-- Сводная смены-персонал
id_staff_worksifts serial primary key,
id_workshift INT,
id_staff INT,
FOREIGN KEY (id_staff) REFERENCES staff (id_staff),
FOREIGN KEY (id_workshift) REFERENCES workshifts_fact (id_workshift)
);

CREATE TABLE IF NOT EXISTS getting_a_fine ( -- Кто в какую смену какой штраф получил
id_getting serial NOT NULL PRIMARY KEY, 
id_workshift int,
id_fines INT, 
id_staff INT, 
FOREIGN KEY (id_fines) REFERENCES fines (id_fines), 
FOREIGN KEY (id_staff) REFERENCES staff (id_staff), 
FOREIGN KEY (id_workshift) REFERENCES workshifts_fact (id_workshift)
);

CREATE TABLE IF NOT EXISTS _storage (
id_equipment VARCHAR PRIMARY KEY,
amount int,
_location int,
/*
FOREIGN KEY (id_equipment) REFERENCES shafts (id_equip),
FOREIGN KEY (id_equipment) REFERENCES tobacco (id_equip),
FOREIGN KEY (id_equipment) REFERENCES bowls (id_equip),
FOREIGN KEY (id_equipment)REFERENCES flasks (id_equip),
FOREIGN KEY (id_equipment) REFERENCES equipment (id_equip),
*/
FOREIGN KEY (_location) REFERENCES filials (id_filial)
);



CREATE TABLE IF NOT EXISTS fillers ( -- Наполнители
id_filler serial PRIMARY KEY,
description VARCHAR
);

CREATE TABLE IF NOT EXISTS promotions ( -- Акции
id_promotion serial PRIMARY KEY,
description VARCHAR
);

CREATE TABLE IF NOT EXISTS shafts ( -- ШАХТЫ
id_shaft serial PRIMARY KEY,
id_equip VARCHAR,
description VARCHAR,
FOREIGN KEY (id_equip) REFERENCES _storage (id_equipment)
);


CREATE TABLE IF NOT EXISTS tobacco ( -- ТАБАКИ
id_tobacco serial PRIMARY KEY,
id_equip VARCHAR,
description VARCHAR,
FOREIGN KEY (id_equip) REFERENCES _storage (id_equipment)
);

CREATE TABLE IF NOT EXISTS bowls (-- ЧАШИ
id_bowl serial PRIMARY KEY,
id_equip VARCHAR,
description VARCHAR,
FOREIGN KEY (id_equip) REFERENCES _storage (id_equipment)
);

CREATE TABLE IF NOT EXISTS flasks (-- КОЛБЫ
id_flask serial PRIMARY KEY,
id_equip VARCHAR,
description VARCHAR,
FOREIGN KEY (id_equip) REFERENCES _storage (id_equipment)
);

CREATE TABLE IF NOT EXISTS equipment ( -- прочее оборудование
id_equipment serial PRIMARY KEY,
id_equip VARCHAR,
description VARCHAR,
FOREIGN KEY (id_equip) REFERENCES _storage (id_equipment)
);

CREATE TABLE IF NOT EXISTS sales (
id_sale serial PRIMARY KEY,
id_workshift int,
id_staff int,
id_promotion int,
promotion_amount smallint,
id_filler int,
filler_amount smallint,
id_shaft int,
shaft_amount smallint,
id_bowl int,
bowl_amount smallint,
id_tobacco int,
tobacco_amount smallint,
FOREIGN KEY (id_workshift) REFERENCES workshifts_fact (id_workshift),
FOREIGN KEY (id_staff) REFERENCES staff (id_staff),
FOREIGN KEY (id_promotion) REFERENCES promotions (id_promotion),
FOREIGN KEY (id_filler) REFERENCES fillers (id_filler),
FOREIGN KEY (id_shaft) REFERENCES shafts (id_shaft),
FOREIGN KEY (id_bowl) REFERENCES bowls (id_bowl),
FOREIGN KEY (id_tobacco) REFERENCES tobacco (id_tobacco)
);

CREATE TABLE interview (
	_date TIMESTAMP PRIMARY KEY,
	surname VARCHAR (30) NOT NULL,
	_name VARCHAR (30) NOT NULL,
	patronymic VARCHAR (30) NOT NULL,
	date_of_birth DATE NOT NULL,
	citizenship VARCHAR (30) NOT NULL,
	education VARCHAR (100) NOT NULL,
	marital_status VARCHAR (30) NOT NULL,
	phone_number VARCHAR (30) NOT NULL,
	experience yes_no NOT NULL,
	brutality yes_no NOT NULL,
	drugs yes_no NOT NULL,
	med_book yes_no NOT NULL,
	seconds_stap_day DATE NOT NULL,
	servises contact, -- Skype , Facetime, WhatsApp, Viber
);
	description VARCHAR (40),
		q1 test_question,--общительность 
    q2 test_question,	--позитив 
    q3 test_question,--общительность 
    q4 test_question,--немного о себе 
    q5 test_question,--кем себя видишь через 5 лет 
    q6 test_question,--жизненная ситуация 
    q7 test_question,--сложная проблема 
    q8 test_question,--опыт кальянства 
    q9 test_question,--последняя работа 
    q10 test_question,--сколько времени последней работы 
    q11 test_question,--почему ушел 
    q12 test_question,--алгоритм вытаскивания предпочтений 
    q13 test_question,--реакция на крепкий кальян 
    q14 test_question,--продажа допкальяна 
    q15 test_question,--любовь к бухим 
    q16 test_question,--командность 
    q17 test_question,--ночные смены 
    q18 test_question,--время до работы 
/* 1-18 по скайпу, 18-36 вживую */
	q19 test_question,--опоздание 
    q20 test_question,--внешний вид 
    q21 test_question,--граммовка табака 
    q22 test_question,--мытье рук 
    q23 test_question,--уборка стола 
    q24 test_question,--угли сразу на печку 
    q25 test_question,--разогрев калауда 
    q26 test_question,--использование колпака 
    q27 test_question,--вкус 
    q28 test_question,--оригинальность вкуса 
    q29 test_question,--дымность 
    q30 test_question,--скорость приготовления 
    q31 test_question,--разобран ли кальян 
    q32 test_question,--помыт ли кальян 
    q33 test_question,--качество мойки кальяна 
    q34 test_question,--подход 
    q35 test_question,--общение с гостем 
    q36 test_question --обслуживание стола
);

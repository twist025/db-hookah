CREATE TYPE sex AS ENUM ('Муж', 'Жен');
CREATE TYPE _position AS ENUM ('Кальянщик','Менеджер');
CREATE TYPE staff_type AS ENUM ('Стажер','Специалист');
CREATE TYPE equip AS ENUM (
	'Кальянный инвентарь',
	'Столовые приборы',
	'Хоз. товары',
	'Хранение',
	'Конц. товары',
	'Техника',
	'Брендинг'
);
CREATE TYPE test_question AS ENUM ('0', '1', '2', '3', '4');
CREATE TYPE yes_no AS ENUM ('0', '1', '2', '3', '4');
CREATE TYPE contact AS ENUM (
	'Skype',
	'Facetime',
	'WhatsApp',
	'Viber'
);

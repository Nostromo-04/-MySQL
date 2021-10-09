/* Проект базы данных интернет-магазина.
 * Функционал, сущности и атрибуты представлены в том виде,
 * в котором я их задумал. Возможно это не последний вариант БД. */

DROP DATABASE IF EXISTS im;
CREATE DATABASE im;
USE im;

-- 1 блок: создание таблиц, связей и ограничений
DROP TABLE IF EXISTS buyers;
CREATE TABLE buyers(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор покупателя',
	first_name VARCHAR(100) NOT NULL COMMENT 'Имя покупателя',
	last_name VARCHAR(100) NOT NULL COMMENT 'Фамилия покупателя',
	birthday DATE COMMENT 'Дата рождения покупателя',
	email VARCHAR(100) NOT NULL UNIQUE COMMENT 'Эл.почта покупателя',
	phone VARCHAR(16) NOT NULL UNIQUE COMMENT 'Телефон покупателя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица покупателей';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор товара',
	catalog_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на категорию товара', 
	picture_id INT UNSIGNED COMMENT 'Ссылка на изображение товара',
	name VARCHAR(255) NOT NULL COMMENT 'Наименование товара',
	description VARCHAR(255) COMMENT 'Описание товара',
	price DECIMAL (11,2) COMMENT 'Цена товара',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица товаров';

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs( 
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор каталога',
	name VARCHAR(100) NOT NULL COMMENT 'Название каталога'
) COMMENT 'Таблица каталогов';

DROP TABLE IF EXISTS pictures;
CREATE TABLE pictures(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор картинки товара',
	file_name VARCHAR(255) NOT NULL COMMENT 'Имя файла картинки',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица картинок товаров';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор скидки на товар',
	product_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на товар',
	discount DECIMAL(11,1) UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
	start_at DATETIME COMMENT 'Дата начала действия скидки',
	stop_at DATETIME COMMENT 'Дата окончания действия скидки',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица скидок';

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор отзыва на товар',
	buyer_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на покупателя',
	product_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на товар',
	quality ENUM('1', '2', '3', '4', '5') NOT NULL COMMENT 'Качество товара',
	description VARCHAR(255) COMMENT 'Отзыв на товар',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица отзывов';

-- ALTER TABLE products DROP CONSTRAINT products_catalog_id;
ALTER TABLE products ADD CONSTRAINT products_catalog_id FOREIGN KEY (catalog_id) REFERENCES catalogs(id);
-- ALTER TABLE products DROP CONSTRAINT products_picture_id;
ALTER TABLE products ADD CONSTRAINT products_picture_id FOREIGN KEY (picture_id) REFERENCES pictures(id);
-- ALTER TABLE discounts DROP CONSTRAINT discounts_product_id;
ALTER TABLE discounts ADD CONSTRAINT discounts_product_id FOREIGN KEY (product_id) REFERENCES products(id);
-- ALTER TABLE reviews DROP CONSTRAINT reviews_buyer_id;
ALTER TABLE reviews ADD CONSTRAINT reviews_buyer_id FOREIGN KEY (buyer_id) REFERENCES buyers(id);
-- ALTER TABLE reviews DROP CONSTRAINT reviews_product_id;
ALTER TABLE reviews ADD CONSTRAINT reviews_product_id FOREIGN KEY (product_id) REFERENCES products(id);
CREATE INDEX buyers_indx ON buyers(first_name, last_name);
CREATE INDEX products_indx ON products(name);

DROP TABLE IF EXISTS warehouses;
CREATE TABLE warehouses(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор склада',
	name VARCHAR(50) NOT NULL COMMENT 'Название склада',
	address VARCHAR(100) NOT NULL COMMENT 'Адрес склада',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица складов/магазинов';

DROP TABLE IF EXISTS warehouse_products;
CREATE TABLE warehouse_products(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор картинки товара',
	warehouse_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на склад',
	product_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на товар',
 	quantity INT UNSIGNED COMMENT 'Количество товара на складе',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица товаров на складе';

-- ALTER TABLE warehouse_products DROP CONSTRAINT warehouse_products_warehouse_id;
ALTER TABLE warehouse_products ADD CONSTRAINT warehouse_products_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id);
-- ALTER TABLE warehouse_products DROP CONSTRAINT warehouse_products_product_id;
ALTER TABLE warehouse_products ADD CONSTRAINT warehouse_products_product_id FOREIGN KEY (product_id) REFERENCES products(id);
CREATE INDEX warehouses_indx ON warehouses(name, address);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор заказа',
	buyer_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на покупателя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица заказов';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор товаров в заказе',
	order_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на заказ',
	product_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на товар',
	quantity INT UNSIGNED DEFAULT 1 COMMENT 'Количество товара в заказе',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица наполнения заказа';

-- ALTER TABLE orders DROP CONSTRAINT orders_buyer_id;
ALTER TABLE orders ADD CONSTRAINT orders_buyer_id FOREIGN KEY (buyer_id) REFERENCES buyers(id);
-- ALTER TABLE orders_products DROP CONSTRAINT orders_products_order_id;
ALTER TABLE orders_products ADD CONSTRAINT orders_products_order_id FOREIGN KEY (order_id) REFERENCES orders(id);
-- ALTER TABLE orders_products DROP CONSTRAINT orders_products_order_id;
ALTER TABLE orders_products ADD CONSTRAINT orders_products_product_id FOREIGN KEY (product_id) REFERENCES products(id);

***********************************************************************************************************************************************************************************************************
-- 2 блок: наполнение таблиц данными
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Дмитрий', 'Менделеев', '1834-02-08', 'd.mendeleev@mail.ru', '+7(905)123-01-01', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Владимир', 'Вернадский', '1863-02-28', 'v.vernadsky@mail.ru', '+7(905)456-21-89', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Сергей', 'Королёв', '1906-01-12', 's.korolev@mail.ru', '+7(905)895-23-78', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Владимир', 'Высоцкий', '1938-01-25', 'v.visotsky@mail.ru', '+7(905)458-48-12', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Юрий', 'Гагарин', '1934-03-09', 'y.gagarin@mail.ru', '+7(905)895-56-89', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Георгий', 'Жуков', '1896-11-19', 'g.zhukov@mail.ru', '+7(905)516-42-69', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Лев', 'Яшин', '1929-10-22', 'l.yashin@mail.ru', '+7(905)896-45-78', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Валерий', 'Чкалов', '1904-02-02', 'v.chkalov@mail.ru', '+7(905)896-74-12', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Михаил', 'Калашников', '1919-11-10', 'm.kalashnikov@mail.ru', '+7(905)123-11-99', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('Иван', 'Поддубный', '1871-09-26', 'i.poddubny@mail.ru', '+7(905)789-94-23', NOW(), NOW());

INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_01', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_02', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_03', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_04', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_05', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_06', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_07', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_08', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_09', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('картинка_10', NOW(), NOW());

INSERT INTO catalogs (name) VALUES ('категория_1');
INSERT INTO catalogs (name) VALUES ('категория_2');
INSERT INTO catalogs (name) VALUES ('категория_3');
INSERT INTO catalogs (name) VALUES ('категория_4');
INSERT INTO catalogs (name) VALUES ('категория_5');

INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (1, 1, 'макет "Таблица Менделеева"', 'Периодическая система химических элементов', '20733', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (2, 2, 'памятная монета им.Вернадского', 'Памятная серебряная монету номиналом в 2 рубля, посвящённую 150-летию со дня рождения естествоиспытателя В. И. Вернадского', '17510', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (3, 3, 'космический корабль «Восток-1»', 'Первый космический аппарат, поднявший человека на околоземную орбиту', '99200', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (4, 4, 'гитара Высоцкого', 'Музыкальный интсрумент', '68235', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (5, 5, 'модель  МиГ-15', 'Советский реактивный истребитель, разработанный ОКБ Микояна и Гуревича в конце 1947 года', '15681', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (1, 6, 'будёновка Жукова', 'Головной убор Г.Жукова', '56987', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (2, 7, 'кубок "Золотой мяч"', 'Футбольная награда, присуждаемая лучшему футболисту', '74604', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (3, 8, 'почтовая марка В.Чкалов', 'Марка из серии почтовых марок (СССР, 1938)', '36653', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (4, 9, 'автомат «АК-47»', 'Самое распространённое стрелковое оружие в мире', '17870', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (5, 10, 'пудовая гиря', 'Спортивный снаряд, обладающий специальной формой в виде металлического ядра с рукоятью', '44764', NOW(), NOW());

INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (1, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (2, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (3, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (4, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (5, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (6, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (7, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (8, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (9, NOW(), NOW());
INSERT INTO orders (buyer_id, created_at, updated_at) VALUES (10, NOW(), NOW());

INSERT INTO warehouses (name, address, created_at, updated_at) VALUES ('Склад_1', 'г.Актобе', NOW(), NOW());
INSERT INTO warehouses (name, address, created_at, updated_at) VALUES ('Склад_2', 'г.Уральск', NOW(), NOW());
INSERT INTO warehouses (name, address, created_at, updated_at) VALUES ('Склад_3', 'г.Актау', NOW(), NOW());
INSERT INTO warehouses (name, address, created_at, updated_at) VALUES ('Склад_4', 'г.Атырау', NOW(), NOW());

INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (1, 1, 1500, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (1, 2, 1200, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (1, 3, 1000, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (2, 4, 1600, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (2, 5, 1300, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (3, 6, 1700, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (3, 7, 1400, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (4, 8, 1800, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (4, 9, 1600, NOW(), NOW());
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, created_at, updated_at) VALUES (4, 10, 1100, NOW(), NOW());

INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (1, 1, '3', 'Ut dolor itaque aut assumenda. Modi sit ab quisquam occaecati.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (2, 2, '4', 'Neque nulla provident doloremque vel voluptatem perspiciatis optio praesentium.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (3, 3, '5', 'Ut voluptas est hic et. A repudiandae rerum ut. Ut laudantium a commodi provident quis placeat et.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (4, 4, '5', 'Eos adipisci veniam ducimus et nulla animi nobis. Et rerum totam ratione alias.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (5, 5, '5', 'Ut dolorum rerum fugiat quae totam aut eius. Quae odit tenetur quas eum.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (6, 6, '1', 'Soluta rerum eos est itaque temporibus quae nulla qui. Eum et id perspiciatis laborum.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (7, 7, '1', 'Ad quibusdam vel voluptas sunt autem ad sequi. Quae laboriosam velit provident esse sed autem.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (8, 8, '3', 'Illo quod sunt fugit cum qui voluptate culpa. Placeat pariatur tempora ut. Sed sit dolores omnis dicta.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (9, 9, '3', 'Omnis iure repellendus dolorum sapiente laborum. Consequatur rem est voluptatum quas possimus rem.', NOW(), NOW());
INSERT INTO reviews (buyer_id, product_id, quality, description, created_at, updated_at) VALUES (10, 10, '1', 'Nisi esse quae nobis vitae deserunt animi. Quas omnis et eaque quod consequuntur ut.', NOW(), NOW());

INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (1, 1, 100, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (2, 2, 150, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (3, 3, 200, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (4, 4, 300, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (5, 5, 450, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (6, 6, 500, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (7, 7, 650, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (8, 8, 700, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (9, 9, 750, NOW(), NOW());
INSERT INTO orders_products (order_id, product_id, quantity, created_at, updated_at) VALUES (10, 10, 800, NOW(), NOW());

INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (1, '0.3', '2021-04-25 06:24:03', '2021-05-19 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (2, '0.3', '2021-06-05 06:24:03', '2021-06-30 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (3, '0.4', '2021-01-01 06:24:03', '2021-01-19 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (4, '0.5', '2021-03-10 06:24:03', '2021-03-20 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (5, '0.1', '2021-04-07 06:24:03', '2021-05-07 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (6, '0.8', '2021-08-02 06:24:03', '2021-08-12 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (7, '0.7', '2021-11-13 06:24:03', '2021-12-13 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (8, '0.5', '2021-09-09 06:24:03', '2021-09-18 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (9, '0.5', '2021-02-05 06:24:03', '2021-02-15 23:50:40', NOW(), NOW());
INSERT INTO discounts (product_id, discount, start_at, stop_at, created_at, updated_at) VALUES (10, '0.6', '2021-12-26 06:24:03', '2021-12-26 23:50:40', NOW(), NOW());

SELECT * FROM buyers b ;
SELECT * FROM pictures p ;
SELECT * FROM catalogs c ;
SELECT * FROM products p ;
SELECT * FROM orders o ;
SELECT * FROM warehouses w ;
SELECT * FROM warehouse_products wp ;
SELECT * FROM reviews r ;
SELECT * FROM orders_products op ;
SELECT * FROM discounts d ;
SELECT count(1) FROM orders;
SELECT count(1) FROM orders_products op ;












































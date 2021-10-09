/* ������ ���� ������ ��������-��������.
 * ����������, �������� � �������� ������������ � ��� ����,
 * � ������� � �� �������. �������� ��� �� ��������� ������� ��. */

DROP DATABASE IF EXISTS im;
CREATE DATABASE im;
USE im;

-- 1 ����: �������� ������, ������ � �����������
DROP TABLE IF EXISTS buyers;
CREATE TABLE buyers(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ����������',
	first_name VARCHAR(100) NOT NULL COMMENT '��� ����������',
	last_name VARCHAR(100) NOT NULL COMMENT '������� ����������',
	birthday DATE COMMENT '���� �������� ����������',
	email VARCHAR(100) NOT NULL UNIQUE COMMENT '��.����� ����������',
	phone VARCHAR(16) NOT NULL UNIQUE COMMENT '������� ����������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� �����������';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������',
	catalog_id INT UNSIGNED NOT NULL COMMENT '������ �� ��������� ������', 
	picture_id INT UNSIGNED COMMENT '������ �� ����������� ������',
	name VARCHAR(255) NOT NULL COMMENT '������������ ������',
	description VARCHAR(255) COMMENT '�������� ������',
	price DECIMAL (11,2) COMMENT '���� ������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� �������';

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs( 
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ��������',
	name VARCHAR(100) NOT NULL COMMENT '�������� ��������'
) COMMENT '������� ���������';

DROP TABLE IF EXISTS pictures;
CREATE TABLE pictures(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������� ������',
	file_name VARCHAR(255) NOT NULL COMMENT '��� ����� ��������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� �������� �������';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������ �� �����',
	product_id INT UNSIGNED NOT NULL COMMENT '������ �� �����',
	discount DECIMAL(11,1) UNSIGNED COMMENT '�������� ������ �� 0.0 �� 1.0',
	start_at DATETIME COMMENT '���� ������ �������� ������',
	stop_at DATETIME COMMENT '���� ��������� �������� ������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� ������';

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������ �� �����',
	buyer_id INT UNSIGNED NOT NULL COMMENT '������ �� ����������',
	product_id INT UNSIGNED NOT NULL COMMENT '������ �� �����',
	quality ENUM('1', '2', '3', '4', '5') NOT NULL COMMENT '�������� ������',
	description VARCHAR(255) COMMENT '����� �� �����',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� �������';

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
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������',
	name VARCHAR(50) NOT NULL COMMENT '�������� ������',
	address VARCHAR(100) NOT NULL COMMENT '����� ������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� �������/���������';

DROP TABLE IF EXISTS warehouse_products;
CREATE TABLE warehouse_products(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� �������� ������',
	warehouse_id INT UNSIGNED NOT NULL COMMENT '������ �� �����',
	product_id INT UNSIGNED NOT NULL COMMENT '������ �� �����',
 	quantity INT UNSIGNED COMMENT '���������� ������ �� ������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� ������� �� ������';

-- ALTER TABLE warehouse_products DROP CONSTRAINT warehouse_products_warehouse_id;
ALTER TABLE warehouse_products ADD CONSTRAINT warehouse_products_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id);
-- ALTER TABLE warehouse_products DROP CONSTRAINT warehouse_products_product_id;
ALTER TABLE warehouse_products ADD CONSTRAINT warehouse_products_product_id FOREIGN KEY (product_id) REFERENCES products(id);
CREATE INDEX warehouses_indx ON warehouses(name, address);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������',
	buyer_id INT UNSIGNED NOT NULL COMMENT '������ �� ����������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� �������';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '������������� ������� � ������',
	order_id INT UNSIGNED NOT NULL COMMENT '������ �� �����',
	product_id INT UNSIGNED NOT NULL COMMENT '������ �� �����',
	quantity INT UNSIGNED DEFAULT 1 COMMENT '���������� ������ � ������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������� ���������� ������';

-- ALTER TABLE orders DROP CONSTRAINT orders_buyer_id;
ALTER TABLE orders ADD CONSTRAINT orders_buyer_id FOREIGN KEY (buyer_id) REFERENCES buyers(id);
-- ALTER TABLE orders_products DROP CONSTRAINT orders_products_order_id;
ALTER TABLE orders_products ADD CONSTRAINT orders_products_order_id FOREIGN KEY (order_id) REFERENCES orders(id);
-- ALTER TABLE orders_products DROP CONSTRAINT orders_products_order_id;
ALTER TABLE orders_products ADD CONSTRAINT orders_products_product_id FOREIGN KEY (product_id) REFERENCES products(id);

***********************************************************************************************************************************************************************************************************
-- 2 ����: ���������� ������ �������
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('�������', '���������', '1834-02-08', 'd.mendeleev@mail.ru', '+7(905)123-01-01', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('��������', '����������', '1863-02-28', 'v.vernadsky@mail.ru', '+7(905)456-21-89', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('������', '������', '1906-01-12', 's.korolev@mail.ru', '+7(905)895-23-78', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('��������', '��������', '1938-01-25', 'v.visotsky@mail.ru', '+7(905)458-48-12', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('����', '�������', '1934-03-09', 'y.gagarin@mail.ru', '+7(905)895-56-89', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('�������', '�����', '1896-11-19', 'g.zhukov@mail.ru', '+7(905)516-42-69', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('���', '����', '1929-10-22', 'l.yashin@mail.ru', '+7(905)896-45-78', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('�������', '������', '1904-02-02', 'v.chkalov@mail.ru', '+7(905)896-74-12', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('������', '����������', '1919-11-10', 'm.kalashnikov@mail.ru', '+7(905)123-11-99', NOW(), NOW());
INSERT INTO buyers (first_name, last_name, birthday, email, phone, created_at, updated_at) VALUES ('����', '���������', '1871-09-26', 'i.poddubny@mail.ru', '+7(905)789-94-23', NOW(), NOW());

INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_01', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_02', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_03', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_04', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_05', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_06', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_07', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_08', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_09', NOW(), NOW());
INSERT INTO pictures (file_name, created_at, updated_at) VALUES ('��������_10', NOW(), NOW());

INSERT INTO catalogs (name) VALUES ('���������_1');
INSERT INTO catalogs (name) VALUES ('���������_2');
INSERT INTO catalogs (name) VALUES ('���������_3');
INSERT INTO catalogs (name) VALUES ('���������_4');
INSERT INTO catalogs (name) VALUES ('���������_5');

INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (1, 1, '����� "������� ����������"', '������������� ������� ���������� ���������', '20733', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (2, 2, '�������� ������ ��.�����������', '�������� ���������� ������ ��������� � 2 �����, ����������� 150-����� �� ��� �������� ������������������ �. �. �����������', '17510', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (3, 3, '����������� ������� �������-1�', '������ ����������� �������, ��������� �������� �� ����������� ������', '99200', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (4, 4, '������ ���������', '����������� ����������', '68235', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (5, 5, '������  ���-15', '��������� ���������� �����������, ������������� ��� ������� � �������� � ����� 1947 ����', '15681', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (1, 6, '�������� ������', '�������� ���� �.������', '56987', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (2, 7, '����� "������� ���"', '���������� �������, ������������ ������� ����������', '74604', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (3, 8, '�������� ����� �.������', '����� �� ����� �������� ����� (����, 1938)', '36653', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (4, 9, '������� ���-47�', '����� ��������������� ���������� ������ � ����', '17870', NOW(), NOW());
INSERT INTO products (catalog_id, picture_id, name, description, price, created_at, updated_at) VALUES (5, 10, '������� ����', '���������� ������, ���������� ����������� ������ � ���� �������������� ���� � ��������', '44764', NOW(), NOW());

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

INSERT INTO warehouses (name, address, created_at, updated_at) VALUES ('�����_1', '�.������', NOW(), NOW());
INSERT INTO warehouses (name, address, created_at, updated_at) VALUES ('�����_2', '�.�������', NOW(), NOW());
INSERT INTO warehouses (name, address, created_at, updated_at) VALUES ('�����_3', '�.�����', NOW(), NOW());
INSERT INTO warehouses (name, address, created_at, updated_at) VALUES ('�����_4', '�.������', NOW(), NOW());

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












































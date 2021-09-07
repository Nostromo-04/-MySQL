DROP DATABASE vk;
CREATE DATABASE vk;

SHOW DATABASES;

USE vk;

CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    first_name VARCHAR(100) NOT NULL COMMENT 'Имя пользователя',
	last_name VARCHAR(100) NOT NULL COMMENT 'Фамилия пользователя',
	birthday DATE NOT NULL COMMENT 'Дата рождения',
	gender CHAR(1) NOT NULL COMMENT 'Пол Пользователя',
	email VARCHAR(100) NOT NULL UNIQUE COMMENT 'Email пользователя',
	phone VARCHAR(11) NOT NULL UNIQUE COMMENT 'Номер телефона пользователя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
) COMMENT 'Таблица пользователей';

SELECT REGEXP_LIKE('+79991234567', '^\\+7[0-9]{10}$');
ALTER TABLE users MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY gender ENUM('M','F') NOT NULL COMMENT 'Пол Пользователя';
ALTER TABLE users MODIFY phone VARCHAR(12) NOT NULL UNIQUE COMMENT 'Номер телефона пользователя'; 
ALTER TABLE users DROP CONSTRAINT сheck_phone;
ALTER TABLE users ADD CONSTRAINT сheck_phone CHECK (REGEXP_LIKE(phone, '^\\+7[0-9]{10}$')) ; -- пользвательское правило

DESCRIBE users;

CREATE TABLE profiles (
	user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Идентификатор строки',
    city VARCHAR(100) COMMENT 'Город проживания',
	country VARCHAR(100) COMMENT 'Страна проживания',
	`status` VARCHAR(10) COMMENT 'Текущий статус',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
) COMMENT 'Таблица профилей';

ALTER TABLE profiles MODIFY `status` ENUM('Online','Offline','Inactive') NOT NULL;
ALTER TABLE profiles ADD CONSTRAINT profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id);

DROP TABLE friendship;
CREATE TABLE friendship (
	user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на инициатора дружбы',
	friend_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на получателя запроса о дружбе',
	request_type_id INT UNSIGNED NOT NULL COMMENT 'Тип запроса',
    requested_at DATETIME COMMENT 'Дата и время отправки приглашения',
	confirmed_at DATETIME COMMENT 'Дата и время подтверждения приглашения',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки',
    PRIMARY KEY (user_id, friend_id) COMMENT 'Составной первичный ключ'
) COMMENT 'Таблица дружбы';

ALTER TABLE friendship ADD CONSTRAINT friendship_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT friendship_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

ALTER TABLE friendship DROP COLUMN request_type; 
ALTER TABLE friendship ADD COLUMN request_type_id INT UNSIGNED NOT NULL COMMENT 'Тип запроса';
DESCRIBE friendship;

CREATE TABLE friendship_request_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
	name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Email пользователя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
    ) COMMENT 'Типы запроса на дружбу';

ALTER TABLE friendship ADD CONSTRAINT friendship_request_type_id FOREIGN KEY (request_type_id) REFERENCES friendship_request_types(id);

SHOW TABLES;
RENAME TABLE community_id TO communities;
CREATE TABLE communities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
	name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название группы',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
    ) COMMENT 'Таблицы группы';
    
    CREATE TABLE communities_users (
	community_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на группу',
	user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	PRIMARY KEY (community_id, user_id) COMMENT 'Составной первичный ключ',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
    ) COMMENT 'Участники групп, связь между пользователями и группами';
    
ALTER TABLE communities_users DROP CONSTRAINT communities_community_id;
ALTER TABLE communities_users ADD CONSTRAINT communities_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
ALTER TABLE communities_users ADD CONSTRAINT communities_user_id FOREIGN KEY (user_id) REFERENCES users(id);
DESCRIBE communities_users;

CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
	from_user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на отправителя сообщения',
	to_user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на получателя сообщения',
    body TEXT NOT NULL COMMENT 'Текст сообщения',
    is_important BOOLEAN COMMENT 'Признак важности',
    is_delivered BOOLEAN COMMENT 'Признак доставки',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
) COMMENT 'Таблица сообщений';

ALTER TABLE messages ADD CONSTRAINT messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);    

DROP TABLE media;
CREATE TABLE media (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    filename VARCHAR(255) NOT NULL COMMENT 'Полный путь к файлу',
	media_type_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на тип файла',
    metadata JSON NOT NULL COMMENT 'Метаданные файла',
	user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
) COMMENT 'Таблица медиафайлы';

CREATE TABLE media_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название типа',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
) COMMENT 'Типы медиафайлов';

ALTER TABLE media ADD CONSTRAINT media_media_type_id FOREIGN KEY (media_type_id) REFERENCES media_types(id);
ALTER TABLE media ADD CONSTRAINT media_to_user_id FOREIGN KEY (user_id) REFERENCES users(id);  

-- добавил таблицу постов
CREATE TABLE posts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
	post_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на пост',
	body TEXT NOT NULL COMMENT 'Текст поста',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
) COMMENT 'Таблица постов';

ALTER TABLE posts ADD CONSTRAINT posts_post_id FOREIGN KEY (post_id) REFERENCES users(id);

--добавил таблицу лайков
CREATE TABLE likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    like_type_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на тип лайка',
    user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
) COMMENT 'Таблица лайков';

CREATE TABLE likes_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название типа',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата и время создания строки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата и время обновления строки'
) COMMENT 'Типы лайков';

ALTER TABLE likes ADD CONSTRAINT likes_like_type_id FOREIGN KEY (like_type_id) REFERENCES likes_types(id);
ALTER TABLE likes ADD CONSTRAINT likes_user_id FOREIGN KEY (user_id) REFERENCES users(id);

SHOW TABLES;


  

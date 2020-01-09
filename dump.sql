create table users
(
    id           bigint unsigned not null auto_increment primary key ,
    first_name   varchar(255) null,
    last_name    varchar(255) null,
    email        varchar(255) unique not null,
    password     varchar(255) null,
    role         enum ('ADMIN','WORKER'),
    created_date datetime not null,
    updated_date datetime not null,
    active       boolean default FALSE,
    email_uuid   varchar(64) not null,
    account_id   bigint UNSIGNED null
);

ALTER TABLE users
    ADD CONSTRAINT acc_fk
        FOREIGN KEY (account_id)
            REFERENCES accounts (id);

CREATE TABLE accounts
(
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(45) NOT NULL,
  type_id      BIGINT UNSIGNED NOT NULL,
  admin_id     BIGINT UNSIGNED NOT NULL,
  created_date DATETIME    NOT NULL,
  active       boolean default TRUE
);

ALTER TABLE accounts
    ADD CONSTRAINT type_id_fk
        FOREIGN KEY (type_id)
            REFERENCES account_types (id);
            
ALTER TABLE accounts
    ADD CONSTRAINT admin_fk
        FOREIGN KEY (admin_id)
            REFERENCES users (id);


CREATE TABLE account_types
(
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name                VARCHAR(45) NOT NULL,
  price               DOUBLE      NOT NULL,
  level               INT         NOT NULL,
  max_warehouses      INT         NOT NULL,
  max_warehouse_depth INT         NOT NULL,
  max_users           INT         NOT NULL,
  max_suppliers       INT         NOT NULL,
  max_clients         INT         NOT NULL,
  active              boolean default TRUE
);

CREATE TABLE warehouses
(
    id         BIGINT UNSIGNED NOT NULL,
    name       VARCHAR(45)  NOT NULL,
    info       VARCHAR(100) NULL,
    capacity   INT UNSIGNED NULL,
    is_bottom  TINYINT(1)   NOT NULL,
    parent_id  BIGINT UNSIGNED NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    active     TINYINT(1)   NULL,
    PRIMARY KEY (id),
    UNIQUE INDEX id_UNIQUE (id ASC) 
);

ALTER TABLE warehouses
    ADD CONSTRAINT parent
        FOREIGN KEY (parent_id)
            REFERENCES warehouses (id);
            
ALTER TABLE warehouses
    ADD CONSTRAINT acc_id_2
        FOREIGN KEY (account_id)
            REFERENCES accounts (id);
            
create table items
(
    id          bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name_item   varchar(255) NOT NULL,
    unit        varchar(255) not null,
    description varchar(255) not null,
    volume      int not null,
    active      tinyint      not null,
    account_id  bigint UNSIGNED not null
);

ALTER TABLE items
    ADD CONSTRAINT acc_id_3
        FOREIGN KEY (account_id)
            REFERENCES accounts (id); 

create table saved_items
(
    id           bigint AUTO_INCREMENT PRIMARY KEY,
    item_id     bigint UNSIGNED NOT NULL,
    quantity     int    NOT NULL,
    warehouse_id bigint UNSIGNED not null
);

ALTER TABLE saved_items
    ADD CONSTRAINT item_id_fk
        FOREIGN KEY (item_id)
            REFERENCES items (id);
            
ALTER TABLE saved_items
    ADD CONSTRAINT warehouse_id_fk
        FOREIGN KEY (warehouse_id)
            REFERENCES warehouses (id); 

CREATE TABLE events
(
    id             bigint(11) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    message        text             NOT NULL,
    date           datetime         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_id     bigint(11) UNSIGNED NOT NULL,
    warehouse_id   bigint(11) UNSIGNED DEFAULT NULL,
    author_id      bigint(11) UNSIGNED NOT NULL,
    name           varchar(32)      NOT NULL,
    transaction_id bigint(11) UNSIGNED DEFAULT NULL
);

ALTER TABLE events
    ADD CONSTRAINT account_id_4_fk
        FOREIGN KEY (account_id)
            REFERENCES accounts (id);
            
ALTER TABLE events
    ADD CONSTRAINT warehouse_id_2_fk
        FOREIGN KEY (warehouse_id)
            REFERENCES warehouses (id); 
            
ALTER TABLE events
    ADD CONSTRAINT author_id_fk
        FOREIGN KEY (author_id)
            REFERENCES users (id); 
            
ALTER TABLE events
    ADD CONSTRAINT transaction_id_fk
        FOREIGN KEY (transaction_id)
            REFERENCES transactions (id); 

create table transactions
(
    id           bigint unsigned  not null auto_increment primary key,
    timestamp    timestamp        not null default current_timestamp,
    account_id   bigint(11) unsigned not null,
    worker_id    bigint(11) unsigned not null,
    item_id      bigint(11) unsigned not null,
    quantity     int(11) unsigned not null,
    associate_id bigint(11) unsigned null,
    moved_from   bigint(11) unsigned null,
    moved_to     bigint(11) unsigned null,
    type         enum ('IN', 'OUT', 'MOVE')
);


ALTER TABLE transactions
    ADD CONSTRAINT account_id_5_fk
        FOREIGN KEY (account_id)
            REFERENCES accounts (id); 
            
ALTER TABLE transactions
    ADD CONSTRAINT worker_id
        FOREIGN KEY (worker_id)
            REFERENCES users (id); 
            
ALTER TABLE transactions
    ADD CONSTRAINT item_id_2_fk
        FOREIGN KEY (item_id)
            REFERENCES items (id); 
            
ALTER TABLE transactions
    ADD CONSTRAINT associate_id_fk
        FOREIGN KEY (associate_id)
            REFERENCES associates (id);
            
ALTER TABLE transactions
    ADD CONSTRAINT moved_from_fk
        FOREIGN KEY (moved_from)
            REFERENCES warehouses (id); 
            
ALTER TABLE transactions
    ADD CONSTRAINT moved_to_fk
        FOREIGN KEY (moved_to)
            REFERENCES warehouses (id);

create table associates
(
    id              bigint(11) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    account_id      bigint(11) UNSIGNED  not null,
    name            varchar(45)      not null,
    email           varchar(60)      null,
    phone           varchar(20)      null,
    additional_info mediumtext       null,
    type            enum ('CLIENT', 'SUPPLIER'),
    active          boolean default TRUE
);

ALTER TABLE associates
    ADD CONSTRAINT account_id_fk
        FOREIGN KEY (account_id)
            REFERENCES accounts (id);

create table addresses
(
    id           bigint(11) unsigned not null auto_increment primary key,
    country      varchar(255)     null,
    city         varchar(255)     null,
    address      varchar(255)     null,
    zip          varchar(11)      null,
    latitude     float(10, 8)     null,
    longitude    float(11, 8)     null,
    warehouse_id bigint(11) unsigned null,
    associate_id bigint(11) unsigned null
);

ALTER TABLE addresses
    ADD CONSTRAINT warehouse_2_id_fk
        FOREIGN KEY (warehouse_id)
            REFERENCES warehouses (id);
            
ALTER TABLE addresses
    ADD CONSTRAINT associate_id_2_fk
        FOREIGN KEY (associate_id)
            REFERENCES associates (id);

ALTER TABLE accounts DROP FOREIGN KEY admin_fk;
ALTER TABLE warehouses DROP FOREIGN KEY acc_id_2;
drop table users;
drop table accounts;
drop table account_types;
drop table warehouses;
drop table items;
drop table saved_items;
drop table events;
drop table transactions;
drop table associates;
drop table addresses;

#--------------
#populate db
INSERT INTO users
(first_name, last_name, email,  password, role,
 created_date, updated_date, active, email_uuid, account_id)
VALUES('Mariia','Slobodian','slobodjanmarija1@gmail.com',
		'5f4dcc3b5aa765d61d8327deb882cf99',
       'ADMIN','2019-01-01 00:00:00','2019-01-01 00:00:00',
       true,'03bfe72c-0d5d-11ea-8d71-362b9e155667', 1),
       ('Olha','Slobodian','slobodian.olha.work@gmail.com',
		'7f4dcc3b5aa76gh61d8327deb882cf99',
        'WORKER','2019-02-01 00:00:00','2019-02-01 00:00:00',
        true,'08bfe72c-0d5d-11ea-8d75-362b9e155667', 1),
       ('Bohdan','Slobodian','slobodian.bohdan@gmail.com',
		'9d4dcc3b5aa765d61d8327deb882cf99',
        'ADMIN','2019-03-01 00:00:00','2019-03-01 00:00:00',
        false,'03bfe72c-0d5d-12ea-8d71-362b9e155667', 1);

INSERT INTO accounts
(name, type_id, admin_id, created_date, active)
VALUES
('Home', 1, 1,'2019-01-01 00:00:00', true),
('Warehouse', 1, 3,'2019-03-01 00:00:00', true),
('Goods',1, 1, '2019-12-24 22:00:00', true);

INSERT INTO account_types
(name, price, level, max_warehouses, max_warehouse_depth, max_users,
								max_suppliers, max_clients, active)
VALUES('basic', 1000, 3, 3, 3, 20, 20, true);

INSERT INTO warehouses
(name, info, capacity, is_bottom, parent_id, account_id, active)
VALUES
('room', 'room is warehouse', 3, true, null, 1, true),
('shelf', 'shelf is in room', 3, false, 1, 1, true);

INSERT INTO items
(name_item, unit, description, volume, active, account_id)
VALUES
('Devaytis', 'block','high carbonated mineral water', 12, 1, 1),
('Bonakva', 'block','low carbonated mineral water',	6, 1, 2);

INSERT INTO saved_items(item_id, quantity, warehouse_id)
VALUES
(1, 100, 1),
(2, 120, 2),
(3, 90, 2);

INSERT INTO events
(message, date, account_id, author_id, warehouse_id, name, transaction_id)
VALUES
('User Vasyl login', '2000-07-27, 122', 7, 34432, 'LOGIN', NULL),
('Phones were shipped from warehouse 12', '2005-01-13, 235', 12, 53872,	'ITEM_SHIPPED', 66723);

INSERT INTO transactions(account_id, worker_id, associate_id, item_id, quantity,
														moved_from, moved_to, type)
VALUES
(2019-01-01, 1,	1,	1,	1,	10,	null),
(2019-12-31, 1,	1,	10,	3,	20,	1);

INSERT INTO associates
( account_id, name, email, phone, additional_info, type, active)
VALUES
(1, 'John Doe', 'john.doe@shopify.com',	null, null, 'CLIENT', TRUE),
(1, 'Charles Brocade', 'charly.br@gmail.com', '+1-541-754-3010', null, 'SUPPLIER', TRUE);

INSERT INTO addresses(warehouse_id, country, city, address, zip, latitude, longitude)
VALUES
('Japan','Tokyo','Kyobashi', 'Kyobashi MID Bldg., 13-10, Kyobashi 2-chome, Chuo-ku',
												153-0051, 35.6850,139.7514,	null, 2),
('United States','New York','151 Pennington Street Brooklyn, NY 11236', 10004, 40.6943,
																	-73.9249, 1, null);
#population end                                                                     
#-------------


#------------------
#---main queries---
#------------------
#find by id
SELECT *
FROM users
WHERE id = 1;

#find count
SELECT COUNT(*)
FROM users
WHERE account_id = 2;

#find by email
SELECT *
FROM users
WHERE email = 'slobodjanmarija1@gmail.com';

#find admin
SELECT *
FROM users
WHERE role = 'ADMIN'
AND account_id = 1;

#find all account possible to upgrage
SELECT *
FROM account_types
WHERE level > ?
AND active = true;

#SQL_FIND_POPULAR_ITEMS 
SELECT it.name_item AS name,
sum(ts.quantity) AS quantity
FROM transactions ts
JOIN items it
ON ts.item_id = it.id
WHERE type = 'OUT';

#SQL_FIND_WAREHOUSE_LOAD_BY_ACCOUNT_ID
SELECT top_warehouse_id id,  ifnull(sum(charge),0) charge, ifnull(sum(capacity),0) capacity
FROM
(SELECT warehouse_id, it.account_id, sum(quantity*volume) charge
FROM saved_items si
JOIN items it
ON si.item_id = it.id
JOIN warehouses wh
ON si.warehouse_id = wh.id
GROUP BY warehouse_id) AS  cha
RIGHT JOIN
(SELECT id, capacity, account_id, top_warehouse_id
FROM warehouses
WHERE is_bottom=1) AS cap
ON  cha.warehouse_id=cap.id AND  cha.account_id=cap.account_id
WHERE cap.account_id=2
GROUP BY top_warehouse_id;

#SQL_COUNT_QUANTITY_OF_WAREHOUSE_BY_ACCOUNT_ID
SELECT COUNT(id)
FROM warehouses
WHERE parent_id IS NULL
AND account_id = 2;

#SQL_LEVEL_WAREHOUSE_BY_PARENT_ID
WITH RECURSIVE cte AS
(SELECT id, 1 as depth
FROM warehouses
WHERE parent_id IS NULL
UNION ALL
SELECT w.id, cte.depth+1
FROM warehouses w JOIN cte
ON cte.id=w.parent_id)
SELECT depth
FROM cte
WHERE cte.id = ?;

#SQL_FIND_ENDED_ITEMS_BY_ACCOUNT_ID
 SELECT wh.id, wh.name, it.name_item, si.quantity
 FROM saved_items si
 JOIN warehouses wh
 ON si.warehouse_id = wh.id
 JOIN items it
 ON si.item_id = it.id
 WHERE si.quantity <= 20
 AND wh.account_id = 2;
 
#SQL_SELECT_ITEM_BY_ACCOUNT_ID
select *
from items
where account_id=2;

#SQL_SELECT_TRANSACTION_BY_ID
select * 
from transactions 
where id = 2; 

#=========
# update & delete
#SQL_DELETE_USER_BY_ID
DELETE
FROM users
WHERE id = 2;

#update user
UPDATE users
SET 
first_name= 'Mariia',
last_name = 'Slobodian',
email = 'slobodjanmarija1@gmail.com',
updated_date = '2019-03-01 00:00:00'
WHERE id = 1;

#SQL_UPDATE_WAREHOUSE
UPDATE warehouses
SET 
name= 'home',
info = 'Home is a new solution for your warehouse',
capacity = 3,
is_bottom = true,
top_warehouse_id = 1, 
active = true
WHERE id = 4;

#SQL_UPDATE_ASSOCIATE
UPDATE associates
SET 
name = 'John Doe', 
email = 'john.doe@shopify.com', 
phone = '+1-541-754-3010', 
additional_info = 'An active supplier'
WHERE id = ?;


#trigger
DELIMITER ;;
CREATE TRIGGER `insert_before_to_add_warehouse`
BEFORE INSERT 
ON `warehouses`
FOR EACH ROW 
BEGIN
	IF EXISTS ((SELECT COUNT(*) 
					FROM users
					WHERE (account_id) = (NEW.account_id)) <= 3) THEN
			   INSERT INTO warehouses
			   (name, info, capacity, is_bottom, parent_id, account_id, top_warehouse_id, active)
			   VALUES(NEW.name, NEW.info, NEW.capacity, NEW.is_bottom, NEW.parent_id,
				 NEW.account_id, NEW.top_warehouse_id, NEW.active)
	END IF;
END 
DELIMITER ;
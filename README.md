# WarehouseDB
## 1.Database schema. General desccription of tables
### Users
```mysql
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
    account_id   int null
);
```
| id | first_name | last_name | email | password | role | created_date | updated_date | active | email_uuid | account_id |
|----|------------|-----------|-------|----------|------|--------------|--------------|--------|------------|------------|
| 1  | Mariia     | Slobodian | slobodjanmarija1@gmail.com | 5f4dcc3b5aa765d61d8327deb882cf99 | ADMIN | 2019-01-01 00:00:00 | 2019-01-01 00:00:00 | TRUE | 03bfe72c-0d5d-11ea-8d71-362b9e155667 | 1 |
| 2  | Volodymyr | Huk | huk.volodymyr@gmail.com | 630bf032efe4507f2c57b280995925a9 | WORKER | 2019-05-01 00:00:00 | 2019-05-01 00:00:00 | TRUE | 1874136e-0d5d-11ea-8d71-362b9e155667 | 1 |
| 3  | null | null | svefankiv.olha@gmail.com | null | WORKER | 2019-01-02 00:12:00 | 2019-01-02 00:12:00 | FALSE | 2de6f4dc-0d5d-11ea-8d71-362b9e155667 | 1 |
| 4  | Taras     | Sokil | sokil.taras@gmail.com | 5f4dcc3b5aa765d61d8327deb834cf99 | ADMIN | 2019-07-01 00:00:00 | 2019-07-01 00:00:00 | TRUE | 03bfe72c-0d5d-11ea-8d71-362b78155667 | 2 |

***

### Accounts
```mysql
CREATE TABLE accounts
(
  id           INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(45) NOT NULL,
  type_id      INT         NOT NULL,
  admin_id     INT         NOT NULL,
  created_date DATETIME    NOT NULL,
  active       boolean default TRUE
);
```
| id | name | type_id | admin_id | created_date | active | 
|----|------------|-----------|-------|----------|------|
| 1  | travel goods | 2 | 1 | 2019-01-01 13:00:00 | true |
| 2  | building materials| 2 | 15 | 2019-11-07 14:00:00 | true | 
***
### Account_types
```mysql
CREATE TABLE account_types
(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
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
```
| id | name | price | level | max_warehouses | max_warehouse_depth | max_users | max_suppliers | max_clients | active |
|----|------------|-----------|-------|----------|------|--------------|--------------|--------|------------|
| 1  | basic | 0 | 1 | 3 | 3 | 3 | 20 | 20 | true |
| 2  | premium | 300 | 2 | 1000 | 1000 | 10000 | 10000 | 10000 | true |
***

### Warehouses
```mysql
CREATE TABLE warehouses
(
    id         INT UNSIGNED NOT NULL,
    name       VARCHAR(45)  NOT NULL,
    info       VARCHAR(100) NULL,
    capacity   INT UNSIGNED NULL,
    is_bottom  TINYINT(1)   NOT NULL,
    parent_id  INT UNSIGNED NULL,
    account_id INT          NOT NULL,
    active     TINYINT(1)   NULL,
    PRIMARY KEY (id),
    UNIQUE INDEX id_UNIQUE (id ASC) VISIBLE
);

constraint parent___fk
  foreign key (parent_id) references warehouses (id)
    on update cascade,
      constraint top_id___fk
        foreign key (top_warehouse_id) references warehouses (id)
          on update cascade
```

***

### Items
```mysql
create table items
(
    id          bigint AUTO_INCREMENT PRIMARY KEY,
    name_item   varchar(255) NOT NULL,
    unit        varchar(255) not null,
    description varchar(255) not null,
    volume      int not null,
    active      tinyint      not null,
    account_id  bigint       not null
);
```
| id | name_item | unit | description | volume | active | account_id |
|----|-----------|------|-------------|--------|--------|------------|
|1   | Devaytis  |block| high carbonated mineral water  |12 	|1 	|1|
|2   |Bonakva 	 |block| low carbonated mineral water   |6 	|1 	|2|
|3   |Artesiancka|block| high carbonated mineral water  |9 	|1 	|2|
 

***

### Saved Items
```mysql
create table saved_items
(
    id           bigint AUTO_INCREMENT PRIMARY KEY,
    item_id      bigint NOT NULL,
    quantity     int    NOT NULL,
    warehouse_id bigint not null
);
```
| id | items_id | quantity | warehouse_id |
|----|----------|----------|--------------|
| 1  | 1        |100       |1| 
| 2  | 2        |120       |2| 
| 3  | 3        |90        |3| 

***

### Events
```mysql
CREATE TABLE events
(
    id             int(11) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    message        text             NOT NULL,
    date           datetime         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_id     int(11)          NOT NULL,
    warehouse_id   int(11)                   DEFAULT NULL,
    author_id      int(11)          NOT NULL,
    name           varchar(32)      NOT NULL,
    transaction_id int(11)                   DEFAULT NULL
);
```
| id | message | date | org_id | warehouse_id | author_id | name | transaction_id |
|----|---------|------|--------|--------------|-----------|------|----------------|
|2707|User Vasyl login|2000-07-27|122|7|34432|LOGIN|NULL|
|2222|Phones were shipped from warehouse 12|2005-01-13|235|12|53872|ITEM_SHIPPED|66723|
***

### Transactions
```mysql
create table transactions
(
    id           bigint unsigned  not null auto_increment primary key,
    timestamp    timestamp        not null default current_timestamp,
    account_id   int(11) unsigned not null,
    worker_id    int(11) unsigned not null,
    item_id      int(11) unsigned not null,
    quantity     int(11) unsigned not null,
    associate_id int(11) unsigned null,
    moved_from   int(11) unsigned null,
    moved_to     int(11) unsigned null,
    type         enum ('IN', 'OUT', 'MOVE')
);
```

| timestamp | account_id | worker_id | associate_id | item_id | quantity | moved_from | moved_to | type |
|-----------|------------|-----------|--------------|---------|----------|------------|----------|------|
|2019-01-01 00:00:00| 1  |      1    |       1      |    1    |    10    |     null   |    33    |  IN  |
|2019-12-31 10:30:00| 1  |      1    |      10      |    3    |    20    |     1      |    null  |  OUT |
|2020-01-20 00:30:00| 2  |      2    |      null    |    2    |     1    |     22     |    5     | MOVE |
***

### Associates
```mysql
create table associates
(
    id              int(11) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    account_id      int(11)          not null,
    name            varchar(45)      not null,
    email           varchar(60)      null,
    phone           varchar(20)      null,
    additional_info mediumtext       null,
    type            enum ('CLIENT', 'SUPPLIER'),
    active          boolean default TRUE
);
```

| account_id | name | email | phone | additional_info | type | active |
|------------|------|-------|-------|-----------------|------|--------|
|1| John Doe | john.doe@shopify.com | null | null   | CLIENT |  TRUE  |
|1| Charles Brocade | charly.br@gmail.com  | +1-541-754-3010 | null   | SUPPLIER |  TRUE  |
|2| Kevin Buttler | kevin.b@gmail.com  | null | Inactive supplier   | SUPPLIER |  FALSE  |

***

### Addresses
```mysql
create table addresses
(
    id           int(11) unsigned not null auto_increment primary key,
    country      varchar(255)     null,
    city         varchar(255)     null,
    address      varchar(255)     null,
    zip          varchar(11)      null,
    latitude     float(10, 8)     null,
    longitude    float(11, 8)     null,
    warehouse_id int(11) unsigned null,
    associate_id int(11) unsigned null
);
```
| country | city | address | zip | latitude | longitude | warehouse_id | associate_id |
|---------|------|--------|-----|----------|-----------|---------------|--------------|
| Japan |  Tokyo | Kyobashi MID Bldg., 13-10, Kyobashi 2-chome, Chuo-ku |  153-0051 | 35.6850 | 139.7514 | null | 2|
| United States  | New York | 151 Pennington Street Brooklyn, NY 11236 |  10004 | 40.6943 | -73.9249 | 1 | null |

***
## 2. ER-diagram
![DB ERD](https://drive.google.com/uc?id=15VFKm0W-Mc8TMmcKZeZQT0GpUcMnPA28)

## 3.Trigger
```sql
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

```

## 4. Queries
##### 1.Find user by id
```sql
SELECT *
FROM users
WHERE id = 1;
```
##### Результат
| id | first_name | last_name | email | password | role | created_date | updated_date | active | email_uuid | account_id |
|----|------------|-----------|-------|----------|------|--------------|--------------|--------|------------|------------|
| 1  | Mariia     | Slobodian | slobodjanmarija1@gmail.com | 5f4dcc3b5aa765d61d8327deb882cf99 | ADMIN | 2019-01-01 00:00:00 | 2019-01-01 00:00:00 | TRUE | 03bfe72c-0d5d-11ea-8d71-362b9e155667 | 1 |

##### 2.Find user by email
```sql
SELECT *
FROM users
WHERE email = 'slobodjanmarija1@gmail.com';
```
##### Результат
| id | first_name | last_name | email | password | role | created_date | updated_date | active | email_uuid | account_id |
|----|------------|-----------|-------|----------|------|--------------|--------------|--------|------------|------------|
| 1  | Mariia     | Slobodian | slobodjanmarija1@gmail.com | 5f4dcc3b5aa765d61d8327deb882cf99 | ADMIN | 2019-01-01 00:00:00 | 2019-01-01 00:00:00 | TRUE | 03bfe72c-0d5d-11ea-8d71-362b9e155667 | 1 |

##### 3.Find admin with particular account(account include defferent level of warehouses)
```sql
SELECT *
FROM users
WHERE role = 'ADMIN'
AND account_id = 2;
```
##### Результат
| id | first_name | last_name | email | password | role | created_date | updated_date | active | email_uuid | account_id |
|----|------------|-----------|-------|----------|------|--------------|--------------|--------|------------|------------|
| 4  | Taras     | Sokil | sokil.taras@gmail.com | 5f4dcc3b5aa765d61d8327deb834cf99 | ADMIN | 2019-07-01 00:00:00 | 2019-07-01 00:00:00 | TRUE | 03bfe72c-0d5d-11ea-8d71-362b78155667 | 2 |

##### 4.Find all account possible to upgrage
```sql
SELECT *
FROM account_types
WHERE level > 1
AND active = true;
```
##### Результат
| id | name | price | level | max_warehouses | max_warehouse_depth | max_users | max_suppliers | max_clients | active |
|----|------------|-----------|-------|----------|------|--------------|--------------|--------|------------|
| 2  | premium | 300 | 2 | 1000 | 1000 | 10000 | 10000 | 10000 | true |

##### 5.Find popular products
```sql
SELECT it.name_item AS name,
sum(ts.quantity) AS quantity
FROM transactions ts
JOIN items it
ON ts.item_id = it.id
WHERE type = 'OUT';
```
##### Результат
| id | name | quantity | 
|----|------------|-----------|
|1   | Devaytis  |100|
|2   | Bonakva 	 |120| 
|3   |Artesiancka|90 |

##### 6.Find ended products by account_id
```sql
SELECT wh.id, wh.name, it.name_item, si.quantity
 FROM saved_items si
 JOIN warehouses wh
 ON si.warehouse_id = wh.id
 JOIN items it
 ON si.item_id = it.id
 WHERE si.quantity <= 20
 AND wh.account_id = 2;
```
##### Результат
| id | name  | name_item | quantity | 
|----|-------|-----------|-----     |
|2   | House |Devaytis   | 5        |
|3   | Room  |Bonakva    | 15       |

##### 7.Find particular transaction
```sql
select * 
from transactions 
where id = 2; 
```
##### Результат
| timestamp | account_id | worker_id | associate_id | item_id | quantity | moved_from | moved_to | type |
|-----------|------------|-----------|--------------|---------|----------|------------|----------|------|
|2020-01-20 00:30:00| 2  |      2    |      null    |    2    |     1    |     22     |    5     | MOVE |

##### 8.Find products related with particular account
```sql
select *
from items
where account_id=2;
```
##### Результат
| id | name_item | unit | description | volume | active | account_id |
|----|-----------|------|-------------|--------|--------|------------|
|2   |Bonakva 	 |block| low carbonated mineral water   |6 	|1 	|2|
|3   |Artesiancka|block| high carbonated mineral water  |9 	|1 	|2|

##### 9.Find number of warehouses in account
```sql
SELECT COUNT(id)
FROM warehouses
WHERE parent_id IS NULL
AND account_id = 2;
```
##### Результат
| count | 
|-------|
|2      |

##### 10.Find warehouse level
```sql
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
             WHERE cte.id = 2
```
##### Результат
| depth| 
|------|
|  1   |

## 5. The rest queries in file `dump.sql`

# Домашнее задание №1
## Зайти на Кинопоиск, найти 5 любимых фильмов и сделать по ним таблички с данными.

Табличка films:
- title - название фильма (текст)
- id (число) соответствует film_id в табличке persons2content
- country страна (тест)
- box_office сборы в долларах (число)
- release_date дата выпуска (date)

Табличка persons (актёры, режиссёры и т.д.)
- id (число) - соответствует person_id в табличке persons2content
- fio (текст) фамилия, имя

Табличка persons2content
- person_id (число) - id персоны
- film_id (число) - id контента
- person_type (текст) тип персоны (актёр, режиссёр и т.д.)

Таким образом реализуется схема БД "Звезда" с центром в табличке persons2content

**Важное замечание** Для этой домашки Postgres устанавливать не нужно, все запросы можно отладить на сайте http://sqlfiddle.com/

**Примечание** ответ должен быть предоставлен в виде файла формата *.sql*  нужными командами `CREATE TABLE`, `INSERT` и т.д.

# Работа

```sql
SELECT 'ФИО: Сотников Иван Дмитриевич';

CREATE SCHEMA IF NOT EXISTS P2C;

DROP TABLE IF EXISTS P2C.films, P2C.persons, P2C.persons2content;

CREATE TABLE P2C.films (
  id bigint PRIMARY KEY,
  title varchar(400) NOT NULL,
  country varchar(400) NOT NULL,
  box_office bigint NOT NULL,
  release_date date NOT NULL);
  
CREATE TABLE P2C.persons (
  id int PRIMARY KEY,
  fio varchar(400) NOT NULL);
  
CREATE TABLE P2C.persons2content (
  person_id bigint REFERENCES persons(id),
  film_id bigint REFERENCES films(id),
  person_type varchar(400) NOT NULL,
  PRIMARY KEY (person_id, film_id));
  
INSERT INTO P2C.films VALUES (1, 'rope', 'US', 2748000, '1948-08-26');
INSERT INTO P2C.films VALUES (2, 'psycho', 'US', 32000000, '1960-06-16');
INSERT INTO P2C.films VALUES (3, 'the_departed', 'US', 132384315, '2006-09-26');
INSERT INTO P2C.films VALUES (4, 'the_pianist', 'France', 120100000, '2002-09-25');
INSERT INTO P2C.films VALUES (5, 'whiplash', 'US', 49000000, '2014-11-10');

INSERT INTO P2C.persons VALUES (1, 'alfred_hitchcock');
INSERT INTO P2C.persons VALUES (2, 'martin_scorsese');
INSERT INTO P2C.persons VALUES (3, 'roman_polanski');
INSERT INTO P2C.persons VALUES (4, 'damien_chazelle');

INSERT INTO P2C.persons2content VALUES (1, 1, 'producer');
INSERT INTO P2C.persons2content VALUES (1, 2, 'producer');
INSERT INTO P2C.persons2content VALUES (2, 3, 'producer');
INSERT INTO P2C.persons2content VALUES (3, 4, 'producer');
INSERT INTO P2C.persons2content VALUES (4, 5, 'producer');
```

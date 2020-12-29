## Задание

<pre>
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
</pre>

# Домашнее задание #4

### ETL

ETL - процесс выгрузки данных, обработки и их дальнейшей загрузки. В рамках домашней работы нужно проделать все три этапа

#### Extract

Проверьте, что в директории `data_store` присутствует файл с мета-информацией по фильмам

```shell script
ls data_store/raw_data | grep movies_metadata.csv
```

Наша задача - загрузить это файл в Postgres. Для начала откройте его в excel и найдите столбец `genres`.
Каждая строка содержит JSON - в таком виде в Postgres залить не получится, поэтому для начала трансформируем столбец в "плоский" вид.

```shell script
python3 data_tools/extract_zipped_data.py -s transform
```

Результат работы скрипта - получили файл `data_store/raw_data/genres.csv`. Можно заливать его в Postgres!

Для начала подключимся в сеанс psql - тут нужно будет с помощью CREATE TABLE создать табличку `content_genres` для файла `genres.csv`.

```shell script
python3 upstart.py -s psql
``` 

Напишите команду создания таблички `content_genres` у неё должно быть 2 поля - `movieId` (числовой) и `genre` (текстовое).  Пример такой команды можно подсмотреть в файле [create_tables.sql](../docker_compose/postgres_host/create_tables.sql)
```sql
CREATE TABLE ...
```

Напишите команду копирования данных из файла в созданную вами таблицу - воспользуйтесь командой [copy](https://github.com/adzhumurat/data_management/blob/master/slides/postgres_db.md#data-importexport)
```sql
\copy
```

Подключитесь к контейнеру
<pre>
python3 upstart.py -s psql
</pre>

Проверьте, что в таблице есть записи
```sql
SELECT COUNT(*) FROM movie.genres;
```

Результат запроса
<pre>
count
-------
46419
</pre>

#### Transform

Мы загрузили данные в табличку, теперь нужно их преобразовать для дальнейшего использования. Мы ходитм узнать, какие теги у фильмов, которые сильно нравятся пользователям.

- Сформируйте запрос (назовём его ЗАПРОС1) к таблице ratings, в котором будут 2 поля
-- movieId
-- avg_rating - средний рейтинг, который ставят этому контенту пользователи
В выборку должны попасть те фильмы, которым поставили оценки более чем 50 пользователей
Список должен быть отсортирован по убыванию по полю avg_rating и по возрастанию по полю movieId
Из этой выборки оставить первые 150 элементов

Теперь мы хотим добавить к выборке хороших фильмов с высоким рейтингов информацию о тегах. Воспользуемся Common Table Expressions. Для этого нужно написать ЗАПРОС2, который присоединяет к выборке таблицу keywords

```sql
WITH top_rated as ( ЗАПРОС1 ) ЗАПРОС2;
```

#### Load

Мы обогатили выборку популярного контента внешними данными о тегах. Теперь мы можем сохранить эту информацию в таблицу для дальнейшего использования

Сохраним нашу выборку в новую таблицу `movie.top_rated_tags`. Для этого мы модифицируем ЗАПРОС2 - вместо простого SELECT сделаем SELECT INTO.

Назовём всю эту конструкцию ЗАПРОС3
```sql
WITH top_rated as ( ЗАПРОС1 )
SELECT movieId, top_rated_tags
INTO movie.top_rated_tags
FROM top_rated ...;
```

Теперь можно выгрузить таблицу в текстовый файл - [пример см. в лекции](https://github.com/adzhumurat/data_management/blob/master/slides/postgres_db.md#data-importexport).
Внимание: Поля в текстовом файле нужно разделить при помощи табуляции ( символ E`\t`).

Путь до файла с выгрузкой должен начинаться `/usr/share/data_store/raw_data/` - таким образом данные сохраняться в файловую систему вашей ОС, а не докера.
# Работа
```sql
SELECT 'ФИО: Сотников Иван Дмитриевич';
```
Создание таблицы
```sql
CREATE TABLE movie.content_genres (
    movieid bigint,
    genre varchar(255))
```
Копирование данных в таблицу из csv файла

```shell script
psql --host $APP_POSTGRES_HOST -U postgres -c "\\copy movie.content_genres FROM '/usr/share/data_store/raw_data/genres.csv' DELIMITER ',' CSV HEADER"
```

Запрос 3
```sql
WITH top_rated AS 
    (SELECT movieid, avg(rating) AS avg_rating
    FROM movie.ratings
    GROUP BY movieid
    HAVING count(rating) > 50
    ORDER BY avg(rating) DESC,
    movieid ASC
    LIMIT 150)
SELECT r.movieid, avg_rating, tag
INTO movie.top_rated_tag
FROM top_rated AS r
LEFT JOIN
(SELECT movieid, array_agg(genre) AS tag
FROM movie.content_genres) AS g
ON r.movieid = g.movieid
ORDER BY avg_rating DESC;
```
Загрузка данных из таблицы в csv файл

```shell script
psql --host $APP_POSTGRES_HOST -U postgres -c "\\copy movie.top_rated_tag TO '/usr/share/data_store/raw_data/top_rated_tag.csv' DELIMITER E'\t' CSV HEADER"
```

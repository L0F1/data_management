# Домашнее задание №2

## 1. Простые выборки

- 1.1 SELECT , LIMIT - выбрать 10 записей из таблицы ratings (Для всех дальнейших запросов выбирать по 10 записей, если не указано иное)
- 1.2 WHERE, LIKE - выбрать из таблицы links всё записи, у которых imdbid оканчивается на "42", а поле movieid между 100 и 1000

## 2. Сложные выборки: JOIN

- 2.1 INNER JOIN выбрать из таблицы links все imdbId, которым ставили рейтинг 5

## 3. Аггрегация данных: базовые статистики

- 3.1 COUNT() Посчитать число фильмов без оценок
- 3.2 GROUP BY, HAVING вывести top-10 пользователей, у который средний рейтинг выше 3.5

## 4. Иерархические запросы

- 4.1 Подзапросы: достать любые 10 imbdId из links у которых средний рейтинг больше 3.5.
- 4.2 Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок.  Нужно подсчитать средний рейтинг по все пользователям, которые попали под условие - то есть в ответе должно быть одно число.

# Работа

<pre>
SELECT 'ФИО: Сотников Иван Дмитриевич';

SELECT *
FROM movie.ratings
LIMIT 10;

SELECT *
FROM movie.links
WHERE imdbid LIKE '%42' AND
      movieid > 10 AND
      movieid < 100
LIMIT 10;

SELECT imdbid
FROM movie.links AS l
INNER JOIN movie.ratings AS r
ON l.movieid = r.movieid
WHERE rating = 5
LIMIT 10;

SELECT COUNT(movieid)
FROM movie.ratings
WHERE rating IS NULL
LIMIT 10;

SELECT userid
FROM movie.ratings
GROUP BY userid
HAVING AVG(rating) > 3.5
ORDER BY AVG(rating) DESC
LIMIT 10;

SELECT imdbid
FROM movie.links
WHERE movieid IN
(SELECT movieid
FROM movie.ratings
WHERE rating > 3.5)
LIMIT 10;

SELECT AVG(arating)
FROM(SELECT AVG(rating) AS arating
FROM movie.ratings
GROUP BY userid
HAVING COUNT(rating) > 10) X;
</pre>

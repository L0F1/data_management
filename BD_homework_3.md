# Домашнее задание #3
## Схема БД
Таблица `movie.ratings`

| userId | movieId | rating | timestamp |
| --- | --- | --- | --- |
| 1 | 999 | 5.0 | 8987866443 |
| ... | ... | ... | ... |
| 10 | 5 | 3.0 | 898785647 |
| 1999 | 14 | 4.0 | 8987866556 |

Таблица `movie.links`

| movieId | imdbIdId | timdbId |
| --- | --- | --- |
| 999 | 6999 | 6758 |
| ... | ... | ... |
| 5 | 555 | 4857 |
| 14 | 144 | 3049 |
## Оконные функции.

Вывести список пользователей в формате userId, movieId, normed_rating, avg_rating где

- userId, movieId - без изменения
- для каждого пользователя преобразовать рейтинг `r` в нормированный `normed_rating=(r - r_min)/(r_max - r_min)`, где
    - `r_min` минимальное значение рейтинга у данного пользователя
    - `r_max` максимальное значение рейтинга у данного пользователя
- `avg_rating` - среднее значение рейтинга у данного пользователя

Вывести первые 30 таких записей
# Работа
<pre>
SELECT 'ФИО: Сотников Иван Дмитриевич';

SELECT userid, movieid,
((rating - min(rating) OVER (PARTITION BY userid))
/ (max(rating) OVER (PARTITION BY userid)
- min(rating) OVER (PARTITION BY userid))) as norm_rating,
avg(rating) OVER (PARTITION BY userid) AS avg_rating
FROM movie.ratings
ORDER BY userid
LIMIT 30;
</pre>

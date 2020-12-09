SELECT 'ФИО: Сотников Иван Дмитриевич';

SELECT userid, movieid,
((rating - MIN(rating) OVER (PARTITION BY userid))
/ (MAX(rating) OVER (PARTITION BY userid)
- MIN(rating) OVER (PARTITION BY userid))) as norm_rating,
avg(rating) OVER (PARTITION BY userid) AS avg_rating
FROM movie.ratings
ORDER BY userid
LIMIT 30;

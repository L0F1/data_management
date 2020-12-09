SELECT 'ФИО: Сотников Иван Дмитриевич';

SELECT userid, movieid,
((rating - min(rating) OVER (PARTITION BY userid))
/ (max(rating) OVER (PARTITION BY userid)
- min(rating) OVER (PARTITION BY userid))) as norm_rating,
avg(rating) OVER (PARTITION BY userid) AS avg_rating
FROM movie.ratings
ORDER BY userid
LIMIT 30;

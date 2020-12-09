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
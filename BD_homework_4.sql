-- Создание таблицы
CREATE TABLE movie.content_genres {
    movieid bigint,
    genre varchar(255)
}

-- Копирование данных в таблицу из csv файла
psql --host $APP_POSTGRES_HOST -U postgres -c "\\copy movie.content_genres FROM '/usr/share/data_store/raw_data/genres.csv' DELIMITER ',' CSV HEADER"

-- Запрос 3
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

-- Загрузка данных из таблицы в csv файл
psql --host $APP_POSTGRES_HOST -U postgres -c "\\copy movie.top_rated_tag TO '/usr/share/data_store/raw_data/top_rated_tag.csv' DELIMITER E'\t' CSV HEADER"
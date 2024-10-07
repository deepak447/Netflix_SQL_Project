DROP TABLE NETFLIX;

CREATE TABLE NETFLIX (
	SHOW_ID VARCHAR(255),
	TYPE VARCHAR(255),
	TITLE VARCHAR(255),
	DIRECTOR VARCHAR(255),
	CASTS VARCHAR(1050),
	COUNTRY VARCHAR(255),
	DATE_ADDED DATE,
	RELEASE_YEAR INT,
	RATING VARCHAR(255),
	DURATION VARCHAR(255),
	LISTED_IN VARCHAR(255),
	DESCRIPTION VARCHAR(255)
)
SELECT
	*
FROM
	NETFLIX;

-- 1. Count the number of Movies vs TV Shows
SELECT
	TYPE,
	COUNT(*)
FROM
	NETFLIX
GROUP BY
	TYPE;

-- 2. Find the most common rating for movies and TV shows
SELECT
	*
FROM
	NETFLIX;

SELECT
	TYPE,
	RATING
FROM
	(
		SELECT
			TYPE,
			RATING,
			COUNT(*),
			RANK() OVER (
				PARTITION BY
					TYPE
				ORDER BY
					COUNT(*) DESC
			) AS RANKING
		FROM
			NETFLIX
		GROUP BY
			1,
			2
	) AS MOST_COMMON_RATING
WHERE
	RANKING = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT
	*
FROM
	NETFLIX;

SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND RELEASE_YEAR = 2020;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT
	*
FROM
	NETFLIX;

SELECT
	UNNEST(STRING_TO_ARRAY(COUNTRY, ',')) AS COUNTRY,
	COUNT(SHOW_ID) AS NO_OF_CONTENT
FROM
	NETFLIX
GROUP BY
	COUNTRY
ORDER BY
	NO_OF_CONTENT DESC
LIMIT
	5;

SELECT
	UNNEST(STRING_TO_ARRAY(COUNTRY, ',')) AS COUNTRY
FROM
	NETFLIX;

-- 5. Identify the longest movie
SELECT
	*
FROM
	NETFLIX;

SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND DURATION = (
		SELECT
			MAX(DURATION)
		FROM
			NETFLIX
	)
	-- 6. Find content added in the last 5 years
SELECT
	*
FROM
	NETFLIX
WHERE
	DATE_ADDED >= DATE (CURRENT_DATE - INTERVAL '5 years')
	-- select current_date - interval '5 years'
	-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT
	*
FROM
	NETFLIX
WHERE
	DIRECTOR = 'Rajiv Chilaka';

-- 8. List all TV shows with more than 5 seasons
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'TV Show'
	AND DURATION > '5 seasons';

-- 9. Count the number of content items in each genre
SELECT
	*
FROM
	NETFLIX;

SELECT
	UNNEST(STRING_TO_ARRAY(LISTED_IN, ',')) AS GENRE,
	COUNT(SHOW_ID) AS COUNT_CONTENT
FROM
	NETFLIX
GROUP BY
	1
ORDER BY
	COUNT_CONTENT DESC;

-- 10.Find each year and the average numbers of content release in India on netflix. 
SELECT
	*
FROM
	NETFLIX;

SELECT
	EXTRACT(
		YEAR
		FROM
			DATE_ADDED
	) AS YEAR,
	COUNT(*)::"numeric" / (
		SELECT
			COUNT(*)
		FROM
			NETFLIX
		WHERE
			COUNTRY = 'India'
	) * 100 AS AVG
FROM
	NETFLIX
WHERE
	COUNTRY = 'India'
GROUP BY
	YEAR
ORDER BY
	AVG DESC;

-- 11. List all movies that are documentaries
SELECT
	*
FROM
	NETFLIX;

SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND LISTED_IN LIKE '%Documentaries';

-- 12. Find all content without a director
SELECT
	*
FROM
	NETFLIX
WHERE
	DIRECTOR IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT
	*
FROM
	NETFLIX
WHERE
	CASTS LIKE '%Salman Khan%'
	AND RELEASE_YEAR > EXTRACT(
		YEAR
		FROM
			CURRENT_DATE
	) -10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
	UNNEST(STRING_TO_ARRAY(CASTS, ',')) AS ACTORS,
	COUNT(*) AS NO_OF_MOVIES
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND COUNTRY = 'India'
GROUP BY
	1
ORDER BY
	NO_OF_MOVIES DESC
LIMIT
	10;

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
SELECT
	*
FROM
	NETFLIX;

SELECT
	CATEGORY,
	TYPE,
	COUNT(*) AS CONTENT_COUNT
FROM
	(
		SELECT
			*,
			CASE
				WHEN DESCRIPTION ILIKE '%kill%'
				OR DESCRIPTION ILIKE '%violence%' THEN 'Bad'
				ELSE 'Good'
			END AS CATEGORY
		FROM
			NETFLIX
	) AS CATEGORIZED_CONTENT
GROUP BY
	1,
	2;
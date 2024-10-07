## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND RELEASE_YEAR = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
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

```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
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
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT
	*
FROM
	NETFLIX
WHERE
	DATE_ADDED >= DATE (CURRENT_DATE - INTERVAL '5 years')
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT
	*
FROM
	NETFLIX
WHERE
	DIRECTOR = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'TV Show'
	AND DURATION > '5 seasons';

```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
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
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'Movie'
	AND LISTED_IN LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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

```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.


This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


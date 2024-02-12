select * from imdb_top_1000;

#SQL mode changing for group by clase -- important --
SET @@sql_mode = SYS.LIST_DROP(@@sql_mode, 'ONLY_FULL_GROUP_BY');
SELECT @@sql_mode;
  
-- THIS above code helps to remove this kind of error " SELECT list is not in GROUP BY clause and contains nonaggregated column"
-- u can also add full group by just changing the drop into add just like the below code.

SET @@sql_mode = SYS.LIST_ADD(@@sql_mode, 'ONLY_FULL_GROUP_BY');
SELECT @@sql_mode;


-- Question 1 -- Find the total gross revenue for each certificate. name it as Total Gross and return certificates and total gross.

select Certificate,sum(Gross) as 'Total Gross'
from imdb_top_1000
group by Certificate;

-- 02. write an query to retrieve the top 10 highest-grossing series. return series title and Gross.

with cte as (
select Series_title,Gross,
dense_rank() over(order by Gross desc) as rnk
from imdb_top_1000
)
select Series_title,Gross
from cte 
where rnk between 1 and 10;

-- 03 --  Find series with a meta score greater than 90.return series title and score in decending order.
                  
select Series_title, Meta_score
from imdb_top_1000
where Meta_score >90
order by Meta_score desc;


-- 04 -- Calculate the average runtime of movies for each genre, order the result according to runtime decending format

select Genre, Avg(Runtime) as average
from imdb_top_1000
group by Genre
order by average desc;

-- 05 -- Retrieve the series released in the last 5 years. return series title and realeased year.

SELECT 
  Series_title, 
  Released_Year
FROM imdb_top_1000
WHERE Released_Year BETWEEN 2016 AND 2020
ORDER BY Released_Year DESC;


-- Alternative Solution --
SELECT Series_title, Released_Year
FROM imdb_top_1000
WHERE Released_Year >= YEAR(CURDATE()) - 5;


-- 06 -- Find the director with the highest average IMDb rating . Return Director name and avg rating.round the result into 2 decimel points

select Director, round(Avg(IMDB_Rating),2) as Average_Rating
from imdb_top_1000
group by Director
order by Average_Rating desc
limit 1;


-- Alternative Solution --

SELECT  MAX(avg_rating) AS max_avg_rating
FROM (
    SELECT AVG(IMDB_Rating) AS avg_rating
    FROM imdb_top_1000
    GROUP BY Director
) AS director_avg_ratings;


-- 7 -- Retrieve series with a runtime longer than 150 minutes. return series titile and runtime

select Series_title, Runtime
from imdb_top_1000
where Runtime >150;

-- 8 -- Count the number of series in each genre 

select Genre, count(Series_title)
from imdb_top_1000
group by Genre
order by Genre;

 -- 09: Find series with IMDb ratings between 7 and 8

select Series_title, IMDB_Rating 
from imdb_top_1000
where IMDB_Rating between 7 and 8
order by IMDB_Rating desc;

-- 10: Retrieve series with rating and gross that are directed by Francis Ford Coppola.  

select Series_title,IMDB_Rating,Gross
from imdb_top_1000
where Director = 'Francis Ford Coppola';

-- 11. Find the total gross revenue for each Director. name it as Total Gross and return Director and total gross.

select Director,sum(Gross) as 'Total Gross'
from imdb_top_1000
group by Director;

-- 12:: Find the highest-grossing movie for each year. Return Series title and gross

select Released_Year, Max(Gross) as gross
from imdb_top_1000
group by Released_Year
order by Released_Year desc;

-- Alternative Solution ----------

with cte as (
select Series_title,
Released_Year,
Gross,
row_number() over (Partition by Released_Year order by Gross Desc) as rnk
FROM imdb_top_1000
)
select 
Series_title,
Released_Year,
Gross
from cte
where rnk = 1
order by Released_Year desc;

-- 13 --  Retrieve series where main hero was John Travolta

select Series_title
from imdb_top_1000
where Star1 = 'John Travolta';


-- 14 -- Query to identify movies where one of the stars listed in the "Star1", "Star2", "Star3", or "Star4" columns has also directed a movie.

SELECT m.Series_title
FROM imdb_top_1000 m
JOIN imdb_top_1000 d ON 
    (m.Star1 = d.Director OR m.Star2 = d.Director OR m.Star3 = d.Director OR m.Star4 = d.Director)
WHERE m.Director IS NOT NULL;


-- 15 Write an query to calculate the cumulative gross revenue over time for each director.

SELECT
    Series_title,
    Released_Year,
    Director,
    Gross,
    SUM(REPLACE(Gross, ',', '') + 0) OVER (PARTITION BY Director ORDER BY Released_Year) AS cumulative_gross
FROM
    imdb_top_1000;

-- 16 --Query to identify movies with a runtime that is significantly longer  than  the average runtime of movies in the same genre.

select 
	Series_title,
    Runtime
From 
	imdb_top_1000
where 
	Runtime > (select Avg(Runtime) from imdb_top_1000);
    
    
-- 17 -- Write an query to find movies that have a higher IMDb rating than any other movie released in the same year.
    
select Series_title, IMDB_Rating
from imdb_top_1000
where IMDB_Rating > (select IMDB_Rating from imdb_top_1000 group by Released_Year, IMDB_Rating);


-- 18-- Calculate the total number of votes for each movie
select Series_title, Sum(No_of_Votes) as total_votes
from imdb_top_1000
group by Series_Title;

select * from imdb_top_1000;

-- 19 -- Recursive query to find all the directors who have directed more than one movie.

select Director, count(Series_title) as Total_series_Directed
from imdb_top_1000
group by Director
having count(Series_Title) >1;

-- 20 -- Query to calculate the total gross revenue for each combination of genre and certificate.
SELECT Genre, Certificate, SUM(Gross) AS total_gross_revenue
FROM imdb_top_1000
GROUP BY Genre, Certificate;

-- 21 --- query to find movies that have a higher IMDb rating than any other movie released in the same year.

select i.Series_title ,i.Released_Year,max(i.IMDB_Rating) as highest_rating
from imdb_top_1000 i 
join imdb_top_1000 tt
where i.Released_Year = tt.Released_Year and i.IMDB_Rating > tt.IMDB_Rating
group by i.Released_Year 
order by Released_Year;























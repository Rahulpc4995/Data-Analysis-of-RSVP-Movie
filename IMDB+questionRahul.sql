USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
use imdb;
show tables;
select count(*) as Total_Dir_rows from director_mapping;
select count(*) as Total_Genre_rows from genre;
select count(*) as Total_Movie_rows from movie;
select count(*) as Total_Names_rows from names;
select count(*) as Total_ratings_rows from ratings;
select count(*) as Total_rolemapping_rows from role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
SUM(case when id IS NULL then 1 ELSE 0 END) AS ID_NUL,
SUM(case when title IS NULL then 1 ELSE 0 END) AS Title_NUL,
SUM(case when year IS NULL then 1 ELSE 0 END) AS Year_NUL,
SUM(case when date_published IS NULL then 1 ELSE 0 END) AS DatePublished_NUL,
SUM(case when duration IS NULL then 1 ELSE 0 END) AS Duration_NUL,
SUM(case when country IS NULL then 1 ELSE 0 END) AS Country_NUL,
SUM(case when worlwide_gross_income IS NULL then 1 ELSE 0 END) AS WorldWide_NUL,
SUM(case when languages IS NULL then 1 ELSE 0 END) AS Lang_NUL,
SUM(case when production_company IS NULL then 1 ELSE 0 END) AS prod_co_NULL
FROM movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- the below table shows the number of movies released year wise 
select year, count(ID) as no_of_movies
from movie
group by year;

-- this table shows movie released by month wise
select month(date_published) as no_of_month, count(ID) as no_of_movies from movie
group by month(date_published);



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select count(distinct ID) as no_of_movies, year from movie
where (country like '%INDIA%' or country like '%USA%') and year = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below;
  select distinct(genre) from genre;
  

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select genre, count(movie_id) as no_of_movie
from genre g
inner join movie m
on m.id = g.movie_id
group by genre order by count(id) desc
limit 1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with cnt_genre as 
(select movie_id, count(genre) as no_of_movies
from genre
group by movie_id having no_of_movies=1)
select count(movie_id) as no_of_movies from cnt_genre;




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre, round(avg(m.duration),2)as avg_duration
from movie m
inner join genre g
on m.id = g.movie_id 
group by genre 
order by avg(m.duration) desc;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with genre_ranks as (
select genre, count(movie_id), rank()
over(order by count(movie_id)desc) genre_rank
from genre group by genre)
select * from genre_ranks where genre = "Thriller";



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select * from ratings;
select 
min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating,
min(total_votes) as min_avg_rating, max(total_votes) as max_avg_rating,
min(median_rating) as min_avg_rating, max(median_rating) as max_avg_rating 
from ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

with avg_rating_rank as 
(select m.title as title, r.avg_rating as avg_rating,
DENSE_rank() over(order by r.avg_rating desc) movie_rank from movie m
inner join ratings r 
on m.id = r.movie_id)
select * from avg_rating_rank where movie_rank<=10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating, count(movie_id) as mov_count from ratings
group by median_rating
order by mov_count asc;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


select production_company, count(ID) as movie_count,
dense_rank() over(order by count(ID) DESC) prod_co_rank from movie m
inner join ratings r
on m.ID = r.movie_id
where r.avg_rating > 8 and m.production_company IS NOT NULL
group by m.production_company;



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre, count(m.ID) as movie_count from genre g
inner join movie m 
on m.ID = movie_id
inner join ratings r
on m.ID = 	r.movie_id
where m.year = 2017 and month(m.date_published) = 3 and m.country LIKE '%USA%' and r.total_votes>1000
group by genre 
order by count(m.ID);







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

Select title, avg_rating, genre from movie m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN genre g
ON g.movie_id = m.id
where title LIKE'The%' AND avg_rating>8
ORDER BY avg_rating DESC;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select COUNT(id) as movie_released,
median_rating
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
where median_rating = 8 AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
group by median_rating;



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select country, sum(total_votes) AS votes_count from movie as m
INNER JOIN ratings as r
ON r.movie_id=m.id
where country = 'Germany' OR country = 'Italy'
group by country;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select
SUM(CASE when name IS NULL then 1 ELSE 0 END) AS name_nul,
SUM(CASE when height IS NULL then 1 ELSE 0 END) AS height_nul,
SUM(CASE when date_of_birth IS NULL then 1 ELSE 0 END) AS date_of_birth_nul,
SUM(CASE when known_for_movies IS NULL then 1 ELSE 0 END) AS known_for_movies_nul from names;




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- To find the top 3 directors
WITH top_genre
AS
(select
g.genre, count(g.movie_id) as movie_count from genre g
INNER JOIN ratings r
ON g.movie_id = r.movie_id
WHERE avg_rating>8
group by genre
ORDER BY movie_count DESC
LIMIT 4
),

Top_Director as
(select
n.name as director_name, count(d.movie_id) as movie_count,
RANK() OVER(ORDER BY COUNT(d.movie_id) DESC) director_rank
FROM names n
INNER JOIN director_mapping d
ON n.id = d.name_id
INNER JOIN ratings r
ON r.movie_id = d.movie_id
INNER JOIN genre g
ON g.movie_id = d.movie_id,

Top_Genre
where r.avg_rating > 8 AND g.genre IN (top_genre.genre)
group by n.name
ORDER BY movie_count DESC
)
select director_name, movie_count
from top_director where director_rank <= 3
LIMIT 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- To find TOP 2 actors :

select * from role_mapping;
select n.name AS actor_name,
COUNT(rm.movie_id) AS movie_count
from role_mapping rm
INNER JOIN names n
ON n.id = rm.name_id
INNER JOIN ratings r
ON r.movie_id = rm.movie_id
where category="actor"
AND r.median_rating >= 8
group by n.name
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,
Sum(total_votes) AS Vote_Count,
DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY production_company
ORDER BY Vote_Count DESC
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name AS actor_name,
r.total_votes as total_votes,
count(r.movie_id) as movie_count,
ROUND(SUM(avg_rating)/SUM(total_votes),2) AS actor_avg_rating, RANK() OVER(ORDER BY ROUND(SUM(avg_rating)/SUM(total_votes),2) DESC) AS actor_rank
from names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN ratings r
ON rm.movie_id = r.movie_id
INNER JOIN movie m
ON m.id = r.movie_id
where rm.category="actor" AND m.country="India"
group by n.name
having COUNT(r.movie_id) >= 5;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name,
Total_votes,
COUNT(m.id) AS movie_count,
Round(Sum(avg_rating)/Sum(total_votes),2) AS actress_avg_rating, 
RANK() OVER(ORDER BY Round(Sum(avg_rating)/Sum(total_votes),2) DESC) AS actress_rank
FROM names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN movie m
ON rm.movie_id = m.id
INNER JOIN ratings r
ON m.id = r.movie_id
where rm.category = "ACTRESS" AND m.languages LIKE "%Hindi%" AND m.country = "INDIA"
group by n.name HAVING COUNT(m.id) >=3
LIMIT 5;




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title, avg_rating,
CASE
WHEN avg_rating > 8 THEN "Superhit movies"
WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies"
WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
ELSE "Flop Movies"
END AS avg_rating_category from movie m
INNER JOIN genre g
ON m.id = g.movie_id
INNER JOIN ratings r
ON r.movie_id = m.id
where genre="thriller";




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select genre,
ROUND(AVG(duration),2) AS avg_duration,
SUM(AVG(duration)) OVER(ORDER BY genre) AS running_total_duration,
AVG(AVG(duration)) OVER(ORDER BY genre) AS moving_avg_duration
from movie mov
INNER JOIN genre g
ON mov.id = g.movie_id
group by genre;





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with Topthree_genre
AS
(select genre, count(movie_id) as movie_count from genre
group by genre
ORDER BY movie_count DESC
LIMIT 3
),

Topfiv_movie
AS
(select genre, YEAR, title as movie_name, worlwide_gross_income,
DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
WHERE genre IN(SELECT genre FROM Topthree_genre)
)

SELECT *from Topfiv_movie where movie_rank<=5 ;





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,
COUNT(id) as movie_count,
ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
from movie m
INNER JOIN ratings r
ON m.id = r.movie_id
where median_rating>=8
AND production_company IS NOT NULL
AND POSITION(',' IN languages)>0
group by production_company
LIMIT 2;





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name as actress_name, 
SUM(total_votes) AS total_votes, 
COUNT(rm.movie_id) as movie_id,
Round(Sum(avg_rating)/Sum(total_votes),2) AS actress_avg_rating,
RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank
from names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN ratings r
ON r.movie_id = rm.movie_id
INNER JOIN genre g
ON g.movie_id = r.movie_id
where category="actress" AND avg_rating>8 AND g.genre="Drama"
group by name
LIMIT 3;





/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH ctf_date_summary AS
(SELECT d.name_id,NAME, d.movie_id, duration, r.avg_rating, total_votes, m.date_published,
Lead(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
FROM director_mapping AS d
INNER JOIN names AS n ON n.id = d.name_id
INNER JOIN movie AS m ON m.id = d.movie_id
INNER JOIN ratings AS r ON r.movie_id = m.id ),
top_director_summary AS
( SELECT *,
Datediff(next_date_published, date_published) AS date_difference
FROM ctf_date_summary
)
SELECT name_id AS director_id,
NAME AS director_name,
COUNT(movie_id) AS number_of_movies,
ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
ROUND(AVG(avg_rating),2) AS avg_rating,
MIN(avg_rating) AS min_rating,
MAX(avg_rating) AS max_rating,
SUM(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC
limit 9;

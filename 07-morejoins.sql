#01
#@List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie
WHERE yr=1962;

#02
#When was Citizen Kane released? Give year of 'Citizen Kane'.
SELECT yr FROM movie WHERE title = 'Citizen Kane';

#03
#Star Trek movies. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr FROM movie 
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

#04
#What id number does the actor 'Glenn Close' have?
SELECT id FROM actor 
WHERE name = 'Glenn Close';

#05
#What is the id of the film 'Casablanca'
SELECT id FROM movie WHERE title = 'Casablanca';

#06
#Cast list for Casablanca
#Obtain the cast list for 'Casablanca'.
#what is a cast list?
#Use movieid=11768, (or whatever value you got from the previous question)
SELECT a.name FROM casting c JOIN actor a ON(c.actorid = a.id)
WHERE movieid = (SELECT id FROM movie WHERE title = 'Casablanca');

#07	
#Obtain the cast list for the film 'Alien'
SELECT a.name FROM casting c JOIN actor a ON(c.actorid = a.id)
WHERE movieid = (SELECT id FROM movie WHERE title = 'Alien');

#08
#List the films in which 'Harrison Ford' has appeared
SELECT title FROM movie JOIN casting ON(movie.id = casting.movieid)
WHERE casting.actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford');

#09
#List the films where 'Harrison Ford' has appeared - but not in the starring role. 
#[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title FROM movie JOIN casting ON(movie.id = casting.movieid)
WHERE casting.actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford')
AND casting.ord != 1 ;

#10
#List the films together with the leading star for all 1962 films.
SELECT m.title, a.name 
FROM movie m JOIN casting c ON(m.id = c.movieid)
JOIN actor a ON (c.actorid = a.id)
WHERE m.yr = 1962 AND c.ord = 1;

##11
SELECT yr,COUNT(title) 
FROM movie JOIN casting ON movie.id=movieid
JOIN actor ON actorid=actor.id
WHERE name = 'John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t		
)

#12
SELECT m.title, a.name FROM movie m 
JOIN casting c ON(m.id = c.movieid AND c.ord = 1)
JOIN actor a ON(c.actorid = a.id)
WHERE m.id IN(SELECT movieid FROM casting WHERE actorid IN(SELECT id FROM actor WHERE name = 'Julie Andrews') );

SELECT m.title, a.name FROM movie m 
JOIN casting c ON(m.id = c.movieid AND c.ord = 1)
JOIN actor a ON(c.actorid = a.id)
WHERE m.id IN(SELECT m.id FROM movie m
JOIN casting c ON(m.id = c.movieid)
JOIN actor a ON (a.id = c.actorid)
WHERE a.name = 'Julie Andrews' );

#13
SELECT a.name
 FROM casting c JOIN actor a ON(c.actorid = a.id AND c.ord = 1)
GROUP BY a.name
HAVING COUNT(*) >= 30
ORDER BY a.name;

#14
#List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT m.title, COUNT(*) as quantity
FROM movie m 
JOIN casting c ON(c.movieid = m.id AND m.yr = 1978)
GROUP BY m.title, m.id
ORDER BY quantity DESC, m.title;

#15
SELECT name FROM actor 
WHERE actor.id IN
(SELECT actorid FROM casting c WHERE c.movieid IN
	(SELECT c.movieid FROM casting c WHERE c.actorid = 
		(SELECT a.id FROM actor a WHERE a.name = 'Art Garfunkel')) 
			AND c.actorid != (SELECT a.id FROM actor a WHERE a.name = 'Art Garfunkel'));


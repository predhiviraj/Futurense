use world;
select * from city;
select * from country;
select * from countrylanguage;
desc city;
desc country;
desc countrylanguage;

-- Part - 3 (50)
-- Continent Analysis: For each continent, find the average population and total GDP. 
-- Filter out continents with an average population below a certain threshold.

select continent, avg(Population) avgpopulation, 
sum(GNP) totgnp
from country 
group by continent
having avg(Population) <= 30000000;

-- Language Diversity: Identify countries with more than a specific number of official languages and 
-- display the country name, number of official languages, and total population.

select c.Name,
sum(c.Population) totpopulation,
count(cl.Language)  officiallan
from countrylanguage cl
inner join country c on cl.CountryCode = c.Code
where cl.IsOfficial = 'T'
group by c.Name ;




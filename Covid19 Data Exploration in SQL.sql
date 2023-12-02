SELECT *
FROM dbo.Covid23
WHERE continent is not NULL 

--Looking at Global Numbers
ALTER TABLE Covid23
ALTER COLUMN total_cases bigint

ALTER TABLE Covid23
ALTER COLUMN total_deaths bigint
  
ALTER TABLE Covid23
ALTER COLUMN  population bigint
  
ALTER TABLE Covid23
ALTER COLUMN people_fully_vaccinated bigint

with cte as (SELECT Continent, Location, MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths
FROM dbo.Covid23
WHERE continent is not NULL
GROUP By location, continent)
select SUM(total_cases) as total_cases_world2023, SUM(total_deaths) as total_deaths_world2023
from cte

--Total Numbers by Continent by November 2023
with cte2 as (SELECT Continent, Location, population, MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths
FROM dbo.Covid23
WHERE continent is not NULL
GROUP By location, continent,population)
select continent, SUM(total_cases) as total_cases_continent, SUM(total_deaths) as total_deaths_continent
from cte2
GROUP BY continent
ORDER BY continent

------–-Creating View to store data for later queries
Create View total_statistics as SELECT Continent, Location, population, MAX(total_cases) as total_cases, MAX(total_deaths) as total_deaths
FROM dbo.Covid23
WHERE continent is not NULL
GROUP By location, continent,population


---- PercentPopulationInfected,DeathPercentage,VaccinatedPercentage in UK
SELECT location,date, population, total_cases,total_deaths,people_fully_vaccinated,round((CAST(total_cases as float)/population*100),2) as PercentPopulationInfected,
round(CAST(total_deaths as float)/CAST(total_cases as float)*100,2) as DeathPercentage, ROUND((CAST(people_fully_vaccinated as float)/population)*100,2) as percent_vaccinated
from dbo.Covid23
WHERE location = 'United Kingdom'
ORDER BY 1,2


-----Looking at the countries with highest infection rate compared to population
	SELECT location,total_cases, population, round((CAST(total_cases as float)/population*100),2) as percent_population_infected
	from total_statistics
	ORDER BY percent_population_infected DESC

----- Countries with Highest Death Count per Population
SELECT Location, population, total_deaths
FROM total_statistics
Order by total_deaths DESC


------Looking at Countries with Highest Death Percent 
SELECT location,total_cases,total_deaths,round(CAST(total_deaths as float)/CAST(total_cases as float)*100,2) as percent_deaths
from total_statistics
ORDER BY percent_deaths DESC 
  

------Looking DeathPercantage vs VaccinatedPercentage
SELECT total_statistics.location,total_statistics.population,total_cases,total_deaths, people_fully_vaccinated,
round(CAST(total_deaths as float)/CAST(total_cases as float)*100,2) as percent_deaths, 
ROUND((CAST(people_fully_vaccinated as float)/total_statistics.population)*100,2) as percent_vaccinated
from total_statistics
JOIN vaccination_statistics ON total_statistics.location=vaccination_statistics.location
ORDER BY percent_vaccinated DESC 





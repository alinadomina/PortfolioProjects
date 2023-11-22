SELECT *
FROM dbo.Covid23
WHERE continent is not NULL 

--Looking at Global Numbers
with cte as (SELECT Continent, Location, MAX(CAST(total_cases as float)) as total_cases, MAX(CAST(total_deaths as float)) as total_deaths, 
MAX(CAST(total_tests as float)) as total_tests,MAX(CAST(total_vaccinations as float)) as total_vaccinations
FROM dbo.Covid23
WHERE continent is not NULL
GROUP By location, continent)
select SUM(total_cases) as total_cases_world2023, SUM(total_deaths) as total_deaths_world2023, SUM(total_tests) as total_tests_world23, SUM(total_vaccinations) as total_vaccinations23
from cte

--–-Creating View to store data for later queries
Create View total_statistics as SELECT Continent, Location, population, MAX(CAST(total_cases as float)) as total_cases, MAX(CAST(total_deaths as float)) as total_deaths, 
MAX(CAST(total_tests as float)) as total_tests,MAX(CAST(total_vaccinations as float)) as total_vaccinations
FROM dbo.Covid23
WHERE continent is not NULL
GROUP By location, continent,population

----Looking at total statistics by continent Nov 2023
select continent, SUM(total_cases) as total_cases_continent, SUM(total_deaths) as total_deaths_continent, SUM(total_tests) as total_tests_continent,
SUM(total_vaccinations) as total_vaccinations_continent
from total_statistics
GROUP BY continent
ORDER BY continent

----Total Cases vs Total Deaths in UK
SELECT location,date, total_cases,total_deaths,(CAST(total_deaths as float)/CAST(total_cases as float)*100) as DeathPercentage
from dbo.Covid23
WHERE location = 'United Kingdom'
ORDER BY 1,2

---- Total Cases vs Population in UK
SELECT location,date, total_cases,total_deaths,(CAST(total_cases as float)/CAST(population as float)*100) as PercentPopulationInfected
from dbo.Covid23
WHERE location = 'United Kingdom'
ORDER BY 1,2


-----Looking at the countries with highest infection rate compared to population (% of population infected)
SELECT location,total_cases, population, (total_cases/population*100) as percent_population_infected
from total_statistics
ORDER BY percent_population_infected DESC

----- Countries with Highest Death Count per Population
SELECT Location, population, total_deaths
FROM total_statistics
Order by total_deaths DESC


------Looking at total cases vs total deaths
SELECT location,total_cases,total_deaths, total_deaths/total_cases*100 as percent_deaths
from total_statistics
ORDER BY percent_deaths DESC 

SELECT location,date, total_cases,total_deaths,(CAST(total_deaths as float)/CAST(total_cases as float)*100) as DeathPercentage
from dbo.Covid23
WHERE location = 'Ukraine'
ORDER BY 1,2



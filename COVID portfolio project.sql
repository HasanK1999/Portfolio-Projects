Select *
From Covid_Deaths
Where continent is not null 
order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population
From Covid_Deaths
Where continent is not null
order by 1,2;

-- Total Cases vs Total Deaths
-- Showing Likelyhood of dying if you contact covid in your country (Pakistan)
SELECT
    Location,
    date,
    total_cases,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) AS Death_Percentage
FROM
    Covid_Deaths
WHERE 
     location = 'Pakistan'
ORDER BY
    1, 2;
	
--Total cases vs Population
-- What percentage of popualtion affected by covid

SELECT
    Location,
    date,
    total_cases,
    population,
    (total_cases/ population::numeric) * 100 AS Death_Percentage
FROM
    Covid_Deaths
WHERE 
     location = 'Pakistan'
ORDER BY
    1, 2;

-- Countries with Highest Infection Rate compared to Population
SELECT
    Location,
    Population,
    MAX(total_cases) as HighestInfectionCount,
    MAX((total_cases/population::numeric))*100 as PercentPopulationInfected
FROM
    Covid_Deaths
GROUP BY
    Location,
    Population
HAVING
    MAX(total_cases/population::numeric) IS NOT NULL
ORDER BY
    PercentPopulationInfected DESC;
	
-- Countries with Highest Death Count 	
	SELECT
    Location,
    MAX(Total_deaths) AS TotalDeathCount
FROM
    Covid_deaths
Where continent is not null
GROUP BY
    Location
HAVING
    MAX(Total_deaths) IS NOT NULL 

ORDER BY
    TotalDeathCount DESC;
	
	
-- Continents with Highest Death Count
		SELECT
    continent,
    MAX(Total_deaths) AS TotalDeathCount
FROM
    Covid_deaths
Where continent is not null
GROUP BY
    continent
HAVING
    MAX(Total_deaths) IS NOT NULL 
ORDER BY
    TotalDeathCount DESC;
	
	
-- GLOBAL NUMBERS of cases and deaths

SELECT
    date,
    sum (new_cases) as totalcases,
    sum (new_deaths::numeric) as totaldeaths,
    sum (new_deaths)/sum(new_cases) *100 as Death_percentage
FROM
    Covid_Deaths
Where continent is not NULL
GROUP BY date
Order by 1,2;
	

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (
        PARTITION BY dea.location
        ORDER BY dea.date
    ) AS RollingPeopleVaccinated
FROM 
    Covid_deaths AS dea
JOIN 
    covid_vaccination AS vac
ON 
    dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY 
    2, 3;

------------ Using CTE to perform Calculation on Partition By
With popsvac as (

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (
        PARTITION BY dea.location
        ORDER BY dea.date
    ) AS RollingPeopleVaccinated
FROM 
    Covid_deaths AS dea
JOIN 
    covid_vaccination AS vac
ON 
    dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
)

Select *, (RollingPeopleVaccinated/population)*100
from popsvac;

---Creating view fro visualisation
Create view percentpopulationvaccinated as
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (
        PARTITION BY dea.location
        ORDER BY dea.date
    ) AS RollingPeopleVaccinated
FROM 
    Covid_deaths AS dea
JOIN 
    covid_vaccination AS vac
ON 
    dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL

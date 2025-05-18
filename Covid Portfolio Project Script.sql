#Looking at the Total Cases vs Total Deaths
#shows the likelihood of dying if you contract covid in my country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths1
WHERE location = 'Bangladesh'
AND continent <> ''
ORDER BY 1,2;

#looking at total cases vs population
#shows the likelihood of contracting covid in my country

SELECT location, date, total_cases, population, (total_cases/population)*100 AS PopulationInfectedPercentage
FROM coviddeaths1
WHERE location = 'Bangladesh'
ORDER BY 1,2;

#Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS PopulationInfectedPercentage
FROM coviddeaths1
GROUP BY population, location
ORDER BY PopulationInfectedPercentage DESC;

#This is showing the countries with highest death count per population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths1
WHERE continent <> ''
GROUP BY location
ORDER BY TotalDeathCount DESC;

#Let's break things down by continent
#Showing the continents with the highest death counts per population

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths1
WHERE continent <> ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;

#Global numbers

SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths1
WHERE continent <> ''
#GROUP BY date
ORDER BY 1,2;



#Looking at Total Population vs Total Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM coviddeaths1 dea
JOIN covidvaccination vac
ON dea.location = vac.location AND dea.date = vac.date
where dea.continent <> '' 
order by 2,3 ;

#Use CTE

WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
FROM coviddeaths1 dea
JOIN covidvaccination vac
ON dea.location = vac.location AND dea.date = vac.date
where dea.continent <> '' 
)
SELECT * , (RollingPeopleVaccinated/population)*100
FROM PopvsVac;

#USE temp

drop table if exists PercentPopulationVaccinated;
create temporary table PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric);


insert into PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
FROM coviddeaths1 dea
JOIN covidvaccination vac
ON dea.location = vac.location AND dea.date = vac.date
where dea.continent <> ''
;

SELECT * , (RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated;


#Creating view to store data for later visualization

create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
FROM coviddeaths1 dea
JOIN covidvaccination vac
ON dea.location = vac.location AND dea.date = vac.date
where dea.continent <> '';

select * from PercentPopulationVaccinated;
































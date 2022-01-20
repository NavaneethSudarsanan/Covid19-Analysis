-- Total Cases VS Total Deaths
-- Shows the geographical probability of death caused by COVID-19
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location='India'
AND continent is not null
ORDER BY 1,2

-- Total Cases VS Population

SELECT location,date,population,total_cases,(total_cases/population)*100 AS InfectionPercentage
FROM CovidDeaths
WHERE location='India'
AND continent is not null
ORDER BY 1,2

-- Countries with Highest Infection Rates compared to Population

SELECT location,population,MAX(cast(total_cases as int))AS HighestInfectionCount,MAX((total_cases/population))*100 AS InfectionPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY 4 DESC

-- Countries with Highest Death Count compared to Population

SELECT location,MAX(cast(total_deaths as int))AS HighestDeathCount,MAX(total_deaths/population)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY 2 DESC

-- Continents with Highest Death Count compared to Population

SELECT location,MAX(cast(total_deaths as int))AS HighestDeathCount,MAX(total_deaths/population)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is null
AND location<>'High income' AND location<>'Upper middle income' AND location<>'Lower middle income' AND location<>'Low income'
GROUP BY location
ORDER BY 3 DESC

--Overall Global Numbers

SELECT date,SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as Total_Deaths,(SUM(cast(new_deaths as int))/SUM(new_cases))*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1

-- Total Population VS Vaccinations(FullY Vaccinated Individuals)
WITH DoubleDose(location,population,FullyVaccinated)
AS
(
SELECT dea.location,dea.population,MAX(cast(vac.people_fully_vaccinated as bigint)) AS FullyVaccinated
FROM CovidVaccinations vac
JOIN CovidDeaths dea
ON vac.location=dea.location
WHERE dea.continent IS NOT NULL
GROUP BY dea.location,dea.population
)
SELECT *,(FullyVaccinated/population)*100 AS FullyVaccinatedPercentage
FROM DoubleDose
ORDER BY 4 DESC

--Creating View for data visualisation purposes

CREATE VIEW FullyVaccinated AS
SELECT dea.location,dea.population,MAX(cast(vac.people_fully_vaccinated as bigint)) AS FullyVaccinated,((MAX(cast(vac.people_fully_vaccinated as bigint)))/dea.population)*100 AS FullyVaccinatedPercentage
FROM CovidVaccinations vac
JOIN CovidDeaths dea
ON vac.location=dea.location
WHERE dea.continent IS NOT NULL
GROUP BY dea.location,dea.population

SELECT *
FROM FullyVaccinated




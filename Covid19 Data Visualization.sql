DROP DATABASE IF EXISTS  covid_analyis;
CREATE DATABASE covid_analysis;
DROP TABLE covid_analysis.Vaccinations;
CREATE TABLE covid_analysis.Vaccinations(
iso_code TEXT,
continent TEXT,
location TEXT,
date	TEXT,
total_tests	TEXT,
new_tests TEXT,
total_tests_per_thousand TEXT,	
new_tests_per_thousand	TEXT,
new_tests_smoothed	TEXT,
new_tests_smoothed_per_thousand	TEXT,
positive_rate TEXT,	
tests_per_case	TEXT,
tests_units	TEXT,
Total_vaccinations	TEXT,
people_vaccinated	TEXT,
people_fully_vaccinated	TEXT,
total_boosters	TEXT,
new_vaccinations TEXT,
new_vaccinations_smoothed	TEXT,
total_vaccinations_per_hundred	TEXT,
people_vaccinated_per_hundred	TEXT,
people_fully_vaccinated_per_hundred	TEXT,
total_boosters_per_hundred	TEXT,
new_vaccinations_smoothed_per_million	TEXT,
new_people_vaccinated_smoothed TEXT,
new_people_vaccinated_smoothed_per_hundred	TEXT,
stringency_index	TEXT,
population_density	TEXT,
median_age TEXT,
aged_65_older	TEXT,
aged_70_older	TEXT,
gdp_per_capita	TEXT,
extreme_poverty	TEXT,
cardiovasc_death_rate	TEXT,
diabetes_prevalence	TEXT,
female_smokers	TEXT,
male_smokers	TEXT,
handwashing_facilities	TEXT,
hospital_beds_per_thousand TEXT,	
life_expectancy	TEXT,
human_development_index	TEXT,
excess_mortality_cumulative_absolute TEXT,	
excess_mortality_cumulative	TEXT,
excess_mortality TEXT,
excess_mortality_cumulative_per_million TEXT)
;

LOAD DATA LOCAL INFILE "C:/Program Files/MySQL/MySQL Server 8.0/Uploads/CovidVaccinations.csv" INTO TABLE covid_analysis.Vaccinations
FIELDS TERMINATED BY ','
ENCLOSED by '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(iso_code,continent,location,date,total_tests,new_tests,total_tests_per_thousand,new_tests_per_thousand,new_tests_smoothed,	new_tests_smoothed_per_thousand,positive_rate,tests_per_case,tests_units,total_vaccinations,people_vaccinated,people_fully_vaccinated,total_boosters,new_vaccinations,new_vaccinations_smoothed,total_vaccinations_per_hundred,people_vaccinated_per_hundred,people_fully_vaccinated_per_hundred,total_boosters_per_hundred,new_vaccinations_smoothed_per_million,new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred,stringency_index,population_density,median_age,aged_65_older,aged_70_older,gdp_per_capita,extreme_poverty,cardiovasc_death_rate,diabetes_prevalence,female_smokers,male_smokers,handwashing_facilities,hospital_beds_per_thousand,life_expectancy,human_development_index,excess_mortality_cumulative_absolute,excess_mortality_cumulative,excess_mortality,excess_mortality_cumulative_per_million);


SELECT *
FROM covid_analysis.Vaccinations
WHERE location = 'Kenya';

CREATE TABLE covid_analysis.deaths(iso_code TEXT,
continent TEXT,
location TEXT,
date TEXT,
population TEXT,
total_cases TEXT,
new_cases TEXT,
new_cases_smoothed TEXT,
total_deaths TEXT,
new_deaths TEXT,
new_deaths_smoothed TEXT,
total_cases_per_million TEXT,
new_cases_per_million TEXT,
new_cases_smoothed_per_million TEXT,
total_deaths_per_million TEXT,
new_deaths_per_million TEXT,
new_deaths_smoothed_per_million TEXT,
reproduction_rate TEXT,
icu_patients TEXT,
icu_patients_per_million TEXT,
hosp_patients TEXT,
hosp_patients_per_million TEXT,
weekly_icu_admissions TEXT,
weekly_icu_admissions_per_million TEXT,
weekly_hosp_admissions TEXT,
weekly_hosp_admissions_per_million TEXT,
total_tests TEXT);

LOAD DATA LOCAL INFILE "C:/Program Files/MySQL/MySQL Server 8.0/Uploads/CovidDeaths.csv" INTO TABLE covid_analysis.deaths
FIELDS TERMINATED BY ','
ENCLOSED by '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(iso_code,continent,location,date,population,total_cases,new_cases,new_cases_smoothed,total_deaths,new_deaths,new_deaths_smoothed,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million,total_deaths_per_million,new_deaths_per_million,new_deaths_smoothed_per_million,reproduction_rate,icu_patients,icu_patients_per_million,hosp_patients,hosp_patients_per_million,weekly_icu_admissions,weekly_icu_admissions_per_million,weekly_hosp_admissions,weekly_hosp_admissions_per_million,total_tests
);


-- Preview covid deaths data in Kenya
SELECT *
FROM covid_analysis.deaths
WHERE location = 'Kenya';

-- Total cases vs Total deaths
-- Likelihood of dying from covid if you contract covid  while in Kenya

SELECT Location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covid_analysis.deaths
WHERE Location LIKE '%Kenya%'
ORDER BY 1,2;

-- Likelihood of dying from covid if you contract covid in 2023 while in Kenya

SELECT Location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covid_analysis.deaths
WHERE Location LIKE '%Kenya%' and Date like '_/_/2023%'
ORDER BY 1,2;

-- Total cases vs Population
-- % of the population that has covid

SELECT Location,date,total_cases, population, (total_cases/population)*100 as InfectionPercentage
FROM covid_analysis.deaths
WHERE Location LIKE '%Kenya%'
ORDER BY 1,2;

-- Countries with the highest infection rate compared to population

SELECT Location,MAX(CAST(total_cases AS SIGNED)), population, MAX((total_cases/population))*100 as InfectionPercentage
FROM covid_analysis.deaths
GROUP BY location, population
ORDER BY InfectionPercentage desc;


-- Continents with the highest infection rate

SELECT Continent,MAX(CAST(Total_cases AS SIGNED)), MAX((Total_cases/Population))*100 AS InfectionRate
FROM Covid_Analysis.deaths
WHERE CONTINENT IS NOT NULL
GROUP BY Continent
ORDER BY InfectionRate DESC;

-- Countries/Regions with the Highest death count per population

SELECT Location,Max(cast(total_deaths as signed)) AS DeathCount
FROM Covid_analysis.Deaths
GROUP BY Location
ORDER BY DeathCount DESC;

 -- Continents with the highest death count

SELECT Continent,Max(cast(total_deaths as signed)) AS TotalDeathCount
FROM Covid_Analysis.Deaths
WHERE Continent is not null
GROUP BY Continent
ORDER BY TotalDeathCount DESC;

-- Global Numbers

SELECT Date, SUM(new_cases) AS Total_cases, SUM(CAST(New_deaths AS SIGNED)) as total_deaths, SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases) *100 AS DeathPercentage
FROM Covid_analysis.deaths
GROUP BY date
ORDER BY 1,2;

-- Join coviddeaths data and covidvaccinations data based on location and date

SELECT *
FROM Covid_analysis.deaths as Deaths
JOIN Covid_analysis.vaccinations as Vaccs
ON Deaths.Location = Vaccs.Location
AND Deaths.Date = Vaccs.Date;

-- Total population vs vaccinations

SELECT deaths.continent, deaths.location,deaths.date,deaths.population,vaccs.new_vaccinations
FROM Covid_analysis.deaths as Deaths
JOIN Covid_analysis.vaccinations as Vaccs
ON Deaths.Location = Vaccs.Location
AND Deaths.Date = vaccs.Date
WHERE deaths.location = 'Kenya'
ORDER BY 2,3;

-- USE COMMOM TABLE EXPRESSIONS(CTE) TO DETERMINE TOTAL POPULATION VACCINATED

WITH PopulationVSVaccinations(continent,location,date,population,new_vaccinations,RollingPeoplevaccinated)
as
(
SELECT deaths.continent, deaths.location,deaths.date,deaths.population,vaccs.new_vaccinations
, SUM(CAST(vaccs.new_vaccinations AS SIGNED)) OVER (PARTITION BY deaths.Location order by deaths.location, deaths.date) as RollingPeopleVaccinated
FROM Covid_analysis.deaths as Deaths
JOIN Covid_Analysis.vaccinations as Vaccs
ON Deaths.Location = Vaccs.Location
AND Deaths.Date = Vaccs.Date
WHERE deaths.location = 'Kenya'
)
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PopulationVSVaccinations;


-- USING TEMPORARY TABLE TO DETERMINE %POPULATION VACCINATED

DROP TEMPORARY TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated(
Continent varchar(255),
Location varchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
);
INSERT INTO PercentPopulationVaccinated
SELECT deaths.continent, deaths.location,deaths.date,deaths.population,vaccs.new_vaccinations
, SUM(CAST(vaccs.new_vaccinations AS SIGNED)) OVER (PARTITION BY deaths.Location order by deaths.location, deaths.date) as RollingPeopleVaccinated
FROM Covid_Analysis.deaths as Deaths
JOIN Covid_Analysis.vaccinations as Vaccs
	ON Deaths.Location = Vaccs.Location
	AND Deaths.Date = Vaccs.Date;
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinated;





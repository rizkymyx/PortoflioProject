select *
from PortofolioProject..CovidDeaths
where continent is NOT NULL
order by 3,4

--select *
--from PortofolioProject..CovidVaccinations
--order by 3,4

-- select data that we want
select location, date, total_cases, new_cases, total_deaths, population
from PortofolioProject..CovidDeaths
where continent is NOT NULL
order by 1,2

--looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
where location like '%indonesia%'
and continent is NOT NULL
order by 1,2


--looking at total cases vs population
select location, date, population, total_cases, (total_cases/population)*100 as PopulationPercentageInfected
from PortofolioProject..CovidDeaths
--where location like '%indonesia%'
where continent is NOT NULL
order by 1,2

--looing at countries with highest infection rate compared to population
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PopulationPercentageInfected
from PortofolioProject..CovidDeaths
--where location like '%indonesia%'
Group By location, population
where continent is NOT NULL
order by PopulationPercentageInfected desc


--lets break things down by continent

--showing countries with highest deatch count per population



--showing contient with higesht death count per population
select continent, MAX(cast(total_deaths as int)) as TotalDeatchCount
from PortofolioProject..CovidDeaths
--where location like '%indonesia%'
where continent is not NULL
Group By continent
order by TotalDeatchCount desc

--GLOBAL NUMBERS
select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
--where location like '%indonesia%'
where continent is NOT NULL
--Group by date
order by 1,2


--looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

-- still looking at total population vs vaccinations
 select vac.location, sum(dea.population) as TotalPopulation, sum(cast(vac.new_vaccinations as bigint)) as TotalVaccinations,
 (SUM(cast(vac.new_vaccinations as bigint))/sum(dea.population))*100 as PercetageofVaccinations
 from PortofolioProject..CovidVaccinations vac
 inner join PortofolioProject..CovidDeaths dea
 on vac.location = dea.location
 group by vac.location
 order by 1


-- USE CTE

with  PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

--TEMP TABLE
DROP table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--creating view to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated--, (RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3

	select * from PercentPopulationVaccinated


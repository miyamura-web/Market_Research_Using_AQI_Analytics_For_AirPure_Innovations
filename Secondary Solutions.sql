select * from [dbo].[Health related consequences]
select * from [dbo].[Age_Group]
select * from [dbo].[AirPollutedIllnesses]
select * from [dbo].[Map_Diseases]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q1 :-

select hrc.state, ap.disease_illness_name as Disease_Name, ap.affected_age_group_code, sum(hrc.cases) as Total_Affected
from AirPollutedIllnesses as ap
inner join [Health related consequences] as hrc on  ap.disease_illness_name = hrc.disease_illness_name
group by hrc.state,  ap.disease_illness_name, ap.affected_age_group_code
order by Total_Affected desc;
   
---------------------------- Original answer

with SplitAgeGroups as (
    select 
        hrc.state,
        value as age_group,  -- Splits 'A,E' into rows
        hrc.cases,
        hrc.disease_illness_name
    from AirPollutedIllnesses ap
   inner join [Health related consequences] hrc 
        on ap.disease_illness_name = hrc.disease_illness_name
    cross apply string_split(ap.affected_age_group_code, ',')
)

select 
    sag.state,
    sag.age_group,
   count(distinct sag.disease_illness_name) as Contributing_Diseases,
    sum(sag.cases) as Total_Affected,
    md.Description
from SplitAgeGroups as sag
join Map_Diseases as md 
    on md.Age_Group_Code = sag.age_group
group by sag.state, sag.age_group, md.Description
order by Total_Affected desc;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2 :-

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3 :-

-- Step 1: Average AQI by state for 2024 (no area, cleaned state)
with AQI_2024 as (
    select 
        lower(ltrim(rtrim(state))) as state,
        round(avg(cast(aqi_value AS float)),2) as avg_aqi
    from AQI
    where
        try_cast(date as DATE) is not null
        and year(cast(date as DATE)) = 2024
    group by lower(ltrim(rtrim(state)))
),

-- Step 2: Population data (gender = Total, cleaned state)
Population_2024 as (
   select 
        lower(ltrim(rtrim(state))) as state,
        max(cast(value as float)) as population
    from [Population Data]
    where 
        gender = 'Total'
        and year = 2024
    group by lower(ltrim(rtrim(state)))
)

-- Step 3: Join and final result
select 
    pop.state,
    aqi.avg_aqi,
    pop.population
from AQI_2024 aqi
join Population_2024 pop on aqi.state = pop.state
order by aqi.avg_aqi desc;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


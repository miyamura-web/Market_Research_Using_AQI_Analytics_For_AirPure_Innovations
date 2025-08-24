Create database AQI_Analytics;

select * from AQI;
select * from [dbo].[Health related consequences]
select * from [dbo].[Population data]
select * from [dbo].[Vehicle data]


-- My name is Niladri
-----------------------------------------------------------------------------------------------------------------------------------

-- Q1 :-
select * from (
              select top 5 state, area, avg(aqi_value) as Avg_Aqi_Value from AQI
              where date between '2024-12-01' and '2025-05-30'
              group by area, state
              order by Avg_Aqi_Value desc ) as top5

union all      -- keeps both result sets
               -- Subqueries allow separate ORDER BY clauses to work properly
select * from (
              select top 5 state, area, avg(aqi_value) as Avg_Aqi_Value from AQI
              where date between '2024-12-01' and '2025-05-30'
              group by area, state
              order by Avg_Aqi_Value asc) as bottom5 ;

-----------------------------------------------------------------------------------------------------------------------------------
 
-- Q2 :-

-- Find southern states
with SouthernStates as (
                        select state, prominent_pollutants from AQI
                        where state in ('Tamil Nadu', 'Karnataka', 'Andhra Pradesh', 'Telangana', 'Kerala')    -- This table have only those states which I want
                              and prominent_pollutants is not null ), -- If that state have this value 

-- Splitting the pollutants (as in some rows their are more than one pollutants)
SplitPollutants as (
                    select state, ltrim(rtrim(value)) as pollutant from SouthernStates
                    cross apply string_split(prominent_pollutants, ',') ),

-- Count occurrences of each pollutant per state
PollutantCounts as (
                    select state, pollutant, count(*) as Occurence from SplitPollutants
                    group by state, pollutant ),

-- Rank pollutants per state
RankedPollutants as (
                     select * ,
                     rank() over(partition by state order by Occurence desc) as HighRank,
                     rank() over(partition by state order by Occurence asc) as LowRank
from PollutantCounts )

-- To see most and least pollutants in each states
select state, pollutant, Occurence, 'Most Prominent' AS Category
from RankedPollutants
where HighRank <= 2
union all
select state, pollutant, Occurence, 'Least Prominent' AS Category
from RankedPollutants
where LowRank <= 2
order by state, Category desc;

-----------------------------------------------------------------------------------------------------------------------------------

-- Q3 :-
with WeekType as (
                  select area, date, aqi_value, datename(weekday, date) as Day_Name,
                       case when datename(weekday, date) in ('Saturday', 'Sunday') then 'Weekend' else 'Weekday'
                       end as Day_Type 
                  from AQI 
                  where area in ('Delhi', 'Mumbai', 'Chennai', 'Kolkata', 'Bengaluru', 'Hyderabad', 'Ahmedabad', 'Pune')
                     and date >= dateadd(year, -1, getdate())    ),

CityAQI as (
            select area, Day_Type, avg(aqi_value) as Avg_Aqi_Value 
            from WeekType 
            group by area, Day_Type )
             
select area as Metro_City,
       max(case when Day_Type = 'Weekday' then Avg_Aqi_Value end) as Weekday_AQI,
       max(case when Day_Type = 'Weekend' then Avg_Aqi_Value end) as Weekend_AQI,
       max(case when Day_Type = 'Weekday' then Avg_Aqi_Value end) - max(case when Day_Type = 'Weekend' then Avg_Aqi_Value end) as AQI_Diff
from CityAQI
group by area
order by AQI_Diff desc;

-----------------------------------------------------------------------------------------------------------------------------------

-- Q4 :-
-- Get Top 10 States by Number of Distinct Areas
with TopStates as (
                   select top 10 state from AQI
                   group by state
                   order by count(distinct area) desc ),

-- Monthly Average AQI per State
MonthlyAQI as (
               select state, year(date) as Year, datename(month, date) as Month_Name, month(date) as Month_Number, avg(aqi_value) AS Avg_Aqi_Value from AQI
               where state in (select state from TopStates)
               group by state, year(date), datename(month, date), month(date) ),

-- Rank Worst Months per State by Avg AQI
RankedMonths as (
                 select *,
                 rank() over (partition by state order by Avg_Aqi_Value desc) as MonthRank
                 from MonthlyAQI )

-- Worst month for each top state per year 
select Month_Name, 
       count(*) as Frequency_As_Worst_Month,
       round(avg(Avg_Aqi_Value), 2) as Avg_Worst_Month_AQI
from RankedMonths
where MonthRank = 1
group by month_name
order by Frequency_As_Worst_Month desc;

-----------------------------------------------------------------------------------------------------------------------------------

-- Q5 :-

select distinct air_quality_status as Category  -- To see what air quality category bengaluru have
from AQI
where area = 'Bengaluru'

-- To see how many days fall under those category
select air_quality_status as Air_Qlty_Category, count(distinct(date)) as No_Of_Days 
from AQI
where area = 'Bengaluru' and date between '2025-03-01' and '2025-05-31'
group by air_quality_status
order by No_Of_Days desc;

-----------------------------------------------------------------------------------------------------------------------------------

-- Q6 :-

with DiseaseName as (
                     select state, disease_illness_name, count(*) as Occurrence, sum(cases) as Total_Cases
                     from [Health related consequences]
                     where reporting_date >= dateadd(year, -3, getdate())
                     group by state, disease_illness_name ),

RankedDisease as (
                  select *, 
                  row_number() over (partition by state order by Total_Cases desc) as Disease_Rank,
                  row_number() over (partition by state order by Occurrence desc) as Frequency_Occurrence
                  from DiseaseName ),

TopDisease as (
               select state, disease_illness_name, Total_Cases, Occurrence
               from RankedDisease 
               where Disease_Rank <= 2 ),

AvgAqi as (
           select state, avg(aqi_value) as Avg_aqi_value
           from AQI
           where date >= dateadd(year, -3, getdate())
           group by state )

select td.state, td.disease_illness_name, td.Total_Cases, td.Occurrence, aa.Avg_aqi_value
from TopDisease as td
join AvgAqi as aa on aa.state = td.state
order by td.state, td.Total_Cases desc;
                  
-----------------------------------------------------------------------------------------------------------------------------------

-- Q7 :-

select distinct(fuel) from [Vehicle data];   -- To see which are EV


with ValidAqiStates AS (
select distinct state from AQI ),  -- To get all states that have AQI data, as 2 low ev states are not in aqi table

TopEvStates as (
              select top 5 vd.state, count(*) as Total_EV
              from [Vehicle data] as vd
              join ValidAqiStates as vas on vas.state = vd.state
              where fuel like '%EV%' 
                    or fuel like '%ELECTRIC%' 
                    or fuel like '%HYBRID%' 
                    or fuel like '%FUEL CELL%'
              group by vd.state
              order by Total_EV desc ),


LessEvStates as (
              select top 5 vd.state, count(*) as Total_EV
              from [Vehicle data] as vd
              join ValidAqiStates as vas on vas.state = vd.state
              where fuel like '%EV%' 
                   or fuel like '%ELECTRIC%' 
                   or fuel like '%HYBRID%' 
                   or fuel like '%FUEL CELL%'
              group by vd.state
              order by Total_EV asc ),

-- To find avg aql values
AqiAvg as (
select state, avg(aqi_value) as Avg_AQI_Value from AQI
group by state), 

-- To choose state depend on ev adoption, cause above have 2 seperated group of states (top & less)
EvAdoption as (
select state, Total_EV, 'High EV Adoption' as EV_Group from TopEvStates
union all
select state, Total_EV, 'Low EV Adoption' as EV_Group from LessEvStates ),


-- Join to AQI (all 10 states now guaranteed to have AQI)
ValidStates as (
select ea.state, ea.Total_EV, ea.EV_Group, aa.Avg_AQI_Value
from EvAdoption as ea
join AqiAvg as aa on aa.state = ea.state )


-- To get state wise data 
 select state, Total_EV, Avg_AQI_Value, EV_Group
from ValidStates
order by Total_EV desc;


-- To get Group-Wise AQI Average
-- select 
--     EV_Group,
--     count(*) AS States_Used,
--    avg(Avg_AQI_Value) as Group_Avg_AQI
-- from ValidStates
-- group by EV_Group;


------------------------------------------------------------

-- Q7 :- Compare Top 5 High EV Adoption states vs ALL OTHER states (excluding those Top 5) � for average AQI. [ Original ]

-- Step 1: States with AQI data
with ValidAqiStates as (
    select distinct state
    from AQI
),

-- Step 2: Top 5 EV states
TopEvStates as (
    select top 5 
        state, 
        count(*) as Total_EV
    from [Vehicle data]
    where fuel like '%EV%' 
       or fuel like '%ELECTRIC%' 
       or  fuel like '%HYBRID%' 
       or fuel like '%FUEL CELL%'
    group by state
    order by Total_EV desc
),

-- Step 3: All other EV states that are not in Top 5 but have AQI data
OtherEvStates as (
    select 
        vd.state, 
        count(*) as Total_EV
   from [Vehicle data] vd
   join ValidAqiStates as vas on vd.state = vas.state
    where (fuel like '%EV%' 
        or  fuel like '%ELECTRIC%' 
        or  fuel like '%HYBRID%' 
        or  fuel like '%FUEL CELL%')
      and vd.state not in (select state from TopEvStates)
    group by vd.state
),

-- Step 4: AQI average per state
AqiAvg as (
    select 
        state, 
        avg(aqi_value) AS Avg_AQI_Value
    from AQI
    group by state
),

-- Step 5: Combine High EV and All Others
EvAdoption as (
    select state, Total_EV, 'High EV Adoption' as EV_Group from TopEvStates
    union all
   select state, Total_EV, 'Other States' as EV_Group from OtherEvStates
),

-- Step 6: Join with AQI (only valid states due to earlier filter)
FinalJoin as (
    select 
        ea.state, 
        ea.Total_EV, 
        ea.EV_Group, 
        aa.Avg_AQI_Value
    from EvAdoption ea
    join AqiAvg as aa on ea.state = aa.state
)

-- Step 7: Final Output � State-wise
select
    state, 
    Total_EV, 
   EV_Group, 
   Avg_AQI_Value
from FinalJoin
order by EV_Group, Total_EV desc;


-- For Group-Level AQI Comparison:
-- select 
--     EV_Group,
--     countT(*) AS States_Used,
--     avg(Avg_AQI_Value) as Group_Avg_AQI
-- from FinalJoin
-- group by EV_Group;


-----------------------------------------------------------------------------------------------------------------------------------

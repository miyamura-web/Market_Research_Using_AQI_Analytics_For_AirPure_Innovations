# Market Research using AQI Analytics for AirPure Innovations

## 🌐 Introduction
AirPure Innovations is a data-driven startup aiming to address India's growing air pollution crisis through smart air purification technologies. This repository provides an end-to-end market research and analytics project using AQI (Air Quality Index) data to assess the demand, consumer behavior, and regional prioritization for air purifier deployment.

### ↪ Project Objective :
To evaluate the market potential for air purifiers in Indian cities by analyzing AQI data, and how can R&D be aligned with localized pollution patterns, what pollutants or particles should air purifier target, also which cities have the highest demand for air purifiers etc. For more details see the attach file "problem_statement".

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 📁 Project Structure
```
___
├── Datasets/ (Collected from "Dataful")
│   ├── AQI(2022-2025).csv                          # Raw AQI data for Indian states
│   ├── Health related consequences.csv             # Survey data on public health perception
│   ├── Population data.csv                         # State wise population data
│   └── Vehicle data.csv                            # State wise all types of vehicle data  
│
├── Solutions/ 
│   ├── Primary Solutions.sql                       # SQL query for primary questions
│   ├── Secondary Solutions.sql                     # SQL query for secondary questions
│   ├── AQI Dashboard.pbix                          # Power BI interactive dashboard
│   └── AQI_Analytics.ipynb                         # Python scripts for EDA and correlation
│
└── AQI R&D Recommendations.pdf                     # Report of the analysis and insights along with recommendations

```

### 🔍 Data sources :
```
● Dataful datasets            [ https://dataful.in/challenges/ ]
● NAMP data                   [ https://cpcb.nic.in/namp-data/ ]
● Ken Research                [ https://www.kenresearch.com/industry-reports/india-air-purifiers-market ]
● IQAIR                       [ https://www.iqair.com/in-en/india?]
● Some Research Papers        [ https://doi.org/10.1177/10519815241305004 AND https://doi.org/10.1016/B978-0-443-23788-1.00013-0 ]
● Article & News Papers       [ References in the "AQI R&D Recommendations.pdf" ]

```

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Project Analysis :-

### Problem Statements :
See the attach file "Primary_and_Secondary_Analysis.pdf"

### Solutions :
See the attach file "Primary Solutions.sql", "Secondary Solutions", and for dashboard see the file "AQI Dashboard.pbix". Also for EDA can see "AQI_Analytics.ipynb".

### Insights :
See the attach file "AQI R&D Suggetions.pdf" [ download it to view ].

### Recommendations :
 ● Pre-Filter: Captures large dust particles, hair, pet dander
 <br>
 ● HEPA Filter (H13/H14): Removes 99.97% of PM2.5, PM10, allergens, bacteria
  <br>
 ● Activated Carbon Filter: Absorbs VOCs, smoke, cooking odors, gases like CO & SO2
  <br>
 ● Real-time AQI Monitoring (with color-coded LED and numeric display)
  <br>
 ● Silent Mode (<32 dB) for night use
  <br>
 ● Eco Mode to reduce power consumption
  <br>
 ● Auto Mode: Automatically adjusts fan speed based on AQI
  <br>
 ● Kills airborne viruses, bacteria, mold spores
  <br>
 ● Ideal for households with children and elderly, and for hospitals/schools
  <br>
 ● Budget friendly

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Tools Used :
1. SQL [ 40% ]
2. Power BI [ 34% ]
3. Python [ 20% ]
4. Canva [ 4% ]
5. Excel [ 2% ]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Conclusion :
This comprehensive analysis demonstrates strong market potential for AirPure Innovations across major Indian cities facing persistent air-quality challenges. By synthesizing AQI trends (2022–2025), population density, vehicle proliferation, and public health perceptions, I’ve identified both broad and city-specific demand hot spots.

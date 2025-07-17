# Market Research using AQI Analytics for AirPure Innovations

## 🌐 Introduction
AirPure Innovations is a data-driven startup aiming to address India's growing air pollution crisis through smart air purification technologies. This repository provides an end-to-end market research and analytics project using AQI (Air Quality Index) data to assess the demand, consumer behavior, and regional prioritization for air purifier deployment.

## Project Objective :
To evaluate the market potential for air purifiers in Indian cities by analyzing AQI data, public awareness, health perception, and vehicle data. The insights aim to guide strategic decision-making in product development, targeting, and advocacy.

## 📁 Project Structure
```plaintext
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
│   └── AQI_Analytics.ipynb                         # PYthon scripts for EDA and correlation
│
└── AQI R&D Suggetions.pdf                          # Report of the analysis and insights along with recommendations

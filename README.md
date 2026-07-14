# COVID-19 Mortality in England: Socio-Demographic Drivers

A data analysis project investigating which socio-economic, demographic, ethnic, health, and travel-behaviour factors are associated with COVID-19 death rates across Local Authorities (LAs) in England.

## Project Overview

England recorded one of the highest COVID-19 mortality rates in Europe. This project brings together several official datasets (age structure, ethnicity, self-reported health, and method of travel to work) at Local Authority level and combines them with COVID-19 death counts to explore which factors best explain variation in mortality between areas.

**Objective:** identify the demographic and socio-economic variables most strongly associated with COVID-19 death rates per 1,000 population across English Local Authorities, using correlation analysis, PCA/factor analysis, and stepwise multiple regression.

## Repository Structure

```
covid19-uk-mortality-analysis/
├── data/
│   └── COVID_Data.csv            # Merged, LA-level dataset (rates per 1,000 population)
├── sql/
│   └── data_preparation.sql      # SQL used to reconcile LA boundary changes and build the merged dataset
├── scripts/
│   └── covid_analysis.R          # Full R analysis workflow (EDA → PCA → regression)
├── results/
│   └── analysis_summary.txt      # Output of the best-fit stepwise regression model
└── README.md
```

## Data

`data/COVID_Data.csv` contains one row per English Local Authority, with COVID-19 deaths and predictor variables expressed as **rates per 1,000 population**, including:

- **Age bands:** Age_0_19, Age_20_39, Age_40_59, Age_60_79, Age_80_Plus
- **Ethnicity:** Asian, Black, Mixed_Ethnic, White, Other_Ethnic
- **Self-reported health:** Health_VGood, Health_Good, Health_Fair, Health_Bad, Health_VBad
- **Travel to work:** Work_Home, Metro_Rail, Train, Bus_Coach, Taxi, Motorcycle, Driving_Car, Passenger_Car, Bicycle, On_Foot, Other_Travel

Local Authority boundary changes and mergers (e.g. Somerset, North/West Northamptonshire, Cumbria/Westmorland, Buckinghamshire, Dorset, Bournemouth/Christchurch/Poole) were reconciled in `sql/data_preparation.sql` so that all source tables join consistently on `LA_Code`.

> **Note:** the underlying raw source tables (age, ethnicity, health, and travel tables plus the original COVID-19 deaths table) are not included in this repo — only the final merged `COVID_Data.csv`. If you want the SQL script to run end-to-end, you'll need to load your own copies of those ONS/UK Government source tables first.

## Methodology

1. **Data preparation (SQL):** reconcile Local Authority boundary changes, join deaths/age/ethnicity/health/travel tables on `LA_Code`, and convert raw counts to rates per 1,000 population.
2. **Exploratory analysis (R):** distribution and normality checks (histogram, Q-Q plot, Shapiro-Wilk test) on `Covid_Deaths`, scatterplots against predictors, and a full correlation matrix.
3. **Sampling adequacy:** Kaiser-Meyer-Olkin (KMO) test to check suitability for factor analysis.
4. **Dimensionality reduction:** Principal Component Analysis (PCA) with varimax rotation, retaining enough components to explain ~70% of variance.
5. **Modelling:** multiple regression using (a) top correlated variables and (b) PCA components as predictors, then a stepwise (AIC-based, both-direction) selection to find the best-fit model.
6. **Diagnostics:** residual plots and Variance Inflation Factors (VIF) to check multicollinearity.

## Key Results

- Shapiro-Wilk test indicated `Covid_Deaths` is **not normally distributed** (p ≈ 0).
- KMO measure of sampling adequacy was **0.351**, below the conventional 0.6 threshold — factor analysis results should be interpreted cautiously.
- **4 principal components** were needed to explain ~70% of variance in the predictors.
- The best-fit stepwise regression model explained **43.8% of variance** in COVID-19 death rates (R² = 0.4384, Adjusted R² = 0.4166, AIC = 433.38), with the strongest predictors including:
  - **Train travel** (positive association, p < 0.001)
  - **Motorcycle travel** (negative association, p < 0.001)
  - **Black ethnicity share** (negative association, p < 0.001)
  - **Health_Fair** and **Taxi** (positive, p < 0.01)
  - Additional significant predictors: Driving_Car, Other_Ethnic, Mixed_Ethnic

Full model coefficients are in [`results/analysis_summary.txt`](results/analysis_summary.txt).

## How to Run

1. Clone this repository.
2. Open R/RStudio with the repository folder as your working directory (or open it as an RStudio Project).
3. Run `scripts/covid_analysis.R`. It will:
   - Install any missing packages (`ggplot2`, `corrplot`, `psych`, `car`, `MASS`)
   - Read `data/COVID_Data.csv`
   - Reproduce all plots, the PCA/factor analysis, and the stepwise regression
   - Write results to the `results/` folder

```r
setwd("path/to/covid19-uk-mortality-analysis")
source("scripts/covid_analysis.R")
```

## Limitations

- This is an **ecological (area-level) study** — associations observed between LA-level rates do not necessarily hold at the individual level (ecological fallacy).
- The low KMO score suggests the predictor set may not be strongly suited to factor analysis; PCA results should be treated as exploratory.
- Cross-sectional design cannot establish causation, only association.

## Data Sources

Datasets were derived from UK Government / ONS open data on COVID-19 deaths, population age structure, ethnicity, self-reported health, and travel to work, all reported at Local Authority level.

## Author

u3012235 — DS7006 Coursework 2 (MSc Data Science)

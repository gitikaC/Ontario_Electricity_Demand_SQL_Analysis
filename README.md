# Ontario Electricity Demand - SQL Analysis
## Overview
I wanted to explore Ontario's electricity demand and see how it changes over time. I was curious about when demand is highest and lowest, whether it changes during different hours of the day, and which months have higher average demand. 

Dataset
I used two datasets from the official website:
https://reports-public.ieso.ca/public/Demand/

- PUB_Demand_2025_v396

-  PUB_Demand_2026_v289

The main columns I used were Date, Hour and Ontario Demand. Demand is measured in magawatts (MW).

The 2026 data only covers part of the year, so it is important to keep that in mind when comparing the two years.

## What I did
I used SQL to:

- Check the data and its column types.
- Check for missing values.
- Find the maximum and minimum electricity demand in each year.
- Calculate average demand for each hour.
- Calculate average demand for each month.
- Compare the highest demand in 2025 with the average demand for that month.

## What I found

- There were no missing values in the Date, Hour and Ontario Demand columns in either dataset.
- The hourly averages show how demand changes throughout the day.
- The monthly averages help me look for differences in demand across the year.
- In 2025, peak demand reached 24,862 MW, which was 51.74% above the average demand for June.

## Limitations

The 2026 data does not cover full year, so the comparison between years is limited. Also these queries show demand patterns, but they do not explain why demand increases or decreases. 

## Conclusion

This project helped me practice using SQL to explore a real-world dataset and answer questions about electricity demand. I focused on finding patterns in the data rather than just displaying the records.

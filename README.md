## A project repo for tasks done at Lux_Dev Academy.
For Week 2,we used CTE's and core SQL syntanx to query data from data we imported from [https://github.com/LuxDevHQ/Data-Analytics-Boot-camp-Projects/blob/main/international_debt_with_missing_values.csv] and loaded it to our postgresql database.
To identify the most frequently reported debt indicator for each country, we grouped the data by country_name and indicator_name, and used COUNT(*) to calculate how often each indicator appeared. Then, we used a window function (ROW_NUMBER()) to rank indicators within each country by their frequency.
Only the top-ranked indicator per country (i.e., the one that appears most often) was selected.

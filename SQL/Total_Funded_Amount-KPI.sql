--- Use Bank_loan database for this query
use Bank_loan
Go

--Select data from table loan_Data
Select * from loan_data
Go

--Calculate Total Funded Amount 
Select SUM(loan_amount) as Total_Funded_Amount from loan_data
Go

--Calculate Total Funded Amount for December Month 
Select SUM(loan_amount) as MTD_Total_Funded_Amount from loan_data
where year(issue_date) = 2021 
and month(issue_date) = 12
GO

--Calculate Previous Total Funded Amount for November Month 
Select SUM(loan_amount) as PMTD_Total_Funded_Amount from loan_data
where year(issue_date) = 2021 
and month(issue_date) = 11
GO

--Calculate MOM Total Funded Amount
With Total_Funded_Amount as
(SELECT
Year(issue_date) AS Year,
Month(issue_date) AS Month,
SUM(loan_amount) AS Total_Funded_Amount
FROM loan_data
GROUP BY Year(issue_date), Month(issue_date)
),
--WITH is common table expression (CTE) stores data results temporarily

MOM AS(
SELECT 
Year, 
Month,
Total_Funded_Amount as Current_Month_Funded_Amount,
LAG(Total_Funded_Amount) OVER(ORDER BY Year, Month) as Previous_Month_Funded_Amount,
(Total_Funded_Amount-Lag(Total_Funded_Amount) OVER( ORDER BY Year, Month)) * 100.0/
NULLIF(LAG(Total_Funded_Amount) OVER (ORDER BY Year, Month), 0) AS MOM_Percentage_Change
from Total_Funded_Amount
)
--NULLIF - Prevents division by zero when the previous month’s applications are 0.
--OVER- Clause defines the order in which rows are processed.
--LAG -Retrieves the value from a previous row in the result set 
-- MOM = ((MTD-PMTD)/PMTD)

Select 
Year, 
Month, 
Current_Month_Funded_Amount, 
Previous_Month_Funded_Amount, 
CAST(Round(MOM_Percentage_Change,3) as float) as MOM_Percentage_Change 
--Cast is used to change one data type to another e.g CAST(column_name AS data_type)
--Round (round(expression,decimal_places)
FROM MOM
Order by Month ASC;
Go


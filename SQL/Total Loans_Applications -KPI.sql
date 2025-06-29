--- Use Bank_loan database for this query
use Bank_loan
Go
--Select data from table loan_Data
Select * from loan_data
Go

---Calculate Total loan Applications
Select count(*) as Total_Loan_Applications from loan_data
Go

--- Month To Date (MTD) loan applications
Select Count(*) as MTD_Loan_Applications FROM loan_data
where year(issue_date) = 2021 
and month(issue_date) = 12
GO

--- Previous Month To Date (PMTD) loan applications
Select Count(*) as PMTD_Loan_Applications FROM loan_data
where year(issue_date) = 2021 
and month(issue_date) = 11
Go

--Calculate MOM loan applications changes 
With MonthlyCounts as
(SELECT
Year(issue_date) AS Year,
Month(issue_date) AS Month,
Count(*) AS Loan_Applications
FROM loan_data
GROUP BY Year(issue_date), Month(issue_date)
),
--WITH is common table expression (CTE) stores data results temporarily

MOM AS(
SELECT 
Year, 
Month,
Loan_Applications as Current_Month_Applications,
LAG(Loan_Applications) OVER(ORDER BY Year, Month) as Previous_Month_Applications,
(Loan_Applications-Lag(Loan_Applications) OVER( ORDER BY Year, Month)) * 100.0/
NULLIF(LAG(Loan_Applications) OVER (ORDER BY Year, Month), 0) AS MOM_Percentage_Change
from MonthlyCounts
)
--NULLIF - Prevents division by zero when the previous month’s applications are 0.
--OVER- Clause defines the order in which rows are processed.
--LAG -Retrieves the value from a previous row in the result set 
-- MOM = ((MTD-PMTD)/PMTD)

Select 
Year, 
Month, 
Current_Month_Applications, 
Previous_Month_Applications, 
CAST(Round(MOM_Percentage_Change,3) as float) as MOM_Percentage_Change 
--Cast is used to change one data type to another e.g CAST(column_name AS data_type)
--Round (round(expression,decimal_places)
from MOM
Order by Month ASC;
Go


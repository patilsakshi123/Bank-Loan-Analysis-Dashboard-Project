--- Use Bank_loan database for this query
use Bank_loan
Go

--Select data from table loan_Data
Select * from loan_data
Go

--Calculate Average DTI
Select ROUND(AVG(dti)*100.0,2) as Average_DTI from loan_data
Go

--Calculate Average Interest Rate for December Month 
Select ROUND(AVG(dti)*100.0,2)as MTD_Average_DTI from loan_data
where year(issue_date) = 2021 
and month(issue_date) = 12
GO

--Calculate Average Interest Rate for November Month 
Select ROUND(AVG(dti)*100.0,2)as PMTD_Average_DTI from loan_data
where year(issue_date) = 2021 
and month(issue_date) = 11
GO

--Calculate MOM Average DTI
With Average_DTI as
(SELECT
Year(issue_date) AS Year,
Month(issue_date) AS Month,
AVG(dti)*100.0 AS Average_DTI
FROM loan_data
GROUP BY Year(issue_date), Month(issue_date)
),
--WITH is common table expression (CTE) stores data results temporarily

MOM AS(
SELECT 
Year, 
Month,
Average_DTI as Current_Month_Average_DTI,
LAG(Average_DTI) OVER(ORDER BY Year, Month) as Previous_Month_Average_DTI,
(Average_DTI-Lag(Average_DTI) OVER( ORDER BY Year, Month)) * 100.0/
NULLIF(LAG(Average_DTI) OVER (ORDER BY Year, Month), 0) AS MOM_Percentage_Change
from Average_DTI
)
--NULLIF - Prevents division by zero when the previous month’s applications are 0.
--OVER- Clause defines the order in which rows are processed.
--LAG -Retrieves the value from a previous row in the result set 
-- MOM = ((MTD-PMTD)/PMTD)

Select 
Year, 
Month, 
ROUND(Current_Month_Average_DTI,2) as Current_Month_Average_DTI, 
ROUND(Previous_Month_Average_DTI, 2) as Previous_Month_Average_DTI,
CAST(Round(MOM_Percentage_Change,3) as float) as MOM_Percentage_Change 
--Cast is used to change one data type to another e.g CAST(column_name AS data_type)
--Round (round(expression,decimal_places)
FROM MOM	
Order by Month ASC;
Go
--- Use Bank_loan database for this query
use Bank_loan
Go

--Select data from table loan_Data
Select * from loan_data
Go

--Calculate Total Amount Received 
Select SUM(total_payment) as Total_Amount_Received from loan_data
Go

--Calculate Total Amount Received for December Month 
Select SUM(total_payment) as MTD_Total_Amount_Received from loan_data
where year(issue_date) = 2021 
and month(issue_date) = 12
GO

--Calculate Previous Total Amount Received for November Month 
Select SUM(total_payment) as PMTD_Total_Amount_Received from loan_data
where year(issue_date) = 2021 
and month(issue_date) = 11
GO

--Calculate MOM Total Amount Received
With Total_Amount_Received as
(SELECT
Year(issue_date) AS Year,
Month(issue_date) AS Month,
SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY Year(issue_date), Month(issue_date)
),
--WITH is common table expression (CTE) stores data results temporarily

MOM AS(
SELECT 
Year, 
Month,
Total_Amount_Received as Current_Month_Amount_Received,
LAG(Total_Amount_Received) OVER(ORDER BY Year, Month) as Previous_Month_Amount_Received,
(Total_Amount_Received-Lag(Total_Amount_Received) OVER( ORDER BY Year, Month)) * 100.0/
NULLIF(LAG(Total_Amount_Received) OVER (ORDER BY Year, Month), 0) AS MOM_Percentage_Change
from Total_Amount_Received
)
--NULLIF - Prevents division by zero when the previous month’s applications are 0.
--OVER- Clause defines the order in which rows are processed.
--LAG -Retrieves the value from a previous row in the result set 
-- MOM = ((MTD-PMTD)/PMTD)

Select 
Year, 
Month, 
Current_Month_Amount_Received, 
Previous_Month_Amount_Received, 
CAST(Round(MOM_Percentage_Change,3) as float) as MOM_Percentage_Change 
--Cast is used to change one data type to another e.g CAST(column_name AS data_type)
--Round (round(expression,decimal_places)
FROM MOM
Order by Month ASC;
Go


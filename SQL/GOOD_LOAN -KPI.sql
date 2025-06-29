--- Use Bank_loan database for this query
use Bank_loan
Go

--Select data from table loan_Data
Select * from loan_data
Go


--Calculate Good Loan and Bad Loan KPI's 
--Good loan - means Fully Paid and Current 
--Bad loan - means Charged Off
---Classification as Good loan , Bad loan 
WITH Loan_Classification AS (SELECT 
  id,
  loan_amount,
  loan_status,
  CASE 
    WHEN loan_status IN ('Charged Off') THEN 'Bad Loan'
    WHEN loan_status IN ('Fully Paid', 'Current') THEN 'Good Loan'
  END AS Loan_Classification
FROM loan_data
)
--Calculate Total Good Loan Applications
Select count(*) as Total_Good_Loan_Applications from Loan_Classification
Where Loan_Classification = 'Good Loan'
Go

--Calculate Total Good Loan Applications Percentage
Select
(COUNT(CASE 
WHEN loan_status ='Fully Paid' or loan_status ='Current' 
Then id End)*100)/Count(id) AS Good_Loan_Percentage
FROM loan_data
Go

--Calculate Total Good Loan Funded Amount
SELECT(
SUM(CASE WHEN loan_status = 'Fully Paid' or loan_status = 'Current' THEN loan_amount END)) AS Good_loan_Funded_Amount
FROM loan_data
Go

--Calculate Good Loan Total Amount recieved
SELECT(
SUM(CASE WHEN loan_status = 'Fully Paid' or loan_status = 'Current' THEN total_payment END)) AS Good_loan_Amount_recievec
FROM loan_data
Go


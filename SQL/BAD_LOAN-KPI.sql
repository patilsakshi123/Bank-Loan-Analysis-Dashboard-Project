--- Use Bank_loan database for this query
use Bank_loan
Go

--Select data from table loan_Data
Select * from loan_data
Go


--Calculate Good Loan and Bad Loan KPI's 
--Good loan - means fully paid and current 
--Bad loan - means charged off

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
--Calculate Total Bad Loan Applications
Select count(*) as Total_Bad_Loan_Applications from Loan_Classification
Where Loan_Classification = 'Bad Loan'
Go

--Calculate Total Bad Loan Applications Percentage
Select
(COUNT(CASE WHEN loan_status ='Charged Off' Then id End)*100)/Count(id) AS Bad_Loan_Percentage
FROM loan_data
Go

--Calculate Total Bad Loan Funded Amount
SELECT(
SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amount END)) AS Bad_loan_Funded_Amount
FROM loan_data
Go

--Calculate Bad Loan Total Amount recieved
SELECT(
SUM(CASE WHEN loan_status = 'Charged Off' THEN total_payment END)) AS Bad_loan_Amount_recievec
FROM loan_data
Go

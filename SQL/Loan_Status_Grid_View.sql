--- Use Bank_loan database for this query
use Bank_loan
Go

--Select data from table loan_Data
Select * from loan_data
Go

--Calculate loan status Grid View
SELECT 
loan_status,
count(id) as Total_loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received,
ROUND(AVG(dti)*100.0,2) as Average_DTI ,
ROUND(AVG(int_rate)*100.0,2) as Average_Interest_Rate
from loan_data
GROUP BY loan_status
Go

--Calculate MTD Funded Amount and Amount recieved
SELECT 
  loan_status,
  MONTH(issue_date) AS Month,
  SUM(loan_amount) AS MTD_Total_Funded_Amount,
  SUM(total_payment) AS MTD_Total_Amount_Received
FROM loan_data
GROUP BY loan_status, MONTH(issue_date)
ORDER BY Month ASC;


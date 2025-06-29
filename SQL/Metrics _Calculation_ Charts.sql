--- Use Bank_loan database for this query
use Bank_loan
Go

--Select data from table loan_Data
Select * from loan_data
Go

----Calculate Monthly Trends by Issue date
SELECT 
  MONTH(issue_date) AS Month_Number,
  DATENAME(MONTH, issue_date) AS Month_Name,
  COUNT(id) AS Total_Loan_Applications,
  SUM(loan_amount) AS Total_Funded_Amount,
  SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY Month_Number ASC;
GO


--Calculate Trends by State
SELECT 
  address_state,
  COUNT(id) AS Total_Loan_Applications,
  SUM(loan_amount) AS Total_Funded_Amount,
  SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY address_state
ORDER BY SUM(loan_amount) DESC;
GO

--Calculate loan Term Analysis
SELECT 
  term,
  COUNT(id) AS Total_Loan_Applications,
  SUM(loan_amount) AS Total_Funded_Amount,
  SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY term
ORDER BY term DESC;
GO

--Calculate Employee length Analysis
SELECT 
  emp_length,
  COUNT(id) AS Total_Loan_Applications,
  SUM(loan_amount) AS Total_Funded_Amount,
  SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY emp_length
ORDER BY emp_length DESC;
GO


--Based on Loan Purpose calculate the following metrics 
SELECT 
  purpose,
  COUNT(id) AS Total_Loan_Applications,
  SUM(loan_amount) AS Total_Funded_Amount,
  SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY purpose
ORDER BY SUM(loan_amount) DESC;
GO

--Based on Home Ownership ,calculate metrics 
SELECT 
  home_ownership,
  COUNT(id) AS Total_Loan_Applications,
  SUM(loan_amount) AS Total_Funded_Amount,
  SUM(total_payment) AS Total_Amount_Received
FROM loan_data
GROUP BY home_ownership
ORDER BY SUM(loan_amount) DESC;
GO





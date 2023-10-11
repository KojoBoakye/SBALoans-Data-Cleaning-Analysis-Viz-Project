
--   Question 1: what is the summary of all approved loans by the SBA?
SELECT 
year(DateApproved) as Year_Approved,
COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan
  FROM [SBA].[dbo].[public_150k_plus_230930]

 where year(DateApproved)=2020
 GROUP by YEAR(DateApproved)

 UNION

 SELECT 
year(DateApproved) as Year_Approved,
COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan
  FROM [SBA].[dbo].[public_150k_plus_230930]

 where year(DateApproved)=2021
 GROUP by YEAR(DateApproved)

--   Total Number of loans is 968,525
--   Total amount of loans is $515,518,176,988.478
--   average loan amount is $532,271.42

--   Total Number of loans in 2020 is 659,441
--   Total amount of loans in 2020 is $377,642,663,936.53784
--   average loan amount in 2020 is $572670.89

--   Total Number of loans in 2021 is 309,084
--   Total amount of loans in 2021 is $137,875,513,051.9291
--   average loan amount in 2021 is $572,670.89




--   Question 2: Top 15 originating lenders by loan count, total amount, and average in 2020 and 2021?

SELECT top 15
OriginatingLender,
COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan
 FROM [SBA].[dbo].[public_150k_plus_230930]
 where year(DateApproved)=2020
 GROUP by OriginatingLender
 order by Total_Amount_of_Loans desc 
  
 

SELECT  top 15
OriginatingLender,
COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan
FROM [SBA].[dbo].[public_150k_plus_230930]

 where year(DateApproved)=2021
 GROUP by OriginatingLender
 order by Total_Amount_of_Loans desc



 --   Question 3:Top 20 industries that received the SBA loans in 2020 and 2021

  Select top 20
  sector,
  COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan

 FROM [SBA].[dbo].[public_150k_plus_230930] as  kl
 INNER JOIN [SBA].[dbo].[sba_desc_codes_sector] as kb
 on 
 LEFT(kl.NAICSCode,2) = kb.lookup_codes
  where year(DateApproved)=2020
  GROUP by sector 
  order by Total_Amount_of_Loans DESC


    Select top 20
  sector,
  COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan

 

 FROM [SBA].[dbo].[public_150k_plus_230930] as  kl
 INNER JOIN [SBA].[dbo].[sba_desc_codes_sector] as kb
 on 
 LEFT(kl.NAICSCode,2) = kb.lookup_codes
  where year(DateApproved)=2021
  GROUP by sector 
  order by Total_Amount_of_Loans DESC


--   percentages of loan amount in total amount of loans disbursed in 2021
WITH temp as (
 Select
  sector,
  COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan

 

 FROM [SBA].[dbo].[public_150k_plus_230930] as  kl
 INNER JOIN [SBA].[dbo].[sba_desc_codes_sector] as kb
 on 
 LEFT(kl.NAICSCode,2) = kb.lookup_codes
  where year(DateApproved)=2020
  GROUP by sector 
 
)

Select top 20
 sector,
 Total_Amount_of_Loans,
 Total_Amount_of_Loans/(
 SELECT 
SUM(InitialApprovalAmount) as Total_Amount_of_Loans
  FROM [SBA].[dbo].[public_150k_plus_230930]
 where year(DateApproved)=2020
 )*100 as Perecentage_of_loan_amount
FROM temp
 order by Perecentage_of_loan_amount desc

 --   percentages of loan amount in total amount of loans disbursed in 2021
WITH temp as (
 Select
  sector,
  COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan

 

 FROM [SBA].[dbo].[public_150k_plus_230930] as  kl
 INNER JOIN [SBA].[dbo].[sba_desc_codes_sector] as kb
 on 
 LEFT(kl.NAICSCode,2) = kb.lookup_codes
  where year(DateApproved)=2021
  GROUP by sector 
 
)

Select top 20
 sector,
 Total_Amount_of_Loans,
 Total_Amount_of_Loans/(
 SELECT 
SUM(InitialApprovalAmount) as Total_Amount_of_Loans
  FROM [SBA].[dbo].[public_150k_plus_230930]
 where year(DateApproved)=2021
 )*100 as Perecentage_of_loan_amount
FROM temp
 order by Perecentage_of_loan_amount desc

 
 --   Question 4:how much of the total loan amount has been forgiven by the SBA?


 SELECT 
 2020 as year ,
SUM(CurrentApprovalAmount) as Total_Current_Amount_of_Loans,
round(AVG(CurrentApprovalAmount),2) as average_Current_amount_of_loan,
SUM(ForgivenessAmount) as Total_amount_forgiven,
concat(round (SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 , 2) , '%')as percentage_forgiven
  FROM [SBA].[dbo].[public_150k_plus_230930]

 where year(DateApproved)=2020
 
 UNION

 SELECT 
 2021 year,
SUM(CurrentApprovalAmount) as Total_Current_Amount_of_Loans,
round(AVG(CurrentApprovalAmount),2) as average_Current_amount_of_loan,
SUM(ForgivenessAmount) as Total_amount_forgiven,
concat(round (SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 , 2) , '%')as percentage_forgiven
  FROM [SBA].[dbo].[public_150k_plus_230930]

 where year(DateApproved)=2021
 

--  overall amount forgiven for both years

SELECT 
 
SUM(CurrentApprovalAmount) as Total_Current_Amount_of_Loans,
round(AVG(CurrentApprovalAmount),2) as average_Current_amount_of_loan,
SUM(ForgivenessAmount) as Total_amount_forgiven,
concat(round (SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 , 2) , '%')as percentage_forgiven
  FROM [SBA].[dbo].[public_150k_plus_230930]


 --   Question 5:year,month where highest loans were agreed?

 SELECT top 10
year(DateApproved) as Year_Approved,
MONTH(DateApproved) as Month_Approved,
COUNT(LoanNumber) as Total_Number_of_loans,
SUM(InitialApprovalAmount) as Total_Amount_of_Loans,
round(AVG(InitialApprovalAmount),2) as average_amount_of_loan
  FROM [SBA].[dbo].[public_150k_plus_230930]
 GROUP by  year(DateApproved),MONTH(DateApproved)
 ORDER by Total_Number_of_loans DESC

 


-- script to select the interested columns in the NAICS table
 
     SELECT *
     into sba_desc_codes_sector
      From (
    SELECT 
      [NAICS_Industry_Description],
      Case
       when [NAICS_Industry_Description] like '% – %' 
       then SUBSTRING([NAICS_Industry_Description],8,2) end as lookup_codes,
      Case 
       when [NAICS_Industry_Description] like '% – %' 
       then LTRIM( SUBSTRING([NAICS_Industry_Description],(CHARINDEX('–',[NAICS_Industry_Description])+1),LEN([NAICS_Industry_Description])))
       
       when [NAICS_Industry_Description] like '(%' 
       then ''
       
        end as sector
     
  FROM [SBA].[dbo].[NAICS]
  WHERE[NAICS_Codes] is NULL
  ) as main
     WHERE lookup_codes !=''


     SELECT TOP (1000) [NAICS_Industry_Description]
      ,[lookup_codes]
      ,[sector]
  FROM [SBA].[dbo].[sba_desc_codes_sector]


  insert into [SBA].[dbo].[sba_desc_codes_sector]
  VALUES
  ('Sector 31 – 33 – Manufacturing',32,'Manufacturing'),
  ('Sector 31 – 33 – Manufacturing',33,'Manufacturing'),
  ('Sector 44 – 45 – Retail Trade',45,'Retail Trade'),
  ('Sector 48 - 49 – Transportation and Warehousing',49,'Transportation and Warehousing')

  UPDATE [SBA].[dbo].[sba_desc_codes_sector]
  SET sector = 'Manufacturing'
  where lookup_codes = '31'

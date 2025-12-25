SELECT * 
	FROM credit_risk_data;
    
-- CHANGE COLUMN NAME
ALTER TABLE credit_risk_data
	RENAME COLUMN ï»¿client_ID TO Client_ID;
    
ALTER TABLE credit_risk_data
	RENAME COLUMN person_age TO Client_Age;
        
ALTER TABLE credit_risk_data
	RENAME COLUMN person_income TO Client_Income;
    
ALTER TABLE credit_risk_data
	RENAME COLUMN person_home_ownership TO Residential_Status;
    
ALTER TABLE credit_risk_data
	RENAME COLUMN person_emp_length TO Employment_Lenght;
    
ALTER TABLE credit_risk_data
	RENAME COLUMN loan_amnt TO Loan_amount;
    
ALTER TABLE credit_risk_data
	RENAME COLUMN loan_int_rate TO Interest_rate;
    
ALTER TABLE credit_risk_data
	RENAME COLUMN cb_person_default_on_file TO Default_flag;
    
ALTER TABLE credit_risk_data
	RENAME COLUMN cb_person_cred_hist_length TO Credit_History;
    

-- FIND DUPLICATE COLUMNS
SELECT 
	Client_ID, Interest_rate, COUNT(*) AS duplicate_count
FROM 
	credit_risk_data
GROUP BY 
	Client_ID, Interest_rate
HAVING COUNT(*) > 1;    -- there was no duplicate found
            
            
-- DATA EXPLORATION: FOCUS ON UK BRANCH


-- DEFAULTED LOANS VS ONTIME PAYMENT
SELECT 
	SUM(CASE WHEN Default_flag = "Y" THEN 1 ELSE 0 END) AS defaulted,
	SUM(CASE WHEN Default_flag = "N" THEN 1 ELSE 0 END) AS Non_defaulted
FROM 
	 credit_risk_data
WHERE 
    country = "UK";
    
    
-- CLIENT COUNT BY EMPLOYMENT STATUS 
SELECT 
	employment_type, COUNT(Client_ID) AS clients
FROM 
	credit_risk_data
WHERE 
    country = "UK"
GROUP BY 
	employment_type
ORDER BY 
	clients
DESC;   

-- Which CLIENT employment status are more likely to default?

SELECT 
	employment_type, COUNT(Client_ID) AS clients
FROM 
	credit_risk_data
WHERE 
	Default_flag = "Y" AND country = "UK"
GROUP BY 
	employment_type
ORDER BY 
	clients
DESC;   

-- No of clients by age group 
SELECT 
	CASE
		WHEN client_age BETWEEN 18 AND 29 THEN "18-29"
        WHEN client_age BETWEEN 30 AND 39 THEN "30-39"
        WHEN client_age BETWEEN 40 AND 49 THEN "40-49"
        WHEN client_age BETWEEN 50 AND 59 THEN "50-59"
        WHEN client_age >= 60 THEN "60+"
        ELSE "Out Of Range"
	END AS Age_Group,
		COUNT(Client_ID) AS clients
FROM
    credit_risk_data
WHERE country = "UK"    
GROUP BY 
    Age_Group
ORDER BY clients
DESC;    


-- DEFAULTERS BY AGE
SELECT 
	CASE
		WHEN client_age BETWEEN 18 AND 29 THEN "18-29"
        WHEN client_age BETWEEN 30 AND 39 THEN "30-39"
        WHEN client_age BETWEEN 40 AND 49 THEN "40-49"
        WHEN client_age BETWEEN 50 AND 59 THEN "50-59"
        WHEN client_age >= 60 THEN "60+"
        ELSE "Out Of Range"
	END AS Age_Group,
		COUNT(Client_ID) AS clients
FROM
    credit_risk_data
WHERE 
    Default_flag = "Y" AND country = "UK"
GROUP BY 
    Age_Group
ORDER BY clients
DESC;    
        
        
        
     

    
    
        


     
    
CREATE DATABASE BankingDB;
USE BankingDB;

DROP TABLE IF EXISTS Banking;

CREATE TABLE Banking (
    `Client ID` VARCHAR(20),
    `Name` VARCHAR(100),
    `Age` INT,
    `Location ID` INT,
    `Joined Bank` VARCHAR(20),
    `Banking Contact` VARCHAR(100),
    `Nationality` VARCHAR(100),
    `Occupation` VARCHAR(100),
    `Fee Structure` VARCHAR(25),
    `Loyalty Classification` VARCHAR(25),
    `Estimated Income` DECIMAL(18,2),
    `Superannuation Savings` DECIMAL(18,2),
    `Amount of Credit Cards` INT,
    `Credit Card Balance` DECIMAL(18,2),
    `Bank Loans` DECIMAL(18,2),
    `Bank Deposits` DECIMAL(18,2),
    `Checking Accounts` DECIMAL(18,2),
    `Saving Accounts` DECIMAL(18,2),
    `Foreign Currency Account` DECIMAL(18,2),
    `Business Lending` DECIMAL(18,2),
    `Properties Owned` INT,
    `Risk Weighting` INT,
    `BRId` INT,
    `GenderId` INT,
    `IAId` INT
);


## -------- VERIFY DATASET THAT IT SUCCESSFULLY IMPORTED DATASET -------- ##
SELECT
    `Estimated Income`,
    `Bank Loans`,
    `Bank Deposits`,
    `Business Lending`
FROM Banking
LIMIT 10;

## --------DATA VALIDATION-------- ##
#---1)Check Number of Customers---#
SELECT COUNT(*) AS Total_Rows
FROM Banking;

#---2)Check Columns---#
DESC Banking;

#---3)Check Missing Values---#
SELECT
	SUM(`Client ID` IS NULL) AS Missing_CLient_ID,
    SUM(`Name` IS NULL) AS Missing_Name,
	SUM(`Age` IS NULL) AS Missing_Age,
    SUM(`Estimated Income` IS NULL) AS Missing_Income,
    SUM(`Bank Loans` IS NULL) AS Missing_Loans,
    SUM(`Bank Deposits` IS NULL) AS Missing_Deposits,
    SUM(`GenderId` IS NULL) AS Missing_Gender
FROM Banking;
## --------SQL DATA CLEANING-------- ##
#---1)Check Duplicate Customers---#
SELECT
	`Client ID`,
    COUNT(*) AS Duplicate_Count
FROM banking
GROUP BY `Client ID`
HAVING COUNT(*) > 1;

#---2)Check Age Range---#
SELECT 
	MIN(Age) AS Minimum_Age,
    MAX(Age) AS Maximum_Age,
    ROUND(AVG(Age),2) AS Average_Age
FROM Banking;

#---3)Check Negative Financial Values---#
SELECT *
FROM Banking
WHERE `Estimated Income` < 0
	OR `Bank Deposits` < 0
    OR `Bank Loans` < 0
    OR `Saving Accounts` < 0
    OR `Checking Accounts` < 0
    OR `Business Lending` < 0;

## -------- Createing Clean Analytical View -------- ##
CREATE VIEW Banking_Clean AS 
SELECT
	`Client ID`,
    `Name`,
    Age,
    `Location ID`,
    `Joined Bank`,
    `Banking Contact`,
    `Nationality`,
    `Occupation`,
    `Fee Structure`,
    `Loyalty Classification`,
    `Estimated Income`,
    `Superannuation Savings`,
    `Amount of Credit Cards`,
    `Credit Card Balance`,
    `Bank Loans`,
    `Bank Deposits`,
    `Checking Accounts`,
    `Saving Accounts`,
    `Foreign Currency Account`,
    `Business Lending`,
    `Properties Owned`,
    `Risk Weighting`,
    
    `BRId`,
    
    CASE 
		WHEN `GenderId` = 1 THEN 'Male'
        WHEN `GenderId` = 2 THEN 'Female'
        ELSE 'Unknown'
	END AS Gender,
    
    `IAId`,
    
    CASE
		WHEN `Estimated Income` < 50000 THEN 'Low'
        WHEN `Estimated Income` < 100000 THEN 'Mid'
	END AS Income_Band,
    
    CASE 
		WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 44 THEN '30-44'
        WHEN Age BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+'
	END AS Age_Group
FROM Banking;

SELECT *
FROM Banking_CLean
LIMIT 10;

## -------- SQL EDA -------- ##
#--- 1)Overall Customer Statistics ---#
SELECT 
	COUNT(*) AS Total_Customers,
    ROUND(AVG(Age),2) AS Average_Age,
    ROUND(AVG(`Estimated Income`),2) AS Average_Income,
    ROUND(AVG(`Bank Loans`),2) AS Average_Loan,
    ROUND(AVG(`Bank Deposits`),2) AS Average_Deposit,
    ROUND(AVG(`Credit Card Balance`),2) AS Average_Credit_Card_Balance,
    ROUND(AVG(`Business Lending`),2) AS Average_Business_Lending
FROM Banking;
#--- 2)Total Financial Portfolio ---#
SELECT
    ROUND(SUM(`Bank Loans`),2) AS Total_Bank_Loans,
    ROUND(SUM(`Bank Deposits`),2) AS Total_Bank_Deposits,
    ROUND(SUM(`Checking Accounts`),2) AS Total_Checking,
    ROUND(SUM(`Saving Accounts`),2) AS Total_Savings,
    ROUND(SUM(`Foreign Currency Account`),2) AS Total_Foreign_Currency,
    ROUND(SUM(`Business Lending`),2) AS Total_Business_Lending,
    ROUND(SUM(`Credit Card Balance`),2) AS Total_Credit_Card_Balance
FROM Banking;

#--- 3)Gender Analysis ---#
SELECT
    ROUND(SUM(`Bank Loans`),2) AS Total_Bank_Loans,
    ROUND(SUM(`Bank Deposits`),2) AS Total_Bank_Deposits,
    ROUND(SUM(`Checking Accounts`),2) AS Total_Checking,
    ROUND(SUM(`Saving Accounts`),2) AS Total_Savings,
    ROUND(SUM(`Foreign Currency Account`),2) AS Total_Foreign_Currency,
    ROUND(SUM(`Business Lending`),2) AS Total_Business_Lending,
    ROUND(SUM(`Credit Card Balance`),2) AS Total_Credit_Card_Balance
FROM Banking;

#--- 4)Nationality Analysis ---#
SELECT
    Nationality,
    COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`),2) AS Avg_Income,
    ROUND(AVG(`Bank Loans`),2) AS Avg_Loan,
    ROUND(AVG(`Bank Deposits`),2) AS Avg_Deposit
FROM Banking_Clean
GROUP BY Nationality
ORDER BY Customers DESC;

#--- 5)Occupation Analysis ---#
SELECT
    Occupation,
    COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`),2) AS Avg_Income,
    ROUND(SUM(`Bank Loans`),2) AS Total_Loans,
    ROUND(SUM(`Bank Deposits`),2) AS Total_Deposits
FROM Banking
GROUP BY Occupation
ORDER BY Customers DESC;

#--- 6)Loyalty Classification ---#
SELECT
    `Loyalty Classification`,
    COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`),2) AS Avg_Income,
    ROUND(AVG(`Bank Deposits`),2) AS Avg_Deposits,
    ROUND(AVG(`Bank Loans`),2) AS Avg_Loans
FROM Banking
GROUP BY `Loyalty Classification`
ORDER BY Customers DESC;

#--- 7)Income Band Analysis ---#
SELECT
    Income_Band,
    COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`),2) AS Avg_Income,
    ROUND(AVG(`Bank Deposits`),2) AS Avg_Deposits,
    ROUND(AVG(`Bank Loans`),2) AS Avg_Loans
FROM Banking_Clean
GROUP BY Income_Band
ORDER BY
    CASE Income_Band
        WHEN 'Low' THEN 1
        WHEN 'Mid' THEN 2
        WHEN 'High' THEN 3
    END;

#--- 8)Age Group Analysis ---#
SELECT
    Age_Group,
    COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`),2) AS Avg_Income,
    ROUND(AVG(`Bank Loans`),2) AS Avg_Loans,
    ROUND(AVG(`Bank Deposits`),2) AS Avg_Deposits
FROM Banking_Clean
GROUP BY Age_Group
ORDER BY
    CASE Age_Group
        WHEN 'Under 30' THEN 1
        WHEN '30-44' THEN 2
        WHEN '45-59' THEN 3
        WHEN '60+' THEN 4
    END;
#--- 9)Top 10 Customers by Bank Deposits ---#
SELECT
    `Client ID`,
    `Name`,
    Nationality,
    `Estimated Income`,
    `Bank Deposits`
FROM Banking
ORDER BY `Bank Deposits` DESC
LIMIT 10;

#--- 10)Top 10 Customers by Loans ---#
SELECT
    `Client ID`,
    `Name`,
    Nationality,
    `Estimated Income`,
    `Bank Loans`
FROM Banking
ORDER BY `Bank Loans` DESC
LIMIT 10;

#--- 11)Top Customers by Income ---#
SELECT
    `Client ID`,
    `Name`,
    Occupation,
    Nationality,
    `Estimated Income`
FROM Banking
ORDER BY `Estimated Income` DESC
LIMIT 10;

#--- 12)Customers with Highest Credit Card Balance ---#
SELECT
    `Client ID`,
    `Name`,
    `Amount of Credit Cards`,
    `Credit Card Balance`
FROM Banking
ORDER BY `Credit Card Balance` DESC
LIMIT 10;

#--- 13)Property Ownership Analysis ---#
SELECT
    `Properties Owned`,
    COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`),2) AS Avg_Income,
    ROUND(AVG(`Bank Deposits`),2) AS Avg_Deposits
FROM Banking
GROUP BY `Properties Owned`
ORDER BY `Properties Owned`;

#--- 14)Risk Weighting Analysis ---#
SELECT
    `Risk Weighting`,
    COUNT(*) AS Customers,
    ROUND(AVG(`Bank Loans`),2) AS Avg_Loans,
    ROUND(AVG(`Bank Deposits`),2) AS Avg_Deposits
FROM Banking
GROUP BY `Risk Weighting`
ORDER BY `Risk Weighting`;

#--- 15)Branch Analysis ---#
SELECT
    BRId AS Branch_ID,
    COUNT(*) AS Customers,
    ROUND(AVG(`Bank Deposits`),2) AS Avg_Deposits,
    ROUND(AVG(`Bank Loans`),2) AS Avg_Loans,
    ROUND(AVG(`Estimated Income`),2) AS Avg_Income
FROM Banking
GROUP BY BRId
ORDER BY Customers DESC;

#--- 16)Banking Relationship Analysis ---#
SELECT
    COUNT(*) AS Customers_With_Loan_And_Deposit
FROM Banking
WHERE `Bank Loans` > 0
AND `Bank Deposits` > 0;

#--- 17)High-Value Customers ---#
SELECT
    `Client ID`,
    `Name`,
    `Estimated Income`,
    `Bank Deposits`,
    `Bank Loans`,
    `Saving Accounts`,
    `Checking Accounts`
FROM Banking
WHERE `Estimated Income` >= 100000
  AND `Bank Deposits` >= 50000
ORDER BY `Bank Deposits` DESC;

#--- 18)Loan-to-Income Ratio ---#
SELECT
    `Client ID`,
    `Name`,
    `Estimated Income`,
    `Bank Loans`,
    ROUND(
        (`Bank Loans` / NULLIF(`Estimated Income`,0)) * 100,
        2
    ) AS Loan_To_Income_Percentage
FROM Banking
ORDER BY Loan_To_Income_Percentage DESC;

#--- 19)Deposit-to-Income Ratio ---#
SELECT
    `Client ID`,
    `Name`,
    `Estimated Income`,
    `Bank Deposits`,
    ROUND(
        (`Bank Deposits` / NULLIF(`Estimated Income`,0)) * 100,
        2
    ) AS Deposit_To_Income_Percentage
FROM Banking
ORDER BY Deposit_To_Income_Percentage DESC;



















## -------- BASIC DA -------- ##
SELECT
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Age), 2) AS Average_Age,
    ROUND(AVG(`Estimated Income`), 2) AS Average_Income,
    ROUND(AVG(`Bank Loans`), 2) AS Average_Loan,
    ROUND(AVG(`Bank Deposits`), 2) AS Average_Deposit,
    ROUND(AVG(`Business Lending`), 2) AS Average_Business_Lending
FROM Banking;

## -------- CUSTOMER ANALYSIS BY LOYALTY CLASSIFICATION -------- ##
SELECT
	`Loyalty Classification`,
    COUNT(*) AS Customer,
    ROUND(AVG(`Estimated Income`), 2) AS Avg_Income,
    ROUND(AVG(`Bank Deposits`), 2) AS Avg_Desposits,
    ROUND(AVG(`Bank Loans`), 2) AS Avg_Loans
FROM Banking
GROUP BY `Loyalty Classification`
ORDER BY Avg_Income DESC;

## -------- ANALYSIS BY FEE STRUCTURE -------- ##
SELECT 
	`Fee Structure`,
    COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`), 2) AS Avg_Income,
	ROUND(AVG(`Credit Card Balance`), 2) AS Avg_Credit_Card_Balance,
    ROUND(AVG(`Bank Loans`), 2) AS Avg_Loans
FROM Banking
GROUP BY `Fee Structure`
ORDER BY Customers DESC;

## -------- NATIONALITY ANALYSIS -------- ##
SELECT
	`Nationality`,
    COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`), 2) AS Avg_Income,
    ROUND(AVG(`Bank Deposits`), 2) AS Avg_Deposits
FROM Banking
GROUP BY `Nationality`
ORDER BY Customers DESC;

## -------- RISK ANALYSIS ~ (MOST IMP ANALYSIS) -------- ##
SELECT 
	`Risk Weighting`,
    COUNT(*) AS Customer,
    ROUND(AVG(`Estimated Income`), 2) AS Avg_Income,
    ROUND(AVG(`Bank Loans`), 2) AS Avg_Loans,
    ROUND(AVG(`Bank Deposits`), 2) AS Avg_Deposits
FROM banking
GROUP BY `Risk Weighting`
ORDER BY `Risk Weighting`;

## -------- AGE GROUP ANALYSIS -------- ##
SELECT 
	CASE
		WHEN Age < 30 THEN 'Under 30'
		WHEN Age BETWEEN 30 AND 44 THEN '30-44'
		WHEN Age BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+'
	END AS Age_Group,
    COUNT(*) AS Customers,
    ROUND (AVG(`Estimated Income`), 2) AS Avg_Income,
    ROUND(AVG(`Bank Deposits`), 2) AS Avg_Deposits
FROM banking
GROUP BY
	CASE 
		WHEN Age < 30 THEN 'Under 30'
		WHEN Age BETWEEN 30 AND 44 THEN '30-44'
		WHEN Age BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60+'
	END
ORDER BY Avg_Income DESC;

## -------- GENDER ANALYSIS -------- ##
SELECT
	GenderId,
	COUNT(*) AS Customers,
    ROUND(AVG(`Estimated Income`), 2) AS Avg_Income,
    ROUND(AVG(`Bank Deposits`), 2) AS Avg_Deposits,
	ROUND(AVG(`Bank Loans`), 2) AS Avg_Loans
FROM banking
GROUP BY GenderId;

## -------- TOP CUSTOMKERS BY BANK DEPOSITS -------- ##
SELECT
    `Client ID`,
    Name,
    Nationality,
    `Estimated Income`,
    `Bank Deposits`
FROM Banking
ORDER BY `Bank Deposits` DESC
LIMIT 10;

## ------ HELPS TO ATLER TABLE NAME TO CORRECT TABLE NAME ------ ##
ALTER TABLE Banking
CHANGE COLUMN `ï»¿Client ID` `Client ID` TEXT;
DESC BANKING;

## -------- TOP CUSTOMERS BY BANK LOANS -------- ##



































# SQL Analysis – UK Credit Risk Case Study
---
[SQL files and Images](https://drive.google.com/drive/folders/1PAmnpUVuuqLOAD44jip1QN2hv7wDfRby?usp=drive_link)
# Credit Risk Case Study

## UK Retail Portfolio – Nevolut Bank

### 📌 Project Overview

This case study analyses **credit default behaviour** within the UK retail lending portfolio of **Nevolut Bank**, using **SQL-driven analysis** to identify:

* Who is defaulting
* Where credit risk is concentrated
* Why existing underwriting controls may be insufficient

The objective is to translate loan-level data into **actionable credit risk insights** that support stronger underwriting decisions and portfolio risk management.

---

## 🧠 Executive Summary

The UK retail loan portfolio consists of **9,618 clients**, of which **1,703 have defaulted**, resulting in an **overall default rate of 17.71%**.

The analysis demonstrates that defaults are **not randomly distributed** across the portfolio. Instead, they are **highly concentrated among younger borrowers and full-time employed clients**, challenging the assumption that employment stability alone is a reliable proxy for lower credit risk.

These findings point to **structural weaknesses in affordability assessment and behavioural risk modelling**, rather than deficiencies in employment participation.

This case study provides a foundation for **data-driven refinement of underwriting rules, customer segmentation, and credit risk controls**.

---

## 🎯 Business Problem

Despite a diversified customer base and strong employment participation, the UK retail loan portfolio exhibits a **material default rate approaching 18%**, posing significant risk to:

* Portfolio profitability
* Capital adequacy
* Long-term customer value
* Regulatory and compliance scrutiny

Senior management requires clear, evidence-based answers to the following:

* Which **client segments** are driving defaults
* Whether **employment status** meaningfully reduces credit risk
* How **age demographics** influence repayment behaviour

---
## 1. Data Inspection

```sql
SELECT *
FROM credit_risk_data;
```

**Purpose**
Initial inspection to understand schema, data types, and column naming issues.

---

## 2. Column Standardisation (Data Cleaning)

> Objective: Improve readability, enforce naming consistency, and remove encoding artefacts.

```sql
ALTER TABLE credit_risk_data
RENAME COLUMN ï»¿client_ID TO Client_ID;

ALTER TABLE credit_risk_data
RENAME COLUMN person_age TO Client_Age;

ALTER TABLE credit_risk_data
RENAME COLUMN person_income TO Client_Income;

ALTER TABLE credit_risk_data
RENAME COLUMN person_home_ownership TO Residential_Status;

ALTER TABLE credit_risk_data
RENAME COLUMN person_emp_length TO Employment_Length;

ALTER TABLE credit_risk_data
RENAME COLUMN loan_amnt TO Loan_Amount;

ALTER TABLE credit_risk_data
RENAME COLUMN loan_int_rate TO Interest_Rate;

ALTER TABLE credit_risk_data
RENAME COLUMN cb_person_default_on_file TO Default_Flag;

ALTER TABLE credit_risk_data
RENAME COLUMN cb_person_cred_hist_length TO Credit_History;
```

**Why this matters**

* Removes BOM / encoding corruption
* Aligns column names with analytics and BI standards
* Improves maintainability and downstream dashboard usage

---

## 3. Duplicate Record Validation

> Assumption: A client should not appear multiple times with the same interest rate.

```sql
SELECT
    Client_ID,
    Interest_Rate,
    COUNT(*) AS duplicate_count
FROM credit_risk_data
GROUP BY Client_ID, Interest_Rate
HAVING COUNT(*) > 1;
```

**Result**

* No duplicate records found
* Confirms dataset integrity for aggregation and rate calculations

---

## 4. UK Portfolio Scope Filter

All subsequent analysis is **strictly scoped to the UK branch**.

---

## 5. Defaulted vs Non-Defaulted Clients (UK)

```sql
SELECT
    SUM(CASE WHEN Default_Flag = 'Y' THEN 1 ELSE 0 END) AS Defaulted_Clients,
    SUM(CASE WHEN Default_Flag = 'N' THEN 1 ELSE 0 END) AS Non_Defaulted_Clients,
    COUNT(*) AS Total_UK_Clients
FROM credit_risk_data
WHERE country = 'UK';
```

**Business Value**

* Establishes portfolio composition
* Confirms scale of default exposure in the UK market

---

## 6. Default Rate Calculation (UK)

```sql
SELECT
    COUNT(CASE WHEN Default_Flag = 'Y' THEN 1 END) AS Defaulted_Clients,
    COUNT(*) AS Total_Clients,
    ROUND(
        COUNT(CASE WHEN Default_Flag = 'Y' THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS Default_Rate_Percentage
FROM credit_risk_data
WHERE country = 'UK';
```

**Insight**

* UK default rate calculated at **17.71%**
* Indicates elevated portfolio risk requiring intervention

---

## 7. Client Distribution by Employment Status (UK)

```sql
SELECT
    Employment_Type,
    COUNT(Client_ID) AS Total_Clients
FROM credit_risk_data
WHERE country = 'UK'
GROUP BY Employment_Type
ORDER BY Total_Clients DESC;
```

**Purpose**

* Understand exposure concentration by employment category
* Establish baseline before analysing defaults

---

## 8. Defaulters by Employment Status (UK)

```sql
SELECT
    Employment_Type,
    COUNT(Client_ID) AS Defaulting_Clients
FROM credit_risk_data
WHERE Default_Flag = 'Y'
  AND country = 'UK'
GROUP BY Employment_Type
ORDER BY Defaulting_Clients DESC;
```

**Key Finding**

* Full-time employment accounts for the **highest absolute number of defaulters**
* Employment stability alone does not eliminate credit risk

---

## 9. Client Segmentation by Age Group (UK)

```sql
SELECT
    CASE
        WHEN Client_Age BETWEEN 18 AND 29 THEN '18–29'
        WHEN Client_Age BETWEEN 30 AND 39 THEN '30–39'
        WHEN Client_Age BETWEEN 40 AND 49 THEN '40–49'
        WHEN Client_Age BETWEEN 50 AND 59 THEN '50–59'
        WHEN Client_Age >= 60 THEN '60+'
        ELSE 'Out of Range'
    END AS Age_Group,
    COUNT(Client_ID) AS Total_Clients
FROM credit_risk_data
WHERE country = 'UK'
GROUP BY Age_Group
ORDER BY Total_Clients DESC;
```

**Why this matters**

* Identifies demographic concentration
* Forms the basis for lifecycle-based risk assessment

---

## 10. Defaulters by Age Group (UK)

```sql
SELECT
    CASE
        WHEN Client_Age BETWEEN 18 AND 29 THEN '18–29'
        WHEN Client_Age BETWEEN 30 AND 39 THEN '30–39'
        WHEN Client_Age BETWEEN 40 AND 49 THEN '40–49'
        WHEN Client_Age BETWEEN 50 AND 59 THEN '50–59'
        WHEN Client_Age >= 60 THEN '60+'
        ELSE 'Out of Range'
    END AS Age_Group,
    COUNT(Client_ID) AS Defaulting_Clients
FROM credit_risk_data
WHERE Default_Flag = 'Y'
  AND country = 'UK'
GROUP BY Age_Group
ORDER BY Defaulting_Clients DESC;
```

**Critical Insight**

* Defaults are **heavily concentrated in the 18–29 age band**
* Default frequency declines sharply with age
* Indicates behavioural and maturity-driven risk rather than income alone

---

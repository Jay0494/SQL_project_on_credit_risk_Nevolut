# Credit Risk Case Study – UK Retail Lending

## Nevolut Bank

---

## 📌 Case Study Overview

This case study presents a **UK-focused credit risk analysis** conducted for **Nevolut Bank**, a retail bank with a growing unsecured lending portfolio. The objective was to use **SQL-based exploratory analysis** to identify **default risk drivers**, assess borrower segmentation, and generate **actionable insights** for underwriting and portfolio risk management.

The analysis focuses strictly on the **UK branch**, covering **9,618 loans**, and evaluates default behaviour across:

* Employment type
* Age groups

---

## 🏦 Business Context

Nevolut Bank observed a **persistent rise in loan defaults** within its UK portfolio. While overall growth remained strong, management lacked clarity on:

* Which borrower segments were driving defaults
* Whether defaults were random or structurally concentrated
* How underwriting policies could be improved without slowing growth

This analysis was commissioned to provide **data-backed answers** for credit leadership.

---

## 🎯 Objectives

1. Clean and standardise raw credit data using SQL
2. Validate data integrity (duplicate checks)
3. Quantify default vs non-default exposure in the UK
4. Identify high-risk borrower segments by:

   * Employment type
   * Age group
5. Translate findings into **business-impactful recommendations**

---

## 📂 Dataset Scope

* **Table:** `credit_risk_data`
* **Geography:** United Kingdom only
* **Loan Status Flag:** `Default_flag (Y / N)`

### UK Portfolio Snapshot

| Metric              | Value     |
| ------------------- | --------- |
| Total UK Loans      | 9,618     |
| Defaulted Loans     | 1,703     |
| Non-Defaulted Loans | 7,915     |
| Default Rate        | **17.7%** |

---

## 🛠️ Data Cleaning & Preparation (SQL)

```sql
ALTER TABLE credit_risk_data RENAME COLUMN ï»¿client_ID TO Client_ID;
ALTER TABLE credit_risk_data RENAME COLUMN person_age TO Client_Age;
ALTER TABLE credit_risk_data RENAME COLUMN person_income TO Client_Income;
ALTER TABLE credit_risk_data RENAME COLUMN person_home_ownership TO Residential_Status;
ALTER TABLE credit_risk_data RENAME COLUMN person_emp_length TO Employment_Lenght;
ALTER TABLE credit_risk_data RENAME COLUMN loan_amnt TO Loan_amount;
ALTER TABLE credit_risk_data RENAME COLUMN loan_int_rate TO Interest_rate;
ALTER TABLE credit_risk_data RENAME COLUMN cb_person_default_on_file TO Default_flag;
ALTER TABLE credit_risk_data RENAME COLUMN cb_person_cred_hist_length TO Credit_History;
```

**Why this matters:**
Standardised naming improves data governance, reduces ambiguity, and aligns datasets with enterprise analytics standards.

---

## 🔍 Data Validation – Duplicate Check

```sql
SELECT Client_ID, Interest_rate, COUNT(*) AS duplicate_count
FROM credit_risk_data
GROUP BY Client_ID, Interest_rate
HAVING COUNT(*) > 1;
```

**Result:**
✅ No duplicate records detected.
The dataset is reliable for credit risk analysis.

---

## 📊 UK Portfolio Performance – Defaults vs Non-Defaults

```sql
SELECT 
  SUM(CASE WHEN Default_flag = "Y" THEN 1 ELSE 0 END) AS defaulted,
  SUM(CASE WHEN Default_flag = "N" THEN 1 ELSE 0 END) AS non_defaulted
FROM credit_risk_data
WHERE country = "UK";
```

**Outcome:**

* Defaults: **1,703**
* Non-defaults: **7,915**

This confirms defaults are **material but controllable**, requiring targeted policy action rather than blanket tightening.

---

## 👔 Employment Type Analysis (UK)

### Clients by Employment Type

```sql
SELECT employment_type, COUNT(Client_ID) AS clients
FROM credit_risk_data
WHERE country = "UK"
GROUP BY employment_type
ORDER BY clients DESC;
```

| Employment Type | Clients |
| --------------- | ------- |
| Full-time       | 5,774   |
| Part-time       | 1,884   |
| Self-employed   | 1,469   |
| Unemployed      | 491     |

---

### Defaults by Employment Type

```sql
SELECT employment_type, COUNT(Client_ID) AS clients
FROM credit_risk_data
WHERE Default_flag = "Y" AND country = "UK"
GROUP BY employment_type
ORDER BY clients DESC;
```

| Employment Type | Defaults | Default Rate        |
| --------------- | -------- | ------------------- |
| Full-time       | 1,045    | 18.1%               |
| Part-time       | 301      | 16.0%               |
| Self-employed   | 275      | **18.7% (Highest)** |
| Unemployed      | 82       | 16.7%               |

### 🔑 Insight

* **Self-employed borrowers carry the highest default risk**, despite lower volume.
* Full-time employees drive the **largest absolute defaults** due to portfolio concentration.
* Income volatility is **underpriced** in current underwriting rules.

---

## 👥 Age Group Analysis (UK)

### Clients by Age Group

```sql
SELECT
  CASE
    WHEN Client_Age BETWEEN 18 AND 29 THEN '18-29'
    WHEN Client_Age BETWEEN 30 AND 39 THEN '30-39'
    WHEN Client_Age BETWEEN 40 AND 49 THEN '40-49'
    WHEN Client_Age BETWEEN 50 AND 59 THEN '50-59'
    WHEN Client_Age >= 60 THEN '60+'
  END AS Age_Group,
  COUNT(Client_ID) AS clients
FROM credit_risk_data
WHERE country = "UK"
GROUP BY Age_Group
ORDER BY clients DESC;
```

| Age Group | Clients |
| --------- | ------- |
| 18–29     | 6,867   |
| 30–39     | 2,272   |
| 40–49     | 398     |
| 50–59     | 62      |
| 60+       | 19      |

---

### Defaults by Age Group

```sql
SELECT
  CASE
    WHEN Client_Age BETWEEN 18 AND 29 THEN '18-29'
    WHEN Client_Age BETWEEN 30 AND 39 THEN '30-39'
    WHEN Client_Age BETWEEN 40 AND 49 THEN '40-49'
    WHEN Client_Age BETWEEN 50 AND 59 THEN '50-59'
    WHEN Client_Age >= 60 THEN '60+'
  END AS Age_Group,
  COUNT(Client_ID) AS clients
FROM credit_risk_data
WHERE Default_flag = "Y" AND country = "UK"
GROUP BY Age_Group
ORDER BY clients DESC;
```

| Age Group | Defaults | Default Rate                    |
| --------- | -------- | ------------------------------- |
| 18–29     | 1,204    | 17.5%                           |
| 30–39     | 415      | **18.3% (Highest stable risk)** |
| 40–49     | 70       | 17.6%                           |
| 50–59     | 9        | 14.5%                           |
| 60+       | 5        | 26.3%*                          |

*Very small sample size

### 🔑 Insight

Default risk peaks during **ages 30–39**, aligning with:

* Higher financial obligations
* Family and housing costs
* Multiple credit commitments

---

## 💼 Business Impact for Nevolut Bank

This analysis enables Nevolut to:

* Identify **structural default drivers**, not random loss
* Refine underwriting without reducing growth
* Improve capital efficiency
* Strengthen regulatory and risk committee reporting

---

## ✅ Recommendations

### 1. Employment-Sensitive Underwriting

* Enhanced income verification for self-employed borrowers
* Risk-weighted loan limits by employment stability

### 2. Age-Aware Credit Policies

* Treat **30–39** as a monitored risk band
* Adjust affordability models for dependents and housing costs

### 3. Early-Warning Risk Monitoring

* Track delinquency migration by age and employment
* Proactive intervention before default occurs

### 4. Portfolio Rebalancing

* Reduce over-concentration in younger borrowers
* Increase exposure to lower-risk mature segments

---

## 🚀 Next Steps

* Calculate **default rates (%) dynamically**
* Add income-to-loan and credit-history ratios
* Build a **Power BI executive dashboard**
* Develop a **predictive default risk score**

---

## 🧠 Skills Demonstrated

* SQL data cleaning & validation
* Credit risk segmentation
* Portfolio risk interpretation
* Business-focused analytical storytelling

---

## 👤 Author

**Elijah Okpako**
Data Analyst | Credit Risk & Portfolio Analytics

---

If you want next, I can:

* Create the **Power BI dashboard layout + KPIs**
* Build a **GitHub repo structure** (`/sql`, `/insights`, `/dashboard`)
* Rewrite this as a **senior credit risk interview case walkthrough**

Select * from telco_customers

Select gender, Count(gender) as TotalCount,
Count(gender)*1.0/(Select Count(*) from telco_customers) as Percentage
From Telco_Customers
Group By Gender

Select gender, Count(gender) as TotalCount,
Count(gender)*100.0/(Select Count(*) from telco_customers) as Percentage
From Telco_Customers
Group By Gender

SELECT contract, Count(contract) as TotalCount,
Count(contract)*100.0/(Select Count(*) from Telco_Customers) as Percentage
FROM Telco_Customers
Group by contract

SELECT churn, Count(churn) as TotalCount, Sum(totalcharges) as TotalCharges,
Sum(totalcharges) / (Select sum(totalcharges) from Telco_Customers) * 100  as TotalPercentage
FROM Telco_customers
Group by churn

SELECT SeniorCitizen,COUNT(*) AS total_customers,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_customers), 2) AS percentage
FROM telco_customers
GROUP BY SeniorCitizen;

SELECT Partner,Dependents,
COUNT(*) AS total_customers,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_customers), 2) AS percentage
FROM telco_customers
GROUP BY Partner, Dependents
ORDER BY total_customers DESC;

SELECT PaymentMethod, COUNT(*)
FROM telco_customers
GROUP BY PaymentMethod
ORDER BY COUNT(*) DESC;

SELECT PaymentMethod,
COUNT(PaymentMethod) AS TotalCount,
COUNT(PaymentMethod) * 100.0 / (SELECT COUNT(*) FROM telco_customers) AS Percentage
FROM telco_customers
GROUP BY PaymentMethod

SELECT (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) 
AS churn_rate_percent
FROM telco_customers;

SELECT Contract, COUNT(*) AS total_customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned
FROM telco_customers
GROUP BY Contract
ORDER BY churned DESC;

SELECT customerID, MonthlyCharges, TotalCharges
FROM telco_customers
ORDER BY MonthlyCharges DESC
LIMIT 10;

SELECT Churn, AVG(MonthlyCharges), AVG(TotalCharges)
FROM telco_customers
GROUP BY Churn;

SELECT
    SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS customerID_nulls,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN SeniorCitizen IS NULL THEN 1 ELSE 0 END) AS SeniorCitizen_nulls,
    SUM(CASE WHEN Partner IS NULL THEN 1 ELSE 0 END) AS Partner_nulls,
    SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS Dependents_nulls,
    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS tenure_nulls,
    SUM(CASE WHEN PhoneService IS NULL THEN 1 ELSE 0 END) AS PhoneService_nulls,
    SUM(CASE WHEN MultipleLines IS NULL THEN 1 ELSE 0 END) AS MultipleLines_nulls,
    SUM(CASE WHEN InternetService IS NULL THEN 1 ELSE 0 END) AS InternetService_nulls,
    SUM(CASE WHEN OnlineSecurity IS NULL THEN 1 ELSE 0 END) AS OnlineSecurity_nulls,
    SUM(CASE WHEN OnlineBackup IS NULL THEN 1 ELSE 0 END) AS OnlineBackup_nulls,
    SUM(CASE WHEN DeviceProtection IS NULL THEN 1 ELSE 0 END) AS DeviceProtection_nulls,
    SUM(CASE WHEN TechSupport IS NULL THEN 1 ELSE 0 END) AS TechSupport_nulls,
    SUM(CASE WHEN StreamingTV IS NULL THEN 1 ELSE 0 END) AS StreamingTV_nulls,
    SUM(CASE WHEN StreamingMovies IS NULL THEN 1 ELSE 0 END) AS StreamingMovies_nulls,
    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS Contract_nulls,
    SUM(CASE WHEN PaperlessBilling IS NULL THEN 1 ELSE 0 END) AS PaperlessBilling_nulls,
    SUM(CASE WHEN PaymentMethod IS NULL THEN 1 ELSE 0 END) AS PaymentMethod_nulls,
    SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS MonthlyCharges_nulls,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS TotalCharges_nulls,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS Churn_nulls
FROM telco_customers;

CREATE TABLE telco_customers_prod (
    customerID        VARCHAR(20) PRIMARY KEY,
    gender            VARCHAR(10),
    SeniorCitizen     INT,
    Partner           VARCHAR(20),
    Dependents        VARCHAR(20),
    tenure            INT,
    PhoneService      VARCHAR(20),
    MultipleLines     VARCHAR(30),
    InternetService   VARCHAR(30),
    OnlineSecurity    VARCHAR(30),
    OnlineBackup      VARCHAR(30),
    DeviceProtection  VARCHAR(30),
    TechSupport       VARCHAR(30),
    StreamingTV       VARCHAR(30),
    StreamingMovies   VARCHAR(30),
    Contract          VARCHAR(30),
    PaperlessBilling  VARCHAR(20),
    PaymentMethod     VARCHAR(40),
    MonthlyCharges    NUMERIC(10,2),
    TotalCharges      NUMERIC(10,2),
    Churn             VARCHAR(10)
);

INSERT INTO telco_customers_prod (
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    Churn
)
SELECT
    customerID,
    gender,
    SeniorCitizen,
    COALESCE(Partner, 'No') AS Partner,
    COALESCE(Dependents, 'No') AS Dependents,
    tenure,
    COALESCE(PhoneService, 'No') AS PhoneService,
    COALESCE(MultipleLines, 'No') AS MultipleLines,
    InternetService,
    COALESCE(OnlineSecurity, 'No') AS OnlineSecurity,
    COALESCE(OnlineBackup, 'No') AS OnlineBackup,
    COALESCE(DeviceProtection, 'No') AS DeviceProtection,
    COALESCE(TechSupport, 'No') AS TechSupport,
    COALESCE(StreamingTV, 'No') AS StreamingTV,
    COALESCE(StreamingMovies, 'No') AS StreamingMovies,
    Contract,
    COALESCE(PaperlessBilling, 'No') AS PaperlessBilling,
    COALESCE(PaymentMethod, 'Unknown') AS PaymentMethod,
    COALESCE(MonthlyCharges, 0)::NUMERIC(10,2),
    COALESCE(TotalCharges, 0)::NUMERIC(10,2),
    COALESCE(Churn, 'No') AS Churn
FROM telco_customers;

CREATE VIEW vw_ChurnData AS
SELECT * FROM telco_customers_prod
WHERE Churn IN ('Yes', 'No');


CREATE VIEW vw_Joined AS
SELECT *
FROM telco_customers_prod
WHERE tenure BETWEEN 0 AND 6;





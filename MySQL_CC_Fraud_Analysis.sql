
-- SCHEMA AND TABLES
CREATE SCHEMA IF NOT EXISTS finance;
USE finance;

CREATE TABLE cc_data (
    `index` INT,
    trans_date_trans_time TEXT,
    cc_num BIGINT,
    merchant TEXT,
    category TEXT,
    amt FLOAT,
    first TEXT,
    last TEXT,
    gender CHAR(1),
    street TEXT,
    city TEXT,
    state TEXT,
    zip TEXT,
    lat FLOAT,
    `long` FLOAT,
    city_pop INT,
    job TEXT,
    dob TEXT,
    trans_num TEXT,
    unix_time BIGINT,
    merch_lat FLOAT,
    merch_long FLOAT,
    is_fraud INT
);

CREATE TABLE location_data (
    cc_num BIGINT,
    lat FLOAT,
    `long` FLOAT
);

-- SQL EXPLORATION & AGGREGATION TASKS

-- Total transactions
SELECT COUNT(*) AS total_transactions FROM cc_data;

-- Top 10 merchants
SELECT merchant, COUNT(*) AS transaction_count FROM cc_data
GROUP BY merchant ORDER BY transaction_count DESC LIMIT 10;

-- Average amount per category
SELECT category, AVG(amt) AS average_amount FROM cc_data
GROUP BY category ORDER BY average_amount DESC;

-- Fraud statistics
SELECT 
    COUNT(*) FILTER (WHERE is_fraud = 1) AS fraud_transactions,
    COUNT(*) AS total_transactions,
    ROUND(100.0 * COUNT(*) FILTER (WHERE is_fraud = 1) / COUNT(*), 2) AS fraud_percentage
FROM cc_data;

-- Join with location data
SELECT c.trans_num, c.cc_num, l.lat, l.long
FROM cc_data c JOIN location_data l ON c.cc_num = l.cc_num;

-- City with highest population
SELECT city, MAX(city_pop) AS max_population
FROM cc_data GROUP BY city ORDER BY max_population DESC LIMIT 1;

-- Earliest and latest transaction dates
SELECT MIN(trans_date_trans_time) AS earliest_transaction, MAX(trans_date_trans_time) AS latest_transaction
FROM cc_data;

-- Total amount spent
SELECT SUM(amt) AS total_spent FROM cc_data;

-- Transaction count per category
SELECT category, COUNT(*) AS transaction_count FROM cc_data
GROUP BY category ORDER BY transaction_count DESC;

-- Average amount by gender
SELECT gender, AVG(amt) AS average_amt FROM cc_data GROUP BY gender;

-- Day with highest avg transaction
SELECT 
    DAYNAME(FROM_UNIXTIME(unix_time)) AS day_of_week,
    AVG(amt) AS average_amt
FROM cc_data
GROUP BY day_of_week
ORDER BY average_amt DESC
LIMIT 1;

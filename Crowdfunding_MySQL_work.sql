
# CREATE THE TABLE FROM CREATORS DATASET
CREATE TABLE creators (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
# SHOWS THE SECURE FILE PRIVE
SHOW VARIABLES LIKE 'secure_file_priv';

# TO IMPORT THE DATA INTO CREATORS TABLE
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CF_creator_clean.csv'
INTO TABLE creators
FIELDS TERMINATED BY  ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS 
(id, name, @dumy);

SELECT * FROM creators ;

# CREATE THE TABLE FOR CATEGORY DATASET
CREATE TABLE category (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    parent_id INT,
    position INT
);

# IMPORT THE DATA INTO THE CATEGORY TABLE 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CF_category.csv'
INTO TABLE category
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id, name, parent_id, position);

SELECT * FROM category;



# TO CREATE THE TABLE FOR LOCATION DATASET
CREATE TABLE location (
    id INT PRIMARY KEY,
    displayable_name VARCHAR(255),
    type VARCHAR(50),
    name VARCHAR(255),
    state VARCHAR(50),
    short_name VARCHAR(255),
    is_root VARCHAR(50),
    country VARCHAR(50)
);


# IMPORT THE DATA INTO THE LOCATION TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CF_location.csv"
INTO TABLE location
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id, displayable_name, type, name, state, short_name, is_root, country);

SELECT * FROM location;



# CREATING THE DATA FOR CALENDER TABLE
CREATE TABLE Calender_data (
    Date DATETIME,
    Year INT,
    Month_no TINYINT,
    Month_name VARCHAR(20),
    Quarter CHAR(2),
    Month_year CHAR(20),
    WeekDay_No TINYINT,
    WeekDay_Name VARCHAR(20),
    Financial_Month TINYINT,
    Financial_Quarter CHAR(3)
);

ALTER TABLE calender_data MODIFY Month_year VARCHAR(20) ;
ALTER TABLE calender_data MODIFY Financial_Quarter CHAR(10);

SELECT 
    *
FROM
    calender_data;

# IMPORTING THE DATA INTO THE CALENDER TABLE
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Calender_data.csv'
INTO TABLE calender_data
FIELDS TERMINATED BY','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@rawDate, Year, Month_no, Month_name, Quarter, Month_year, WeekDay_No, WeekDay_Name, @raw_FinancialMonth, Financial_Quarter)
SET date = STR_TO_DATE(@rawdate, '%d-%m-%Y'),
financial_month = CAST(SUBSTRING(@raw_finmonth, 3) AS UNSIGNED);



# CREATING THE DATA TABLE FOR MAIN FILE
CREATE TABLE cf_project (
    id INT,
    state VARCHAR(50),
    name VARCHAR(255),
    country VARCHAR(50),
    creator_id INT,
    location_id INT,
    category_id INT,
    goal DECIMAL(15,2),
    pledged DECIMAL(15,2),
    currency VARCHAR(10),
    usd_pledged DECIMAL(15,2),
    static_usd_rate DECIMAL(10,4),
    backers_count INT,
    created_at2 DATE,
    Deadline2 DATE,
    Updated_at2 DATE,
    state_changed_at3 DATE,
    successful_at4 DATE,
    launched_at5 DATE
);

ALTER TABLE cf_project MODIFY id BIGINT;

# DATA INSERTED THROGH THE PYTHON SCRIPT IN THE MAIN TEBALE

DROP TABLE IF EXISTS cf_data;

# NUMBER OF PROJECTS BASED ON THE OUTCOMES 
SELECT state, COUNT(*) AS total_projects
FROM cf_project
GROUP BY state;

# RETURN ALL ROWS IN THE DATASET
SELECT * FROM cf_project;

# COUNT THE NUMBER OF ROWS IN THE DATASET
SELECT count(*) FROM cf_project;

# SCHEMA OF THE TABLE 
DESCRIBE cf_project;

# TOTAL NUMBER OF BACKERS COUNT
SELECT COUNT(backers_count)
FROM cf_project;

# LIST OF THE OUTCOMES OF THE PROJECTS
SELECT DISTINCT state FROM cf_project;


# MIN AND MAX DATE 
SELECT MIN(created_at2), MAX(created_at2) FROM cf_project;

# MAX AND MIN COUNT OF BACKERS FOR THE SINGLE PROJECT
SELECT MIN(backers_count) AS min_backers, MAX(backers_count) AS max_backers
FROM cf_project;

# NUMBER OF PROJECTS OF 2017
SELECT COUNT(*) AS total_projects
FROM cf_project
WHERE YEAR(created_at2) = 2017;



#QUE 4
# CONVERSION GOAL AMOUNT INTO GOAL USD
SELECT goal,static_usd_rate,
    ROUND(goal * static_usd_rate, 2) AS goal_usd
FROM cf_project;

# QUE 5
# NUMBER PROJECTS BASED ON OUTCOMES
SELECT 
    state AS state_clean,
    COUNT(*) AS Projects
FROM cf_project
GROUP BY state
ORDER BY Projects DESC;

# NUMBER OF PROJECTS BASED ON LOCATIONS
SELECT 
	l.type AS location_name,
    COUNT(p.id) AS total_projects
FROM cf_project p
LEFT JOIN location l
    ON p.location_id = l.id
GROUP BY type
ORDER BY total_projects DESC;

# NUMBER OF PROJECTS BASED CATEGORIES
SELECT 
    c.name AS Category,
    COUNT(p.id) AS Total_projects
FROM cf_project p
LEFT JOIN category c
    ON p.category_id = c.id
GROUP BY c.name
ORDER BY total_projects DESC;

# NUMBER OF PROJECTS ON THE TIMELINE
SELECT 
    YEAR(created_at2) AS project_year,
    QUARTER(created_at2) AS project_quarter,
    MONTHNAME(created_at2) AS project_month_name,
    COUNT(*) AS total_projects
FROM cf_project
GROUP BY project_year, project_quarter, project_month_name
ORDER BY project_year, project_quarter;

# YEAR WISE NUMBER OF PROJECTS BASED ON OUTCOMES
SELECT 
    YEAR(created_at2) AS project_year,
    LOWER(TRIM(state)) AS state,
    COUNT(*) AS total_projects
FROM cf_project
GROUP BY project_year, state
ORDER BY project_year, state;


#QUE 6
# TOTAL AMOUNT RAISED BY SUCCESSFUL PROJECTS
SELECT 
    ROUND(SUM(usd_pledged) / 1000000,2) AS Total_amount_million
FROM cf_project
WHERE state LIKE  '%successful%';

# TOTAL NUMBERS OF BACKER FOR SUCCESSFUL PROJECTS
SELECT 
    ROUND(SUM(backers_count) / 1000000, 2) AS Total_backers_millions
FROM cf_project
WHERE state like '%successful%';

# AVG DURATION DAYS FOR SUCCESFUL PROJECTS
SELECT 
    ROUND(AVG(DATEDIFF(deadline2, launched_at5)), 2) AS avg_days
FROM cf_project
WHERE state LIKE '%success%';

# TOTAL NUMBER SUCCESSFUL PROJECTS AND AMOUNT RAISED BY THEM
SELECT 
    SUM(CAST(usd_pledged AS DECIMAL(15,2))) AS total_amount_raised,
    COUNT(*) AS total_successful_projects
FROM cf_project
WHERE statE LIKE '%success%';


# QUE 7
# TOP SUCCESSFUL PROJECTS BASED ON BACKERS COUNT
SELECT name, country, pledged, backers_count, created_at2
FROM cf_project
WHERE state LIKE '%success%'
ORDER BY backers_count DESC
LIMIT 10;

# TOP PROJECTS BASED ON THE AMOUNT RAISED
SELECT name, backers_count, usd_pledged AS amount_raised
FROM cf_project
WHERE state LIKE '%successful%'
ORDER BY usd_pledged DESC
LIMIT 10;

# TOP PROJECTS BASED ON AMOUNT RAISED AND THEIR GOAL AMOUNT
SELECT name, pledged, goal, country
FROM cf_project
ORDER BY pledged DESC
LIMIT 10;

# TOP PROJECTS BASED ON THE AMOUNT RAISED AND THEIR BACKERS COUNT
SELECT name,
    backers_count,
    ROUND(usd_pledged / 1000000, 2) AS amount_raised_M
FROM cf_project
WHERE state LIKE '%success%' 
ORDER BY usd_pledged DESC
LIMIT 10;

# PROJECT OUTCOMES WITH NUMBER OF PROJECTS AND AMOUNT RAISED
SELECT 
    state AS state_normalized,
    COUNT(*) AS total_projects,
    ROUND(SUM(usd_pledged)/1000000,2) AS Total_amount_m
FROM cf_project
GROUP BY state_normalized
ORDER BY Total_amount_m DESC;


# QUE 8
# NUMBER OF SUCCESSFUL PROJECTS WITH SUCCESS PERCENTAGE 
SELECT 
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state LIKE '%success%' THEN 1 ELSE 0 END) AS successful_projects,
    ROUND((SUM(CASE WHEN state LIKE '%success%' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2) AS successful_percentage
FROM cf_project;


# CATEGORY WISE SUCCESS PERCENATGE
SELECT
    c.name AS Category,
    COUNT(p.id) AS Total_projects,
    SUM(CASE WHEN LOWER(TRIM(p.state)) LIKE '%success%' THEN 1 ELSE 0 END) AS Successful_projects,
    ROUND((SUM(CASE WHEN LOWER(TRIM(p.state)) LIKE '%success%' THEN 1 ELSE 0 END) / COUNT(p.id)) * 100,2) AS Successful_percentage
FROM cf_project p
LEFT JOIN category c
    ON p.category_id = c.id
GROUP BY c.name
ORDER BY Successful_percentage DESC;

# SUCCESS PERCENATGE BY YEAR
SELECT 
    YEAR(created_at2) AS year,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state LIKE '%successful%' THEN 1 ELSE 0 END) AS successful_projects,
    ROUND((SUM(CASE WHEN state LIKE '%successful%' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS success_percentage
FROM cf_project
GROUP BY YEAR(created_at2)
ORDER BY year;


# SUCCESS PERCENTAGE BY QUARTER
SELECT 
    YEAR(created_at2) AS year,
    QUARTER(created_at2) AS quarter,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state LIKE '%successful%' THEN 1 ELSE 0 END) AS successful_projects,
    ROUND((SUM(CASE WHEN state LIKE '%successful%' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS success_percentage
FROM cf_project
GROUP BY YEAR(created_at2), QUARTER(created_at2)
ORDER BY year, quarter;

# SUCESS PERCENATGE BY GOAL RANGE 
SELECT 
    CASE
        WHEN goal_usd < 1000 THEN '< 1K'
        WHEN goal_usd BETWEEN 1000 AND 10000 THEN '1K - 10K'
        WHEN goal_usd BETWEEN 10001 AND 50000 THEN '10K - 50K'
        WHEN goal_usd BETWEEN 50001 AND 100000 THEN '50K - 100K'
        WHEN goal_usd BETWEEN 100001 AND 500000 THEN '100K - 500K'
        WHEN goal_usd BETWEEN 500001 AND 1000000 THEN '500K - 1M'
        ELSE '> 1M'
    END AS goal_range,

    COUNT(*) AS total_projects,

    SUM(CASE WHEN state LIKE '%successful%' THEN 1 ELSE 0 END) AS successful_projects,
	ROUND((SUM(CASE WHEN state LIKE '%successful%' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS success_percentage
FROM (
    SELECT id, state, (goal * static_usd_rate) AS goal_usd
    FROM cf_project
) t
GROUP BY goal_range
ORDER BY MIN(goal_usd);












 

























	




	


																																									



































    
    











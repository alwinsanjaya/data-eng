-- 1. gunakan accountadmin
USE ROLE accountadmin;

-- 2. set warehouse
USE WAREHOUSE compute_wh;

-- 3. create database
CREATE OR REPLACE DATABASE mixue_sample_data;

-- 4. use database 
USE DATABASE mixue_sample_data;

-- 5. create bronze, silver dan gold schema
CREATE OR REPLACE SCHEMA mixue_sample_data.bronze_data;

CREATE OR REPLACE SCHEMA mixue_sample_data.silver_data;

CREATE OR REPLACE SCHEMA mixue_sample_data.gold_data;



-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 24, 2020 at 07:32 PM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `twittersample`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_init_chart_data` (IN `keyword` VARCHAR(256), IN `starttime` DATETIME, IN `starttime_mili` BIGINT, IN `interval_minute` INT, IN `pre_minute` INT)  BEGIN
    SET @query = CONCAT(
        "(SELECT ", starttime_mili-60000*59, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 59 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*60 + pre_minute," MINUTE)) UNION ",
        "(SELECT ", starttime_mili-60000*58, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 58 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*59 + pre_minute," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*57, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 57 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*58 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*56, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 56 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*57 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*55, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 55 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*56 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*54, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 54 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*55 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*53, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 53 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*54 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*52, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 52 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*53 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*51, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 51 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*52 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*50, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 50 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*51 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*49, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 49 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*50 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*48, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 48 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*49 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*47, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 47 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*48 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*46, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 46 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*47 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*45, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 45 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*46 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*44, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 44 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*45 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*43, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 43 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*44 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*42, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 42 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*43 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*41, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 41 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*42 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*40, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 40 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*41 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*39, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 39 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*40 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*38, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 38 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*39 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*37, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 37 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*38 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*36, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 36 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*37 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*35, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 35 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*36 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*34, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 34 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*35 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*33, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 33 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*34 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*32, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 32 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*33 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*31, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 31 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*32 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*30, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 30 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*31 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*29, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 29 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*30 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*28, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 28 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*29 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*27, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 27 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*28 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*26, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 26 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*27 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*25, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 25 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*26 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*24, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 24 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*25 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*23, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 23 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*24 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*22, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 22 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*23 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*21, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 21 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*22 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*20, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 20 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*21 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*19, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 19 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*20 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*18, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 18 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*19 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*17, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 17 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*18 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*16, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 16 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*17 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*15, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 15 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*16 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*14, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 14 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*15 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*13, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 13 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*14 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*12, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 12 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*13 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*11, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 11 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*12 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*10, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 10 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*11 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*9, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 9 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*10 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*8, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 8 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*9 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*7, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 7 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*8 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*6, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 6 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*7 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*5, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 5 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*6 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*4, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 4 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*5 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*3, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 3 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*4 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*2, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 2 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*3 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*1, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 1 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*2 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*0, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 0 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*1 + pre_minute ," MINUTE))"
        
    );
    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @query1 = CONCAT("SELECT country_code, COUNT(tweet_id) cc FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime,"', INTERVAL ", pre_minute,  " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ", interval_minute + pre_minute , " MINUTE) GROUP BY country_code ORDER BY cc DESC LIMIT 0, 10");
    PREPARE stmt1 FROM @query1;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    
    SET @query2 = CONCAT("SELECT UPPER(country_code), COUNT(tweet_id) cc FROM tweets WHERE keyword='", keyword, "' AND created_at<date_sub('", starttime, "', INTERVAL ", pre_minute, " MINUTE) GROUP BY country_code ORDER BY cc");
    PREPARE stmt2 FROM @query2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_realtime_chart_data` (IN `keyword` VARCHAR(256), IN `nexttime` DATETIME, IN `interval_minute` INT, IN `pre_minute` INT)  BEGIN
    SET @query = CONCAT("(SELECT IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", nexttime, "', INTERVAL ", pre_minute, " MINUTE) AND created_at>=date_sub('", nexttime, "', INTERVAL ", interval_minute+pre_minute, " MINUTE))");    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @query1 = CONCAT("SELECT country_code, COUNT(tweet_id) cc FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", nexttime, "', INTERVAL ", pre_minute, " MINUTE) AND created_at>=date_sub('", nexttime, "', INTERVAL ", interval_minute+pre_minute, " MINUTE) GROUP BY country_code ORDER BY cc DESC LIMIT 0, 10");
    PREPARE stmt1 FROM @query1;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    
    SET @query2 = CONCAT("SELECT UPPER(country_code), COUNT(tweet_id) cc FROM tweets WHERE keyword='", keyword, "' AND created_at<date_sub('", nexttime, "', INTERVAL ", pre_minute, " MINUTE) GROUP BY country_code ORDER BY cc");
    PREPARE stmt2 FROM @query2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address_country_code`
--

CREATE TABLE `address_country_code` (
  `id` int(11) NOT NULL,
  `address_final_word` varchar(256) NOT NULL,
  `country_code` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tweets`
--

CREATE TABLE `tweets` (
  `id` int(11) NOT NULL,
  `keyword` varchar(256) NOT NULL,
  `tweet_id` varchar(256) NOT NULL,
  `username` varchar(256) NOT NULL,
  `polarity` int(11) NOT NULL,
  `subjectivity` int(11) NOT NULL,
  `location` varchar(256) NOT NULL,
  `country_code` varchar(16) NOT NULL,
  `created_at` datetime NOT NULL,
  `full_text` varchar(4096) NOT NULL,
  `cleaned_text` varchar(4096) NOT NULL,
  `hash_tag_str` varchar(256) NOT NULL,
  `favorite_count` int(11) NOT NULL,
  `retweet_count` int(11) NOT NULL,
  `lang` varchar(10) NOT NULL,
  `user_mentions_str` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `twitterdata`
--

CREATE TABLE `twitterdata` (
  `id_str` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL,
  `polarity` int(11) DEFAULT NULL,
  `subjectivity` int(11) DEFAULT NULL,
  `user_created_at` varchar(255) DEFAULT NULL,
  `user_location` varchar(255) DEFAULT NULL,
  `user_description` varchar(255) DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `latitude` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address_country_code`
--
ALTER TABLE `address_country_code`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tweets`
--
ALTER TABLE `tweets`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address_country_code`
--
ALTER TABLE `address_country_code`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tweets`
--
ALTER TABLE `tweets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

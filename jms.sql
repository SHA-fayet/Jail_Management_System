-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 19, 2025 at 05:17 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jms`
--

-- --------------------------------------------------------

--
-- Table structure for table `alerts`
--

CREATE TABLE `alerts` (
  `id` int(11) NOT NULL,
  `inmate_id` int(11) DEFAULT NULL,
  `alert_type` enum('Release','Medical','Security') NOT NULL,
  `alert_date` date DEFAULT NULL,
  `message` text DEFAULT NULL,
  `status` enum('Active','Resolved') DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alerts`
--

INSERT INTO `alerts` (`id`, `inmate_id`, `alert_type`, `alert_date`, `message`, `status`) VALUES
(1, 9, 'Release', '2025-07-19', 'Inmate Hero scheduled for release on 2025-07-22', 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `behavior_notes`
--

CREATE TABLE `behavior_notes` (
  `id` int(11) NOT NULL,
  `inmate_id` int(11) NOT NULL,
  `note` text NOT NULL,
  `points` int(11) NOT NULL,
  `recorded_by_id` int(11) NOT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `behavior_notes`
--

INSERT INTO `behavior_notes` (`id`, `inmate_id`, `note`, `points`, `recorded_by_id`, `recorded_at`) VALUES
(1, 9, 'started a fight with jamal', -15, 1, '2025-07-17 17:15:05'),
(2, 11, 'He worked so hard in LONDON', 50, 1, '2025-07-17 17:53:20'),
(3, 10, 'extra duty', 60, 1, '2025-07-17 17:54:34'),
(4, 11, 'no reason', 50, 1, '2025-07-17 20:01:55'),
(5, 18, 'Aura', 60, 1, '2025-07-19 08:29:08'),
(6, 9, 'working', 50, 1, '2025-07-19 08:34:08'),
(7, 12, 'Good Behave', 50, 1, '2025-07-19 09:10:05'),
(8, 11, 'bad', -100, 1, '2025-07-19 09:12:42'),
(9, 10, 'emnei', -100, 1, '2025-07-19 09:12:59'),
(10, 12, 'emnei', -200, 1, '2025-07-19 09:13:21'),
(11, 9, 'good', 10, 1, '2025-07-19 09:13:40'),
(12, 15, 'emneu', 56, 1, '2025-07-19 09:17:38'),
(13, 15, 'emneu', -60, 1, '2025-07-19 10:05:09'),
(14, 18, 'emnei', -100, 1, '2025-07-19 10:05:31'),
(15, 9, 'no', -60, 1, '2025-07-19 10:05:50'),
(16, 15, 'good', 60, 1, '2025-07-19 10:06:12'),
(17, 13, '100', 100, 1, '2025-07-19 10:15:42'),
(18, 17, 'sa100', 100, 1, '2025-07-19 10:17:23'),
(19, 16, 'asa', 100, 1, '2025-07-19 10:19:06'),
(20, 11, 'no', 50, 1, '2025-07-19 10:31:31'),
(21, 11, 'kk', 50, 1, '2025-07-19 10:33:29');

-- --------------------------------------------------------

--
-- Table structure for table `cells`
--

CREATE TABLE `cells` (
  `id` int(11) NOT NULL,
  `cell_number` varchar(20) NOT NULL,
  `capacity` int(11) NOT NULL,
  `current_occupancy` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cells`
--

INSERT INTO `cells` (`id`, `cell_number`, `capacity`, `current_occupancy`) VALUES
(1, 'A1', 4, 4),
(2, 'A2', 3, 2),
(3, 'B1', 2, 2),
(5, 'C1', 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `inmates`
--

CREATE TABLE `inmates` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `crime` varchar(255) NOT NULL,
  `sentence_duration` varchar(50) NOT NULL,
  `admission_date` date NOT NULL,
  `release_date` date DEFAULT NULL,
  `status` enum('Active','Released') DEFAULT 'Active',
  `cell_id` int(11) DEFAULT NULL,
  `sentence` varchar(100) DEFAULT NULL,
  `photo_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inmates`
--

INSERT INTO `inmates` (`id`, `name`, `crime`, `sentence_duration`, `admission_date`, `release_date`, `status`, `cell_id`, `sentence`, `photo_url`) VALUES
(3, 'Obaidul Kader', 'gambler', '5 years', '2025-05-03', '2025-05-14', 'Released', 1, 'imprisonment', NULL),
(4, 'Shamim Osman', 'gambler', '10 years', '2025-05-03', '2025-05-14', 'Released', 1, 'death ', NULL),
(6, 'Trump', 'Genocide', 'Death sentence', '2025-05-14', '2025-05-17', 'Released', 3, NULL, NULL),
(7, 'boma kashem', 'gambler', '5 years', '2025-05-15', '2025-05-17', 'Released', 1, 'imprisonment', NULL),
(8, 'boma kashem', 'gambler', '5 years', '2025-05-15', '2025-05-17', 'Released', 3, 'imprisonment', NULL),
(9, 'Hero', 'Drug dealing', '5 years', '2025-07-15', '2025-07-22', 'Active', 2, 'imprisonment', ''),
(10, 'jamal', 'pick pocket', '2 month', '2025-07-15', '2025-07-21', 'Active', 1, 'imprisonment', ''),
(11, 'khamba tareq', 'khamba churi', 'lifetime', '2025-07-15', '2025-07-24', 'Active', 3, 'lifetime imprisonment in London', 'https://th.bing.com/th/id/OIP.54NJyQwtz4MoCOPuILiTCwAAAA?w=224&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7'),
(12, 'Sarjis', 'Dakat', '1 year', '2025-07-18', '2026-03-18', 'Active', 3, '1 year imprisonment', 'https://www.thedailystar.net/sites/default/files/styles/big_202/public/images/2024/08/16/sarjis.jpg'),
(13, 'Sarjis', 'Money Laundering', '1 year', '2025-07-18', '2026-03-18', 'Active', 5, '1 year imprisonment', NULL),
(14, 'Sarjis', 'Money Laundering', '1 year', '2025-07-18', '2026-03-18', 'Active', 1, '1 year imprisonment', 'https://en.wikipedia.org/wiki/Sarjis_Alam#/media/File:Sarjis_Alam_at_Rajshahi_(cropped).jpg'),
(15, 'Dipu Moni', 'Killing Students', 'Null', '2025-07-18', '2025-02-07', 'Released', 2, 'death ', 'https://tse1.mm.bing.net/th/id/OIP.pHzvWS0F8VHDznxWb1yK3wHaEJ?r=0&rs=1&pid=ImgDetMain&o=7&rm=3'),
(16, 'Obaidul Kader', 'Killing Students', 'Null', '2025-07-18', '2070-03-01', 'Active', 5, 'death ', 'https://th.bing.com/th/id/OIP.daJMUtP2LTeNYJi6kUI4HAHaEh?w=243&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3'),
(17, 'Shamin Osman', 'Mass killing', 'infinity', '2025-07-18', '2085-02-05', 'Active', 2, 'death', 'https://ecdn.dhakatribune.net/contents/cache/images/1200x630x1xxxxx1x694528/uploads/dten/2013/07/Shamim-Osman.jpg?watermark=media%2F2023%2F05%2F28%2F1280px-Dhaka_Tribune_Logo.svg-1-a9e61c86dded62d74300fef48fee558f.png'),
(18, 'saka Chy', 'Killing People in 1971', 'null', '2025-07-18', '2040-02-03', 'Active', 1, 'Death', 'https://th.bing.com/th/id/OIP.P0SuvS99Y1OqtpvbSfihaAHaFj?w=221&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3'),
(19, 'polok', 'Throwing water on satellite', '30 years imprisonment', '2025-07-19', '2055-03-25', 'Active', 1, 'imprisonment', 'https://tse2.mm.bing.net/th/id/OIF.bB3sPfbNVfB3LjNa7hyp8g?r=0&rs=1&pid=ImgDetMain&o=7&rm=3'),
(20, 'P.K Haldar', 'Tax issue', '5 years', '2025-07-19', '2030-07-19', 'Active', 2, 'imprisonment', 'https://th.bing.com/th/id/OIP.PWZ5EYHi-r14E0qIXjUeGAHaEK?w=297&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `target_audience` varchar(50) NOT NULL DEFAULT 'staff',
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `message`, `created_at`, `target_audience`, `user_id`) VALUES
(1, 'Please Maintain The Security', '2025-05-14 15:31:49', 'staff', NULL),
(3, 'New visit request from \'munim\' for inmate \'hdjahd\'.', '2025-07-15 16:09:46', 'staff', NULL),
(5, 'Maintain Security', '2025-07-15 16:39:37', 'staff', NULL),
(9, 'New visit request from \'munim\' for inmate \'hdjahd\'.', '2025-07-15 17:21:04', 'staff', NULL),
(10, 'New visit request from \'munim\' for inmate \'hdjahd\'.', '2025-07-15 17:23:46', 'staff', NULL),
(13, 'Maintain the Security', '2025-07-15 19:01:55', 'staff', 1),
(14, 'Maintain them', '2025-07-15 19:04:55', 'staff', 1),
(15, 'New visit request from \'Abir\' for inmate \'Hero\'.', '2025-07-15 19:30:39', 'staff', NULL),
(16, 'New visit request from \'Abir\' for inmate \'Hero\'.', '2025-07-15 20:25:11', 'staff', NULL),
(17, 'New visit request from \'Abir\' for inmate \'Hero\'.', '2025-07-15 20:26:27', 'staff', NULL),
(26, 'New visit request from \'Tanvir \' for inmate \'Sarjis\'.', '2025-07-18 06:40:41', 'staff', NULL),
(27, 'New visit request from \'Tanvir \' for inmate \'Sarjis\'.', '2025-07-18 06:41:55', 'staff', NULL),
(28, 'New visit request from \'Tanvir \' for inmate \'Sarjis\'.', '2025-07-18 06:52:11', 'staff', NULL),
(29, 'New visit request from \'Tanvir\' for inmate \'saka Chy\'.', '2025-07-19 07:39:23', 'staff', NULL),
(30, 'New visit request from \'Selim\' for inmate \'saka Chy\'.', '2025-07-19 07:47:30', 'staff', NULL),
(31, 'New visit request from \'hasnat\' for inmate \'Sarjis\'.', '2025-07-19 08:10:21', 'staff', NULL),
(32, 'Recommendation: Inmate \'khamba tareq\' has a high score of 110. Consider punishment review.', '2025-07-19 08:34:19', 'staff', NULL),
(33, 'Release Alert: Hero is scheduled for release on 2025-07-22.', '2025-07-19 12:48:52', 'staff', NULL),
(34, 'Look at the alerts', '2025-07-19 13:20:44', 'staff', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notification_read_status`
--

CREATE TABLE `notification_read_status` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `notification_id` int(11) NOT NULL,
  `read_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_read_status`
--

INSERT INTO `notification_read_status` (`id`, `user_id`, `notification_id`, `read_at`) VALUES
(1, 2, 1, '2025-07-15 19:56:54'),
(2, 2, 3, '2025-07-15 19:56:54'),
(3, 2, 5, '2025-07-15 19:56:54'),
(4, 2, 9, '2025-07-15 19:56:54'),
(5, 2, 10, '2025-07-15 19:56:54'),
(6, 2, 13, '2025-07-15 19:56:54'),
(7, 2, 14, '2025-07-15 19:56:54'),
(8, 2, 15, '2025-07-15 19:56:54'),
(9, 1, 1, '2025-07-15 19:59:53'),
(10, 1, 3, '2025-07-15 19:59:53'),
(11, 1, 5, '2025-07-15 19:59:53'),
(12, 1, 9, '2025-07-15 19:59:53'),
(13, 1, 10, '2025-07-15 19:59:53'),
(14, 1, 13, '2025-07-15 19:59:53'),
(15, 1, 14, '2025-07-15 19:59:53'),
(16, 1, 15, '2025-07-15 19:59:53'),
(17, 1, 16, '2025-07-15 20:25:35'),
(18, 1, 17, '2025-07-15 20:27:01'),
(20, 2, 16, '2025-07-17 17:59:23'),
(21, 2, 17, '2025-07-17 17:59:23'),
(31, 1, 26, '2025-07-18 06:42:14'),
(32, 1, 27, '2025-07-18 06:42:14'),
(33, 1, 28, '2025-07-18 08:37:16'),
(34, 1, 29, '2025-07-19 07:43:26'),
(35, 1, 30, '2025-07-19 07:48:42'),
(36, 1, 31, '2025-07-19 08:28:05'),
(37, 1, 32, '2025-07-19 08:34:35'),
(38, 2, 26, '2025-07-19 10:19:25'),
(39, 2, 27, '2025-07-19 10:19:25'),
(40, 2, 28, '2025-07-19 10:19:25'),
(41, 2, 29, '2025-07-19 10:19:25'),
(42, 2, 30, '2025-07-19 10:19:25'),
(43, 2, 31, '2025-07-19 10:19:25'),
(44, 2, 32, '2025-07-19 10:19:25'),
(45, 1, 33, '2025-07-19 13:02:01'),
(46, 2, 33, '2025-07-19 13:21:01'),
(47, 2, 34, '2025-07-19 13:21:01');

-- --------------------------------------------------------

--
-- Table structure for table `punishments`
--

CREATE TABLE `punishments` (
  `id` int(11) NOT NULL,
  `inmate_id` int(11) NOT NULL,
  `punishment_detail` text NOT NULL,
  `date_given` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `punishments`
--

INSERT INTO `punishments` (`id`, `inmate_id`, `punishment_detail`, `date_given`) VALUES
(1, 6, '30 years imprisonment\r\n', '2025-05-15'),
(8, 11, '6 month in jail', '2025-07-18'),
(9, 11, '2 years imprisonment\r\n', '2025-07-19');

-- --------------------------------------------------------

--
-- Table structure for table `punishment_reduction_log`
--

CREATE TABLE `punishment_reduction_log` (
  `id` int(11) NOT NULL,
  `inmate_id` int(11) NOT NULL,
  `punishment_id` int(11) NOT NULL,
  `recommendation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(50) DEFAULT 'recommended'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `punishment_reduction_log`
--

INSERT INTO `punishment_reduction_log` (`id`, `inmate_id`, `punishment_id`, `recommendation_date`, `status`) VALUES
(3, 11, 8, '2025-07-18 06:04:58', 'recommended'),
(4, 11, 9, '2025-07-19 08:34:19', 'recommended');

-- --------------------------------------------------------

--
-- Table structure for table `transfers`
--

CREATE TABLE `transfers` (
  `id` int(11) NOT NULL,
  `inmate_id` int(11) NOT NULL,
  `from_cell` varchar(50) NOT NULL,
  `to_cell` varchar(50) NOT NULL,
  `transfer_date` date NOT NULL,
  `reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transfers`
--

INSERT INTO `transfers` (`id`, `inmate_id`, `from_cell`, `to_cell`, `transfer_date`, `reason`) VALUES
(1, 4, 'A2', 'B1', '2025-05-15', NULL),
(2, 4, 'B1', 'A1', '2025-05-15', NULL),
(3, 6, 'B1', 'A2', '2025-05-15', NULL),
(4, 6, 'A2', 'B1', '2025-05-17', NULL),
(5, 9, 'A2', 'B1', '2025-07-17', 'Limited Capacity'),
(6, 10, 'A1', 'B1', '2025-07-17', 'Behavior'),
(7, 10, 'B1', 'A1', '2025-07-17', 'dirty'),
(8, 11, 'C1', 'B1', '2025-07-17', 'Behavior'),
(9, 9, 'B1', 'A2', '2025-07-17', 'Behavior');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','jailer') NOT NULL,
  `last_notification_check` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `last_notification_check`) VALUES
(1, 'admin', 'scrypt:32768:8:1$Gro7elg82PtfM2ew$fe8d88e485c49c2db6724f8acc68e5c8a3cb1622039af614d357db256eaaefbe2bbbae209ae963f4e2a553ea25051972d9ec2eb2c1d2c899f9684c9891653240', 'admin', '2025-05-11 12:16:46'),
(2, 'jailer', 'scrypt:32768:8:1$6QOuqUaAiSGiznvj$cfdd355afc37bb67328ba0d673294ff643265f5f1d814ebe8778dc644eb710ee2d8fb5d1e4d975456f217092b967fdc3554c47b383efbb429964ef87cec9dd05', 'jailer', '2025-05-11 12:16:46');

-- --------------------------------------------------------

--
-- Table structure for table `visitors`
--

CREATE TABLE `visitors` (
  `id` int(11) NOT NULL,
  `inmate_id` int(11) NOT NULL,
  `visitor_name` varchar(100) NOT NULL,
  `relation` varchar(100) NOT NULL,
  `visit_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visitors`
--

INSERT INTO `visitors` (`id`, `inmate_id`, `visitor_name`, `relation`, `visit_date`) VALUES
(1, 3, 'She has made us fly', 'Nani', '2025-05-15'),
(2, 4, 'Ayvi', 'enemy', '2025-05-16'),
(3, 9, 'Abir', 'N/A', '2025-07-16'),
(4, 9, 'Abir', 'N/A', '2025-07-16'),
(5, 12, 'Tanvir ', 'N/A', '2025-07-18'),
(6, 12, 'Tanvir ', 'N/A', '2025-07-18'),
(7, 12, 'Tanvir ', 'N/A', '2025-07-18'),
(8, 12, 'Tanvir ', 'N/A', '2025-07-18'),
(9, 12, 'Tanvir ', 'Friends', '2025-07-18'),
(10, 18, 'Tanvir', 'Baap', '2025-07-19'),
(11, 18, 'Selim', 'Bro', '2025-07-19');

-- --------------------------------------------------------

--
-- Table structure for table `visit_requests`
--

CREATE TABLE `visit_requests` (
  `id` int(11) NOT NULL,
  `visitor_name` varchar(100) NOT NULL,
  `inmate_name` varchar(100) NOT NULL,
  `date_requested` date NOT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `tracking_id` varchar(32) DEFAULT NULL,
  `relation` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visit_requests`
--

INSERT INTO `visit_requests` (`id`, `visitor_name`, `inmate_name`, `date_requested`, `status`, `tracking_id`, `relation`) VALUES
(1, 'Munna Vai', 'Trump', '2025-05-16', 'Approved', NULL, NULL),
(2, 'Ayvi', 'Trump', '2025-05-16', 'Rejected', NULL, NULL),
(3, 'Ayvi', 'Trump', '2025-05-16', 'Approved', NULL, NULL),
(4, 'sgafayet', 'Trump', '2025-05-16', 'Rejected', NULL, NULL),
(5, 'Munna Vai', 'Trump', '2025-05-16', 'Approved', NULL, NULL),
(6, 'Kalam', 'Hero', '2025-07-17', 'Rejected', NULL, NULL),
(7, 'harun', 'hero', '2025-07-15', 'Rejected', NULL, NULL),
(8, 'Siam', 'Hero', '2025-07-16', 'Rejected', 'c2af30df7c574e6f93905a5d3c09c7de', NULL),
(9, 'shetu', 'hero', '2025-07-16', 'Rejected', 'dc4e9aed52da48e791561ddec1dec2b8', NULL),
(10, 'munim', 'hero', '2025-07-17', 'Rejected', 'abf51159c30f4a849d4facddecf197ae', NULL),
(11, 'munim', 'Hero', '2025-07-17', 'Rejected', 'f7409a53919b42ef878343a8e063ceb1', NULL),
(12, 'kuddus', 'Hero', '2025-07-16', 'Rejected', '69ac9f97f8d54845b09e33d0974ceef5', NULL),
(13, 'munim', 'Heru', '2025-07-17', 'Rejected', '9c35a55e09584710b2f6a843777eb8f8', NULL),
(14, 'munim', 'gjgj', '2025-07-17', 'Rejected', '1686b91085dc471db8896fbb1919de2d', NULL),
(15, 'munim', 'hdjahd', '2025-07-17', 'Approved', '3e75da9f8ab4426ea5af8271354834c0', NULL),
(16, 'munim', 'hdjahd', '2025-07-17', 'Rejected', '68eef5dc434c4bb184a95702d679b8d7', NULL),
(17, 'munim', 'hdjahd', '2025-07-17', 'Approved', 'e82d843a57da4f1680f9b607facc017a', NULL),
(18, 'munim', 'hdjahd', '2025-07-17', 'Approved', '5659e1975b8c4dd79c696cfceaf55b79', NULL),
(19, 'munim', 'hdjahd', '2025-07-17', 'Rejected', '44787c3a42494e3197913e5272ca1b12', NULL),
(20, 'munim', 'hdjahd', '2025-07-17', 'Approved', 'de2ac3d391bd42e2b8e9863209ee1aa0', NULL),
(21, 'munim', 'hdjahd', '2025-07-17', 'Approved', 'fc39333a900f4d7d833c54dfdfcd2557', NULL),
(22, 'munim', 'hdjahd', '2025-07-17', 'Rejected', 'f6b2058dc73242ba8e539e1b527565ee', NULL),
(23, 'munim', 'Hero', '2025-07-17', 'Approved', '07e4d30bc8eb4653be6c57506e17d13e', NULL),
(24, 'Abir', 'Hero', '2025-07-16', '', '8507970060ce4cd6800f570b16b506f0', NULL),
(25, 'Abir', 'Hero', '2025-07-16', 'Rejected', '91eb0c0ae9a5418ca6664df5926526b1', NULL),
(26, 'Abir', 'Hero', '2025-07-16', '', '05c6c814c6fd440ca05a64755e6a08b6', NULL),
(27, 'Tanvir ', 'Sarjis', '2025-07-18', '', '7a54f39807ff4104b3273b76871423d0', NULL),
(28, 'Tanvir ', 'Sarjis', '2025-07-18', 'Approved', '101e38aaa63841e6af3caad21f6969ea', 'Friends'),
(29, 'Tanvir ', 'Sarjis', '2025-07-18', 'Rejected', '4fc408d864c8457098aed9c7553de37f', 'Friends'),
(30, 'Tanvir ', 'Sarjis', '2025-07-18', '', '8927bac29fa4472e8444beb119d5b519', 'Friends'),
(31, 'Tanvir ', 'Sarjis', '2025-07-18', '', '226896b5dbba482fb686e176adf021ff', NULL),
(32, 'Tanvir ', 'Sarjis', '2025-07-18', '', '6a70163a5c654cbe8ba6d391b46acd9d', NULL),
(33, 'Tanvir ', 'Sarjis', '2025-07-18', '', '443bb987f9a1462c900e679706fa23a1', 'Friends'),
(34, 'Tanvir', 'saka Chy', '2025-07-19', '', '48c5bb2273e543ed984e985ced31d2a2', 'Baap'),
(35, 'Selim', 'saka Chy', '2025-07-19', '', 'b9840311ceb748d0b1fc968019502931', 'Bro'),
(36, 'hasnat', 'Sarjis', '2025-07-19', 'Approved', '1eb093e825c743919d9f4082fabc999a', 'bro');

-- --------------------------------------------------------

--
-- Table structure for table `work_assignments`
--

CREATE TABLE `work_assignments` (
  `id` int(11) NOT NULL,
  `inmate_id` int(11) DEFAULT NULL,
  `assignment` text DEFAULT NULL,
  `assigned_date` date DEFAULT NULL,
  `supervisor` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `completion_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `work_assignments`
--

INSERT INTO `work_assignments` (`id`, `inmate_id`, `assignment`, `assigned_date`, `supervisor`, `status`, `completion_date`) VALUES
(5, 9, 'Cleaning', '2025-07-15', 'jailer', 'Completed', '2025-07-15'),
(6, 10, 'Laundry', '2025-07-17', 'jailer', 'Completed', '2025-07-18'),
(7, 10, 'kitchen', '2025-07-17', 'jailer', 'Completed', '2025-07-17'),
(8, 11, 'cleaning', '2025-07-17', 'admin', 'Completed', '2025-07-17'),
(9, 16, 'toilet cleaning', '2025-07-19', 'jailer', 'Completed', '2025-07-19');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerts`
--
ALTER TABLE `alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inmate_id` (`inmate_id`);

--
-- Indexes for table `behavior_notes`
--
ALTER TABLE `behavior_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inmate_id` (`inmate_id`),
  ADD KEY `recorded_by_id` (`recorded_by_id`);

--
-- Indexes for table `cells`
--
ALTER TABLE `cells`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cell_number` (`cell_number`);

--
-- Indexes for table `inmates`
--
ALTER TABLE `inmates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cell_id` (`cell_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notification_read_status`
--
ALTER TABLE `notification_read_status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_notification_unique` (`user_id`,`notification_id`),
  ADD KEY `notification_id` (`notification_id`);

--
-- Indexes for table `punishments`
--
ALTER TABLE `punishments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inmate_id` (`inmate_id`);

--
-- Indexes for table `punishment_reduction_log`
--
ALTER TABLE `punishment_reduction_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inmate_id` (`inmate_id`),
  ADD KEY `punishment_id` (`punishment_id`);

--
-- Indexes for table `transfers`
--
ALTER TABLE `transfers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inmate_id` (`inmate_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `visitors`
--
ALTER TABLE `visitors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inmate_id` (`inmate_id`);

--
-- Indexes for table `visit_requests`
--
ALTER TABLE `visit_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `work_assignments`
--
ALTER TABLE `work_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inmate_id` (`inmate_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alerts`
--
ALTER TABLE `alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `behavior_notes`
--
ALTER TABLE `behavior_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `cells`
--
ALTER TABLE `cells`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inmates`
--
ALTER TABLE `inmates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `notification_read_status`
--
ALTER TABLE `notification_read_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `punishments`
--
ALTER TABLE `punishments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `punishment_reduction_log`
--
ALTER TABLE `punishment_reduction_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `transfers`
--
ALTER TABLE `transfers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `visitors`
--
ALTER TABLE `visitors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `visit_requests`
--
ALTER TABLE `visit_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `work_assignments`
--
ALTER TABLE `work_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alerts`
--
ALTER TABLE `alerts`
  ADD CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`inmate_id`) REFERENCES `inmates` (`id`);

--
-- Constraints for table `behavior_notes`
--
ALTER TABLE `behavior_notes`
  ADD CONSTRAINT `behavior_notes_ibfk_1` FOREIGN KEY (`inmate_id`) REFERENCES `inmates` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `behavior_notes_ibfk_2` FOREIGN KEY (`recorded_by_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `inmates`
--
ALTER TABLE `inmates`
  ADD CONSTRAINT `inmates_ibfk_1` FOREIGN KEY (`cell_id`) REFERENCES `cells` (`id`);

--
-- Constraints for table `notification_read_status`
--
ALTER TABLE `notification_read_status`
  ADD CONSTRAINT `notification_read_status_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notification_read_status_ibfk_2` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `punishments`
--
ALTER TABLE `punishments`
  ADD CONSTRAINT `punishments_ibfk_1` FOREIGN KEY (`inmate_id`) REFERENCES `inmates` (`id`);

--
-- Constraints for table `punishment_reduction_log`
--
ALTER TABLE `punishment_reduction_log`
  ADD CONSTRAINT `punishment_reduction_log_ibfk_1` FOREIGN KEY (`inmate_id`) REFERENCES `inmates` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `punishment_reduction_log_ibfk_2` FOREIGN KEY (`punishment_id`) REFERENCES `punishments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transfers`
--
ALTER TABLE `transfers`
  ADD CONSTRAINT `transfers_ibfk_1` FOREIGN KEY (`inmate_id`) REFERENCES `inmates` (`id`);

--
-- Constraints for table `visitors`
--
ALTER TABLE `visitors`
  ADD CONSTRAINT `visitors_ibfk_1` FOREIGN KEY (`inmate_id`) REFERENCES `inmates` (`id`);

--
-- Constraints for table `work_assignments`
--
ALTER TABLE `work_assignments`
  ADD CONSTRAINT `work_assignments_ibfk_1` FOREIGN KEY (`inmate_id`) REFERENCES `inmates` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 04, 2026 at 06:28 AM
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
-- Database: `airking`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `activity_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `activity_type` varchar(100) NOT NULL,
  `module` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `adjustments`
--

CREATE TABLE `adjustments` (
  `adjustment_id` bigint(20) UNSIGNED NOT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `adjustment_number` varchar(50) NOT NULL,
  `adjustment_date` date DEFAULT NULL,
  `adjustment_type` varchar(50) DEFAULT NULL,
  `total_variance_positive` int(11) NOT NULL DEFAULT 0,
  `total_variance_negative` int(11) NOT NULL DEFAULT 0,
  `adjusted_by` varchar(255) DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `adjustments`
--

INSERT INTO `adjustments` (`adjustment_id`, `location_id`, `created_by`, `adjustment_number`, `adjustment_date`, `adjustment_type`, `total_variance_positive`, `total_variance_negative`, `adjusted_by`, `approved_by`, `status_id`, `created_at`, `updated_at`) VALUES
(5, 1, NULL, 'ADJ-1774657637448', '2026-03-28', 'Stock Count', 0, 0, 'System Admin', NULL, NULL, '2026-03-27 17:27:17', '2026-03-27 17:27:17');

-- --------------------------------------------------------

--
-- Table structure for table `adjustment_details`
--

CREATE TABLE `adjustment_details` (
  `adjustment_detail_id` bigint(20) UNSIGNED NOT NULL,
  `adjustment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `add_quantity` int(11) NOT NULL DEFAULT 0,
  `deduct_quantity` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `adjustment_details`
--

INSERT INTO `adjustment_details` (`adjustment_detail_id`, `adjustment_id`, `product_id`, `created_at`, `updated_at`, `add_quantity`, `deduct_quantity`) VALUES
(5, 5, 32, '2026-03-27 17:27:17', '2026-03-27 17:27:17', 0, 3);

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `audit_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `record_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `table_affected` varchar(100) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_trail`
--

CREATE TABLE `audit_trail` (
  `audit_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `table_name` varchar(100) DEFAULT NULL,
  `record_id` bigint(20) UNSIGNED DEFAULT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_trail`
--

INSERT INTO `audit_trail` (`audit_id`, `user_id`, `action`, `table_name`, `record_id`, `old_values`, `new_values`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(1, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-01 15:40:13', '2026-02-01 15:40:13'),
(2, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-12 12:58:53', '2026-02-12 12:58:53'),
(3, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-13 04:10:23', '2026-02-13 04:10:23'),
(4, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-13 07:35:58', '2026-02-13 07:35:58'),
(5, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-13 10:48:03', '2026-02-13 10:48:03'),
(6, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-13 11:28:00', '2026-02-13 11:28:00'),
(7, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-13 23:56:36', '2026-02-13 23:56:36'),
(8, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 03:13:05', '2026-02-14 03:13:05'),
(9, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.31 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', '2026-02-14 03:29:27', '2026-02-14 03:29:27'),
(10, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 03:29:36', '2026-02-14 03:29:36'),
(11, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 03:47:51', '2026-02-14 03:47:51'),
(12, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 03:53:20', '2026-02-14 03:53:20'),
(13, 3, 'create', 'users', 4, NULL, '{\"first_name\":\"John\",\"last_name\":\"Baloro\",\"email\":\"johnphilipbaloro56@gmail.com\",\"username\":\"john\",\"phone\":\"09756026160\",\"role_id\":3,\"branch_id\":1,\"status_id\":1,\"password_hash\":\"$2y$12$iyaSyX\\/W0RE.9495NQKX6OKyERHQroanVVUd\\/enOzP8AwU.PlsqC.\",\"updated_at\":\"2026-02-13 19:59:02\",\"created_at\":\"2026-02-13 19:59:02\",\"user_id\":4}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 03:59:02', '2026-02-14 03:59:02'),
(14, 3, 'update', 'users', 4, '{\"user_id\":4,\"first_name\":\"John\",\"last_name\":\"Baloro\",\"username\":\"john\",\"email\":\"johnphilipbaloro56@gmail.com\",\"phone\":\"09756026160\",\"role_id\":3,\"branch_id\":1,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$iyaSyX\\/W0RE.9495NQKX6OKyERHQroanVVUd\\/enOzP8AwU.PlsqC.\",\"remember_token\":null,\"created_at\":\"2026-02-13T19:59:02.000000Z\",\"updated_at\":\"2026-02-13T19:59:02.000000Z\"}', '{\"role_id\":2,\"branch_id\":5,\"updated_at\":\"2026-02-13 19:59:34\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 03:59:34', '2026-02-14 03:59:34'),
(15, 3, 'create', 'users', 5, NULL, '{\"first_name\":\"marichu\",\"last_name\":\"contado\",\"email\":\"marichu@gmail.com\",\"username\":\"marichu\",\"phone\":\"123456789\",\"role_id\":3,\"branch_id\":1,\"status_id\":1,\"password_hash\":\"$2y$12$Cc7.a3CYtLn3sj\\/rdmGUqeW0hwuN0uy0QnmpTKoImVy4\\/qmhxGYvC\",\"updated_at\":\"2026-02-13 20:03:40\",\"created_at\":\"2026-02-13 20:03:40\",\"user_id\":5}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 04:03:40', '2026-02-14 04:03:40'),
(16, 3, 'create', 'users', 6, NULL, '{\"first_name\":\"cristian\",\"last_name\":\"castro\",\"email\":\"cristian@gmail.com\",\"username\":\"cristian\",\"phone\":\"123456\",\"role_id\":4,\"branch_id\":3,\"status_id\":1,\"password_hash\":\"$2y$12$0dqwawWPRsKDBfNv2Ew8m.QV7v1fjC1q13abYWs2uDK7x5GFN8Xwe\",\"updated_at\":\"2026-02-13 20:06:16\",\"created_at\":\"2026-02-13 20:06:16\",\"user_id\":6}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 04:06:16', '2026-02-14 04:06:16'),
(17, 3, 'create', 'users', 7, NULL, '{\"first_name\":\"silwyn\",\"last_name\":\"Ibaoc\",\"email\":\"silwyn@gmail.com\",\"username\":\"silwyn\",\"phone\":\"12345\",\"role_id\":5,\"branch_id\":7,\"status_id\":1,\"password_hash\":\"$2y$12$R3nVdwct874htHQKR9AhiOCrqvpCRZkAtxOFoSeivP7oUtGi5amVW\",\"updated_at\":\"2026-02-13 20:07:39\",\"created_at\":\"2026-02-13 20:07:39\",\"user_id\":7}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 04:07:39', '2026-02-14 04:07:39'),
(18, 3, 'create', 'branches', 8, NULL, '{\"name\":\"Bohol\",\"code\":\"boh\",\"address\":\"united village\",\"updated_at\":\"2026-02-13 20:10:17\",\"created_at\":\"2026-02-13 20:10:17\",\"id\":8}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 04:10:17', '2026-02-14 04:10:17'),
(19, 3, 'create', 'items', 1, NULL, '{\"name\":\"LG 43\",\"code\":\"1123\",\"category\":\"TELEVISION\",\"brand\":\"LG\",\"barcode\":\"32131\",\"description\":\"Televison 24 inch\",\"unit\":\"Piece\",\"reorder_level\":5,\"supplier\":\"secret\",\"status\":\"Active\",\"type\":\"Non-Serialized\",\"price\":20000,\"updated_at\":\"2026-02-13 20:38:02\",\"created_at\":\"2026-02-13 20:38:02\",\"id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 04:38:02', '2026-02-14 04:38:02'),
(20, 3, 'create', 'items', 2, NULL, '{\"name\":\"TV SAM 45\",\"code\":\"3124123\",\"category\":\"TELEVISION\",\"brand\":\"SAMSUNG\",\"barcode\":\"12345\",\"description\":\"A T.V\",\"unit\":\"Piece\",\"reorder_level\":5,\"supplier\":\"SECRET\",\"status\":\"Active\",\"type\":\"Serialized\",\"price\":15999,\"updated_at\":\"2026-02-13 20:39:57\",\"created_at\":\"2026-02-13 20:39:57\",\"id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 04:39:57', '2026-02-14 04:39:57'),
(21, 3, 'create', 'items', 3, NULL, '{\"name\":\"Aircon 14\",\"code\":\"53121\",\"category\":\"Aircon\",\"brand\":\"Suzuki\",\"barcode\":\"412455124\",\"description\":\"aircon\",\"unit\":\"Piece\",\"reorder_level\":3,\"supplier\":\"secret\",\"status\":\"Active\",\"type\":\"Serialized\",\"price\":5000,\"updated_at\":\"2026-02-13 21:00:21\",\"created_at\":\"2026-02-13 21:00:21\",\"id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 05:00:21', '2026-02-14 05:00:21'),
(22, 3, 'create', 'items', 4, NULL, '{\"name\":\"laptop\",\"code\":\"53421\",\"category\":\"Laptop\",\"brand\":\"MSI\",\"barcode\":\"12314\",\"description\":\"Laptop for student\",\"unit\":\"Piece\",\"reorder_level\":61,\"supplier\":\"secrete\",\"status\":\"Active\",\"type\":\"Serialized\",\"price\":35000,\"updated_at\":\"2026-02-13 21:31:27\",\"created_at\":\"2026-02-13 21:31:27\",\"id\":4}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 05:31:27', '2026-02-14 05:31:27'),
(23, 3, 'create', 'users', 8, NULL, '{\"first_name\":\"khen\",\"last_name\":\"adora\",\"email\":\"khen@gmail.com\",\"username\":\"khen\",\"phone\":\"143143\",\"role_id\":3,\"branch_id\":1,\"status_id\":1,\"password_hash\":\"$2y$12$nJDTUsxkGhN0GeOCt3ZFD.\\/2pVqHa46MZVfKT4qaWGLuAcsu2QrpC\",\"updated_at\":\"2026-02-13 21:37:40\",\"created_at\":\"2026-02-13 21:37:40\",\"user_id\":8}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 05:37:40', '2026-02-14 05:37:40'),
(24, 3, 'create', 'users', 9, NULL, '{\"first_name\":\"dayadaya\",\"last_name\":\"ydaddyy\",\"email\":\"dayday@gmail.com\",\"username\":\"dayadaya\",\"phone\":\"12124\",\"role_id\":3,\"branch_id\":6,\"status_id\":1,\"password_hash\":\"$2y$12$NE8NdkKZNxWT0ajYWLG9oODlXAvGJgjqeNtxvst1Lh7czP11pXlhO\",\"updated_at\":\"2026-02-13 21:44:09\",\"created_at\":\"2026-02-13 21:44:09\",\"user_id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 05:44:09', '2026-02-14 05:44:09'),
(25, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 14:59:01', '2026-02-14 14:59:01'),
(26, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 22:40:57', '2026-02-14 22:40:57'),
(27, 3, 'create', 'items', 5, NULL, '{\"name\":\"LG 69\",\"code\":\"3211\",\"category\":\"Refrigerator\",\"brand\":\"Hanabishi\",\"barcode\":\"431534\",\"description\":\"Ref na kusog\",\"unit\":\"Piece\",\"reorder_level\":33,\"supplier\":\"secret\",\"status\":\"Active\",\"type\":\"Non-Serialized\",\"price\":3000,\"updated_at\":\"2026-02-14 15:39:27\",\"created_at\":\"2026-02-14 15:39:27\",\"id\":5}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-14 23:39:27', '2026-02-14 23:39:27'),
(28, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 01:11:28', '2026-02-15 01:11:28'),
(29, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 02:53:36', '2026-02-15 02:53:36'),
(30, 3, 'update', 'branches', 2, '{\"id\":2,\"code\":\"DVO\",\"name\":\"Davao City\",\"address\":null,\"capacity\":10000,\"is_active\":true,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-13T19:57:06.000000Z\"}', '{\"is_active\":false,\"updated_at\":\"2026-02-14 21:29:17\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 05:29:17', '2026-02-15 05:29:17'),
(31, 3, 'update', 'branches', 4, '{\"id\":4,\"code\":\"BUT\",\"name\":\"Butuan\",\"address\":null,\"capacity\":4500,\"is_active\":true,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-13T19:57:06.000000Z\"}', '{\"is_active\":false,\"updated_at\":\"2026-02-14 21:30:04\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 05:30:04', '2026-02-15 05:30:04'),
(32, 3, 'update', 'branches', 6, '{\"id\":6,\"code\":\"PAG\",\"name\":\"Pagadian\",\"address\":null,\"capacity\":4000,\"is_active\":true,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-13T19:57:06.000000Z\"}', '{\"is_active\":false,\"updated_at\":\"2026-02-14 21:31:03\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 05:31:03', '2026-02-15 05:31:03'),
(33, 3, 'update', 'branches', 8, '{\"id\":8,\"code\":\"boh\",\"name\":\"Bohol\",\"address\":\"united village\",\"capacity\":null,\"is_active\":true,\"created_at\":\"2026-02-13T20:10:17.000000Z\",\"updated_at\":\"2026-02-13T20:10:17.000000Z\"}', '{\"is_active\":false,\"updated_at\":\"2026-02-14 21:33:22\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 05:33:22', '2026-02-15 05:33:22'),
(34, 3, 'update', 'branches', 7, '{\"id\":7,\"code\":\"ZAM\",\"name\":\"Zamboanga\",\"address\":null,\"capacity\":5000,\"is_active\":true,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-13T19:57:06.000000Z\"}', '{\"is_active\":false,\"updated_at\":\"2026-02-14 21:34:33\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 05:34:33', '2026-02-15 05:34:33'),
(35, 3, 'update', 'branches', 5, '{\"id\":5,\"code\":\"ILI\",\"name\":\"Iligan\",\"address\":null,\"capacity\":3000,\"is_active\":true,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-13T19:57:06.000000Z\"}', '{\"is_active\":false,\"updated_at\":\"2026-02-14 21:35:08\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 05:35:08', '2026-02-15 05:35:08'),
(36, 3, 'update', 'branches', 3, '{\"id\":3,\"code\":\"VAL\",\"name\":\"Valencia\",\"address\":null,\"capacity\":2500,\"is_active\":true,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-13T19:57:06.000000Z\"}', '{\"is_active\":false,\"updated_at\":\"2026-02-14 21:36:57\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-15 05:36:57', '2026-02-15 05:36:57'),
(37, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 08:50:05', '2026-02-16 08:50:05'),
(38, 3, 'update', 'items', 1, '{\"id\":1,\"code\":\"1123\",\"barcode\":\"32131\",\"name\":\"LG 43\",\"category\":\"TELEVISION\",\"brand\":\"LG\",\"description\":\"Televison 24 inch\",\"price\":\"20000.00\",\"unit\":\"Piece\",\"reorder_level\":5,\"supplier\":\"secret\",\"status\":\"Active\",\"type\":\"Non-Serialized\",\"created_at\":\"2026-02-13T20:38:02.000000Z\",\"updated_at\":\"2026-02-13T20:38:02.000000Z\"}', '{\"category\":\"Television\",\"status\":\"Inactive\",\"updated_at\":\"2026-02-16 01:57:43\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 09:57:43', '2026-02-16 09:57:43'),
(39, 3, 'create', 'users', 10, NULL, '{\"first_name\":\"Cyrus\",\"last_name\":\"tadoy\",\"email\":\"cyrus@gmail.com\",\"username\":\"cyrus\",\"phone\":\"0978937362\",\"role_id\":3,\"branch_id\":1,\"status_id\":1,\"password_hash\":\"$2y$12$kkYK9eByCldNvbEclhYXU.BC\\/C0L3PHL3doPNDlA9qAUS5QXdL9IW\",\"updated_at\":\"2026-02-16 02:24:18\",\"created_at\":\"2026-02-16 02:24:18\",\"user_id\":10}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 10:24:18', '2026-02-16 10:24:18'),
(40, 3, 'create', 'warehouses', 1, NULL, '{\"name\":\"Bossing Warehouse\",\"code\":\"143\",\"branch_id\":\"1\",\"type\":\"Main Warehouse\",\"location\":\"Bulua Cagayan De Oro City Philippines\",\"capacity\":\"10000\",\"contact_number\":\"0987654321\",\"manager\":\"Marichu Contado\",\"opening_date\":\"2026-02-16 00:00:00\",\"status\":\"Active\",\"updated_at\":\"2026-02-16 02:37:02\",\"created_at\":\"2026-02-16 02:37:02\",\"id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 10:37:02', '2026-02-16 10:37:02'),
(41, 3, 'create', 'warehouses', 2, NULL, '{\"name\":\"Airking Warehouse\",\"code\":\"316\",\"branch_id\":\"1\",\"type\":\"Distribution Center\",\"location\":\"Gusa Cagayan De Oro city Philippines\",\"capacity\":\"8000\",\"contact_number\":\"0984022039\",\"manager\":\"Silwyn Dayadaya\",\"opening_date\":\"2026-02-21 00:00:00\",\"status\":\"Inactive\",\"updated_at\":\"2026-02-16 02:38:42\",\"created_at\":\"2026-02-16 02:38:42\",\"id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 10:38:42', '2026-02-16 10:38:42'),
(42, 3, 'create', 'warehouses', 3, NULL, '{\"name\":\"Baloro Warehouse\",\"code\":\"2004\",\"branch_id\":\"3\",\"type\":\"Storage Warehouse\",\"location\":\"Philipines Bukidnon Valencia City Lumbo\",\"capacity\":\"5000\",\"contact_number\":\"0987360212\",\"manager\":\"John Philip Baloro\",\"opening_date\":\"2026-03-14 00:00:00\",\"status\":\"Inactive\",\"updated_at\":\"2026-02-16 02:50:53\",\"created_at\":\"2026-02-16 02:50:53\",\"id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 10:50:53', '2026-02-16 10:50:53'),
(43, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 14:08:12', '2026-02-16 14:08:12'),
(44, 3, 'create', 'users', 11, NULL, '{\"first_name\":\"Charity\",\"last_name\":\"Dayaata\",\"email\":\"chairty@gmail.com\",\"username\":\"Charity\",\"phone\":\"09843232\",\"role_id\":3,\"branch_id\":1,\"status_id\":1,\"password_hash\":\"$2y$12$fcGazu1pkWn9oMJP.pDNw.mP11vcNQHWnetzcTCs.FrTjXsSFTbx6\",\"updated_at\":\"2026-02-16 06:41:04\",\"created_at\":\"2026-02-16 06:41:04\",\"user_id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 14:41:04', '2026-02-16 14:41:04'),
(45, 3, 'create', 'items', 6, NULL, '{\"name\":\"Adidas\",\"code\":\"132123\",\"category\":\"Washing Machine\",\"brand\":\"Samsung\",\"barcode\":\"13213\",\"description\":\"automatic washing machine\",\"unit\":\"Piece\",\"reorder_level\":55,\"supplier\":\"secret\",\"status\":\"Active\",\"type\":\"Serialized\",\"price\":15000,\"updated_at\":\"2026-02-16 07:08:22\",\"created_at\":\"2026-02-16 07:08:22\",\"id\":6}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:08:22', '2026-02-16 15:08:22'),
(46, 3, 'update', 'branches', 2, '{\"id\":2,\"code\":\"DVO\",\"name\":\"Davao City\",\"address\":\"adssa\",\"capacity\":10000,\"is_active\":false,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-14T21:29:17.000000Z\"}', '{\"is_active\":true,\"updated_at\":\"2026-02-16 07:11:12\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:11:12', '2026-02-16 15:11:12'),
(47, 3, 'create', 'users', 12, NULL, '{\"first_name\":\"Hanz earl\",\"last_name\":\"Tan\",\"email\":\"Hanz@gmail.com\",\"username\":\"Hanz earl\",\"phone\":\"012490412\",\"role_id\":3,\"branch_id\":2,\"status_id\":1,\"password_hash\":\"$2y$12$DQ8fsQ40PTCw\\/aarXWOn7OzRgggzra.U\\/KyKmWAKt8exG\\/390wjgm\",\"updated_at\":\"2026-02-16 07:12:26\",\"created_at\":\"2026-02-16 07:12:26\",\"user_id\":12}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:12:26', '2026-02-16 15:12:26'),
(48, 3, 'update', 'warehouses', 2, '{\"id\":2,\"name\":\"Airking Warehouse\",\"code\":\"316\",\"branch_id\":1,\"type\":\"Distribution Center\",\"location\":\"Gusa Cagayan De Oro city Philippines\",\"capacity\":8000,\"contact_number\":\"0984022039\",\"manager\":\"Silwyn Dayadaya\",\"opening_date\":\"2026-02-21T00:00:00.000000Z\",\"status\":\"Inactive\",\"created_at\":\"2026-02-16T02:38:42.000000Z\",\"updated_at\":\"2026-02-16T02:38:42.000000Z\"}', '{\"status\":\"Active\",\"updated_at\":\"2026-02-16 07:37:26\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:37:26', '2026-02-16 15:37:26'),
(49, 3, 'update', 'warehouses', 3, '{\"id\":3,\"name\":\"Baloro Warehouse\",\"code\":\"2004\",\"branch_id\":3,\"type\":\"Storage Warehouse\",\"location\":\"Philipines Bukidnon Valencia City Lumbo\",\"capacity\":5000,\"contact_number\":\"0987360212\",\"manager\":\"John Philip Baloro\",\"opening_date\":\"2026-03-14T00:00:00.000000Z\",\"status\":\"Inactive\",\"created_at\":\"2026-02-16T02:50:53.000000Z\",\"updated_at\":\"2026-02-16T02:50:53.000000Z\"}', '{\"status\":\"Active\",\"updated_at\":\"2026-02-16 07:37:34\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:37:34', '2026-02-16 15:37:34'),
(50, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:48:40', '2026-02-16 15:48:40'),
(51, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.4.36 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', '2026-02-16 15:50:26', '2026-02-16 15:50:26'),
(52, 3, 'update', 'branches', 3, '{\"id\":3,\"code\":\"VAL\",\"name\":\"Valencia\",\"address\":\"13123\",\"capacity\":2500,\"is_active\":false,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-14T21:36:57.000000Z\"}', '{\"is_active\":true,\"updated_at\":\"2026-02-16 07:57:57\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:57:57', '2026-02-16 15:57:57'),
(53, 3, 'update', 'warehouses', 1, '{\"id\":1,\"name\":\"Bossing Warehouse\",\"code\":\"143\",\"branch_id\":1,\"type\":\"Main Warehouse\",\"location\":\"Bulua Cagayan De Oro City Philippines\",\"capacity\":10000,\"contact_number\":\"0987654321\",\"manager\":\"Marichu Contado\",\"opening_date\":\"2026-02-16T00:00:00.000000Z\",\"status\":\"Active\",\"created_at\":\"2026-02-16T02:37:02.000000Z\",\"updated_at\":\"2026-02-16T02:37:02.000000Z\"}', '{\"code\":\"Bulua CDO\",\"updated_at\":\"2026-02-16 07:58:48\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:58:48', '2026-02-16 15:58:48'),
(54, 3, 'update', 'warehouses', 2, '{\"id\":2,\"name\":\"Airking Warehouse\",\"code\":\"316\",\"branch_id\":1,\"type\":\"Distribution Center\",\"location\":\"Gusa Cagayan De Oro city Philippines\",\"capacity\":8000,\"contact_number\":\"0984022039\",\"manager\":\"Silwyn Dayadaya\",\"opening_date\":\"2026-02-21T00:00:00.000000Z\",\"status\":\"Active\",\"created_at\":\"2026-02-16T02:38:42.000000Z\",\"updated_at\":\"2026-02-16T07:37:26.000000Z\"}', '{\"code\":\"Davao\",\"branch_id\":\"2\",\"location\":\"Davao city Philippines\",\"updated_at\":\"2026-02-16 07:59:23\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:59:23', '2026-02-16 15:59:23'),
(55, 3, 'update', 'warehouses', 3, '{\"id\":3,\"name\":\"Baloro Warehouse\",\"code\":\"2004\",\"branch_id\":3,\"type\":\"Storage Warehouse\",\"location\":\"Philipines Bukidnon Valencia City Lumbo\",\"capacity\":5000,\"contact_number\":\"0987360212\",\"manager\":\"John Philip Baloro\",\"opening_date\":\"2026-03-14T00:00:00.000000Z\",\"status\":\"Active\",\"created_at\":\"2026-02-16T02:50:53.000000Z\",\"updated_at\":\"2026-02-16T07:37:34.000000Z\"}', '{\"code\":\"Valencia\",\"updated_at\":\"2026-02-16 07:59:36\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 15:59:36', '2026-02-16 15:59:36'),
(56, 3, 'create', 'items', 7, NULL, '{\"name\":\"JKL 143\",\"code\":\"FEB14\",\"category\":\"Small Appliances\",\"brand\":\"Whirlpool\",\"barcode\":\"23223\",\"description\":\"Small appliances\",\"unit\":\"Piece\",\"reorder_level\":21321,\"supplier\":\"Secret\",\"status\":\"Active\",\"type\":\"Non-Serialized\",\"price\":1000,\"updated_at\":\"2026-02-16 08:03:25\",\"created_at\":\"2026-02-16 08:03:25\",\"id\":7}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 16:03:25', '2026-02-16 16:03:25'),
(57, 3, 'create', 'items', 8, NULL, '{\"name\":\"Airqueen\",\"code\":\"12313\",\"category\":\"Air Conditioning\",\"brand\":\"Airking\",\"barcode\":\"13251423\",\"description\":\"Aircon With ice\",\"unit\":\"Set\",\"reorder_level\":13123,\"supplier\":\"Secret\",\"status\":\"Active\",\"type\":\"Serialized\",\"price\":10000,\"updated_at\":\"2026-02-16 08:05:19\",\"created_at\":\"2026-02-16 08:05:19\",\"id\":8}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 16:05:19', '2026-02-16 16:05:19'),
(58, 3, 'update', 'items', 3, '{\"id\":3,\"code\":\"53121\",\"barcode\":\"412455124\",\"name\":\"Aircon 14\",\"category\":\"Aircon\",\"brand\":\"Suzuki\",\"description\":\"aircon\",\"price\":\"5000.00\",\"unit\":\"Piece\",\"reorder_level\":3,\"supplier\":\"secret\",\"status\":\"Active\",\"type\":\"Serialized\",\"created_at\":\"2026-02-13T21:00:21.000000Z\",\"updated_at\":\"2026-02-13T21:00:21.000000Z\"}', '{\"category\":\"Air Conditioning\",\"status\":\"Inactive\",\"updated_at\":\"2026-02-16 08:12:51\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 16:12:51', '2026-02-16 16:12:51'),
(59, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-16 18:02:06', '2026-02-16 18:02:06'),
(60, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 01:29:55', '2026-02-17 01:29:55'),
(61, 3, 'create', 'items', 9, NULL, '{\"name\":\"LG 53\",\"code\":\"as-30 pro\",\"category\":\"Air Conditioning\",\"brand\":\"Condura\",\"barcode\":null,\"description\":\"Inventer\",\"unit\":\"Set\",\"reorder_level\":0,\"supplier\":null,\"status\":\"Active\",\"type\":\"Non-Serialized\",\"price\":15000,\"updated_at\":\"2026-02-16 17:49:45\",\"created_at\":\"2026-02-16 17:49:45\",\"id\":9}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 01:49:45', '2026-02-17 01:49:45'),
(62, 3, 'create', 'items', 10, NULL, '{\"name\":\"Cooper tube\",\"code\":\"2314\",\"category\":\"Small Appliances\",\"brand\":null,\"barcode\":null,\"description\":\"Cooper\",\"unit\":\"Roll\",\"reorder_level\":0,\"supplier\":null,\"status\":\"Active\",\"type\":\"Non-Serialized\",\"price\":10000,\"updated_at\":\"2026-02-16 17:50:54\",\"created_at\":\"2026-02-16 17:50:54\",\"id\":10}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 01:50:54', '2026-02-17 01:50:54'),
(63, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 03:09:18', '2026-02-17 03:09:18'),
(64, 3, 'create', 'customers', 1, NULL, '{\"customer_type\":\"Ordinary\",\"customer_name\":\"John Philip Baloro\",\"contact_number\":\"09876573652\",\"email\":\"Philip@gmail.com\",\"company_name\":null,\"address\":\"United village\",\"city\":null,\"region\":\"Cagayan De Oro\",\"is_active\":true,\"updated_at\":\"2026-02-16 19:42:00\",\"created_at\":\"2026-02-16 19:42:00\",\"id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 03:42:00', '2026-02-17 03:42:00'),
(65, 3, 'create', 'customers', 2, NULL, '{\"customer_type\":\"Business\",\"customer_name\":\"Intsik Tan\",\"contact_number\":\"098762135126\",\"email\":\"Tan@gmail.com\",\"company_name\":\"Tan furniture\",\"address\":\"United village\",\"city\":null,\"region\":\"PANGANTUCAN\",\"is_active\":true,\"updated_at\":\"2026-02-16 19:42:46\",\"created_at\":\"2026-02-16 19:42:46\",\"id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 03:42:46', '2026-02-17 03:42:46'),
(66, 3, 'create', 'customers', 3, NULL, '{\"customer_type\":\"Ordinary\",\"customer_name\":\"HAHAHA\",\"contact_number\":\"09039214042\",\"email\":\"hahaha45@gmail.com\",\"company_name\":null,\"address\":\"United village\",\"city\":null,\"region\":\"Bukidnon\",\"credit_limit\":null,\"is_active\":true,\"outstanding_balance\":0,\"updated_at\":\"2026-02-16 20:21:54\",\"created_at\":\"2026-02-16 20:21:54\",\"id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 04:21:54', '2026-02-17 04:21:54'),
(67, 3, 'create', 'customers', 4, NULL, '{\"customer_type\":\"Business\",\"customer_name\":\"Manny Pacquaio\",\"contact_number\":\"09875192093\",\"email\":\"Pac@gmail.com\",\"company_name\":\"Genpac Appliances\",\"address\":\"Gensan\",\"city\":null,\"region\":\"General Santos\",\"credit_limit\":499999.99,\"is_active\":true,\"outstanding_balance\":0,\"updated_at\":\"2026-02-16 20:22:05\",\"created_at\":\"2026-02-16 20:22:05\",\"id\":4}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 04:22:05', '2026-02-17 04:22:05'),
(68, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 05:03:44', '2026-02-17 05:03:44'),
(69, 3, 'update', 'branches', 5, '{\"id\":5,\"code\":\"ILI\",\"name\":\"Iligan\",\"address\":\"asdad0\",\"capacity\":3000,\"is_active\":false,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-14T21:35:08.000000Z\"}', '{\"is_active\":true,\"updated_at\":\"2026-02-16 21:23:33\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 05:23:33', '2026-02-17 05:23:33'),
(70, 3, 'create', 'items', 11, NULL, '{\"name\":\"ytttf3\",\"code\":\"CUST-1771283337298-7zv3fl\",\"category\":\"Air Conditioning\",\"brand\":\"Airking\",\"description\":null,\"unit\":\"Unit\",\"reorder_level\":1,\"status\":\"Active\",\"price\":4888,\"updated_at\":\"2026-02-16 23:09:01\",\"created_at\":\"2026-02-16 23:09:01\",\"id\":11}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 07:09:01', '2026-02-17 07:09:01'),
(71, 3, 'create', 'items', 12, NULL, '{\"name\":\"Aircon\",\"code\":\"as2456\",\"category\":\"Air Conditioning\",\"brand\":\"Hanabishi\",\"barcode\":null,\"description\":\"airventer\",\"unit\":\"Piece\",\"reorder_level\":0,\"supplier\":null,\"status\":\"Active\",\"type\":\"Non-Serialized\",\"price\":600,\"updated_at\":\"2026-02-16 23:11:48\",\"created_at\":\"2026-02-16 23:11:48\",\"id\":12}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '2026-02-17 07:11:48', '2026-02-17 07:11:48'),
(72, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-17 13:43:12', '2026-02-17 13:43:12'),
(73, 3, 'create', 'items', 13, NULL, '{\"name\":\"123123\",\"code\":\"CUST-1771307096819-kafcaw\",\"category\":\"Refrigerator\",\"brand\":\"Condura\",\"description\":null,\"unit\":\"Unit\",\"reorder_level\":1,\"status\":\"Active\",\"price\":4000,\"updated_at\":\"2026-02-17 05:44:58\",\"created_at\":\"2026-02-17 05:44:58\",\"id\":13}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-17 13:44:58', '2026-02-17 13:44:58'),
(74, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-17 16:23:49', '2026-02-17 16:23:49'),
(75, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-18 02:49:11', '2026-02-18 02:49:11'),
(76, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-18 07:03:47', '2026-02-18 07:03:47'),
(77, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-18 07:33:24', '2026-02-18 07:33:24'),
(78, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-18 13:01:27', '2026-02-18 13:01:27'),
(79, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 02:30:03', '2026-02-20 02:30:03'),
(80, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 02:35:26', '2026-02-20 02:35:26'),
(81, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 02:41:46', '2026-02-20 02:41:46'),
(82, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 02:43:30', '2026-02-20 02:43:30'),
(83, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 06:39:53', '2026-02-20 06:39:53'),
(84, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 08:17:27', '2026-02-20 08:17:27'),
(85, 3, 'update', 'users', 4, '{\"user_id\":4,\"first_name\":\"John\",\"last_name\":\"Baloro\",\"username\":\"john\",\"email\":\"johnphilipbaloro56@gmail.com\",\"phone\":\"09756026160\",\"role_id\":2,\"branch_id\":5,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$iyaSyX\\/W0RE.9495NQKX6OKyERHQroanVVUd\\/enOzP8AwU.PlsqC.\",\"remember_token\":null,\"created_at\":\"2026-02-13T19:59:02.000000Z\",\"updated_at\":\"2026-02-13T19:59:34.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-20 01:08:31\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 09:08:31', '2026-02-20 09:08:31'),
(86, 3, 'update', 'branches', 1, '{\"id\":1,\"code\":\"CDO\",\"name\":\"Cagayan de Oro\",\"region\":null,\"city\":null,\"address\":null,\"contact_number\":null,\"email\":null,\"opening_date\":null,\"capacity\":6000,\"is_active\":true,\"created_at\":\"2026-02-13T19:57:06.000000Z\",\"updated_at\":\"2026-02-13T19:57:06.000000Z\"}', '{\"updated_at\":\"2026-02-20 01:15:35\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 09:15:35', '2026-02-20 09:15:35'),
(87, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-20 15:03:47', '2026-02-20 15:03:47'),
(88, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-20 15:09:03', '2026-02-20 15:09:03'),
(89, 3, 'update', 'warehouses', 1, '{\"id\":1,\"name\":\"Bossing Warehouse\",\"code\":\"Bulua CDO\",\"branch_id\":1,\"type\":\"Main Warehouse\",\"location\":\"Bulua Cagayan De Oro City Philippines\",\"capacity\":10000,\"contact_number\":\"0987654321\",\"manager\":\"Marichu Contado\",\"opening_date\":\"2026-02-16T00:00:00.000000Z\",\"status\":\"Active\",\"created_at\":\"2026-02-16T02:37:02.000000Z\",\"updated_at\":\"2026-02-16T07:58:48.000000Z\"}', '{\"status\":\"Inactive\",\"updated_at\":\"2026-02-20 07:14:39\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-20 15:14:39', '2026-02-20 15:14:39'),
(90, 3, 'update', 'warehouses', 1, '{\"id\":1,\"name\":\"Bossing Warehouse\",\"code\":\"Bulua CDO\",\"branch_id\":1,\"type\":\"Main Warehouse\",\"location\":\"Bulua Cagayan De Oro City Philippines\",\"capacity\":10000,\"contact_number\":\"0987654321\",\"manager\":\"Marichu Contado\",\"opening_date\":\"2026-02-16T00:00:00.000000Z\",\"status\":\"Inactive\",\"created_at\":\"2026-02-16T02:37:02.000000Z\",\"updated_at\":\"2026-02-20T07:14:39.000000Z\"}', '{\"status\":\"Active\",\"updated_at\":\"2026-02-20 07:14:48\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-20 15:14:48', '2026-02-20 15:14:48'),
(91, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 00:43:43', '2026-02-21 00:43:43'),
(92, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 02:12:36', '2026-02-21 02:12:36'),
(93, 3, 'create', 'warehouses', 4, NULL, '{\"name\":\"HAHha\",\"code\":\"32123\",\"branch_id\":\"4\",\"type\":\"Main Warehouse\",\"location\":\"CITuhADJ\",\"capacity\":\"20301\",\"contact_number\":\"0986656\",\"manager\":\"John Pghilip BAL\",\"opening_date\":\"2026-03-02 00:00:00\",\"status\":\"Active\",\"updated_at\":\"2026-02-20 18:13:28\",\"created_at\":\"2026-02-20 18:13:28\",\"id\":4}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 02:13:28', '2026-02-21 02:13:28'),
(94, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 04:35:01', '2026-02-21 04:35:01'),
(95, 3, 'create', 'suppliers', 1, NULL, '{\"supplier_name\":\"KHEN THE GREAT\",\"contact_person\":\"KASJDKAS\",\"contact_number\":\"029309123\",\"email\":\"SGAGSGA@GMAIL.COM\",\"address\":\"Cagayan de oro\",\"origin\":\"Local\",\"region\":\"Region X - Northern Mindanao\",\"tin\":\"2313524\",\"notes\":\"HAHAHAHA\",\"updated_at\":\"2026-02-20 22:29:50\",\"created_at\":\"2026-02-20 22:29:50\",\"id\":1}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 06:29:50', '2026-02-21 06:29:50'),
(96, 3, 'create', 'suppliers', 2, NULL, '{\"supplier_name\":\"khentoy\",\"contact_person\":\"093210938921\",\"contact_number\":\"09988741726\",\"email\":\"MIDDLE@GMAIL.COM\",\"address\":\"JHSDJAJHDSHJ\",\"origin\":\"International\",\"region\":\"Middle East\",\"tin\":\"kjdsakjhsad\",\"notes\":\"aircon\",\"updated_at\":\"2026-02-20 22:31:07\",\"created_at\":\"2026-02-20 22:31:07\",\"id\":2}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-21 06:31:07', '2026-02-21 06:31:07'),
(97, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-21 06:33:50', '2026-02-21 06:33:50'),
(98, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 00:16:45', '2026-02-22 00:16:45'),
(99, 3, 'update', 'users', 4, '{\"user_id\":4,\"first_name\":\"John\",\"last_name\":\"Baloro\",\"username\":\"john\",\"email\":\"johnphilipbaloro56@gmail.com\",\"phone\":\"09756026160\",\"role_id\":2,\"branch_id\":5,\"status_id\":2,\"email_verified_at\":null,\"password_hash\":\"$2y$12$iyaSyX\\/W0RE.9495NQKX6OKyERHQroanVVUd\\/enOzP8AwU.PlsqC.\",\"remember_token\":null,\"created_at\":\"2026-02-13T19:59:02.000000Z\",\"updated_at\":\"2026-02-20T01:08:31.000000Z\"}', '{\"status_id\":1,\"updated_at\":\"2026-02-21 16:24:20\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 00:24:20', '2026-02-22 00:24:20'),
(100, 3, 'update', 'users', 7, '{\"user_id\":7,\"first_name\":\"silwyn\",\"last_name\":\"Ibaoc\",\"username\":\"silwyn\",\"email\":\"silwyn@gmail.com\",\"phone\":\"12345\",\"role_id\":5,\"branch_id\":7,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$R3nVdwct874htHQKR9AhiOCrqvpCRZkAtxOFoSeivP7oUtGi5amVW\",\"remember_token\":null,\"created_at\":\"2026-02-13T20:07:39.000000Z\",\"updated_at\":\"2026-02-13T20:07:39.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-21 16:24:24\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 00:24:24', '2026-02-22 00:24:24'),
(101, 3, 'update', 'users', 8, '{\"user_id\":8,\"first_name\":\"khen\",\"last_name\":\"adora\",\"username\":\"khen\",\"email\":\"khen@gmail.com\",\"phone\":\"143143\",\"role_id\":3,\"branch_id\":1,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$nJDTUsxkGhN0GeOCt3ZFD.\\/2pVqHa46MZVfKT4qaWGLuAcsu2QrpC\",\"remember_token\":null,\"created_at\":\"2026-02-13T21:37:40.000000Z\",\"updated_at\":\"2026-02-13T21:37:40.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-21 16:24:27\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 00:24:27', '2026-02-22 00:24:27'),
(102, 3, 'update', 'users', 9, '{\"user_id\":9,\"first_name\":\"dayadaya\",\"last_name\":\"ydaddyy\",\"username\":\"dayadaya\",\"email\":\"dayday@gmail.com\",\"phone\":\"12124\",\"role_id\":3,\"branch_id\":6,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$NE8NdkKZNxWT0ajYWLG9oODlXAvGJgjqeNtxvst1Lh7czP11pXlhO\",\"remember_token\":null,\"created_at\":\"2026-02-13T21:44:09.000000Z\",\"updated_at\":\"2026-02-13T21:44:09.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-21 16:24:30\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 00:24:30', '2026-02-22 00:24:30'),
(103, 3, 'create', 'suppliers', 3, NULL, '{\"supplier_name\":\"Hanz birthday Boi\",\"contact_person\":\"Hanz earl taga kalilangan\",\"contact_number\":\"092138329\",\"email\":\"earl@gmmail.com\",\"address\":\"Bukidnon malaybalay city\",\"origin\":\"Local\",\"region\":\"Region X - Northern Mindanao\",\"tin\":\"21321321\",\"status_id\":\"1\",\"notes\":\"HAHAHAH\",\"updated_at\":\"2026-02-21 16:39:33\",\"created_at\":\"2026-02-21 16:39:33\",\"id\":3}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-22 00:39:33', '2026-02-22 00:39:33'),
(104, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-23 04:38:43', '2026-02-23 04:38:43'),
(105, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-23 05:33:52', '2026-02-23 05:33:52'),
(106, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-23 05:48:20', '2026-02-23 05:48:20'),
(107, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.5.17 Chrome/142.0.7444.265 Electron/39.3.0 Safari/537.36', '2026-02-23 06:01:15', '2026-02-23 06:01:15'),
(108, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-23 06:01:44', '2026-02-23 06:01:44'),
(109, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-23 06:18:58', '2026-02-23 06:18:58'),
(110, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-23 12:33:52', '2026-02-23 12:33:52'),
(111, 3, 'update', 'users', 6, '{\"user_id\":6,\"first_name\":\"cristian\",\"last_name\":\"castro\",\"username\":\"cristian\",\"email\":\"cristian@gmail.com\",\"phone\":\"123456\",\"role_id\":4,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$0dqwawWPRsKDBfNv2Ew8m.QV7v1fjC1q13abYWs2uDK7x5GFN8Xwe\",\"remember_token\":null,\"created_at\":\"2026-02-13T20:06:16.000000Z\",\"updated_at\":\"2026-02-13T20:06:16.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-23 04:34:07\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-23 12:34:07', '2026-02-23 12:34:07'),
(112, 3, 'update', 'users', 6, '{\"user_id\":6,\"first_name\":\"cristian\",\"last_name\":\"castro\",\"username\":\"cristian\",\"email\":\"cristian@gmail.com\",\"phone\":\"123456\",\"role_id\":4,\"status_id\":2,\"email_verified_at\":null,\"password_hash\":\"$2y$12$0dqwawWPRsKDBfNv2Ew8m.QV7v1fjC1q13abYWs2uDK7x5GFN8Xwe\",\"remember_token\":null,\"created_at\":\"2026-02-13T20:06:16.000000Z\",\"updated_at\":\"2026-02-23T04:34:07.000000Z\"}', '{\"status_id\":1,\"updated_at\":\"2026-02-23 04:34:11\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-23 12:34:11', '2026-02-23 12:34:11'),
(113, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-23 12:37:56', '2026-02-23 12:37:56'),
(114, 3, 'create', 'suppliers', 4, NULL, '{\"supplier_name\":\"Josh Appliance\",\"contact_person\":\"john biran\",\"contact_number\":\"094939049823\",\"email\":\"josh@gmail.com\",\"address\":\"carmen cagayan de oro city\",\"origin\":\"International\",\"region\":\"East Asia\",\"tin\":\"adsa\",\"status_id\":\"1\",\"notes\":\"HAHAHAHA\",\"updated_at\":\"2026-02-23 05:30:23\",\"created_at\":\"2026-02-23 05:30:23\",\"id\":4}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-23 13:30:23', '2026-02-23 13:30:23'),
(115, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-23 16:10:07', '2026-02-23 16:10:07'),
(116, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-24 00:27:15', '2026-02-24 00:27:15');
INSERT INTO `audit_trail` (`audit_id`, `user_id`, `action`, `table_name`, `record_id`, `old_values`, `new_values`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(117, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-24 03:47:37', '2026-02-24 03:47:37'),
(118, 3, 'update', 'users', 5, '{\"user_id\":5,\"first_name\":\"marichu\",\"last_name\":\"contado\",\"username\":\"marichu\",\"email\":\"marichu@gmail.com\",\"phone\":\"123456789\",\"role_id\":3,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$Cc7.a3CYtLn3sj\\/rdmGUqeW0hwuN0uy0QnmpTKoImVy4\\/qmhxGYvC\",\"remember_token\":null,\"created_at\":\"2026-02-13T20:03:40.000000Z\",\"updated_at\":\"2026-02-13T20:03:40.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-23 19:48:11\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-24 03:48:11', '2026-02-24 03:48:11'),
(119, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-24 11:32:14', '2026-02-24 11:32:14'),
(120, 3, 'create', 'suppliers', 5, NULL, '{\"supplier_name\":\"Cyrus the great\",\"contact_person\":\"cyrus\",\"contact_number\":\"09879804712\",\"email\":\"cyrus@gmail.com\",\"address\":\"Jakarta Indonesia\",\"origin\":\"International\",\"region\":\"Southeast Asia\",\"tin\":\"982331\",\"status_id\":\"1\",\"notes\":\"Aircon\",\"updated_at\":\"2026-02-24 04:36:19\",\"created_at\":\"2026-02-24 04:36:19\",\"id\":5}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-24 12:36:20', '2026-02-24 12:36:20'),
(121, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-24 14:01:43', '2026-02-24 14:01:43'),
(122, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-24 14:18:26', '2026-02-24 14:18:26'),
(123, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-24 14:42:53', '2026-02-24 14:42:53'),
(124, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 05:10:55', '2026-02-25 05:10:55'),
(125, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 05:11:06', '2026-02-25 05:11:06'),
(126, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 05:11:16', '2026-02-25 05:11:16'),
(127, 3, 'create', 'users', 13, NULL, '{\"first_name\":\"baloro\",\"last_name\":\"john\",\"email\":\"philip@gmail.com\",\"username\":\"philip\",\"phone\":\"09890328190\",\"role_id\":1,\"status_id\":1,\"password_hash\":\"$2y$12$DdAPbFU4J9L1Zwoh1H943.tv2eEozYA8R5naup90sOZaZBQGWO.C.\",\"updated_at\":\"2026-02-24 21:26:46\",\"created_at\":\"2026-02-24 21:26:46\",\"user_id\":13}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 05:26:46', '2026-02-25 05:26:46'),
(128, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 05:27:38', '2026-02-25 05:27:38'),
(129, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 05:27:48', '2026-02-25 05:27:48'),
(130, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 06:24:07', '2026-02-25 06:24:07'),
(131, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 07:46:00', '2026-02-25 07:46:00'),
(132, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 07:55:07', '2026-02-25 07:55:07'),
(133, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 07:55:17', '2026-02-25 07:55:17'),
(134, 3, 'update', 'users', 4, '{\"user_id\":4,\"first_name\":\"John\",\"last_name\":\"Baloro\",\"username\":\"john\",\"email\":\"johnphilipbaloro56@gmail.com\",\"phone\":\"09756026160\",\"role_id\":2,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$iyaSyX\\/W0RE.9495NQKX6OKyERHQroanVVUd\\/enOzP8AwU.PlsqC.\",\"remember_token\":null,\"created_at\":\"2026-02-13T19:59:02.000000Z\",\"updated_at\":\"2026-02-21T16:24:20.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-24 23:55:50\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 07:55:50', '2026-02-25 07:55:50'),
(135, 3, 'create', 'users', 14, NULL, '{\"first_name\":\"kinsa\",\"last_name\":\"nia\",\"email\":\"kinsa@gmail.com\",\"username\":\"kinsa\",\"phone\":\"09087096123\",\"role_id\":3,\"status_id\":1,\"password_hash\":\"$2y$12$T0tCdjrhciuQAVWmprxQae5KLL57wq3iWPgtYPxaTnYW9w3D2aA1C\",\"updated_at\":\"2026-02-24 23:57:15\",\"created_at\":\"2026-02-24 23:57:15\",\"user_id\":14}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 07:57:15', '2026-02-25 07:57:15'),
(136, 3, 'create', 'suppliers', 6, NULL, '{\"supplier_name\":\"example\",\"contact_person\":\"example\",\"contact_number\":\"09424242\",\"email\":\"example@gmail.com\",\"address\":\"carmen cagayan de oro city\",\"origin\":\"Local\",\"region\":\"NIR - Negros Island Region\",\"tin\":\"42323\",\"status_id\":\"1\",\"notes\":null,\"updated_at\":\"2026-02-25 00:29:02\",\"created_at\":\"2026-02-25 00:29:02\",\"supplier_id\":6}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 08:29:02', '2026-02-25 08:29:02'),
(137, 3, 'delete', 'suppliers', 5, '{\"supplier_id\":5,\"supplier_name\":\"Cyrus the great\",\"contact_person\":\"cyrus\",\"contact_number\":\"09879804712\",\"email\":\"cyrus@gmail.com\",\"address\":\"Jakarta Indonesia\",\"origin\":\"International\",\"region\":\"Southeast Asia\",\"tin\":\"982331\",\"status_id\":1,\"notes\":\"Aircon\",\"created_at\":\"2026-02-24T04:36:19.000000Z\",\"updated_at\":\"2026-02-25T05:37:49.000000Z\",\"deleted_at\":\"2026-02-25T05:37:49.000000Z\"}', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 13:37:49', '2026-02-25 13:37:49'),
(138, 3, 'delete', 'suppliers', 3, '{\"supplier_id\":3,\"supplier_name\":\"Hanz birthday Boi\",\"contact_person\":\"Hanz earl taga kalilangan\",\"contact_number\":\"092138329\",\"email\":\"earl@gmmail.com\",\"address\":\"Bukidnon malaybalay city\",\"origin\":\"Local\",\"region\":\"Region X - Northern Mindanao\",\"tin\":\"21321321\",\"status_id\":1,\"notes\":\"HAHAHAH\",\"created_at\":\"2026-02-21T16:39:33.000000Z\",\"updated_at\":\"2026-02-25T05:37:56.000000Z\",\"deleted_at\":\"2026-02-25T05:37:56.000000Z\"}', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 13:37:56', '2026-02-25 13:37:56'),
(139, 3, 'delete', 'suppliers', 4, '{\"supplier_id\":4,\"supplier_name\":\"Josh Appliance\",\"contact_person\":\"john biran\",\"contact_number\":\"094939049823\",\"email\":\"josh@gmail.com\",\"address\":\"carmen cagayan de oro city\",\"origin\":\"International\",\"region\":\"East Asia\",\"tin\":\"adsa\",\"status_id\":1,\"notes\":\"HAHAHAHA\",\"created_at\":\"2026-02-23T05:30:23.000000Z\",\"updated_at\":\"2026-02-25T05:38:00.000000Z\",\"deleted_at\":\"2026-02-25T05:38:00.000000Z\"}', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 13:38:00', '2026-02-25 13:38:00'),
(140, 3, 'delete', 'suppliers', 1, '{\"supplier_id\":1,\"supplier_name\":\"KHEN THE GREAT\",\"contact_person\":\"KASJDKAS\",\"contact_number\":\"029309123\",\"email\":\"SGAGSGA@GMAIL.COM\",\"address\":\"Cagayan de oro\",\"origin\":\"Local\",\"region\":\"Region X - Northern Mindanao\",\"tin\":\"2313524\",\"status_id\":null,\"notes\":\"HAHAHAHA\",\"created_at\":\"2026-02-20T22:29:50.000000Z\",\"updated_at\":\"2026-02-25T05:38:04.000000Z\",\"deleted_at\":\"2026-02-25T05:38:04.000000Z\"}', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 13:38:04', '2026-02-25 13:38:04'),
(141, 3, 'delete', 'suppliers', 2, '{\"supplier_id\":2,\"supplier_name\":\"khentoy\",\"contact_person\":\"093210938921\",\"contact_number\":\"09988741726\",\"email\":\"MIDDLE@GMAIL.COM\",\"address\":\"JHSDJAJHDSHJ\",\"origin\":\"International\",\"region\":\"Middle East\",\"tin\":\"kjdsakjhsad\",\"status_id\":null,\"notes\":\"aircon\",\"created_at\":\"2026-02-20T22:31:07.000000Z\",\"updated_at\":\"2026-02-25T05:38:08.000000Z\",\"deleted_at\":\"2026-02-25T05:38:08.000000Z\"}', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 13:38:08', '2026-02-25 13:38:08'),
(142, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 14:05:35', '2026-02-25 14:05:35'),
(143, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 14:05:44', '2026-02-25 14:05:44'),
(144, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-25 17:28:32', '2026-02-25 17:28:32'),
(145, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-25 17:29:53', '2026-02-25 17:29:53'),
(146, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-26 01:33:20', '2026-02-26 01:33:20'),
(147, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-26 05:26:00', '2026-02-26 05:26:00'),
(148, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-02-26 10:52:44', '2026-02-26 10:52:44'),
(149, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 02:56:44', '2026-02-27 02:56:44'),
(150, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 05:03:49', '2026-02-27 05:03:49'),
(151, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 06:33:00', '2026-02-27 06:33:00'),
(152, 10, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 06:33:45', '2026-02-27 06:33:45'),
(153, 10, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 06:34:08', '2026-02-27 06:34:08'),
(154, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 06:34:15', '2026-02-27 06:34:15'),
(155, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 06:34:19', '2026-02-27 06:34:19'),
(156, 10, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 06:34:30', '2026-02-27 06:34:30'),
(157, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 15:05:59', '2026-02-27 15:05:59'),
(158, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 15:11:12', '2026-02-27 15:11:12'),
(159, 11, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 15:26:19', '2026-02-27 15:26:19'),
(160, 11, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:18:46', '2026-02-27 18:18:46'),
(161, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:18:52', '2026-02-27 18:18:52'),
(162, 3, 'update', 'users', 6, '{\"user_id\":6,\"first_name\":\"cristian\",\"last_name\":\"castro\",\"username\":\"cristian\",\"email\":\"cristian@gmail.com\",\"phone\":\"123456\",\"role_id\":4,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$0dqwawWPRsKDBfNv2Ew8m.QV7v1fjC1q13abYWs2uDK7x5GFN8Xwe\",\"remember_token\":null,\"created_at\":\"2026-02-13T20:06:16.000000Z\",\"updated_at\":\"2026-02-23T04:34:11.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-27 10:19:10\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:19:10', '2026-02-27 18:19:10'),
(163, 3, 'update', 'users', 10, '{\"user_id\":10,\"first_name\":\"Cyrus\",\"last_name\":\"tadoy\",\"username\":\"cyrus\",\"email\":\"cyrus@gmail.com\",\"phone\":\"0978937362\",\"role_id\":3,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$kkYK9eByCldNvbEclhYXU.BC\\/C0L3PHL3doPNDlA9qAUS5QXdL9IW\",\"remember_token\":null,\"created_at\":\"2026-02-16T02:24:18.000000Z\",\"updated_at\":\"2026-02-16T02:24:18.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-27 10:19:14\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:19:14', '2026-02-27 18:19:14'),
(164, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:19:22', '2026-02-27 18:19:22'),
(165, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:20:26', '2026-02-27 18:20:26'),
(166, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:20:57', '2026-02-27 18:20:57'),
(167, 13, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:21:15', '2026-02-27 18:21:15'),
(168, 13, 'create', 'users', 15, NULL, '{\"first_name\":\"blue\",\"last_name\":\"than\",\"email\":\"blue@gmail.com\",\"username\":\"blue\",\"phone\":\"09089023189\",\"role_id\":2,\"status_id\":1,\"password_hash\":\"$2y$12$0ElgIqzlVgER9wEP9yDAmu7LwgqhwsL86iRoJ1.M0vVRomK5RAYam\",\"updated_at\":\"2026-02-27 10:22:30\",\"created_at\":\"2026-02-27 10:22:30\",\"user_id\":15}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:22:30', '2026-02-27 18:22:30'),
(169, 13, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:22:34', '2026-02-27 18:22:34'),
(170, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:22:47', '2026-02-27 18:22:47'),
(171, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:23:05', '2026-02-27 18:23:05'),
(172, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:23:12', '2026-02-27 18:23:12'),
(173, 3, 'create', 'users', 16, NULL, '{\"first_name\":\"red\",\"last_name\":\"than\",\"email\":\"red@gmail.com\",\"username\":\"red\",\"phone\":\"09089318921\",\"role_id\":5,\"status_id\":1,\"password_hash\":\"$2y$12$4vgCrIC\\/TITO.FQ8ggRHG.8TppJemvrMXoKhlY7H6BBa94iOE2d6O\",\"updated_at\":\"2026-02-27 10:24:13\",\"created_at\":\"2026-02-27 10:24:13\",\"user_id\":16}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:24:13', '2026-02-27 18:24:13'),
(174, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:24:25', '2026-02-27 18:24:25'),
(175, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:24:28', '2026-02-27 18:24:28'),
(176, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-27 18:24:37', '2026-02-27 18:24:37'),
(177, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:55:05', '2026-02-28 09:55:05'),
(178, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:55:40', '2026-02-28 09:55:40'),
(179, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:55:45', '2026-02-28 09:55:45'),
(180, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:55:58', '2026-02-28 09:55:58'),
(181, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:56:06', '2026-02-28 09:56:06'),
(182, 3, 'update', 'users', 16, '{\"user_id\":16,\"first_name\":\"red\",\"last_name\":\"than\",\"username\":\"red\",\"email\":\"red@gmail.com\",\"phone\":\"09089318921\",\"role_id\":5,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$4vgCrIC\\/TITO.FQ8ggRHG.8TppJemvrMXoKhlY7H6BBa94iOE2d6O\",\"remember_token\":null,\"created_at\":\"2026-02-27T10:24:13.000000Z\",\"updated_at\":\"2026-02-27T10:24:13.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-02-28 01:56:18\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:56:18', '2026-02-28 09:56:18'),
(183, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:56:24', '2026-02-28 09:56:24'),
(184, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:56:46', '2026-02-28 09:56:46'),
(185, 3, 'update', 'users', 16, '{\"user_id\":16,\"first_name\":\"red\",\"last_name\":\"than\",\"username\":\"red\",\"email\":\"red@gmail.com\",\"phone\":\"09089318921\",\"role_id\":5,\"status_id\":2,\"email_verified_at\":null,\"password_hash\":\"$2y$12$4vgCrIC\\/TITO.FQ8ggRHG.8TppJemvrMXoKhlY7H6BBa94iOE2d6O\",\"remember_token\":null,\"created_at\":\"2026-02-27T10:24:13.000000Z\",\"updated_at\":\"2026-02-28T01:56:18.000000Z\"}', '{\"status_id\":1,\"updated_at\":\"2026-02-28 01:56:58\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:56:58', '2026-02-28 09:56:58'),
(186, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:57:05', '2026-02-28 09:57:05'),
(187, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:57:08', '2026-02-28 09:57:08'),
(188, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:57:17', '2026-02-28 09:57:17'),
(189, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:57:27', '2026-02-28 09:57:27'),
(190, 3, 'update', 'users', 5, '{\"user_id\":5,\"first_name\":\"marichu\",\"last_name\":\"contado\",\"username\":\"marichu\",\"email\":\"marichu@gmail.com\",\"phone\":\"123456789\",\"role_id\":3,\"status_id\":2,\"email_verified_at\":null,\"password_hash\":\"$2y$12$Cc7.a3CYtLn3sj\\/rdmGUqeW0hwuN0uy0QnmpTKoImVy4\\/qmhxGYvC\",\"remember_token\":null,\"created_at\":\"2026-02-13T20:03:40.000000Z\",\"updated_at\":\"2026-02-23T19:48:11.000000Z\"}', '{\"status_id\":1,\"updated_at\":\"2026-02-28 01:57:38\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:57:38', '2026-02-28 09:57:38'),
(191, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:57:43', '2026-02-28 09:57:43'),
(192, 5, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:58:00', '2026-02-28 09:58:00'),
(193, 5, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 09:58:12', '2026-02-28 09:58:12'),
(194, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-02-28 11:17:57', '2026-02-28 11:17:57'),
(195, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', '2026-03-03 11:05:21', '2026-03-03 11:05:21'),
(196, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-03 11:15:28', '2026-03-03 11:15:28'),
(197, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 14:17:12', '2026-03-10 14:17:12'),
(198, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-10 14:20:32', '2026-03-10 14:20:32'),
(199, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 05:14:59', '2026-03-13 05:14:59'),
(200, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:21:29', '2026-03-13 06:21:29'),
(201, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:21:51', '2026-03-13 06:21:51'),
(202, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:22:11', '2026-03-13 06:22:11'),
(203, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:22:46', '2026-03-13 06:22:46'),
(204, 4, 'password_reset', 'users', 4, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:23:09', '2026-03-13 06:23:09'),
(205, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:23:38', '2026-03-13 06:23:38'),
(206, 3, 'update', 'users', 4, '{\"user_id\":4,\"first_name\":\"John\",\"last_name\":\"Baloro\",\"username\":\"john\",\"email\":\"johnphilipbaloro56@gmail.com\",\"phone\":\"09756026160\",\"role_id\":2,\"status_id\":2,\"email_verified_at\":null,\"password_hash\":\"$2y$12$LUpDbwlOCHSYr9ULQoBPU.WzyOtRhDKfPZl5y2qfvtzs\\/GJZeeO2u\",\"remember_token\":null,\"created_at\":\"2026-02-13T19:59:02.000000Z\",\"updated_at\":\"2026-03-12T22:23:09.000000Z\"}', '{\"status_id\":1,\"updated_at\":\"2026-03-12 22:23:51\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:23:51', '2026-03-13 06:23:51'),
(207, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:23:56', '2026-03-13 06:23:56'),
(208, 4, 'password_reset', 'users', 4, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:24:19', '2026-03-13 06:24:19'),
(209, 4, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:24:30', '2026-03-13 06:24:30'),
(210, 4, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:24:41', '2026-03-13 06:24:41'),
(211, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:25:16', '2026-03-13 06:25:16'),
(212, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:25:55', '2026-03-13 06:25:55'),
(213, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:26:37', '2026-03-13 06:26:37'),
(214, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:27:35', '2026-03-13 06:27:35'),
(215, 4, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:27:59', '2026-03-13 06:27:59'),
(216, 4, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:29:46', '2026-03-13 06:29:46'),
(217, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-13 06:29:51', '2026-03-13 06:29:51'),
(218, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', '2026-03-13 07:06:49', '2026-03-13 07:06:49'),
(219, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-15 00:38:54', '2026-03-15 00:38:54'),
(220, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-15 00:48:50', '2026-03-15 00:48:50'),
(221, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-15 00:48:56', '2026-03-15 00:48:56'),
(222, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-15 00:49:13', '2026-03-15 00:49:13'),
(223, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-15 00:52:00', '2026-03-15 00:52:00'),
(224, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-16 15:05:49', '2026-03-16 15:05:49'),
(225, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-21 23:07:22', '2026-03-21 23:07:22'),
(226, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-22 13:23:51', '2026-03-22 13:23:51'),
(227, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-23 14:55:44', '2026-03-23 14:55:44'),
(228, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 13:11:00', '2026-03-24 13:11:00'),
(229, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-24 17:03:44', '2026-03-24 17:03:44'),
(230, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 20:19:59', '2026-03-24 20:19:59'),
(231, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 21:44:02', '2026-03-24 21:44:02'),
(232, 3, 'update', 'users', 13, '{\"user_id\":13,\"first_name\":\"baloro\",\"last_name\":\"john\",\"username\":\"philip\",\"email\":\"philip@gmail.com\",\"phone\":\"09890328190\",\"role_id\":1,\"branch_id\":null,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$DdAPbFU4J9L1Zwoh1H943.tv2eEozYA8R5naup90sOZaZBQGWO.C.\",\"remember_token\":null,\"created_at\":\"2026-02-24T21:26:46.000000Z\",\"updated_at\":\"2026-02-24T21:26:46.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-03-24 15:04:34\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 22:04:34', '2026-03-24 22:04:34'),
(233, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 22:04:48', '2026-03-24 22:04:48'),
(234, 14, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 22:05:08', '2026-03-24 22:05:08'),
(235, 14, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 22:12:49', '2026-03-24 22:12:49'),
(236, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 22:12:51', '2026-03-24 22:12:51'),
(237, 3, 'update', 'users', 6, '{\"user_id\":6,\"first_name\":\"cristian\",\"last_name\":\"castro\",\"username\":\"cristian\",\"email\":\"cristian@gmail.com\",\"phone\":\"123456\",\"role_id\":4,\"branch_id\":null,\"status_id\":2,\"email_verified_at\":null,\"password_hash\":\"$2y$12$0dqwawWPRsKDBfNv2Ew8m.QV7v1fjC1q13abYWs2uDK7x5GFN8Xwe\",\"remember_token\":null,\"created_at\":\"2026-02-13T20:06:16.000000Z\",\"updated_at\":\"2026-02-27T10:19:10.000000Z\"}', '{\"status_id\":1,\"updated_at\":\"2026-03-24 15:13:11\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-24 22:13:11', '2026-03-24 22:13:11'),
(238, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-25 11:14:46', '2026-03-25 11:14:46'),
(239, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-27 00:07:36', '2026-03-27 00:07:36'),
(240, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-27 00:08:58', '2026-03-27 00:08:58'),
(241, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-27 00:16:44', '2026-03-27 00:16:44'),
(242, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-27 01:48:46', '2026-03-27 01:48:46'),
(243, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 01:50:26', '2026-03-27 01:50:26'),
(244, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-27 02:14:58', '2026-03-27 02:14:58'),
(245, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-27 05:03:29', '2026-03-27 05:03:29'),
(246, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0', '2026-03-27 05:40:47', '2026-03-27 05:40:47'),
(247, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 05:42:44', '2026-03-27 05:42:44'),
(248, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:10:09', '2026-03-27 07:10:09'),
(249, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:16:41', '2026-03-27 07:16:41'),
(250, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:17:09', '2026-03-27 07:17:09'),
(251, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:17:35', '2026-03-27 07:17:35'),
(252, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:17:59', '2026-03-27 07:17:59'),
(253, 3, 'update', 'users', 6, '{\"user_id\":6,\"first_name\":\"cristian\",\"last_name\":\"castro\",\"username\":\"cristian\",\"email\":\"cristian@gmail.com\",\"phone\":\"123456\",\"role_id\":4,\"branch_id\":null,\"status_id\":1,\"email_verified_at\":null,\"password_hash\":\"$2y$12$0dqwawWPRsKDBfNv2Ew8m.QV7v1fjC1q13abYWs2uDK7x5GFN8Xwe\",\"remember_token\":null,\"created_at\":\"2026-02-14T11:06:16.000000Z\",\"updated_at\":\"2026-03-25T05:13:11.000000Z\"}', '{\"status_id\":2,\"updated_at\":\"2026-03-27 14:18:09\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:18:09', '2026-03-27 07:18:09'),
(254, 3, 'create', 'users', 17, NULL, '{\"first_name\":\"Marc\",\"last_name\":\"Dayadaya\",\"email\":\"Marcdayadaya1@gmail.com\",\"username\":\"marc\",\"phone\":\"09801238902\",\"role_id\":4,\"status_id\":1,\"password_hash\":\"$2y$12$F7pXU5TwLviGBR\\/1oQbCb.E\\/FEg0iBinhLXkmpgy8geXegZ4kZPwy\",\"updated_at\":\"2026-03-27 14:20:05\",\"created_at\":\"2026-03-27 14:20:05\",\"user_id\":17}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:20:05', '2026-03-27 07:20:05'),
(255, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:20:22', '2026-03-27 07:20:22'),
(256, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:20:32', '2026-03-27 07:20:32'),
(257, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:23:19', '2026-03-27 07:23:19'),
(258, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:23:25', '2026-03-27 07:23:25'),
(259, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:26:01', '2026-03-27 07:26:01'),
(260, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:38:37', '2026-03-27 07:38:37'),
(261, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:38:44', '2026-03-27 07:38:44'),
(262, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:40:06', '2026-03-27 07:40:06'),
(263, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:40:12', '2026-03-27 07:40:12'),
(264, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:40:33', '2026-03-27 07:40:33'),
(265, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 07:40:41', '2026-03-27 07:40:41'),
(266, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 08:58:00', '2026-03-27 08:58:00'),
(267, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 08:58:06', '2026-03-27 08:58:06'),
(268, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:05:47', '2026-03-27 09:05:47'),
(269, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:05:54', '2026-03-27 09:05:54'),
(270, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:26:09', '2026-03-27 09:26:09'),
(271, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:26:14', '2026-03-27 09:26:14'),
(272, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:26:39', '2026-03-27 09:26:39'),
(273, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:26:50', '2026-03-27 09:26:50'),
(274, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:46:33', '2026-03-27 09:46:33'),
(275, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:46:39', '2026-03-27 09:46:39'),
(276, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:54:03', '2026-03-27 09:54:03'),
(277, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:54:15', '2026-03-27 09:54:15'),
(278, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:54:20', '2026-03-27 09:54:20'),
(279, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 09:54:30', '2026-03-27 09:54:30'),
(280, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:03:37', '2026-03-27 10:03:37'),
(281, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:03:42', '2026-03-27 10:03:42'),
(282, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:04:09', '2026-03-27 10:04:09'),
(283, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:04:25', '2026-03-27 10:04:25'),
(284, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:24:56', '2026-03-27 10:24:56'),
(285, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:25:01', '2026-03-27 10:25:01'),
(286, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:25:52', '2026-03-27 10:25:52'),
(287, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:25:58', '2026-03-27 10:25:58'),
(288, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:26:31', '2026-03-27 10:26:31'),
(289, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:26:38', '2026-03-27 10:26:38'),
(290, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:29:30', '2026-03-27 10:29:30'),
(291, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:29:36', '2026-03-27 10:29:36'),
(292, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:30:21', '2026-03-27 10:30:21'),
(293, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:30:27', '2026-03-27 10:30:27'),
(294, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:32:02', '2026-03-27 10:32:02'),
(295, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:32:07', '2026-03-27 10:32:07'),
(296, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:33:19', '2026-03-27 10:33:19'),
(297, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 10:33:26', '2026-03-27 10:33:26');
INSERT INTO `audit_trail` (`audit_id`, `user_id`, `action`, `table_name`, `record_id`, `old_values`, `new_values`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(298, 17, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":18,\"condition\":null,\"available_quantity\":18,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T14:33:15.000000Z\"}', '{\"quantity_on_hand\":13,\"available_quantity\":13,\"updated_at\":\"2026-03-27 18:02:59\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:02:59', '2026-03-27 11:02:59'),
(299, 17, 'create', 'inventory', 33, NULL, '{\"location_id\":\"3\",\"product_id\":39,\"quantity_on_hand\":0,\"available_quantity\":0,\"reorder_level\":0,\"updated_at\":\"2026-03-27 18:02:59\",\"created_at\":\"2026-03-27 18:02:59\",\"inventory_id\":33}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:02:59', '2026-03-27 11:02:59'),
(300, 17, 'update', 'inventory', 33, '{\"location_id\":\"3\",\"product_id\":39,\"quantity_on_hand\":0,\"available_quantity\":0,\"reorder_level\":0,\"updated_at\":\"2026-03-27T18:02:59.000000Z\",\"created_at\":\"2026-03-27T18:02:59.000000Z\",\"inventory_id\":33}', '{\"quantity_on_hand\":5,\"available_quantity\":5}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:02:59', '2026-03-27 11:02:59'),
(301, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:03:11', '2026-03-27 11:03:11'),
(302, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:03:16', '2026-03-27 11:03:16'),
(303, 3, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":12,\"condition\":null,\"available_quantity\":12,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T14:33:15.000000Z\"}', '{\"quantity_on_hand\":18,\"available_quantity\":18,\"updated_at\":\"2026-03-27 18:04:41\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:04:41', '2026-03-27 11:04:41'),
(304, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:07:32', '2026-03-27 11:07:32'),
(305, 14, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:07:39', '2026-03-27 11:07:39'),
(306, 14, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:44:21', '2026-03-27 11:44:21'),
(307, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 11:44:28', '2026-03-27 11:44:28'),
(308, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 16:38:08', '2026-03-27 16:38:08'),
(309, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 16:38:27', '2026-03-27 16:38:27'),
(310, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 16:38:33', '2026-03-27 16:38:33'),
(311, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 16:38:39', '2026-03-27 16:38:39'),
(312, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 16:38:54', '2026-03-27 16:38:54'),
(313, 14, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 16:39:00', '2026-03-27 16:39:00'),
(314, 14, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 16:58:52', '2026-03-27 16:58:52'),
(315, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 16:58:58', '2026-03-27 16:58:58'),
(316, 3, 'update', 'inventory', 28, '{\"inventory_id\":28,\"location_id\":1,\"product_id\":37,\"status_id\":null,\"quantity_on_hand\":12,\"condition\":null,\"available_quantity\":12,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T14:33:15.000000Z\"}', '{\"quantity_on_hand\":7,\"available_quantity\":7,\"updated_at\":\"2026-03-28 00:11:16\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 17:11:16', '2026-03-27 17:11:16'),
(317, 3, 'update', 'inventory', 23, '{\"inventory_id\":23,\"location_id\":1,\"product_id\":32,\"status_id\":null,\"quantity_on_hand\":30,\"condition\":null,\"available_quantity\":30,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T14:33:15.000000Z\"}', '{\"quantity_on_hand\":25,\"available_quantity\":25,\"updated_at\":\"2026-03-28 00:14:31\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 17:14:31', '2026-03-27 17:14:31'),
(318, 3, 'update', 'inventory', 23, '{\"inventory_id\":23,\"location_id\":1,\"product_id\":32,\"status_id\":null,\"quantity_on_hand\":25,\"condition\":null,\"available_quantity\":25,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-28T00:14:31.000000Z\"}', '{\"quantity_on_hand\":28,\"available_quantity\":28,\"updated_at\":\"2026-03-28 00:17:55\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 17:17:55', '2026-03-27 17:17:55'),
(319, 3, 'update', 'inventory', 23, '{\"inventory_id\":23,\"location_id\":1,\"product_id\":32,\"status_id\":null,\"quantity_on_hand\":28,\"condition\":null,\"available_quantity\":28,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-28T00:17:55.000000Z\"}', '{\"quantity_on_hand\":29,\"available_quantity\":29,\"updated_at\":\"2026-03-28 00:20:48\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 17:20:48', '2026-03-27 17:20:48'),
(323, 3, 'update', 'inventory', 23, '{\"inventory_id\":23,\"location_id\":1,\"product_id\":32,\"status_id\":null,\"quantity_on_hand\":29,\"condition\":null,\"available_quantity\":29,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-28T00:20:48.000000Z\"}', '{\"quantity_on_hand\":26,\"available_quantity\":26,\"updated_at\":\"2026-03-28 00:27:17\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 17:27:17', '2026-03-27 17:27:17'),
(324, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 18:49:11', '2026-03-27 18:49:11'),
(325, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 18:53:19', '2026-03-27 18:53:19'),
(326, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 18:53:31', '2026-03-27 18:53:31'),
(327, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 18:53:41', '2026-03-27 18:53:41'),
(328, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:07:33', '2026-03-27 19:07:33'),
(329, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:07:41', '2026-03-27 19:07:41'),
(330, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:08:28', '2026-03-27 19:08:28'),
(331, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:08:37', '2026-03-27 19:08:37'),
(332, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:18:34', '2026-03-27 19:18:34'),
(333, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:19:02', '2026-03-27 19:19:02'),
(334, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:19:20', '2026-03-27 19:19:20'),
(335, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:19:36', '2026-03-27 19:19:36'),
(336, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:20:51', '2026-03-27 19:20:51'),
(337, 14, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:21:03', '2026-03-27 19:21:03'),
(338, 14, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:22:36', '2026-03-27 19:22:36'),
(339, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:22:51', '2026-03-27 19:22:51'),
(340, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:30:06', '2026-03-27 19:30:06'),
(341, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:30:17', '2026-03-27 19:30:17'),
(342, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:30:48', '2026-03-27 19:30:48'),
(343, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:30:55', '2026-03-27 19:30:55'),
(344, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:32:30', '2026-03-27 19:32:30'),
(345, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:32:39', '2026-03-27 19:32:39'),
(346, 17, 'update', 'inventory', 12, '{\"inventory_id\":12,\"location_id\":1,\"product_id\":21,\"status_id\":null,\"quantity_on_hand\":18,\"condition\":null,\"available_quantity\":18,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T14:33:15.000000Z\"}', '{\"quantity_on_hand\":19,\"available_quantity\":19,\"updated_at\":\"2026-03-28 02:34:27\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:34:27', '2026-03-27 19:34:27'),
(347, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:35:40', '2026-03-27 19:35:40'),
(348, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:35:55', '2026-03-27 19:35:55'),
(349, 3, 'update', 'inventory', 12, '{\"inventory_id\":12,\"location_id\":1,\"product_id\":21,\"status_id\":null,\"quantity_on_hand\":19,\"condition\":null,\"available_quantity\":19,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-28T02:34:27.000000Z\"}', '{\"quantity_on_hand\":20,\"available_quantity\":20,\"updated_at\":\"2026-03-28 02:37:48\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:37:48', '2026-03-27 19:37:48'),
(350, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:46:22', '2026-03-27 19:46:22'),
(351, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:46:33', '2026-03-27 19:46:33'),
(352, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:10:49', '2026-03-27 21:10:49'),
(353, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:11:06', '2026-03-27 21:11:06'),
(354, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:14:10', '2026-03-27 21:14:10'),
(355, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:14:59', '2026-03-27 21:14:59'),
(356, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:15:09', '2026-03-27 21:15:09'),
(357, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:18:12', '2026-03-27 21:18:12'),
(358, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:19:38', '2026-03-27 21:19:38'),
(359, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:19:57', '2026-03-27 21:19:57'),
(360, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:20:41', '2026-03-27 21:20:41'),
(361, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:20:51', '2026-03-27 21:20:51'),
(362, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:31:49', '2026-03-27 21:31:49'),
(363, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:32:00', '2026-03-27 21:32:00'),
(364, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:32:17', '2026-03-27 21:32:17'),
(365, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:32:36', '2026-03-27 21:32:36'),
(366, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:33:32', '2026-03-27 21:33:32'),
(367, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:33:43', '2026-03-27 21:33:43'),
(368, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:36:20', '2026-03-27 21:36:20'),
(369, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:36:42', '2026-03-27 21:36:42'),
(370, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:29:36', '2026-03-27 22:29:36'),
(371, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:31:18', '2026-03-27 22:31:18'),
(372, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:31:37', '2026-03-27 22:31:37'),
(373, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:32:14', '2026-03-27 22:32:14'),
(374, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:32:41', '2026-03-27 22:32:41'),
(375, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:19:22', '2026-03-27 23:19:22'),
(376, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:58:26', '2026-03-27 23:58:26'),
(377, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:58:39', '2026-03-27 23:58:39'),
(378, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:58:59', '2026-03-27 23:58:59'),
(379, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:59:20', '2026-03-27 23:59:20'),
(380, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:00:01', '2026-03-28 00:00:01'),
(381, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:00:27', '2026-03-28 00:00:27'),
(382, 15, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:06:02', '2026-03-28 00:06:02'),
(383, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:06:20', '2026-03-28 00:06:20'),
(384, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:12:42', '2026-03-28 00:12:42'),
(385, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:12:53', '2026-03-28 00:12:53'),
(386, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:13:09', '2026-03-28 00:13:09'),
(387, 16, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:13:19', '2026-03-28 00:13:19'),
(388, 16, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:13:50', '2026-03-28 00:13:50'),
(389, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:14:05', '2026-03-28 00:14:05'),
(390, 15, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:29:01', '2026-03-28 00:29:01'),
(391, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:29:13', '2026-03-28 00:29:13'),
(392, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:30:43', '2026-03-28 00:30:43'),
(393, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:34:24', '2026-03-28 00:34:24'),
(394, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 21:00:28', '2026-03-28 21:00:28'),
(395, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 21:13:44', '2026-03-28 21:13:44'),
(396, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 22:26:25', '2026-03-28 22:26:25'),
(397, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 23:02:07', '2026-03-28 23:02:07'),
(398, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 23:02:31', '2026-03-28 23:02:31'),
(399, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 23:14:21', '2026-03-28 23:14:21'),
(400, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 23:14:28', '2026-03-28 23:14:28'),
(401, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 02:59:29', '2026-03-29 02:59:29'),
(402, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 02:59:42', '2026-03-29 02:59:42'),
(403, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 05:55:49', '2026-03-29 05:55:49'),
(404, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 05:56:00', '2026-03-29 05:56:00'),
(405, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 06:52:41', '2026-03-29 06:52:41'),
(406, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 07:09:34', '2026-03-29 07:09:34'),
(407, 3, 'logout', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 07:09:55', '2026-03-29 07:09:55'),
(408, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 07:10:09', '2026-03-29 07:10:09'),
(409, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 07:10:44', '2026-03-29 07:10:44'),
(410, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 09:02:22', '2026-03-29 09:02:22'),
(411, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:02:51', '2026-03-29 09:02:51'),
(412, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:03:07', '2026-03-29 09:03:07'),
(413, 3, 'logout', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:05:12', '2026-03-29 09:05:12'),
(414, 17, 'login', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:05:28', '2026-03-29 09:05:28'),
(415, 17, 'logout', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:05:43', '2026-03-29 09:05:43'),
(416, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:05:54', '2026-03-29 09:05:54'),
(417, 3, 'update', 'inventory', 12, '{\"inventory_id\":12,\"location_id\":1,\"product_id\":21,\"status_id\":null,\"quantity_on_hand\":20,\"condition\":null,\"available_quantity\":20,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-28T02:37:48.000000Z\"}', '{\"quantity_on_hand\":21,\"available_quantity\":21,\"updated_at\":\"2026-03-29 16:06:32\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 09:06:32', '2026-03-29 09:06:32'),
(418, 3, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":13,\"condition\":null,\"available_quantity\":13,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T18:02:59.000000Z\"}', '{\"quantity_on_hand\":14,\"available_quantity\":14,\"updated_at\":\"2026-03-29 16:06:53\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 09:06:53', '2026-03-29 09:06:53'),
(419, 17, 'login', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 09:31:15', '2026-03-29 09:31:15'),
(420, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:41:40', '2026-03-29 09:41:40'),
(421, 3, 'login', NULL, NULL, NULL, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 10:28:25', '2026-03-29 10:28:25'),
(422, 17, 'logout', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:25:33', '2026-03-29 16:25:33'),
(423, 16, 'login', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:25:49', '2026-03-29 16:25:49'),
(424, 16, 'logout', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:26:33', '2026-03-29 16:26:33'),
(425, 15, 'login', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:26:43', '2026-03-29 16:26:43'),
(426, 15, 'logout', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:27:34', '2026-03-29 16:27:34'),
(427, 17, 'login', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:27:44', '2026-03-29 16:27:44'),
(428, 17, 'create', 'inventory', 37, NULL, '{\"location_id\":1,\"product_id\":42,\"quantity_on_hand\":0,\"available_quantity\":0,\"reorder_level\":0,\"updated_at\":\"2026-03-30 00:07:48\",\"created_at\":\"2026-03-30 00:07:48\",\"inventory_id\":37}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:07:48', '2026-03-29 17:07:48'),
(429, 17, 'update', 'inventory', 37, '{\"location_id\":1,\"product_id\":42,\"quantity_on_hand\":0,\"available_quantity\":0,\"reorder_level\":0,\"updated_at\":\"2026-03-30T00:07:48.000000Z\",\"created_at\":\"2026-03-30T00:07:48.000000Z\",\"inventory_id\":37}', '{\"quantity_on_hand\":1,\"available_quantity\":1}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:07:48', '2026-03-29 17:07:48'),
(430, 17, 'update', 'inventory', 37, '{\"inventory_id\":37,\"location_id\":1,\"product_id\":42,\"status_id\":null,\"quantity_on_hand\":1,\"condition\":null,\"available_quantity\":1,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T00:07:48.000000Z\",\"updated_at\":\"2026-03-30T00:07:48.000000Z\"}', '{\"quantity_on_hand\":2,\"available_quantity\":2,\"updated_at\":\"2026-03-30 00:07:50\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:07:50', '2026-03-29 17:07:50'),
(431, 17, 'update', 'inventory', 37, '{\"inventory_id\":37,\"location_id\":1,\"product_id\":42,\"status_id\":null,\"quantity_on_hand\":2,\"condition\":null,\"available_quantity\":2,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T00:07:48.000000Z\",\"updated_at\":\"2026-03-30T00:07:50.000000Z\"}', '{\"quantity_on_hand\":3,\"available_quantity\":3,\"updated_at\":\"2026-03-30 00:07:51\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:07:51', '2026-03-29 17:07:51'),
(432, 17, 'update', 'inventory', 37, '{\"inventory_id\":37,\"location_id\":1,\"product_id\":42,\"status_id\":null,\"quantity_on_hand\":3,\"condition\":null,\"available_quantity\":3,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T00:07:48.000000Z\",\"updated_at\":\"2026-03-30T00:07:51.000000Z\"}', '{\"quantity_on_hand\":2,\"available_quantity\":2,\"updated_at\":\"2026-03-30 00:19:13\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:19:13', '2026-03-29 17:19:13'),
(433, 17, 'update', 'inventory', 37, '{\"inventory_id\":37,\"location_id\":1,\"product_id\":42,\"status_id\":null,\"quantity_on_hand\":2,\"condition\":null,\"available_quantity\":2,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T00:07:48.000000Z\",\"updated_at\":\"2026-03-30T00:19:13.000000Z\"}', '{\"quantity_on_hand\":1,\"available_quantity\":1,\"updated_at\":\"2026-03-30 00:19:14\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:19:14', '2026-03-29 17:19:14'),
(434, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":30,\"condition\":null,\"available_quantity\":30,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T14:33:15.000000Z\"}', '{\"quantity_on_hand\":29,\"available_quantity\":29,\"updated_at\":\"2026-03-30 00:21:27\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:21:27', '2026-03-29 17:21:27'),
(435, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":29,\"condition\":null,\"available_quantity\":29,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:21:27.000000Z\"}', '{\"quantity_on_hand\":28,\"available_quantity\":28,\"updated_at\":\"2026-03-30 00:21:28\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:21:28', '2026-03-29 17:21:28'),
(436, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":28,\"condition\":null,\"available_quantity\":28,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:21:28.000000Z\"}', '{\"quantity_on_hand\":27,\"available_quantity\":27,\"updated_at\":\"2026-03-30 00:33:09\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:09', '2026-03-29 17:33:09'),
(437, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":27,\"condition\":null,\"available_quantity\":27,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:09.000000Z\"}', '{\"quantity_on_hand\":26,\"available_quantity\":26,\"updated_at\":\"2026-03-30 00:33:10\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:10', '2026-03-29 17:33:10'),
(438, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":26,\"condition\":null,\"available_quantity\":26,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:10.000000Z\"}', '{\"quantity_on_hand\":25,\"available_quantity\":25,\"updated_at\":\"2026-03-30 00:33:11\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:11', '2026-03-29 17:33:11'),
(439, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":25,\"condition\":null,\"available_quantity\":25,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:11.000000Z\"}', '{\"quantity_on_hand\":24,\"available_quantity\":24,\"updated_at\":\"2026-03-30 00:33:12\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:12', '2026-03-29 17:33:12'),
(440, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":24,\"condition\":null,\"available_quantity\":24,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:12.000000Z\"}', '{\"quantity_on_hand\":23,\"available_quantity\":23}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:12', '2026-03-29 17:33:12'),
(441, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":23,\"condition\":null,\"available_quantity\":23,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:12.000000Z\"}', '{\"quantity_on_hand\":22,\"available_quantity\":22,\"updated_at\":\"2026-03-30 00:33:14\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:14', '2026-03-29 17:33:14'),
(442, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":22,\"condition\":null,\"available_quantity\":22,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:14.000000Z\"}', '{\"quantity_on_hand\":21,\"available_quantity\":21,\"updated_at\":\"2026-03-30 00:33:16\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:16', '2026-03-29 17:33:16'),
(443, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":21,\"condition\":null,\"available_quantity\":21,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:16.000000Z\"}', '{\"quantity_on_hand\":20,\"available_quantity\":20}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:16', '2026-03-29 17:33:16'),
(444, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":20,\"condition\":null,\"available_quantity\":20,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:16.000000Z\"}', '{\"quantity_on_hand\":19,\"available_quantity\":19,\"updated_at\":\"2026-03-30 00:33:17\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:17', '2026-03-29 17:33:17'),
(445, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":19,\"condition\":null,\"available_quantity\":19,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:17.000000Z\"}', '{\"quantity_on_hand\":18,\"available_quantity\":18,\"updated_at\":\"2026-03-30 00:33:18\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:18', '2026-03-29 17:33:18'),
(446, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":18,\"condition\":null,\"available_quantity\":18,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:18.000000Z\"}', '{\"quantity_on_hand\":17,\"available_quantity\":17,\"updated_at\":\"2026-03-30 00:33:19\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:19', '2026-03-29 17:33:19'),
(447, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":17,\"condition\":null,\"available_quantity\":17,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:19.000000Z\"}', '{\"quantity_on_hand\":16,\"available_quantity\":16,\"updated_at\":\"2026-03-30 00:33:20\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:20', '2026-03-29 17:33:20'),
(448, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":16,\"condition\":null,\"available_quantity\":16,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:20.000000Z\"}', '{\"quantity_on_hand\":15,\"available_quantity\":15,\"updated_at\":\"2026-03-30 00:33:21\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:21', '2026-03-29 17:33:21'),
(449, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":15,\"condition\":null,\"available_quantity\":15,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:21.000000Z\"}', '{\"quantity_on_hand\":14,\"available_quantity\":14,\"updated_at\":\"2026-03-30 00:33:22\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:22', '2026-03-29 17:33:22'),
(450, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":14,\"condition\":null,\"available_quantity\":14,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:22.000000Z\"}', '{\"quantity_on_hand\":13,\"available_quantity\":13}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:22', '2026-03-29 17:33:22'),
(451, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":13,\"condition\":null,\"available_quantity\":13,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:22.000000Z\"}', '{\"quantity_on_hand\":12,\"available_quantity\":12,\"updated_at\":\"2026-03-30 00:33:24\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:24', '2026-03-29 17:33:24'),
(452, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":12,\"condition\":null,\"available_quantity\":12,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:24.000000Z\"}', '{\"quantity_on_hand\":11,\"available_quantity\":11,\"updated_at\":\"2026-03-30 00:33:25\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:25', '2026-03-29 17:33:25'),
(453, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":11,\"condition\":null,\"available_quantity\":11,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:25.000000Z\"}', '{\"quantity_on_hand\":10,\"available_quantity\":10,\"updated_at\":\"2026-03-30 00:33:26\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:26', '2026-03-29 17:33:26'),
(454, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":10,\"condition\":null,\"available_quantity\":10,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:26.000000Z\"}', '{\"quantity_on_hand\":9,\"available_quantity\":9}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:26', '2026-03-29 17:33:26'),
(455, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":9,\"condition\":null,\"available_quantity\":9,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:26.000000Z\"}', '{\"quantity_on_hand\":8,\"available_quantity\":8,\"updated_at\":\"2026-03-30 00:33:27\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:27', '2026-03-29 17:33:27'),
(456, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":8,\"condition\":null,\"available_quantity\":8,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:27.000000Z\"}', '{\"quantity_on_hand\":7,\"available_quantity\":7,\"updated_at\":\"2026-03-30 00:33:28\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:28', '2026-03-29 17:33:28');
INSERT INTO `audit_trail` (`audit_id`, `user_id`, `action`, `table_name`, `record_id`, `old_values`, `new_values`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(457, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":7,\"condition\":null,\"available_quantity\":7,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:28.000000Z\"}', '{\"quantity_on_hand\":6,\"available_quantity\":6,\"updated_at\":\"2026-03-30 00:33:29\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:29', '2026-03-29 17:33:29'),
(458, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":6,\"condition\":null,\"available_quantity\":6,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:29.000000Z\"}', '{\"quantity_on_hand\":5,\"available_quantity\":5,\"updated_at\":\"2026-03-30 00:33:30\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:30', '2026-03-29 17:33:30'),
(459, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":5,\"condition\":null,\"available_quantity\":5,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:30.000000Z\"}', '{\"quantity_on_hand\":4,\"available_quantity\":4,\"updated_at\":\"2026-03-30 00:33:31\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:31', '2026-03-29 17:33:31'),
(460, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":4,\"condition\":null,\"available_quantity\":4,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:31.000000Z\"}', '{\"quantity_on_hand\":3,\"available_quantity\":3,\"updated_at\":\"2026-03-30 00:33:32\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:32', '2026-03-29 17:33:32'),
(461, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":3,\"condition\":null,\"available_quantity\":3,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:32.000000Z\"}', '{\"quantity_on_hand\":2,\"available_quantity\":2,\"updated_at\":\"2026-03-30 00:33:33\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:33:33', '2026-03-29 17:33:33'),
(462, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":2,\"condition\":null,\"available_quantity\":2,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:33:33.000000Z\"}', '{\"quantity_on_hand\":1,\"available_quantity\":1,\"updated_at\":\"2026-03-30 00:41:42\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:41:42', '2026-03-29 17:41:42'),
(463, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":1,\"condition\":null,\"available_quantity\":1,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:41:42.000000Z\"}', '{\"quantity_on_hand\":0,\"available_quantity\":0,\"updated_at\":\"2026-03-30 00:41:43\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:41:43', '2026-03-29 17:41:43'),
(464, 17, 'update', 'inventory', 29, '{\"inventory_id\":29,\"location_id\":1,\"product_id\":38,\"status_id\":null,\"quantity_on_hand\":30,\"condition\":null,\"available_quantity\":30,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T14:33:15.000000Z\"}', '{\"quantity_on_hand\":29,\"available_quantity\":29,\"updated_at\":\"2026-03-30 00:42:14\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:42:14', '2026-03-29 17:42:14'),
(465, 17, 'update', 'inventory', 29, '{\"inventory_id\":29,\"location_id\":1,\"product_id\":38,\"status_id\":null,\"quantity_on_hand\":29,\"condition\":null,\"available_quantity\":29,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:42:14.000000Z\"}', '{\"quantity_on_hand\":28,\"available_quantity\":28,\"updated_at\":\"2026-03-30 00:42:15\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:42:15', '2026-03-29 17:42:15'),
(466, 17, 'update', 'inventory', 29, '{\"inventory_id\":29,\"location_id\":1,\"product_id\":38,\"status_id\":null,\"quantity_on_hand\":28,\"condition\":null,\"available_quantity\":28,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:42:15.000000Z\"}', '{\"quantity_on_hand\":27,\"available_quantity\":27,\"updated_at\":\"2026-03-30 00:42:19\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:42:19', '2026-03-29 17:42:19'),
(467, 17, 'update', 'inventory', 29, '{\"inventory_id\":29,\"location_id\":1,\"product_id\":38,\"status_id\":null,\"quantity_on_hand\":27,\"condition\":null,\"available_quantity\":27,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:42:19.000000Z\"}', '{\"quantity_on_hand\":25,\"available_quantity\":25,\"updated_at\":\"2026-03-30 00:43:06\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:43:06', '2026-03-29 17:43:06'),
(468, 17, 'update', 'inventory', 29, '{\"inventory_id\":29,\"location_id\":1,\"product_id\":38,\"status_id\":null,\"quantity_on_hand\":25,\"condition\":null,\"available_quantity\":25,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:43:06.000000Z\"}', '{\"quantity_on_hand\":24,\"available_quantity\":24}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:43:06', '2026-03-29 17:43:06'),
(469, 17, 'update', 'inventory', 29, '{\"inventory_id\":29,\"location_id\":1,\"product_id\":38,\"status_id\":null,\"quantity_on_hand\":24,\"condition\":null,\"available_quantity\":24,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:43:06.000000Z\"}', '{\"quantity_on_hand\":23,\"available_quantity\":23,\"updated_at\":\"2026-03-30 00:43:18\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:43:18', '2026-03-29 17:43:18'),
(470, 17, 'update', 'inventory', 29, '{\"inventory_id\":29,\"location_id\":1,\"product_id\":38,\"status_id\":null,\"quantity_on_hand\":23,\"condition\":null,\"available_quantity\":23,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:43:18.000000Z\"}', '{\"quantity_on_hand\":22,\"available_quantity\":22,\"updated_at\":\"2026-03-30 00:43:19\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:43:19', '2026-03-29 17:43:19'),
(471, 17, 'update', 'inventory', 29, '{\"inventory_id\":29,\"location_id\":1,\"product_id\":38,\"status_id\":null,\"quantity_on_hand\":22,\"condition\":null,\"available_quantity\":22,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:43:19.000000Z\"}', '{\"quantity_on_hand\":21,\"available_quantity\":21,\"updated_at\":\"2026-03-30 00:43:20\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 17:43:20', '2026-03-29 17:43:20'),
(472, 17, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":14,\"condition\":null,\"available_quantity\":14,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-29T16:06:53.000000Z\"}', '{\"quantity_on_hand\":13,\"available_quantity\":13,\"updated_at\":\"2026-03-30 01:02:54\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 18:02:54', '2026-03-29 18:02:54'),
(473, 17, 'login', NULL, NULL, NULL, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 18:31:53', '2026-03-29 18:31:53'),
(474, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 18:32:08', '2026-03-29 18:32:08'),
(475, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":18,\"condition\":null,\"available_quantity\":18,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T18:04:41.000000Z\"}', '{\"quantity_on_hand\":17,\"available_quantity\":17,\"updated_at\":\"2026-03-30 01:44:43\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 18:44:43', '2026-03-29 18:44:43'),
(476, 17, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":13,\"condition\":null,\"available_quantity\":13,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T01:02:54.000000Z\"}', '{\"quantity_on_hand\":12,\"available_quantity\":12,\"updated_at\":\"2026-03-30 01:45:13\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 18:45:13', '2026-03-29 18:45:13'),
(477, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":0,\"condition\":null,\"available_quantity\":0,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T00:41:43.000000Z\"}', '{\"quantity_on_hand\":1,\"available_quantity\":1,\"updated_at\":\"2026-03-30 01:45:40\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 18:45:40', '2026-03-29 18:45:40'),
(478, 17, 'update', 'inventory', 32, '{\"inventory_id\":32,\"location_id\":1,\"product_id\":41,\"status_id\":null,\"quantity_on_hand\":1,\"condition\":null,\"available_quantity\":1,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T01:45:40.000000Z\"}', '{\"quantity_on_hand\":2,\"available_quantity\":2,\"updated_at\":\"2026-03-30 01:45:43\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 18:45:43', '2026-03-29 18:45:43'),
(479, 3, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 19:05:16', '2026-03-29 19:05:16'),
(480, 17, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 19:05:25', '2026-03-29 19:05:25'),
(481, 17, 'logout', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 19:07:45', '2026-03-29 19:07:45'),
(482, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 19:07:52', '2026-03-29 19:07:52'),
(483, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":17,\"condition\":null,\"available_quantity\":17,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T01:44:43.000000Z\"}', '{\"quantity_on_hand\":16,\"available_quantity\":16,\"updated_at\":\"2026-03-30 02:08:14\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:08:14', '2026-03-29 19:08:14'),
(505, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":16,\"condition\":null,\"available_quantity\":16,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:08:14.000000Z\"}', '{\"quantity_on_hand\":15,\"available_quantity\":15,\"updated_at\":\"2026-03-30 02:12:04\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:04', '2026-03-29 19:12:04'),
(506, 17, 'create', 'inventory', 45, NULL, '{\"location_id\":3,\"product_id\":40,\"quantity_on_hand\":0,\"available_quantity\":0,\"reorder_level\":0,\"updated_at\":\"2026-03-30 02:12:04\",\"created_at\":\"2026-03-30 02:12:04\",\"inventory_id\":45}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:04', '2026-03-29 19:12:04'),
(507, 17, 'update', 'inventory', 45, '{\"location_id\":3,\"product_id\":40,\"quantity_on_hand\":0,\"available_quantity\":0,\"reorder_level\":0,\"updated_at\":\"2026-03-30T02:12:04.000000Z\",\"created_at\":\"2026-03-30T02:12:04.000000Z\",\"inventory_id\":45}', '{\"quantity_on_hand\":1,\"available_quantity\":1}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:04', '2026-03-29 19:12:04'),
(508, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":15,\"condition\":null,\"available_quantity\":15,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:12:04.000000Z\"}', '{\"quantity_on_hand\":14,\"available_quantity\":14,\"updated_at\":\"2026-03-30 02:12:06\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:06', '2026-03-29 19:12:06'),
(509, 17, 'update', 'inventory', 45, '{\"inventory_id\":45,\"location_id\":3,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":1,\"condition\":null,\"available_quantity\":1,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T02:12:04.000000Z\",\"updated_at\":\"2026-03-30T02:12:04.000000Z\"}', '{\"quantity_on_hand\":2,\"available_quantity\":2,\"updated_at\":\"2026-03-30 02:12:06\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:06', '2026-03-29 19:12:06'),
(510, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":14,\"condition\":null,\"available_quantity\":14,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:12:06.000000Z\"}', '{\"quantity_on_hand\":13,\"available_quantity\":13,\"updated_at\":\"2026-03-30 02:12:08\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:08', '2026-03-29 19:12:08'),
(511, 17, 'update', 'inventory', 45, '{\"inventory_id\":45,\"location_id\":3,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":2,\"condition\":null,\"available_quantity\":2,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T02:12:04.000000Z\",\"updated_at\":\"2026-03-30T02:12:06.000000Z\"}', '{\"quantity_on_hand\":3,\"available_quantity\":3,\"updated_at\":\"2026-03-30 02:12:08\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:08', '2026-03-29 19:12:08'),
(512, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":13,\"condition\":null,\"available_quantity\":13,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:12:08.000000Z\"}', '{\"quantity_on_hand\":12,\"available_quantity\":12,\"updated_at\":\"2026-03-30 02:12:10\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:10', '2026-03-29 19:12:10'),
(513, 17, 'update', 'inventory', 45, '{\"inventory_id\":45,\"location_id\":3,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":3,\"condition\":null,\"available_quantity\":3,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T02:12:04.000000Z\",\"updated_at\":\"2026-03-30T02:12:08.000000Z\"}', '{\"quantity_on_hand\":4,\"available_quantity\":4,\"updated_at\":\"2026-03-30 02:12:10\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:10', '2026-03-29 19:12:10'),
(514, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":12,\"condition\":null,\"available_quantity\":12,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:12:10.000000Z\"}', '{\"quantity_on_hand\":11,\"available_quantity\":11,\"updated_at\":\"2026-03-30 02:12:12\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:12', '2026-03-29 19:12:12'),
(515, 17, 'update', 'inventory', 45, '{\"inventory_id\":45,\"location_id\":3,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":4,\"condition\":null,\"available_quantity\":4,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T02:12:04.000000Z\",\"updated_at\":\"2026-03-30T02:12:10.000000Z\"}', '{\"quantity_on_hand\":5,\"available_quantity\":5,\"updated_at\":\"2026-03-30 02:12:12\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:12', '2026-03-29 19:12:12'),
(516, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":11,\"condition\":null,\"available_quantity\":11,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:12:12.000000Z\"}', '{\"quantity_on_hand\":10,\"available_quantity\":10,\"updated_at\":\"2026-03-30 02:12:14\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:14', '2026-03-29 19:12:14'),
(517, 17, 'update', 'inventory', 45, '{\"inventory_id\":45,\"location_id\":3,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":5,\"condition\":null,\"available_quantity\":5,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T02:12:04.000000Z\",\"updated_at\":\"2026-03-30T02:12:12.000000Z\"}', '{\"quantity_on_hand\":6,\"available_quantity\":6,\"updated_at\":\"2026-03-30 02:12:14\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:14', '2026-03-29 19:12:14'),
(518, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":10,\"condition\":null,\"available_quantity\":10,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:12:14.000000Z\"}', '{\"quantity_on_hand\":9,\"available_quantity\":9,\"updated_at\":\"2026-03-30 02:12:16\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:16', '2026-03-29 19:12:16'),
(519, 17, 'update', 'inventory', 45, '{\"inventory_id\":45,\"location_id\":3,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":6,\"condition\":null,\"available_quantity\":6,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T02:12:04.000000Z\",\"updated_at\":\"2026-03-30T02:12:14.000000Z\"}', '{\"quantity_on_hand\":7,\"available_quantity\":7,\"updated_at\":\"2026-03-30 02:12:16\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:16', '2026-03-29 19:12:16'),
(520, 17, 'update', 'inventory', 31, '{\"inventory_id\":31,\"location_id\":1,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":9,\"condition\":null,\"available_quantity\":9,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:12:16.000000Z\"}', '{\"quantity_on_hand\":8,\"available_quantity\":8,\"updated_at\":\"2026-03-30 02:12:19\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:19', '2026-03-29 19:12:19'),
(521, 17, 'update', 'inventory', 45, '{\"inventory_id\":45,\"location_id\":3,\"product_id\":40,\"status_id\":null,\"quantity_on_hand\":7,\"condition\":null,\"available_quantity\":7,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T02:12:04.000000Z\",\"updated_at\":\"2026-03-30T02:12:16.000000Z\"}', '{\"quantity_on_hand\":8,\"available_quantity\":8,\"updated_at\":\"2026-03-30 02:12:19\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:19', '2026-03-29 19:12:19'),
(522, 17, 'update', 'inventory', 26, '{\"inventory_id\":26,\"location_id\":1,\"product_id\":35,\"status_id\":null,\"quantity_on_hand\":30,\"condition\":null,\"available_quantity\":30,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-27T14:33:15.000000Z\"}', '{\"quantity_on_hand\":29,\"available_quantity\":29,\"updated_at\":\"2026-03-30 02:12:53\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:53', '2026-03-29 19:12:53'),
(523, 17, 'create', 'inventory', 46, NULL, '{\"location_id\":3,\"product_id\":35,\"quantity_on_hand\":0,\"available_quantity\":0,\"reorder_level\":0,\"updated_at\":\"2026-03-30 02:12:53\",\"created_at\":\"2026-03-30 02:12:53\",\"inventory_id\":46}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:53', '2026-03-29 19:12:53'),
(524, 17, 'update', 'inventory', 46, '{\"location_id\":3,\"product_id\":35,\"quantity_on_hand\":0,\"available_quantity\":0,\"reorder_level\":0,\"updated_at\":\"2026-03-30T02:12:53.000000Z\",\"created_at\":\"2026-03-30T02:12:53.000000Z\",\"inventory_id\":46}', '{\"quantity_on_hand\":1,\"available_quantity\":1}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:53', '2026-03-29 19:12:53'),
(525, 17, 'update', 'inventory', 26, '{\"inventory_id\":26,\"location_id\":1,\"product_id\":35,\"status_id\":null,\"quantity_on_hand\":29,\"condition\":null,\"available_quantity\":29,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T02:12:53.000000Z\"}', '{\"quantity_on_hand\":28,\"available_quantity\":28,\"updated_at\":\"2026-03-30 02:12:55\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:55', '2026-03-29 19:12:55'),
(526, 17, 'update', 'inventory', 46, '{\"inventory_id\":46,\"location_id\":3,\"product_id\":35,\"status_id\":null,\"quantity_on_hand\":1,\"condition\":null,\"available_quantity\":1,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T02:12:53.000000Z\",\"updated_at\":\"2026-03-30T02:12:53.000000Z\"}', '{\"quantity_on_hand\":2,\"available_quantity\":2,\"updated_at\":\"2026-03-30 02:12:55\"}', '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 19:12:55', '2026-03-29 19:12:55'),
(527, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 21:08:27', '2026-03-29 21:08:27'),
(528, 17, 'login', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 22:04:30', '2026-03-29 22:04:30'),
(529, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 22:05:51', '2026-03-29 22:05:51'),
(530, 17, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":12,\"condition\":null,\"available_quantity\":12,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T01:45:13.000000Z\"}', '{\"quantity_on_hand\":11,\"available_quantity\":11,\"updated_at\":\"2026-03-30 05:50:04\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 22:50:04', '2026-03-29 22:50:04'),
(531, 17, 'update', 'inventory', 33, '{\"inventory_id\":33,\"location_id\":3,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":5,\"condition\":null,\"available_quantity\":5,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-27T18:02:59.000000Z\",\"updated_at\":\"2026-03-27T18:02:59.000000Z\"}', '{\"quantity_on_hand\":6,\"available_quantity\":6,\"updated_at\":\"2026-03-30 05:50:04\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 22:50:04', '2026-03-29 22:50:04'),
(532, 17, 'logout', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:54:39', '2026-03-29 23:54:39'),
(533, 3, 'login', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:55:03', '2026-03-29 23:55:03'),
(534, 3, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":11,\"condition\":null,\"available_quantity\":11,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T05:50:04.000000Z\"}', '{\"quantity_on_hand\":10,\"available_quantity\":10,\"updated_at\":\"2026-03-30 06:56:04\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:56:04', '2026-03-29 23:56:04'),
(535, 3, 'update', 'inventory', 37, '{\"inventory_id\":37,\"location_id\":1,\"product_id\":42,\"status_id\":null,\"quantity_on_hand\":1,\"condition\":null,\"available_quantity\":1,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T00:07:48.000000Z\",\"updated_at\":\"2026-03-30T00:19:14.000000Z\"}', '{\"quantity_on_hand\":2,\"available_quantity\":2,\"updated_at\":\"2026-03-30 06:56:35\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:56:35', '2026-03-29 23:56:35'),
(536, 3, 'update', 'inventory', 37, '{\"inventory_id\":37,\"location_id\":1,\"product_id\":42,\"status_id\":null,\"quantity_on_hand\":2,\"condition\":null,\"available_quantity\":2,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T00:07:48.000000Z\",\"updated_at\":\"2026-03-30T06:56:35.000000Z\"}', '{\"quantity_on_hand\":3,\"available_quantity\":3,\"updated_at\":\"2026-03-30 06:56:38\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:56:38', '2026-03-29 23:56:38'),
(537, 3, 'logout', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:57:07', '2026-03-29 23:57:07'),
(538, 17, 'login', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:57:19', '2026-03-29 23:57:19'),
(539, 17, 'logout', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:58:12', '2026-03-29 23:58:12'),
(540, 17, 'login', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:58:30', '2026-03-29 23:58:30'),
(541, 17, 'update', 'inventory', 37, '{\"inventory_id\":37,\"location_id\":1,\"product_id\":42,\"status_id\":null,\"quantity_on_hand\":3,\"condition\":null,\"available_quantity\":3,\"reorder_level\":0,\"last_updated\":null,\"created_at\":\"2026-03-30T00:07:48.000000Z\",\"updated_at\":\"2026-03-30T06:56:38.000000Z\"}', '{\"quantity_on_hand\":4,\"available_quantity\":4,\"updated_at\":\"2026-03-30 06:59:59\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:59:59', '2026-03-29 23:59:59'),
(542, 17, 'logout', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-30 00:09:03', '2026-03-30 00:09:03'),
(543, 17, 'login', NULL, NULL, NULL, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-30 00:09:24', '2026-03-30 00:09:24'),
(544, 17, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":10,\"condition\":null,\"available_quantity\":10,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T06:56:04.000000Z\"}', '{\"quantity_on_hand\":11,\"available_quantity\":11,\"updated_at\":\"2026-03-30 07:24:29\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-30 00:24:29', '2026-03-30 00:24:29'),
(545, 17, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":11,\"condition\":null,\"available_quantity\":11,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T07:24:29.000000Z\"}', '{\"quantity_on_hand\":12,\"available_quantity\":12,\"updated_at\":\"2026-03-30 07:24:32\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-30 00:24:32', '2026-03-30 00:24:32'),
(546, 17, 'update', 'inventory', 30, '{\"inventory_id\":30,\"location_id\":1,\"product_id\":39,\"status_id\":null,\"quantity_on_hand\":12,\"condition\":null,\"available_quantity\":12,\"reorder_level\":20,\"last_updated\":\"2026-03-27 14:33:15\",\"created_at\":\"2026-03-27T14:33:15.000000Z\",\"updated_at\":\"2026-03-30T07:24:32.000000Z\"}', '{\"quantity_on_hand\":13,\"available_quantity\":13,\"updated_at\":\"2026-03-30 07:25:18\"}', '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-30 00:25:18', '2026-03-30 00:25:18'),
(547, 3, 'login', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-01 21:54:54', '2026-04-01 21:54:54');

-- --------------------------------------------------------

--
-- Table structure for table `barcode_scans`
--

CREATE TABLE `barcode_scans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `barcode` varchar(191) NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `scan_mode` varchar(64) NOT NULL,
  `scanned_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `barcode_scans`
--

INSERT INTO `barcode_scans` (`id`, `user_id`, `barcode`, `product_id`, `scan_mode`, `scanned_at`, `created_at`, `updated_at`) VALUES
(1, 17, '13251423', 21, 'receive-po', '2026-03-27 19:34:22', '2026-03-27 19:34:22', '2026-03-27 19:34:22'),
(2, 3, '13251423', 21, 'receive-po', '2026-03-27 19:37:43', '2026-03-27 19:37:43', '2026-03-27 19:37:43'),
(3, 3, '13251423', 21, 'issue-out', '2026-03-27 21:24:06', '2026-03-27 21:24:07', '2026-03-27 21:24:07'),
(4, 3, '13251423', 21, 'receive-po', '2026-03-29 09:06:33', '2026-03-29 09:06:33', '2026-03-29 09:06:33'),
(5, 3, '09joh7', 39, 'receive-po', '2026-03-29 09:06:53', '2026-03-29 09:06:53', '2026-03-29 09:06:53'),
(6, 17, '1234567890128', 42, 'receive-po', '2026-03-29 17:07:47', '2026-03-29 17:07:48', '2026-03-29 17:07:48'),
(7, 17, '1234567890128', 42, 'receive-po', '2026-03-29 17:07:50', '2026-03-29 17:07:50', '2026-03-29 17:07:50'),
(8, 17, '1234567890128', 42, 'receive-po', '2026-03-29 17:07:51', '2026-03-29 17:07:52', '2026-03-29 17:07:52'),
(9, 17, '1234567890128', 42, 'issue-out', '2026-03-29 17:19:13', '2026-03-29 17:19:13', '2026-03-29 17:19:13'),
(10, 17, '1234567890128', 42, 'issue-out', '2026-03-29 17:19:14', '2026-03-29 17:19:14', '2026-03-29 17:19:14'),
(11, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:21:27', '2026-03-29 17:21:27', '2026-03-29 17:21:27'),
(12, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:21:28', '2026-03-29 17:21:28', '2026-03-29 17:21:28'),
(13, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:09', '2026-03-29 17:33:09', '2026-03-29 17:33:09'),
(14, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:10', '2026-03-29 17:33:10', '2026-03-29 17:33:10'),
(15, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:11', '2026-03-29 17:33:11', '2026-03-29 17:33:11'),
(16, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:11', '2026-03-29 17:33:12', '2026-03-29 17:33:12'),
(17, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:12', '2026-03-29 17:33:13', '2026-03-29 17:33:13'),
(18, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:14', '2026-03-29 17:33:14', '2026-03-29 17:33:14'),
(19, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:16', '2026-03-29 17:33:16', '2026-03-29 17:33:16'),
(20, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:16', '2026-03-29 17:33:17', '2026-03-29 17:33:17'),
(21, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:17', '2026-03-29 17:33:18', '2026-03-29 17:33:18'),
(22, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:18', '2026-03-29 17:33:19', '2026-03-29 17:33:19'),
(23, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:19', '2026-03-29 17:33:19', '2026-03-29 17:33:19'),
(24, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:20', '2026-03-29 17:33:20', '2026-03-29 17:33:20'),
(25, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:21', '2026-03-29 17:33:21', '2026-03-29 17:33:21'),
(26, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:22', '2026-03-29 17:33:22', '2026-03-29 17:33:22'),
(27, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:22', '2026-03-29 17:33:23', '2026-03-29 17:33:23'),
(28, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:24', '2026-03-29 17:33:24', '2026-03-29 17:33:24'),
(29, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:25', '2026-03-29 17:33:25', '2026-03-29 17:33:25'),
(30, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:25', '2026-03-29 17:33:26', '2026-03-29 17:33:26'),
(31, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:26', '2026-03-29 17:33:27', '2026-03-29 17:33:27'),
(32, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:27', '2026-03-29 17:33:28', '2026-03-29 17:33:28'),
(33, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:28', '2026-03-29 17:33:28', '2026-03-29 17:33:28'),
(34, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:29', '2026-03-29 17:33:29', '2026-03-29 17:33:29'),
(35, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:30', '2026-03-29 17:33:30', '2026-03-29 17:33:30'),
(36, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:31', '2026-03-29 17:33:31', '2026-03-29 17:33:31'),
(37, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:32', '2026-03-29 17:33:32', '2026-03-29 17:33:32'),
(38, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:33:33', '2026-03-29 17:33:33', '2026-03-29 17:33:33'),
(39, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:41:42', '2026-03-29 17:41:42', '2026-03-29 17:41:42'),
(40, 17, '1040047425762', 41, 'issue-out', '2026-03-29 17:41:43', '2026-03-29 17:41:43', '2026-03-29 17:41:43'),
(41, 17, '090lm', 38, 'issue-out', '2026-03-29 17:42:14', '2026-03-29 17:42:14', '2026-03-29 17:42:14'),
(42, 17, '090lm', 38, 'issue-out', '2026-03-29 17:42:15', '2026-03-29 17:42:15', '2026-03-29 17:42:15'),
(43, 17, '090lm', 38, 'issue-out', '2026-03-29 17:42:19', '2026-03-29 17:42:20', '2026-03-29 17:42:20'),
(44, 17, '090lm', 38, 'issue-out', '2026-03-29 17:43:05', '2026-03-29 17:43:06', '2026-03-29 17:43:06'),
(45, 17, '090lm', 38, 'issue-out', '2026-03-29 17:43:06', '2026-03-29 17:43:07', '2026-03-29 17:43:07'),
(46, 17, '090lm', 38, 'issue-out', '2026-03-29 17:43:18', '2026-03-29 17:43:18', '2026-03-29 17:43:18'),
(47, 17, '090lm', 38, 'issue-out', '2026-03-29 17:43:19', '2026-03-29 17:43:19', '2026-03-29 17:43:19'),
(48, 17, '090lm', 38, 'issue-out', '2026-03-29 17:43:20', '2026-03-29 17:43:20', '2026-03-29 17:43:20'),
(49, 17, '09joh7', 39, 'issue-out', '2026-03-29 18:02:49', '2026-03-29 18:02:49', '2026-03-29 18:02:49'),
(50, 17, '09joh7', 39, 'issue-out', '2026-03-29 18:02:51', '2026-03-29 18:02:51', '2026-03-29 18:02:51'),
(51, 17, '09kil', 40, 'issue-out', '2026-03-29 18:38:30', '2026-03-29 18:38:30', '2026-03-29 18:38:30'),
(52, 17, '09kil', 40, 'issue-out', '2026-03-29 18:38:31', '2026-03-29 18:38:32', '2026-03-29 18:38:32'),
(53, 17, '09kil', 40, 'issue-out', '2026-03-29 18:38:33', '2026-03-29 18:38:33', '2026-03-29 18:38:33'),
(54, 17, '09kil', 40, 'issue-out', '2026-03-29 18:38:35', '2026-03-29 18:38:35', '2026-03-29 18:38:35'),
(55, 17, '09joh7', 39, 'issue-out', '2026-03-29 18:45:09', '2026-03-29 18:45:09', '2026-03-29 18:45:09'),
(56, 17, '09joh7', 39, 'issue-out', '2026-03-29 18:45:10', '2026-03-29 18:45:11', '2026-03-29 18:45:11'),
(57, 17, '1040047425762', 41, 'receive-po', '2026-03-29 18:45:40', '2026-03-29 18:45:41', '2026-03-29 18:45:41'),
(58, 17, '1040047425762', 41, 'receive-po', '2026-03-29 18:45:43', '2026-03-29 18:45:44', '2026-03-29 18:45:44'),
(59, 17, '132ads', 35, 'transfer', '2026-03-29 18:46:19', '2026-03-29 18:46:20', '2026-03-29 18:46:20'),
(60, 17, '132ads', 35, 'transfer', '2026-03-29 18:46:28', '2026-03-29 18:46:29', '2026-03-29 18:46:29'),
(61, 17, '132ads', 35, 'transfer', '2026-03-29 18:46:30', '2026-03-29 18:46:31', '2026-03-29 18:46:31'),
(62, 17, '132ads', 35, 'transfer', '2026-03-29 18:46:32', '2026-03-29 18:46:33', '2026-03-29 18:46:33'),
(63, 17, '132ads', 35, 'transfer', '2026-03-29 18:46:34', '2026-03-29 18:46:34', '2026-03-29 18:46:34'),
(64, 17, '132ads', 35, 'transfer', '2026-03-29 18:46:36', '2026-03-29 18:46:37', '2026-03-29 18:46:37'),
(65, 17, '09kil', 40, 'issue-out', '2026-03-29 19:08:09', '2026-03-29 19:08:09', '2026-03-29 19:08:09'),
(66, 17, '09kil', 40, 'transfer', '2026-03-29 19:12:04', '2026-03-29 19:12:05', '2026-03-29 19:12:05'),
(67, 17, '09kil', 40, 'transfer', '2026-03-29 19:12:06', '2026-03-29 19:12:07', '2026-03-29 19:12:07'),
(68, 17, '09kil', 40, 'transfer', '2026-03-29 19:12:08', '2026-03-29 19:12:09', '2026-03-29 19:12:09'),
(69, 17, '09kil', 40, 'transfer', '2026-03-29 19:12:10', '2026-03-29 19:12:11', '2026-03-29 19:12:11'),
(70, 17, '09kil', 40, 'transfer', '2026-03-29 19:12:12', '2026-03-29 19:12:13', '2026-03-29 19:12:13'),
(71, 17, '09kil', 40, 'transfer', '2026-03-29 19:12:14', '2026-03-29 19:12:15', '2026-03-29 19:12:15'),
(72, 17, '09kil', 40, 'transfer', '2026-03-29 19:12:17', '2026-03-29 19:12:18', '2026-03-29 19:12:18'),
(73, 17, '09kil', 40, 'transfer', '2026-03-29 19:12:19', '2026-03-29 19:12:20', '2026-03-29 19:12:20'),
(74, 17, '132ads', 35, 'transfer', '2026-03-29 19:12:53', '2026-03-29 19:12:54', '2026-03-29 19:12:54'),
(75, 17, '132ads', 35, 'transfer', '2026-03-29 19:12:56', '2026-03-29 19:12:57', '2026-03-29 19:12:57'),
(76, 17, '09joh7', 39, 'transfer', '2026-03-29 22:49:12', '2026-03-29 22:49:12', '2026-03-29 22:49:12'),
(77, 17, '09joh7', 39, 'transfer', '2026-03-29 22:49:13', '2026-03-29 22:49:13', '2026-03-29 22:49:13'),
(78, 17, '09joh7', 39, 'transfer', '2026-03-29 22:49:13', '2026-03-29 22:49:14', '2026-03-29 22:49:14'),
(79, 17, '09joh7', 39, 'transfer', '2026-03-29 22:49:17', '2026-03-29 22:49:18', '2026-03-29 22:49:18'),
(80, 17, '09joh7', 39, 'transfer', '2026-03-29 22:49:21', '2026-03-29 22:49:22', '2026-03-29 22:49:22'),
(81, 17, '09joh7', 39, 'transfer', '2026-03-29 22:49:22', '2026-03-29 22:49:23', '2026-03-29 22:49:23'),
(82, 17, '09joh7', 39, 'transfer', '2026-03-29 22:49:24', '2026-03-29 22:49:24', '2026-03-29 22:49:24'),
(83, 17, '09joh7', 39, 'transfer', '2026-03-29 22:50:04', '2026-03-29 22:50:06', '2026-03-29 22:50:06'),
(84, 3, '09joh7', 39, 'issue-out', '2026-03-29 23:55:53', '2026-03-29 23:55:52', '2026-03-29 23:55:52'),
(85, 3, '09joh7', 39, 'issue-out', '2026-03-29 23:55:56', '2026-03-29 23:55:55', '2026-03-29 23:55:55'),
(86, 3, '1234567890128', 42, 'receive-po', '2026-03-29 23:56:36', '2026-03-29 23:56:36', '2026-03-29 23:56:36'),
(87, 3, '1234567890128', 42, 'receive-po', '2026-03-29 23:56:39', '2026-03-29 23:56:40', '2026-03-29 23:56:40'),
(88, 17, '1234567890128', 42, 'receive-po', '2026-03-30 00:00:00', '2026-03-30 00:00:00', '2026-03-30 00:00:00'),
(89, 17, '09kil', 40, 'transfer', '2026-03-30 00:09:59', '2026-03-30 00:09:58', '2026-03-30 00:09:58'),
(90, 17, '09kil', 40, 'transfer', '2026-03-30 00:10:01', '2026-03-30 00:10:00', '2026-03-30 00:10:00'),
(91, 17, '09joh7', 39, 'receive-po', '2026-03-30 00:24:30', '2026-03-30 00:24:30', '2026-03-30 00:24:30'),
(92, 17, '09joh7', 39, 'receive-po', '2026-03-30 00:24:33', '2026-03-30 00:24:34', '2026-03-30 00:24:34'),
(93, 17, '09joh7', 39, 'receive-po', '2026-03-30 00:25:19', '2026-03-30 00:25:19', '2026-03-30 00:25:19');

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE `branches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `contact_number` varchar(50) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `opening_date` date DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `branches`
--

INSERT INTO `branches` (`id`, `code`, `name`, `region`, `city`, `address`, `contact_number`, `email`, `opening_date`, `capacity`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'CDO', 'Cagayan de Oro', 'Mindanao', 'PANGANTUCAN', 'United village', '0712345678', 'johnphilipbaloro56@gmail.com', NULL, 6000, 1, '2026-02-14 03:57:06', '2026-02-20 09:15:35'),
(2, 'DVO', 'Davao City', NULL, NULL, 'adssa', NULL, NULL, NULL, 10000, 1, '2026-02-14 03:57:06', '2026-02-16 15:11:12'),
(3, 'VAL', 'Valencia', NULL, NULL, '13123', NULL, NULL, NULL, 2500, 1, '2026-02-14 03:57:06', '2026-02-16 15:57:57'),
(4, 'BUT', 'Butuan', NULL, NULL, 'adsad', NULL, NULL, NULL, 4500, 0, '2026-02-14 03:57:06', '2026-02-15 05:30:04'),
(5, 'ILI', 'Iligan', NULL, NULL, 'asdad0', NULL, NULL, NULL, 3000, 1, '2026-02-14 03:57:06', '2026-02-17 05:23:33'),
(6, 'PAG', 'Pagadian', NULL, NULL, 'adwa', NULL, NULL, NULL, 4000, 0, '2026-02-14 03:57:06', '2026-02-15 05:31:03'),
(7, 'ZAM', 'Zamboanga', NULL, NULL, 'sfsadf', NULL, NULL, NULL, 5000, 0, '2026-02-14 03:57:06', '2026-02-15 05:34:33'),
(8, 'boh', 'Bohol', NULL, NULL, 'united village', NULL, NULL, NULL, NULL, 0, '2026-02-14 04:10:17', '2026-02-15 05:33:22');

-- --------------------------------------------------------

--
-- Table structure for table `brand_lookup`
--

CREATE TABLE `brand_lookup` (
  `brand_id` bigint(20) UNSIGNED NOT NULL,
  `brand_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `brand_lookup`
--

INSERT INTO `brand_lookup` (`brand_id`, `brand_name`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Airking', NULL, '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(2, 'Samsung', NULL, '2026-02-14 16:39:50', '2026-03-25 11:16:22', NULL),
(3, 'LG', NULL, '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(4, 'Panasonic', NULL, '2026-02-14 16:39:50', '2026-03-24 23:34:18', NULL),
(5, 'Sony', NULL, '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(6, 'Whirlpool', NULL, '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(7, 'Condura', NULL, '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(8, 'Hanabishi', NULL, '2026-02-14 16:39:50', '2026-03-24 23:34:08', NULL),
(9, 'Imarflex', NULL, '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(10, 'TCL', NULL, '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-2697c212a0ed3a80c6170c8290e8262f31aff77a', 'i:3;', 1774854603),
('laravel-cache-2697c212a0ed3a80c6170c8290e8262f31aff77a:timer', 'i:1774854603;', 1774854603),
('laravel-cache-5c785c036466adea360111aa28563bfd556b5fba', 'i:4;', 1775105721),
('laravel-cache-5c785c036466adea360111aa28563bfd556b5fba:timer', 'i:1775105721;', 1775105721),
('laravel-cache-b016102da059b983ae49d7f65437da4af0eb87a4', 'i:3;', 1774805358),
('laravel-cache-b016102da059b983ae49d7f65437da4af0eb87a4:timer', 'i:1774805358;', 1774805358),
('laravel-cache-cab94ca3970691f94c439ec48db23b790065a855', 'i:3;', 1774834353),
('laravel-cache-cab94ca3970691f94c439ec48db23b790065a855:timer', 'i:1774834353;', 1774834353);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category_lookup`
--

CREATE TABLE `category_lookup` (
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `category_type` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `category_lookup`
--

INSERT INTO `category_lookup` (`category_id`, `category_name`, `category_type`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Air Conditioning', 'product', 'Air conditioning units', '2026-02-14 16:39:50', '2026-02-26 05:27:01', NULL),
(2, 'Television', 'product', 'TVs and displays', '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(4, 'Refrigerator', 'product', 'Refrigerators and freezers', '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(5, 'Small Appliances', 'product', 'Small home appliances', '2026-02-14 16:39:50', '2026-02-14 16:39:50', NULL),
(6, 'Aircon', 'accessory', NULL, '2026-03-25 11:38:44', '2026-03-29 10:29:36', '2026-03-29 10:29:36');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `customer_type` varchar(100) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `tin` varchar(100) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `credit_limit` decimal(12,2) DEFAULT NULL,
  `outstanding_balance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `customer_code` varchar(50) DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `created_at`, `updated_at`, `region`, `is_active`, `customer_type`, `customer_name`, `contact_number`, `email`, `company_name`, `address`, `city`, `province`, `tin`, `notes`, `credit_limit`, `outstanding_balance`, `deleted_at`, `customer_code`, `status_id`) VALUES
(1, '2026-02-17 03:42:00', '2026-02-17 03:42:00', 'Cagayan De Oro', 1, 'Ordinary', 'John Philip Baloro', '09876573652', 'Philip@gmail.com', NULL, 'United village', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL),
(2, '2026-02-17 03:42:46', '2026-02-17 03:42:46', 'PANGANTUCAN', 1, 'Business', 'Intsik Tan', '098762135126', 'Tan@gmail.com', 'Tan furniture', 'United village', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL),
(3, '2026-02-17 04:21:54', '2026-02-17 04:21:54', 'Bukidnon', 1, 'Ordinary', 'HAHAHA', '09039214042', 'hahaha45@gmail.com', NULL, 'United village', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, NULL),
(4, '2026-02-17 04:22:05', '2026-02-17 04:22:05', 'General Santos', 1, 'Business', 'Manny Pacquaio', '09875192093', 'Pac@gmail.com', 'Genpac Appliances', 'Gensan', NULL, NULL, NULL, NULL, 499999.99, 0.00, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `delivery_receipts`
--

CREATE TABLE `delivery_receipts` (
  `dr_id` bigint(20) UNSIGNED NOT NULL,
  `dr_number` varchar(50) NOT NULL,
  `sales_id` bigint(20) UNSIGNED DEFAULT NULL,
  `issued_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `inventory_id` bigint(20) UNSIGNED NOT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity_on_hand` int(11) NOT NULL DEFAULT 0,
  `condition` varchar(50) DEFAULT NULL,
  `available_quantity` int(11) NOT NULL DEFAULT 0,
  `reorder_level` int(11) NOT NULL DEFAULT 0,
  `last_updated` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`inventory_id`, `location_id`, `product_id`, `status_id`, `quantity_on_hand`, `condition`, `available_quantity`, `reorder_level`, `last_updated`, `created_at`, `updated_at`) VALUES
(5, 1, 14, NULL, 30, NULL, 30, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(6, 1, 15, NULL, 18, NULL, 18, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(7, 1, 16, NULL, 12, NULL, 12, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(8, 1, 17, NULL, 30, NULL, 30, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(9, 1, 18, NULL, 18, NULL, 18, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(10, 1, 19, NULL, 12, NULL, 12, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(11, 1, 20, NULL, 30, NULL, 30, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(12, 1, 21, NULL, 21, NULL, 21, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-29 09:06:32'),
(13, 1, 22, NULL, 12, NULL, 12, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(14, 1, 23, NULL, 30, NULL, 30, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(15, 1, 24, NULL, 18, NULL, 18, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(16, 1, 25, NULL, 12, NULL, 12, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(17, 1, 26, NULL, 30, NULL, 30, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(18, 1, 27, NULL, 18, NULL, 18, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(19, 1, 28, NULL, 12, NULL, 12, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(20, 1, 29, NULL, 30, NULL, 30, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(21, 1, 30, NULL, 18, NULL, 18, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(22, 1, 31, NULL, 12, NULL, 12, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(23, 1, 32, NULL, 26, NULL, 26, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 17:27:17'),
(24, 1, 33, NULL, 18, NULL, 18, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(25, 1, 34, NULL, 12, NULL, 12, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(26, 1, 35, NULL, 28, NULL, 28, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-29 19:12:55'),
(27, 1, 36, NULL, 18, NULL, 18, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 07:33:15'),
(28, 1, 37, NULL, 7, NULL, 7, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-27 17:11:16'),
(29, 1, 38, NULL, 21, NULL, 21, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-29 17:43:20'),
(30, 1, 39, NULL, 13, NULL, 13, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-30 00:25:18'),
(31, 1, 40, NULL, 8, NULL, 8, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-29 19:12:19'),
(32, 1, 41, NULL, 2, NULL, 2, 20, '2026-03-27 14:33:15', '2026-03-27 07:33:15', '2026-03-29 18:45:43'),
(33, 3, 39, NULL, 6, NULL, 6, 0, NULL, '2026-03-27 11:02:59', '2026-03-29 22:50:04'),
(37, 1, 42, NULL, 4, NULL, 4, 0, NULL, '2026-03-29 17:07:48', '2026-03-29 23:59:59'),
(45, 3, 40, NULL, 8, NULL, 8, 0, NULL, '2026-03-29 19:12:04', '2026-03-29 19:12:19'),
(46, 3, 35, NULL, 2, NULL, 2, 0, NULL, '2026-03-29 19:12:53', '2026-03-29 19:12:55');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_scan_events`
--

CREATE TABLE `inventory_scan_events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `transaction_type` varchar(32) NOT NULL,
  `action` varchar(16) NOT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `barcode` varchar(191) NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `po_id` bigint(20) UNSIGNED DEFAULT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `to_location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity_delta` int(11) NOT NULL DEFAULT 0,
  `serial_number` varchar(191) DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inventory_scan_events`
--

INSERT INTO `inventory_scan_events` (`id`, `user_id`, `transaction_type`, `action`, `reason`, `barcode`, `product_id`, `po_id`, `location_id`, `to_location_id`, `quantity_delta`, `serial_number`, `meta`, `created_at`, `updated_at`) VALUES
(1, 3, 'receiving', 'rejected', 'Item not included in PO.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:03:53', '2026-03-29 09:03:53'),
(2, 3, 'receiving', 'rejected', 'Item not included in PO.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:03:54', '2026-03-29 09:03:54'),
(3, 3, 'receiving', 'rejected', 'Item not included in PO.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:03:54', '2026-03-29 09:03:54'),
(4, 3, 'receiving', 'rejected', 'Item not included in PO.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:03:55', '2026-03-29 09:03:55'),
(5, 3, 'receiving', 'rejected', 'Item not included in PO.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:03:55', '2026-03-29 09:03:55'),
(6, 3, 'receiving', 'rejected', 'Item not included in PO.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:03:56', '2026-03-29 09:03:56'),
(7, 3, 'receiving', 'rejected', 'Item not included in PO.', '132szdsa', 36, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:04:31', '2026-03-29 09:04:31'),
(8, 3, 'receiving', 'rejected', 'Item not included in PO.', '132szdsa', 36, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:04:32', '2026-03-29 09:04:32'),
(9, 3, 'receiving', 'rejected', 'Item not included in PO.', '132szdsa', 36, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:04:33', '2026-03-29 09:04:33'),
(10, 3, 'receiving', 'rejected', 'Item not included in PO.', '132szdsa', 36, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:04:33', '2026-03-29 09:04:33'),
(11, 3, 'receiving', 'rejected', 'Item not included in PO.', '132szdsa', 36, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:04:34', '2026-03-29 09:04:34'),
(12, 3, 'receiving', 'rejected', 'Item not included in PO.', '132szdsa', 36, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:04:34', '2026-03-29 09:04:34'),
(13, 3, 'receiving', 'rejected', 'Item not included in PO.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:08', '2026-03-29 09:06:08'),
(14, 3, 'receiving', 'rejected', 'Item not included in PO.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:08', '2026-03-29 09:06:08'),
(15, 3, 'receiving', 'rejected', 'Item not included in PO.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:09', '2026-03-29 09:06:09'),
(16, 3, 'receiving', 'rejected', 'Item not included in PO.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:20', '2026-03-29 09:06:20'),
(17, 3, 'receiving', 'rejected', 'Item not included in PO.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:20', '2026-03-29 09:06:20'),
(18, 3, 'receiving', 'rejected', 'Item not included in PO.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:21', '2026-03-29 09:06:21'),
(19, 3, 'receiving', 'rejected', 'Item not included in PO.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:22', '2026-03-29 09:06:22'),
(20, 3, 'receiving', 'rejected', 'Item not included in PO.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:22', '2026-03-29 09:06:22'),
(21, 3, 'receiving', 'rejected', 'Item not included in PO.', '13251423', 21, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:26', '2026-03-29 09:06:26'),
(22, 3, 'receiving', 'rejected', 'Item not included in PO.', '13251423', 21, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:27', '2026-03-29 09:06:27'),
(23, 3, 'receiving', 'rejected', 'Item not included in PO.', '13251423', 21, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:27', '2026-03-29 09:06:27'),
(24, 3, 'receiving', 'rejected', 'Item not included in PO.', '13251423', 21, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:28', '2026-03-29 09:06:28'),
(25, 3, 'receiving', 'rejected', 'Item not included in PO.', '13251423', 21, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:28', '2026-03-29 09:06:28'),
(26, 3, 'receiving', 'rejected', 'Item not included in PO.', '13251423', 21, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:29', '2026-03-29 09:06:29'),
(27, 3, 'receiving', 'rejected', 'Item not included in PO.', '13251423', 21, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:30', '2026-03-29 09:06:30'),
(28, 3, 'receiving', 'rejected', 'Item not included in PO.', '13251423', 21, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 09:06:31', '2026-03-29 09:06:31'),
(29, 3, 'receiving', 'accepted', NULL, '13251423', 21, 8, 1, NULL, 1, '13251423', NULL, '2026-03-29 09:06:32', '2026-03-29 09:06:32'),
(30, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '13251423', 21, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"13251423\"}', '2026-03-29 09:06:34', '2026-03-29 09:06:34'),
(31, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '13251423', 21, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"13251423\"}', '2026-03-29 09:06:34', '2026-03-29 09:06:34'),
(32, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '13251423', 21, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"13251423\"}', '2026-03-29 09:06:35', '2026-03-29 09:06:35'),
(33, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '13251423', 21, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"13251423\"}', '2026-03-29 09:06:36', '2026-03-29 09:06:36'),
(34, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '13251423', 21, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"13251423\"}', '2026-03-29 09:06:36', '2026-03-29 09:06:36'),
(35, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '13251423', 21, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"13251423\"}', '2026-03-29 09:06:45', '2026-03-29 09:06:45'),
(36, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '13251423', 21, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"13251423\"}', '2026-03-29 09:06:46', '2026-03-29 09:06:46'),
(37, 3, 'receiving', 'accepted', NULL, '09joh7', 39, 8, 1, NULL, 1, '09joh7', NULL, '2026-03-29 09:06:53', '2026-03-29 09:06:53'),
(38, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"09joh7\"}', '2026-03-29 09:06:54', '2026-03-29 09:06:54'),
(39, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"09joh7\"}', '2026-03-29 09:06:54', '2026-03-29 09:06:54'),
(40, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"09joh7\"}', '2026-03-29 09:06:55', '2026-03-29 09:06:55'),
(41, 3, 'receiving', 'rejected', 'Duplicate serial detected.', '09joh7', 39, NULL, NULL, NULL, 0, NULL, '{\"serial_number\":\"09joh7\"}', '2026-03-29 09:06:56', '2026-03-29 09:06:56'),
(42, 17, 'receiving', 'accepted', NULL, '1234567890128', 42, NULL, 1, NULL, 1, NULL, NULL, '2026-03-29 17:07:48', '2026-03-29 17:07:48'),
(43, 17, 'receiving', 'accepted', NULL, '1234567890128', 42, NULL, 1, NULL, 1, NULL, NULL, '2026-03-29 17:07:50', '2026-03-29 17:07:50'),
(44, 17, 'receiving', 'accepted', NULL, '1234567890128', 42, NULL, 1, NULL, 1, NULL, NULL, '2026-03-29 17:07:51', '2026-03-29 17:07:51'),
(45, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:49', '2026-03-29 17:10:49'),
(46, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:50', '2026-03-29 17:10:50'),
(47, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:51', '2026-03-29 17:10:51'),
(48, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:52', '2026-03-29 17:10:52'),
(49, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:53', '2026-03-29 17:10:53'),
(50, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:53', '2026-03-29 17:10:53'),
(51, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:55', '2026-03-29 17:10:55'),
(52, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:56', '2026-03-29 17:10:56'),
(53, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:57', '2026-03-29 17:10:57'),
(54, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:10:58', '2026-03-29 17:10:58'),
(55, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:01', '2026-03-29 17:11:01'),
(56, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:01', '2026-03-29 17:11:01'),
(57, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:03', '2026-03-29 17:11:03'),
(58, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:17', '2026-03-29 17:11:17'),
(59, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:17', '2026-03-29 17:11:17'),
(60, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:18', '2026-03-29 17:11:18'),
(61, 17, 'issuance', 'rejected', 'Unregistered barcode.', '12345678', NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:21', '2026-03-29 17:11:21'),
(62, 17, 'issuance', 'rejected', 'Unregistered barcode.', '12345678', NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:22', '2026-03-29 17:11:22'),
(63, 17, 'issuance', 'rejected', 'Unregistered barcode.', '12345678', NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:22', '2026-03-29 17:11:22'),
(64, 17, 'issuance', 'rejected', 'Unregistered barcode.', '12345678', NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:23', '2026-03-29 17:11:23'),
(65, 17, 'issuance', 'rejected', 'Unregistered barcode.', '12345678', NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:24', '2026-03-29 17:11:24'),
(66, 17, 'issuance', 'rejected', 'Unregistered barcode.', 'ABCabc', NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:24', '2026-03-29 17:11:24'),
(67, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:27', '2026-03-29 17:11:27'),
(68, 17, 'issuance', 'rejected', 'Unregistered barcode.', '125002141350', NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:29', '2026-03-29 17:11:29'),
(69, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '525002741350', 43, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:30', '2026-03-29 17:11:30'),
(70, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '525002741350', 43, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:31', '2026-03-29 17:11:31'),
(71, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:33', '2026-03-29 17:11:33'),
(72, 17, 'issuance', 'rejected', 'Scan the unit serial number to issue this serialized item.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:11:35', '2026-03-29 17:11:35'),
(73, 17, 'issuance', 'rejected', 'No inventory record at this location.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:18:18', '2026-03-29 17:18:18'),
(74, 17, 'issuance', 'rejected', 'No inventory record at this location.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:18:18', '2026-03-29 17:18:18'),
(75, 17, 'issuance', 'rejected', 'No inventory record at this location.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:18:19', '2026-03-29 17:18:19'),
(76, 17, 'issuance', 'rejected', 'No inventory record at this location.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:18:20', '2026-03-29 17:18:20'),
(77, 17, 'issuance', 'rejected', 'No inventory record at this location.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:18:21', '2026-03-29 17:18:21'),
(78, 17, 'issuance', 'rejected', 'No inventory record at this location.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:18:22', '2026-03-29 17:18:22'),
(79, 17, 'issuance', 'rejected', 'No inventory record at this location.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:18:23', '2026-03-29 17:18:23'),
(80, 17, 'issuance', 'rejected', 'No inventory record at this location.', '1234567890', 44, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:18:25', '2026-03-29 17:18:25'),
(81, 17, 'issuance', 'accepted', NULL, '1234567890128', 42, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:19:13', '2026-03-29 17:19:13'),
(82, 17, 'issuance', 'accepted', NULL, '1234567890128', 42, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:19:14', '2026-03-29 17:19:14'),
(83, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:21:27', '2026-03-29 17:21:27'),
(84, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:21:28', '2026-03-29 17:21:28'),
(85, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:09', '2026-03-29 17:33:09'),
(86, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:10', '2026-03-29 17:33:10'),
(87, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:11', '2026-03-29 17:33:11'),
(88, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:12', '2026-03-29 17:33:12'),
(89, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:12', '2026-03-29 17:33:12'),
(90, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:14', '2026-03-29 17:33:14'),
(91, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:16', '2026-03-29 17:33:16'),
(92, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:16', '2026-03-29 17:33:16'),
(93, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:17', '2026-03-29 17:33:17'),
(94, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:18', '2026-03-29 17:33:18'),
(95, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:19', '2026-03-29 17:33:19'),
(96, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:20', '2026-03-29 17:33:20'),
(97, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:21', '2026-03-29 17:33:21'),
(98, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:22', '2026-03-29 17:33:22'),
(99, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:22', '2026-03-29 17:33:22'),
(100, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:24', '2026-03-29 17:33:24'),
(101, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:25', '2026-03-29 17:33:25'),
(102, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:26', '2026-03-29 17:33:26'),
(103, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:26', '2026-03-29 17:33:26'),
(104, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:27', '2026-03-29 17:33:27'),
(105, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:28', '2026-03-29 17:33:28'),
(106, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:29', '2026-03-29 17:33:29'),
(107, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:30', '2026-03-29 17:33:30'),
(108, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:31', '2026-03-29 17:33:31'),
(109, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:32', '2026-03-29 17:33:32'),
(110, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:33:33', '2026-03-29 17:33:33'),
(111, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:41:42', '2026-03-29 17:41:42'),
(112, 17, 'issuance', 'accepted', NULL, '1040047425762', 41, NULL, 1, NULL, -1, NULL, '{\"mode\":\"appliance_barcode\",\"quantity\":1}', '2026-03-29 17:41:43', '2026-03-29 17:41:43'),
(113, 17, 'issuance', 'rejected', 'Insufficient stock for issuance.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:41:43', '2026-03-29 17:41:43'),
(114, 17, 'issuance', 'rejected', 'Insufficient stock for issuance.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:41:44', '2026-03-29 17:41:44'),
(115, 17, 'issuance', 'rejected', 'Insufficient stock for issuance.', '1040047425762', 41, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 17:41:45', '2026-03-29 17:41:45'),
(116, 17, 'issuance', 'accepted', NULL, '090lm', 38, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:42:14', '2026-03-29 17:42:14'),
(117, 17, 'issuance', 'accepted', NULL, '090lm', 38, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:42:15', '2026-03-29 17:42:15'),
(118, 17, 'issuance', 'accepted', NULL, '090lm', 38, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:42:19', '2026-03-29 17:42:19'),
(119, 17, 'issuance', 'accepted', NULL, '090lm', 38, NULL, 1, NULL, -2, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:43:06', '2026-03-29 17:43:06'),
(120, 17, 'issuance', 'accepted', NULL, '090lm', 38, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:43:06', '2026-03-29 17:43:06'),
(121, 17, 'issuance', 'accepted', NULL, '090lm', 38, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:43:18', '2026-03-29 17:43:18'),
(122, 17, 'issuance', 'accepted', NULL, '090lm', 38, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:43:19', '2026-03-29 17:43:19'),
(123, 17, 'issuance', 'accepted', NULL, '090lm', 38, NULL, 1, NULL, -1, NULL, '{\"mode\":\"consumable\"}', '2026-03-29 17:43:20', '2026-03-29 17:43:20'),
(124, 17, 'issuance', 'rejected', 'Unregistered barcode.', '09`on7', NULL, NULL, NULL, NULL, 0, NULL, NULL, '2026-03-29 18:02:47', '2026-03-29 18:02:47'),
(125, 17, 'issuance', 'accepted', NULL, '09joh7', 39, NULL, 1, NULL, -1, '09joh7', '{\"mode\":\"serialized\"}', '2026-03-29 18:02:54', '2026-03-29 18:02:54');

-- --------------------------------------------------------

--
-- Table structure for table `issuances`
--

CREATE TABLE `issuances` (
  `issuance_id` bigint(20) UNSIGNED NOT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `issuance_date` date DEFAULT NULL,
  `issuance_type` varchar(50) DEFAULT NULL,
  `purpose` text DEFAULT NULL,
  `issued_to_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `expected_return_date` date DEFAULT NULL,
  `actual_return_date` date DEFAULT NULL,
  `issued_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `issuances`
--

INSERT INTO `issuances` (`issuance_id`, `location_id`, `issuance_date`, `issuance_type`, `purpose`, `issued_to_user_id`, `expected_return_date`, `actual_return_date`, `issued_by`, `approved_by`, `status_id`, `created_at`, `updated_at`) VALUES
(3, 1, '2026-03-28', 'Operations', 'Inventory Operation scan (09j12)', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-27 17:11:16', '2026-03-27 17:11:16'),
(4, 1, '2026-03-28', 'Operations', 'Inventory Operation scan (123fasd)', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-27 17:14:31', '2026-03-27 17:14:31'),
(5, 1, '2026-03-30', 'ISSUE_OUT', 'Inventory operation (barcode scan)', NULL, NULL, NULL, 17, NULL, NULL, '2026-03-29 18:44:43', '2026-03-29 18:44:43'),
(6, 1, '2026-03-30', 'ISSUE_OUT', 'Inventory operation (barcode scan)', NULL, NULL, NULL, 17, NULL, NULL, '2026-03-29 18:45:13', '2026-03-29 18:45:13'),
(7, 1, '2026-03-30', 'ISSUE_OUT', 'Inventory operation (barcode scan)', NULL, NULL, NULL, 17, NULL, NULL, '2026-03-29 19:08:14', '2026-03-29 19:08:14');

-- --------------------------------------------------------

--
-- Table structure for table `issuance_details`
--

CREATE TABLE `issuance_details` (
  `issuance_detail_id` bigint(20) UNSIGNED NOT NULL,
  `issuance_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity_issued` int(11) NOT NULL DEFAULT 0,
  `quantity_returned` int(11) NOT NULL DEFAULT 0,
  `condition_issued` varchar(50) DEFAULT NULL,
  `condition_returned` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `issuance_details`
--

INSERT INTO `issuance_details` (`issuance_detail_id`, `issuance_id`, `product_id`, `quantity_issued`, `quantity_returned`, `condition_issued`, `condition_returned`, `created_at`, `updated_at`) VALUES
(3, 3, 37, 5, 0, 'Good', NULL, '2026-03-27 17:11:16', '2026-03-27 17:11:16'),
(4, 4, 32, 5, 0, 'Good', NULL, '2026-03-27 17:14:31', '2026-03-27 17:14:31'),
(5, 5, 40, 1, 0, 'Good', NULL, '2026-03-29 18:44:43', '2026-03-29 18:44:43'),
(6, 6, 39, 1, 0, 'Good', NULL, '2026-03-29 18:45:13', '2026-03-29 18:45:13'),
(7, 7, 40, 1, 0, 'Good', NULL, '2026-03-29 19:08:14', '2026-03-29 19:08:14');

-- --------------------------------------------------------

--
-- Table structure for table `item_serial`
--

CREATE TABLE `item_serial` (
  `serial_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `serial_number` varchar(100) NOT NULL,
  `serial_type` varchar(50) DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `item_serial`
--

INSERT INTO `item_serial` (`serial_id`, `product_id`, `serial_number`, `serial_type`, `status_id`, `created_at`, `updated_at`) VALUES
(1, 21, '13251423', 'received', NULL, '2026-03-29 09:06:32', '2026-03-29 09:06:32'),
(2, 39, '09joh7', 'received', NULL, '2026-03-29 09:06:53', '2026-03-29 09:06:53');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `location_id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED DEFAULT NULL,
  `location_name` varchar(255) DEFAULT NULL,
  `location_type` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`location_id`, `branch_id`, `location_name`, `location_type`, `address`, `city`, `province`, `region`, `status_id`, `created_at`, `updated_at`) VALUES
(1, 1, 'CDO Main Warehouse', 'warehouse', 'Cagayan de Oro Warehouse Hub', 'Cagayan de Oro', 'Misamis Oriental', 'Region X', 1, '2026-02-23 16:48:51', '2026-02-24 01:54:01'),
(2, 1, 'CDO Showroom', 'showroom', 'Cagayan de Oro Distribution Showroom', 'Cagayan de Oro', 'Misamis Oriental', 'Region X', 1, '2026-02-23 16:48:51', '2026-02-23 16:48:51'),
(3, 1, 'Carmen Showroom', 'showroom', 'Carmen, Misamis Oriental — AirKing showroom', 'Carmen', 'Misamis Oriental', 'Region X', 1, '2026-03-27 10:42:40', '2026-03-27 10:42:40');

-- --------------------------------------------------------

--
-- Table structure for table `login_activities`
--

CREATE TABLE `login_activities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `username_attempt` varchar(100) DEFAULT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `failure_reason` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `login_activities`
--

INSERT INTO `login_activities` (`id`, `user_id`, `username_attempt`, `success`, `failure_reason`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 18:53:19'),
(2, 15, 'blue', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 18:53:41'),
(3, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:07:41'),
(4, 17, 'marc', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:08:37'),
(5, NULL, 'red', 0, 'Invalid CAPTCHA.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:18:50'),
(6, 16, 'red', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:19:02'),
(7, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:19:36'),
(8, 14, 'kinsa', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:21:03'),
(9, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:22:51'),
(10, 17, 'marc', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:30:17'),
(11, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:30:55'),
(12, 17, 'marc', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:32:39'),
(13, NULL, 'admin', 0, 'Invalid CAPTCHA.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:35:49'),
(14, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:35:55'),
(15, 17, 'marc', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 19:46:33'),
(16, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:11:06'),
(17, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:14:10'),
(18, 16, 'red', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:15:09'),
(19, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:18:12'),
(20, 16, 'red', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:19:57'),
(21, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:20:51'),
(22, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:32:00'),
(23, 16, 'red', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:32:36'),
(24, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 21:33:43'),
(25, 15, 'blue', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/2.6.21 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36', '2026-03-27 21:36:42'),
(26, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:29:36'),
(27, 17, 'marc', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:31:37'),
(28, NULL, 'admin', 0, 'Invalid CAPTCHA.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:32:26'),
(29, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 22:32:41'),
(30, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:19:22'),
(31, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:58:39'),
(32, 16, 'red', 0, 'Invalid credentials.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:59:10'),
(33, 16, 'red', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-27 23:59:20'),
(34, 15, 'blue', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:00:27'),
(35, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:06:20'),
(36, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:12:53'),
(37, 16, 'red', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:13:19'),
(38, 15, 'blue', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:14:05'),
(39, NULL, 'blue', 0, 'Invalid CAPTCHA.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:28:52'),
(40, 15, 'blue', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:29:01'),
(41, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:29:13'),
(42, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 00:34:24'),
(43, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 21:00:28'),
(44, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 21:13:44'),
(45, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 22:26:25'),
(46, 17, 'marc', 0, 'Invalid credentials.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 23:02:21'),
(47, 17, 'marc', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 23:02:31'),
(48, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-28 23:14:28'),
(49, 17, 'marc', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 02:59:42'),
(50, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 05:56:00'),
(51, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 06:52:41'),
(52, 3, 'admin', 1, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 07:09:34'),
(53, 3, 'admin', 1, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 07:10:09'),
(54, 3, 'admin', 1, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 07:10:44'),
(55, 3, 'admin', 1, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 09:02:22'),
(56, 3, 'admin', 1, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:02:51'),
(57, 3, 'admin', 1, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:03:07'),
(58, 17, 'marc', 1, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:05:28'),
(59, 3, 'admin', 1, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:05:54'),
(60, 17, 'marc', 1, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 09:31:15'),
(61, 3, 'admin', 1, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 09:41:40'),
(62, NULL, 'admin', 0, 'Invalid CAPTCHA.', '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 10:28:18'),
(63, 3, 'admin', 1, NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 10:28:25'),
(64, 16, 'red', 1, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:25:49'),
(65, 15, 'blue', 1, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:26:43'),
(66, 17, 'marc', 1, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 16:27:44'),
(67, 17, 'marc', 1, NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 18:31:53'),
(68, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 18:32:08'),
(69, 17, 'marc', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 19:05:25'),
(70, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 19:07:52'),
(71, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 21:08:27'),
(72, 17, 'marc', 1, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 22:04:30'),
(73, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-03-29 22:05:51'),
(74, 3, 'admin', 1, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:55:03'),
(75, 17, 'marc', 1, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:57:19'),
(76, 17, 'marc', 1, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-29 23:58:30'),
(77, 17, 'marc', 1, NULL, '192.168.1.9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '2026-03-30 00:09:24'),
(78, 3, 'admin', 1, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '2026-04-01 21:54:54');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_01_14_000000_update_users_table', 1),
(5, '2025_01_14_000001_create_branches_table', 1),
(6, '2025_01_14_000002_create_warehouses_table', 1),
(7, '2025_01_14_000003_create_items_table', 1),
(8, '2025_01_14_000004_create_inventory_table', 1),
(9, '2025_01_14_000005_create_transactions_table', 1),
(12, '2026_01_14_215013_create_personal_access_tokens_table', 2),
(13, '2026_01_25_000222_update_users_table_for_system', 3),
(14, '2026_01_25_000304_update_users_table_for_system', 3),
(15, '2026_01_30_000309_create_status_lookup_table', 4),
(16, '2026_01_30_000336_create_roles_table', 4),
(17, '2026_01_30_000350_create_unit_lookup_table', 4),
(18, '2026_01_30_000403_create_brand_lookup_table', 4),
(19, '2026_01_30_000422_create_category_lookup_table', 4),
(20, '2026_01_30_000436_create_subcategory_lookup_table', 4),
(21, '2026_01_30_000450_create_transaction_type_lookup_table', 4),
(22, '2026_01_30_001527_create_customers_table', 5),
(23, '2026_01_30_001527_create_locations_table', 5),
(24, '2026_01_30_001527_create_suppliers_table', 5),
(25, '2026_01_30_001528_create_model_lookup_table', 5),
(26, '2026_01_31_000000_update_users_table_schema', 6),
(27, '2026_01_31_000001_create_audit_trail_table', 6),
(28, '2025_01_14_000010_create_warranty_claims_table', 7),
(29, '2026_02_14_000000_add_item_master_fields_to_items_table', 8),
(30, '2026_02_15_000001_add_pos_fields_to_customers_table', 9),
(31, '2026_02_15_000003_create_pos_delivery_receipt_items_table', 10),
(32, '2026_02_15_000002_create_pos_delivery_receipts_table', 11),
(33, '2026_02_15_000004_add_pos_customer_fields_to_customers', 11),
(34, '2026_02_16_000001_add_credit_limit_and_outstanding_to_customers', 12),
(35, '2026_02_13_000001_create_erd_tables', 13),
(36, '2026_02_18_000001_update_schema_to_match_erd', 14),
(37, '2026_02_19_000001_remove_tables_not_in_erd', 15),
(38, '2026_02_19_000002_drop_remaining_non_erd_tables', 16),
(40, '2026_02_20_000001_update_attributes_per_erd', 17),
(41, '2026_02_20_000002_align_products_table_with_erd', 18),
(43, '2026_02_20_000003_transfer_items_to_products', 19),
(44, '2026_02_21_000001_migrate_items_to_products', 20),
(45, '2026_02_22_000001_drop_pos_tables', 21),
(46, '2026_02_23_000001_add_branch_modal_fields_to_branches_table', 22),
(47, '2026_02_20_000001_add_origin_region_to_suppliers_and_create_supplier_product_table', 23),
(48, '2026_02_24_000001_erd_schema_alignment', 24),
(49, '2026_02_24_000002_fix_locations_and_users_schema', 25),
(50, '2026_02_23_000001_sync_locations_branch_schema', 26),
(51, '2026_02_23_000002_seed_cdo_operational_locations', 27),
(52, '2026_02_23_000002_add_soft_deletes_to_category_brand_lookup', 28),
(53, '2026_02_24_000003_add_product_type_to_products', 29),
(54, '2026_02_25_000001_erd_alignment_fixes', 30),
(55, '2026_02_25_000002_erd_full_schema_alignment', 31),
(56, '2026_02_25_000003_erd_pk_alignment', 32),
(57, '2026_03_20_120000_fr_gaps_branch_po_inventory', 33),
(58, '2026_03_28_000001_seed_carmen_showroom_location', 34),
(59, '2026_03_28_100000_seed_transfer_statuses', 35),
(60, '2026_03_28_120000_create_barcode_scans_table', 36),
(61, '2026_03_28_130000_seed_purchase_order_statuses', 37),
(62, '2026_03_28_140000_security_login_activity_user_locations', 38),
(63, '2026_03_28_150000_add_allowed_panels_to_users_table', 39),
(64, '2026_03_29_120000_create_inventory_scan_events_table', 40),
(65, '2026_03_30_000001_create_pending_products_table', 41),
(66, '2026_03_29_000002_add_appliance_pending_registration_to_pending_products', 42),
(67, '2026_03_30_000003_add_variant_column_to_products_table', 43),
(68, '2026_03_31_000001_add_opening_stock_to_pending_products', 44),
(69, '2026_03_30_000001_restore_transfer_quantity_columns', 45),
(70, '2026_03_30_120000_create_pending_products_table', 46),
(71, '2026_03_31_000001_create_pending_products_table', 47);

-- --------------------------------------------------------

--
-- Table structure for table `model_lookup`
--

CREATE TABLE `model_lookup` (
  `model_id` bigint(20) UNSIGNED NOT NULL,
  `brand_id` bigint(20) UNSIGNED DEFAULT NULL,
  `subcategory_id` bigint(20) UNSIGNED DEFAULT NULL,
  `model_code` varchar(100) NOT NULL,
  `variant` varchar(100) DEFAULT NULL,
  `capacity` varchar(50) DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pending_products`
--

CREATE TABLE `pending_products` (
  `pending_product_id` bigint(20) UNSIGNED NOT NULL,
  `barcode` varchar(100) NOT NULL,
  `registration_kind` varchar(24) NOT NULL DEFAULT 'consumable',
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `brand_id` bigint(20) UNSIGNED DEFAULT NULL,
  `supply_type` varchar(120) DEFAULT NULL,
  `packaging_unit` varchar(32) DEFAULT NULL,
  `quantity_per_package` decimal(12,2) DEFAULT NULL,
  `generated_name` varchar(255) NOT NULL,
  `appliance_snapshot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`appliance_snapshot`)),
  `opening_quantity` int(10) UNSIGNED DEFAULT NULL,
  `opening_location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status` varchar(24) NOT NULL DEFAULT 'pending',
  `final_product_name` varchar(255) DEFAULT NULL,
  `unit_price` decimal(12,2) DEFAULT NULL,
  `cost_price` decimal(12,2) DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pending_products`
--

INSERT INTO `pending_products` (`pending_product_id`, `barcode`, `registration_kind`, `category_id`, `brand_id`, `supply_type`, `packaging_unit`, `quantity_per_package`, `generated_name`, `appliance_snapshot`, `opening_quantity`, `opening_location_id`, `created_by`, `status`, `final_product_name`, `unit_price`, `cost_price`, `approved_by`, `approved_at`, `product_id`, `created_at`, `updated_at`) VALUES
(1, '1234567890128', 'consumable', NULL, NULL, 'PVC Pipe', 'meter', 5.00, 'PVC Pipe', NULL, NULL, NULL, 17, 'approved', 'PVC Pipe', NULL, NULL, 3, '2026-03-29 16:17:56', 42, '2026-03-29 11:03:38', '2026-03-29 16:17:56'),
(2, '525002741350', 'appliance', 2, 4, NULL, NULL, NULL, 'LG99', '{\"product_name\":\"LG99\",\"product_code\":null,\"capacity_rating\":null,\"variant\":null,\"category_id\":2,\"brand_id\":4,\"unit_id\":1,\"warranty_period_months\":0}', NULL, NULL, 17, 'approved', 'LG99', NULL, NULL, 3, '2026-03-29 16:45:03', 43, '2026-03-29 16:44:46', '2026-03-29 16:45:03'),
(3, '1234567890', 'appliance', 2, 3, NULL, NULL, NULL, 'Lg 90', '{\"product_name\":\"Lg 90\",\"product_code\":null,\"capacity_rating\":null,\"variant\":null,\"category_id\":2,\"brand_id\":3,\"unit_id\":1,\"warranty_period_months\":0}', NULL, NULL, 17, 'approved', 'Lg 90', NULL, NULL, 3, '2026-03-29 17:09:03', 44, '2026-03-29 17:08:47', '2026-03-29 17:09:03'),
(4, '036000291452', 'appliance', 4, 3, NULL, NULL, NULL, 'Hahaha123', '{\"product_name\":\"Hahaha123\",\"product_code\":null,\"capacity_rating\":\"1HP\",\"variant\":\"Inverter\",\"category_id\":4,\"brand_id\":3,\"unit_id\":1,\"warranty_period_months\":null,\"initial_location_id\":1}', 1, 1, 17, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-29 19:31:26', '2026-03-29 19:31:26'),
(5, '00012345678975', 'consumable', NULL, NULL, 'Copper / tubing', 'piece', 50.00, 'Copper / tubing · Piece / Each · 00012345678975', NULL, 1, 1, 17, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-29 22:05:32', '2026-03-29 22:05:32'),
(6, '1540363269588', 'consumable', NULL, NULL, 'Copper / tubing', 'meter', 30.00, 'Copper / tubing · Meter · 1540363269588', NULL, 1, 1, 17, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-30 00:00:59', '2026-03-30 00:00:59');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 3, 'auth-token', '2ca1dbcd025791f6f26466fb4ddb4978302968abf2fe6544c5d081c9e12c52bb', '[\"*\"]', '2026-02-01 15:40:23', NULL, '2026-02-01 15:40:13', '2026-02-01 15:40:23'),
(2, 'App\\Models\\User', 3, 'auth-token', '421e36a83e712a9323bffc5263898e4f586914f3a11485a6b89d9e5efd83ace5', '[\"*\"]', '2026-02-12 13:44:40', NULL, '2026-02-12 12:58:52', '2026-02-12 13:44:40'),
(3, 'App\\Models\\User', 3, 'auth-token', '08d9c70403fd04ab5fdc016b53089e48bd86c36e6dbb4aea194c6b48dc5d2e80', '[\"*\"]', '2026-02-13 05:41:32', NULL, '2026-02-13 04:10:23', '2026-02-13 05:41:32'),
(4, 'App\\Models\\User', 3, 'auth-token', '8539ca13402f6f947a41e3da49875aa1e79d4847e7b451cdaee9ab01eb5e198f', '[\"*\"]', '2026-02-13 07:46:01', NULL, '2026-02-13 07:35:58', '2026-02-13 07:46:01'),
(5, 'App\\Models\\User', 3, 'auth-token', '3ec97f33bccb8ec795c952262e6e6f81295b71b4b94e5ea54d978c78be4a2e20', '[\"*\"]', '2026-02-13 11:26:50', NULL, '2026-02-13 10:48:03', '2026-02-13 11:26:50'),
(6, 'App\\Models\\User', 3, 'auth-token', '9dc7b5fc7d5fccd795813e8590e8e1a5f840149cc57ac66818040532bc0209eb', '[\"*\"]', '2026-02-13 12:47:11', NULL, '2026-02-13 11:28:00', '2026-02-13 12:47:11'),
(7, 'App\\Models\\User', 3, 'auth-token', '9fb98aa40d92354eceeb6351101258581acd83fea5fffb13a7016c240a13fc9e', '[\"*\"]', '2026-02-14 03:07:04', NULL, '2026-02-13 23:56:36', '2026-02-14 03:07:04'),
(8, 'App\\Models\\User', 3, 'auth-token', '28fb4154e4df54d6e4a55691c3ea4ad574fe93454fbaefe2c5948cac95412853', '[\"*\"]', '2026-02-14 03:13:21', NULL, '2026-02-14 03:13:05', '2026-02-14 03:13:21'),
(9, 'App\\Models\\User', 3, 'auth-token', '15c7016072ca91fe29f89ba33c317e9102f4e8d0bfb26d470a42bdd3a7d73132', '[\"*\"]', '2026-02-14 22:41:21', NULL, '2026-02-14 03:29:27', '2026-02-14 22:41:21'),
(10, 'App\\Models\\User', 3, 'auth-token', '5fbb519ba71afdc04657b965c527ca10980c6efb50ccd5abd96a85faf6c2058e', '[\"*\"]', '2026-02-14 03:47:45', NULL, '2026-02-14 03:29:36', '2026-02-14 03:47:45'),
(11, 'App\\Models\\User', 3, 'auth-token', 'f39e326ef1136fad1b668d85f24e3f7fe6501aacb72f516114e36dcffdabba33', '[\"*\"]', '2026-02-14 03:50:45', NULL, '2026-02-14 03:47:51', '2026-02-14 03:50:45'),
(12, 'App\\Models\\User', 3, 'auth-token', '9e2604bebd55ea49bbef9f8ab6895f52583dff10b9b1abcd8725fcd6bef788f8', '[\"*\"]', '2026-02-14 14:47:38', NULL, '2026-02-14 03:53:20', '2026-02-14 14:47:38'),
(13, 'App\\Models\\User', 3, 'auth-token', 'e0d2c71479fa999211ac8758377828cdd5d103457cdf5a322d58f6b99688ea0f', '[\"*\"]', '2026-02-14 16:37:31', NULL, '2026-02-14 14:59:01', '2026-02-14 16:37:31'),
(14, 'App\\Models\\User', 3, 'auth-token', '084093bd05815083844f30ab8e56549372bbc326f58b2c7db6db8e491d0f4ce1', '[\"*\"]', '2026-02-14 23:42:16', NULL, '2026-02-14 22:40:56', '2026-02-14 23:42:16'),
(15, 'App\\Models\\User', 3, 'auth-token', '4ec61b42afd595379fdedc897f8e63a02e0196b7841ddcb86db601a209e4700e', '[\"*\"]', '2026-02-15 01:43:03', NULL, '2026-02-15 01:11:28', '2026-02-15 01:43:03'),
(16, 'App\\Models\\User', 3, 'auth-token', '87bd9f81bdc404dd34426148cf1ad86240f33b3580624c71ee4bd94a144337ca', '[\"*\"]', '2026-02-15 06:13:46', NULL, '2026-02-15 02:53:36', '2026-02-15 06:13:46'),
(17, 'App\\Models\\User', 3, 'auth-token', '33cbe47ea47a5ff0afc14ba65ffadd7d55cfcf29792bdd938d5250dd11061084', '[\"*\"]', '2026-02-16 13:58:38', NULL, '2026-02-16 08:50:04', '2026-02-16 13:58:38'),
(18, 'App\\Models\\User', 3, 'auth-token', 'b2480013c923562ed6a29197c94b50bde8f27db54cce08927dc53dbe19814a53', '[\"*\"]', '2026-02-16 15:46:34', NULL, '2026-02-16 14:08:12', '2026-02-16 15:46:34'),
(19, 'App\\Models\\User', 3, 'auth-token', 'a0378046b9228e308a24144e7a5b064d3cd3e64f659089779033360c31808f1f', '[\"*\"]', '2026-02-16 17:14:27', NULL, '2026-02-16 15:48:40', '2026-02-16 17:14:27'),
(20, 'App\\Models\\User', 3, 'auth-token', '0fd45ac3ce51b4ee1d8ca108b3c6a158944cc7c15a7017e5c313621c0ce60b0c', '[\"*\"]', '2026-02-16 17:00:06', NULL, '2026-02-16 15:50:26', '2026-02-16 17:00:06'),
(21, 'App\\Models\\User', 3, 'auth-token', 'd416cb87a45914b30cb1ffc495be6cf9a51f4f4d25af0d3b8cde968c0d35a2a3', '[\"*\"]', '2026-02-16 23:06:53', NULL, '2026-02-16 18:02:06', '2026-02-16 23:06:53'),
(22, 'App\\Models\\User', 3, 'auth-token', '58dfad9ca8906580a2effeaf68b25881b8b97225e2b2d56817cb06743bff5926', '[\"*\"]', '2026-02-17 02:33:50', NULL, '2026-02-17 01:29:55', '2026-02-17 02:33:50'),
(23, 'App\\Models\\User', 3, 'auth-token', '1ba614d5ecbc0028b0876a9700d6c7572f339dd53af321f87d4b9e4cde3229d7', '[\"*\"]', '2026-02-17 05:01:25', NULL, '2026-02-17 03:09:18', '2026-02-17 05:01:25'),
(24, 'App\\Models\\User', 3, 'auth-token', 'a43dcc940e8194ad60d20e782ccc159f71f360a8b2071a66b0f0390219547861', '[\"*\"]', '2026-02-17 07:25:30', NULL, '2026-02-17 05:03:44', '2026-02-17 07:25:30'),
(25, 'App\\Models\\User', 3, 'auth-token', 'e54ff7c3763125d116584ccf5b69e86ef2d502b4158d58ef3893788f313be1df', '[\"*\"]', '2026-02-17 13:50:09', NULL, '2026-02-17 13:43:12', '2026-02-17 13:50:09'),
(26, 'App\\Models\\User', 3, 'auth-token', '7a514ec3659dd23642fb17dd29c0f45c54f73858bd059f0f64eb6fca3bfa5297', '[\"*\"]', '2026-02-17 16:24:36', NULL, '2026-02-17 16:23:49', '2026-02-17 16:24:36'),
(27, 'App\\Models\\User', 3, 'auth-token', '002c9e06bf911ca595750a34d29ef897dcfefba70520dca58eff6defdaa24fa2', '[\"*\"]', '2026-02-18 07:00:33', NULL, '2026-02-18 02:49:11', '2026-02-18 07:00:33'),
(28, 'App\\Models\\User', 3, 'auth-token', 'ba077b69e79b589c98690bee1878a50bf115a88c85f68b8c7a27d451e449d79c', '[\"*\"]', '2026-02-18 07:32:52', NULL, '2026-02-18 07:03:46', '2026-02-18 07:32:52'),
(29, 'App\\Models\\User', 3, 'auth-token', '200b343f8e7a3addfe8ee52d004ff9008d07ce9774887f9e49843161c18ce888', '[\"*\"]', '2026-02-18 08:03:49', NULL, '2026-02-18 07:33:23', '2026-02-18 08:03:49'),
(30, 'App\\Models\\User', 3, 'auth-token', '5c970fe259e82198111e58062d831d7dcb6bf5aa3135c1a22d0e4db1aa691659', '[\"*\"]', '2026-02-18 14:25:11', NULL, '2026-02-18 13:01:27', '2026-02-18 14:25:11'),
(31, 'App\\Models\\User', 3, 'auth-token', '1583da0d56b13c7e2eeaad4f774bd313752fe7060c416f4bda14bbcc7552e72d', '[\"*\"]', '2026-02-20 02:35:17', NULL, '2026-02-20 02:30:03', '2026-02-20 02:35:17'),
(32, 'App\\Models\\User', 3, 'auth-token', 'cd4955a31ece207517ff4c1d186191686f72d70307cd064c4924380acd9bf553', '[\"*\"]', '2026-02-20 02:35:31', NULL, '2026-02-20 02:35:26', '2026-02-20 02:35:31'),
(33, 'App\\Models\\User', 3, 'auth-token', 'd4b8d45a3849d04208083cc85ec256ae36c1b10459eff2f7486d55639844c989', '[\"*\"]', '2026-02-20 02:42:02', NULL, '2026-02-20 02:41:46', '2026-02-20 02:42:02'),
(34, 'App\\Models\\User', 3, 'auth-token', '69f1a5f4d33e4eca7377204e663679458759d5337663f5cd9b51c719ffb74bf6', '[\"*\"]', '2026-02-20 02:43:35', NULL, '2026-02-20 02:43:30', '2026-02-20 02:43:35'),
(35, 'App\\Models\\User', 3, 'auth-token', '993f2167fbcfbc7058180430e8cfbbf8543f1e2f6c81363dd0bc2023a99c1412', '[\"*\"]', '2026-02-20 07:30:53', NULL, '2026-02-20 06:39:52', '2026-02-20 07:30:53'),
(36, 'App\\Models\\User', 3, 'auth-token', 'ff2cc01689dbe095df7e0a38f8916c51d95ec4826c0d9fe353823f41ae411c74', '[\"*\"]', '2026-02-20 13:20:00', NULL, '2026-02-20 08:17:27', '2026-02-20 13:20:00'),
(37, 'App\\Models\\User', 3, 'auth-token', '6680d9ef45c38b33d1f9c96a05e2fda6591b158716c6ff7e862cb207b9656bb5', '[\"*\"]', '2026-02-20 15:07:04', NULL, '2026-02-20 15:03:47', '2026-02-20 15:07:04'),
(38, 'App\\Models\\User', 3, 'auth-token', '0a221621c457c82934232b976e8e9797fa6771f5de9534d1e49765fb7c9f9757', '[\"*\"]', '2026-02-20 15:34:09', NULL, '2026-02-20 15:09:03', '2026-02-20 15:34:09'),
(39, 'App\\Models\\User', 3, 'auth-token', 'b86af30a417d6527410bcc9a561e3c21b462bd6d1f03c30f1c1bc66d9694e767', '[\"*\"]', '2026-02-21 01:39:49', NULL, '2026-02-21 00:43:43', '2026-02-21 01:39:49'),
(40, 'App\\Models\\User', 3, 'auth-token', 'a46fd82a81ee87bea3df189a709429e733a5ec65bf946086209834eb86dd33ae', '[\"*\"]', '2026-02-21 02:13:47', NULL, '2026-02-21 02:12:36', '2026-02-21 02:13:47'),
(41, 'App\\Models\\User', 3, 'auth-token', '15037661440e3460832f9d2a682bc61174510862674c0021caee8526d23983db', '[\"*\"]', '2026-02-21 06:31:07', NULL, '2026-02-21 04:35:00', '2026-02-21 06:31:07'),
(42, 'App\\Models\\User', 3, 'auth-token', '0f400567324ca9527a342729188e6dc5817306c320a7667652b8533af29018af', '[\"*\"]', '2026-02-21 06:33:59', NULL, '2026-02-21 06:33:49', '2026-02-21 06:33:59'),
(43, 'App\\Models\\User', 3, 'auth-token', '69544e94a7e0be2d1474a05cefd348a293f5673d1309b83cb27151e0404a0673', '[\"*\"]', '2026-02-22 00:48:07', NULL, '2026-02-22 00:16:45', '2026-02-22 00:48:07'),
(44, 'App\\Models\\User', 3, 'auth-token', '1813b1c446589c640fc9f514aa2a5d21e9de384713d38cdd1c3ccda830af6b88', '[\"*\"]', '2026-02-23 04:38:53', NULL, '2026-02-23 04:38:43', '2026-02-23 04:38:53'),
(45, 'App\\Models\\User', 3, 'auth-token', 'e0c64f3d39b727e5a19f8273846b8ae75d26d6c0cb85a7f81cec658702c1520f', '[\"*\"]', '2026-02-23 05:46:29', NULL, '2026-02-23 05:33:52', '2026-02-23 05:46:29'),
(46, 'App\\Models\\User', 3, 'auth-token', 'f1dfb80ae104effcee6061cace18ac10d5efc6cdcb80800fe84629691e48c259', '[\"*\"]', '2026-02-23 05:55:55', NULL, '2026-02-23 05:48:20', '2026-02-23 05:55:55'),
(47, 'App\\Models\\User', 3, 'auth-token', 'f0cebcd2285aa933b6f6672c9b73e5ea446a4eaaaa21dafda0e8d52bbfd7a978', '[\"*\"]', '2026-02-23 16:25:48', NULL, '2026-02-23 06:01:15', '2026-02-23 16:25:48'),
(48, 'App\\Models\\User', 3, 'auth-token', '5d5237477a0652ce825bb5c38497cbbb8d39871106dd48f75fdf30eb9c36fb52', '[\"*\"]', '2026-02-23 06:02:13', NULL, '2026-02-23 06:01:44', '2026-02-23 06:02:13'),
(49, 'App\\Models\\User', 3, 'auth-token', '939f50d85caaa788195faba1b89309dcd1f747bc74ebfa16bcdf712c25b9f0f1', '[\"*\"]', '2026-02-23 06:19:22', NULL, '2026-02-23 06:18:58', '2026-02-23 06:19:22'),
(50, 'App\\Models\\User', 3, 'auth-token', '963802bfac3270589bc84819b5bfa8920f5fa59663ee2fd0cacd6eb7ba1e27f8', '[\"*\"]', '2026-02-23 12:35:47', NULL, '2026-02-23 12:33:51', '2026-02-23 12:35:47'),
(51, 'App\\Models\\User', 3, 'auth-token', '683f7a06d34e663fc43e9653af04bfa33ae459353f123723fa57658f7f357f18', '[\"*\"]', '2026-02-23 13:36:29', NULL, '2026-02-23 12:37:56', '2026-02-23 13:36:29'),
(52, 'App\\Models\\User', 3, 'auth-token', '99b6b145854b1a65a54232c28f94f362916176d6726b7a680ca1908db032cae7', '[\"*\"]', '2026-02-23 17:34:01', NULL, '2026-02-23 16:10:07', '2026-02-23 17:34:01'),
(53, 'App\\Models\\User', 3, 'auth-token', '5886634d98c2548ebca00acbfb673e737c992b6f2e2e23ea7ec213b9a11ba671', '[\"*\"]', '2026-02-24 01:57:18', NULL, '2026-02-24 00:27:15', '2026-02-24 01:57:18'),
(54, 'App\\Models\\User', 3, 'auth-token', '4e26ff58e94612f6af52bf416bbb9d632c03d1ed59c97b50d77eafdd3f677160', '[\"*\"]', '2026-02-24 04:04:10', NULL, '2026-02-24 03:47:37', '2026-02-24 04:04:10'),
(55, 'App\\Models\\User', 3, 'auth-token', 'dfd59aa73ca8ad5f90b1bc78ade9ce363ab0a8b7ebfb1c9cd7ad16cca6ada2c1', '[\"*\"]', '2026-02-24 13:55:24', NULL, '2026-02-24 11:32:14', '2026-02-24 13:55:24'),
(56, 'App\\Models\\User', 3, 'auth-token', 'ea84c2d10e6cc7d70c2c16fc3950957b226ec205c6f3e2e96e76f5fa2c49f6f5', '[\"*\"]', '2026-02-24 14:16:51', NULL, '2026-02-24 14:01:43', '2026-02-24 14:16:51'),
(57, 'App\\Models\\User', 3, 'auth-token', 'fb88cc49df74b566ce0b64af77c59270ffd43d4830036a139b77e39843478d13', '[\"*\"]', '2026-02-24 14:27:47', NULL, '2026-02-24 14:18:26', '2026-02-24 14:27:47'),
(58, 'App\\Models\\User', 3, 'auth-token', '5354cb14589f103809fd3c00081696f3d8c9d14e651c50a11f4dce2a7f6d1ec5', '[\"*\"]', '2026-02-24 14:43:04', NULL, '2026-02-24 14:42:53', '2026-02-24 14:43:04'),
(61, 'App\\Models\\User', 3, 'auth-token', 'fe3bf3bdb4cdb44b6b83d05e1935199f727ab90e3c3a309b05d709f74752dd05', '[\"*\"]', '2026-02-25 05:50:28', NULL, '2026-02-25 05:27:48', '2026-02-25 05:50:28'),
(62, 'App\\Models\\User', 3, 'auth-token', '77451f0ad41e016ac04a1fab598dd2ffa6da8c00b108ea80d80aa60e2127be44', '[\"*\"]', '2026-02-25 07:45:40', NULL, '2026-02-25 06:24:07', '2026-02-25 07:45:40'),
(66, 'App\\Models\\User', 3, 'auth-token', 'd44289c6e93cb110d388d686e2ec3d137d8b8e3ed2e2324410cb8bac0e99359b', '[\"*\"]', '2026-02-26 01:04:17', NULL, '2026-02-25 17:29:53', '2026-02-26 01:04:17'),
(67, 'App\\Models\\User', 3, 'auth-token', 'b68cb2447d25a3287411b3172f9f82bf3c031e9e21942985ead81e2c8f5927d3', '[\"*\"]', '2026-02-26 05:25:53', NULL, '2026-02-26 01:33:20', '2026-02-26 05:25:53'),
(68, 'App\\Models\\User', 3, 'auth-token', '6d92be5e4705b7a3d90166d86700bb79822f52320281e6ce883839e13309a0db', '[\"*\"]', '2026-02-26 05:34:03', NULL, '2026-02-26 05:26:00', '2026-02-26 05:34:03'),
(69, 'App\\Models\\User', 3, 'auth-token', 'c56593a9b6e874663a758ad396a3a442be21247299b3135f62a4b6e39dabf226', '[\"*\"]', '2026-02-26 11:43:53', NULL, '2026-02-26 10:52:44', '2026-02-26 11:43:53'),
(70, 'App\\Models\\User', 3, 'auth-token', '845b53b643f3283e195b00b32d071c828b5d9616ce6579b399064ca3b121eba4', '[\"*\"]', '2026-02-27 03:10:33', NULL, '2026-02-27 02:56:44', '2026-02-27 03:10:33'),
(74, 'App\\Models\\User', 10, 'auth-token', '923313b81bbd45e6b91fb719c1e2154bb02ed25d49c906c00fc3e121fb836153', '[\"*\"]', '2026-02-27 06:41:02', NULL, '2026-02-27 06:34:30', '2026-02-27 06:41:02'),
(90, 'App\\Models\\User', 3, 'auth-token', '2d152c1332b80bd5cd4985e1004c98bd9845321fc02b2dfbef008e61736e9408', '[\"*\"]', '2026-02-28 11:18:54', NULL, '2026-02-28 11:17:57', '2026-02-28 11:18:54'),
(91, 'App\\Models\\User', 3, 'auth-token', 'c52b3f1656d9d293ea6c4c5eb4233555fe80d399e478bb9e1a1fc67053488740', '[\"*\"]', '2026-03-03 11:05:52', NULL, '2026-03-03 11:05:21', '2026-03-03 11:05:52'),
(92, 'App\\Models\\User', 3, 'auth-token', '39bcb1a135cdcb77e2b2965b164890f0a81441a02dac5eb4f1b9a8e885b03723', '[\"*\"]', '2026-03-03 11:17:24', NULL, '2026-03-03 11:15:28', '2026-03-03 11:17:24'),
(94, 'App\\Models\\User', 3, 'auth-token', '8386e22630a23eafda03149d937917e23f8f9f68782ed45dcd1bd73d50065305', '[\"*\"]', '2026-03-13 05:22:26', NULL, '2026-03-13 05:14:59', '2026-03-13 05:22:26'),
(102, 'App\\Models\\User', 3, 'auth-token', '7c8ca042c1c42f1786182beb3d30b047a75684c2ecfe81972cbf5eb499fda8a8', '[\"*\"]', '2026-03-13 06:29:53', NULL, '2026-03-13 06:29:51', '2026-03-13 06:29:53'),
(103, 'App\\Models\\User', 3, 'auth-token', 'f86448715802704b7ae31aba3c0b1cdb593fb7eb6cd132e04c2a956b71b9f167', '[\"*\"]', '2026-03-13 07:06:52', NULL, '2026-03-13 07:06:49', '2026-03-13 07:06:52'),
(106, 'App\\Models\\User', 3, 'auth-token', '7b80ae045c142c045fe33134995d9da74447e8bf92ad2678ea996d21d91e5e79', '[\"*\"]', '2026-03-15 00:52:48', NULL, '2026-03-15 00:51:59', '2026-03-15 00:52:48'),
(107, 'App\\Models\\User', 3, 'auth-token', '350eb4fa59c6f441fd7a9339df76f45eae6389295697ccc362183b562fa8e569', '[\"*\"]', '2026-03-16 15:06:37', NULL, '2026-03-16 15:05:49', '2026-03-16 15:06:37'),
(108, 'App\\Models\\User', 3, 'auth-token', '045063bbaa8d96c4de130bcead247715d6c7baa308c439af805dba37140207d9', '[\"*\"]', '2026-03-21 23:18:53', NULL, '2026-03-21 23:07:22', '2026-03-21 23:18:53'),
(109, 'App\\Models\\User', 3, 'auth-token', 'c3e6147aa773c3822ef5319334382acf4dd5fce8ba347357a539414846f3cab5', '[\"*\"]', '2026-03-22 14:56:06', NULL, '2026-03-22 13:23:51', '2026-03-22 14:56:06'),
(110, 'App\\Models\\User', 3, 'auth-token', 'bfce11290eec4bb12a4de24baeeb8ce81ffc1440a76e591a1e05751383935ef9', '[\"*\"]', '2026-03-23 17:12:17', NULL, '2026-03-23 14:55:44', '2026-03-23 17:12:17'),
(111, 'App\\Models\\User', 3, 'auth-token', 'e68f56f9ce3953d7fac00b251f5b7a7bbcd7105507fd51c7104b548ba6b7be1b', '[\"*\"]', '2026-03-24 14:21:38', NULL, '2026-03-24 13:11:00', '2026-03-24 14:21:38'),
(112, 'App\\Models\\User', 3, 'auth-token', 'f466b2094dee5dd1ab3e45231019d1cbb882098768d4f0a862d0f0458476de99', '[\"*\"]', '2026-03-24 17:03:45', NULL, '2026-03-24 17:03:44', '2026-03-24 17:03:45'),
(113, 'App\\Models\\User', 3, 'auth-token', 'a4b4aba671cdd30abd80575e236e1b89cf4e6d863765236c356c0999e6b0fcd5', '[\"*\"]', '2026-03-24 20:20:59', NULL, '2026-03-24 20:19:59', '2026-03-24 20:20:59'),
(116, 'App\\Models\\User', 3, 'auth-token', 'f2b32585119bb13d6d946ac73f86b1f9f5a5554b8207ff1ba15a4cd28090ded0', '[\"*\"]', '2026-03-25 07:03:41', NULL, '2026-03-24 22:12:51', '2026-03-25 07:03:41'),
(117, 'App\\Models\\User', 3, 'auth-token', '99204af5a8a8d76c5c9889de00cab58a90cf00335b96a71c8ea71db43313b934', '[\"*\"]', '2026-03-25 11:39:06', NULL, '2026-03-25 11:14:46', '2026-03-25 11:39:06'),
(119, 'App\\Models\\User', 3, 'auth-token', 'b864457080c8082b1ac17d543e47290ce08f749c0767ce45d96236fee8105f5d', '[\"*\"]', '2026-03-27 00:17:39', NULL, '2026-03-27 00:16:44', '2026-03-27 00:17:39'),
(120, 'App\\Models\\User', 3, 'auth-token', 'dfe82329d24d8abc941b7f0e9fb287201de43b14b069805405fa7830d91d739b', '[\"*\"]', '2026-03-27 01:48:50', NULL, '2026-03-27 01:48:46', '2026-03-27 01:48:50'),
(121, 'App\\Models\\User', 3, 'auth-token', 'b375e2d997b36139d80f2707a50c2043cdb282d4769b1b103f76249c875c166a', '[\"*\"]', '2026-03-27 02:14:59', NULL, '2026-03-27 01:50:26', '2026-03-27 02:14:59'),
(122, 'App\\Models\\User', 3, 'auth-token', '3fe5d090a19134d1ce03c57a78081e6f04d813507eb7c5fab9519aa2bbeb3cb3', '[\"*\"]', '2026-03-27 04:24:58', NULL, '2026-03-27 02:14:58', '2026-03-27 04:24:58'),
(123, 'App\\Models\\User', 3, 'auth-token', '1ee2e2c76b77b38f3df9c8dca77144444728d61bb99b36eafb660e6f81e59e3b', '[\"*\"]', '2026-03-27 05:31:06', NULL, '2026-03-27 05:03:29', '2026-03-27 05:31:06'),
(124, 'App\\Models\\User', 3, 'auth-token', 'd95ac2717d1c755002fd4883b2a03ec6ff5337245c6cdbbaed6797a59af47845', '[\"*\"]', '2026-03-27 05:42:55', NULL, '2026-03-27 05:40:47', '2026-03-27 05:42:55'),
(125, 'App\\Models\\User', 3, 'auth-token', '59385e51d13537fe89207645e0f6e15764a0e5e42e785a812ccafb29fb70b9aa', '[\"*\"]', '2026-03-27 07:09:08', NULL, '2026-03-27 05:42:44', '2026-03-27 07:09:08'),
(130, 'App\\Models\\User', 3, 'auth-token', 'e360a85da7d9f05cbfd76ed365e6acdebfed6bb06d1b2bce1f6c20304097d5ea', '[\"*\"]', '2026-03-27 07:25:31', NULL, '2026-03-27 07:23:25', '2026-03-27 07:25:31'),
(171, 'App\\Models\\User', 3, 'auth-token', 'd75c2979b83a81798e3cc28910ae4e47e5d019c548596c791ce638831dcd9d3a', '[\"*\"]', '2026-03-27 21:11:54', NULL, '2026-03-27 21:11:06', '2026-03-27 21:11:54'),
(179, 'App\\Models\\User', 3, 'auth-token', 'b046bd0f35bef0c4856b728f3a6db1cf9a172a4846b0f6dcba2bfba228b33e67', '[\"*\"]', '2026-03-27 21:42:59', NULL, '2026-03-27 21:33:43', '2026-03-27 21:42:59'),
(180, 'App\\Models\\User', 15, 'auth-token', 'd860227a7e235f4e4b9ff3fe4b2c1d652189b709997bc572e64902c177df9425', '[\"*\"]', '2026-03-27 23:01:23', NULL, '2026-03-27 21:36:42', '2026-03-27 23:01:23'),
(183, 'App\\Models\\User', 3, 'auth-token', '2ffd44451baa150a265ccd812b2f16855ac1f08749424ad08498af95b78cccc5', '[\"*\"]', '2026-03-27 23:17:59', NULL, '2026-03-27 22:32:41', '2026-03-27 23:17:59'),
(191, 'App\\Models\\User', 15, 'auth-token', '9c31b22588677d50455c227c26cca021181b3f3c7b2736373103eb72a4bbc685', '[\"*\"]', '2026-03-28 00:14:32', NULL, '2026-03-28 00:14:05', '2026-03-28 00:14:32'),
(192, 'App\\Models\\User', 15, 'auth-token', '833bd349c316ef1af7328603aeadd81edf7bb01e5cd5ce3f1d42b6813d919a08', '[\"*\"]', '2026-03-28 00:47:18', NULL, '2026-03-28 00:29:01', '2026-03-28 00:47:18'),
(194, 'App\\Models\\User', 3, 'auth-token', '899ff68f7d1aee64ca6fd83ffab10edb9578cebdcdd944160cfd4da05cee1c70', '[\"*\"]', '2026-03-28 00:49:41', NULL, '2026-03-28 00:34:24', '2026-03-28 00:49:41'),
(195, 'App\\Models\\User', 3, 'auth-token', '1ad8396894b3426c7cb55af26764efe28970af8b68e4ef18df772b9fd6ec6920', '[\"*\"]', '2026-03-28 21:06:22', NULL, '2026-03-28 21:00:28', '2026-03-28 21:06:22'),
(196, 'App\\Models\\User', 3, 'auth-token', 'a54d1dd5e795d3da05dc12e12264ea6bbc6d459bfb89da7ea7f887b367d5d17d', '[\"*\"]', '2026-03-28 21:30:17', NULL, '2026-03-28 21:13:44', '2026-03-28 21:30:17'),
(201, 'App\\Models\\User', 3, 'auth-token', '5c1333b4934f60245c3255966b4e7113d46293337e90f9934e70a6f28ffac3e3', '[\"*\"]', '2026-03-29 05:56:13', NULL, '2026-03-29 05:56:00', '2026-03-29 05:56:13'),
(202, 'App\\Models\\User', 3, 'auth-token', '19f5a900ad6b948a0ed49115d00a057808e7574c4902a104ede6e8726e46588f', '[\"*\"]', '2026-03-29 07:10:15', NULL, '2026-03-29 06:52:41', '2026-03-29 07:10:15'),
(204, 'App\\Models\\User', 3, 'auth-token', '27cacfada44b4ee4982f8658329b744343f9ac00eb04a07f81a628c5202e540a', '[\"*\"]', '2026-03-29 08:33:47', NULL, '2026-03-29 07:10:09', '2026-03-29 08:33:47'),
(205, 'App\\Models\\User', 3, 'auth-token', 'be5222ec4a2353a7f3cb11a592913563fcff4cef3485ae1be17c143e05f2ba1e', '[\"*\"]', '2026-03-29 07:10:54', NULL, '2026-03-29 07:10:44', '2026-03-29 07:10:54'),
(206, 'App\\Models\\User', 3, 'auth-token', 'd9cb82f912cf52ded83068c79c54d4293fb54fb1fe4c9608f9b20fb5a87c1d06', '[\"*\"]', '2026-03-29 09:06:56', NULL, '2026-03-29 09:02:22', '2026-03-29 09:06:56'),
(207, 'App\\Models\\User', 3, 'auth-token', 'aa9f9170a61c93cf79305430efb480e3baacf2bc005047f61a23c7aa385cfcff', '[\"*\"]', NULL, NULL, '2026-03-29 09:02:51', '2026-03-29 09:02:51'),
(210, 'App\\Models\\User', 3, 'auth-token', 'a3aa3c9952867b18f7b5f5a62fa3def9e47d78baa185d5946f9073177523c6e8', '[\"*\"]', '2026-03-29 09:06:05', NULL, '2026-03-29 09:05:54', '2026-03-29 09:06:05'),
(212, 'App\\Models\\User', 3, 'auth-token', 'add941e24bf7626ad57de0da57e5f3d47aed722968a98660b7bfea6cfa904d11', '[\"*\"]', '2026-03-29 10:08:58', NULL, '2026-03-29 09:41:40', '2026-03-29 10:08:58'),
(213, 'App\\Models\\User', 3, 'auth-token', 'a3eb09ff471e0586bc21bca81ab562ca097ecfcc017fcb24ac3311622bf1a83f', '[\"*\"]', '2026-03-29 18:31:36', NULL, '2026-03-29 10:28:25', '2026-03-29 18:31:36'),
(216, 'App\\Models\\User', 17, 'auth-token', '418cba6f1351382e7989fab55607f1aafa1c92f0933cd6b1487926849e9962e0', '[\"*\"]', '2026-03-29 18:10:24', NULL, '2026-03-29 16:27:44', '2026-03-29 18:10:24'),
(217, 'App\\Models\\User', 17, 'auth-token', '00dae331c2c21664e1876acf34b93d570aa1013826a67d07ea376391c6d2d484', '[\"*\"]', '2026-03-29 20:01:16', NULL, '2026-03-29 18:31:53', '2026-03-29 20:01:16'),
(220, 'App\\Models\\User', 3, 'auth-token', 'da5d2eea5abadde144c41c908c2df48853e281a8a3a0719e25543e6b8d88e8c2', '[\"*\"]', '2026-03-29 19:23:11', NULL, '2026-03-29 19:07:52', '2026-03-29 19:23:11'),
(221, 'App\\Models\\User', 3, 'auth-token', '214ebe0301268eafc9defe05a5153d174e33889d70d378e49b7ed524a3994f5e', '[\"*\"]', '2026-03-29 21:08:39', NULL, '2026-03-29 21:08:27', '2026-03-29 21:08:39'),
(223, 'App\\Models\\User', 3, 'auth-token', '59d666b7de06a1ef7ec8b5f9eccc85b31396ce5e9c63df5fe097f796601e6207', '[\"*\"]', '2026-03-30 00:23:10', NULL, '2026-03-29 22:05:51', '2026-03-30 00:23:10'),
(227, 'App\\Models\\User', 17, 'auth-token', '7654024369935ab1d1e3f8e45e6a3a9d276c92029f6c5a0f7d14197daaeeed4b', '[\"*\"]', '2026-03-30 00:25:20', NULL, '2026-03-30 00:09:24', '2026-03-30 00:25:20'),
(228, 'App\\Models\\User', 3, 'auth-token', '8592ba84ee8a0f089f487ed732dbe8ceec8ab1091b7337ec128d764037c3a7d4', '[\"*\"]', '2026-04-01 21:58:43', NULL, '2026-04-01 21:54:54', '2026-04-01 21:58:43');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `unit_id` bigint(20) UNSIGNED DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `brand_id` bigint(20) UNSIGNED DEFAULT NULL,
  `model_id` bigint(20) UNSIGNED DEFAULT NULL,
  `barcode` varchar(100) DEFAULT NULL,
  `product_code` varchar(50) NOT NULL,
  `product_type` varchar(20) NOT NULL DEFAULT 'appliance' COMMENT 'appliance | consumable',
  `capacity_rating` varchar(20) DEFAULT NULL COMMENT 'HP / capacity rating for appliances: 1HP, 1.5HP, 2HP, 2.5HP, 3HP, 5HP',
  `description` text DEFAULT NULL COMMENT 'Descriptive attributes for consumable supplies',
  `pieces_per_package` int(10) UNSIGNED DEFAULT NULL COMMENT 'Number of individual pieces in one package unit (consumables)',
  `product_name` varchar(255) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `cost_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `warranty_period_months` int(11) NOT NULL DEFAULT 0,
  `recommended_stocks` int(11) NOT NULL DEFAULT 0,
  `safety_stock` int(10) UNSIGNED DEFAULT NULL,
  `max_stock_level` int(10) UNSIGNED DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `variant` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `unit_id`, `category_id`, `brand_id`, `model_id`, `barcode`, `product_code`, `product_type`, `capacity_rating`, `description`, `pieces_per_package`, `product_name`, `unit_price`, `cost_price`, `warranty_period_months`, `recommended_stocks`, `safety_stock`, `max_stock_level`, `quantity`, `status_id`, `created_at`, `updated_at`, `variant`) VALUES
(14, 2, 1, 3, NULL, '32131', '1123', 'appliance', '1HP', NULL, NULL, 'LG 43', 1500.00, 1000.00, 0, 20, NULL, NULL, 0, 2, '2026-02-14 04:38:02', '2026-03-27 07:33:15', NULL),
(15, 2, NULL, NULL, NULL, '12345', '3124123', 'appliance', NULL, NULL, NULL, 'TV SAM 45', 15999.00, 15999.00, 0, 20, NULL, NULL, 0, 1, '2026-02-14 04:39:57', '2026-03-27 07:33:15', NULL),
(16, 2, 1, 8, NULL, '412455124', '53121', 'appliance', '1HP', NULL, NULL, 'Aircon 14', 5000.00, 5000.00, 0, 20, NULL, NULL, 0, 2, '2026-02-14 05:00:21', '2026-03-27 07:33:15', NULL),
(17, 2, NULL, NULL, NULL, '12314', '53421', 'appliance', NULL, NULL, NULL, 'laptop', 35000.00, 35000.00, 0, 20, NULL, NULL, 0, 1, '2026-02-14 05:31:27', '2026-03-27 07:33:15', NULL),
(18, 2, 4, 8, NULL, '431534', '3211', 'appliance', NULL, NULL, NULL, 'LG 69', 3000.00, 3000.00, 0, 20, NULL, NULL, 0, 1, '2026-02-14 23:39:27', '2026-03-27 07:33:15', NULL),
(19, 2, NULL, 2, NULL, '13213', '132123', 'appliance', NULL, NULL, NULL, 'Adidas', 15000.00, 15000.00, 0, 20, NULL, NULL, 0, 1, '2026-02-16 15:08:22', '2026-03-27 07:33:15', NULL),
(20, 2, 5, 6, NULL, '23223', 'FEB14', 'appliance', NULL, NULL, NULL, 'JKL 143', 1000.00, 1000.00, 0, 20, NULL, NULL, 0, 1, '2026-02-16 16:03:25', '2026-03-27 07:33:15', NULL),
(21, 1, 1, 1, NULL, '13251423', '12313', 'appliance', '2HP', NULL, NULL, 'Airqueen', 10000.00, 10000.00, 0, 20, NULL, NULL, 21, 1, '2026-02-16 16:05:19', '2026-03-29 09:06:32', NULL),
(22, 1, 1, 7, NULL, NULL, 'as-30 pro', 'appliance', NULL, NULL, NULL, 'LG 53', 15000.00, 15000.00, 0, 20, NULL, NULL, 0, 1, '2026-02-17 01:49:45', '2026-03-27 07:33:15', NULL),
(23, 3, 5, NULL, NULL, NULL, '2314', 'appliance', NULL, NULL, NULL, 'Cooper tube', 10000.00, 10000.00, 0, 20, NULL, NULL, 0, 1, '2026-02-17 01:50:54', '2026-03-27 07:33:15', NULL),
(24, 1, 1, 1, NULL, '23123', 'CUST-1771283337298-7zv3fl', 'appliance', '2HP', NULL, NULL, 'ytttf3', 4888.00, 4888.00, 0, 20, NULL, NULL, 0, 1, '2026-02-17 07:09:01', '2026-03-27 07:33:15', NULL),
(25, 2, 1, 8, NULL, '1231a', 'as2456', 'appliance', '1HP', NULL, NULL, 'Aircon', 600.00, 600.00, 0, 20, NULL, NULL, 0, 1, '2026-02-17 07:11:48', '2026-03-27 07:33:15', NULL),
(26, 1, 4, 7, NULL, '653243as', 'CUST-1771307096819-kafcaw', 'appliance', '1HP', NULL, NULL, '123123', 4000.00, 4000.00, 0, 20, NULL, NULL, 0, 1, '2026-02-17 13:44:58', '2026-03-27 07:33:15', NULL),
(27, NULL, 1, 7, NULL, 'rtrq2312', 'CUST-1771608440028-rvciy0', 'appliance', '2.5HP', NULL, NULL, 'the best', 500.00, 200.00, 0, 20, NULL, NULL, 0, NULL, '2026-02-21 01:27:20', '2026-03-27 07:33:15', NULL),
(28, NULL, 4, 7, NULL, NULL, 'CUST-1771608777711-uktnlp', 'appliance', NULL, NULL, NULL, 'SKIBIDI12312', 6000.00, 0.00, 0, 20, NULL, NULL, 0, NULL, '2026-02-21 01:32:58', '2026-03-27 07:33:15', NULL),
(29, NULL, 1, 8, NULL, NULL, 'CUST-1771608840893-friwji', 'appliance', NULL, NULL, NULL, 'sKIBISAIDB123', 10000.00, 0.00, 0, 20, NULL, NULL, 0, NULL, '2026-02-21 01:34:01', '2026-03-27 07:33:15', NULL),
(30, NULL, 5, 7, NULL, NULL, 'CUST-1771609189179-cm2wsg', 'appliance', NULL, NULL, NULL, 'rwra', 5000.00, 0.00, 0, 20, NULL, NULL, 0, NULL, '2026-02-21 01:39:49', '2026-03-27 07:33:15', NULL),
(31, 2, 2, NULL, NULL, NULL, '32123', 'appliance', NULL, NULL, NULL, 'hahahha', 150.00, 100.00, 0, 20, NULL, NULL, 0, NULL, '2026-02-22 00:46:45', '2026-03-27 07:33:15', NULL),
(32, 2, 1, 9, NULL, '123fasd', 'Grade A', 'appliance', '3HP', NULL, NULL, 'AIra', 5000.00, 999.97, 0, 20, NULL, NULL, 26, NULL, '2026-02-23 13:32:37', '2026-03-27 17:27:17', NULL),
(33, 2, 4, 9, NULL, '786T6YGUH', 'GHGGH', 'appliance', '1.5HP', NULL, NULL, 'IUYG', 3000.00, 1500.00, 0, 20, NULL, NULL, 0, NULL, '2026-02-24 01:50:09', '2026-03-27 07:33:15', NULL),
(34, 3, 4, NULL, NULL, '123awd', 'PROD-6ECD25F4', 'consumable', NULL, '1/4 inch', 50, 'AC copper', 50.00, 20.00, 0, 20, NULL, NULL, 0, NULL, '2026-02-25 06:33:39', '2026-03-27 07:33:15', NULL),
(35, 3, 4, NULL, NULL, '132ads', 'PROD-199C4B00', 'consumable', NULL, 'HAHAHSDAIDS', 213, 'Skibidi toilet', 12.00, 5.00, 0, 20, NULL, NULL, 30, NULL, '2026-02-25 06:44:34', '2026-03-29 19:12:56', NULL),
(36, 1, 1, NULL, NULL, '132szdsa', 'PROD-93FE1043', 'consumable', NULL, 'adsjad', 50, 'Ssisi', 40.00, 20.00, 0, 20, NULL, NULL, 0, NULL, '2026-02-25 06:45:27', '2026-03-27 07:33:15', NULL),
(37, 1, 4, 8, NULL, '09j12', 'HI2', 'appliance', '1.5HP', NULL, NULL, 'H2I Airconditioning', 3000.00, 1500.00, 0, 20, NULL, NULL, 7, NULL, '2026-03-24 21:49:02', '2026-03-27 17:11:16', NULL),
(38, 2, 2, NULL, NULL, '090lm', 'PROD-8CFF1292', 'consumable', NULL, NULL, 100, 'TL copper 1/4', 15.00, 70.00, 0, 20, NULL, NULL, 21, NULL, '2026-03-24 21:59:35', '2026-03-29 17:43:20', NULL),
(39, 1, 1, 8, NULL, '09joh7', 'DF30', 'appliance', '1HP', NULL, NULL, 'Airconhana', 3000.00, 1500.00, 0, 20, NULL, NULL, 19, NULL, '2026-03-25 11:31:14', '2026-03-30 00:25:18', NULL),
(40, 2, 4, NULL, NULL, '09kil', 'PROD-1E067FC4', 'consumable', NULL, NULL, 50, '1/4', 15.00, 4.00, 0, 20, NULL, NULL, 16, NULL, '2026-03-25 11:31:58', '2026-03-29 19:12:19', NULL),
(41, 1, 1, 8, NULL, '1040047425762', 'HASK20', 'appliance', '1HP', NULL, NULL, 'test', 21.00, 10.00, 0, 20, NULL, NULL, 2, NULL, '2026-03-27 02:19:42', '2026-03-29 18:45:43', NULL),
(42, 4, NULL, NULL, NULL, '1234567890128', 'CONS-D7CFFC0875', 'consumable', NULL, NULL, 5, 'PVC Pipe', 100.00, 60.00, 0, 0, NULL, NULL, 4, NULL, '2026-03-29 16:17:56', '2026-03-29 23:59:59', NULL),
(43, 1, 2, 4, NULL, '525002741350', 'PROD-53F01457BA', 'appliance', NULL, NULL, NULL, 'LG99', 1000.00, 500.00, 0, 0, NULL, NULL, 0, NULL, '2026-03-29 16:45:03', '2026-03-29 17:44:34', NULL),
(44, 1, 2, 3, NULL, '1234567890', 'PROD-CD6899B38D', 'appliance', NULL, NULL, NULL, 'Lg 90', 1000.00, 5000.02, 0, 0, NULL, NULL, 0, NULL, '2026-03-29 17:09:03', '2026-03-29 17:09:38', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `profit_loss`
--

CREATE TABLE `profit_loss` (
  `profit_loss_id` bigint(20) UNSIGNED NOT NULL,
  `model_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `reference_type` varchar(50) DEFAULT NULL,
  `transaction_date` date DEFAULT NULL,
  `incident_date` date DEFAULT NULL,
  `serial_number` varchar(100) DEFAULT NULL,
  `quantity_lost` int(11) NOT NULL DEFAULT 0,
  `unit_cost` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_loss_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `recorded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `po_id` bigint(20) UNSIGNED NOT NULL,
  `supplier_id` bigint(20) UNSIGNED DEFAULT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `pc_number` varchar(50) NOT NULL,
  `order_date` date DEFAULT NULL,
  `expected_delivery_date` date DEFAULT NULL,
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `grand_total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ordered_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approval_notes` text DEFAULT NULL,
  `received_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchase_orders`
--

INSERT INTO `purchase_orders` (`po_id`, `supplier_id`, `location_id`, `pc_number`, `order_date`, `expected_delivery_date`, `total_amount`, `grand_total`, `status_id`, `ordered_by`, `created_by`, `approved_by`, `approval_notes`, `received_by`, `created_at`, `updated_at`) VALUES
(6, 6, 1, 'PO-20260327-823', '2026-03-27', NULL, 56000.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-27 06:48:53', '2026-03-27 06:48:53'),
(7, 6, 1, 'PO-20260327-325', '2026-03-27', NULL, 35838.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-27 07:38:01', '2026-03-27 07:38:01'),
(8, 6, 1, 'PO-20260327-926', '2026-03-27', NULL, 416647.00, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(9, 6, 3, 'PO-20260328-276', '2026-03-28', '2026-03-28', 22500.00, 22500.00, 9, NULL, 3, NULL, NULL, NULL, '2026-03-27 18:02:45', '2026-03-27 18:02:56'),
(10, 6, 3, 'PO-20260328-685', '2026-03-28', '2026-03-28', 77998.00, 77998.00, 9, NULL, 14, NULL, NULL, NULL, '2026-03-27 19:22:19', '2026-03-27 19:22:32'),
(11, 6, 3, 'PO-20260328-249', '2026-03-28', '2026-03-28', 23000.00, 23000.00, 9, NULL, 3, NULL, NULL, NULL, '2026-03-27 19:29:45', '2026-03-27 19:29:53'),
(12, 6, 3, 'PO-20260328-446', '2026-03-28', '2026-03-31', 31668.00, 31668.00, 9, NULL, 15, NULL, NULL, NULL, '2026-03-28 00:05:53', '2026-03-28 00:12:36'),
(13, 6, 3, 'PO-20260328-501', '2026-03-28', '2026-03-31', 71998.00, 71998.00, 9, NULL, 3, NULL, NULL, NULL, '2026-03-28 00:46:32', '2026-03-28 00:48:01'),
(14, 6, 3, 'PO-20260328-227', '2026-03-28', '2026-03-31', 126000.00, 126000.00, 3, NULL, 15, NULL, NULL, NULL, '2026-03-28 00:47:18', '2026-03-28 00:47:18'),
(15, 6, 3, 'PO-20260330-730', '2026-03-30', '2026-04-02', 6000.00, 6000.00, 3, NULL, 3, NULL, NULL, NULL, '2026-03-30 00:22:35', '2026-03-30 00:22:35');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_details`
--

CREATE TABLE `purchase_order_details` (
  `po_detail_id` bigint(20) UNSIGNED NOT NULL,
  `po_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity_ordered` int(11) NOT NULL DEFAULT 0,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchase_order_details`
--

INSERT INTO `purchase_order_details` (`po_detail_id`, `po_id`, `product_id`, `quantity_ordered`, `unit_price`, `subtotal`, `created_at`, `updated_at`) VALUES
(1, 6, 30, 50, 1000.00, 50000.00, '2026-03-27 06:48:53', '2026-03-27 06:48:53'),
(2, 7, 15, 2, 15999.00, 31998.00, '2026-03-27 07:38:01', '2026-03-27 07:38:01'),
(3, 8, 15, 2, 15999.00, 31998.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(4, 8, 16, 8, 5000.00, 40000.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(5, 8, 18, 2, 3000.00, 6000.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(6, 8, 19, 8, 15000.00, 120000.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(7, 8, 21, 2, 10000.00, 20000.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(8, 8, 22, 8, 15000.00, 120000.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(9, 8, 24, 2, 4888.00, 9776.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(10, 8, 25, 8, 600.00, 4800.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(11, 8, 27, 2, 200.00, 400.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(12, 8, 28, 8, 0.00, 0.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(13, 8, 30, 2, 0.00, 0.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(14, 8, 31, 8, 100.00, 800.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(15, 8, 33, 2, 1500.00, 3000.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(16, 8, 34, 8, 20.00, 160.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(17, 8, 36, 2, 20.00, 40.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(18, 8, 37, 8, 1500.00, 12000.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(19, 8, 39, 2, 1500.00, 3000.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(20, 8, 40, 8, 4.00, 32.00, '2026-03-27 08:57:15', '2026-03-27 08:57:15'),
(21, 9, 39, 15, 1500.00, 22500.00, '2026-03-27 18:02:45', '2026-03-27 18:02:45'),
(22, 10, 15, 2, 15999.00, 31998.00, '2026-03-27 19:22:19', '2026-03-27 19:22:19'),
(23, 10, 16, 8, 5000.00, 40000.00, '2026-03-27 19:22:19', '2026-03-27 19:22:19'),
(24, 10, 18, 2, 3000.00, 6000.00, '2026-03-27 19:22:19', '2026-03-27 19:22:19'),
(25, 11, 21, 2, 10000.00, 20000.00, '2026-03-27 19:29:45', '2026-03-27 19:29:45'),
(26, 11, 39, 2, 1500.00, 3000.00, '2026-03-27 19:29:45', '2026-03-27 19:29:45'),
(27, 12, 18, 3, 3000.00, 9000.00, '2026-03-28 00:05:53', '2026-03-28 00:05:53'),
(28, 12, 28, 8, 0.00, 0.00, '2026-03-28 00:05:53', '2026-03-28 00:05:53'),
(29, 12, 33, 2, 1500.00, 3000.00, '2026-03-28 00:05:53', '2026-03-28 00:05:53'),
(30, 12, 34, 8, 20.00, 160.00, '2026-03-28 00:05:53', '2026-03-28 00:05:53'),
(31, 12, 37, 13, 1500.00, 19500.00, '2026-03-28 00:05:53', '2026-03-28 00:05:53'),
(32, 12, 40, 2, 4.00, 8.00, '2026-03-28 00:05:53', '2026-03-28 00:05:53'),
(33, 13, 15, 2, 15999.00, 31998.00, '2026-03-28 00:46:32', '2026-03-28 00:46:32'),
(34, 13, 16, 8, 5000.00, 40000.00, '2026-03-28 00:46:32', '2026-03-28 00:46:32'),
(35, 14, 18, 2, 3000.00, 6000.00, '2026-03-28 00:47:18', '2026-03-28 00:47:18'),
(36, 14, 19, 8, 15000.00, 120000.00, '2026-03-28 00:47:18', '2026-03-28 00:47:18'),
(37, 15, 39, 4, 1500.00, 6000.00, '2026-03-30 00:22:35', '2026-03-30 00:22:35');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_returns`
--

CREATE TABLE `purchase_returns` (
  `purchase_return_id` bigint(20) UNSIGNED NOT NULL,
  `po_id` bigint(20) UNSIGNED DEFAULT NULL,
  `supplier_id` bigint(20) UNSIGNED DEFAULT NULL,
  `receiving_id` bigint(20) UNSIGNED DEFAULT NULL,
  `pr_number` varchar(50) NOT NULL,
  `return_date` date DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `requested_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_return_details`
--

CREATE TABLE `purchase_return_details` (
  `pr_detail_id` bigint(20) UNSIGNED NOT NULL,
  `purchase_return_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity_returned` int(11) NOT NULL DEFAULT 0,
  `unit_cost` decimal(10,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `condition` varchar(100) DEFAULT NULL,
  `serial_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receivings`
--

CREATE TABLE `receivings` (
  `receiving_id` bigint(20) UNSIGNED NOT NULL,
  `pc_id` bigint(20) UNSIGNED DEFAULT NULL,
  `supplier_id` bigint(20) UNSIGNED DEFAULT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `receiving_number` varchar(50) NOT NULL,
  `receiving_date` date DEFAULT NULL,
  `received_by` bigint(20) UNSIGNED DEFAULT NULL,
  `total_quantity_received` int(11) NOT NULL DEFAULT 0,
  `total_quantity_damaged` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `receivings`
--

INSERT INTO `receivings` (`receiving_id`, `pc_id`, `supplier_id`, `location_id`, `receiving_number`, `receiving_date`, `received_by`, `total_quantity_received`, `total_quantity_damaged`, `created_at`, `updated_at`) VALUES
(3, 8, NULL, 1, 'RCV-1774634681353', '2026-03-27', NULL, 6, 0, '2026-03-27 11:04:41', '2026-03-27 11:04:41'),
(4, 8, NULL, 1, 'RCV-1774657075165', '2026-03-28', NULL, 3, 0, '2026-03-27 17:17:55', '2026-03-27 17:17:55'),
(5, 7, NULL, 1, 'RCV-1774657248009', '2026-03-28', NULL, 1, 0, '2026-03-27 17:20:48', '2026-03-27 17:20:48'),
(6, 11, NULL, 1, 'RCV-1774665267552', '2026-03-28', NULL, 1, 0, '2026-03-27 19:34:27', '2026-03-27 19:34:27'),
(7, 11, NULL, 1, 'RCV-1774665468586', '2026-03-28', NULL, 1, 0, '2026-03-27 19:37:48', '2026-03-27 19:37:48');

-- --------------------------------------------------------

--
-- Table structure for table `receiving_details`
--

CREATE TABLE `receiving_details` (
  `receiving_detail_id` bigint(20) UNSIGNED NOT NULL,
  `receiving_id` bigint(20) UNSIGNED DEFAULT NULL,
  `po_detail_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `prod_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `quantity_amount` int(11) NOT NULL DEFAULT 0,
  `condition` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `receiving_details`
--

INSERT INTO `receiving_details` (`receiving_detail_id`, `receiving_id`, `po_detail_id`, `product_id`, `created_at`, `updated_at`, `prod_price`, `quantity_amount`, `condition`) VALUES
(3, 3, NULL, 40, '2026-03-27 11:04:41', '2026-03-27 11:04:41', 0.00, 6, 'Good'),
(4, 4, NULL, 32, '2026-03-27 17:17:55', '2026-03-27 17:17:55', 0.00, 3, 'Good'),
(5, 5, NULL, 32, '2026-03-27 17:20:48', '2026-03-27 17:20:48', 0.00, 1, 'Good'),
(6, 6, NULL, 21, '2026-03-27 19:34:27', '2026-03-27 19:34:27', 0.00, 1, 'Good'),
(7, 7, NULL, 21, '2026-03-27 19:37:48', '2026-03-27 19:37:48', 0.00, 1, 'Good');

-- --------------------------------------------------------

--
-- Table structure for table `restock_recommendations`
--

CREATE TABLE `restock_recommendations` (
  `recommendation_id` bigint(20) UNSIGNED NOT NULL,
  `item_id` bigint(20) UNSIGNED DEFAULT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `current_stock` decimal(10,2) NOT NULL DEFAULT 0.00,
  `reorder_level` decimal(10,2) NOT NULL DEFAULT 0.00,
  `recommended_quantity` decimal(10,2) NOT NULL DEFAULT 0.00,
  `reason` varchar(255) DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'System Administrator', '2026-02-01 05:56:03', '2026-02-01 05:56:03'),
(2, 'inventory_analyst', 'Inventory Analyst', '2026-02-14 03:57:06', '2026-02-14 03:57:06'),
(3, 'branch_manager', 'Branch Manager', '2026-02-14 03:57:06', '2026-02-14 03:57:06'),
(4, 'warehouse_personnel', 'Warehouse Personnel', '2026-02-14 03:57:06', '2026-02-14 03:57:06'),
(5, 'auditor', 'Auditor', '2026-02-14 03:57:06', '2026-02-14 03:57:06');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sales_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `order_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT NULL,
  `payment_due` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_paid` decimal(12,2) NOT NULL DEFAULT 0.00,
  `payment_status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount_paid` decimal(12,2) NOT NULL DEFAULT 0.00,
  `balance_due` decimal(12,2) NOT NULL DEFAULT 0.00,
  `sold_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sales_details`
--

CREATE TABLE `sales_details` (
  `sales_detail_id` bigint(20) UNSIGNED NOT NULL,
  `sales_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('08lqIoWy0ONnCVUkFqpJ7elOTAyNRaRJbd8s90dZ', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic1VkMlpBWTFRMzJyZk5NSmdsVldJMUNOOFlLQkRSeThWa3R4SWI1dSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459703),
('3NDLg880hbSjnGeiBUkWApcAyMlBGvEMxpeLtVHR', NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibmNaUGRxbEdxM0d4SmpJUm11M05XRjhnZzdnRENZWDR2Z3pOY1BkRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774801874),
('3Y9SxkkBpcXsZks5FrDwuQDCnEDdO8DRHg8n85b4', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNEllS1hLWmdXNW03MmxTNHJJREI1c0hSVnpQVTRKVkxNWmlHWlh1MCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459704),
('42FPrx64Ncmx0o4s8mzCwIQw57lCVBCpoNucgqEm', NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSmVmWWZwYmgyWFhJWDA4SFF5ZlpuT3QxaVF1Wlg5NHhpRktMMmNyYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774826748),
('4pX74MLzeK93py3w0L030fNZgjcrCi4zdjfg0L3A', NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicXFjOHVsdUYwUW9SOVcybElnTmxpRk5OOVNJd25kMUY0aFp0WXFWTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774800142),
('5ImQ0sw1aAKYU3oDjSJURWMbd6ZBHJAw83p7i4Ie', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiRG44bkJydE5Sc1M3Y1I1d1UzT3p1dHk0UmF4Tm1ocnh6VFRHU1p4dCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769459610),
('64cN8IsRe4RdFQdT3lo2u0Mb5HwkjHXWTyogpl86', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNmdYUGFDWHJodUI2NENpMXFMMk5oNTI0V3NWN2pWWFhWdkNrWUppUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497619),
('6ERJb09OKYq6ZJ7d72vougnBGpvPD3aOEHg62mSl', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRkdHTWYyN293YkpSa3RBV1ExejUxNXhhZjQwVUZEQW1HU3lZdHhKdyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769476286),
('6gSITYxMysIXxw0MvjOX28U02Lf0XrLVXQA3Ne15', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoielUwQlN4dnVmNUU1YnhZZHRMSkpjc1FSTnFRVlJVRGR0WEFDUkJHWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497642),
('6OZVqddDyx3vprtJ7SFb3yi5E4t7V64tWRpBstM7', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHNHWGdMWjdKWHNOMm1ZR1RJeWxUdjRwc0tFU0d6UVY0VUdBazhDTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497465),
('6VGcD9PeiVDVNX65aKfVEJ2S9K8l0566fY5tYKCC', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibm1xSHpIWlBERFlQV0pPcXowQjg1NTZMSzV0aElWT2xMNUE0U0hQeCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769497529),
('7IoImWhTp8m53mQUlRTDcZpUVNmtmPdUuyCrxLjm', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVG9NVkk2eWpCZHlVYzJ2SThKbU94cjFSSFhGZ1dIWFNUc1hPeU1FNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769498629),
('7yKdxr3MQfs0ahp7ouE981937i1oXxmk3M1Gardj', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNUtvZUNJc0NNclRtSnZGc3hRMVBEZzNMMXQ0NDNJMkVlOU8yRHdycCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769460014),
('9JbyCvkBK9NXDM5Xo5spkRxU6VU3UKJaBPLMMsGO', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiblZkUWxGTk5Mc01mSksxYUszVmZ6QVlaaVFzVzl5T0dPa241dDRQbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769462312),
('AfbaSXpHjPWfCVzQZwmdlbSiuLLJF8BYc3IT5LwX', NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTHp3aU1UZVg0T1o3ZW9tb3ZMVUV0UFhVSWt4NU9WTW1UMDJ0dzJncCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774800170),
('AKhjEcqhj5LvmNWSwYrizsFiqJnUtocAxJo6tuw7', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiREw1allRcmxPcWhVYlZhWmVHaHJxNDBhamFzZTVoYjh4SGJ0NkM4TSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769459995),
('CfxPAlR1pLZLOzRRSSsv5DLSyByYWptRPlqSoGXA', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieDFmRzVhV3Y1NENhQVRhbDk2N0N3WGpoMExKY2Y0Z0czcW1QSW90RiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459729),
('CPwyrGJp75OT3XWg2bx1CQD9gcxeDq9Bdg5kuZf2', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYzR2cnhIY3cwbHprTkhteTJpQVZORVZyaHBqWXRRbHM5MERNN0hqZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459613),
('dlpoUXyXr7XvtvOrOaJKO2fKklLJIkgaB7U4e4D7', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSlpTZVBYeG9ib2ZMNEJHaVV0dW5WT3A4enVzRzd0QUdsUlBpV0w2VCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459728),
('Emx80h4U9xcs9NfrSBcZsbUYKBUF3qlpe4s9wYGw', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicG16VGlhaTB3bkFKWlhhaUQ0MDdLZzlRWWNGcUt3blR6ejJjWXpaWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497532),
('ew1DRkwJCSWGOUUQsGGXY8GG2Yb6SwmGiiH8pBTp', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiajhKdW56alNTQVNITFlBaWFWbEVqamQ1RG05cW1UTjJEb3JtRWs0VSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772138392),
('EZFQ89FO3uPvJcBN0EVYi3Unk1la6WV8cPSS1L7V', NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieWRFRXA5dUxsZ09FMGpFUUMxQ0ljSzRCY1hzU0F4bFp0UzBTODNCTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774802499),
('FIzVJqjL9mCqJKFZb5kyVEODNGJuB11Zlyb3hZgh', NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMFBLRnR0YnZwMU5haWhSUlh2Q3VQbnVEOG84am1wbU96dDc2OG4wcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774826803),
('gDLgCpQ4J7mLFQBsl2Oz2mxWWwvzXe6kbU1fPNrk', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicWl6OUZBdXZBU1BHeVgzYXg3UUk2TzEwazNwT0piaHRmam5PaFRkMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1771306985),
('GhKfiOelAEPJhvVEbTXPtAfr7dSs1O6vuT0ULY0u', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZEhyelBPUFZTMU5sV0hTalhjS3B4d0g1S2dXUnRLQ0gzZlpjdDd1bSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497498),
('GS2eRXi3ff14YWnoZaU9giZ7eSfGBkiJc4hbDUyA', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSnN1NENVZEx4WjE5bnV2dFlVaHoxWWJXS0ZoSEhRTzRhUWZrU3NyQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772086682),
('hcaJ9Mqq0eeB4bg0V22jHwYmqJ6U86QXBdw1YT4L', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidW1UWEtLZWt2N2ptVTg5R0R3TkY2V2xiME9mUHJIWUlhQ04wWGJraiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769496344),
('i9womDFsZqzJ6LwTu21TuI85H2t2Dlxpc78yOTAn', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQW1YaWpyblNJNHZHV1JuYUNXdEhmNjU3Nzhyc0FvaWJnN2VMT3dabiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497632),
('jDCXW3DFNepUlItZKgbWfwZDFOP1s0b7oEhtfk0Z', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibzlTdW5hQ0xKUHdLek5jUE9IYTFKYVNGNmNqbTJNVG5jWklBY2pVUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769496368),
('jGKd96eLCjT6rjGtmj73d4Bt2KdjEEHF3AlPL25x', NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS2lqZ1BQY1BKbjRoTWp4bkZvQVRQUGthTlI2MmdLOW43UVE1RlNWYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774800328),
('juHuWSdSGyjApTLAt7n4ldGtKEkMPQB2IKHX1DaE', NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieEJubW13T1Q1eTdPbHZLSGYwanFnTHhRTzVYVkZCcGJyZ2M5M1dNUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774800186),
('JwXLYnph5G1QohlIruaGR6HDUmik3v4f0lD0pgFG', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWmY4dVRydU5wcnRCbkZJc0JvQ2JEcFNGOGpuRkwwU0N1ZG5HQnNmeCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772086698),
('jYtoDaEBaNStFcKIOYkBJINYMPFnCQu2FN8o5fau', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic1ZtN3l4cW95b1VRb21JVkZiZ3hIdjByOEtMQ2tsZGpIQ3RLaUV4ayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769462324),
('kMrPRHg0aJvcaNi8r3sgBC3qAU0f9HA7lmFBaYLm', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiU0pZNGdQMEUwc2xTU0c4WVhmMFFBV1Vjc1RTenB4VHQ0elNqRDUyUyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769498625),
('krCG7rsfjRSspjTT23GNy41mCxGpxwm6oI3M1HKe', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoickRoT2VNNTkyS3JLMmVMS1JpT3BBdmRITG1OOFdsUHZLRzlRb3BUMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769460025),
('KsFT3h1ULLQwDOrLHFMRsMZoEVMwlz1E2ZoRPHjN', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMGl2TThyazhReVVHVHM2Y1dzZmxJZkpjbnhLUGJRaUx1U2N4Q2dXWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497531),
('kWHnfqtOq0dXBCNQ9lwpdP5wZCvUPfHt41WposQn', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ3F0Q2c0MVRPS0RaVEt5dkZTUGxyYUVzSkdyTGpJVlFVMDV2aDY3MyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769496372),
('La4foWjrllTimonFL4xyvvXvrvzZuXKwNzhmcDsB', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSkxlZlN0QUppNU56d0lmTDdFYzMxN0NyRG9KdkxhZGY3cEY5ZW9xWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497619),
('lBqypemZdo196VMu1CwKTEvHZZJ5STZjMDOz3KDd', NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibDNhNU9pOW5WMFgwT2xBRWhNQVFxRGJTRGxsdXd1SnE5S2N2b2g3SCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774793443),
('LJyDD1Cm2OEhaNvU8FGE8u747QmUoMpgenj1Sbr1', NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUmI4dklBaW1WMWtvOEJqd3Y5dkZLOFdoWXUwQ0ZuRUxDdWdaODlBaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774805304),
('lv2du6E9vhc8kAZE1zZpB1UiQYyYbOBcGK9GktAh', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieFdydmVMeWRDeWpOZWhFWG9PVUFORXdKSEpDSjZUY1Z0WWtNMW8xQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459999),
('lYO3dl1QZb7UeuLAtI89GsZTjdZTPPdrXkVK1rET', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ1Q5M2Rzd0M2WXFDN09uV1N0Z2g5cEZOUjUyRHhSbmNQMUhSdEhaTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459612),
('nnzSW6S6ZXT564TsTkFmCNqiqHsVWdTCblkPNzFB', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNzJqc0diR05HUW9xN0xzQ2FiWWV1U0VoQTAwVnBSYjR0aEJpS1NQZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769496349),
('o4prgqYHNQwrGpFrTR0p7XQCuFgQFkQTpRxTbUb7', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaHZSbWttblhLTW9GT052MWNKMHZVVGd4a0cyd21kY3NDQ2hiandjcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497462),
('ohqdECvHcWI6xPdIWdwHXHBgisWxVe1I8vSCVvld', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZmRUR3NrR3JzeEVoWU53U3FEN2hMWW52cnFrOTh1cTJYTkk1dDljUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459998),
('PlyTOwa9OOTl0WOEMOaBnzYBvfKWAXVPdI99HRfo', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOWI3SDZFN09KamZUS1I4bHB4cFJtSmhLbUxTRUtrcGl5MVF3MGtZeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769498616),
('qLgKZmkVozHyAKAKZZQns3Vq0Gi5TEA7iPrdpWu3', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTml2a1JoeWtkYWJ5MVlocE9VQlNGbmF1QVN4alZsWGQzZEdWQUNrTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769496371),
('QlkTLGaMGM0GDKv7U0DioCuodkAXrFR1Qko40SnG', NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNEtsbGxQVnNKV3liUEpGY0RhUWpzc3JuOGVyNGRnNDNzSjA4WjZESSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774805298),
('qLOW3wDRZ6EOzvdXG7JgX5cJpphV2LR9ShBBcpcG', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic2VXbWVHQURzMUcxODFmV1FwV1NSWmxQTTBDbXdjdXJPb2lDRnUzZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769496348),
('R5RQLNSm8dyVKnUHH9ZXl4JqEvTYa6cwFfJfDqjG', NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRDJHRUxRdVBqVW8ydGJPZmJTalB4Q3JkOHdnWU9UQkRJczZ3V1Z0TiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774793407),
('rl7n4DLjwPt3TIJPIUJ9OmoMXXOam8wYQxJI2eRQ', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUmhjQ3NUVEJLSXVJOHQ0ZEYwSmxnV052OWdDazdkZHdxYWsyWXRvbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769460013),
('RlhD1I8lw0vbxS5PfwyhkBS78FnFN8SEpWLrYZ6w', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUzN5MTdYU3k5VlI3dEdsU1RhdUJETDZXaExMYkcwYzdHcTkwckxwWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497497),
('SKpeLnVFJAcJXSAj4jMs7g0ovoohTO09TdTpKovl', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiMTBlY0d1SkNDYUZVMXdnVVRhbUZUTkZvMURlUFhKZlRpRHF1NEtzNiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769497495),
('sl8jkOBl7ZAdZr6zNZppn0EZDnfFO0hvy2bX7Orh', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicWk1VWQzY0w5OUd0MEY3Sms5NnVzeEcxNjNKQ21RU2ozejNCYnhvbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772074339),
('tVc1nBcjR9DTBBbT7vQzfRP3xkKWytxzKKcFRzoH', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVER6alAydDZiYXlKZjF0RjFQd21haXVPZjI0UW54RXVMQXFOMjRkUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497461),
('udcky0HqojO76PvJAxzvdvAPGGmaohBSke5E7yEq', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoibTMySTJ0N1g3U3hSeFVrUDRPTjZzNHE0c1RjWE1NVDFLSzJYWFk1SiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769462322),
('V270bdkMkuVqogj3sw2zHhbzpRq3ZTCu05cRdCOM', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRE9pQmVPRDFYMW12U0NEdmdhOFlEZTN4aWVzTjROcDNobHZsWEQ5MiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769496370),
('vcyE2qhxX7t0cIIOh9kcpk0btZpskvnjTNFZPeRH', NULL, '192.168.100.45', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidTh0N25WV0FhZEJUM1NTVXBNRDBEU1U0SVdSTElPVEp3OFg3QWozMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774826864),
('VL1udKZTe0p1Zmr6GwMq64YmJoO5prUhBcyqF7re', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiakxtdTZ4OWNKaW9MbUoxc0diTXNESjhHWXRzNnFScmtlazZhM082cyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769498615),
('VMRgU3WbLZaGEVZC8hjsVX4HTbEKrV7nQoSMx3NH', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOGg0VkhYS2c1TVFIcWRJTHI0VHhDYWlqNUhjNkc4NHhFU3gyN0xUVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497465),
('vTQ8eLxDd7cxg4WnnUKZAdvZlQxFWRYq0Ngkd217', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibDEwTDFMMjJYTGhMVFJaMk9rd2s5MTZ3NEFvUjdvU0hpWTN4alBhcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497641),
('WFIsuOda8hAk2iqyc3xkxpEnRaEOxfrZG9AjR36Y', NULL, '192.168.100.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWE51Z1pTc1M4QnJOMEJ4ZTU2WFhHZjNpR3g2UWo4blM0eW5VMXJpbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHA6Ly8xOTIuMTY4LjEwMC41MDo4MDAwL3NhbmN0dW0vY3NyZi1jb29raWUiO3M6NToicm91dGUiO3M6MTk6InNhbmN0dW0uY3NyZi1jb29raWUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1774800354),
('XfEV2IpmMtWm9DHcW8lMhCCKSCvc2B4N9bwxss2j', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNTlubFdJUUdtSDlqZkhWZTE3eHg0NTg1Q2VFY2dyQlFibWJLMUJmdyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459741),
('YZdIvDzU9hHoOkK5gTNG8Ba0ysD4MrbZFz4SWHjZ', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidzBZaXZDVmZ4T0FmSXZwTlY3Y2RraEFuMmJNbkJvUE9LemI3RUZxbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769497631),
('zdEOHjIGpnhvrvDaUmru2Rd91i1w9kmgasePWZVX', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ3FPTks2TmU2dkFLbE9RQkttWmJhZHhnVW45QWRQNjVWNmlQNUhuRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769460024),
('ZFMLUdzZmLxBYMlqkOLsjE2ADi2vWghyFh25iPHX', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMGlHSWhYTzNOcGhHVVIwbDlLZHBRNDYweGxpdWFrMzg0RzFDOGw0MiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769459742),
('zmgUHTKE92ktBhyb0df7DXvt4VeRxX9JWZufCrOD', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUnh6RmpkWnBFcW5KMHpBTjFUU01qd2NpTUtIZXlxYTZFRFRjdEN3RCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769498627),
('ZWKtZY3YjP0ViXihMDotP2jaakAJZzJ23aLig6BW', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSmtNdzRLMnFrdFFmZG81WVhLTmRGbDVGNjZDczBSN1lOa2l4WWdQSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hcGkvZGFzaGJvYXJkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1769462325);

-- --------------------------------------------------------

--
-- Table structure for table `status_lookup`
--

CREATE TABLE `status_lookup` (
  `status_id` bigint(20) UNSIGNED NOT NULL,
  `status_name` varchar(50) NOT NULL,
  `status_category` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `status_lookup`
--

INSERT INTO `status_lookup` (`status_id`, `status_name`, `status_category`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Active', 'user', 1, '2026-02-01 05:56:03', '2026-02-01 05:56:03'),
(2, 'Inactive', 'product', 1, '2026-02-20 08:22:28', '2026-02-20 08:22:28'),
(3, 'Pending', 'purchase_order', 1, '2026-03-22 13:33:45', '2026-03-22 13:33:45'),
(4, 'Approved', 'purchase_order', 1, '2026-03-22 13:33:45', '2026-03-22 13:33:45'),
(5, 'Rejected', 'purchase_order', 1, '2026-03-22 13:33:45', '2026-03-22 13:33:45'),
(6, 'In Transit', 'transfer', 1, '2026-03-27 11:34:44', '2026-03-27 11:34:44'),
(7, 'Received', 'transfer', 1, '2026-03-27 11:34:44', '2026-03-27 11:34:44'),
(8, 'Pending Approval', 'purchase_order', 1, '2026-03-27 18:01:45', '2026-03-27 18:01:45'),
(9, 'Authorized', 'purchase_order', 1, '2026-03-27 18:01:45', '2026-03-27 18:01:45');

-- --------------------------------------------------------

--
-- Table structure for table `subcategory_lookup`
--

CREATE TABLE `subcategory_lookup` (
  `subcategory_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `subcategory_name` varchar(100) NOT NULL,
  `is_serialized` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` bigint(20) UNSIGNED NOT NULL,
  `supplier_name` varchar(255) NOT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `origin` varchar(20) NOT NULL DEFAULT 'Local',
  `region` varchar(100) DEFAULT NULL,
  `tin` varchar(50) DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `supplier_name`, `contact_person`, `contact_number`, `email`, `address`, `origin`, `region`, `tin`, `status_id`, `notes`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'KHEN THE GREAT', 'KASJDKAS', '029309123', 'SGAGSGA@GMAIL.COM', 'Cagayan de oro', 'Local', 'Region X - Northern Mindanao', '2313524', NULL, 'HAHAHAHA', '2026-02-21 06:29:50', '2026-02-25 13:38:04', '2026-02-25 13:38:04'),
(2, 'khentoy', '093210938921', '09988741726', 'MIDDLE@GMAIL.COM', 'JHSDJAJHDSHJ', 'International', 'Middle East', 'kjdsakjhsad', NULL, 'aircon', '2026-02-21 06:31:07', '2026-02-25 13:38:08', '2026-02-25 13:38:08'),
(3, 'Hanz birthday Boi', 'Hanz earl taga kalilangan', '092138329', 'earl@gmmail.com', 'Bukidnon malaybalay city', 'Local', 'Region X - Northern Mindanao', '21321321', 1, 'HAHAHAH', '2026-02-22 00:39:33', '2026-02-25 13:37:56', '2026-02-25 13:37:56'),
(4, 'Josh Appliance', 'john biran', '094939049823', 'josh@gmail.com', 'carmen cagayan de oro city', 'International', 'East Asia', 'adsa', 1, 'HAHAHAHA', '2026-02-23 13:30:23', '2026-02-25 13:38:00', '2026-02-25 13:38:00'),
(5, 'Cyrus the great', 'cyrus', '09879804712', 'cyrus@gmail.com', 'Jakarta Indonesia', 'International', 'Southeast Asia', '982331', 1, 'Aircon', '2026-02-24 12:36:19', '2026-02-25 13:37:49', '2026-02-25 13:37:49'),
(6, 'example', 'example', '09424242', 'example@gmail.com', 'carmen cagayan de oro city', 'Local', 'NIR - Negros Island Region', '42323', 1, NULL, '2026-02-25 08:29:02', '2026-02-25 08:29:02', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `supplier_product`
--

CREATE TABLE `supplier_product` (
  `supplier_prod_id` bigint(20) UNSIGNED NOT NULL,
  `supplier_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `product_price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'PHP',
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supplier_product`
--

INSERT INTO `supplier_product` (`supplier_prod_id`, `supplier_id`, `product_id`, `product_price`, `currency`, `status_id`, `created_at`, `updated_at`) VALUES
(2, 4, 14, 2500.00, 'PHP', 1, '2026-02-24 13:33:37', '2026-02-24 13:33:37');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transfer_tracking`
--

CREATE TABLE `tbl_transfer_tracking` (
  `tracking_id` bigint(20) UNSIGNED NOT NULL,
  `transfer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status_note` varchar(255) DEFAULT NULL,
  `recorded_at` datetime DEFAULT NULL,
  `recorded_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `type` enum('Sale','Purchase','Transfer','Restock') NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('Completed','Pending','Cancelled') NOT NULL DEFAULT 'Pending',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_type_lookup`
--

CREATE TABLE `transaction_type_lookup` (
  `transaction_type_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transfers`
--

CREATE TABLE `transfers` (
  `transfer_id` bigint(20) UNSIGNED NOT NULL,
  `from_location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `to_location_id` bigint(20) UNSIGNED DEFAULT NULL,
  `transfer_number` varchar(50) NOT NULL,
  `transfer_date` date DEFAULT NULL,
  `requested_by` bigint(20) UNSIGNED DEFAULT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `received_by` bigint(20) UNSIGNED DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_quantity_transferred` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total_quantity_received` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transfers`
--

INSERT INTO `transfers` (`transfer_id`, `from_location_id`, `to_location_id`, `transfer_number`, `transfer_date`, `requested_by`, `approved_by`, `received_by`, `status_id`, `created_at`, `updated_at`, `total_quantity_transferred`, `total_quantity_received`) VALUES
(3, 1, 3, 'TR-1774634579586', '2026-03-27', NULL, NULL, NULL, NULL, '2026-03-27 11:02:59', '2026-03-27 11:02:59', 0, 0),
(11, 1, 3, 'TR-SCAN-69c9dbf45de0a157610254', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:04', '2026-03-29 19:12:04', 1, 1),
(12, 1, 3, 'TR-SCAN-69c9dbf67d4e2451561340', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:06', '2026-03-29 19:12:06', 1, 1),
(13, 1, 3, 'TR-SCAN-69c9dbf895280681186291', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:08', '2026-03-29 19:12:08', 1, 1),
(14, 1, 3, 'TR-SCAN-69c9dbfa98fcb541024140', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:10', '2026-03-29 19:12:10', 1, 1),
(15, 1, 3, 'TR-SCAN-69c9dbfcbd1c1738761261', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:12', '2026-03-29 19:12:12', 1, 1),
(16, 1, 3, 'TR-SCAN-69c9dbfec5fcc506619912', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:14', '2026-03-29 19:12:14', 1, 1),
(17, 1, 3, 'TR-SCAN-69c9dc00f39af996382165', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:17', '2026-03-29 19:12:17', 1, 1),
(18, 1, 3, 'TR-SCAN-69c9dc0376d75400143098', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:19', '2026-03-29 19:12:19', 1, 1),
(19, 1, 3, 'TR-SCAN-69c9dc25604c6044613353', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:53', '2026-03-29 19:12:53', 1, 1),
(20, 1, 3, 'TR-SCAN-69c9dc27f0136541632308', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 19:12:55', '2026-03-29 19:12:56', 1, 1),
(21, 1, 3, 'TR-SCAN-69ca0f0ccc3b5428080374', '2026-03-30', 17, NULL, 17, 7, '2026-03-29 22:50:04', '2026-03-29 22:50:04', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `transfer_details`
--

CREATE TABLE `transfer_details` (
  `transfer_detail_id` bigint(20) UNSIGNED NOT NULL,
  `transfer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity_transferred` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `quantity_received` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transfer_details`
--

INSERT INTO `transfer_details` (`transfer_detail_id`, `transfer_id`, `product_id`, `quantity_transferred`, `created_at`, `updated_at`, `quantity_received`) VALUES
(3, 3, 39, 5, '2026-03-27 11:02:59', '2026-03-27 11:02:59', 0),
(4, 11, 40, 1, '2026-03-29 19:12:04', '2026-03-29 19:12:04', 1),
(5, 12, 40, 1, '2026-03-29 19:12:06', '2026-03-29 19:12:06', 1),
(6, 13, 40, 1, '2026-03-29 19:12:08', '2026-03-29 19:12:08', 1),
(7, 14, 40, 1, '2026-03-29 19:12:10', '2026-03-29 19:12:10', 1),
(8, 15, 40, 1, '2026-03-29 19:12:12', '2026-03-29 19:12:12', 1),
(9, 16, 40, 1, '2026-03-29 19:12:14', '2026-03-29 19:12:14', 1),
(10, 17, 40, 1, '2026-03-29 19:12:17', '2026-03-29 19:12:17', 1),
(11, 18, 40, 1, '2026-03-29 19:12:19', '2026-03-29 19:12:19', 1),
(12, 19, 35, 1, '2026-03-29 19:12:53', '2026-03-29 19:12:53', 1),
(13, 20, 35, 1, '2026-03-29 19:12:55', '2026-03-29 19:12:55', 1),
(14, 21, 39, 1, '2026-03-29 22:50:04', '2026-03-29 22:50:04', 1);

-- --------------------------------------------------------

--
-- Table structure for table `unit_lookup`
--

CREATE TABLE `unit_lookup` (
  `unit_id` bigint(20) UNSIGNED NOT NULL,
  `unit_name` varchar(50) NOT NULL,
  `unit_abbreviation` varchar(10) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `unit_lookup`
--

INSERT INTO `unit_lookup` (`unit_id`, `unit_name`, `unit_abbreviation`, `created_at`, `updated_at`) VALUES
(1, 'Unit', 'pc', '2026-02-20 08:22:28', '2026-02-20 08:22:28'),
(2, 'Piece', 'pc', '2026-02-20 08:22:28', '2026-02-20 08:22:28'),
(3, 'Roll', 'roll', '2026-02-20 08:22:28', '2026-02-20 08:22:28'),
(4, 'Meter (m)', 'METER', '2026-03-29 16:07:38', '2026-03-29 16:07:38');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `branch_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status_id` bigint(20) UNSIGNED NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `assigned_location_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`assigned_location_ids`)),
  `allowed_panels` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`allowed_panels`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `username`, `email`, `phone`, `role_id`, `branch_id`, `status_id`, `email_verified_at`, `password_hash`, `remember_token`, `created_at`, `updated_at`, `assigned_location_ids`, `allowed_panels`) VALUES
(3, 'System', 'Admin', 'admin', 'admin@example.com', NULL, 1, NULL, 1, NULL, '$2y$12$uGpGxZzt1cFxpn6y8DSiDuiJlgs9PZQQcjrhXLt/gh7fW431jY/jm', NULL, '2026-01-24 12:10:02', '2026-01-24 12:10:02', NULL, NULL),
(4, 'John', 'Baloro', 'john', 'johnphilipbaloro56@gmail.com', '09756026160', 2, NULL, 1, NULL, '$2y$12$NijEnVuFsIcEjrE4dLfSu.0049IOpziTARKaw2eUwYCmVebrpi6IK', NULL, '2026-02-14 03:59:02', '2026-03-13 06:24:19', NULL, NULL),
(5, 'marichu', 'contado', 'marichu', 'marichu@gmail.com', '123456789', 3, NULL, 1, NULL, '$2y$12$Cc7.a3CYtLn3sj/rdmGUqeW0hwuN0uy0QnmpTKoImVy4/qmhxGYvC', NULL, '2026-02-14 04:03:40', '2026-02-28 09:57:38', NULL, NULL),
(6, 'cristian', 'castro', 'cristian', 'cristian@gmail.com', '123456', 4, NULL, 2, NULL, '$2y$12$0dqwawWPRsKDBfNv2Ew8m.QV7v1fjC1q13abYWs2uDK7x5GFN8Xwe', NULL, '2026-02-14 04:06:16', '2026-03-27 07:18:09', NULL, NULL),
(7, 'silwyn', 'Ibaoc', 'silwyn', 'silwyn@gmail.com', '12345', 5, NULL, 2, NULL, '$2y$12$R3nVdwct874htHQKR9AhiOCrqvpCRZkAtxOFoSeivP7oUtGi5amVW', NULL, '2026-02-14 04:07:39', '2026-02-22 00:24:24', NULL, NULL),
(8, 'khen', 'adora', 'khen', 'khen@gmail.com', '143143', 3, NULL, 2, NULL, '$2y$12$nJDTUsxkGhN0GeOCt3ZFD./2pVqHa46MZVfKT4qaWGLuAcsu2QrpC', NULL, '2026-02-14 05:37:40', '2026-02-22 00:24:27', NULL, NULL),
(9, 'dayadaya', 'ydaddyy', 'dayadaya', 'dayday@gmail.com', '12124', 3, NULL, 2, NULL, '$2y$12$NE8NdkKZNxWT0ajYWLG9oODlXAvGJgjqeNtxvst1Lh7czP11pXlhO', NULL, '2026-02-14 05:44:09', '2026-02-22 00:24:30', NULL, NULL),
(10, 'Cyrus', 'tadoy', 'cyrus', 'cyrus@gmail.com', '0978937362', 3, NULL, 2, NULL, '$2y$12$kkYK9eByCldNvbEclhYXU.BC/C0L3PHL3doPNDlA9qAUS5QXdL9IW', NULL, '2026-02-16 10:24:18', '2026-02-27 18:19:14', NULL, NULL),
(11, 'Charity', 'Dayaata', 'Charity', 'chairty@gmail.com', '09843232', 3, NULL, 1, NULL, '$2y$12$fcGazu1pkWn9oMJP.pDNw.mP11vcNQHWnetzcTCs.FrTjXsSFTbx6', NULL, '2026-02-16 14:41:04', '2026-02-16 14:41:04', NULL, NULL),
(12, 'Hanz earl', 'Tan', 'Hanz earl', 'Hanz@gmail.com', '012490412', 3, NULL, 1, NULL, '$2y$12$DQ8fsQ40PTCw/aarXWOn7OzRgggzra.U/KyKmWAKt8exG/390wjgm', NULL, '2026-02-16 15:12:26', '2026-02-16 15:12:26', NULL, NULL),
(13, 'baloro', 'john', 'philip', 'philip@gmail.com', '09890328190', 1, NULL, 2, NULL, '$2y$12$DdAPbFU4J9L1Zwoh1H943.tv2eEozYA8R5naup90sOZaZBQGWO.C.', NULL, '2026-02-25 05:26:46', '2026-03-24 22:04:34', NULL, NULL),
(14, 'kinsa', 'nia', 'kinsa', 'kinsa@gmail.com', '09087096123', 3, NULL, 1, NULL, '$2y$12$T0tCdjrhciuQAVWmprxQae5KLL57wq3iWPgtYPxaTnYW9w3D2aA1C', NULL, '2026-02-25 07:57:15', '2026-02-25 07:57:15', NULL, NULL),
(15, 'blue', 'than', 'blue', 'blue@gmail.com', '09089023189', 2, NULL, 1, NULL, '$2y$12$0ElgIqzlVgER9wEP9yDAmu7LwgqhwsL86iRoJ1.M0vVRomK5RAYam', NULL, '2026-02-27 18:22:30', '2026-02-27 18:22:30', NULL, NULL),
(16, 'red', 'than', 'red', 'red@gmail.com', '09089318921', 5, NULL, 1, NULL, '$2y$12$4vgCrIC/TITO.FQ8ggRHG.8TppJemvrMXoKhlY7H6BBa94iOE2d6O', NULL, '2026-02-27 18:24:13', '2026-02-28 09:56:58', NULL, NULL),
(17, 'Marc', 'Dayadaya', 'marc', 'Marcdayadaya1@gmail.com', '09801238902', 4, NULL, 1, NULL, '$2y$12$F7pXU5TwLviGBR/1oQbCb.E/FEg0iBinhLXkmpgy8geXegZ4kZPwy', NULL, '2026-03-27 07:20:05', '2026-03-27 07:20:05', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `warehouses`
--

CREATE TABLE `warehouses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `branch_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('Main Warehouse','Storage Warehouse','Distribution Center') NOT NULL,
  `location` text NOT NULL,
  `capacity` int(11) NOT NULL,
  `contact_number` varchar(255) DEFAULT NULL,
  `manager` varchar(255) DEFAULT NULL,
  `opening_date` date DEFAULT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `warehouses`
--

INSERT INTO `warehouses` (`id`, `name`, `code`, `branch_id`, `type`, `location`, `capacity`, `contact_number`, `manager`, `opening_date`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Bossing Warehouse', 'Bulua CDO', 1, 'Main Warehouse', 'Bulua Cagayan De Oro City Philippines', 10000, '0987654321', 'Marichu Contado', '2026-02-16', 'Active', '2026-02-16 10:37:02', '2026-02-20 15:14:48'),
(2, 'Airking Warehouse', 'Davao', 2, 'Distribution Center', 'Davao city Philippines', 8000, '0984022039', 'Silwyn Dayadaya', '2026-02-21', 'Active', '2026-02-16 10:38:42', '2026-02-16 15:59:23'),
(3, 'Baloro Warehouse', 'Valencia', 3, 'Storage Warehouse', 'Philipines Bukidnon Valencia City Lumbo', 5000, '0987360212', 'John Philip Baloro', '2026-03-14', 'Active', '2026-02-16 10:50:53', '2026-02-16 15:59:36'),
(4, 'HAHha', '32123', 4, 'Main Warehouse', 'CITuhADJ', 20301, '0986656', 'John Pghilip BAL', '2026-03-02', 'Active', '2026-02-21 02:13:28', '2026-02-21 02:13:28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`activity_id`),
  ADD KEY `activity_log_user_id_foreign` (`user_id`),
  ADD KEY `activity_log_status_id_foreign` (`status_id`);

--
-- Indexes for table `adjustments`
--
ALTER TABLE `adjustments`
  ADD PRIMARY KEY (`adjustment_id`),
  ADD UNIQUE KEY `adjustments_adjustment_number_unique` (`adjustment_number`),
  ADD KEY `adjustments_adjusted_by_foreign` (`adjusted_by`),
  ADD KEY `adjustments_approved_by_foreign` (`approved_by`),
  ADD KEY `adjustments_status_id_foreign` (`status_id`),
  ADD KEY `adjustments_created_by_foreign` (`created_by`),
  ADD KEY `adjustments_location_id_foreign` (`location_id`);

--
-- Indexes for table `adjustment_details`
--
ALTER TABLE `adjustment_details`
  ADD PRIMARY KEY (`adjustment_detail_id`),
  ADD KEY `adjustment_details_adjustment_id_foreign` (`adjustment_id`),
  ADD KEY `adjustment_details_product_id_foreign` (`product_id`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`audit_id`),
  ADD KEY `audit_log_user_id_foreign` (`user_id`);

--
-- Indexes for table `audit_trail`
--
ALTER TABLE `audit_trail`
  ADD PRIMARY KEY (`audit_id`),
  ADD KEY `audit_trail_user_id_index` (`user_id`),
  ADD KEY `audit_trail_table_name_index` (`table_name`),
  ADD KEY `audit_trail_created_at_index` (`created_at`);

--
-- Indexes for table `barcode_scans`
--
ALTER TABLE `barcode_scans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `barcode_scans_product_id_foreign` (`product_id`),
  ADD KEY `barcode_scans_user_id_scanned_at_index` (`user_id`,`scanned_at`);

--
-- Indexes for table `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `branches_code_unique` (`code`);

--
-- Indexes for table `brand_lookup`
--
ALTER TABLE `brand_lookup`
  ADD PRIMARY KEY (`brand_id`),
  ADD UNIQUE KEY `brand_lookup_brand_name_unique` (`brand_name`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `category_lookup`
--
ALTER TABLE `category_lookup`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_lookup_category_name_unique` (`category_name`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `delivery_receipts`
--
ALTER TABLE `delivery_receipts`
  ADD PRIMARY KEY (`dr_id`),
  ADD UNIQUE KEY `delivery_receipts_dr_number_unique` (`dr_number`),
  ADD KEY `delivery_receipts_sales_id_foreign` (`sales_id`),
  ADD KEY `delivery_receipts_issued_by_foreign` (`issued_by`),
  ADD KEY `delivery_receipts_status_id_foreign` (`status_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`inventory_id`);

--
-- Indexes for table `inventory_scan_events`
--
ALTER TABLE `inventory_scan_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_scan_events_product_id_foreign` (`product_id`),
  ADD KEY `inventory_scan_events_location_id_foreign` (`location_id`),
  ADD KEY `inventory_scan_events_to_location_id_foreign` (`to_location_id`),
  ADD KEY `inventory_scan_events_transaction_type_created_at_index` (`transaction_type`,`created_at`),
  ADD KEY `inventory_scan_events_user_id_created_at_index` (`user_id`,`created_at`),
  ADD KEY `inventory_scan_events_po_id_location_id_product_id_index` (`po_id`,`location_id`,`product_id`);

--
-- Indexes for table `issuances`
--
ALTER TABLE `issuances`
  ADD PRIMARY KEY (`issuance_id`),
  ADD KEY `issuances_issued_to_user_id_foreign` (`issued_to_user_id`),
  ADD KEY `issuances_issued_by_foreign` (`issued_by`),
  ADD KEY `issuances_approved_by_foreign` (`approved_by`),
  ADD KEY `issuances_status_id_foreign` (`status_id`),
  ADD KEY `issuances_location_id_foreign` (`location_id`);

--
-- Indexes for table `issuance_details`
--
ALTER TABLE `issuance_details`
  ADD PRIMARY KEY (`issuance_detail_id`),
  ADD KEY `issuance_details_issuance_id_foreign` (`issuance_id`),
  ADD KEY `issuance_details_product_id_foreign` (`product_id`);

--
-- Indexes for table `item_serial`
--
ALTER TABLE `item_serial`
  ADD PRIMARY KEY (`serial_id`),
  ADD UNIQUE KEY `item_serial_serial_number_unique` (`serial_number`),
  ADD KEY `item_serial_status_id_foreign` (`status_id`),
  ADD KEY `item_serial_product_id_foreign` (`product_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `locations_status_id_foreign` (`status_id`),
  ADD KEY `locations_branch_type_idx` (`branch_id`,`location_type`);

--
-- Indexes for table `login_activities`
--
ALTER TABLE `login_activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `login_activities_user_id_index` (`user_id`),
  ADD KEY `login_activities_username_attempt_index` (`username_attempt`),
  ADD KEY `login_activities_ip_address_index` (`ip_address`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_lookup`
--
ALTER TABLE `model_lookup`
  ADD PRIMARY KEY (`model_id`),
  ADD UNIQUE KEY `model_lookup_brand_id_model_code_unique` (`brand_id`,`model_code`),
  ADD KEY `model_lookup_subcategory_id_foreign` (`subcategory_id`),
  ADD KEY `model_lookup_status_id_foreign` (`status_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `pending_products`
--
ALTER TABLE `pending_products`
  ADD PRIMARY KEY (`pending_product_id`),
  ADD UNIQUE KEY `pending_products_barcode_unique` (`barcode`),
  ADD KEY `pending_products_status_created_at_index` (`status`,`created_at`),
  ADD KEY `pending_products_category_id_foreign` (`category_id`),
  ADD KEY `pending_products_brand_id_foreign` (`brand_id`),
  ADD KEY `pending_products_created_by_foreign` (`created_by`),
  ADD KEY `pending_products_approved_by_foreign` (`approved_by`),
  ADD KEY `pending_products_product_id_foreign` (`product_id`),
  ADD KEY `pending_products_opening_location_id_foreign` (`opening_location_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `products_unit_id_foreign` (`unit_id`),
  ADD KEY `products_category_id_foreign` (`category_id`),
  ADD KEY `products_brand_id_foreign` (`brand_id`);

--
-- Indexes for table `profit_loss`
--
ALTER TABLE `profit_loss`
  ADD PRIMARY KEY (`profit_loss_id`),
  ADD KEY `profit_loss_product_id_foreign` (`product_id`),
  ADD KEY `profit_loss_recorded_by_foreign` (`recorded_by`),
  ADD KEY `profit_loss_approved_by_foreign` (`approved_by`),
  ADD KEY `profit_loss_status_id_foreign` (`status_id`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`po_id`),
  ADD UNIQUE KEY `purchase_orders_pc_number_unique` (`pc_number`),
  ADD KEY `purchase_orders_ordered_by_foreign` (`ordered_by`),
  ADD KEY `purchase_orders_received_by_foreign` (`received_by`),
  ADD KEY `purchase_orders_location_id_foreign` (`location_id`);

--
-- Indexes for table `purchase_order_details`
--
ALTER TABLE `purchase_order_details`
  ADD PRIMARY KEY (`po_detail_id`),
  ADD KEY `purchase_order_details_po_id_foreign` (`po_id`),
  ADD KEY `purchase_order_details_product_id_foreign` (`product_id`);

--
-- Indexes for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  ADD PRIMARY KEY (`purchase_return_id`),
  ADD UNIQUE KEY `purchase_returns_pr_number_unique` (`pr_number`),
  ADD KEY `purchase_returns_receiving_id_foreign` (`receiving_id`),
  ADD KEY `purchase_returns_status_id_foreign` (`status_id`),
  ADD KEY `purchase_returns_requested_by_foreign` (`requested_by`),
  ADD KEY `purchase_returns_approved_by_foreign` (`approved_by`),
  ADD KEY `purchase_returns_po_id_foreign` (`po_id`),
  ADD KEY `purchase_returns_supplier_id_foreign` (`supplier_id`);

--
-- Indexes for table `purchase_return_details`
--
ALTER TABLE `purchase_return_details`
  ADD PRIMARY KEY (`pr_detail_id`),
  ADD KEY `purchase_return_details_purchase_return_id_foreign` (`purchase_return_id`),
  ADD KEY `purchase_return_details_product_id_foreign` (`product_id`),
  ADD KEY `purchase_return_details_serial_id_foreign` (`serial_id`);

--
-- Indexes for table `receivings`
--
ALTER TABLE `receivings`
  ADD PRIMARY KEY (`receiving_id`),
  ADD KEY `receivings_pc_id_foreign` (`pc_id`),
  ADD KEY `receivings_supplier_id_foreign` (`supplier_id`),
  ADD KEY `receivings_location_id_foreign` (`location_id`);

--
-- Indexes for table `receiving_details`
--
ALTER TABLE `receiving_details`
  ADD PRIMARY KEY (`receiving_detail_id`),
  ADD KEY `receiving_details_receiving_id_foreign` (`receiving_id`),
  ADD KEY `receiving_details_po_detail_id_foreign` (`po_detail_id`),
  ADD KEY `receiving_details_product_id_foreign` (`product_id`);

--
-- Indexes for table `restock_recommendations`
--
ALTER TABLE `restock_recommendations`
  ADD PRIMARY KEY (`recommendation_id`),
  ADD KEY `restock_recommendations_item_id_foreign` (`item_id`),
  ADD KEY `restock_recommendations_location_id_foreign` (`location_id`),
  ADD KEY `restock_recommendations_status_id_foreign` (`status_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `roles_role_name_unique` (`role_name`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sales_id`),
  ADD UNIQUE KEY `sales_invoice_number_unique` (`invoice_number`),
  ADD KEY `sales_customer_id_foreign` (`customer_id`),
  ADD KEY `sales_payment_status_id_foreign` (`payment_status_id`),
  ADD KEY `sales_sold_by_foreign` (`sold_by`),
  ADD KEY `sales_location_id_foreign` (`location_id`);

--
-- Indexes for table `sales_details`
--
ALTER TABLE `sales_details`
  ADD PRIMARY KEY (`sales_detail_id`),
  ADD KEY `sales_details_sales_id_foreign` (`sales_id`),
  ADD KEY `sales_details_product_id_foreign` (`product_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `status_lookup`
--
ALTER TABLE `status_lookup`
  ADD PRIMARY KEY (`status_id`),
  ADD UNIQUE KEY `status_lookup_status_name_status_category_unique` (`status_name`,`status_category`);

--
-- Indexes for table `subcategory_lookup`
--
ALTER TABLE `subcategory_lookup`
  ADD PRIMARY KEY (`subcategory_id`),
  ADD UNIQUE KEY `subcategory_lookup_category_id_subcategory_name_unique` (`category_id`,`subcategory_name`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`),
  ADD KEY `suppliers_status_id_foreign` (`status_id`);

--
-- Indexes for table `supplier_product`
--
ALTER TABLE `supplier_product`
  ADD PRIMARY KEY (`supplier_prod_id`),
  ADD UNIQUE KEY `supplier_product_supplier_id_product_id_unique` (`supplier_id`,`product_id`),
  ADD KEY `supplier_product_product_id_foreign` (`product_id`),
  ADD KEY `supplier_product_status_id_foreign` (`status_id`);

--
-- Indexes for table `tbl_transfer_tracking`
--
ALTER TABLE `tbl_transfer_tracking`
  ADD PRIMARY KEY (`tracking_id`),
  ADD KEY `tbl_transfer_tracking_transfer_id_foreign` (`transfer_id`),
  ADD KEY `tbl_transfer_tracking_recorded_by_foreign` (`recorded_by`),
  ADD KEY `tbl_transfer_tracking_location_id_foreign` (`location_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transactions_transaction_id_unique` (`transaction_id`);

--
-- Indexes for table `transaction_type_lookup`
--
ALTER TABLE `transaction_type_lookup`
  ADD PRIMARY KEY (`transaction_type_id`),
  ADD UNIQUE KEY `transaction_type_lookup_transaction_name_unique` (`transaction_name`);

--
-- Indexes for table `transfers`
--
ALTER TABLE `transfers`
  ADD PRIMARY KEY (`transfer_id`),
  ADD UNIQUE KEY `transfers_transfer_number_unique` (`transfer_number`),
  ADD KEY `transfers_requested_by_foreign` (`requested_by`),
  ADD KEY `transfers_approved_by_foreign` (`approved_by`),
  ADD KEY `transfers_received_by_foreign` (`received_by`),
  ADD KEY `transfers_status_id_foreign` (`status_id`),
  ADD KEY `transfers_from_location_id_foreign` (`from_location_id`),
  ADD KEY `transfers_to_location_id_foreign` (`to_location_id`);

--
-- Indexes for table `transfer_details`
--
ALTER TABLE `transfer_details`
  ADD PRIMARY KEY (`transfer_detail_id`),
  ADD KEY `transfer_details_transfer_id_foreign` (`transfer_id`),
  ADD KEY `transfer_details_product_id_foreign` (`product_id`);

--
-- Indexes for table `unit_lookup`
--
ALTER TABLE `unit_lookup`
  ADD PRIMARY KEY (`unit_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD KEY `users_role_id_foreign` (`role_id`),
  ADD KEY `users_status_id_foreign` (`status_id`),
  ADD KEY `users_branch_id_foreign` (`branch_id`);

--
-- Indexes for table `warehouses`
--
ALTER TABLE `warehouses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `warehouses_code_unique` (`code`),
  ADD KEY `warehouses_branch_id_foreign` (`branch_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `activity_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `adjustments`
--
ALTER TABLE `adjustments`
  MODIFY `adjustment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `adjustment_details`
--
ALTER TABLE `adjustment_details`
  MODIFY `adjustment_detail_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `audit_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_trail`
--
ALTER TABLE `audit_trail`
  MODIFY `audit_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=548;

--
-- AUTO_INCREMENT for table `barcode_scans`
--
ALTER TABLE `barcode_scans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT for table `branches`
--
ALTER TABLE `branches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `brand_lookup`
--
ALTER TABLE `brand_lookup`
  MODIFY `brand_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `category_lookup`
--
ALTER TABLE `category_lookup`
  MODIFY `category_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `delivery_receipts`
--
ALTER TABLE `delivery_receipts`
  MODIFY `dr_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `inventory_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `inventory_scan_events`
--
ALTER TABLE `inventory_scan_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- AUTO_INCREMENT for table `issuances`
--
ALTER TABLE `issuances`
  MODIFY `issuance_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `issuance_details`
--
ALTER TABLE `issuance_details`
  MODIFY `issuance_detail_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `item_serial`
--
ALTER TABLE `item_serial`
  MODIFY `serial_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `location_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `login_activities`
--
ALTER TABLE `login_activities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `model_lookup`
--
ALTER TABLE `model_lookup`
  MODIFY `model_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pending_products`
--
ALTER TABLE `pending_products`
  MODIFY `pending_product_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=229;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `profit_loss`
--
ALTER TABLE `profit_loss`
  MODIFY `profit_loss_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `po_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `purchase_order_details`
--
ALTER TABLE `purchase_order_details`
  MODIFY `po_detail_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  MODIFY `purchase_return_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_return_details`
--
ALTER TABLE `purchase_return_details`
  MODIFY `pr_detail_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receivings`
--
ALTER TABLE `receivings`
  MODIFY `receiving_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `receiving_details`
--
ALTER TABLE `receiving_details`
  MODIFY `receiving_detail_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `restock_recommendations`
--
ALTER TABLE `restock_recommendations`
  MODIFY `recommendation_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sales_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales_details`
--
ALTER TABLE `sales_details`
  MODIFY `sales_detail_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `status_lookup`
--
ALTER TABLE `status_lookup`
  MODIFY `status_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `subcategory_lookup`
--
ALTER TABLE `subcategory_lookup`
  MODIFY `subcategory_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `supplier_product`
--
ALTER TABLE `supplier_product`
  MODIFY `supplier_prod_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_transfer_tracking`
--
ALTER TABLE `tbl_transfer_tracking`
  MODIFY `tracking_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_type_lookup`
--
ALTER TABLE `transaction_type_lookup`
  MODIFY `transaction_type_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transfers`
--
ALTER TABLE `transfers`
  MODIFY `transfer_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `transfer_details`
--
ALTER TABLE `transfer_details`
  MODIFY `transfer_detail_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `unit_lookup`
--
ALTER TABLE `unit_lookup`
  MODIFY `unit_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `warehouses`
--
ALTER TABLE `warehouses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD CONSTRAINT `activity_log_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `activity_log_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `adjustments`
--
ALTER TABLE `adjustments`
  ADD CONSTRAINT `adjustments_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `adjustments_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `adjustments_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `adjustments_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL;

--
-- Constraints for table `adjustment_details`
--
ALTER TABLE `adjustment_details`
  ADD CONSTRAINT `adjustment_details_adjustment_id_foreign` FOREIGN KEY (`adjustment_id`) REFERENCES `adjustments` (`adjustment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `adjustment_details_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL;

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `audit_log_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `barcode_scans`
--
ALTER TABLE `barcode_scans`
  ADD CONSTRAINT `barcode_scans_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `barcode_scans_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `delivery_receipts`
--
ALTER TABLE `delivery_receipts`
  ADD CONSTRAINT `delivery_receipts_issued_by_foreign` FOREIGN KEY (`issued_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `delivery_receipts_sales_id_foreign` FOREIGN KEY (`sales_id`) REFERENCES `sales` (`sales_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `delivery_receipts_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL;

--
-- Constraints for table `inventory_scan_events`
--
ALTER TABLE `inventory_scan_events`
  ADD CONSTRAINT `inventory_scan_events_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `inventory_scan_events_po_id_foreign` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`po_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `inventory_scan_events_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `inventory_scan_events_to_location_id_foreign` FOREIGN KEY (`to_location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `inventory_scan_events_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `issuances`
--
ALTER TABLE `issuances`
  ADD CONSTRAINT `issuances_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `issuances_issued_by_foreign` FOREIGN KEY (`issued_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `issuances_issued_to_user_id_foreign` FOREIGN KEY (`issued_to_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `issuances_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `issuances_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL;

--
-- Constraints for table `issuance_details`
--
ALTER TABLE `issuance_details`
  ADD CONSTRAINT `issuance_details_issuance_id_foreign` FOREIGN KEY (`issuance_id`) REFERENCES `issuances` (`issuance_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `issuance_details_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL;

--
-- Constraints for table `item_serial`
--
ALTER TABLE `item_serial`
  ADD CONSTRAINT `item_serial_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `item_serial_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL;

--
-- Constraints for table `locations`
--
ALTER TABLE `locations`
  ADD CONSTRAINT `locations_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `locations_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL;

--
-- Constraints for table `login_activities`
--
ALTER TABLE `login_activities`
  ADD CONSTRAINT `login_activities_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `model_lookup`
--
ALTER TABLE `model_lookup`
  ADD CONSTRAINT `model_lookup_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brand_lookup` (`brand_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `model_lookup_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `model_lookup_subcategory_id_foreign` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategory_lookup` (`subcategory_id`) ON DELETE SET NULL;

--
-- Constraints for table `pending_products`
--
ALTER TABLE `pending_products`
  ADD CONSTRAINT `pending_products_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pending_products_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brand_lookup` (`brand_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pending_products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `category_lookup` (`category_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pending_products_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pending_products_opening_location_id_foreign` FOREIGN KEY (`opening_location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pending_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brand_lookup` (`brand_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `category_lookup` (`category_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_unit_id_foreign` FOREIGN KEY (`unit_id`) REFERENCES `unit_lookup` (`unit_id`) ON DELETE SET NULL;

--
-- Constraints for table `profit_loss`
--
ALTER TABLE `profit_loss`
  ADD CONSTRAINT `profit_loss_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `profit_loss_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `profit_loss_recorded_by_foreign` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `profit_loss_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL;

--
-- Constraints for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `purchase_orders_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_orders_ordered_by_foreign` FOREIGN KEY (`ordered_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_orders_received_by_foreign` FOREIGN KEY (`received_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `purchase_order_details`
--
ALTER TABLE `purchase_order_details`
  ADD CONSTRAINT `purchase_order_details_po_id_foreign` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`po_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchase_order_details_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL;

--
-- Constraints for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  ADD CONSTRAINT `purchase_returns_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_returns_po_id_foreign` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`po_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_returns_receiving_id_foreign` FOREIGN KEY (`receiving_id`) REFERENCES `receivings` (`receiving_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_returns_requested_by_foreign` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_returns_status_id_foreign` FOREIGN KEY (`status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_returns_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE SET NULL;

--
-- Constraints for table `purchase_return_details`
--
ALTER TABLE `purchase_return_details`
  ADD CONSTRAINT `purchase_return_details_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_return_details_purchase_return_id_foreign` FOREIGN KEY (`purchase_return_id`) REFERENCES `purchase_returns` (`purchase_return_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchase_return_details_serial_id_foreign` FOREIGN KEY (`serial_id`) REFERENCES `item_serial` (`serial_id`) ON DELETE SET NULL;

--
-- Constraints for table `receivings`
--
ALTER TABLE `receivings`
  ADD CONSTRAINT `receivings_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `receivings_pc_id_foreign` FOREIGN KEY (`pc_id`) REFERENCES `purchase_orders` (`po_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `receivings_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE SET NULL;

--
-- Constraints for table `receiving_details`
--
ALTER TABLE `receiving_details`
  ADD CONSTRAINT `receiving_details_po_detail_id_foreign` FOREIGN KEY (`po_detail_id`) REFERENCES `purchase_order_details` (`po_detail_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `receiving_details_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `receiving_details_receiving_id_foreign` FOREIGN KEY (`receiving_id`) REFERENCES `receivings` (`receiving_id`) ON DELETE CASCADE;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `sales_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `sales_payment_status_id_foreign` FOREIGN KEY (`payment_status_id`) REFERENCES `status_lookup` (`status_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `sales_sold_by_foreign` FOREIGN KEY (`sold_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

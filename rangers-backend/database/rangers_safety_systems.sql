-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 20, 2026 at 01:37 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rangers_safety_systems`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password_hash`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Rangers Admin', 'admin@rangers.com', '$2y$10$mr7IZ67c7lt40CCS1OjAW.FTVEjM5vDiQLNh0Lsyst8vse3etGqqq', 'active', '2026-10-20 08:17:01', '2026-10-20 08:17:01');

-- --------------------------------------------------------

--
-- Table structure for table `booklet_products`
--

CREATE TABLE `booklet_products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `display_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booklet_settings`
--

CREATE TABLE `booklet_settings` (
  `id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `booklet_settings`
--

INSERT INTO `booklet_settings` (`id`, `title`, `description`, `status`, `updated_at`) VALUES
(1, 'Digital Booklet', '', 'active', '2026-10-20 08:09:24');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(190) NOT NULL,
  `slug` varchar(190) NOT NULL,
  `description` text DEFAULT NULL,
  `image_path` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `display_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `image_path`, `status`, `display_order`, `created_at`, `updated_at`) VALUES
(1, 'Safety Footwear', 'safety-footwear', 'Imported category from the Rangers safety catalogue', NULL, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 09:45:32'),
(2, 'Protective Clothing', 'protective-clothing', 'Imported category from the Rangers safety catalogue', NULL, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 09:45:32');

-- --------------------------------------------------------

--
-- Table structure for table `cms_elements`
--

CREATE TABLE `cms_elements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `page_slug` varchar(100) NOT NULL,
  `element_key` varchar(255) NOT NULL,
  `kind` enum('text','image','video','link','html','style') NOT NULL DEFAULT 'text',
  `content` mediumtext NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cms_elements`
--

INSERT INTO `cms_elements` (`id`, `page_slug`, `element_key`, `kind`, `content`, `updated_at`) VALUES
(1, 'home', 'main:nth-of-type(1) > section:nth-of-type(1) > div:nth-of-type(1) > div:nth-of-type(2) > div:nth-of-type(1) > div:nth-of-type(1)', 'image', 'storage/uploads/2da937544c89a8a11d06cb28047c31cf4c247700.jpg', '2026-10-20 08:49:15');

-- --------------------------------------------------------

--
-- Table structure for table `cms_pages`
--

CREATE TABLE `cms_pages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `slug` varchar(100) NOT NULL,
  `title` varchar(200) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cms_pages`
--

INSERT INTO `cms_pages` (`id`, `slug`, `title`, `status`, `sort_order`, `updated_at`) VALUES
(1, 'home', 'Home', 'active', 1, '2026-10-20 08:35:52'),
(2, 'products', 'Products', 'active', 2, '2026-10-20 08:35:52'),
(3, 'product', 'Product Details', 'active', 3, '2026-10-20 08:35:52'),
(4, 'exhibition', 'Exhibition', 'active', 4, '2026-10-20 08:35:52'),
(5, 'booklet', 'Digital Catalogue', 'active', 5, '2026-10-20 08:35:52'),
(6, 'schedule', 'Schedule Meeting', 'active', 6, '2026-10-20 08:35:52'),
(7, 'contact', 'Contact', 'active', 7, '2026-10-20 08:35:52'),
(8, 'print-catalogue', 'Print Catalogue', 'active', 8, '2026-10-20 08:35:52'),
(9, 'global', 'Header and Footer', 'active', 9, '2026-10-20 08:35:52');

-- --------------------------------------------------------

--
-- Table structure for table `company_information`
--

CREATE TABLE `company_information` (
  `id` int(11) NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `about_heading` varchar(255) DEFAULT NULL,
  `about_description` mediumtext DEFAULT NULL,
  `company_image` varchar(500) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `company_information`
--

INSERT INTO `company_information` (`id`, `company_name`, `about_heading`, `about_description`, `company_image`, `updated_at`) VALUES
(1, 'Rangers Safety Systems', 'About Us', '', NULL, '2026-10-20 08:09:24');

-- --------------------------------------------------------

--
-- Table structure for table `exhibitions`
--

CREATE TABLE `exhibitions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_path` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `display_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `exhibitions`
--

INSERT INTO `exhibitions` (`id`, `title`, `description`, `image_path`, `status`, `display_order`, `created_at`, `updated_at`) VALUES
(1, '2026 Exhibition Showcase', '', NULL, 'active', 0, '2026-10-20 08:09:24', '2026-10-20 08:09:24');

-- --------------------------------------------------------

--
-- Table structure for table `exhibition_products`
--

CREATE TABLE `exhibition_products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `exhibition_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `display_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ip_hash` char(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `media_library`
--

CREATE TABLE `media_library` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `filename` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `file_size` bigint(20) UNSIGNED NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `media_library`
--

INSERT INTO `media_library` (`id`, `filename`, `file_path`, `mime_type`, `file_size`, `uploaded_at`) VALUES
(1, '37dba3fb0149e67cf44d4b87d045c5ed705a39d8.png', 'storage/uploads/37dba3fb0149e67cf44d4b87d045c5ed705a39d8.png', 'image/png', 17334, '2026-10-20 08:19:14'),
(2, '7d729bfe41c7d89c744a19c8dc43b5b27aa71d86.png', 'storage/uploads/7d729bfe41c7d89c744a19c8dc43b5b27aa71d86.png', 'image/png', 17334, '2026-10-20 08:19:17'),
(3, '776aea4366f89e12af6573bee8941911c007adb8.jpg', 'storage/uploads/776aea4366f89e12af6573bee8941911c007adb8.jpg', 'image/jpeg', 219209, '2026-10-20 08:46:05'),
(4, '935830676bf3f85856f159e28d491b62115145b4.jpg', 'storage/uploads/935830676bf3f85856f159e28d491b62115145b4.jpg', 'image/jpeg', 219209, '2026-10-20 08:46:28'),
(5, '2da937544c89a8a11d06cb28047c31cf4c247700.jpg', 'storage/uploads/2da937544c89a8a11d06cb28047c31cf4c247700.jpg', 'image/jpeg', 219209, '2026-10-20 08:49:13'),
(25, 'rangers-ss-12s-s1p-2k.png', 'storage/uploads/catalogue/rangers-ss-12s-s1p-2k.png', 'image/png', 1819222, '2026-10-20 11:03:35'),
(26, 'rangers-ss-18-s1p-2k.png', 'storage/uploads/catalogue/rangers-ss-18-s1p-2k.png', 'image/png', 1905494, '2026-10-20 11:03:35'),
(27, 'rangers-ss-21-s3-2k.png', 'storage/uploads/catalogue/rangers-ss-21-s3-2k.png', 'image/png', 1739326, '2026-10-20 11:03:35'),
(28, 'rangers-ss-25-s3-2k.png', 'storage/uploads/catalogue/rangers-ss-25-s3-2k.png', 'image/png', 2028739, '2026-10-20 11:03:35'),
(29, 'rangers-ss-26-s3-2k.png', 'storage/uploads/catalogue/rangers-ss-26-s3-2k.png', 'image/png', 1356847, '2026-10-20 11:03:35'),
(30, 'rangers-ss-49-s3-2k.png', 'storage/uploads/catalogue/rangers-ss-49-s3-2k.png', 'image/png', 1468392, '2026-10-20 11:03:35'),
(31, 'rangers-ss-59-s1p-2k.png', 'storage/uploads/catalogue/rangers-ss-59-s1p-2k.png', 'image/png', 1523060, '2026-10-20 11:03:35'),
(32, 'rangers-ss-136-s3-2k.png', 'storage/uploads/catalogue/rangers-ss-136-s3-2k.png', 'image/png', 1542585, '2026-10-20 11:03:35'),
(33, 'rangers-ss-138-s3-2k.png', 'storage/uploads/catalogue/rangers-ss-138-s3-2k.png', 'image/png', 1488238, '2026-10-20 11:03:35'),
(34, 'rangers-ss-161-s3-2k.png', 'storage/uploads/catalogue/rangers-ss-161-s3-2k.png', 'image/png', 1414328, '2026-10-20 11:03:35'),
(35, 'rangers-abora-9822-2k.png', 'storage/uploads/catalogue/rangers-abora-9822-2k.png', 'image/png', 1393010, '2026-10-20 11:03:35'),
(36, 'rangers-electa-9824-2k.png', 'storage/uploads/catalogue/rangers-electa-9824-2k.png', 'image/png', 924045, '2026-10-20 11:03:35'),
(37, 'rangers-istella-9814-2k.png', 'storage/uploads/catalogue/rangers-istella-9814-2k.png', 'image/png', 1368141, '2026-10-20 11:03:35'),
(38, 'rangers-roover-1844-2k.png', 'storage/uploads/catalogue/rangers-roover-1844-2k.png', 'image/png', 939632, '2026-10-20 11:03:35'),
(39, 'rangers-slamer-8824-2k.png', 'storage/uploads/catalogue/rangers-slamer-8824-2k.png', 'image/png', 936664, '2026-10-20 11:03:35'),
(40, 'rangers-ra-pcc160-2k.png', 'storage/uploads/catalogue/rangers-ra-pcc160-2k.png', 'image/png', 1439117, '2026-10-20 11:03:35'),
(41, 'rangers-ra-pcu160-2k.png', 'storage/uploads/catalogue/rangers-ra-pcu160-2k.png', 'image/png', 1636054, '2026-10-20 11:03:35'),
(42, 'rangers-ra-ctu240-2k.png', 'storage/uploads/catalogue/rangers-ra-ctu240-2k.png', 'image/png', 1769461, '2026-10-20 11:03:35'),
(43, 'rangers-fr-coveralls-uniforms-2k.png', 'storage/uploads/catalogue/rangers-fr-coveralls-uniforms-2k.png', 'image/png', 1979209, '2026-10-20 11:03:35');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `short_description` text DEFAULT NULL,
  `full_description` mediumtext DEFAULT NULL,
  `specifications` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`specifications`)),
  `main_image_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'inactive',
  `display_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `slug`, `short_description`, `full_description`, `specifications`, `main_image_id`, `status`, `display_order`, `created_at`, `updated_at`) VALUES
(1, 1, 'SS-12S-S1P', 'ss-12s-s1p', 'Safety footwear with a steel toe, steel midplate, beige suede cow leather and fabric upper, and dual-density PU sole.', 'Safety footwear certified to EN ISO 20345:2022. It has a 200 J steel toe, 1100 N steel midplate, beige suede cow leather and fabric upper, dual-density PU sole described as slip- and oil-resistant, and an anti-static moulded EVA footbed.', '{\"sku\": \"SS-12S-S1P\", \"standards\": [\"EN ISO 20345:2022 certified\"], \"toe_protection\": \"Steel toe (200 J)\", \"puncture_protection\": \"Steel midplate (1100 N)\", \"upper_material\": \"Beige suede cow leather and fabric upper\", \"sole\": \"Dual-density PU (DDPU), slip- and oil-resistant\", \"footbed\": \"Anti-static moulded EVA footbed\", \"sizes\": \"38-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-12s-s1p-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 21, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(2, 1, 'SS-18-S1P', 'ss-18-s1p', 'Safety footwear with steel toe and midplate, breathable fabric upper, and dual-density PU sole.', 'Safety footwear certified to EN ISO 20345:2022. It has a 200 J steel toe, 1100 N steel midplate, breathable fabric upper with sandwich lining, dual-density PU sole described as slip- and oil-resistant, and an anti-static breathable PU foam footbed.', '{\"sku\": \"SS-18-S1P\", \"standards\": [\"EN ISO 20345:2022 certified\"], \"toe_protection\": \"Steel toe (200 J)\", \"puncture_protection\": \"Steel midplate (1100 N)\", \"upper_material\": \"Breathable fabric upper with sandwich lining\", \"sole\": \"Dual-density PU (DDPU), slip- and oil-resistant\", \"footbed\": \"Anti-static breathable PU foam footbed\", \"sizes\": \"39-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-18-s1p-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 22, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(3, 1, 'SS-21-S3', 'ss-21-s3', 'Water-resistant S3 footwear with lightweight plastic toe protection and microfiber leather upper.', 'Water-resistant S3 safety footwear certified to EN ISO 20345:2022. It has a lightweight plastic toe and 1100 N steel midsole, microfiber leather upper, dual-density PU sole described as slip-, oil- and heat-resistant, and an anti-static breathable PU foam footbed.', '{\"sku\": \"SS-21-S3\", \"standards\": [\"EN ISO 20345:2022 S3 (water-resistant)\"], \"toe_protection\": \"Lightweight plastic toe\", \"puncture_protection\": \"Steel midsole (1100 N)\", \"upper_material\": \"Microfiber leather upper\", \"sole\": \"Dual-density PU (DDPU), slip-, oil- and heat-resistant\", \"footbed\": \"Anti-static breathable PU foam footbed\", \"sizes\": \"39-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-21-s3-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 23, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(4, 1, 'SS-25-S3', 'ss-25-s3', 'Water-resistant S3 footwear with steel toe and midplate, printed split-leather upper, and dual-density PU sole.', 'Water-resistant S3 safety footwear certified to EN ISO 20345:2022. It has a 200 J steel toe, 1100 N steel midplate, Barton printed split leather with side reflector, dual-density PU sole described as slip-, oil- and heat-resistant, and an anti-static moulded EVA footbed.', '{\"sku\": \"SS-25-S3\", \"standards\": [\"EN ISO 20345:2022 S3 (water-resistant)\"], \"toe_protection\": \"Steel toe (200 J)\", \"puncture_protection\": \"Steel midplate (1100 N)\", \"upper_material\": \"Barton printed split leather with side reflector\", \"sole\": \"Dual-density PU (DDPU), slip-, oil- and heat-resistant\", \"footbed\": \"Anti-static moulded EVA footbed\", \"sizes\": \"38-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-25-s3-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 24, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(5, 1, 'SS-26-S3', 'ss-26-s3', 'Water-resistant S3 footwear with steel toe and midplate, printed split-leather upper, and dual-density PU sole.', 'Water-resistant S3 safety footwear certified to EN ISO 20345:2022. It has a 200 J steel toe, 1100 N steel midplate, Barton printed split leather with side reflector, dual-density PU sole described as slip-, oil- and heat-resistant, and an anti-static moulded EVA footbed.', '{\"sku\": \"SS-26-S3\", \"standards\": [\"EN ISO 20345:2022 S3 (water-resistant)\"], \"toe_protection\": \"Steel toe (200 J)\", \"puncture_protection\": \"Steel midplate (1100 N)\", \"upper_material\": \"Barton printed split leather with side reflector\", \"sole\": \"Dual-density PU (DDPU), slip-, oil- and heat-resistant\", \"footbed\": \"Anti-static moulded EVA footbed\", \"sizes\": \"38-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-26-s3-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 25, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(6, 1, 'SS-49-S3', 'ss-49-s3', 'Water-resistant S3 footwear with steel toe and midplate, printed microfiber upper, and dual-density PU sole.', 'Water-resistant S3 safety footwear certified to EN ISO 20345:2022. It has a 200 J steel toe, 1100 N steel midplate, Barton printed microfiber with counter reflector, dual-density PU sole described as slip-, oil- and heat-resistant, and an anti-static moulded EVA footbed.', '{\"sku\": \"SS-49-S3\", \"standards\": [\"EN ISO 20345:2022 S3 (water-resistant)\"], \"toe_protection\": \"Steel toe (200 J)\", \"puncture_protection\": \"Steel midplate (1100 N)\", \"upper_material\": \"Barton printed microfiber with counter reflector\", \"sole\": \"Dual-density PU (DDPU), slip-, oil- and heat-resistant\", \"footbed\": \"Anti-static moulded EVA footbed\", \"sizes\": \"38-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-49-s3-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 26, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(7, 1, 'SS-59-S1P', 'ss-59-s1p', 'Safety footwear with composite toe, Kevlar insole, mesh/TPU/leather upper, and quick-release lacing.', 'Safety footwear certified to EN ISO 20345:2022. It has a 200 J composite toe and 1100 N Kevlar insole, mesh/TPU/leather upper with quick-release lacing, dual-density PU sole described as slip-, oil- and heat-resistant, and an anti-static breathable PU foam footbed.', '{\"sku\": \"SS-59-S1P\", \"standards\": [\"EN ISO 20345:2022 certified\"], \"toe_protection\": \"Composite toe (200 J)\", \"puncture_protection\": \"Kevlar insole (1100 N)\", \"upper_material\": \"Mesh\\/TPU\\/leather upper with quick-release lacing\", \"sole\": \"Dual-density PU (DDPU), slip-, oil- and heat-resistant\", \"footbed\": \"Anti-static breathable PU foam footbed\", \"sizes\": \"39-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-59-s1p-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 27, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(8, 1, 'SS-136-S3', 'ss-136-s3', 'Water-resistant S3 footwear with composite toe, Kevlar anti-puncture insert, and non-metallic leather upper.', 'Water-resistant S3 safety footwear certified to EN ISO 20345:2022. It has a 200 J composite toe and Kevlar anti-puncture insert, 100% non-metallic crazy horse leather upper, dual-density PU sole described as slip-, oil- and heat-resistant, and an anti-static breathable PU foam footbed.', '{\"sku\": \"SS-136-S3\", \"standards\": [\"EN ISO 20345:2022 S3 (water-resistant)\"], \"toe_protection\": \"Composite toe (200 J)\", \"puncture_protection\": \"Kevlar anti-puncture insert\", \"upper_material\": \"100% non-metallic crazy horse leather\", \"sole\": \"Dual-density PU (DDPU), slip-, oil- and heat-resistant\", \"footbed\": \"Anti-static breathable PU foam footbed\", \"sizes\": \"39-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-136-s3-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 28, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(9, 1, 'SS-138-S3', 'ss-138-s3', 'Water-resistant S3 footwear with composite toe, lightweight Kevlar insole, and non-metallic nubuck upper.', 'Water-resistant S3 safety footwear certified to EN ISO 20345:2022. It has a 200 J composite toe and lightweight Kevlar insole (1100 N), 100% non-metallic nubuck leather upper with ESD and counter reflector, lightweight RBPU sole described as slip- and oil-resistant and heat-resistant to 300 C, and an anti-static breathable PU foam footbed.', '{\"sku\": \"SS-138-S3\", \"standards\": [\"EN ISO 20345:2022 S3 (water-resistant)\"], \"toe_protection\": \"Composite toe (200 J)\", \"puncture_protection\": \"Lightweight Kevlar insole (1100 N)\", \"upper_material\": \"100% non-metallic nubuck leather\", \"sole\": \"Lightweight RBPU, slip- and oil-resistant, heat-resistant to 300 C\", \"features\": [\"ESD\", \"Counter reflector\"], \"footbed\": \"Anti-static breathable PU foam footbed\", \"sizes\": \"40-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers WAQ - Safety Footwear\", \"subcategory\": \"Rangers WAQ\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-138-s3-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 29, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(10, 1, 'SS-161-S3', 'ss-161-s3', 'Water-resistant S3 footwear with epoxy-coated stainless steel toe, 9-inch full-grain leather upper, and DDPU sole.', 'Water-resistant S3 safety footwear certified to EN ISO 20345:2022. It has an epoxy-coated stainless steel toe (200 J), steel midplate (1100 N), full-grain leather upper (9-inch height), dual-density PU sole described as slip-, oil- and heat-resistant, and an anti-static moulded PU footbed.', '{\"sku\": \"SS-161-S3\", \"standards\": [\"EN ISO 20345:2022 S3 (water-resistant)\"], \"toe_protection\": \"Epoxy-coated stainless steel toe (200 J)\", \"puncture_protection\": \"Steel midplate (1100 N)\", \"upper_material\": \"Full-grain leather, 9-inch height\", \"sole\": \"Dual-density PU (DDPU), slip-, oil- and heat-resistant\", \"footbed\": \"Anti-static moulded PU footbed\", \"sizes\": \"38-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers Parade - Safety Footwear\", \"subcategory\": \"Rangers Parade\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-ss-161-s3-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 30, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(11, 1, 'ABORA-9822', 'abora-9822', 'S1P footwear with steel toe, metallic anti-puncture sole, and breathable microfiber/3D mesh upper for hot environments.', 'The PDF lists EN ISO 20345:2022 S1P SR FO CI HI. It describes a steel toe (200 J) and steel midplate (1100 N), breathable microfibre upper with 3D mesh lining for hot environments, two-density polyurethane sole described as slip-, hydrocarbon-, cold- and heat-resistant, electrostatic dissipation with VPS arch-support system, and removable mesh over PU foam insole.', '{\"sku\": \"ABORA-9822\", \"standards\": [\"EN ISO 20345:2022 S1P SR FO CI HI\"], \"toe_protection\": \"Steel toe (200 J)\", \"puncture_protection\": \"Steel midplate (1100 N)\", \"upper_material\": \"Breathable microfibre upper with 3D mesh lining; suitable for hot environments\", \"sole\": \"Two-density polyurethane, slip-, hydrocarbon-, cold- and heat-resistant\", \"features\": [\"Electrostatic dissipation (ESD)\", \"VPS system for arch support\", \"Removable mesh over PU foam insole\"], \"sizes\": \"39-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers Parade - Safety Footwear\", \"subcategory\": \"Rangers Parade\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-abora-9822-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 31, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(12, 1, 'ELECTA-9824', 'electa-9824', 'Footwear with electrical insulation for dry environments, composite toe, and an insulating anti-puncture sole.', 'The PDF lists EN ISO 20345:2022 SB SR FO PS CI HI E and ASTM F2413-18 M I C EH PR. It describes a composite toe and insulating fabric anti-puncture sole, electrical insulation in dry environments (1000 V AC-1500 V DC), fabric upper with injected PU front reinforcement, and two-density insulating polyurethane sole described as slip- and hydrocarbon-resistant and cold/heat-insulated. The design is non-magnetic and breathable, with a DRS shock-absorbent heel and VPS arch support.', '{\"sku\": \"ELECTA-9824\", \"standards\": [\"EN ISO 20345:2022 SB SR FO PS CI HI E\", \"ASTM F2413-18 M I C EH PR\"], \"toe_protection\": \"Composite toe\", \"puncture_protection\": \"Insulating fabric anti-puncture sole\", \"upper_material\": \"Fabric upper with injected PU front reinforcement\", \"sole\": \"Two-density insulating polyurethane, slip- and hydrocarbon-resistant, cold\\/heat-insulated\", \"features\": [\"Electrical insulation in dry environments (1000 V AC-1500 V DC)\", \"Non-magnetic\", \"Breathable\", \"DRS shock-absorbent heel\", \"VPS arch support\"], \"sizes\": \"35-48\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers Parade - Safety Footwear\", \"subcategory\": \"Rangers Parade\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-electa-9824-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 32, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(13, 1, 'ISTELLA-9814', 'istella-9814', 'Ultralight 420 g footwear with composite toe, textile anti-puncture sole, ESD, and heat/cold insulation.', 'Certified to EN ISO 20345:2022+A1:2024 S3S SR FO HRO CI SC. The PDF describes a composite toe and ultralight textile anti-puncture sole, water-repellent textile upper with TPU front reinforcement, lightweight EVA/nitrile rubber pad sole described as slip- and hydrocarbon-resistant, HRO outsole up to 300 C and cold insulation (CI), and an ultralight 420 g, non-magnetic, ESD design with abrasion-resistant stone guard.', '{\"sku\": \"ISTELLA-9814\", \"standards\": [\"EN ISO 20345:2022+A1:2024 S3S SR FO HRO CI SC\"], \"toe_protection\": \"Composite toe\", \"puncture_protection\": \"Ultralight textile anti-puncture sole\", \"upper_material\": \"Water-repellent textile with TPU front reinforcement\", \"sole\": \"Lightweight EVA\\/nitrile rubber pad sole, slip- and hydrocarbon-resistant; HRO up to 300 C; cold-insulated (CI)\", \"features\": [\"Ultralight (420 g)\", \"Non-magnetic\", \"ESD\", \"Abrasion-resistant stone guard\"], \"sizes\": \"36-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers Parade - Safety Footwear\", \"subcategory\": \"Rangers Parade\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-istella-9814-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 33, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(14, 1, 'ROOVER-1844', 'roover-1844', 'S3 footwear with composite toe, Kevlar anti-puncture insert, water-repellent smooth cow-leather upper, and ESD.', 'The PDF lists EN ISO 20345:2022 S3 S SR E FO ESD WPA and ASTM F2413-18 I C PR SD. It describes a 200 J composite toe and Kevlar anti-puncture insert, water-repellent smooth cow leather upper, dual-density PU sole described as slip- and oil/fuel-resistant, electrostatic dissipating (ESD) and non-magnetic construction, DRS 2 shock-absorption heel, VPS arch support, and Be flex 2.0 sole.', '{\"sku\": \"ROOVER-1844\", \"standards\": [\"EN ISO 20345:2022 S3 S SR E FO ESD WPA\", \"ASTM F2413-18 I C PR SD\"], \"toe_protection\": \"Composite toe (200 J)\", \"puncture_protection\": \"Kevlar anti-puncture insert\", \"upper_material\": \"Water-repellent smooth cow leather\", \"sole\": \"Two-density polyurethane, slip- and oil\\/fuel-resistant; Be flex 2.0 sole\", \"features\": [\"Electrostatic dissipating (ESD)\", \"Non-magnetic\", \"DRS 2 shock-absorption heel\", \"VPS arch support\"], \"sizes\": \"36-47\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers Parade - Safety Footwear\", \"subcategory\": \"Rangers Parade\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-roover-1844-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 34, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(15, 1, 'SLAMER-8824', 'slamer-8824', 'S3 footwear with composite toe, non-metallic anti-puncture insert, rubber/EVA sole, and HRO outsole.', 'Certified to EN ISO 20345:2011 S3 SRC HRO. It has a composite toe and non-metallic anti-puncture insert, water-repellent microfibre and split leather upper, rubber/EVA sole described as anti-slip and oil/fuel-resistant, HRO outsole with high resistance to tearing, and a non-magnetic design with added heel reinforcement for support.', '{\"sku\": \"SLAMER-8824\", \"standards\": [\"EN ISO 20345:2011 S3 SRC HRO\"], \"toe_protection\": \"Composite toe\", \"puncture_protection\": \"Non-metallic anti-puncture insert\", \"upper_material\": \"Water-repellent microfibre and split leather\", \"sole\": \"Rubber\\/EVA, anti-slip and oil\\/fuel-resistant; HRO outsole with high resistance to tearing\", \"features\": [\"Non-magnetic\", \"Added heel reinforcement for support\"], \"sizes\": \"35-48\", \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Rangers Parade - Safety Footwear\", \"subcategory\": \"Rangers Parade\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-slamer-8824-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 35, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(16, 2, '60/40 Polycotton Coverall', '60-40-polycotton-coverall-ra-pcc160', '60/40 polycotton coverall with 160 GSM fabric, two-way front zipper, utility pockets, and elasticized waist.', 'The catalogue identifies a 60/40 Polycotton Coverall with SKU RA-PCC160. It lists EN ISO 13688:2013 (general requirements for protective clothing), a 60% polyester and 40% cotton blend, 160 GSM fabric, sanforized and mercerized fabric for minimum shrinkage and colour bleeding, a two-way front zipper, multiple utility pockets, and elasticized waist. Listed colours are Petrol Blue, Dark Blue, Grey, Beige, Orange and Red; sizes are Small-5XL.', '{\"sku\": \"RA-PCC160\", \"standards\": [\"EN ISO 13688:2013 (general requirements for protective clothing)\"], \"material\": \"60% polyester and 40% cotton blend\", \"fabric_weight\": \"160 GSM\", \"features\": [\"Sanforized and mercerized for minimum shrinkage and colour bleeding\", \"Two-way front zipper\", \"Multiple utility pockets\", \"Elasticized waist\"], \"sizes\": \"Small-5XL\", \"colours\": [\"Petrol Blue\", \"Dark Blue\", \"Grey\", \"Beige\", \"Orange\", \"Red\"], \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"60\\/40 Polycotton Coverall\", \"subcategory\": \"Coveralls\", \"manual_review\": false, \"image_path\": \"storage/uploads/catalogue/rangers-ra-pcc160-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 36, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(17, 2, '60/40 Polycotton Uniform (Pant / Shirt)', '60-40-polycotton-uniform-pant-shirt-ra-pcu160', '60/40 polycotton uniform with 160 GSM fabric, industrial stitching, multi-pocket shirt, and reinforced trouser seams.', 'The catalogue identifies a 60/40 Polycotton Uniform (Pant / Shirt) with SKU RA-PCU160. It lists EN ISO 13688:2013 (general requirements for protective clothing), a 60% polyester and 40% cotton blend, 160 GSM fabric, sanforized and mercerized fabric for minimum shrinkage and colour bleeding, durable industrial stitching, multi-pocket shirt and reinforced trouser seams. Listed colours are Petrol Blue, Dark Blue, Grey, Beige, Orange and Red; sizes are Small-5XL.', '{\"sku\": \"RA-PCU160\", \"standards\": [\"EN ISO 13688:2013 (general requirements for protective clothing)\"], \"material\": \"60% polyester and 40% cotton blend\", \"fabric_weight\": \"160 GSM\", \"features\": [\"Sanforized and mercerized for minimum shrinkage and colour bleeding\", \"Durable industrial stitching\", \"Multi-pocket shirt\", \"Reinforced trouser seams\"], \"sizes\": \"Small-5XL\", \"colours\": [\"Petrol Blue\", \"Dark Blue\", \"Grey\", \"Beige\", \"Orange\", \"Red\"], \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"60\\/40 Polycotton Uniform (Pant \\/ Shirt)\", \"subcategory\": \"Uniforms\", \"manual_review\": false, \"image_path\": \"storage/uploads/catalogue/rangers-ra-pcu160-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 37, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(18, 2, '100% Cotton Uniform (Pant / Shirt)', '100-cotton-uniform-pant-shirt-ra-ctu240', '100% premium cotton twill uniform with 240 GSM base fabric and heavier fabric options.', 'The catalogue identifies a 100% Cotton Uniform (Pant / Shirt) with SKU RA-CTU240. It lists EN ISO 13688:2013, 100% premium cotton twill fabric, 240 GSM with 270 GSM and 300 GSM options for heavy-duty applications, and sanforized and mercerized fabric for minimum shrinkage and colour bleeding. Listed colours are Petrol Blue, Dark Blue, Grey, Beige, Orange and Red; sizes are Small-5XL.', '{\"sku\": \"RA-CTU240\", \"standards\": [\"EN ISO 13688:2013\"], \"material\": \"100% premium cotton twill\", \"fabric_weight\": \"240 GSM; also available in 270 GSM and 300 GSM for heavy-duty applications\", \"features\": [\"Sanforized and mercerized for minimum shrinkage and colour bleeding\"], \"sizes\": \"Small-5XL\", \"colours\": [\"Petrol Blue\", \"Dark Blue\", \"Grey\", \"Beige\", \"Orange\", \"Red\"], \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"100% Cotton Uniform (Pant \\/ Shirt)\", \"subcategory\": \"Uniforms\", \"manual_review\": false, \"image_path\": \"storage/uploads/catalogue/rangers-ra-ctu240-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 38, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(19, 2, 'Fire-Retardant (FR) Coveralls', 'fire-retardant-coveralls-ra-frc200', 'FR coverall entry from a shared coveralls/uniforms family with multiple base-fabric and upgrade options.', 'The catalogue groups Fire-Retardant (FR) Coveralls & Uniforms under SKUs RA-FRC200 / RA-FRU200. This entry uses RA-FRC200 based on the SKU suffix; the exact individual product title needs confirmation. The group lists EN ISO 13688:2013 and EN ISO 11612 (protection against heat and flame), treated 100% premium cotton fabric in 150 GSM, 210 GSM and 300 GSM options, IFR 320 GSM, Nomex IIA/IIIA, and FR/Anti-Static blends (EN 1149-5) as premium upgrades. Features listed include flame-resistant sewing threads, concealed heavy-duty brass zippers and reinforced stress points. Listed colours are Petrol Blue, Orange and Red, with custom colours and designs available upon request; sizes are Small-5XL.', '{\"sku\": \"RA-FRC200\", \"related_sku\": \"RA-FRU200\", \"standards\": [\"EN ISO 13688:2013\", \"EN ISO 11612 (protection against heat and flame)\", \"EN 1149-5 (listed for FR\\/Anti-Static blends)\"], \"material\": \"Treated 100% premium cotton fabric; premium upgrades include IFR, Nomex IIA\\/IIIA, and FR\\/Anti-Static blends\", \"fabric_weight\": \"Base options: 150 GSM, 210 GSM, 300 GSM; IFR upgrade: 320 GSM\", \"features\": [\"Flame-resistant sewing threads\", \"Concealed heavy-duty brass zippers\", \"Reinforced stress points\"], \"sizes\": \"Small-5XL\", \"colours\": [\"Petrol Blue\", \"Orange\", \"Red\", \"Custom colours and designs available upon request\"], \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Fire-Retardant (FR) Coveralls & Uniforms\", \"subcategory\": \"Fire-Retardant Coveralls\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-fr-coveralls-uniforms-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 39, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04'),
(20, 2, 'Fire-Retardant (FR) Uniform', 'fire-retardant-uniform-ra-fru200', 'FR uniform entry from a shared coveralls/uniforms family with multiple base-fabric and upgrade options.', 'The catalogue groups Fire-Retardant (FR) Coveralls & Uniforms under SKUs RA-FRC200 / RA-FRU200. This entry uses RA-FRU200 based on the SKU suffix; the exact individual product title needs confirmation. The group lists EN ISO 13688:2013 and EN ISO 11612 (protection against heat and flame), treated 100% premium cotton fabric in 150 GSM, 210 GSM and 300 GSM options, IFR 320 GSM, Nomex IIA/IIIA, and FR/Anti-Static blends (EN 1149-5) as premium upgrades. Features listed include flame-resistant sewing threads, concealed heavy-duty brass zippers and reinforced stress points. Listed colours are Petrol Blue, Orange and Red, with custom colours and designs available upon request; sizes are Small-5XL.', '{\"sku\": \"RA-FRU200\", \"related_sku\": \"RA-FRC200\", \"standards\": [\"EN ISO 13688:2013\", \"EN ISO 11612 (protection against heat and flame)\", \"EN 1149-5 (listed for FR\\/Anti-Static blends)\"], \"material\": \"Treated 100% premium cotton fabric; premium upgrades include IFR, Nomex IIA\\/IIIA, and FR\\/Anti-Static blends\", \"fabric_weight\": \"Base options: 150 GSM, 210 GSM, 300 GSM; IFR upgrade: 320 GSM\", \"features\": [\"Flame-resistant sewing threads\", \"Concealed heavy-duty brass zippers\", \"Reinforced stress points\"], \"sizes\": \"Small-5XL\", \"colours\": [\"Petrol Blue\", \"Orange\", \"Red\", \"Custom colours and designs available upon request\"], \"source_pdf\": \"rangers-safety-catalogue.pdf\", \"source_page\": 1, \"source_heading\": \"Fire-Retardant (FR) Coveralls & Uniforms\", \"subcategory\": \"Fire-Retardant Uniforms\", \"manual_review\": true, \"image_path\": \"storage/uploads/catalogue/rangers-fr-coveralls-uniforms-2k.png\", \"image_status\": \"2k_original_pdf_photo_upscaled\"}', 40, 'active', 0, '2026-10-20 09:45:32', '2026-10-20 11:25:04');

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `image_path` varchar(500) NOT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `display_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `image_path`, `alt_text`, `display_order`, `created_at`) VALUES
(21, 1, 'storage/uploads/catalogue/rangers-ss-12s-s1p-2k.png', 'SS-12S-S1P', 0, '2026-10-20 11:03:35'),
(22, 2, 'storage/uploads/catalogue/rangers-ss-18-s1p-2k.png', 'SS-18-S1P', 0, '2026-10-20 11:03:35'),
(23, 3, 'storage/uploads/catalogue/rangers-ss-21-s3-2k.png', 'SS-21-S3', 0, '2026-10-20 11:03:35'),
(24, 4, 'storage/uploads/catalogue/rangers-ss-25-s3-2k.png', 'SS-25-S3', 0, '2026-10-20 11:03:35'),
(25, 5, 'storage/uploads/catalogue/rangers-ss-26-s3-2k.png', 'SS-26-S3', 0, '2026-10-20 11:03:35'),
(26, 6, 'storage/uploads/catalogue/rangers-ss-49-s3-2k.png', 'SS-49-S3', 0, '2026-10-20 11:03:35'),
(27, 7, 'storage/uploads/catalogue/rangers-ss-59-s1p-2k.png', 'SS-59-S1P', 0, '2026-10-20 11:03:35'),
(28, 8, 'storage/uploads/catalogue/rangers-ss-136-s3-2k.png', 'SS-136-S3', 0, '2026-10-20 11:03:35'),
(29, 9, 'storage/uploads/catalogue/rangers-ss-138-s3-2k.png', 'SS-138-S3', 0, '2026-10-20 11:03:35'),
(30, 10, 'storage/uploads/catalogue/rangers-ss-161-s3-2k.png', 'SS-161-S3', 0, '2026-10-20 11:03:35'),
(31, 11, 'storage/uploads/catalogue/rangers-abora-9822-2k.png', 'ABORA-9822', 0, '2026-10-20 11:03:35'),
(32, 12, 'storage/uploads/catalogue/rangers-electa-9824-2k.png', 'ELECTA-9824', 0, '2026-10-20 11:03:35'),
(33, 13, 'storage/uploads/catalogue/rangers-istella-9814-2k.png', 'ISTELLA-9814', 0, '2026-10-20 11:03:35'),
(34, 14, 'storage/uploads/catalogue/rangers-roover-1844-2k.png', 'ROOVER-1844', 0, '2026-10-20 11:03:35'),
(35, 15, 'storage/uploads/catalogue/rangers-slamer-8824-2k.png', 'SLAMER-8824', 0, '2026-10-20 11:03:35'),
(36, 16, 'storage/uploads/catalogue/rangers-ra-pcc160-2k.png', '60/40 Polycotton Coverall', 0, '2026-10-20 11:03:35'),
(37, 17, 'storage/uploads/catalogue/rangers-ra-pcu160-2k.png', '60/40 Polycotton Uniform (Pant / Shirt)', 0, '2026-10-20 11:03:35'),
(38, 18, 'storage/uploads/catalogue/rangers-ra-ctu240-2k.png', '100% Cotton Uniform (Pant / Shirt)', 0, '2026-10-20 11:03:35'),
(39, 19, 'storage/uploads/catalogue/rangers-fr-coveralls-uniforms-2k.png', 'Fire-Retardant (FR) Coveralls', 0, '2026-10-20 11:03:35'),
(40, 20, 'storage/uploads/catalogue/rangers-fr-coveralls-uniforms-2k.png', 'Fire-Retardant (FR) Uniform', 0, '2026-10-20 11:03:35');

-- --------------------------------------------------------

--
-- Table structure for table `social_links`
--

CREATE TABLE `social_links` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `platform` varchar(40) NOT NULL,
  `url` varchar(1000) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'inactive',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `social_links`
--

INSERT INTO `social_links` (`id`, `platform`, `url`, `status`, `updated_at`) VALUES
(1, 'linkedin', '', 'inactive', '2026-10-20 08:09:24'),
(2, 'instagram', '', 'inactive', '2026-10-20 08:09:24'),
(3, 'facebook', '', 'inactive', '2026-10-20 08:09:24');

-- --------------------------------------------------------

--
-- Table structure for table `website_settings`
--

CREATE TABLE `website_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `website_settings`
--

INSERT INTO `website_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES
(1, 'whatsapp_number', '', '2026-10-20 08:09:24'),
(2, 'whatsapp_message', 'Hello', '2026-10-20 08:09:24'),
(3, 'whatsapp_enabled', '0', '2026-10-20 08:09:24'),
(4, 'logo_path', '', '2026-10-20 08:09:24'),
(5, 'favicon_path', '', '2026-10-20 08:09:24'),
(6, 'seo_description', '', '2026-10-20 08:09:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `booklet_products`
--
ALTER TABLE `booklet_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_id` (`product_id`);

--
-- Indexes for table `booklet_settings`
--
ALTER TABLE `booklet_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `cms_elements`
--
ALTER TABLE `cms_elements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_element` (`page_slug`,`element_key`);

--
-- Indexes for table `cms_pages`
--
ALTER TABLE `cms_pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_slug` (`slug`);

--
-- Indexes for table `company_information`
--
ALTER TABLE `company_information`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `exhibitions`
--
ALTER TABLE `exhibitions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `exhibition_products`
--
ALTER TABLE `exhibition_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `exhibition_id` (`exhibition_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ip_hash` (`ip_hash`,`created_at`);

--
-- Indexes for table `media_library`
--
ALTER TABLE `media_library`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `fk_main_image` (`main_image_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `social_links`
--
ALTER TABLE `social_links`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `platform` (`platform`);

--
-- Indexes for table `website_settings`
--
ALTER TABLE `website_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `booklet_products`
--
ALTER TABLE `booklet_products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cms_elements`
--
ALTER TABLE `cms_elements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cms_pages`
--
ALTER TABLE `cms_pages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `exhibitions`
--
ALTER TABLE `exhibitions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `exhibition_products`
--
ALTER TABLE `exhibition_products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `media_library`
--
ALTER TABLE `media_library`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `social_links`
--
ALTER TABLE `social_links`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `website_settings`
--
ALTER TABLE `website_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booklet_products`
--
ALTER TABLE `booklet_products`
  ADD CONSTRAINT `booklet_products_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `exhibition_products`
--
ALTER TABLE `exhibition_products`
  ADD CONSTRAINT `exhibition_products_ibfk_1` FOREIGN KEY (`exhibition_id`) REFERENCES `exhibitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exhibition_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_main_image` FOREIGN KEY (`main_image_id`) REFERENCES `product_images` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 17, 2026 at 01:01 PM
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
-- Database: `basobas_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` varchar(50) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `amenities`
--

CREATE TABLE `amenities` (
  `amenity_id` int(11) NOT NULL,
  `amenity_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `amenities`
--

INSERT INTO `amenities` (`amenity_id`, `amenity_name`) VALUES
(4, '24/7 Water Supply'),
(15, 'Air Conditioning'),
(2, 'Backup Generator'),
(9, 'Balcony'),
(7, 'CCTV'),
(8, 'Elevator'),
(10, 'Furnished'),
(20, 'Garden'),
(19, 'Gym'),
(16, 'Heater'),
(14, 'Hospital Nearby'),
(3, 'Inverter'),
(11, 'Kitchen'),
(12, 'Park Nearby'),
(1, 'Parking'),
(13, 'School Nearby'),
(6, 'Security Guard'),
(17, 'Solar Panel'),
(18, 'Waste Management'),
(5, 'WiFi');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `rental_request_id` int(11) DEFAULT NULL,
  `display_id` varchar(20) DEFAULT NULL,
  `tenant_id` int(11) NOT NULL,
  `landlord_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_month` date NOT NULL,
  `payment_date` datetime DEFAULT current_timestamp(),
  `payment_method` enum('bank_transfer','cash','card','khalti','esewa','ime_pay','connectips') DEFAULT 'bank_transfer',
  `transaction_reference` varchar(100) DEFAULT NULL,
  `status` enum('pending','completed','failed','refunded') DEFAULT 'completed',
  `late_fee` decimal(10,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `receipt_url` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `property_id`, `rental_request_id`, `display_id`, `tenant_id`, `landlord_id`, `amount`, `payment_month`, `payment_date`, `payment_method`, `transaction_reference`, `status`, `late_fee`, `notes`, `receipt_url`) VALUES
(1, 9, NULL, 'PY00001', 17, 16, 1000.00, '2026-06-01', '2026-05-17 01:10:05', 'cash', '', 'completed', 0.00, '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `property_id` int(11) NOT NULL,
  `display_id` varchar(20) DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `landlord_id` int(11) NOT NULL,
  `landlord_name` varchar(100) DEFAULT NULL,
  `property_type` enum('apartment','house','condo','studio','room','flat','basement') DEFAULT 'apartment',
  `bedrooms` int(11) DEFAULT 1,
  `bathrooms` decimal(2,1) DEFAULT 1.0,
  `monthly_rent` decimal(10,2) NOT NULL,
  `security_deposit` decimal(10,2) DEFAULT 0.00,
  `city` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `ward_number` int(11) DEFAULT NULL,
  `floor_number` int(11) DEFAULT NULL,
  `road_access` enum('2w','4w','both','none') DEFAULT 'both',
  `water_source` enum('municipal','tanker','well','borewell') DEFAULT 'municipal',
  `power_backup_hours` int(11) DEFAULT 0,
  `status` enum('available','rented','inactive') DEFAULT 'available',
  `current_tenant_id` int(11) DEFAULT NULL,
  `current_lease_start` date DEFAULT NULL,
  `current_lease_end` date DEFAULT NULL,
  `available_from` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `properties`
--

INSERT INTO `properties` (`property_id`, `display_id`, `title`, `description`, `landlord_id`, `landlord_name`, `property_type`, `bedrooms`, `bathrooms`, `monthly_rent`, `security_deposit`, `city`, `address`, `ward_number`, `floor_number`, `road_access`, `water_source`, `power_backup_hours`, `status`, `current_tenant_id`, `current_lease_start`, `current_lease_end`, `available_from`, `created_at`, `updated_at`) VALUES
(9, 'PR00009', 'Explicabo Magna cor', 'Amet obcaecati quam', 16, 'Gabriel Cleveland', 'flat', 20, 9.0, 1000.00, 2000.00, 'Quia dolor asperiore', 'Adipisicing nisi ear', 17, 21, 'both', 'well', 18, 'rented', 17, NULL, NULL, '1984-11-26', '2026-05-16 13:25:53', '2026-05-16 17:48:40'),
(10, 'PR00010', 'Beatae rerum aut eaq', 'Quia mollitia aut iu', 16, 'Gabriel Cleveland', 'studio', 20, 6.0, 1000.00, 2000.00, 'Ex fuga Dolorem mag', 'Repudiandae debitis ', 14, 2, 'both', 'tanker', 16, 'rented', 17, NULL, NULL, '2021-03-01', '2026-05-16 14:13:39', '2026-05-16 18:45:55'),
(11, 'PR00011', 'Labore eveniet et a', 'Minim ratione qui in', 16, 'Gabriel Cleveland', 'flat', 1, 2.0, 100.00, 200.00, 'Incididunt consectet', 'Et sint quod commodo', 5, 2, 'both', 'municipal', 11, 'rented', 17, NULL, NULL, '1985-10-28', '2026-05-16 17:48:22', '2026-05-16 18:16:09'),
(12, 'PR00012', 'Est quo porro aliqua', 'Excepteur dolor ad s', 16, 'Gabriel Cleveland', 'studio', 14, 6.0, 5000.00, 10000.00, 'Aliquid nulla consec', 'Fugiat cum amet su', 3, 2, 'both', 'well', 2, 'available', NULL, NULL, NULL, '2027-01-10', '2026-05-16 19:51:58', '2026-05-17 06:01:58'),
(13, 'PR00013', 'Modern Apartment', 'Modern apartment in Kathmandu  in cozy area.', 19, 'Dai Williams', 'apartment', 2, 1.0, 50000.00, 90000.00, 'Kathmandu', 'Somewhere, Kathmandu', 6, 3, 'both', 'well', 12, 'rented', 20, NULL, NULL, '2026-05-18', '2026-05-17 07:42:11', '2026-05-17 07:57:41');

-- --------------------------------------------------------

--
-- Table structure for table `property_amenities`
--

CREATE TABLE `property_amenities` (
  `property_id` int(11) NOT NULL,
  `amenity_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `property_photos`
--

CREATE TABLE `property_photos` (
  `photo_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `photo_url` varchar(500) NOT NULL,
  `is_primary` tinyint(1) DEFAULT 0,
  `caption` varchar(200) DEFAULT NULL,
  `display_order` int(11) DEFAULT 0,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `property_photos`
--

INSERT INTO `property_photos` (`photo_id`, `property_id`, `photo_url`, `is_primary`, `caption`, `display_order`, `uploaded_at`) VALUES
(10, 9, '/property-photo/PR00009_1778937953851.jpg', 1, NULL, 0, '2026-05-16 13:25:53'),
(11, 9, '/property-photo/PR00009_1778937953879.png', 0, NULL, 1, '2026-05-16 13:25:53'),
(12, 10, '/property-photo/PR00010_1778940831716.png', 1, NULL, 0, '2026-05-16 14:13:51'),
(13, 11, 'PR00011_1778953702437.jpg', 1, NULL, 0, '2026-05-16 17:48:22'),
(14, 12, 'PR00012_1778961118990.png', 1, NULL, 0, '2026-05-16 19:51:59'),
(15, 13, 'PR00013_1779003731064.jpg', 1, NULL, 0, '2026-05-17 07:42:11'),
(16, 13, 'PR00013_1779003731089.jpeg', 0, NULL, 1, '2026-05-17 07:42:11'),
(17, 13, 'PR00013_1779003731108.png', 0, NULL, 2, '2026-05-17 07:42:11');

-- --------------------------------------------------------

--
-- Table structure for table `rental_requests`
--

CREATE TABLE `rental_requests` (
  `request_id` int(11) NOT NULL,
  `display_id` varchar(20) DEFAULT NULL,
  `property_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `landlord_id` int(11) NOT NULL,
  `requested_move_in_date` date NOT NULL,
  `requested_lease_duration_months` int(11) DEFAULT 12,
  `monthly_rent_offered` decimal(10,2) DEFAULT NULL,
  `tenant_message` text DEFAULT NULL,
  `landlord_response` text DEFAULT NULL,
  `status` enum('pending','approved','rejected','cancelled') DEFAULT 'pending',
  `move_in_date` date DEFAULT NULL,
  `move_out_date` date DEFAULT NULL,
  `responded_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rental_requests`
--

INSERT INTO `rental_requests` (`request_id`, `display_id`, `property_id`, `tenant_id`, `landlord_id`, `requested_move_in_date`, `requested_lease_duration_months`, `monthly_rent_offered`, `tenant_message`, `landlord_response`, `status`, `move_in_date`, `move_out_date`, `responded_at`, `created_at`) VALUES
(1, 'RR00001', 9, 17, 16, '2026-05-21', 24, 1000.00, 'noooo', '', 'approved', NULL, NULL, '2026-05-16 23:33:40', '2026-05-16 17:42:08'),
(2, 'RR00002', 11, 17, 16, '2026-05-29', 12, NULL, '', '', 'rejected', NULL, NULL, '2026-05-16 23:40:04', '2026-05-16 17:54:05'),
(3, 'RR00003', 11, 17, 16, '2026-05-27', 12, NULL, '', 'Yes bro', 'approved', NULL, NULL, '2026-05-17 00:01:09', '2026-05-16 17:57:52'),
(4, 'RR00004', 10, 17, 16, '2026-05-14', 12, NULL, '', '', 'approved', NULL, NULL, '2026-05-17 00:30:55', '2026-05-16 18:44:57'),
(5, 'RR00005', 12, 17, 16, '2026-05-28', 12, NULL, 'test', NULL, 'cancelled', NULL, NULL, NULL, '2026-05-17 06:02:24'),
(6, 'RR00006', 13, 20, 19, '2026-06-01', 12, NULL, 'Interested in reniting this property', 'Yes bro', 'approved', NULL, NULL, '2026-05-17 13:42:41', '2026-05-17 07:53:56'),
(7, 'RR00007', 12, 17, 16, '2026-05-19', 12, NULL, 'Reject this\\n', 'OK', 'rejected', NULL, NULL, '2026-05-17 14:07:21', '2026-05-17 08:20:46'),
(8, 'RR00008', 12, 17, 16, '2026-05-20', 12, NULL, '', NULL, 'pending', NULL, NULL, NULL, '2026-05-17 09:30:14');

--
-- Triggers `rental_requests`
--
DELIMITER $$
CREATE TRIGGER `after_rental_request_approved` AFTER UPDATE ON `rental_requests` FOR EACH ROW BEGIN
    IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
        -- Update property status and current tenant
        UPDATE `properties` 
        SET 
            `status` = 'rented',
            `current_tenant_id` = NEW.tenant_id,
            `current_lease_start` = NEW.move_in_date,
            `current_lease_end` = DATE_ADD(NEW.move_in_date, INTERVAL NEW.requested_lease_duration_months MONTH)
        WHERE `property_id` = NEW.property_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `landlord_reply` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `saved_properties`
--

CREATE TABLE `saved_properties` (
  `saved_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `saved_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` varchar(20) DEFAULT 'tenant',
  `full_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `registered_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_logged_in` timestamp NULL DEFAULT NULL,
  `display_id` varchar(20) DEFAULT NULL,
  `profile_photo_url` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password`, `role`, `full_name`, `phone`, `address`, `date_of_birth`, `registered_at`, `last_logged_in`, `display_id`, `profile_photo_url`) VALUES
(1, 'admin', 'admin@basobas.com.np', '$2a$10$oWcFm98R9IsuV/MhK8JqD.w3TySnkAba/YoLVhL/QQyKuYsUOjmr.', 'admin', 'Basobas Admin', '', '', '2026-04-01', '2026-04-16 18:54:48', '2026-05-17 09:39:50', 'AD00001', NULL),
(10, 'quhixa', 'zexepy@mailinator.com', '$2a$10$pJcM.wOoQRDUPj9mqu0zDugQby6oYp95cv.0TNYYdsmES//75a6me', 'admin', 'Quinn Weiss', '+1 (639) 653-5689', 'Ipsum ut et sit a si', '2004-04-05', '2026-05-03 16:42:01', NULL, 'AD00010', NULL),
(15, 'landlordtest1', 'landlordtest1@gmail.com', '$2a$10$bQX0m.OqPE/uzuwy9c9Qh.y9uqYUBQJTCa5OKTciAd/anYnp86hOq', 'landlord', 'Landlord Test', '+9771234567890', NULL, '2026-05-07', '2026-05-06 17:41:02', '2026-05-06 17:41:13', 'LD00015', NULL),
(16, 'landlord1', 'gucyl@mailinator.com', '$2a$10$hrmSux/7Rzlnl5C/kb6HB.Tzg0msC1XkTTTywZHu1PLaDCRUqDrzW', 'landlord', 'Not Tenant', '+1 (875) 676-2053', '', '2009-08-02', '2026-05-14 18:41:15', '2026-05-17 09:46:06', 'LD00016', NULL),
(17, 'tenant1', 'vumyce@mailinator.com', '$2a$10$ClWZ63EUykxxg4tDfQJQCeI9/rSjiX99YDAPYLpBuvpaxvpZW3/Ca', 'tenant', 'Shahil Basnet', '+1 (424) 862-9162', 'Iusto commodo harum', '1977-12-24', '2026-05-16 12:54:28', '2026-05-17 09:56:46', 'TE00017', NULL),
(18, 'admin1', 'miquwumig@mailinator.com', '$2a$10$eIyelrxvRMZsSPGPh91sy.EscuMUHKUqNbllYGXC6.0vSCB7bjnbu', 'tenant', 'Full name', '+1 (135) 709-7936', 'Porro irure unde sol', '1993-04-15', '2026-05-17 03:56:11', NULL, 'TE00018', NULL),
(19, 'newlandlord1', 'fidebyr@mailinator.com', '$2a$10$T.8Sz3D1IuHSswf//aN/uOxrYRaxxQiPW5ol1/opDiFK9FiSpdcYW', 'landlord', 'Dai Williams', '', NULL, '1999-09-28', '2026-05-17 07:27:31', '2026-05-17 09:04:14', 'LD00019', NULL),
(20, 'newtenant1', 'wanuniqy@mailinator.com', '$2a$10$TwcDyDiEcamOXCHSwd2AiOdt370dVrZTARPa5Fon2Z3wEK60Dqfjq', 'tenant', 'Nigel Holman', '9771234567890', NULL, '2003-01-17', '2026-05-17 07:33:31', '2026-05-17 08:44:29', 'TE00020', NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_active_properties`
-- (See below for the actual view)
--
CREATE TABLE `vw_active_properties` (
`property_id` int(11)
,`display_id` varchar(20)
,`title` varchar(200)
,`city` varchar(100)
,`ward_number` int(11)
,`monthly_rent` decimal(10,2)
,`status` enum('available','rented','inactive')
,`created_at` timestamp
,`landlord_display_id` varchar(20)
,`landlord_name` varchar(100)
,`landlord_phone` varchar(20)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_active_properties`
--
DROP TABLE IF EXISTS `vw_active_properties`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_active_properties`  AS SELECT `p`.`property_id` AS `property_id`, `p`.`display_id` AS `display_id`, `p`.`title` AS `title`, `p`.`city` AS `city`, `p`.`ward_number` AS `ward_number`, `p`.`monthly_rent` AS `monthly_rent`, `p`.`status` AS `status`, `p`.`created_at` AS `created_at`, `u`.`display_id` AS `landlord_display_id`, `u`.`full_name` AS `landlord_name`, `u`.`phone` AS `landlord_phone` FROM (`properties` `p` join `users` `u` on(`p`.`landlord_id` = `u`.`user_id`)) WHERE `p`.`status` = 'available' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_action` (`action`);

--
-- Indexes for table `amenities`
--
ALTER TABLE `amenities`
  ADD PRIMARY KEY (`amenity_id`),
  ADD UNIQUE KEY `amenity_name` (`amenity_name`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD UNIQUE KEY `display_id` (`display_id`),
  ADD KEY `tenant_id` (`tenant_id`),
  ADD KEY `landlord_id` (`landlord_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `payments_ibfk_property` (`property_id`),
  ADD KEY `payments_ibfk_request` (`rental_request_id`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`property_id`),
  ADD UNIQUE KEY `display_id` (`display_id`),
  ADD KEY `idx_landlord` (`landlord_id`),
  ADD KEY `idx_city` (`city`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `properties_ibfk_tenant` (`current_tenant_id`);

--
-- Indexes for table `property_amenities`
--
ALTER TABLE `property_amenities`
  ADD PRIMARY KEY (`property_id`,`amenity_id`),
  ADD KEY `amenity_id` (`amenity_id`);

--
-- Indexes for table `property_photos`
--
ALTER TABLE `property_photos`
  ADD PRIMARY KEY (`photo_id`),
  ADD KEY `idx_property` (`property_id`);

--
-- Indexes for table `rental_requests`
--
ALTER TABLE `rental_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD UNIQUE KEY `display_id` (`display_id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_tenant` (`tenant_id`),
  ADD KEY `idx_landlord` (`landlord_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD UNIQUE KEY `unique_review` (`property_id`,`tenant_id`),
  ADD KEY `tenant_id` (`tenant_id`);

--
-- Indexes for table `saved_properties`
--
ALTER TABLE `saved_properties`
  ADD PRIMARY KEY (`saved_id`),
  ADD UNIQUE KEY `unique_saved` (`tenant_id`,`property_id`),
  ADD KEY `property_id` (`property_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `display_id` (`display_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `amenities`
--
ALTER TABLE `amenities`
  MODIFY `amenity_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `property_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `property_photos`
--
ALTER TABLE `property_photos`
  MODIFY `photo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `rental_requests`
--
ALTER TABLE `rental_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `saved_properties`
--
ALTER TABLE `saved_properties`
  MODIFY `saved_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `payments_ibfk_3` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `payments_ibfk_property` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_ibfk_request` FOREIGN KEY (`rental_request_id`) REFERENCES `rental_requests` (`request_id`) ON DELETE SET NULL;

--
-- Constraints for table `properties`
--
ALTER TABLE `properties`
  ADD CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `properties_ibfk_tenant` FOREIGN KEY (`current_tenant_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `property_amenities`
--
ALTER TABLE `property_amenities`
  ADD CONSTRAINT `property_amenities_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `property_amenities_ibfk_2` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`amenity_id`) ON DELETE CASCADE;

--
-- Constraints for table `property_photos`
--
ALTER TABLE `property_photos`
  ADD CONSTRAINT `property_photos_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE;

--
-- Constraints for table `rental_requests`
--
ALTER TABLE `rental_requests`
  ADD CONSTRAINT `rental_requests_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rental_requests_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rental_requests_ibfk_3` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `saved_properties`
--
ALTER TABLE `saved_properties`
  ADD CONSTRAINT `saved_properties_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `saved_properties_ibfk_2` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

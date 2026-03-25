-- Curriculum GUID Dump
-- Generated: 2025-10-20T14:37:30+00:00
-- Database: dashboard_development
-- Tables: 27
-- Purpose: Phase 2 GUID migration - curriculum data without ID columns

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Table structure for scripts
CREATE TABLE `scripts` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for scripts
INSERT INTO `scripts` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'course1', '2025-10-17 10:00:00', '2025-10-17 10:00:00'),
('550e8400-e29b-41d4-a716-446655440002', 'course2', '2025-10-17 10:00:00', '2025-10-17 10:00:00');

SET FOREIGN_KEY_CHECKS = 1;

-- Dump completed: 2025-10-20T14:37:30+00:00
-- Total tables processed: 27
-- Total records: 1000

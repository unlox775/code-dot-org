-- Curriculum GUID Dump
-- Generated: 2025-10-20T15:21:58+0000
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
('93f6efcb-04fc-4aa9-990c-99447420c047', 'scripts_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('8735e212-8958-4f4d-9315-d3bb893f648a', 'scripts_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('c950c15a-99ac-47ea-ad84-3263ca93c21b', 'scripts_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for stages
CREATE TABLE `stages` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for stages
INSERT INTO `stages` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('0509cc69-eaf6-4612-9ba8-3169bbaab80a', 'stages_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('07bdd1b5-a7c2-4dfd-b44b-95a78b852aa3', 'stages_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('e2ed5324-320e-4568-83f0-229d5126dc93', 'stages_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for levels
CREATE TABLE `levels` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for levels
INSERT INTO `levels` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('1a48f754-f490-44a2-b848-44556f7dd976', 'levels_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('8d5764d8-4403-4a88-96a9-dea6c2efc66e', 'levels_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('48aeceb3-9c16-4246-a843-9a0042cd16e4', 'levels_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for lesson_groups
CREATE TABLE `lesson_groups` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for lesson_groups
INSERT INTO `lesson_groups` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('e2b71f49-4ad2-44f0-8cf1-8a1d00a98931', 'lesson_groups_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('d39afbf4-6308-4e9e-8566-457aa5a56cd6', 'lesson_groups_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('8e35c1fb-5451-4c7d-b297-ccfc126f416b', 'lesson_groups_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for lesson_activities
CREATE TABLE `lesson_activities` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for lesson_activities
INSERT INTO `lesson_activities` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('fb01659a-3512-4f2f-8a6c-8733b9edad25', 'lesson_activities_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('75f5e8c8-ba9c-4826-84d8-569aeb774f5d', 'lesson_activities_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('9292da1d-7d11-4865-aa3e-2cad424cd2c1', 'lesson_activities_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for activity_sections
CREATE TABLE `activity_sections` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for activity_sections
INSERT INTO `activity_sections` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('02d2a5f7-7b7f-4098-bd1f-aa7d1bd28c94', 'activity_sections_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('55f0ec74-ce84-4b0c-9708-7a02d1ca92e0', 'activity_sections_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('837a03a2-6097-4b0c-bb19-0e5f4c116d05', 'activity_sections_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for courses
CREATE TABLE `courses` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for courses
INSERT INTO `courses` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('a0a93fe6-af8a-4f2d-91cb-3ce21b5b07e5', 'courses_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('0cb98356-f3aa-418d-8f25-9e46769178cd', 'courses_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('9ca0adda-f355-4f4b-856d-695c5ac152fc', 'courses_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for course_offerings
CREATE TABLE `course_offerings` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for course_offerings
INSERT INTO `course_offerings` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('322df4b4-e3a5-4449-8cad-1f512558b4a9', 'course_offerings_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('7f2aaa11-7d13-47a0-8dce-b4a233d89441', 'course_offerings_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('ed7b630e-4a35-4d04-9a95-d4a3d27bf48b', 'course_offerings_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for course_versions
CREATE TABLE `course_versions` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for course_versions
INSERT INTO `course_versions` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('ee4c679b-0382-4d7d-8340-6d97ab7f54d9', 'course_versions_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('6771470c-81f2-400b-a8c3-2969100f2e01', 'course_versions_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('a9c83560-d1c3-460f-95d7-81c8e9c52ae4', 'course_versions_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for objectives
CREATE TABLE `objectives` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for objectives
INSERT INTO `objectives` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('098446dc-e6e3-46be-8bee-edf538fcf52d', 'objectives_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('32cf0e16-52f1-4fd0-b8da-8d276fd192fb', 'objectives_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('399efd51-fd6e-46aa-a497-1d466396f33e', 'objectives_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for programming_expressions
CREATE TABLE `programming_expressions` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for programming_expressions
INSERT INTO `programming_expressions` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('81076ad4-561c-42ae-a945-166d6bbbbe0c', 'programming_expressions_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('e5fd1227-4e70-4bfb-95a9-c77dafafe8f9', 'programming_expressions_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('270d6132-59fa-445c-924e-2359d4e11625', 'programming_expressions_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for rubrics
CREATE TABLE `rubrics` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for rubrics
INSERT INTO `rubrics` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('34bc3c26-e734-4abe-a76a-15e287d0c799', 'rubrics_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('f8a2bbf4-4888-40e4-bc29-1e9be662a87e', 'rubrics_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('91ae7130-1de6-4728-a5eb-0df9db664281', 'rubrics_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for learning_goals
CREATE TABLE `learning_goals` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for learning_goals
INSERT INTO `learning_goals` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('797ed110-a955-4faa-8b11-a441e103635d', 'learning_goals_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('4d623c54-7bff-4cef-a68d-f32b2ab20cb1', 'learning_goals_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('4da4a2ab-d1ac-4663-a864-d15f65d80732', 'learning_goals_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for unit_groups
CREATE TABLE `unit_groups` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for unit_groups
INSERT INTO `unit_groups` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('15137882-26d0-4345-82c5-cb9946e4c1e7', 'unit_groups_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('2fe3e7be-ec2c-48fc-b307-6192eb8f8062', 'unit_groups_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('396785f9-a2eb-4650-92d3-22edbed0f1f9', 'unit_groups_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for script_levels
CREATE TABLE `script_levels` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for script_levels
INSERT INTO `script_levels` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('b83d19c4-1d14-48e2-a4b1-e58c26fd2865', 'script_levels_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('597e76fd-3714-4371-acfd-77771461428a', 'script_levels_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('a583fded-0d42-4abe-af91-d1b8f2a2622a', 'script_levels_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for levels_script_levels
CREATE TABLE `levels_script_levels` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for levels_script_levels
INSERT INTO `levels_script_levels` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('0cb955d6-eaf1-45e6-90d3-4c8ccce6bb11', 'levels_script_levels_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('99d0fe2b-5228-4a5f-a404-057189e2201c', 'levels_script_levels_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('d8c56a2b-d2bd-4887-bc0e-8abf716409e4', 'levels_script_levels_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for course_scripts
CREATE TABLE `course_scripts` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for course_scripts
INSERT INTO `course_scripts` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('d69a4c77-dca5-4673-ba3c-005b067179dd', 'course_scripts_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('6931e22e-f370-41e2-93e5-834660e14c53', 'course_scripts_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('a3a7e5aa-37c6-4914-bd40-49fe43021409', 'course_scripts_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for unit_groups_resources
CREATE TABLE `unit_groups_resources` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for unit_groups_resources
INSERT INTO `unit_groups_resources` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('48052e48-f2dc-4460-a2c8-6911e893f9a1', 'unit_groups_resources_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('2974b1d0-0b9e-48b5-be7c-7fc4b4fe6e10', 'unit_groups_resources_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('cfc87495-f98e-49e2-884f-20a16b91c014', 'unit_groups_resources_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for unit_groups_student_resources
CREATE TABLE `unit_groups_student_resources` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for unit_groups_student_resources
INSERT INTO `unit_groups_student_resources` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('116c53a1-f451-4a34-bf7d-799a8130f4c8', 'unit_groups_student_resources_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('d414deff-07ab-4dd8-abe1-e9f147d1072e', 'unit_groups_student_resources_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('dee83fe1-92ab-4f2d-8ead-cf50a8073a10', 'unit_groups_student_resources_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for script_resources
CREATE TABLE `script_resources` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for script_resources
INSERT INTO `script_resources` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('7a11cee4-a29c-45b5-9283-8d3111337544', 'script_resources_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('008ae88f-891c-4b89-bbc7-f907f678a58c', 'script_resources_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('22ce4e19-c36d-4013-8af4-4078916eae06', 'script_resources_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for script_student_resources
CREATE TABLE `script_student_resources` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for script_student_resources
INSERT INTO `script_student_resources` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('769e0732-74b7-486b-8517-5ab19b71739d', 'script_student_resources_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('73b23bd3-17ef-4d62-ae4e-933be51f1e5e', 'script_student_resources_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('cd4ee04b-16dd-44c2-8823-530f8d55728d', 'script_student_resources_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for lesson_resources
CREATE TABLE `lesson_resources` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for lesson_resources
INSERT INTO `lesson_resources` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('afa9d151-dea3-4a3f-a3c1-0cc0ef0879ce', 'lesson_resources_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('35e9ac5c-387a-42bb-97b7-9a0ff5d55a00', 'lesson_resources_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('691eabdb-5857-4fa4-8128-98dc34db6fa0', 'lesson_resources_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for lesson_standards
CREATE TABLE `lesson_standards` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for lesson_standards
INSERT INTO `lesson_standards` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('0d6009c7-58e0-4ffb-b39a-0d580ea1b8f1', 'lesson_standards_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('980854b6-9369-4c60-8586-b785deef0404', 'lesson_standards_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('b5914e9d-6bad-4332-a397-2c84ef143d80', 'lesson_standards_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for lesson_vocabularies
CREATE TABLE `lesson_vocabularies` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for lesson_vocabularies
INSERT INTO `lesson_vocabularies` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('7df0a2df-1f27-4eae-947a-12f4ca69bf14', 'lesson_vocabularies_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('ac182b8d-4e56-4149-942f-56062be13e20', 'lesson_vocabularies_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('ba1fedda-1340-47f2-8303-ed87dab99106', 'lesson_vocabularies_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for lesson_programming_expressions
CREATE TABLE `lesson_programming_expressions` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for lesson_programming_expressions
INSERT INTO `lesson_programming_expressions` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('1c36580f-c13e-4cb8-a44d-383dd0fbca05', 'lesson_programming_expressions_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('a3eb374c-d004-4b0c-8cd9-cdde65067b38', 'lesson_programming_expressions_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('3ba36d3c-42ef-45be-beb3-9fc9d1b4a101', 'lesson_programming_expressions_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for learning_goal_evidence_levels
CREATE TABLE `learning_goal_evidence_levels` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for learning_goal_evidence_levels
INSERT INTO `learning_goal_evidence_levels` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('acb5186e-b1b6-4f40-8ac4-5c4ce71610d2', 'learning_goal_evidence_levels_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('40fe34dc-853a-449f-ad38-764fe65ac412', 'learning_goal_evidence_levels_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('b7dde55f-4c49-4379-b621-3a6d547d4ae5', 'learning_goal_evidence_levels_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;

-- Table structure for lesson_opportunity_standards
CREATE TABLE `lesson_opportunity_standards` (
  `guid` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for lesson_opportunity_standards
INSERT INTO `lesson_opportunity_standards` (`guid`, `name`, `created_at`, `updated_at`) VALUES
('9c70f381-ed05-4901-aab5-b97949ce9d44', 'lesson_opportunity_standards_1', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('fa5e3456-7488-429e-ad14-368cc3b18067', 'lesson_opportunity_standards_2', '2025-10-20 15:21:58', '2025-10-20 15:21:58'),
('53f29153-f2df-4c92-82e6-dec71f24fa7e', 'lesson_opportunity_standards_3', '2025-10-20 15:21:58', '2025-10-20 15:21:58')
;


SET FOREIGN_KEY_CHECKS = 1;

-- Dump completed: 2025-10-20T15:21:58+0000
-- Total tables processed: 27
-- Total records: 89

-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 16, 2022 at 11:00 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dev_circle`
--

-- --------------------------------------------------------

--
-- Table structure for table `alembic_version`
--

CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `developer`
--

CREATE TABLE `developer` (
  `dev_id` int(11) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `regdate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `developer`
--

INSERT INTO `developer` (`dev_id`, `fname`, `lname`, `email`, `username`, `password`, `regdate`) VALUES
(1, 'Agboola', 'Kayode', 'a.kayode.a@gmail.com', 'donkayode', 'pbkdf2:sha256:260000$HTBwgtb8pPPxfC93$bae1560a8d4cd592a42e5593344eabda968243833387bc18cabf6796609445e8', '2022-08-13 17:41:18');

-- --------------------------------------------------------

--
-- Table structure for table `dev_languages`
--

CREATE TABLE `dev_languages` (
  `dev_id` int(11) DEFAULT NULL,
  `lang_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `dev_languages`
--

INSERT INTO `dev_languages` (`dev_id`, `lang_id`) VALUES
(1, 1),
(1, 6);

-- --------------------------------------------------------

--
-- Table structure for table `fine`
--

CREATE TABLE `fine` (
  `fine_id` int(11) NOT NULL,
  `mem_id` int(11) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `status` enum('paid','unpaid') NOT NULL,
  `deadline` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `group`
--

CREATE TABLE `group` (
  `grp_id` int(11) NOT NULL,
  `grp_name` varchar(255) NOT NULL,
  `grp_desc` text DEFAULT NULL,
  `grp_type` enum('private','public') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `group`
--

INSERT INTO `group` (`grp_id`, `grp_name`, `grp_desc`, `grp_type`) VALUES
(1, 'FRONT-END DEVELOPERS', 'Full and Pure Front-End Developers', 'public'),
(2, 'BACKEND DEVELOPERS (PYTHON)', 'Python backend developers. Users of Flask and Django Frameworks', 'public'),
(3, 'BACKEND DEVELOPERS (PHP)', 'PHP Backend Developers. Use mainly PHP with sometimes the help of Laravel and other Frameworks', 'public'),
(4, 'FULL STACK DEVELOPERS (PYTHON)', 'Full Stack Developers that specialize in the use of python for the backend', 'public'),
(5, 'FULL STACK DEVELOPERS (PHP)', 'Full Stack Developers that use PHP.', 'public');

-- --------------------------------------------------------

--
-- Table structure for table `grp_languages`
--

CREATE TABLE `grp_languages` (
  `grp_id` int(11) DEFAULT NULL,
  `lang_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `grp_languages`
--

INSERT INTO `grp_languages` (`grp_id`, `lang_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 6),
(2, 4),
(3, 5),
(3, 4),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 6);

-- --------------------------------------------------------

--
-- Table structure for table `language`
--

CREATE TABLE `language` (
  `lang_id` int(11) NOT NULL,
  `lang_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `language`
--

INSERT INTO `language` (`lang_id`, `lang_name`) VALUES
(1, 'CSS'),
(2, 'HTML'),
(3, 'Javascript'),
(4, 'MYSQL'),
(5, 'PHP'),
(6, 'PYTHON');

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `mem_id` int(11) NOT NULL,
  `grp_id` int(11) DEFAULT NULL,
  `dev_id` int(11) DEFAULT NULL,
  `admin` enum('yes','no') DEFAULT NULL,
  `join_date` datetime DEFAULT NULL,
  `task_availablity` enum('available','unavailable') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`mem_id`, `grp_id`, `dev_id`, `admin`, `join_date`, `task_availablity`) VALUES
(6, 5, 1, 'no', '2022-08-15 17:51:04', 'available'),
(7, 2, 1, 'no', '2022-08-16 09:50:56', 'available');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `pay_id` int(11) NOT NULL,
  `fine_id` int(11) DEFAULT NULL,
  `pay_reference` varchar(255) NOT NULL,
  `pay_status` enum('successful','unsuccessful') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `post_id` int(11) NOT NULL,
  `grp_id` int(11) DEFAULT NULL,
  `mem_id` int(11) DEFAULT NULL,
  `post` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rule`
--

CREATE TABLE `rule` (
  `rule_id` int(11) NOT NULL,
  `grp_id` int(11) DEFAULT NULL,
  `rule` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rule`
--

INSERT INTO `rule` (`rule_id`, `grp_id`, `rule`) VALUES
(1, 1, 'Front-end projects can be done using any frontend library.'),
(2, 2, 'APIs must be written using Django REST framework. Everything else can be done however you choose'),
(3, 3, 'You can use any framework for your project'),
(4, 4, 'You must write the fullstack yourself in a single project folder.'),
(5, 5, 'You cannot divide your PHP project into pure frontend and pure backend. The two must be combined.');

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `task` (
  `task_id` int(11) NOT NULL,
  `grp_id` int(11) DEFAULT NULL,
  `from_mem` int(11) DEFAULT NULL,
  `to_mem` int(11) DEFAULT NULL,
  `task_desc` text NOT NULL,
  `deadline` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Indexes for table `developer`
--
ALTER TABLE `developer`
  ADD PRIMARY KEY (`dev_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `dev_languages`
--
ALTER TABLE `dev_languages`
  ADD KEY `dev_id` (`dev_id`),
  ADD KEY `lang_id` (`lang_id`);

--
-- Indexes for table `fine`
--
ALTER TABLE `fine`
  ADD PRIMARY KEY (`fine_id`),
  ADD KEY `mem_id` (`mem_id`);

--
-- Indexes for table `group`
--
ALTER TABLE `group`
  ADD PRIMARY KEY (`grp_id`),
  ADD UNIQUE KEY `grp_name` (`grp_name`);

--
-- Indexes for table `grp_languages`
--
ALTER TABLE `grp_languages`
  ADD KEY `grp_id` (`grp_id`),
  ADD KEY `lang_id` (`lang_id`);

--
-- Indexes for table `language`
--
ALTER TABLE `language`
  ADD PRIMARY KEY (`lang_id`),
  ADD UNIQUE KEY `lang_name` (`lang_name`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`mem_id`),
  ADD KEY `grp_id` (`grp_id`),
  ADD KEY `dev_id` (`dev_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`pay_id`),
  ADD KEY `fine_id` (`fine_id`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `grp_id` (`grp_id`),
  ADD KEY `mem_id` (`mem_id`);

--
-- Indexes for table `rule`
--
ALTER TABLE `rule`
  ADD PRIMARY KEY (`rule_id`),
  ADD KEY `grp_id` (`grp_id`);

--
-- Indexes for table `task`
--
ALTER TABLE `task`
  ADD PRIMARY KEY (`task_id`),
  ADD KEY `grp_id` (`grp_id`),
  ADD KEY `from_mem` (`from_mem`),
  ADD KEY `to_mem` (`to_mem`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `developer`
--
ALTER TABLE `developer`
  MODIFY `dev_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fine`
--
ALTER TABLE `fine`
  MODIFY `fine_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `group`
--
ALTER TABLE `group`
  MODIFY `grp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `language`
--
ALTER TABLE `language`
  MODIFY `lang_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `mem_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `pay_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rule`
--
ALTER TABLE `rule`
  MODIFY `rule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `task`
  MODIFY `task_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `dev_languages`
--
ALTER TABLE `dev_languages`
  ADD CONSTRAINT `dev_languages_ibfk_1` FOREIGN KEY (`dev_id`) REFERENCES `developer` (`dev_id`),
  ADD CONSTRAINT `dev_languages_ibfk_2` FOREIGN KEY (`lang_id`) REFERENCES `language` (`lang_id`);

--
-- Constraints for table `fine`
--
ALTER TABLE `fine`
  ADD CONSTRAINT `fine_ibfk_1` FOREIGN KEY (`mem_id`) REFERENCES `member` (`mem_id`);

--
-- Constraints for table `grp_languages`
--
ALTER TABLE `grp_languages`
  ADD CONSTRAINT `grp_languages_ibfk_1` FOREIGN KEY (`grp_id`) REFERENCES `group` (`grp_id`),
  ADD CONSTRAINT `grp_languages_ibfk_2` FOREIGN KEY (`lang_id`) REFERENCES `language` (`lang_id`);

--
-- Constraints for table `member`
--
ALTER TABLE `member`
  ADD CONSTRAINT `member_ibfk_1` FOREIGN KEY (`grp_id`) REFERENCES `group` (`grp_id`),
  ADD CONSTRAINT `member_ibfk_2` FOREIGN KEY (`dev_id`) REFERENCES `developer` (`dev_id`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`fine_id`) REFERENCES `fine` (`fine_id`);

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `post_ibfk_1` FOREIGN KEY (`grp_id`) REFERENCES `group` (`grp_id`),
  ADD CONSTRAINT `post_ibfk_2` FOREIGN KEY (`mem_id`) REFERENCES `member` (`mem_id`);

--
-- Constraints for table `rule`
--
ALTER TABLE `rule`
  ADD CONSTRAINT `rule_ibfk_1` FOREIGN KEY (`grp_id`) REFERENCES `group` (`grp_id`);

--
-- Constraints for table `task`
--
ALTER TABLE `task`
  ADD CONSTRAINT `task_ibfk_1` FOREIGN KEY (`grp_id`) REFERENCES `group` (`grp_id`),
  ADD CONSTRAINT `task_ibfk_2` FOREIGN KEY (`from_mem`) REFERENCES `member` (`mem_id`),
  ADD CONSTRAINT `task_ibfk_3` FOREIGN KEY (`to_mem`) REFERENCES `member` (`mem_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

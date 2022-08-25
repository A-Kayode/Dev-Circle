-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 25, 2022 at 02:55 AM
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

--
-- Dumping data for table `alembic_version`
--

INSERT INTO `alembic_version` (`version_num`) VALUES
('bf3c4e62b095');

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `com_id` int(11) NOT NULL,
  `com_text` text NOT NULL,
  `post_id` int(11) DEFAULT NULL,
  `com_like_no` int(11) DEFAULT NULL,
  `dev_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`com_id`, `com_text`, `post_id`, `com_like_no`, `dev_id`) VALUES
(1, 'The snakes will never stop! We will swallow the entire world whole.', 8, 0, 1),
(2, 'The only mercy we shall show you is that we will swallow you completely whole.', 8, 0, 1),
(3, 'We have started the assault on the despicable elephants. It is our time to conquer the world.', 7, 1, 1),
(4, 'The snakes shall rule the world people. We are the best!', 7, 3, 2);

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `contact_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `date_sent` datetime DEFAULT NULL,
  `message` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`contact_id`, `name`, `email`, `date_sent`, `message`) VALUES
(1, 'Victor Uwanmaya', 'vicuwa@gmail.com', '2022-08-25 01:24:27', 'I want to be able to add things like fines to my group. Can you implement a feature like that?');

-- --------------------------------------------------------

--
-- Table structure for table `contention`
--

CREATE TABLE `contention` (
  `con_id` int(11) NOT NULL,
  `task_id` int(11) DEFAULT NULL,
  `state` enum('active','succeeded','failed') DEFAULT NULL,
  `closing_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `contention`
--

INSERT INTO `contention` (`con_id`, `task_id`, `state`, `closing_date`) VALUES
(1, 2, 'succeeded', '2022-08-23');

-- --------------------------------------------------------

--
-- Table structure for table `con_votes`
--

CREATE TABLE `con_votes` (
  `vote_id` int(11) NOT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `voter` int(11) DEFAULT NULL,
  `vote` enum('yes','no') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `con_votes`
--

INSERT INTO `con_votes` (`vote_id`, `issue_id`, `voter`, `vote`) VALUES
(1, 1, 7, 'no');

-- --------------------------------------------------------

--
-- Table structure for table `correspondence`
--

CREATE TABLE `correspondence` (
  `cor_id` int(11) NOT NULL,
  `dev_a` int(11) NOT NULL,
  `dev_b` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `correspondence`
--

INSERT INTO `correspondence` (`cor_id`, `dev_a`, `dev_b`) VALUES
(1, 1, 2),
(2, 1, 3);

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
(1, 'Agboola', 'Kayode', 'a.kayode.a@gmail.com', 'donkayode', 'pbkdf2:sha256:260000$jlXbeWmaIMod3Fzv$6975bd71b2968f50d4b67768275bd887d6dd81bd0bef962713204dec791c1b49', '2022-08-13 17:41:18'),
(2, 'Freaky', 'Iwangumi', 'freaky@email.com', 'freakyfriday', 'pbkdf2:sha256:260000$AYFO54bQ7V55wxhU$6e9cbedeff6cab428ada9ef14c82a15459b1b4b08d8155602a80d4af4e36710d', '2022-08-19 14:28:52'),
(3, 'Damilola', 'Funkedele', 'damifunke@mail.com', 'damicray', 'pbkdf2:sha256:260000$qX4MNH6D4pRiblWo$430630f84c55e7edbd7870c0545066e4c017c5b32011a220fc083f5cdda5d1bd', '2022-08-20 07:51:12');

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
(2, 6),
(3, 6),
(1, 1),
(1, 3),
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
(5, 'FULL STACK DEVELOPERS (PHP)', 'Full Stack Developers that use PHP.', 'public'),
(6, 'The Big Thinkers API Group', 'Group that specializes in using Python to create RESTFUL APIs', 'public');

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
(4, 6),
(6, 4),
(6, 6);

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
-- Table structure for table `liker`
--

CREATE TABLE `liker` (
  `liker_id` int(11) NOT NULL,
  `com_id` int(11) DEFAULT NULL,
  `dev_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `liker`
--

INSERT INTO `liker` (`liker_id`, `com_id`, `dev_id`) VALUES
(1, 3, 1),
(2, 4, 1),
(3, 4, 2),
(4, 4, 3);

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
  `task_availability` enum('available','unavailable') DEFAULT NULL,
  `status` enum('joined','left') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`mem_id`, `grp_id`, `dev_id`, `admin`, `join_date`, `task_availability`, `status`) VALUES
(7, 2, 1, 'no', '2022-08-16 09:50:56', 'available', 'joined'),
(9, 2, 2, 'no', '2022-08-19 14:41:12', 'available', 'joined'),
(10, 2, 3, 'no', '2022-08-20 07:53:57', 'available', 'joined'),
(11, 6, 1, 'yes', '2022-08-21 23:04:34', 'available', 'joined'),
(17, 5, 1, 'no', '2022-08-22 19:54:23', 'available', 'joined'),
(18, 4, 1, 'no', '2022-08-22 22:36:22', 'available', 'left');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender` int(11) DEFAULT NULL,
  `corres_id` int(11) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date_sent` datetime NOT NULL,
  `status` enum('new','read') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`message_id`, `sender`, `corres_id`, `message`, `date_sent`, `status`) VALUES
(2, 1, 1, 'I would like to meet you one day Mr Friday.', '2022-08-21 12:49:28', 'read'),
(3, 1, 1, 'It would be the best day of my life sir.', '2022-08-21 12:51:31', 'read'),
(4, 1, 1, 'I will like to congratulate you sir on your successful job application.', '2022-08-21 13:20:28', 'read'),
(5, 1, 1, 'It will be an honour if you could mentor me in the ways of programming.', '2022-08-21 13:21:57', 'read'),
(6, 1, 1, 'Why are you ignoring me sir? Is it because you do not like the way I look? I look perfectly okay sir. It is just that I have the bearing of a king and a king does not care about what others think. \r\n', '2022-08-21 13:31:51', 'read'),
(7, 1, 1, 'Take me on as a mentee sir, you will not regret it at all.', '2022-08-21 13:32:18', 'read'),
(8, 2, 1, 'I am not available to train you young donkayode. I am extremely busy acclimating to my new work and I cannot take you on. I am very sorry.', '2022-08-21 14:17:33', 'read'),
(9, 1, 1, 'I do not mind if you are not available sir, I am perfectly willing to work with your schedule.', '2022-08-21 14:56:56', 'read'),
(10, 3, 2, 'Hi donkayode, I do not thing this project is reasonable and going through the entire contention process is a hassle. Can we please discuss how we can work together for a better and more suitable task?', '2022-08-24 20:34:50', 'read'),
(11, 1, 2, 'Hello damicray. What do you mean by a better and more suitable task? This task I have given you is perfectly normal.', '2022-08-24 20:35:31', 'new');

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
  `post` text NOT NULL,
  `title` varchar(255) NOT NULL,
  `date_posted` datetime NOT NULL,
  `date_edited` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`post_id`, `grp_id`, `mem_id`, `post`, `title`, `date_posted`, `date_edited`) VALUES
(1, 5, 17, 'I am a boy', 'My Gender', '2022-08-17 14:38:31', '2022-08-22 19:54:21'),
(2, 5, 17, 'I like to frolick around during the apocalype', 'What I like to do', '2022-08-17 14:39:31', '2022-08-22 19:54:21'),
(3, 5, 17, 'I like to murder people in their sleep all in the name of love.', 'The things I do for love', '2022-08-17 15:17:10', '2022-08-22 19:54:21'),
(4, 5, 17, 'The world is created on the backs of the devil that was created due to the influence of the magomago.', 'The Truth of the World', '2022-08-17 15:31:10', '2022-08-22 19:54:21'),
(5, 5, 17, 'Kings are honourable and they do the things that need to be done at times.', 'The Way of Kings', '2022-08-17 15:32:16', '2022-08-22 19:54:21'),
(6, 2, 7, 'The growth of the python snake depends on the versatility of the grower to understand the concepts that guide the mighty python.', 'Snake Growth', '2022-08-17 19:45:09', '0000-00-00 00:00:00'),
(7, 2, 7, 'In order to ensure the supremacy of the snake race, we can use the snake assassins to slither into the homes of non-snake developers and murder them.', 'Snake Assassins', '2022-08-17 19:46:36', '0000-00-00 00:00:00'),
(8, 5, 17, 'What exactly are the snakes doing? They have been invading the world for a time now and seem to have no intention on stopping.', 'Snake Invasion', '2022-08-17 19:49:17', '2022-08-22 19:54:21');

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
(5, 5, 'You cannot divide your PHP project into pure frontend and pure backend. The two must be combined.'),
(6, 6, 'You must use python with any framework'),
(7, 6, 'You must use MySQL for database interactions');

-- --------------------------------------------------------

--
-- Table structure for table `submitted_projects`
--

CREATE TABLE `submitted_projects` (
  `sub_id` int(11) NOT NULL,
  `task_id` int(11) DEFAULT NULL,
  `github` varchar(255) NOT NULL,
  `url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `submitted_projects`
--

INSERT INTO `submitted_projects` (`sub_id`, `task_id`, `github`, `url`) VALUES
(1, 1, 'github.com/freakyfriday/movement_tracker', ''),
(5, 3, 'https://github.com/damicray/make_a_human', '');

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `task` (
  `task_id` int(11) NOT NULL,
  `grp_id` int(11) NOT NULL,
  `from_mem` int(11) NOT NULL,
  `to_mem` int(11) NOT NULL,
  `task_title` varchar(255) NOT NULL,
  `task_desc` text NOT NULL,
  `deadline` date DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `status` enum('accepted','pending','expired','completed','contended','late','submitted','cancelled') DEFAULT NULL,
  `date_assigned` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`task_id`, `grp_id`, `from_mem`, `to_mem`, `task_title`, `task_desc`, `deadline`, `duration`, `status`, `date_assigned`) VALUES
(1, 2, 7, 9, 'Movement Tracker', 'Design an app that counts the number of steps you make per day using the blood flow of your body or something.', '2022-09-10', 21, 'completed', '2022-08-20'),
(2, 2, 10, 9, 'Life Saver', 'Design an app that will save the life of a boy whether he is big or small and regardless of the injury the boy has sustained.', NULL, 7, 'cancelled', '2022-08-20'),
(3, 2, 7, 10, 'Make a human being', 'Make a human being.', '2023-05-17', 270, 'completed', '2022-08-20'),
(4, 2, 7, 10, 'Faraway Motion Plot', 'An app that plots the trajectory of faraway birds and calculate where they are flying to.', NULL, 7, 'cancelled', '2022-08-24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alembic_version`
--
ALTER TABLE `alembic_version`
  ADD PRIMARY KEY (`version_num`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`com_id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `dev_id` (`dev_id`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`contact_id`);

--
-- Indexes for table `contention`
--
ALTER TABLE `contention`
  ADD PRIMARY KEY (`con_id`),
  ADD KEY `task_id` (`task_id`);

--
-- Indexes for table `con_votes`
--
ALTER TABLE `con_votes`
  ADD PRIMARY KEY (`vote_id`),
  ADD KEY `issue_id` (`issue_id`),
  ADD KEY `voter` (`voter`);

--
-- Indexes for table `correspondence`
--
ALTER TABLE `correspondence`
  ADD PRIMARY KEY (`cor_id`),
  ADD KEY `dev_a` (`dev_a`),
  ADD KEY `dev_b` (`dev_b`);

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
-- Indexes for table `liker`
--
ALTER TABLE `liker`
  ADD PRIMARY KEY (`liker_id`),
  ADD KEY `com_id` (`com_id`),
  ADD KEY `dev_id` (`dev_id`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`mem_id`),
  ADD KEY `grp_id` (`grp_id`),
  ADD KEY `dev_id` (`dev_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `corres_id` (`corres_id`),
  ADD KEY `sender` (`sender`);

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
-- Indexes for table `submitted_projects`
--
ALTER TABLE `submitted_projects`
  ADD PRIMARY KEY (`sub_id`),
  ADD KEY `task_id` (`task_id`);

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
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `com_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `contact_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `contention`
--
ALTER TABLE `contention`
  MODIFY `con_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `con_votes`
--
ALTER TABLE `con_votes`
  MODIFY `vote_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `correspondence`
--
ALTER TABLE `correspondence`
  MODIFY `cor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `developer`
--
ALTER TABLE `developer`
  MODIFY `dev_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `fine`
--
ALTER TABLE `fine`
  MODIFY `fine_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `group`
--
ALTER TABLE `group`
  MODIFY `grp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `language`
--
ALTER TABLE `language`
  MODIFY `lang_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `liker`
--
ALTER TABLE `liker`
  MODIFY `liker_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `mem_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `pay_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `rule`
--
ALTER TABLE `rule`
  MODIFY `rule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `submitted_projects`
--
ALTER TABLE `submitted_projects`
  MODIFY `sub_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `task`
  MODIFY `task_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`),
  ADD CONSTRAINT `comment_ibfk_3` FOREIGN KEY (`dev_id`) REFERENCES `developer` (`dev_id`);

--
-- Constraints for table `contention`
--
ALTER TABLE `contention`
  ADD CONSTRAINT `contention_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `task` (`task_id`);

--
-- Constraints for table `con_votes`
--
ALTER TABLE `con_votes`
  ADD CONSTRAINT `con_votes_ibfk_1` FOREIGN KEY (`issue_id`) REFERENCES `contention` (`con_id`),
  ADD CONSTRAINT `con_votes_ibfk_2` FOREIGN KEY (`voter`) REFERENCES `member` (`mem_id`);

--
-- Constraints for table `correspondence`
--
ALTER TABLE `correspondence`
  ADD CONSTRAINT `correspondence_ibfk_1` FOREIGN KEY (`dev_a`) REFERENCES `developer` (`dev_id`),
  ADD CONSTRAINT `correspondence_ibfk_2` FOREIGN KEY (`dev_b`) REFERENCES `developer` (`dev_id`);

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
-- Constraints for table `liker`
--
ALTER TABLE `liker`
  ADD CONSTRAINT `liker_ibfk_1` FOREIGN KEY (`com_id`) REFERENCES `comment` (`com_id`),
  ADD CONSTRAINT `liker_ibfk_2` FOREIGN KEY (`dev_id`) REFERENCES `developer` (`dev_id`);

--
-- Constraints for table `member`
--
ALTER TABLE `member`
  ADD CONSTRAINT `member_ibfk_1` FOREIGN KEY (`grp_id`) REFERENCES `group` (`grp_id`),
  ADD CONSTRAINT `member_ibfk_2` FOREIGN KEY (`dev_id`) REFERENCES `developer` (`dev_id`);

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`corres_id`) REFERENCES `correspondence` (`cor_id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`sender`) REFERENCES `developer` (`dev_id`);

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
-- Constraints for table `submitted_projects`
--
ALTER TABLE `submitted_projects`
  ADD CONSTRAINT `submitted_projects_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `task` (`task_id`);

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

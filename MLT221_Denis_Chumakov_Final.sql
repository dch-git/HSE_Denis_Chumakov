CREATE DATABASE IF NOT EXISTS `Edu_DB`;
USE `Edu_DB`;



-- Table structure for table `Students`

DROP TABLE IF EXISTS `Students`;
CREATE TABLE `Students` (
	`Student_ID` INT PRIMARY KEY AUTO_INCREMENT,
	`Student_First_Name` VARCHAR(50) NOT NULL,
	`Student_Surname` VARCHAR(50) NOT NULL,
	`Student_Last_Name` VARCHAR(50),
	`Student_Birth_Date` DATE,
	`Student_Email` VARCHAR(50),
	`Student_Phone_Num` VARCHAR(20),
	`Student_Mobile_Num` VARCHAR(20),
    `Student_Group_ID` int DEFAULT NULL,
	PRIMARY KEY (`Student_ID`),
	UNIQUE KEY `UNIQ_Student` (`Student_Email`)
	KEY `Student_Group_ID` (`Student_Group_ID`),
);



-- Table structure for table `Student_Group`

DROP TABLE IF EXISTS `Student_Group`;
CREATE TABLE `Student_Group` (
	`Student_Group_ID` int NOT NULL AUTO_INCREMENT,
	`Student_Group_Name` int NOT NULL,
	`Student_Group_First_Year` year NOT NULL,
	`Student_Group_Course` enum('1','2','3','4','5') NOT NULL,
    PRIMARY KEY (`Student_Group_ID`),
    UNIQUE KEY `UNIQ_Student_Group` (`Student_Group_Name`, `Student_Group_First_Year`)
);



-- Table structure for table `Teachers`

DROP TABLE IF EXISTS `Teachers`;
CREATE TABLE `Teachers` (
	`Teacher_ID` INT PRIMARY KEY AUTO_INCREMENT,
	`Teacher_First_Name` VARCHAR(50) NOT NULL,
	`Teacher_Surname` VARCHAR(50) NOT NULL,
	`Teacher_Last_Name` VARCHAR(50),
	`Teacher_Birth_Date` DATE,
	`Teacher_Email` VARCHAR(50),
	`Teacher_Phone_Num` VARCHAR(20),
	`Teacher_Mobile_Num` VARCHAR(20),
	PRIMARY KEY (`Teacher_ID`),
    UNIQUE KEY `UNIQ_Teacher` (`Teacher_Email`)
);



-- Table structure for table `Course`

DROP TABLE IF EXISTS `Course`;
CREATE TABLE `Course` (
	`Course_ID` INT PRIMARY KEY AUTO_INCREMENT,
	`Course_Name` VARCHAR(255) NOT NULL,
    `Course_Year` year NOT NULL,
	description VARCHAR(15) CHECK (description IN ('Humanities', 'Mathematical'))
	UNIQUE KEY `UNIQ_Course` (`SubjectName`, `Course_Year`)
);



-- Table structure for table `Grades'

DROP TABLE IF EXISTS `Grades`;
CREATE TABLE `Grades` (
    `Grade_ID` INT PRIMARY KEY AUTO_INCREMENT,
    `Student_ID` INT,
    `Course_ID` INT,
    `Grade` INT CHECK (`Grade` BETWEEN 1 AND 5),
    `Grade_Date` DATE NOT NULL DEFAULT CURRENT_DATE(),
    FOREIGN KEY (`Student_ID`) REFERENCES `Students`(`Student_ID`),
    FOREIGN KEY (`Course_ID`) REFERENCES `Courses`(`Course_ID`),
    UNIQUE KEY `UNIQ_Grade` (`Student_ID`, `Course_ID`,  `Grade_Date`)
);
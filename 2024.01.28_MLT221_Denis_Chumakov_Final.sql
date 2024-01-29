-- База данных для учёта студентов, преподавателей, предметов и выставленных оценок в учебном заведении

CREATE DATABASE IF NOT EXISTS `Edu_DB`;
USE `Edu_DB`;



-- Таблицы

	-- Таблица `Students`
		-- Содержит основную информацию о студентах: ФИО, дата рождения, контактнные данные и т.д.
DROP TABLE IF EXISTS `Students`;
CREATE TABLE `Students` (
	`Student_ID` INT PRIMARY KEY AUTO_INCREMENT,
	`Student_First_Name` VARCHAR(255) NOT NULL,
	`Student_Surname` VARCHAR(255) NOT NULL,
	`Student_Last_Name` VARCHAR(255),
		-- Last Name без NOT NULL так как это необязательная часть ФИО как российских, так и зарубежных граждан
	`Student_Birth_Date` DATE,
	`Student_Email` VARCHAR(255),
	`Student_Phone_Num` VARCHAR(20),
	`Student_Mobile_Num` VARCHAR(20),
	`Student_Group_ID` int DEFAULT NULL,
	PRIMARY KEY (`Student_ID`),
	UNIQUE KEY `UNIQ_Student` (`Student_Email`)
);

	-- Таблица `Teachers`
		-- Содержит основную информацию о преподавателях: ФИО, дата рождения, контактнные данные и т.д.
DROP TABLE IF EXISTS `Teachers`;
CREATE TABLE `Teachers` (
	`Teacher_ID` INT PRIMARY KEY AUTO_INCREMENT,
	`Teacher_First_Name` VARCHAR(255) NOT NULL,
	`Teacher_Surname` VARCHAR(255) NOT NULL,
	`Teacher_Last_Name` VARCHAR(255),
		-- Last Name без NOT NULL так как это необязательная часть ФИО как российских, так и зарубежных граждан
	`Teacher_Birth_Date` DATE,
	`Teacher_Email` VARCHAR(255),
	`Teacher_Phone_Num` VARCHAR(20),
	`Teacher_Mobile_Num` VARCHAR(20),
	PRIMARY KEY (`Teacher_ID`),
    UNIQUE KEY `UNIQ_Teacher` (`Teacher_Email`)
);



	-- Таблица `Courses`
		-- Содержит основную информацию о курсах + деление на математические и гуманитарные
DROP TABLE IF EXISTS `Courses`;
CREATE TABLE `Courses` (
	`Course_ID` INT PRIMARY KEY AUTO_INCREMENT,
	`Course_Name` VARCHAR(255) NOT NULL,
    `Course_Year` YEAR NOT NULL,
	description VARCHAR(15) CHECK (description IN ('Humanities', 'Mathematical')),
	UNIQUE KEY `UNIQ_Course` (`Course_ID`)
);



	-- Таблица `Grades`
DROP TABLE IF EXISTS `Grades`;
CREATE TABLE `Grades` (
    `Grade_ID` INT PRIMARY KEY AUTO_INCREMENT,
    `Student_ID` INT,
    `Course_ID` INT,
    `Grade` INT CHECK (`Grade` BETWEEN 1 AND 5),
    `Grade_Date` DATE NOT NULL,
    UNIQUE KEY `UNIQ_Grade` (`Grade_ID`,`Student_ID`, `Course_ID`, `Grade_Date`)
);



	-- Таблица `List of keys`
		-- Таблица, собирающая значения всех остальных таблиц

DROP TABLE IF EXISTS `List of keys`;
CREATE TABLE  `List of keys`(
  id INT PRIMARY KEY,
  `Student_ID` INT,
  `Group_ID` INT,  
  `Course_ID` INT,
  `Teacher_ID` INT,
  `Grade_ID` INT,
  `Grade_Date` DATE
);


-- определение внешних ключей
ALTER TABLE `List of keys`
    ADD CONSTRAINT `Foreign_Key_Students` FOREIGN KEY (`Student_ID`) REFERENCES `Students`(`Student_ID`),
    ADD CONSTRAINT `Foreign_Key_Courses` FOREIGN KEY (`Course_ID`) REFERENCES `Courses`(`Course_ID`),
    ADD CONSTRAINT `Foreign_Key_Teachers` FOREIGN KEY (`Teacher_ID`) REFERENCES `Teachers`(`Teacher_ID`),
    ADD CONSTRAINT `Foreign_Key_Grades` FOREIGN KEY (`Grade_ID`) REFERENCES `Grades`(`Grade_ID`);



-- Запросы к базе данных

	-- возможность выводить список студентов по определённому предмету
  DELIMITER //

CREATE PROCEDURE `Query_Students_of_Course`(
    IN `Course_Name` VARCHAR(255)
)
BEGIN
    SELECT `Student_ID`
    FROM `Students` `S`
    INNER JOIN `List of keys` `Key` ON `S.Student_ID` = `Key.Student_ID`
    INNER JOIN `Courses` `C` ON `Key.Course_ID` = `C.Course_ID`
    WHERE `C.Course_ID` = `Course_Name`;
END //

DELIMITER ;  
    
    
    
	-- возможность выводить список предметов, которые преподает конкретный преподаватель
  DELIMITER //

CREATE PROCEDURE `Query_Courses_of_Teacher`(
    IN `Teacher_ID` INT
)
BEGIN
    SELECT `C.Course_ID`
    FROM `Courses` `C`
    INNER JOIN `List of keys` `Key` ON `C.Course_ID` = `Key.Course_ID`
    INNER JOIN `Teachers` `T` ON `Key.Teacher_ID` = `T.Teacher_ID`
    WHERE `T.Teacher_ID` = `Teacher_ID`;
END //

DELIMITER ;  
    
    
    
	-- возможность выводить средний балл студента по всем предметам
 DELIMITER //

CREATE PROCEDURE `Query_Student_AVG_Grade`(
    IN `Student_ID` INT
)
BEGIN
    SELECT AVG(`G.Grade`) AS `Average_Grade`
    FROM `Grades` `G`
    INNER JOIN `List of keys` `Key` ON `G.Grade_ID` = `Key.Grade_ID`
    WHERE `Key.Student_ID` = `Student_ID`;
END //

DELIMITER ;   
    
    
    
	-- возможность выводить рейтинг преподавателей по средней оценке студентов

DELIMITER //
CREATE PROCEDURE `Query_Teachers_Rating`()
BEGIN
    SELECT `T.Teacher_ID`, CONCAT(`Teacher_Surname`, ' ', `T.Teacher_Name`) AS `Фамилия, Имя`, AVG(`G.Grade`) AS `Средняя оценка`
    FROM `Teachers` `t`
    INNER JOIN `List of keys` `Key` ON `T.Teacher_ID` = `Key.Teacher_ID`
    INNER JOIN `Grades` `g` ON `Key.Grade_ID` = `G.Grade_ID`
    GROUP BY `T.Teacher_ID`, `Teacher_Surname`, `Teacher_Name`
    ORDER BY `Средняя оценка` DESC;
END //
DELIMITER ;   
    
    

	-- вставка записи о новом студенте с его личной информацией, такой как ФИО, дата рождения, контактные данные и др.
INSERT INTO `Students` (`Student_ID`, `Student_First_Name`, `Student_Surname`, `Student_Last_Name`, `Student_Birth_Date`, `Student_Email`, `Student_Phone_Num`, `Student_Mobile_Num`, `Student_Group_ID`)
VALUES ('ST000001','Ivan','Ivanovov','Ivanovich','2000-01-01','iii@sobaka.mail','84950110101','89110110101','GR000001');



	-- обновление контактной информации преподавателя, например, электронной почты или номера телефона, на основе его идентификационного номера или ФИО
INSERT INTO `Teachers` (`Teacher_ID`, `Teacher_First_Name`, `Teacher_Surname`, `Teacher_Surname`, `Teacher_Last_Name`, `Teacher_Birth_Date`, `Teacher_Email`, `Teacher_Phone_Num`, `Teacher_Mobile_Num`)
VALUES ('T000001', 'Vladimir', 'Chetvernin', 'Alexandrovich','1988-07-29', 'SVACH@hse.ru', '84959124385', '891601233981');
UPDATE `Teachers`
SET `Teacher_Surname` = 'VELICHAISHIY'
WHERE `Teacher_ID` = 'T000001';    

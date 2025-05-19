CREATE DATABASE IF NOT EXISTS `high_school_banking_system_webpage`
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE `high_school_banking_system_webpage`;

-- DROP DATABASE `high_school_banking_system_webpage`;
-- DROP DATABASE `school_management`;

-- 학교
CREATE TABLE IF NOT EXISTS`school` (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
    -- teacher_id VARCHAR(30) NOT NULL,
    school_name VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contact_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `school`; 
 
-- 교실
CREATE TABLE IF NOT EXISTS `classroom` (
    admin_id VARCHAR(30) PRIMARY KEY,
    class_number VARCHAR(10) NOT NULL,
    capacity VARCHAR(10) NOT NULL,
    is_available BOOLEAN NOT NULL,
    location VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `classroom`;

-- 학생 정보
CREATE TABLE IF NOT EXISTS `student` (
    student_id VARCHAR(30) PRIMARY KEY,
    school_id INT,
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    name VARCHAR(20) NOT NULL,
    student_grade VARCHAR(10) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    affiliation ENUM('liberal arts','natural sciences') NOT NULL,
    password VARCHAR(100) NOT NULL,
    status ENUM('enrolled','graduated') NOT NULL,
    year DATE NOT NULL,
    semester VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `student`;

-- 교사 정보
CREATE TABLE IF NOT EXISTS`teacher` (
    teacher_id VARCHAR(30) PRIMARY KEY,
    school_id INT,
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    name VARCHAR(10) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `teacher`;

-- 관리자 정보
CREATE TABLE IF NOT EXISTS `admin` (
	admin_id VARCHAR(30) PRIMARY KEY,
    school_id INT,
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    name VARCHAR(20) NOT NULL,
    email VARCHAR(30) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `admin`;

-- 관리자 로그인
CREATE TABLE IF NOT EXISTS `admin_login` (
	login_id VARCHAR(30) PRIMARY KEY,
    admin_id VARCHAR(30),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    password VARCHAR(100) NOT NULL,
    last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM `admin_login`;

-- 관리자 로그인 시도 기록
CREATE TABLE IF NOT EXISTS `admin_loginattempt`(
    admin_attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id VARCHAR(30),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    success BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `admin_loginattempt`;

-- 관리자 권한
CREATE TABLE IF NOT EXISTS `admin_subject` (
    PRIMARY KEY (admin_id, subject_id),
    admin_id VARCHAR(30) NOT NULL,
    subject_id VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `admin_subject`;

-- 과목
CREATE TABLE IF NOT EXISTS `subject` (
    subject_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
    student_id VARCHAR(30),
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    teacher_id VARCHAR(30) ,
    FOREIGN KEY(teacher_id) REFERENCES teacher(teacher_id),
	teacher_name VARCHAR(30) NOT NULL,
    subject_name VARCHAR(30) NOT NULL,
    grade VARCHAR(10) NOT NULL,
    semester VARCHAR(10) NOT NULL,
    category ENUM('completed','not_selected') NOT NULL,
    max_enrollment INT NOT NULL,
    affiliation ENUM('stem','non_stem') NOT NULL,
    time_schedule VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `subject`;

-- 수강 제한
CREATE TABLE IF NOT EXISTS `course_restriction` (
    restriction_id INT PRIMARY KEY AUTO_INCREMENT,
	admin_id VARCHAR(30),
    subject_id VARCHAR(30),
    FOREIGN KEY (admin_id) REFERENCES admin_login(admin_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    grade INT NOT NULL,
    is_duplicate_allowed BOOLEAN DEFAULT FALSE,
    max_enrollment INT NOT NULL,
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `course_restriction`;

-- 수강 관리
CREATE TABLE IF NOT EXISTS `course_registration` (
    registration_id INT PRIMARY KEY AUTO_INCREMENT, 
    student_id VARCHAR(30) NOT NULL,
    subject_id VARCHAR(30) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    semester VARCHAR(10) NOT NULL,
    year YEAR NOT NULL,
    registration_status ENUM('completed','not_selected') DEFAULT 'not_selected',
    approval_status ENUM('pending', 'approved', 'cancelled', 'rejected') DEFAULT 'pending',
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    application_round TINYINT DEFAULT ("first_round: 1, second_round: 2"),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `course_registration`;

-- 과거 수강 기록
CREATE TABLE IF NOT EXISTS `course_history` (
	PRIMARY KEY (student_id, semester, year),
    student_id VARCHAR(30),
	semester INT NOT NULL,
    year YEAR NOT NULL,
    subject_id VARCHAR(30),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    teacher_id VARCHAR(30) NOT NULL ,
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `course_history`;

-- 공지사항
CREATE TABLE IF NOT EXISTS `notice` (
    notice_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id VARCHAR(30),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(30) NOT NULL,
    targetAudience ENUM('all','student','teacher') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

SELECT * FROM `notice`;

-- 관리자 과목 생성
CREATE TABLE IF NOT EXISTS `admin_create` (
    admin_id VARCHAR(30) PRIMARY KEY,
    subject_id VARCHAR(30),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    school_id INT NOT NULL,
    teacher_name VARCHAR(10) NOT NULL,
    lecture_status ENUM('in_class','no_class') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `admin_create`;

-- 시간표
CREATE TABLE IF NOT EXISTS `schedule` (
	PRIMARY KEY (student_id, subject_name, day_of_week, period),
    -- FOREIGN KEY (student_id) REFERENCES student(student_id),
    student_id VARCHAR(30) NOT NULL,
    subject_id VARCHAR(30) NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL,
    period INT NOT NULL,
    classroom VARCHAR(20) DEFAULT 'TBD', -- To Be Determined
    teacher_id VARCHAR(30),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

SELECT * FROM `schedule`;

-- 강의 정보
CREATE TABLE IF NOT EXISTS `lecture` (
    lecture_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id VARCHAR(30) NOT NULL,
    teacher_id VARCHAR(30) NOT NULL,
    classroom VARCHAR(30) NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL,
    period INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);
-- admin_id VARCHAR(30) NOT NULL,
-- FOREIGN KEY (admin_id) REFERENCES admin(admin_id)


SELECT * FROM `lecture`;

-- 학생 회원가입
CREATE TABLE IF NOT EXISTS `student_register` (
    student_id VARCHAR(30) PRIMARY KEY,
    school_id INT,
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    name VARCHAR(20) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `student_register`;

-- 학생 정보 수정 이력
CREATE TABLE IF NOT EXISTS `student_history` (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES student_register(student_id),
    change_type ENUM('created','updated','deleted') NOT NULL,
    name VARCHAR(20),
    phone_number VARCHAR(20),
    birth_date DATE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `student_history`;

-- 학생 로그인
CREATE TABLE IF NOT EXISTS `student_login` (
    student_login_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    password VARCHAR(100) NOT NULL
);

SELECT * FROM `student_login`;

-- 학생 로그인 시도 기록
CREATE TABLE IF NOT EXISTS `student_loginattempt` (
    student_attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (student_id) REFERENCES student_login(student_id),
    student_id VARCHAR(30),
    success BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `student_loginattempt`;
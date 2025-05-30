CREATE DATABASE IF NOT EXISTS `high_school_banking_system_webpage`
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE `high_school_banking_system_webpage`;

-- 학교 승인 대기 테이블
CREATE TABLE IF NOT EXISTS `school_application` (
    school_application_id BIGINT PRIMARY KEY AUTO_INCREMENT,
	school_application_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    school_name VARCHAR(30) NOT NULL,
    school_address VARCHAR(255) NOT NULL,
    school_contact_number VARCHAR(20) NOT NULL,
    school_admin_name VARCHAR(30) NOT NULL,
    school_admin_phone_number VARCHAR(20) NOT NULL,
    school_admin_email VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 학교
CREATE TABLE IF NOT EXISTS `school` (
	school_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    school_name VARCHAR(30) NOT NULL,
    school_address VARCHAR(255) NOT NULL,
    school_contact_number VARCHAR(20) NOT NULL,
    school_password VARCHAR(255) NOT NULL,
    school_admin_name VARCHAR(30) NOT NULL,
    school_admin_phone_number VARCHAR(20) NOT NULL,
    school_admin_email VARCHAR(30) NOT NULL,
    application_started_day DATE NOT NULL,
    application_limited_day DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 교사 (로그인 포함)
CREATE TABLE IF NOT EXISTS `teacher` (
    teacher_id VARCHAR(30) PRIMARY KEY,
    school_id BIGINT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(30) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- 학생 (로그인 포함)
CREATE TABLE IF NOT EXISTS `student` (
    student_id VARCHAR(30) PRIMARY KEY,
    school_id BIGINT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    student_number VARCHAR(30) UNIQUE NOT NULL,
    name VARCHAR(20) NOT NULL,
    grade VARCHAR(10) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    affiliation ENUM('liberal_arts', 'natural_sciences') NOT NULL,
    status ENUM('enrolled', 'not_enrolled', 'graduated') DEFAULT 'enrolled',
    admission_year YEAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- 과목: 강의 개설용 정보 (수업 개요)
CREATE TABLE IF NOT EXISTS `subject` (
    subject_id VARCHAR(30) PRIMARY KEY,
    school_id BIGINT NOT NULL,
    subject_name VARCHAR(50) NOT NULL,
    grade VARCHAR(10) NOT NULL,
    semester VARCHAR(10) NOT NULL,
    affiliation ENUM('liberal_arts', 'natural_sciences') NOT NULL,
    category ENUM('completed', 'not_selected') NOT NULL,
    max_enrollment INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- 강의: 시간표 포함, 과목 실제 운영
CREATE TABLE IF NOT EXISTS `lecture` (
    lecture_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    school_id BIGINT NOT NULL,
    subject_id VARCHAR(30) NOT NULL,
    teacher_id VARCHAR(30) NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL,
    period INT NOT NULL,
	allowed_grade VARCHAR(10) NOT NULL,
    max_enrollment INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id),
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- 수강 신청
CREATE TABLE IF NOT EXISTS `course_registration` (
    registration_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(30) NOT NULL,
    lecture_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    semester VARCHAR(10) NOT NULL,
    approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (lecture_id) REFERENCES lecture(lecture_id)
);

-- 수강 이력
CREATE TABLE IF NOT EXISTS `course_history` (
    course_history_id INT PRIMARY KEY,
    student_id VARCHAR(30),
    lecture_id INT,
    academic_year YEAR NOT NULL,
    semester VARCHAR(10) NOT NULL,
    score VARCHAR(10) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (lecture_id) REFERENCES lecture(lecture_id)
);

-- 공지사항
CREATE TABLE IF NOT EXISTS `notice` (
    notice_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    school_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    target_audience ENUM('all', 'student', 'teacher') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
);
CREATE DATABASE IF NOT EXISTS `high_school_banking_system_webpage`
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE `high_school_banking_system_webpage`;

-- 학교 승인 대기 테이블
CREATE TABLE IF NOT EXISTS `school_application` (
    school_application_id INT PRIMARY KEY AUTO_INCREMENT,
    school_name VARCHAR(30) NOT NULL,
    school_address VARCHAR(255) NOT NULL,
    school_contact_number VARCHAR(20) NOT NULL,
    # 당당자명(학교 관리자명)
    # 당당자 연락처(학교 관리자 연락처)
    # 담당자 이메일 >> 학교 코드 전송
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP # 신청 날짜 명시
    # 상태 저장(대기, 승인, 미승인-거절)
);

-- 학교
CREATE TABLE IF NOT EXISTS `school` (
	school_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    school_name VARCHAR(30) NOT NULL,
    school_address VARCHAR(255) NOT NULL,
    school_contact_number VARCHAR(20) NOT NULL,
    school_code VARCHAR(100) PRIMARY KEY, -- 자동 발급 (담당자 이메일로 전송) 
    password VARCHAR(255) NOT NULL, -- 임시 비밀번호 발급 / 비밀번호 재설정
    # 당당자명(학교 관리자명)
    # 당당자 연락처(학교 관리자 연락처)
    # 담당자 이메일 >> 학교 코드 전송
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 교사 (로그인 포함)
CREATE TABLE IF NOT EXISTS `teacher` (
    teacher_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
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
    school_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    student_number VARCHAR(30) UNIQUE NOT NULL,
    name VARCHAR(20) NOT NULL,
    grade VARCHAR(10) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    affiliation ENUM('liberal_arts', 'natural_sciences') NOT NULL,
    status ENUM('enrolled', 'graduated') NOT NULL, -- 기본값 enrolled
    admission_year YEAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (school_id) REFERENCES school(school_id)
    
    # 상태 (미승인, 승인, 졸업)
);

-- 과목: 강의 개설용 정보 (수업 개요)
CREATE TABLE IF NOT EXISTS `subject` (
    subject_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL,
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

-- 교실
CREATE TABLE IF NOT EXISTS `classroom` (
    classroom_id INT PRIMARY KEY AUTO_INCREMENT,
    class_number VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    location VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 강의: 시간표 포함, 과목 실제 운영
CREATE TABLE IF NOT EXISTS `lecture` (
    lecture_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id VARCHAR(30) NOT NULL,
    teacher_id VARCHAR(30) NOT NULL,
    admin_id VARCHAR(30) NOT NULL,
    classroom_id INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL,
    period INT NOT NULL, -- 1~8교시
	allowed_grade VARCHAR(10) NOT NULL,
    max_enrollment INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id),
    FOREIGN KEY (classroom_id) REFERENCES classroom(classroom_id)
);

-- 수강 신청
CREATE TABLE IF NOT EXISTS `course_registration` (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(30) NOT NULL,
    lecture_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    semester VARCHAR(10) NOT NULL,
    registration_status ENUM('registered','cancelled') DEFAULT 'registered',
    approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (lecture_id) REFERENCES lecture(lecture_id)
);

-- 수강 이력
CREATE TABLE IF NOT EXISTS `course_history` (
    student_id VARCHAR(30),
    lecture_id INT,
    academic_year YEAR NOT NULL,
    semester VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, lecture_id, academic_year, semester),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (lecture_id) REFERENCES lecture(lecture_id)
);

-- 시간표
CREATE TABLE IF NOT EXISTS `schedule` (
    student_id VARCHAR(30),
    lecture_id INT,
    PRIMARY KEY (student_id, lecture_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (lecture_id) REFERENCES lecture(lecture_id)
);

-- 공지사항
CREATE TABLE IF NOT EXISTS `notice` (
    notice_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id VARCHAR(30) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    target_audience ENUM('all', 'student', 'teacher') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);
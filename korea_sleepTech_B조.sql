-- korea_sleepTech_B조 

CREATE DATABASE `school_management`;
USE `school_management`;

-- 관리자 정보
CREATE TABLE `Admin` (
    admin_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL
);

SELECT * FROM `Admin`;

-- 관리자 로그인
CREATE TABLE `Admin_Login` (
    admin_id VARCHAR(30) PRIMARY KEY,
    password VARCHAR(100) NOT NULL
);

SELECT * FROM `Admin_Login`;

-- 관리자 로그인 기록
CREATE TABLE `Admin_Loginattempt` (
    admin_attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (admin_id) REFERENCES Admin_Login(admin_id),
    admin_id VARCHAR(30),
    success BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `Admin_Loginattempt`;

-- 관리자 권한
CREATE TABLE `Admin_subject` (
    PRIMARY KEY (admin_id, subject_id),
    admin_id VARCHAR(30),
    subject_id VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `Admin_subject`;

-- 관리자 과목 생성
CREATE TABLE `Admin_Create` (
    admin_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    subject_id VARCHAR(30),
    school_id INT NOT NULL,
    teacher_name VARCHAR(10) NOT NULL,
    lecture_status ENUM('수업 중','공강') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `Admin_Create`;

-- 학생 로그인
CREATE TABLE `Student_Login` (
    student_id VARCHAR(30) PRIMARY KEY,
    password VARCHAR(100) NOT NULL
);

SELECT * FROM `Student_Login`;

-- 학생 정보
CREATE TABLE `Student` (
    student_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (school_id) REFERENCES School(school_id),
    school_id INT,
    name VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    status ENUM('재학','졸업') NOT NULL,
    student_grade VARCHAR(10) NOT NULL
);

SELECT * FROM `Student`;

-- 학생 로그인 시도 기록
CREATE TABLE `Student_Loginattempt` (
    student_attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (student_id) REFERENCES Student_Login(student_id),
    student_id VARCHAR(30),
    success BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `Student_Loginattempt`;

-- 학생 회원가입
CREATE TABLE `Student_Register` (
    student_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (school_id) REFERENCES School(school_id),
    school_id INT,
    name VARCHAR(20) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `Student_Register`;

-- 학생 정보 수정 이력
CREATE TABLE `Student_History` (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (student_id) REFERENCES Student_Register(student_id),
    student_id VARCHAR(30),
    change_type ENUM('등록','수정','삭제') NOT NULL,
    name VARCHAR(20),
    phone_number VARCHAR(20),
    birth_date DATE,
    password VARCHAR(100),
    email VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM `Student_History`;

-- 학교
CREATE TABLE `School` (
    school_id INT PRIMARY KEY,
    teacher_id VARCHAR(30),
    school_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `School`;

-- 과목
CREATE TABLE `Subject` (
    subject_id VARCHAR(30) PRIMARY KEY,
	FOREIGN KEY (school_id) REFERENCES School(school_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    school_id INT,
    student_id VARCHAR(30),
    subject_name VARCHAR(30) NOT NULL,
    grade VARCHAR(10) NOT NULL,
    semester VARCHAR(10) NOT NULL,
    category ENUM('수강완료','수강 미선택') NOT NULL,
    max_enrollment VARCHAR(10) DEFAULT '30명',
    affiliation ENUM('이과','문과') NOT NULL,
    teacher_name VARCHAR(30) NOT NULL,
    time_schedule VARCHAR(30) NOT NULL
);

SELECT * FROM `Subject`;

-- 수강 제한
CREATE TABLE `Course_Restriction` (
    restriction_id INT PRIMARY KEY AUTO_INCREMENT,
	FOREIGN KEY (admin_id) REFERENCES Admin_Login(admin_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    admin_id VARCHAR(30),
    subject_id VARCHAR(30),
    Grade INT NOT NULL,
    isDuplicateAllowed BOOLEAN DEFAULT FALSE,
    max_enrollment VARCHAR(10) DEFAULT '30명',
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `Course_Restriction`;

-- 수강 관리
CREATE TABLE `Course_Registration` (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
	FOREIGN KEY (admin_id) REFERENCES Admin(admin_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    admin_id VARCHAR(30),
    subject_id VARCHAR(30),
    student_id VARCHAR(30) NOT NULL,
    semester VARCHAR(10) NOT NULL,
    year YEAR NOT NULL,
    registration_status ENUM('수강완료','수강 미선택') DEFAULT '수강 미선택',
    approval_status ENUM('대기','승인','취소','마감') DEFAULT '대기',
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `Course_Registration`;

-- 시간표
CREATE TABLE `Schedule` (
	PRIMARY KEY (student_id, subject_name, day_of_week, period),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    period INT,
    student_id VARCHAR(30),
    subject_name VARCHAR(20),
    day_of_week ENUM('월요일','화요일','수요일','목요일','금요일') NOT NULL,
    classroom VARCHAR(20) DEFAULT '미정',
    teacher VARCHAR(30) NOT NULL
);

SELECT * FROM `Schedule`;

-- 교실
CREATE TABLE `Classroom` (
    admin_id VARCHAR(30) PRIMARY KEY,
    classNumber VARCHAR(10) NOT NULL,
    capacity VARCHAR(10) NOT NULL,
    isAvailable BOOLEAN NOT NULL,
    location VARCHAR(50) NOT NULL
);

SELECT * FROM `Classroom`;

-- 공지사항
CREATE TABLE `Notice` (
    notice_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id VARCHAR(30),
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(30) NOT NULL,
    targetAudience ENUM('전체','학생','교사') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

SELECT * FROM `Notice`;

-- 과거 수강 기록
CREATE TABLE `CourseHistory` (
	PRIMARY KEY (student_id, subject_id, semester),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    student_id VARCHAR(30),
    subject_id INT,
    semester INT NOT NULL,
    year YEAR NOT NULL,
    teacherName VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `CourseHistory`;
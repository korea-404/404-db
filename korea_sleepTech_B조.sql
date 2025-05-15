--  korea_sleepTech_B조

CREATE DATABASE IF NOT EXISTS `school_management`;
USE `school_management`;
DROP DATABASE `korea_sleepTech_B조`;

-- 관리자 정보
CREATE TABLE IF NOT EXISTS `admin` (
    admin_id VARCHAR(30) PRIMARY KEY,
    school_id INT NOT NULL
);

ALTER TABLE `admin` DROP COLUMN school_id; -- 컬럼 삭제
ALTER TABLE `admin` ADD COLUMN school_id INT NOT NULL; -- 컬럼 추가

ALTER TABLE `admin` ADD CONSTRAINT FOREIGN KEY (school_id) REFERENCES school(school_id); -- 컬럼 추가한거 외래키 지정
ALTER TABLE `admin` ADD name VARCHAR(20) NOT NULL; -- 컬럼 추가
ALTER TABLE `admin` ADD email VARCHAR(30) NOT NULL; -- 컬럼 추가
ALTER TABLE `admin` ADD phone_number VARCHAR(20) NOT NULL; -- 컬럼 추가
ALTER TABLE `admin` ADD created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP; -- 컬럼 추가
ALTER TABLE `admin` ADD updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP; -- 컬럼 추가


SHOW CREATE TABLE `admin`; -- 외래키 지정 후 적용 되었는지 확인(테이블 구조 확인)

SELECT * FROM `admin`; -- 값 확인

-- 관리자 로그인
CREATE TABLE IF NOT EXISTS `admin_login` (
    admin_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (admin_id) REFERENCES admin (admin_id),
    password VARCHAR(100) NOT NULL
);

ALTER TABLE `admin_login` ADD last_login TIMESTAMP;

SELECT * FROM `admin_login`;

-- 관리자 로그인 기록
CREATE TABLE `admin_loginattempt`(
    admin_attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (admin_id) REFERENCES admin_login(admin_id),
    admin_id VARCHAR(30),
    success BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `admin_loginattempt`; 

-- 관리자 권한
CREATE TABLE `admin_subject` (
    PRIMARY KEY (admin_id, subject_id),
    admin_id VARCHAR(30),
    subject_id VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `admin_subject`;

-- 학생 로그인
CREATE TABLE `student_login` (
    student_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    password VARCHAR(100) NOT NULL
);

ALTER TABLE `student_login` ADD last_login TIMESTAMP;

SHOW CREATE TABLE `student_login`;

SELECT * FROM `student_login`;

-- 학생 로그인 시도 기록
CREATE TABLE `student_loginattempt` (
    student_attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (student_id) REFERENCES student_login(student_id),
    student_id VARCHAR(30),
    success BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `student_loginattempt`;

-- 학교
CREATE TABLE `school` (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id VARCHAR(30),
    school_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE `school` DROP COLUMN teacher_id;

SHOW CREATE TABLE `school`;

ALTER TABLE `school` ADD contact_number VARCHAR(20);
ALTER TABLE `school` ADD address VARCHAR(100) NOT NULL;

SELECT * FROM `school`;

-- 교실
CREATE TABLE `classroom` (
    admin_id VARCHAR(30) PRIMARY KEY,
    class_number VARCHAR(10) NOT NULL,
    capacity VARCHAR(10) NOT NULL,
    is_available BOOLEAN NOT NULL,
    location VARCHAR(50) NOT NULL
);

ALTER TABLE `classroom` RENAME COLUMN admin_id TO classroom_id; -- 컬럼명 변경
ALTER TABLE `classroom` ADD created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `classroom` ADD updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

SELECT * FROM `classroom`;

-- 공지사항
CREATE TABLE `notice` (
    notice_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id VARCHAR(30) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(30) NOT NULL,
    targetAudience ENUM('전체','학생','교사') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

ALTER TABLE `notice` DROP COLUMN admin_id; -- 컬럼 삭제

ALTER TABLE `notice` ADD admin_id VARCHAR(30) NOT NULL; -- 다시 생성
ALTER TABLE `notice` ADD CONSTRAINT FOREIGN KEY (admin_id) REFERENCES admin(admin_id); -- 외래키로 지정

SHOW CREATE TABLE `notice`;
SELECT * FROM `notice`;

-- 학생 정보
CREATE TABLE `student` (
    student_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    school_id INT,
    name VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    status ENUM('재학','졸업') NOT NULL,
    student_grade VARCHAR(10) NOT NULL
);

ALTER TABLE `student` ADD grade VARCHAR(10) NOT NULL;
ALTER TABLE `student` ADD email VARCHAR(50) UNIQUE NOT NULL;
ALTER TABLE `student` ADD phone_number VARCHAR(20) NOT NULL;
SELECT * FROM `student`;

-- 과목
CREATE TABLE `subject` (
    subject_id VARCHAR(30) PRIMARY KEY,
	FOREIGN KEY (school_id) REFERENCES school(school_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
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

ALTER TABLE`subject` ADD teacher_id VARCHAR(30) NOT NULL;
ALTER TABLE `subject` ADD created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `subject` ADD updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

SELECT * FROM `subject`;

-- 관리자 과목 생성
CREATE TABLE `admin_create` (
    admin_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    subject_id VARCHAR(30),
    school_id INT NOT NULL,
    teacher_name VARCHAR(10) NOT NULL,
    lecture_status ENUM('수업 중','공강') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `admin_create`;

-- 학생 회원가입
CREATE TABLE `student_register` (
    student_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (school_id) REFERENCES school(school_id),
    school_id INT,
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
CREATE TABLE `student_history` (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (student_id) REFERENCES student_register(student_id),
    student_id VARCHAR(30),
    change_type ENUM('등록','수정','삭제') NOT NULL,
    name VARCHAR(20),
    phone_number VARCHAR(20),
    birth_date DATE,
    password VARCHAR(100),
    email VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM `student_history`;

-- 수강 제한
CREATE TABLE `course_restriction` (
    restriction_id INT PRIMARY KEY AUTO_INCREMENT,
	FOREIGN KEY (admin_id) REFERENCES admin_login(admin_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    admin_id VARCHAR(30),
    subject_id VARCHAR(30),
    grade INT NOT NULL,
    is_duplicate_allowed BOOLEAN DEFAULT FALSE,
    max_enrollment VARCHAR(10) DEFAULT '30명',
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `course_restriction`;

-- 수강 관리
CREATE TABLE `course_registration` (
    registration_id INT PRIMARY KEY AUTO_INCREMENT, 
	FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
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

DROP TABLE `course_registration`; -- 테이블 삭제

ALTER TABLE`course_registration` DROP COLUMN admin_id;

SELECT * FROM `course_registration`;

-- 시간표
CREATE TABLE `schedule` (
	PRIMARY KEY (student_id, subject_name, day_of_week, period),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    period INT,
    student_id VARCHAR(30),
    subject_name VARCHAR(20),
    day_of_week ENUM('월요일','화요일','수요일','목요일','금요일') NOT NULL,
    classroom VARCHAR(20) DEFAULT '미정',
    teacher VARCHAR(30) NOT NULL
);

SELECT * FROM `schedule`;

-- 과거 수강 기록
CREATE TABLE `course_history` (
	PRIMARY KEY (student_id, subject_id, semester),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    student_id VARCHAR(30),
    subject_id VARCHAR(30),
    semester INT NOT NULL,
    year YEAR NOT NULL,
    teacher_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `course_history`;

-- 교사 정보
CREATE TABLE `teacher` (
    teacher_id VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY (school_id) REFERENCES School(school_id),
    school_id INT NOT NULL,
    name VARCHAR(10) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    subject VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM `teacher`;

-- 강의 정보
CREATE TABLE `lecture` (
    lecture_id INT PRIMARY KEY AUTO_INCREMENT,
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id),
    FOREIGN KEY (classroom_id) REFERENCES classroom(classroom_id),
    subject_id VARCHAR(30) NOT NULL,
    teacher_id VARCHAR(30) NOT NULL,
    classroom_id VARCHAR(30) NOT NULL,
    day_of_week ENUM('월요일', '화요일', '수요일', '목요일', '금요일') NOT NULL,
    period INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );


SHOW CREATE TABLE `lecture`;

SELECT * FROM `lecture`;

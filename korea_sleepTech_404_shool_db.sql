-- 1. 데이터베이스 생성 및 선택
CREATE DATABASE IF NOT EXISTS high_school_system;
USE high_school_system;

-- 2. 학교 테이블 생성
CREATE TABLE IF NOT EXISTS `school` (
    school_id INT PRIMARY KEY,
    school_name VARCHAR(30) NOT NULL,
    school_address VARCHAR(255) NOT NULL,
    contact_number VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. 데이터 삽입
INSERT INTO `school` (school_id, school_name, school_address, contact_number)
VALUES
(26001, '부산미래고등학교', '부산광역시 해운대구 미래로 101', '051-1111-0001'),
(26002, '부산창조고등학교', '부산광역시 남구 창조길 202', '051-1111-0002'),
(26003, '부산이노베이션고등학교', '부산광역시 연제구 혁신대로 303', '051-1111-0003'),
(26004, '부산스마트고등학교', '부산광역시 수영구 스마트로 404', '051-1111-0004'),
(26005, '부산미디어고등학교', '부산광역시 금정구 미디어길 505', '051-1111-0005');

-- 4. 확인용 조회
SELECT * FROM school;

-- 1. 데이터베이스 초기화 (기존 DB 삭제 후 재생성)
DROP DATABASE IF EXISTS dictionary;
CREATE DATABASE dictionary DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE dictionary;

-- =============================================
-- [1] 회원 및 포인트 관련 테이블
-- =============================================

-- 1. 회원 테이블 (jdi_login)
CREATE TABLE jdi_login (
    jdi_user    VARCHAR(50) PRIMARY KEY, -- 아이디
    jdi_pw      VARCHAR(100) NOT NULL,   -- 비밀번호
    jdi_name    VARCHAR(50) NOT NULL,    -- 닉네임
    jdi_role    VARCHAR(20) DEFAULT 'USER', -- 권한 (USER, ADMIN)
    jdi_theme   VARCHAR(50) DEFAULT 'default', -- 현재 적용 테마
    jdi_profile VARCHAR(200) DEFAULT 'profile1.png', -- 프로필 이미지 경로
    reg_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 포인트 로그 테이블 (jdi_point_log)
CREATE TABLE jdi_point_log (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    jdi_user    VARCHAR(50) NOT NULL,
    amount      INT NOT NULL, -- 획득(+)/사용(-) 포인트
    reason      VARCHAR(100), -- 사유
    log_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (jdi_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);

-- 3. 프로필 변경 신청 테이블 (profile_request)
CREATE TABLE profile_request (
    req_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id     VARCHAR(50) NOT NULL,
    image_path  VARCHAR(200) NOT NULL, -- 신청한 이미지 경로
    comment     VARCHAR(200),          -- 신청 코멘트
    status      VARCHAR(20) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED
    req_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);


-- =============================================
-- [2] 테마(상점) 관련 테이블
-- =============================================

-- 4. 테마 정보 (상점 진열대)
CREATE TABLE jdi_theme_info (
    theme_code  VARCHAR(50) PRIMARY KEY, -- style1, style2...
    theme_name  VARCHAR(50) NOT NULL,
    price       INT DEFAULT 0,
    description VARCHAR(200),
    is_active   VARCHAR(10) DEFAULT 'Y'  -- Y:판매중, N:중단, AY:시크릿(관리자지급)
);

-- 5. 유저 보유 테마 (jdi_user_theme)
CREATE TABLE jdi_user_theme (
    ut_id       INT AUTO_INCREMENT PRIMARY KEY,
    jdi_user    VARCHAR(50) NOT NULL,
    theme_code  VARCHAR(50) NOT NULL,
    buy_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (jdi_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE,
    FOREIGN KEY (theme_code) REFERENCES jdi_theme_info(theme_code) ON DELETE CASCADE,
    UNIQUE KEY (jdi_user, theme_code) -- 중복 보유 방지
);


-- =============================================
-- [3] 단어장 관련 테이블
-- =============================================

-- 6. 단어장 메인 (jdi_word)
CREATE TABLE japanese_word (
    word_id     INT AUTO_INCREMENT PRIMARY KEY,
    word        VARCHAR(100) NOT NULL, -- 단어
    doc         VARCHAR(100),          -- 요미가나
    korean      VARCHAR(200),          -- 뜻
    jlpt        VARCHAR(10)            -- 급수 (N1~N5)
);

-- 7. 신규 단어 등록 신청 (jdi_word_req)
CREATE TABLE jdi_word_req (
    req_id      INT AUTO_INCREMENT PRIMARY KEY,
    word        VARCHAR(100) NOT NULL,
    doc         VARCHAR(100),
    korean      VARCHAR(200),
    jlpt        VARCHAR(10),
    jdi_user    VARCHAR(50), -- 신청자
    status      VARCHAR(20) DEFAULT 'WAIT', -- WAIT, OK, NO
    reg_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (jdi_user) REFERENCES jdi_login(jdi_user) ON DELETE SET NULL
);

-- 8. 단어 수정 신청 (jdi_word_edit_request)
CREATE TABLE jdi_word_edit_request (
    req_id      INT AUTO_INCREMENT PRIMARY KEY,
    word_id     INT NOT NULL, -- 수정할 원본 단어 ID
    word        VARCHAR(100),
    doc         VARCHAR(100),
    korean      VARCHAR(200),
    jlpt        VARCHAR(10),
    jdi_user    VARCHAR(50), -- 신청자
    status      VARCHAR(20) DEFAULT 'WAIT',
    req_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (word_id) REFERENCES jdi_word(word_id) ON DELETE CASCADE,
    FOREIGN KEY (jdi_user) REFERENCES jdi_login(jdi_user) ON DELETE SET NULL
);

cREATE TABLE incorrect_note (
    note_id INT AUTO_INCREMENT PRIMARY KEY,   -- 오답노트 고유 번호
    jdi_user VARCHAR(50) NOT NULL,            -- 틀린 사람
    quiz_id INT NOT NULL,                     -- 틀린 문제
    wrong_date DATETIME DEFAULT NOW(),        -- 마지막으로 틀린 날짜
    wrong_count INT DEFAULT 1,                -- ★ 추가됨: 틀린 횟수 (기본 1)
    
    CONSTRAINT fk_note_user FOREIGN KEY (jdi_user) REFERENCES jdi_login (jdi_user) ON DELETE CASCADE,
    CONSTRAINT fk_note_quiz FOREIGN KEY (quiz_id) REFERENCES jquiz (quiz_id) ON DELETE CASCADE,
    UNIQUE KEY (jdi_user, quiz_id)
);

CREATE TABLE jquiz (
    quiz_id INT AUTO_INCREMENT PRIMARY KEY,   -- 퀴즈 고유 번호
    word VARCHAR(50) NOT NULL,                -- 문제 (예: 한자)
    jlpt VARCHAR(10) DEFAULT 'N5',            -- 급수
    selection1 VARCHAR(100) NOT NULL,         -- 보기 1
    selection2 VARCHAR(100) NOT NULL,         -- 보기 2
    selection3 VARCHAR(100) NOT NULL,         -- 보기 3
    selection4 VARCHAR(100) NOT NULL,         -- 보기 4
    answer INT NOT NULL                       -- 정답 번호 (1~4)
);

-- =============================================
-- [4] 게시판(공지, Q&A) 관련 테이블
-- =============================================

-- 9. 공지사항 (jdi_notice)
CREATE TABLE jdi_notice (
    idx         INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    content     TEXT NOT NULL,
    writer_id   VARCHAR(50) NOT NULL, -- 작성자(관리자) ID
    is_top      TINYINT DEFAULT 0,    -- 1: 상단고정, 0: 일반
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (writer_id) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);

-- 10. Q&A 질문 (jdi_questions)
CREATE TABLE jdi_questions (
    q_id        INT AUTO_INCREMENT PRIMARY KEY,
    writer_user VARCHAR(50) NOT NULL,
    title       VARCHAR(200) NOT NULL,
    content     TEXT NOT NULL,
    view_count  INT DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (writer_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);

-- 11. Q&A 답변 (jdi_answers)
CREATE TABLE jdi_answers (
    a_id        INT AUTO_INCREMENT PRIMARY KEY,
    q_id        INT NOT NULL,
    writer_user VARCHAR(50) NOT NULL, -- 답변자(주로 관리자)
    content     TEXT NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (q_id) REFERENCES jdi_questions(q_id) ON DELETE CASCADE,
    FOREIGN KEY (writer_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);


-- =============================================
-- [5] 초기 데이터 세팅 (테마 & 관리자)
-- =============================================

-- 1) 테마 데이터 등록
INSERT INTO jdi_theme_info (theme_code, theme_name, price, description, is_active) VALUES 
('default', '기본 (MNU 블루)', 0, '기본 제공 테마', 'Y'),
('style1', '개혁 오렌지', 100, '강렬한 개혁의 색상 #FF7210', 'Y'),
('style2', '크리스마스 나이트', 1500, '레드&그린과 눈 내리는 크리스마스 무드', 'Y'),
('style3', '픽시픽시', 100, '페리윙클과 반짝거리는 색상', 'Y'),
('style4', '결속밴드', 100, '결속력 강한 분홍, 노랑, 파랑, 빨강의 조화', 'A'); -- 시크릿

-- 2) 테스트용 관리자 계정 생성 (필요 시 비밀번호 암호화 주의)
-- ID: admin, PW: 1234, Name: 관리자, Role: ADMIN
INSERT INTO jdi_login (jdi_user, jdi_pw, jdi_name, jdi_role) 
VALUES ('admin', '1234', '관리자', 'ADMIN');

-- 3) 테스트용 일반 유저 생성
-- ID: test, PW: 1234, Name: 홍길동
INSERT INTO jdi_login (jdi_user, jdi_pw, jdi_name, jdi_role) 
VALUES ('test', '1234', '홍길동', 'USER');

-- 4) 관리자에게 시크릿 테마 지급 (테스트용)
INSERT INTO jdi_user_theme (jdi_user, theme_code) VALUES ('admin', 'style4');

COMMIT;
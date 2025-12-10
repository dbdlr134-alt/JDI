-- 1. 스키마(데이터베이스) 생성 (이미 있다면 생략 가능)
CREATE DATABASE dictionary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. 해당 스키마 사용
USE dictionary;

-- 3. 테이블 생성
CREATE TABLE JAPANESE_WORD (
    word_id INT AUTO_INCREMENT PRIMARY KEY,  -- 관리용 고유 번호 (자동 증가)
    word    VARCHAR(50) NOT NULL,            -- 한자 (필수)
    doc   VARCHAR(100),                    -- 음독 
    korean  VARCHAR(200) NOT NULL,           -- 뜻 (필수)
    jlpt    VARCHAR(10) DEFAULT 'N5'         -- 급수 (예: N1, N2... 기본값 N5)
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

CREATE TABLE jdi_login (
    jdi_user    VARCHAR(50) PRIMARY KEY,         -- 아이디
    jdi_pass    VARCHAR(100) NOT NULL,           -- 비밀번호 (암호화 저장)
    jdi_name    VARCHAR(50) NOT NULL,            -- 이름
    jdi_email   VARCHAR(100),                    -- 이메일
    jdi_phone   VARCHAR(20),                     -- 전화번호
    jdi_profile VARCHAR(50) DEFAULT 'profile1.png', -- 프로필 사진 (기본값 설정)
    jdi_role    VARCHAR(10) DEFAULT 'USER'       -- 등급 (USER:일반, ADMIN:관리자)
);

UPDATE jdi_login 
SET jdi_role = 'ADMIN' 
WHERE jdi_user = 'isekai7190';

CREATE TABLE incorrect_note (
    note_id INT AUTO_INCREMENT PRIMARY KEY,   -- 오답노트 고유 번호
    jdi_user VARCHAR(50) NOT NULL,            -- 틀린 사람
    quiz_id INT NOT NULL,                     -- 틀린 문제
    wrong_date DATETIME DEFAULT NOW(),        -- 마지막으로 틀린 날짜
    wrong_count INT DEFAULT 1,                -- ★ 추가됨: 틀린 횟수 (기본 1)
    
    -- 외래키 설정: 회원이 존재해야 저장 가능
    CONSTRAINT fk_note_user FOREIGN KEY (jdi_user) REFERENCES jdi_login (jdi_user) ON DELETE CASCADE,
    
    -- 외래키 설정: 문제가 존재해야 저장 가능
    CONSTRAINT fk_note_quiz FOREIGN KEY (quiz_id) REFERENCES jquiz (quiz_id) ON DELETE CASCADE,
    
    -- 중복 방지: 한 회원이 같은 문제를 여러 번 틀려도 행이 늘어나지 않게 (유니크 키)
    UNIQUE KEY (jdi_user, quiz_id)
);

-- 수정 신청 테이블
CREATE TABLE jdi_word_edit_request (
    req_id INT AUTO_INCREMENT PRIMARY KEY,
    word_id INT NOT NULL,          -- 수정 요청할 단어 ID
    jdi_user VARCHAR(50) NOT NULL, -- 신청자
    word       VARCHAR(50) NOT NULL,           -- 단어
    doc VARCHAR(100),              -- 수정 요청 음독/읽기
    korean VARCHAR(500),           -- 수정 요청 뜻
    jlpt VARCHAR(10),              -- 수정 요청 JLPT
    status VARCHAR(10) DEFAULT 'WAIT', -- WAIT / OK / NO
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 단어 등록 신청
CREATE TABLE jdi_word_req (
    req_id     INT AUTO_INCREMENT PRIMARY KEY, -- 신청 번호
    word       VARCHAR(50) NOT NULL,           -- 단어
    doc        VARCHAR(100),                   -- 요미가나
    korean     VARCHAR(200) NOT NULL,          -- 뜻
    jlpt       VARCHAR(10) DEFAULT 'N5',       -- 급수
    jdi_user   VARCHAR(50),                    -- 신청자 ID (외래키)
    status     VARCHAR(10) DEFAULT 'WAIT',     -- 상태 (WAIT:대기, OK:승인, NO:거절)
    reg_date   DATETIME DEFAULT NOW(),         -- 신청일
    
    FOREIGN KEY (jdi_user) REFERENCES jdi_login(jdi_user) ON DELETE SET NULL
);

-- 테이블 새로 생성 (point_id 제거, 외래키 추가)
CREATE TABLE jdi_point_log (
    jdi_user   VARCHAR(50) NOT NULL,           -- 회원ID (외래키)
    amount     INT NOT NULL default 0,      -- 포인트 양
    reason     VARCHAR(100),                   -- 사유
    reg_date   DATETIME DEFAULT NOW(),         -- 날짜
    
    -- [외래키 설정] jdi_login 테이블의 jdi_user를 참조함
    -- ON DELETE CASCADE: 회원이 탈퇴하면 포인트 기록도 같이 삭제됨
    FOREIGN KEY (jdi_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);

-- (테스트용) 가입 축하금 다시 넣기
INSERT INTO jdi_point_log (jdi_user, amount, reason) 
VALUES ('yerin123', 1000, '회원가입 축하금');

select * from jdi_point_log;

-- 사용자가 푼 문제 수를 저장할 컬럼 추가 (기본값 0)
ALTER TABLE jdi_login ADD jdi_solve_count INT DEFAULT 0;

CREATE TABLE profile_request (
    req_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id    VARCHAR(50) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    comment    VARCHAR(500),
    status     VARCHAR(20) DEFAULT 'PENDING',
    req_date   DATETIME DEFAULT NOW()
);

CREATE TABLE jdi_bookmark (
    bm_id INT AUTO_INCREMENT PRIMARY KEY,
    jdi_user VARCHAR(50) NOT NULL,
    word_id INT NOT NULL,
    reg_date DATETIME DEFAULT NOW(),
    FOREIGN KEY (jdi_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE,
    FOREIGN KEY (word_id) REFERENCES japanese_word(word_id) ON DELETE CASCADE,
    UNIQUE KEY (jdi_user, word_id) -- 한 유저가 같은 단어를 중복 저장 방지
);

CREATE TABLE jdi_message (
    msg_id INT AUTO_INCREMENT PRIMARY KEY,
    sender VARCHAR(50) NOT NULL,    -- 보낸 사람 (관리자)
    receiver VARCHAR(50) NOT NULL,  -- 받는 사람 (회원)
    content VARCHAR(500) NOT NULL,  -- 내용
    is_read CHAR(1) DEFAULT 'N',    -- 읽음 여부 (Y/N)
    send_date DATETIME DEFAULT NOW(),
    FOREIGN KEY (sender) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE,
    FOREIGN KEY (receiver) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);

CREATE TABLE jdi_login (
    jdi_user    VARCHAR(50) PRIMARY KEY,         -- 아이디
    jdi_pass    VARCHAR(100) NOT NULL,           -- 비밀번호 (암호화 저장)
    jdi_name    VARCHAR(50) NOT NULL,            -- 이름
    jdi_email   VARCHAR(100),                    -- 이메일
    jdi_phone   VARCHAR(20),                     -- 전화번호
    jdi_profile VARCHAR(50) DEFAULT 'profile1.png', -- 프로필 사진 (기본값 설정)
    jdi_role    VARCHAR(10) DEFAULT 'USER'       -- 등급 (USER:일반, ADMIN:관리자)
);

CREATE TABLE forbidden_names (
    id INT AUTO_INCREMENT PRIMARY KEY,
    word VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO forbidden_names (word) VALUES
('admin'),
('root'),
('administrator'),
('master'),
('관리자'),
('운영자'),
('system');

ALTER TABLE jdi_login ADD COLUMN jdi_theme VARCHAR(50) DEFAULT 'default';


-- 유저 보유 테마 목록 (구매 내역)
CREATE TABLE jdi_user_theme (
    ut_id INT AUTO_INCREMENT PRIMARY KEY,
    jdi_user VARCHAR(50) NOT NULL,
    theme_code VARCHAR(50) NOT NULL, -- style1, style2 등 폴더명
    buy_date DATETIME DEFAULT NOW(),
    FOREIGN KEY (jdi_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE,
    UNIQUE KEY unique_theme_ownership (jdi_user, theme_code) -- 중복 구매 방지
);

-- 3. 테마 상품 정보 (상점 진열대) ★ 핵심
-- 이 테이블에 데이터를 넣으면 마이페이지 상점에 자동으로 뜹니다.
CREATE TABLE jdi_theme_info (
    theme_code VARCHAR(50) PRIMARY KEY,  -- 폴더명과 일치해야 함 (예: style1)
    theme_name VARCHAR(50) NOT NULL,     -- 화면에 보여줄 이름
    price INT DEFAULT 0,                 -- 가격 (포인트)
    description VARCHAR(100),            -- (선택) 테마 설명
    is_active CHAR(1) DEFAULT 'Y'        -- 판매 중 여부 (Y/N)
);

-- 4. 초기 데이터 등록 (상품 진열)
-- (1) 기본 테마 (가격 0원, 모두가 가진 것으로 처리하거나 로직으로 예외 처리)
INSERT INTO jdi_theme_info (theme_code, theme_name, price, description) 
VALUES ('default', '기본 (MNU 블루)', 0, '기본 제공 테마');

-- (2) ★ 개혁 오렌지 (style1) 등록
INSERT INTO jdi_theme_info (theme_code, theme_name, price, description) 
VALUES ('style1', '개혁 오렌지', 100, '강렬한 개혁의 색상 #FF7210');

INSERT INTO jdi_theme_info (theme_code, theme_name, price, description, is_active)
VALUES (
    'style2',                           -- /style/style2/style.css
    '크리스마스 나이트',                -- 화면에 보이는 이름
    1500,                               -- 포인트 가격 (원하는 대로 수정 가능)
    '레드&그린과 눈 내리는 크리스마스 무드', 
    'Y'
);

CREATE TABLE jdi_questions (
    q_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '질문 고유 ID',
    writer_user VARCHAR(50) NOT NULL COMMENT '작성자 ID (jdi_login 참조)',
    title VARCHAR(200) NOT NULL COMMENT '질문 제목',
    content TEXT NOT NULL COMMENT '질문 내용',
    view_count INT DEFAULT 0 COMMENT '조회수',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',

    -- 외래키 연결: jdi_login 테이블의 jdi_user 컬럼을 참조
    -- 주의: jdi_login의 jdi_user 컬럼 타입과 writer_user 타입이 정확히 같아야 함
    FOREIGN KEY (writer_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);
select * from jdiquestions;
-- 2. 답변 테이블 (jdi 접두사 적용)
CREATE TABLE jdi_answers (
    a_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '답변 고유 ID',
    q_id INT NOT NULL COMMENT '원본 질문 ID (jdi_questions 참조)',
    writer_user VARCHAR(50) NOT NULL COMMENT '답변 작성자 ID (jdi_login 참조)',
    content TEXT NOT NULL COMMENT '답변 내용',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',

    -- 질문이 삭제되면 답변도 삭제
    FOREIGN KEY (q_id) REFERENCES jdi_questions(q_id) ON DELETE CASCADE,
    -- 사용자가 삭제되면 답변도 삭제
    FOREIGN KEY (writer_user) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);

INSERT INTO jdi_theme_info (theme_code, theme_name, price, description, is_active)
VALUES (
    'style3',                           -- /style/style2/style.css
    '픽시픽시',                -- 화면에 보이는 이름
    100,                               -- 포인트 가격 (원하는 대로 수정 가능)
    '페리윙클과 반짝거리는 색상', 
    'Y'
);

INSERT INTO jdi_theme_info (theme_code, theme_name, price, description, is_active)
VALUES (
    'style4',                           -- /style/style2/style.css
    '결속밴드',                -- 화면에 보이는 이름
    100,                               -- 포인트 가격 (원하는 대로 수정 가능)
    '결속력 강한 분홍, 노랑, 파랑, 빨강의 조화', 
    'Y'
);
select * from jdi_point_log;



CREATE TABLE jdi_notice (
    idx INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    writer_id VARCHAR(50) NOT NULL, -- 작성자 아이디 (외래키)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_top TINYINT DEFAULT 0,       -- 상단 고정 여부 (1:고정, 0:일반)

    -- 외래키 설정
    CONSTRAINT fk_notice_writer FOREIGN KEY (writer_id) REFERENCES jdi_login(jdi_user) ON DELETE CASCADE
);



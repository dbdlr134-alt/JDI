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
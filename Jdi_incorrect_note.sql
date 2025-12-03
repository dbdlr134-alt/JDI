CREATE TABLE incorrect_note (
    note_id INT AUTO_INCREMENT PRIMARY KEY,   -- 오답노트 고유 번호
    jdi_user VARCHAR(50) NOT NULL,            -- 틀린 사람 (회원 ID)
    quiz_id INT NOT NULL,                     -- 틀린 문제 (문제 ID)
    wrong_date DATETIME DEFAULT NOW(),        -- 틀린 날짜 (기본값 현재시간)
    
    -- 외래키 설정: 회원이 존재해야 저장 가능
    CONSTRAINT fk_note_user FOREIGN KEY (jdi_user) REFERENCES jdi_login (jdi_user) ON DELETE CASCADE,
    
    -- 외래키 설정: 문제가 존재해야 저장 가능
    CONSTRAINT fk_note_quiz FOREIGN KEY (quiz_id) REFERENCES jquiz (quiz_id) ON DELETE CASCADE,
    
    -- 중복 방지: 한 회원이 같은 문제를 여러 번 틀려도 행이 늘어나지 않게 (유니크 키)
    UNIQUE KEY (jdi_user, quiz_id)
);
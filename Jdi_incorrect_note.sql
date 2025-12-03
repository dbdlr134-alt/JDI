CREATE TABLE incorrect_note (
    note_id INT AUTO_INCREMENT PRIMARY KEY,   -- 오답노트 고유 번호
    jdi_user VARCHAR(50) NOT NULL,            -- 틀린 사람
    quiz_id INT NOT NULL,                     -- 틀린 문제
    wrong_date DATETIME DEFAULT NOW(),        -- 마지막으로 틀린 날짜
    wrong_count INT DEFAULT 1,                -- ★ 추가됨: 틀린 횟수 (기본 1)
    
    CONSTRAINT fk_note_user FOREIGN KEY (jdi_user) REFERENCES jdi_login (jdi_user) ON DELETE CASCADE,
    CONSTRAINT fk_note_quiz FOREIGN KEY (quiz_id) REFERENCES jquiz (quiz_id) ON DELETE CASCADE,
    UNIQUE KEY (jdi_user, quiz_id)
);

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
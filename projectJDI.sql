
-- 1. 스키마(데이터베이스) 생성 (이미 있다면 생략 가능)
CREATE DATABASE dictionary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. 해당 스키마 사용
USE dictionary;
select * from japanese_word;
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
INSERT INTO JAPANESE_WORD (word, doc, korean, jlpt) VALUES
('末', 'まつ', '말', 'N1'),
('愛想', 'あいそう', '붙임성;사람을 대하는 태도상대의 기분을 맞추...', 'N1'),
('間柄', 'あいだがら', '사람과 사람의 사이', 'N1'),
('合間', 'あいま', '틈;짬;참참', 'N1'),
('仰向け', 'あおむけ', '뒤로 젖혀 위를 봄', 'N1'),
('合間', 'あいま', '틈;짬;참참', 'N1'),
('垢', 'あか', '때;더러움물때강바닥의 돌에 붙은 규조', 'N1'),
('証', 'あかし', '증거;증명;특히, 결백의 증거', 'N1'),
('諦め', 'あきらめ', '체념하는 일;단념', 'N1'),
('憧れ', 'あこがれ', '동경', 'N1');
insert into japanese_word values(11, "済み", "-ずみ", "끝남;필", "N2");
insert into japanese_word values(12, "付く・附く", "-つく", "소리・동작・모양이 그렇게 됨을 나타냄", "N2");
insert into japanese_word values(13, "遣(い)", "-づかい", "사용;씀목소리 등의 상태", "N2");
insert into japanese_word values(14, "愛情", "あいじょう", "애정;사랑", "N2");
insert into japanese_word values(15, "青空", "あおぞら", "파랗게 갠 하늘;창공노천;야외", "N2");
insert into japanese_word values(16, "赤字", "あかじ", "적자;결손빨간 빛깔로 바로잡은 글자", "N2");
insert into japanese_word values(17, "明(かり)", "あかり", "환한 빛;밝은 빛결백한 증거", "N2");
insert into japanese_word values(21, "愛", "あい", "사랑;애정", "N3");
insert into japanese_word values(22, "相手", "あいて", "상대;함께 무엇을 하는 사람;적수", "N3");
insert into japanese_word values(23, "赤ん坊", "あかんぼう", "갓난아기;태어날 아기;또, 어리고 유치함", "N3");
insert into japanese_word values(24, "明地・空地", "あきち", "공지;빈터;공터", "N3");
insert into japanese_word values(25, "欠・欠伸", "あくび", "하품", "N3");
insert into japanese_word values(26, "朝日・旭", "あさひ", "아침 해;또, 그 햇빛", "N3");
insert into japanese_word values(27, "足跡", "あしあと", "발자취;발자국;전하여, 행방;업적", "N3");
insert into japanese_word values(28, "足下・足元・足許", "あしもと", "발밑;또, 그 언저리;신변;바로 곁;지반;기반", "N3");
insert into japanese_word values(29, "集(ま)り", "あつまり", "모임;또, 모인 것;특히, 회합", "N3");
insert into japanese_word values(30, "あて先・宛先", "あてさき", "수신인의 주소;수신인", "N3");
insert into japanese_word values(31, "か月・箇月・個月", "-かげつ", "…개월", "N4");
insert into japanese_word values(32, "間", "あいだ", "사이;둘 간의 떨어진 사이;간격;틈새", "N4");
insert into japanese_word values(33, "赤ちゃん", "あかちゃん", "아기;새끼;세상 물정을 모르는 사람", "N4");
insert into japanese_word values(34, "顎・腭・頞", "あご", "턱;아래턱;수다", "N4");
insert into japanese_word values(35, "足音・跫音", "あしおと", "발소리", "N4");
insert into japanese_word values(36, "味", "あじ", "맛;어떠함;멋;재미", "N4");
insert into japanese_word values(37, "明日", "あす", "명일;내일", "N4");
insert into japanese_word values(38, "汗", "あせ", "땀;물방울", "N4");
insert into japanese_word values(39, "遊び", "あそび", "노는 일;놀이;유흥;장난", "N4");
insert into japanese_word values(40, "暑さ", "あつさ", "더위;여름철", "N4");
insert into japanese_word values(41, "秋", "あき", "가을", "N5");
insert into japanese_word values(42, "朝", "あさ", "아침", "N5");
insert into japanese_word values(43, "朝ご飯", "あさごはん", "아침 밥", "N5");
insert into japanese_word values(44, "明後日", "あさって", "모레", "N5");
insert into japanese_word values(45, "足", "あし", "발;걸음;보조", "N5");
insert into japanese_word values(46, "明日", "あした", "내일", "N5");
insert into japanese_word values(47, "頭", "あたま", "머리;두부;두발;머리칼", "N5");
insert into japanese_word values(48, "兄", "あに", "형;오빠", "N5");
insert into japanese_word values(49, "姉", "あね", "언니;손위 누이;배우자의 손위 여자 형제", "N5");
insert into japanese_word values(50, "雨", "あめ", "비;우천;빗발치듯 쏟아지는 모양", "N5");

-- 퀴즈 샘플

INSERT INTO jquiz (quiz_id, word, jlpt, selection1, selection2, selection3, selection4, answer) VALUES
(1, '末', 'N1', 'まく', 'まつ', 'みつ', 'ばつ', 2),
(2, '愛想', 'N1', 'あいそう', 'あいしょう', 'あそう', 'いそう', 1),
(3, '間柄', 'N1', 'まがら', 'かんがら', 'あいだがら', 'あいから', 3),
(4, '合間', 'N1', 'ごうま', 'あまま', 'がっま', 'あいま', 4),
(5, '仰向け', 'N1', 'おおむけ', 'あおむけ', 'あおぬけ', 'こうむけ', 2),
(6, '合間', 'N1', 'あいま', 'あわま', 'ごうま', 'あいまあ', 1),
(7, '垢', 'N1', 'あご', 'あせ', 'あか', 'あじ', 3),
(8, '証', 'N1', 'あきし', 'しょう', 'あかせ', 'あかし', 4),
(9, '諦め', 'N1', 'あからめ', 'あきらめ', 'しめ', 'ながめ', 2),
(10, '憧れ', 'N1', 'あくがれ', 'たそがれ', 'あこがれ', 'あきれ', 3);

INSERT INTO jquiz (quiz_id, word, jlpt, selection1, selection2, selection3, selection4, answer) VALUES
(11, '済み', 'N2', 'すみ', 'しずみ', 'つみ', 'ずみ', 4),
(12, '付く', 'N2', 'つく', 'づく', 'ふく', 'とく', 1),
(13, '遣い', 'N2', 'つかい', 'づかい', 'いかい', 'むかい', 2),
(14, '愛情', 'N2', 'あいしょう', 'あじょう', 'あいじょう', 'あいせい', 3),
(15, '青空', 'N2', 'あおそら', 'せいぞら', 'あおぞろ', 'あおぞら', 4),
(16, '赤字', 'N2', 'あかじ', 'あかち', 'せきじ', 'あかし', 1),
(17, '明かり', 'N2', 'あかる', 'あかり', 'あきり', 'ひかり', 2),
(18, '明け方', 'N2', 'あけかた', 'あきがた', 'あけがた', 'あさかた', 3),
(19, '辺り', 'N2', 'へんり', 'たより', 'ほとり', 'あたり', 4),
(20, '宛名', 'N2', 'あてめい', 'あてな', 'あだな', 'えんめい', 2);

INSERT INTO jquiz (quiz_id, word, jlpt, selection1, selection2, selection3, selection4, answer) VALUES
(21, '愛', 'N3', 'あえ', 'こい', 'あい', 'まい', 3),
(22, '相手', 'N3', 'あいで', 'そうて', 'あうて', 'あいて', 4),
(23, '赤ん坊', 'N3', 'あかんぼう', 'あかぼう', 'あかんほう', 'あかちゃん', 1),
(24, '明地', 'N3', 'あきじ', 'あきち', 'めいち', 'くうち', 2),
(25, '欠伸', 'N3', 'けっしん', 'あくひ', 'あくび', 'あしび', 3),
(26, '朝日', 'N3', 'あさび', 'ちょうにち', 'あした', 'あさひ', 4),
(27, '足跡', 'N3', 'あしあと', 'そくせき', 'あしおと', 'あしもと', 1),
(28, '足下', 'N3', 'あしした', 'あしもと', 'そっか', 'あしもと', 2),
(29, '集まり', 'N3', 'しゅうかい', 'あつまりり', 'あつまり', 'あつむり', 3),
(30, '宛先', 'N3', 'あてせん', 'あてまえ', 'あてな', 'あてさき', 4);

INSERT INTO jquiz (quiz_id, word, jlpt, selection1, selection2, selection3, selection4, answer) VALUES
(31, 'か月', 'N4', 'かげつ', 'こげつ', 'いっかつ', 'がげつ', 1),
(32, '間', 'N4', 'ま', 'あいだ', 'かん', 'あいた', 2),
(33, '赤ちゃん', 'N4', 'あかんぼう', 'あかさん', 'あかちゃん', 'あこちゃん', 3),
(34, '顎', 'N4', 'あこ', 'ひげ', 'ほほ', 'あご', 4),
(35, '足音', 'N4', 'あしおと', 'あしね', 'あしあと', 'そくおん', 1),
(36, '味', 'N4', 'み', 'あじ', 'あし', 'あみ', 2),
(37, '明日', 'N4', 'あき', 'あさ', 'あす', 'みょうにち', 3),
(38, '汗', 'N4', 'あか', 'あめ', 'あわ', 'あせ', 4),
(39, '遊び', 'N4', 'あそび', 'あそひ', 'ゆび', 'えらび', 1),
(40, '暑さ', 'N4', 'あたたかさ', 'あつさ', 'さむさ', 'あつみ', 2);

INSERT INTO jquiz (quiz_id, word, jlpt, selection1, selection2, selection3, selection4, answer) VALUES
(41, '秋', 'N5', 'あか', 'はる', 'あき', 'ふゆ', 3),
(42, '朝', 'N5', 'あし', 'よる', 'ひる', 'あさ', 4),
(43, '朝ご飯', 'N5', 'あさごはん', 'ひるごはん', 'ばんごはん', 'あさごふん', 1),
(44, '明後日', 'N5', 'あした', 'あさって', 'みょうごにち', 'おととい', 2),
(45, '足', 'N5', 'あじ', 'て', 'あし', 'かお', 3),
(46, '明日', 'N5', 'きのう', 'きょう', 'あさ', 'あした', 4),
(47, '頭', 'N5', 'あたま', 'め', 'みみ', 'くち', 1),
(48, '兄', 'N5', 'あね', 'あに', 'おとうと', 'いもうと', 2),
(49, '姉', 'N5', 'あに', 'はは', 'あね', 'ちち', 3),
(50, '雨', 'N5', 'ゆき', 'くも', 'かぜ', 'あめ', 4);

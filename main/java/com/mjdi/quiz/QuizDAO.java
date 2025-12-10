package com.mjdi.quiz;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import com.mjdi.util.DBM;

public class QuizDAO {
    
    // --- 싱글톤 패턴 ---
    private QuizDAO() {}
    private static QuizDAO instance = new QuizDAO();
    public static QuizDAO getInstance() { return instance; }
    
    // ==========================================================
    // [1] 랜덤 퀴즈 5문제 생성 (테이블명: japanese_word)
    // ==========================================================
    public List<QuizDTO> getRandomQuiz(String jlpt) {
        List<QuizDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBM.getConnection();
            String sql = "SELECT * FROM japanese_word WHERE jlpt = ? ORDER BY RAND() LIMIT 5";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, jlpt);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                QuizDTO quiz = new QuizDTO();
                quiz.setQuiz_id(list.size() + 1); 
                quiz.setWord_id(rs.getInt("word_id"));
                quiz.setWord(rs.getString("word"));
                quiz.setAnswer(rs.getString("korean"));
                quiz.setJlpt(rs.getString("jlpt"));
                
                List<String> options = getWrongAnswers(conn, quiz.getJlpt(), quiz.getWord_id());
                options.add(quiz.getAnswer());
                while (options.size() < 4) options.add("보기 부족 (" + (options.size()+1) + ")");
                Collections.shuffle(options);
                
                quiz.setSelection1(options.get(0));
                quiz.setSelection2(options.get(1));
                quiz.setSelection3(options.get(2));
                quiz.setSelection4(options.get(3));
                
                for(int i=0; i<4; i++) {
                    if(options.get(i).equals(quiz.getAnswer())) {
                        quiz.setAnswer(String.valueOf(i+1));
                        break;
                    }
                }
                list.add(quiz);
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }
        return list;
    }

    // ==========================================================
    // [2] 특정 단어(ID)로 퀴즈 1개 생성 (오늘의 퀴즈용)
    // ==========================================================
    public QuizDTO getQuizByWordId(int wordId) {
        QuizDTO quiz = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBM.getConnection();
            String sql = "SELECT * FROM japanese_word WHERE word_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, wordId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                quiz = new QuizDTO();
                quiz.setQuiz_id(1); 
                quiz.setWord_id(rs.getInt("word_id"));
                quiz.setWord(rs.getString("word"));
                quiz.setAnswer(rs.getString("korean"));
                quiz.setJlpt(rs.getString("jlpt"));
                
                List<String> options = getWrongAnswers(conn, quiz.getJlpt(), quiz.getWord_id());
                options.add(quiz.getAnswer());
                while (options.size() < 4) options.add("보기 부족 (" + (options.size()+1) + ")");
                Collections.shuffle(options);
                
                quiz.setSelection1(options.get(0));
                quiz.setSelection2(options.get(1));
                quiz.setSelection3(options.get(2));
                quiz.setSelection4(options.get(3));
                
                for(int i=0; i<4; i++) {
                    if(options.get(i).equals(quiz.getAnswer())) {
                        quiz.setAnswer(String.valueOf(i+1));
                        break;
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }
        return quiz;
    }

    // ==========================================================
    // [3] 보조 메서드: 오답 보기 3개 가져오기
    // ==========================================================
    private List<String> getWrongAnswers(Connection conn, String jlpt, int correctWordId) {
        List<String> options = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT korean FROM japanese_word WHERE jlpt = ? AND word_id != ? ORDER BY RAND() LIMIT 3";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, jlpt);
            pstmt.setInt(2, correctWordId);
            rs = pstmt.executeQuery();
            while(rs.next()) options.add(rs.getString("korean"));
        } catch(Exception e) { e.printStackTrace(); }
        finally { 
            if(rs!=null) try{rs.close();}catch(Exception e){}
            if(pstmt!=null) try{pstmt.close();}catch(Exception e){}
        }
        return options;
    }
    
    // ==========================================================
    // [4] 오늘의 퀴즈 세팅 (앱 시작 시 호출)
    // ==========================================================
    public void checkAndSetGlobalQuiz(javax.servlet.ServletContext app) {
        if(app.getAttribute("todayQuiz") == null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DBM.getConnection();
                String sql = "SELECT * FROM japanese_word WHERE jlpt IN ('N3','N4','N5') ORDER BY RAND() LIMIT 1";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                if(rs.next()) {
                    QuizDTO dto = new QuizDTO();
                    dto.setWord_id(rs.getInt("word_id"));
                    dto.setWord(rs.getString("word"));
                    dto.setAnswer(rs.getString("korean"));
                    dto.setJlpt(rs.getString("jlpt"));
                    app.setAttribute("todayQuiz", dto);
                }
            } catch(Exception e) { e.printStackTrace(); }
            finally { DBM.close(conn, pstmt, rs); }
        }
    }

    // ==========================================================
    // [5] 트랜잭션 지원 메서드들 (Connection을 매개변수로 받음)
    // ==========================================================

    // 5-1. 오답노트 추가 (트랜잭션용) - [수정됨: 외래키 오류 방지 로직 추가]
    public void addIncorrectNoteWithConn(Connection conn, String userId, int wordId) throws Exception {
        // 1. 단어 존재 여부 확인 (삭제된 단어 참조 방지)
        String checkSql = "SELECT COUNT(*) FROM japanese_word WHERE word_id = ?";
        boolean exists = false;
        try (PreparedStatement checkPstmt = conn.prepareStatement(checkSql)) {
            checkPstmt.setInt(1, wordId);
            try (ResultSet rs = checkPstmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    exists = true;
                }
            }
        }

        // 2. 단어가 존재하지 않으면 삽입하지 않고 리턴 (에러 방지)
        if (!exists) {
            System.out.println("⚠️ [알림] 존재하지 않는 단어 ID(" + wordId + ")를 오답노트에 추가하려 했습니다. 작업을 건너뜁니다.");
            return;
        }

        // 3. 단어가 존재할 때만 실행
        String sql = "INSERT INTO incorrect_note (jdi_user, quiz_id, wrong_count, wrong_date) "
                   + "VALUES (?, ?, 1, NOW()) "
                   + "ON DUPLICATE KEY UPDATE wrong_count = wrong_count + 1, wrong_date = NOW()";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, wordId); // quiz_id 컬럼에 word_id 저장
            pstmt.executeUpdate();
        }
    }

    // 5-2. 오답노트 삭제 (트랜잭션용)
    public void removeIncorrectNoteWithConn(Connection conn, String userId, int wordId) throws Exception {
        String sql = "DELETE FROM incorrect_note WHERE jdi_user = ? AND quiz_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, wordId);
            pstmt.executeUpdate();
        }
    }

    // 5-3. 풀이 횟수 증가 (트랜잭션용)
    public void updateSolveCountWithConn(Connection conn, String userId, int count) throws Exception {
        String sql = "UPDATE jdi_login SET jdi_solve_count = jdi_solve_count + ? WHERE jdi_user = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, count);
            pstmt.setString(2, userId);
            pstmt.executeUpdate();
        }
    }
    
    // 5-4. 퀴즈 결과 기록 (히스토리) 저장 (트랜잭션용) ★ 마이페이지 그래프용
    public void insertQuizHistoryWithConn(Connection conn, String userId, int correctCnt, int totalCnt) throws Exception {
        String sql = "INSERT INTO jdi_quiz_history (jdi_user, correct_cnt, total_cnt, solve_date) VALUES (?, ?, ?, NOW())";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, correctCnt);
            pstmt.setInt(3, totalCnt);
            pstmt.executeUpdate();
        }
    }

    // ==========================================================
    // [6] 일반 조회 메서드 (Connection 생성/종료 포함)
    // ==========================================================

    // 6-1. 내 오답 노트 조회
    public List<QuizDTO> getIncorrectNotes(String userId) {
        List<QuizDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT n.quiz_id, w.word, w.doc, w.korean, n.wrong_count, n.wrong_date "
                   + "FROM incorrect_note n "
                   + "JOIN japanese_word w ON n.quiz_id = w.word_id "
                   + "WHERE n.jdi_user = ? ORDER BY n.wrong_date DESC";

        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                QuizDTO dto = new QuizDTO();
                dto.setQuiz_id(rs.getInt("quiz_id"));
                dto.setWord_id(rs.getInt("quiz_id")); // word_id도 세팅
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setWrong_count(rs.getInt("wrong_count"));
                dto.setWrong_date(rs.getString("wrong_date"));
                list.add(dto);
            }
        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }
        return list;
    }

    // 6-2. 오답노트 개수 조회
    public int getIncorrectCount(String userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM incorrect_note WHERE jdi_user = ?";
        try (Connection conn = DBM.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // 6-3. 나의 총 풀이 횟수 조회
    public int getMySolveCount(String userId) {
        int count = 0;
        String sql = "SELECT jdi_solve_count FROM jdi_login WHERE jdi_user = ?";
        try (Connection conn = DBM.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if(rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }
    
    // 6-4. 최근 30건 정답률 조회 (마이페이지 그래프용)
    public List<Integer> getRecentScores(String userId) {
        List<Integer> scores = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // 최근 30개를 가져와서, 오래된 순서대로 정렬해야 그래프가 예쁘게 그려짐 (과거 -> 현재)
        String sql = "SELECT * FROM (SELECT correct_cnt, total_cnt, solve_date FROM jdi_quiz_history WHERE jdi_user = ? ORDER BY solve_date DESC LIMIT 30) AS sub ORDER BY solve_date ASC";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                int correct = rs.getInt("correct_cnt");
                int total = rs.getInt("total_cnt");
                if(total == 0) total = 5; 
                int score = (correct * 100) / total;
                scores.add(score);
            }
        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }
        return scores;
    }
    
    // 6-5. 오답노트 복습 퀴즈 생성
    public List<QuizDTO> getIncorrectQuiz(String userId) {
       List<QuizDTO> list = new ArrayList<>();
       Connection conn = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       
       try {
           conn = DBM.getConnection();
           String sql = "SELECT w.word_id, w.word, w.doc, w.korean, w.jlpt FROM incorrect_note n JOIN japanese_word w ON n.quiz_id = w.word_id WHERE n.jdi_user = ? ORDER BY RAND() LIMIT 5";
           pstmt = conn.prepareStatement(sql);
           pstmt.setString(1, userId);
           rs = pstmt.executeQuery();
           
           while(rs.next()) {
               QuizDTO dto = new QuizDTO();
               dto.setQuiz_id(rs.getInt("word_id"));
               dto.setWord_id(rs.getInt("word_id"));
               dto.setWord(rs.getString("word"));
               dto.setKorean(rs.getString("korean"));
               dto.setJlpt(rs.getString("jlpt"));
               
               List<String> options = getWrongAnswers(conn, dto.getJlpt(), dto.getWord_id());
               options.add(dto.getKorean());
               while(options.size() < 4) options.add("보기 부족");
               Collections.shuffle(options);
               
               dto.setSelection1(options.get(0));
               dto.setSelection2(options.get(1));
               dto.setSelection3(options.get(2));
               dto.setSelection4(options.get(3));
               
               for(int i=0; i<4; i++) {
                   if(options.get(i).equals(dto.getKorean())) {
                       dto.setAnswer(String.valueOf(i+1));
                       break;
                   }
               }
               list.add(dto);
           }
       } catch(Exception e) { e.printStackTrace(); }
       finally { DBM.close(conn, pstmt, rs); }
       return list;
    }
}
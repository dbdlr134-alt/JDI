package com.jdi.word;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import com.jdi.util.DBM;

public class WordDAO {
    
    // 싱글톤 패턴
    private WordDAO() {}
    private static WordDAO instance = new WordDAO();
    public static WordDAO getInstance() { return instance; }
    
    // [중요] 멤버 변수에 있던 conn, pstmt, rs는 삭제했습니다! (안전함)

    // 1. 검색 메소드 (정확도 우선 정렬 + 뜻 검색 포함)
    public ArrayList<WordDTO> searchWords(String keyword) {
        ArrayList<WordDTO> list = new ArrayList<>();
        
        // ★ [수정] 메소드 안에서 선언 (지역 변수)
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM japanese_word "
                   + "WHERE word LIKE ? OR korean LIKE ? OR jlpt LIKE ? "
                   + "ORDER BY (CASE WHEN word = ? THEN 0 ELSE 1 END), LENGTH(word)";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            
            // JLPT는 정확히 검색할 때만 나오게 하거나, 포함 검색하려면 % 추가
            pstmt.setString(3, "%" + keyword + "%"); 
            
            pstmt.setString(4, keyword); // 정렬용
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                WordDTO dto = new WordDTO();
                dto.setWord_id(rs.getInt("word_id"));
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setJlpt(rs.getString("jlpt"));
                
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt, rs); 
        }
        return list;
    }

    // 2. 랜덤 단어 가져오기
    public WordDTO getRandomWord() {
        WordDTO dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM japanese_word ORDER BY RAND() LIMIT 1";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                dto = new WordDTO(); 
                dto.setWord_id(rs.getInt("word_id"));
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setJlpt(rs.getString("jlpt"));
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt, rs);
        }
        return dto;
    }

    // 3. JLPT 급수별 검색
    public ArrayList<WordDTO> JlptSearch(String jlpt) {
        ArrayList<WordDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM japanese_word WHERE jlpt LIKE ?"; // LIKE로 변경 추천
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + jlpt + "%");
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                WordDTO dto = new WordDTO();
                dto.setWord_id(rs.getInt("word_id"));
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setJlpt(rs.getString("jlpt"));
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt, rs);
        }
        return list;
    }

    // 4. 오늘의 퀴즈 세팅 (세션 처리 헬퍼)
    public void setTodayQuiz(HttpSession session) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());

        String sessionDate = (String) session.getAttribute("quizDate");

        if (sessionDate == null || !today.equals(sessionDate)) {
            WordDTO randomWord = getRandomWord(); 

            if (randomWord != null) {
                session.setAttribute("quizWord", randomWord);
            } else {
                WordDTO defaultWord = new WordDTO();
                defaultWord.setWord("준비중");
                defaultWord.setKorean("데이터가 없습니다");
                session.setAttribute("quizWord", defaultWord);
            }
            session.setAttribute("quizDate", today);
        }
    }

    // 5. word_id로 상세 조회
    public WordDTO wordSelect(int word_id){
        WordDTO dto = new WordDTO();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql="SELECT * FROM japanese_word WHERE word_id = ?";
        try {
            conn=DBM.getConnection();
            pstmt=conn.prepareStatement(sql);
            pstmt.setInt(1, word_id);
            rs=pstmt.executeQuery();
            
            if(rs.next()) {
                dto.setWord_id(rs.getInt("word_id"));
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setJlpt(rs.getString("jlpt"));
            }
        }catch(Exception e) {
            e.printStackTrace();
        }finally {
            DBM.close(conn, pstmt, rs);
        }
        return dto;
    }
    
    // 6. 자동완성 검색
    public List<WordDTO> autoComplete(String keyword) {
        List<WordDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM japanese_word WHERE word LIKE ? OR korean LIKE ? LIMIT 10";

        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                WordDTO dto = new WordDTO();
                dto.setWord_id(rs.getInt("word_id"));
                dto.setWord(rs.getString("word"));
                dto.setKorean(rs.getString("korean"));
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt, rs);
        }
        return list;
    }
    
 // ★ [신규] 관리자 승인 시 실제 단어장에 등록 (INSERT)
    public int insertWord(WordDTO dto) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO japanese_word (word, doc, korean, jlpt) VALUES (?, ?, ?, ?)";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getWord());
            pstmt.setString(2, dto.getDoc());
            pstmt.setString(3, dto.getKorean());
            pstmt.setString(4, dto.getJlpt());
            
            result = pstmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt);
        }
        return result;
    }
    
    // 단어 수정 (word_id 기준)
    public int updateWord(WordDTO dto) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE JAPANESE_WORD "
                   + "SET word=?, doc=?, korean=?, jlpt=? "
                   + "WHERE word_id=?";

        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, dto.getWord());
            pstmt.setString(2, dto.getDoc());
            pstmt.setString(3, dto.getKorean());
            pstmt.setString(4, dto.getJlpt());
            pstmt.setInt(5, dto.getWord_id());

            result = pstmt.executeUpdate();

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt);
        }

        return result;
    }

}
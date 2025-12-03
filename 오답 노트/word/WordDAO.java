package com.jdi.word;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpSession;

import com.jdi.util.DBM;





public class WordDAO {
	Connection conn=null;
	PreparedStatement pstmt= null;
	ResultSet rs =null;
	
	// 싱글톤 생성
	// 생성자--> 객체 생성 및 객체 생성시 초기화 시험문제에 나옴
	private WordDAO() {}
	
	private static WordDAO instance = new WordDAO();//자신의 객체 생성
	
	public static WordDAO getInstance() {
		return instance;
		
	}
	//검색 메소드
	// ★ 고급 검색 메소드 (정확도 우선 정렬 + 뜻 검색 포함) ★
    public ArrayList<WordDTO> searchWords(String keyword) {
        ArrayList<WordDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM japanese_word "
                   + "WHERE word LIKE ? OR korean LIKE ? OR jlpt LIKE ? "
                   + "ORDER BY (CASE WHEN word = ? THEN 0 ELSE 1 END), LENGTH(word)";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            // 1. 첫 번째 ? : 단어 포함 검색 (%검색어%)
            pstmt.setString(1, "%" + keyword + "%");
            // 2. 두 번째 ? : 뜻(한국어) 포함 검색 (%검색어%)
            pstmt.setString(2, "%" + keyword + "%");
            // 3. 세 번째 ? : 정렬을 위한 '정확한 단어' (순수 검색어)
            pstmt.setString(3, keyword);
            pstmt.setString(4, keyword);
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                WordDTO dto = new WordDTO();
                dto.setWord_id(rs.getInt("word_id"));
                dto.setWord(rs.getString("word"));      // 한자
                dto.setDoc(rs.getString("doc"));        // 음독 (컬럼명 doc)
                dto.setKorean(rs.getString("korean"));  // 뜻 (컬럼명 korean)
                dto.setJlpt(rs.getString("jlpt"));      // 급수
                
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt, rs); 
        }
        
        return list;
    }
    //랜덤 단어 띄우는 메소드
    public WordDTO getRandomWord() {
    	 WordDTO dto = null;
        // 랜덤으로 섞어서 맨 위 1개만 가져오기
        String sql = "SELECT * FROM japanese_word ORDER BY RAND() LIMIT 1";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
            	dto = new WordDTO(); 
            	dto.setWord_id(rs.getInt("word_id"));
                dto.setWord(rs.getString("word"));      // 한자
                dto.setDoc(rs.getString("doc"));        // 읽기
                dto.setKorean(rs.getString("korean"));  // 뜻
                dto.setJlpt(rs.getString("jlpt"));      // 급수
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt, rs);
        }
        
        return dto;
    }
    //jlpt 급수별 단어 검색
    public ArrayList<WordDTO> JlptSearch(String jlpt) {
        ArrayList<WordDTO> list = new ArrayList<>();
        String sql = "select * from japanese_word where jlpt=?";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, "%" + jlpt + "%");
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                WordDTO dto = new WordDTO();
                dto.setWord_id(rs.getInt("word_id"));
                dto.setWord(rs.getString("word"));      // 한자
                dto.setDoc(rs.getString("doc"));        // 음독 (컬럼명 doc)
                dto.setKorean(rs.getString("korean"));  // 뜻 (컬럼명 korean)
                dto.setJlpt(rs.getString("jlpt"));      // 급수
                
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt, rs);
        }
        
        return list;
    }
	 // 퀴즈 관리 (세션을 받아서 처리해주는 헬퍼 메소드)
    public void setTodayQuiz(HttpSession session) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());

        String sessionDate = (String) session.getAttribute("quizDate");

        // 오늘 날짜와 세션 날짜가 다르면 새로운 퀴즈 생성
        if (sessionDate == null || !today.equals(sessionDate)) {
            WordDTO randomWord = getRandomWord(); // DB에서 랜덤 단어 가져오기

            if (randomWord != null) {
                session.setAttribute("quizWord", randomWord);
            } else {
                WordDTO defaultWord = new WordDTO();
                defaultWord.setWord("단어 없음");
                defaultWord.setKorean("DB에 단어가 없습니다");
                session.setAttribute("quizWord", defaultWord);
            }

            session.setAttribute("quizDate", today); // 오늘 날짜 기록
        } else {
            // 이미 오늘의 퀴즈가 있으면 아무 작업도 안 함
            System.out.println("오늘의 퀴즈 이미 존재: " + session.getAttribute("quizWord"));
        }
    }
	  //word_id로 검색
		public WordDTO wordSelect(int word_id){
			WordDTO dto = new WordDTO();
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
		
	
}

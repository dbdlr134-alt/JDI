package com.jdi.quiz;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.jdi.util.DBM;



public class QuizDAO {
	Connection conn=null;
	PreparedStatement pstmt= null;
	ResultSet rs =null;
	
	// 싱글톤 생성
	// 생성자--> 객체 생성 및 객체 생성시 초기화 시험문제에 나옴
	private QuizDAO() {}
	
	private static QuizDAO instance = new QuizDAO();//자신의 객체 생성
	
	public static QuizDAO getInstance() {
		return instance;
}
	//퀴즈 5개 랜덤으로 가져오기
	public List<QuizDTO> getRandomQuiz(String jlpt) {
		List<QuizDTO> list = new ArrayList<>();
		
		String sql= "SELECT * FROM jquiz  where jlpt=? ORDER BY RAND() LIMIT 10";
		
		try {
			conn= DBM.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, jlpt);
			rs= pstmt.executeQuery();
			
			while(rs.next()) {
				QuizDTO dto= new QuizDTO();
				dto.setQuiz_id(rs.getInt("quiz_id"));;
				dto.setWord(rs.getString("word"));   
				dto.setJlpt(rs.getString("jlpt"));
				dto.setSelection1(rs.getString("selection1"));
				dto.setSelection2(rs.getString("selection2"));
				dto.setSelection3(rs.getString("selection3"));
				dto.setSelection4(rs.getString("selection4"));
				dto.setAnswer(rs.getString("answer"));
				list.add(dto);
			}
			
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBM.close(conn, pstmt, rs);
		}
		return list;
	}
	//db에 오답 입력
	public void addIncorrectNote(String userId, int quizId) {
	    // 1. 없으면 넣고(INSERT), 있으면 날짜만 수정해라(ON DUPLICATE KEY UPDATE)
	    String sql = "INSERT INTO incorrect_note (jdi_user, quiz_id, wrong_date) "
	               + "VALUES (?, ?, NOW()) "
	               + "ON DUPLICATE KEY UPDATE wrong_date = NOW()";
	    
	    try {
	        conn = DBM.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId); // 회원 ID
	        pstmt.setInt(2, quizId);    // 문제 번호
	        
	        pstmt.executeUpdate();
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBM.close(conn, pstmt, rs);
	    }
	}
	//오답 노트
	public List<QuizDTO> getIncorrectNotes(String userId) {
	    List<QuizDTO> list = new ArrayList<>();
	    
	    String sql = "SELECT w.word_id, q.word, w.doc, w.korean, n.wrong_count, n.wrong_date "
	               + "FROM incorrect_note n "
	               + "JOIN jquiz q ON n.quiz_id = q.quiz_id "
	               + "LEFT JOIN JAPANESE_WORD w ON q.word = w.word " 
	               + "WHERE n.jdi_user = ? "
	               + "ORDER BY n.wrong_date DESC";
	    
	    try {
	    	conn = DBM.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	            QuizDTO dto = new QuizDTO();
	            dto.setWord_id(rs.getInt("word_id"));
	            dto.setWord(rs.getString("word"));  	 
	            String doc = rs.getString("doc");
	            String kor = rs.getString("korean");
	            dto.setDoc(doc == null ? "-" : doc);
	            dto.setKorean(kor == null ? "뜻 정보 없음" : kor);
	            
	            dto.setWrong_count(rs.getInt("wrong_count"));
	            dto.setWrong_date(rs.getString("wrong_date"));
	            
	            list.add(dto);
	        }
	        // ★ 리스트 크기 확인
	        System.out.println("가져온 오답 개수: " + list.size());
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBM.close(conn, pstmt, rs);
	    }
	    
	    return list;
	}
	
}	

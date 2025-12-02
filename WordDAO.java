package com.jdi.word;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

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
                   + "WHERE word LIKE ? OR korean LIKE ? "
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
            DBM.close(conn, pstmt, rs); // DBM에 3개짜리 close 메소드가 있다고 가정
        }
        
        return list;
    }
		
	
}

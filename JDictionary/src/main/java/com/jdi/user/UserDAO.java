package com.jdi.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.jdi.util.DBM; // 제공해주신 DBM 클래스 임포트

public class UserDAO {
    
    // 로그인 기능
    public UserDTO loginCheck(String id, String pw) {
        UserDTO user = null;
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // 쿼리문: 아이디와 비번이 같은 사람이 있는지 조회
        String sql = "SELECT * FROM jdi_login WHERE jdi_user = ? AND jdi_pass = ?";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            
            rs = pstmt.executeQuery();
            
            // 결과가 있다면(로그인 성공), DTO에 정보를 담는다
            if(rs.next()) {
                user = new UserDTO();
                user.setJdi_user(rs.getString("jdi_user"));
                user.setJdi_pass(rs.getString("jdi_pass"));
                user.setJdi_name(rs.getString("jdi_name"));
                user.setJdi_email(rs.getString("jdi_email"));
                user.setJdi_phone(rs.getString("jdi_phone"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // DBM에 있는 close 메소드 활용
            DBM.close(conn, pstmt, rs);
        }
        
        return user; // 실패하면 null, 성공하면 정보가 담긴 객체 리턴
    }
}
package com.jdi.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.jdi.util.DBM; // 제공해주신 DBM 클래스 임포트
import com.jdi.util.SHA256;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.service.DefaultMessageService;

public class UserDAO {
    
	// 1. 회원가입 메서드 수정
	public int joinUser(UserDTO dto) {
	    int result = 0;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "INSERT INTO jdi_login VALUES (?, ?, ?, ?, ?)"; // 컬럼 순서 주의
	    
	    try {
	        conn = DBM.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        
	        pstmt.setString(1, dto.getJdi_user());
	        
	        // ★★★ [변경] 비밀번호 암호화 적용 ★★★
	        // 사용자가 입력한 비번(1234) -> 암호화(a6xn...) -> DB 저장
	        String securePw = SHA256.encodeSha256(dto.getJdi_pass());
	        pstmt.setString(2, securePw); 
	        
	        pstmt.setString(3, dto.getJdi_name());
	        pstmt.setString(4, dto.getJdi_email());
	        pstmt.setString(5, dto.getJdi_phone());
	        
	        result = pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBM.close(conn, pstmt);
	    }
	    return result;
	}

	// 2. 로그인 메서드 수정
	public UserDTO loginCheck(String id, String pw) {
	    UserDTO user = null;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    // DB에는 암호화된 비번이 있으므로, 입력받은 비번도 암호화해서 비교해야 함
	    String sql = "SELECT * FROM jdi_login WHERE jdi_user = ? AND jdi_pass = ?";
	    
	    try {
	        conn = DBM.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        
	        pstmt.setString(1, id);
	        
	        // ★★★ [변경] 입력받은 비번을 암호화해서 비교 ★★★
	        String securePw = SHA256.encodeSha256(pw);
	        pstmt.setString(2, securePw);
	        
	        rs = pstmt.executeQuery();
	        
	        if(rs.next()) {
	            user = new UserDTO();
	            user.setJdi_user(rs.getString("jdi_user"));
	            // 비밀번호는 굳이 가져올 필요 없지만, 가져온다면 암호화된 상태임
	            user.setJdi_name(rs.getString("jdi_name"));
	            user.setJdi_email(rs.getString("jdi_email"));
	            user.setJdi_phone(rs.getString("jdi_phone"));
	            user.setJdi_profile(rs.getString("jdi_profile"));
	            user.setJdi_role(rs.getString("jdi_role"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBM.close(conn, pstmt, rs);
	    }
	    return user;
	}
 // ★★★ [신규] 인증번호 생성 및 발송 기능 ★★★
    // 기능: 랜덤 번호를 만들어서 문자로 보내고, 그 번호를 리턴해줍니다.
    public int sendSmsAndGetCode(String userPhone) {
        
        // 1. 랜덤 인증번호 생성 (1000 ~ 9999)
        int randomCode = (int)(Math.random() * 8999) + 1000;
        
        // 2. 발송 로직 (CoolSMS)
        try {
            // =========================================================
            // [API 설정] 발급받은 키를 여기에 넣으세요
            DefaultMessageService messageService = NurigoApp.INSTANCE.initialize("NCSJDONCTN2IMRMR", "BPTVHSKTAXBMETVZCMXAOBJVQMURPJUL", "https://api.coolsms.co.kr");

            Message message = new Message();
            message.setFrom("01065613724"); // [중요] 내 발신번호 (하이픈 제외)
            message.setTo(userPhone.replaceAll("-", "")); 
            message.setText("[My J-Dic] 인증번호: " + randomCode);

            // 실제 전송 (비용 발생)
            messageService.sendOne(new SingleMessageSendingRequest(message));
            System.out.println(">> [CoolSMS] 문자 전송 완료!");
            // =========================================================
            
        } catch (Exception e) {
            // 라이브러리가 없거나 전송 실패시 여기로 옴
            System.out.println(">> [전송 실패/라이브러리 없음] 콘솔 모드로 대체합니다.");
            e.printStackTrace();
        }

        // 3. 콘솔에도 무조건 찍어줌 (테스트용)
        System.out.println("=================================");
        System.out.println(" 생성된 인증번호 : [" + randomCode + "]");
        System.out.println("=================================");
        
        // 4. 생성된 번호를 컨트롤러에게 보고
        return randomCode;
      
    }
 // UserDAO 클래스 안에 추가

 // 1. 비밀번호 확인용 (boolean 리턴)
 public boolean checkPassword(String id, String inputPw) {
     boolean isCorrect = false;
     Connection conn = null;
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     String sql = "SELECT count(*) FROM jdi_login WHERE jdi_user = ? AND jdi_pass = ?";
     
     try {
         conn = DBM.getConnection();
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, id);
         // 입력받은 비번을 암호화해서 비교
         pstmt.setString(2, com.jdi.util.SHA256.encodeSha256(inputPw));
         
         rs = pstmt.executeQuery();
         if(rs.next() && rs.getInt(1) == 1) {
             isCorrect = true;
         }
     } catch (Exception e) { e.printStackTrace(); }
     finally { DBM.close(conn, pstmt, rs); }
     return isCorrect;
 }

 // 2. 통합 정보 수정 (비밀번호 변경 포함/미포함 처리)
 public int updateAll(String id, String name, String phone, String email, String newPw, String profile) {
     int result = 0;
     Connection conn = null;
     PreparedStatement pstmt = null;
     String sql = "";
     
     try {
         conn = DBM.getConnection();
         
         if(newPw == null || newPw.equals("")) {
             // 비번 변경 X -> 프로필 컬럼(jdi_profile) 추가
             sql = "UPDATE jdi_login SET jdi_name=?, jdi_phone=?, jdi_email=?, jdi_profile=? WHERE jdi_user=?";
             pstmt = conn.prepareStatement(sql);
             pstmt.setString(1, name);
             pstmt.setString(2, phone);
             pstmt.setString(3, email);
             pstmt.setString(4, profile); // ★ 추가
             pstmt.setString(5, id);
         } else {
             // 비번 변경 O -> 프로필 컬럼(jdi_profile) 추가
             sql = "UPDATE jdi_login SET jdi_name=?, jdi_phone=?, jdi_email=?, jdi_pass=?, jdi_profile=? WHERE jdi_user=?";
             pstmt = conn.prepareStatement(sql);
             pstmt.setString(1, name);
             pstmt.setString(2, phone);
             pstmt.setString(3, email);
             pstmt.setString(4, com.jdi.util.SHA256.encodeSha256(newPw));
             pstmt.setString(5, profile); // ★ 추가
             pstmt.setString(6, id);
         }
         result = pstmt.executeUpdate();
         
     } catch (Exception e) { e.printStackTrace(); }
     finally { DBM.close(conn, pstmt); }
     return result;
 }
}
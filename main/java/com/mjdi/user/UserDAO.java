package com.mjdi.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mjdi.util.DBM;
import com.mjdi.util.SHA256;

// CoolSMS (Nurigo) SDK 관련 임포트
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.service.DefaultMessageService;

public class UserDAO {
    
    // --- API 설정 (본인의 키로 교체 필요) ---
    private static final String API_KEY = "NCSJDONCTN2IMRMR"; // 실제 API Key
    private static final String API_SECRET = "BPTVHSKTAXBMETVZCMXAOBJVQMURPJUL"; // 실제 API Secret
    private static final String SENDER_PHONE = "01065613724"; // 발신번호 (하이픈 제외)

    // ==========================================
    // 1. 회원가입 (INSERT)
    // ==========================================
    public int joinUser(UserDTO dto) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        // jdi_profile, jdi_role은 DB 기본값 사용 (SQL에서 제외)
        String sql = "INSERT INTO jdi_login (jdi_user, jdi_pass, jdi_name, jdi_email, jdi_phone) VALUES (?, ?, ?, ?, ?)";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, dto.getJdi_user());
            // 비밀번호 암호화 저장
            pstmt.setString(2, SHA256.encodeSha256(dto.getJdi_pass())); 
            pstmt.setString(3, dto.getJdi_name());
            pstmt.setString(4, dto.getJdi_email());
            pstmt.setString(5, dto.getJdi_phone());
            
            result = pstmt.executeUpdate();
            
        } catch (Exception e) {
            System.out.println(">> [UserDAO] 회원가입 실패:");
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt);
        }
        return result;
    }

    // ==========================================
    // 2. 로그인 체크 (SELECT)
    // ==========================================
    public UserDTO loginCheck(String id, String pw) {
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM jdi_login WHERE jdi_user = ? AND jdi_pass = ?";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            // 입력받은 비밀번호를 암호화하여 비교
            pstmt.setString(2, SHA256.encodeSha256(pw));
            
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                user = new UserDTO();
                user.setJdi_user(rs.getString("jdi_user"));
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

    // ==========================================
    // 3. 비밀번호 확인 (정보수정 진입용)
    // ==========================================
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
            pstmt.setString(2, SHA256.encodeSha256(inputPw));
            
            rs = pstmt.executeQuery();
            if(rs.next() && rs.getInt(1) == 1) {
                isCorrect = true;
            }
        } catch (Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }
        
        return isCorrect;
    }

    // ==========================================
    // 4. 회원정보 전체 수정 (프로필 포함)
    // ==========================================
    public int updateAll(String id, String name, String phone, String email, String newPw, String profile) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "";
        
        try {
            conn = DBM.getConnection();
            
            if(newPw == null || newPw.equals("")) {
                // 비밀번호 변경 안 함
                sql = "UPDATE jdi_login SET jdi_name=?, jdi_phone=?, jdi_email=?, jdi_profile=? WHERE jdi_user=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setString(2, phone);
                pstmt.setString(3, email);
                pstmt.setString(4, profile);
                pstmt.setString(5, id);
            } else {
                // 비밀번호 변경 함 (암호화 필수)
                sql = "UPDATE jdi_login SET jdi_name=?, jdi_phone=?, jdi_email=?, jdi_pass=?, jdi_profile=? WHERE jdi_user=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setString(2, phone);
                pstmt.setString(3, email);
                pstmt.setString(4, SHA256.encodeSha256(newPw));
                pstmt.setString(5, profile);
                pstmt.setString(6, id);
            }
            result = pstmt.executeUpdate();
            
        } catch (Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt); }
        
        return result;
    }

    // ==========================================
    // 5. 아이디 찾기 (이름 + 이메일)
    // ==========================================
    public String findId(String name, String email) {
        String id = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT jdi_user FROM jdi_login WHERE jdi_name = ? AND jdi_email = ?";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                id = rs.getString("jdi_user");
            }
        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }
        return id;
    }

    // ==========================================
    // 6. 비밀번호 재설정 (전화번호 인증용)
    // ==========================================
    public int resetPasswordByPhone(String id, String name, String phone, String newPw) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = "UPDATE jdi_login SET jdi_pass = ? WHERE jdi_user = ? AND jdi_name = ? AND jdi_phone = ?";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            // 임시 비밀번호 암호화 저장
            pstmt.setString(1, SHA256.encodeSha256(newPw));
            pstmt.setString(2, id);
            pstmt.setString(3, name);
            pstmt.setString(4, phone);
            
            result = pstmt.executeUpdate();
        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt); }
        return result;
    }

    // ==========================================
    // 7. SMS 인증번호 발송 및 코드 반환
    // ==========================================
    public int sendSmsAndGetCode(String userPhone) {
        int randomCode = (int)(Math.random() * 8999) + 1000;
        
        try {
            DefaultMessageService messageService = NurigoApp.INSTANCE.initialize(API_KEY, API_SECRET, "https://api.coolsms.co.kr");
            Message message = new Message();
            message.setFrom(SENDER_PHONE);
            message.setTo(userPhone.replaceAll("-", "")); 
            message.setText("[My J-Dic] 인증번호: " + randomCode);

            messageService.sendOne(new SingleMessageSendingRequest(message));
            System.out.println(">> [SMS] 전송 완료: " + randomCode);
            
        } catch (Exception e) {
            System.out.println(">> [SMS 실패] 콘솔 모드 전환");
            e.printStackTrace();
        }

        // 테스트 편의를 위해 콘솔에도 출력
        System.out.println("-------------------------");
        System.out.println(" [테스트] 인증번호: " + randomCode);
        System.out.println("-------------------------");
        
        return randomCode;
    }

    // ==========================================
    // 8. 일반 SMS 문자 발송 (임시 비번 알림용)
    // ==========================================
    public void sendSmsMessage(String userPhone, String msgText) {
        try {
            DefaultMessageService messageService = NurigoApp.INSTANCE.initialize(API_KEY, API_SECRET, "https://api.coolsms.co.kr");
            Message message = new Message();
            message.setFrom(SENDER_PHONE);
            message.setTo(userPhone.replaceAll("-", "")); 
            message.setText(msgText);

            messageService.sendOne(new SingleMessageSendingRequest(message));
            System.out.println(">> [SMS 발송] " + msgText);
            
        } catch (Exception e) {
            System.out.println(">> [SMS 실패] 콘솔 출력 대체");
            System.out.println("TO: " + userPhone + " / MSG: " + msgText);
        }
    }
}
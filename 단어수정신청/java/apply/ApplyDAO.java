package com.jdi.apply;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.jdi.util.DBM;

public class ApplyDAO {
    
    // 싱글톤 패턴
    private ApplyDAO() {}
    private static ApplyDAO instance = new ApplyDAO();
    public static ApplyDAO getInstance() { return instance; }

    // 단어 신청 등록 (INSERT)
    public int insertApply(ApplyDTO dto) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO jdi_word_req (word, doc, korean, jlpt, jdi_user) VALUES (?, ?, ?, ?, ?)";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, dto.getWord());
            pstmt.setString(2, dto.getDoc());
            pstmt.setString(3, dto.getKorean());
            pstmt.setString(4, dto.getJlpt());
            pstmt.setString(5, dto.getJdiUser());
            
            result = pstmt.executeUpdate();
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt);
        }
        return result;
    }
 // 1. 대기중인 신청 목록 가져오기 (WAIT 상태인 것만)
    public ArrayList<ApplyDTO> getWaitList() {
        ArrayList<ApplyDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM jdi_word_req WHERE status = 'WAIT' ORDER BY req_id DESC";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                ApplyDTO dto = new ApplyDTO();
                dto.setReqId(rs.getInt("req_id"));
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setJlpt(rs.getString("jlpt"));
                dto.setJdiUser(rs.getString("jdi_user"));
                dto.setRegDate(rs.getString("reg_date"));
                list.add(dto);
            }
        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }
        return list;
    }

    // 2. 신청 정보 1개 자세히 가져오기 (승인할 때 데이터 옮겨야 해서 필요)
    public ApplyDTO getApply(int reqId) {
        ApplyDTO dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM jdi_word_req WHERE req_id = ?";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reqId);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                dto = new ApplyDTO();
                dto.setReqId(rs.getInt("req_id"));
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setJlpt(rs.getString("jlpt"));
                dto.setJdiUser(rs.getString("jdi_user"));
            }
        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }
        return dto;
    }

    // 3. 상태 변경 (OK 또는 NO로 변경)
    public int updateStatus(int reqId, String status) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE jdi_word_req SET status = ? WHERE req_id = ?";
        
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, reqId);
            result = pstmt.executeUpdate();
        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt); }
        return result;
    }
    
    
    // 수정 신청 INSERT
    public int insertEditApply(ApplyDTO dto) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO jdi_word_edit_request"
                   + "(word, doc, korean, jlpt, jdi_user, word_id, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, 'WAIT')";

        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, dto.getWord());
            pstmt.setString(2, dto.getDoc());
            pstmt.setString(3, dto.getKorean());
            pstmt.setString(4, dto.getJlpt());
            pstmt.setString(5, dto.getJdiUser());
            pstmt.setInt(6, dto.getWordId()); // ★ 수정 신청 핵심!

            result = pstmt.executeUpdate();

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt);
        }

        return result;
    }
    
 // 수정 신청 대기 목록 조회
    public ArrayList<ApplyDTO> getEditWaitList() {

        ArrayList<ApplyDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM jdi_word_edit_request "
                   + "WHERE status='WAIT' AND word_id IS NOT NULL "
                   + "ORDER BY req_id DESC";

        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while(rs.next()) {
                ApplyDTO dto = new ApplyDTO();

                dto.setReqId(rs.getInt("req_id"));
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setJlpt(rs.getString("jlpt"));
                dto.setJdiUser(rs.getString("jdi_user"));
                dto.setWordId(rs.getInt("word_id"));
                dto.setStatus(rs.getString("status"));

                list.add(dto);
            }

        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }

        return list;
    }
    
 // 수정 신청 단일 조회
    public ApplyDTO getEditApply(int reqId) {
        ApplyDTO dto = null;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM jdi_word_edit_request "
                   + "WHERE req_id=? AND word_id IS NOT NULL";

        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reqId);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                dto = new ApplyDTO();

                dto.setReqId(rs.getInt("req_id"));
                dto.setWord(rs.getString("word"));
                dto.setDoc(rs.getString("doc"));
                dto.setKorean(rs.getString("korean"));
                dto.setJlpt(rs.getString("jlpt"));
                dto.setJdiUser(rs.getString("jdi_user"));
                dto.setWordId(rs.getInt("word_id"));
                dto.setStatus(rs.getString("status"));
            }

        } catch(Exception e) { e.printStackTrace(); }
        finally { DBM.close(conn, pstmt, rs); }

        return dto;
    }
    // 수정 신청 승인 처리
    public void approveEditApply(ApplyDTO dto) {

        // 1. WordDAO로 원본 단어 수정
        com.jdi.word.WordDAO wdao = com.jdi.word.WordDAO.getInstance();

        com.jdi.word.WordDTO wordDto = new com.jdi.word.WordDTO();

        wordDto.setWord_id(dto.getWordId()); 
        wordDto.setWord(dto.getWord());
        wordDto.setDoc(dto.getDoc());
        wordDto.setKorean(dto.getKorean());
        wordDto.setJlpt(dto.getJlpt());

        wdao.updateWord(wordDto);  // 실제 DB 단어 수정

        // 2. 신청 상태 변경
        updateStatus(dto.getReqId(), "OK");
    }


}
package com.mjdi.notice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.mjdi.util.DBM;

public class NoticeDAO {
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
    // 싱글톤
    private NoticeDAO() {}
    private static NoticeDAO instance = new NoticeDAO();
    public static NoticeDAO getInstance() { 
    	return instance; 
    	}

 // 1. 모든 공지사항 조회
    public List<NoticeDTO> noticeList() {
        List<NoticeDTO> list = new ArrayList<>();
        String sql = "SELECT idx, title, content, created_at, is_top "
                   + "FROM jdi_notice "
                   + "ORDER BY is_top DESC, created_at DESC";

        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while(rs.next()) {
                NoticeDTO dto = new NoticeDTO();
                dto.setIdx(rs.getInt("idx"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreated_at(rs.getString("created_at"));
                dto.setIs_top(rs.getInt("is_top"));  // is_top 컬럼도 DTO에 저장

                list.add(dto);
            }

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt, rs);
        }
        return list;
    }


    //공지사항 상세보기(view)
    public NoticeDTO noticeView(int idx) {
    	NoticeDTO dto = new NoticeDTO();
    	String sql="select * from jdi_notice where idx=?";
    	try {
    		conn=DBM.getConnection();
    		pstmt=conn.prepareStatement(sql);
    		pstmt.setInt(1, idx);
    		
    		rs=pstmt.executeQuery();
    		
    		if(rs.next()) {
    			dto.setIdx(rs.getInt("idx"));
    			dto.setTitle(rs.getString("title"));
    			dto.setContent(rs.getString("content"));
    			dto.setCreated_at(rs.getString("created_at"));
    		}
    		
    	}catch(Exception e) {
    		e.printStackTrace();
    	}finally {
    		DBM.close(conn, pstmt,rs);
    	}
    	return dto;
    }
 
    //공지사항 등록
    public NoticeDTO noticeWrite(NoticeDTO dto) {
    	int row = 0;
    	String sql="INSERT INTO jdi_notice (title, content) "
    			+ "VALUES (?, ?)";
    	try {
    		conn=DBM.getConnection();
    		pstmt=conn.prepareStatement(sql);
    		pstmt.setString(1, dto.getTitle());
    		pstmt.setString(2, dto.getContent());
    		
    		row = pstmt.executeUpdate();
    		
    	}catch(Exception e) {
    		e.printStackTrace();
    	}finally {
    		DBM.close(conn, pstmt);
    	}
    	return dto;
    }
    
    //공지사항 삭제
    public int noticeDelete(int idx) {
    	int row =0;
    	String sql="delete from jdi_notice where idx=?";
    	try {
    		conn=DBM.getConnection();
    		pstmt=conn.prepareStatement(sql);
    		pstmt.setInt(1, idx);
    		
    		row = pstmt.executeUpdate();
    		
    	}catch(Exception e) {
    		e.printStackTrace();
    	}finally {
    		DBM.close(conn, pstmt);
    	}
    	return row;
    }
    
    public void noticeUpdate(NoticeDTO dto) {
        String sql = "UPDATE jdi_notice SET title=?, content=? WHERE idx=?";
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setInt(3, dto.getIdx());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt);
        }
    }
    
 // 공지글 상단 고정/해제
    public int setTopNotice(int idx, boolean isTop) {
        int row = 0;
        String sql = "UPDATE jdi_notice SET is_top = ? WHERE idx = ?";
        try {
            conn = DBM.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, isTop ? 1 : 0);
            pstmt.setInt(2, idx);
            row = pstmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBM.close(conn, pstmt);
        }
        return row;
    }
}

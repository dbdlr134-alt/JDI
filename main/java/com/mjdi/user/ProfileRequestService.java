package com.mjdi.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

public class ProfileRequestService implements Action {
    
    private static final int COST = 50; 

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDTO user = (UserDTO) request.getSession().getAttribute("sessionUser");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String userId = user.getJdi_user();
        PointDAO pointDao = PointDAO.getInstance();
        UserDAO userDao = new UserDAO();
        
        // 1. 포인트 잔액 확인
        if (!pointDao.checkPointSufficient(userId, COST)) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('포인트가 부족합니다! (" + COST + " P 필요)'); location.href='mypage.jsp';</script>");
            return;
        }

        // 2. 포인트 차감 실행
        int logResult = pointDao.addPoint(userId, -COST, "새 프로필 등록 신청");
        
        if (logResult <= 0) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('포인트 차감 중 오류가 발생했습니다.'); history.back();</script>");
            return; 
        }

        // 3. DB에 프로필 경로 업데이트 (새 사진이 등록된 것으로 간주)
        String newProfileName = "profile5.png"; // 새로운 프로필 파일명을 임의 지정
        int updateRes = userDao.updateProfile(userId, newProfileName);
        
        // 4. 세션 갱신 및 결과 처리
        if (updateRes > 0) {
            user.setJdi_profile(newProfileName); // 세션 업데이트
            
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('" + COST + " P 차감! 새로운 프로필 사진이 등록되었습니다.'); location.href='mypage.jsp';</script>");
        } else {
             response.getWriter().write("<script>alert('프로필 등록 중 오류가 발생했습니다.'); location.href='mypage.jsp';</script>");
        }
    }
}
package com.mjdi.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

public class UserLoginService implements Action {
    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String loginId = request.getParameter("id");
        String loginPw = request.getParameter("pw");
        
        UserDAO dao = new UserDAO();
        UserDTO user = dao.loginCheck(loginId, loginPw);
        
        String ctx = request.getContextPath(); // 프로젝트 절대 경로 (예: /MyJDic)
        
        if(user != null) {
            // 세션에 유저 정보 저장
            request.getSession().setAttribute("sessionUser", user);
            
            if("ADMIN".equals(user.getJdi_role())) {
                // ★ [수정] 관리자 메인 대시보드로 이동
                response.sendRedirect(ctx + "/admin/main.jsp");
            } else {
                // 일반 회원은 사용자 메인으로 이동
                response.sendRedirect(ctx + "/index.jsp");
            }
        } else {
            // 로그인 실패 시 다시 로그인 페이지로
            response.sendRedirect(ctx + "/login.jsp?error=1");
        }
    }
}
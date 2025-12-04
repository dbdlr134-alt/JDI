package com.mjdi.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

public class UserUpdateService implements Action {
    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uName = request.getParameter("name");
        String uPhone = request.getParameter("phone");
        String uEmail = request.getParameter("email");
        String uNewPw = request.getParameter("newPw");
        String uProfile = request.getParameter("profile");
        
        UserDTO currentUser = (UserDTO)request.getSession().getAttribute("sessionUser");
        UserDAO dao = new UserDAO();
        
        int updateRes = dao.updateAll(currentUser.getJdi_user(), uName, uPhone, uEmail, uNewPw, uProfile);
        
        if(updateRes > 0) {
            currentUser.setJdi_name(uName);
            currentUser.setJdi_phone(uPhone);
            currentUser.setJdi_email(uEmail);
            currentUser.setJdi_profile(uProfile);
            
            request.getSession().setAttribute("sessionUser", currentUser);
            request.getSession().removeAttribute("isPwdChecked");
            
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('수정되었습니다.'); location.href='mypage.jsp';</script>");
        } else {
            response.sendRedirect("edit_profile.jsp?error=fail");
        }
    }
}
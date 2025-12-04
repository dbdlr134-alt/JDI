package com.mjdi.apply;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.user.UserDTO;
import com.mjdi.util.Action;

public class ApplyEditRequestService implements Action {
    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDTO user = (UserDTO)request.getSession().getAttribute("sessionUser");
        if(user == null) {
            response.sendRedirect("login.jsp"); return;
        }

        ApplyDTO dto = new ApplyDTO();
        dto.setWordId(Integer.parseInt(request.getParameter("word_id")));
        dto.setWord(request.getParameter("word"));
        dto.setDoc(request.getParameter("doc"));
        dto.setKorean(request.getParameter("korean"));
        dto.setJlpt(request.getParameter("jlpt"));
        dto.setJdiUser(user.getJdi_user());

        ApplyDAO.getInstance().insertEditApply(dto);

        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().write("<script>alert('수정 신청이 등록되었습니다'); location.href='WordController?cmd=main';</script>");
    }
}
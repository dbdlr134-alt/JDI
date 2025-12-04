package com.mjdi.apply;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

public class ApplyEditApproveService implements Action {
    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reqId = Integer.parseInt(request.getParameter("id"));
        ApplyDAO dao = ApplyDAO.getInstance();
        ApplyDTO dto = dao.getEditApply(reqId);
        
        if(dto != null) {
            dao.approveEditApply(dto); // 실제 DB 수정
        }
        response.sendRedirect("adminEditList.apply");
    }
}
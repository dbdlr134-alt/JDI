package com.mjdi.apply;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

public class ApplyEditRejectService implements Action {
    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int reqId = Integer.parseInt(request.getParameter("id"));
        ApplyDAO.getInstance().updateEditStatus(reqId, "NO"); 
        response.sendRedirect("adminEditList.apply");
    }
}
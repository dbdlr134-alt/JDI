package com.mjdi.notice;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

public class NoticeWriteProService implements Action {

	@Override
	public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		
		NoticeDAO dao = NoticeDAO.getInstance();
		NoticeDTO dto = new NoticeDTO();
		
		dto.setTitle(request.getParameter("title"));
		dto.setContent(request.getParameter("content"));
		
		NoticeDTO row = dao.noticeWrite(dto);
		
		String ctx = request.getContextPath(); // 프로젝트 context path
		response.sendRedirect(ctx + "/adminMain.apply?cmd=/adminMain.apply");
	}

}

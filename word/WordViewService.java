package com.jdi.word;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jdi.util.Action;

public class WordViewService implements Action {

	@Override
	public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int word_id = Integer.parseInt(request.getParameter("word_id"));
		
		String query = request.getParameter("query");
		
		WordDAO dao = WordDAO.getInstance();
		ArrayList<WordDTO> list = dao.searchWords(query);
		WordDTO vDto = dao.wordSelect(word_id);
		//자동완성용 리스트 (최대 10개)
		 ArrayList<WordDTO> autoList = new ArrayList<>();
		
		
		request.setAttribute("vDto", vDto);
		request.setAttribute("searchQuery", query);
		 request.setAttribute("autoList", autoList);
		
		request.getRequestDispatcher("word_view.jsp").forward(request, response);

	}

}

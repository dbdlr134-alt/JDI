package com.jdi.word;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jdi.util.Action;

public class WordSearchService implements Action {

	@Override
	public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 검색어(query) 파라미터 받기
		String query = request.getParameter("query");
		
		// 2. DAO 생성 및 검색 실행
		WordDAO dao =WordDAO.getInstance();
		ArrayList<WordDTO> list = dao.searchWords(query);
		
		// 3. 결과 데이터를 request 영역에 저장
		request.setAttribute("wordList", list);
		request.setAttribute("searchQuery", query); // 검색어도 화면에 다시 보여주기 위해 저장
		
		// 4. 결과 보여줄 페이지(result.jsp)로 이동
		// 경로는 프로젝트 구조에 맞춰서 수정해 (예: /word/result.jsp 등)
		request.getRequestDispatcher("index.jsp").forward(request, response);

	}

}

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
        WordDAO dao = WordDAO.getInstance();
        ArrayList<WordDTO> list = dao.searchWords(query);

        // 3. 검색 결과와 검색어를 request 영역에 저장
        request.setAttribute("wordList", list);
        request.setAttribute("searchQuery", query);

        // 4. 세션을 이용한 오늘의 퀴즈 설정
        dao.setTodayQuiz(request.getSession());

        // 5. 결과 보여줄 페이지(index.jsp)로 이동
        request.getRequestDispatcher("index.jsp").forward(request, response);
	}

}

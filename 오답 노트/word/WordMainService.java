package com.jdi.word;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jdi.util.Action;

public class WordMainService implements Action {

	@Override
	public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		WordDAO.getInstance().setTodayQuiz(request.getSession());
        
        request.getRequestDispatcher("index.jsp").forward(request, response);

	}

}

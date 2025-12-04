package com.mjdi.word;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

public class WordViewService implements Action {
    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("word_id");
        String query = request.getParameter("query");
        
        int word_id = 0;
        if(idStr != null && !idStr.isEmpty()) {
            word_id = Integer.parseInt(idStr);
        }
        
        WordDAO dao = WordDAO.getInstance();
        WordDTO vDto = dao.wordSelect(word_id);
        
        request.setAttribute("vDto", vDto);
        request.setAttribute("searchQuery", query);
        
        // ★ [수정] 경로 변경: word_view.jsp -> word/word_view.jsp
        request.getRequestDispatcher("word/word_view.jsp").forward(request, response);
    }
}
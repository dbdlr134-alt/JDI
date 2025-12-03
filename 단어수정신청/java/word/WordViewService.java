package com.jdi.word;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.jdi.util.Action;

public class WordViewService implements Action {

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 파라미터 받기 (word_id는 필수, query는 검색 목록 돌아갈 때 필요)
        String idStr = request.getParameter("word_id");
        String query = request.getParameter("query");
        
        int word_id = 0;
        if(idStr != null && !idStr.isEmpty()) {
            word_id = Integer.parseInt(idStr);
        }
        
        // 2. DAO를 통해 단어 상세 정보 가져오기
        WordDAO dao = WordDAO.getInstance();
        WordDTO vDto = dao.wordSelect(word_id);
        
        // 3. JSP로 데이터 넘겨주기
        request.setAttribute("vDto", vDto);       // 단어 객체
        request.setAttribute("searchQuery", query); // 검색어 유지용
        
        // 4. 페이지 이동
        request.getRequestDispatcher("word_view.jsp").forward(request, response);
    }
}
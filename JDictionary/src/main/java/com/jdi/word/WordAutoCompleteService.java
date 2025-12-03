package com.jdi.word;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson; // Gson 라이브러리 필요
import com.jdi.util.Action;

public class WordAutoCompleteService implements Action {

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String key = request.getParameter("key");
        
        WordDAO dao = WordDAO.getInstance();
        List<WordDTO> list = dao.autoComplete(key);

        // 자바 리스트를 JSON 문자열로 변환 (예: [{"word":"学生","korean":"학생"}, ...])
        Gson gson = new Gson();
        String json = gson.toJson(list);

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
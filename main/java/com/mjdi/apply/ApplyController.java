package com.mjdi.apply;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

@WebServlet("*.apply")
public class ApplyController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 1. 커맨드 추출
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String cmd = uri.substring(ctx.length());
        
        System.out.println(">> ApplyController 요청: " + cmd); // 로그 확인용

        // 2. 팩토리에서 서비스 가져오기
        ApplyServiceFactory factory = ApplyServiceFactory.getInstance();
        Action action = factory.getAction(cmd);

        // 3. 서비스 실행
        if (action != null) {
            action.process(request, response);
        } else {
            System.out.println(">> 잘못된 요청입니다: " + cmd);
            response.sendRedirect("index.jsp");
        }
    }
}
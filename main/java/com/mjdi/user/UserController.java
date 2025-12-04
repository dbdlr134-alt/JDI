package com.mjdi.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mjdi.util.Action;

@WebServlet("*.do")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        String command = uri.substring(ctx.length());
        
        System.out.println(">> UserController 요청: " + command);
        
        UserServiceFactory factory = UserServiceFactory.getInstance();
        Action action = factory.getAction(command);
        
        if (action != null) {
            action.process(request, response);
        } else {
            System.out.println(">> 잘못된 요청입니다: " + command);
            response.sendRedirect("index.jsp");
        }
    }
}
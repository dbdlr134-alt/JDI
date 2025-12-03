package com.jdi.word;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jdi.util.Action;

/**
 * Servlet implementation class WordController
 */
@WebServlet("/WordController")
public class WordController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public WordController() {
        super();
    }

	/**
	 * service 메서드는 GET, POST 요청을 모두 받아서 처리합니다.
	 * 따라서 doGet, doPost를 따로 만들 필요가 없습니다.
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 한글 인코딩 처리 (POST 요청 대비)
		request.setCharacterEncoding("UTF-8");
		
		// 2. cmd 파라미터 받기 (없으면 main으로 간주)
		String cmd = request.getParameter("cmd");
		if(cmd == null) cmd = "main";
		
		System.out.println("WordController 요청: " + cmd);
		
		// 3. 팩토리를 통해 일할 서비스 배정 (Factory Pattern)
		WordServiceFactory wf = WordServiceFactory.getInstance();
		Action action = wf.action(cmd);
		
		// 4. 서비스 실행 (Command Pattern)
		if(action != null) {
			action.process(request, response);
		} else {
			// 잘못된 cmd가 들어왔을 때 처리 (예: 에러페이지 또는 메인으로)
			System.out.println("잘못된 요청입니다: " + cmd);
			response.sendRedirect("WordController?cmd=main");
		}
	}

}
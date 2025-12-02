package com.jdi.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// 핵심: *.do로 끝나는 모든 요청을 이 녀석이 다 받습니다.
@WebServlet("*.do")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 1. 한글 깨짐 방지 (가장 먼저!)
		request.setCharacterEncoding("UTF-8");
		
		// 2. 어떤 요청이 들어왔는지 주소 분석 (Routing)
		// 예: http://localhost:8080/프로젝트명/login.do -> "/login.do"만 잘라냄
		String uri = request.getRequestURI();
		String ctx = request.getContextPath();
		String command = uri.substring(ctx.length());
		
		System.out.println("접속 요청: " + command); // 콘솔에서 확인용
		
		UserDAO dao = new UserDAO();
		
		// 3. 주소에 따른 분기 처리 (Switch-Case)
		switch(command) {
		
			// === [1] 로그인 처리 ===
			case "/login.do":
				String id = request.getParameter("id");
				String pw = request.getParameter("pw");
				
				UserDTO user = dao.loginCheck(id, pw);
				
				if(user != null) {
					// 로그인 성공: 세션에 담고 메인으로
					HttpSession session = request.getSession();
					session.setAttribute("sessionUser", user);
					response.sendRedirect("index.jsp");
				} else {
					// 로그인 실패: 다시 로그인창으로 (에러코드 전달)
					response.sendRedirect("login.jsp?error=1");
				}
				break;
				
			// === [2] 로그아웃 처리 ===
			case "/logout.do":
				HttpSession session = request.getSession();
				session.invalidate(); // 세션 전체 삭제 (로그아웃)
				response.sendRedirect("index.jsp"); // 메인으로 튕기기
				break;
				
			// === [3] 회원가입 (나중에 만들 것) ===
			case "/join.do":
				// 나중에 여기에 회원가입 로직 추가
				break;
				
		} // switch 끝
	}
}
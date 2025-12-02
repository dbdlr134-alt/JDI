package com.jdi.user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login.do") // 이 주소로 요청이 들어오면 작동
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 한글 처리
		request.setCharacterEncoding("UTF-8");
		
		// 2. JSP(화면)에서 보낸 아이디, 비번 받기
		String userId = request.getParameter("id");
		String userPw = request.getParameter("pw");
		
		// 3. DAO 불러서 로그인 체크 시키기
		UserDAO dao = new UserDAO();
		UserDTO loginUser = dao.loginCheck(userId, userPw);
		
		// 4. 결과에 따라 처리
		if(loginUser != null) {
			// 성공: 세션(Session)에 회원 정보 저장 -> 브라우저 닫을 때까지 유지됨
			HttpSession session = request.getSession();
			session.setAttribute("sessionUser", loginUser);
			
			// 메인 페이지로 이동
			response.sendRedirect("index.jsp");
		} else {
			// 실패: 로그인 페이지로 다시 보냄 (에러 메시지용 신호 추가)
			response.sendRedirect("login.jsp?error=1");
		}
	}
}
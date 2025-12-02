package com.jdi.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// 주소는 *.do로 통일
@WebServlet("*.do")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		
		// 주소 분석
		String uri = request.getRequestURI();
		String ctx = request.getContextPath();
		String command = uri.substring(ctx.length());
		
		System.out.println("요청 도착: " + command); // 디버깅용
		
		UserDAO dao = new UserDAO();
		
		
		switch(command) {
		
			// [1] 문자 발송 요청 (이제 아주 간단해졌습니다!)
			case "/sendSms.do":
				String phone = request.getParameter("phone");
				
				// DAO야, 문자 좀 보내고 번호 뭔지 알려줘.
				int authNum = dao.sendSmsAndGetCode(phone);
				
				// 알려준 번호를 세션(서버 메모리)에 저장 (나중에 검사하려고)
				HttpSession session = request.getSession();
				session.setAttribute("savedAuthNum", authNum);
				
				// 성공했다고 응답
				response.getWriter().write("success");
				break;
				
				
			// [2] 인증번호 확인 요청
			case "/checkSms.do":
				String userCode = request.getParameter("code"); // 사용자가 입력한 거
				Integer realCode = (Integer)request.getSession().getAttribute("savedAuthNum"); // 세션에 있는 거
				
				if(realCode != null && userCode.equals(String.valueOf(realCode))) {
					response.getWriter().write("ok");
				} else {
					response.getWriter().write("fail");
				}
				break;
				
				
			// [3] 회원가입 요청
			case "/join.do":
				String joinId = request.getParameter("id");
				String joinPw = request.getParameter("pw");
				String joinName = request.getParameter("name");
				String joinEmail = request.getParameter("email");
				String joinPhone = request.getParameter("phone");
				
				UserDTO joinDto = new UserDTO(joinId, joinPw, joinName, joinEmail, joinPhone);
				int result = dao.joinUser(joinDto);
				
				if(result > 0) {
					response.sendRedirect("login.jsp");
				} else {
					response.sendRedirect("join.jsp?error=fail");
				}
				break;
				
				
			// [4] 로그인 요청
			case "/login.do":
				String loginId = request.getParameter("id");
				String loginPw = request.getParameter("pw");
				
				UserDTO user = dao.loginCheck(loginId, loginPw);
			    
			    if(user != null) {
			        request.getSession().setAttribute("sessionUser", user);
			        
			        // ★ [핵심] 등급에 따른 이동 경로 분기
			        if("ADMIN".equals(user.getJdi_role())) {
			            // 관리자라면 admin 폴더의 메인으로 이동
			            response.sendRedirect("admin/main.jsp");
			        } else {
			            // 일반인이라면 그냥 index.jsp로 이동
			            response.sendRedirect("index.jsp");
			        }
			        
			    } else {
			        response.sendRedirect("login.jsp?error=1");
			    }
				break;
				
				// [5] 로그아웃 요청
		    case "/logout.do":
		        session = request.getSession();
		        session.invalidate(); // 세션 전체 삭제 (로그아웃 핵심)
		        response.sendRedirect("index.jsp"); // 메인 화면으로 튕기기
		        break;
		        
		     // [6] 비밀번호 확인 (수정 페이지 진입 전)
		    case "/checkPass.do":
		        String inputPw = request.getParameter("pw");
		        // 세션에서 현재 로그인한 ID 가져오기
		        UserDTO sessUser = (UserDTO)request.getSession().getAttribute("sessionUser");
		        
		        if(dao.checkPassword(sessUser.getJdi_user(), inputPw)) {
		            // 통과: 증표(isPwdChecked)를 주고 수정 페이지로 이동
		            request.getSession().setAttribute("isPwdChecked", "ok");
		            response.sendRedirect("edit_profile.jsp");
		        } else {
		            // 실패: 경고창 띄우기 (간단히 JS로 처리)
		            response.setContentType("text/html; charset=UTF-8");
		            response.getWriter().write("<script>alert('비밀번호가 틀렸습니다.'); location.href='pwd_check.jsp';</script>");
		        }
		        break;

		    // [7] 정보 통합 수정 요청
		    case "/updateAll.do":
		    	String uName = request.getParameter("name");
		        String uPhone = request.getParameter("phone");
		        String uEmail = request.getParameter("email");
		        String uNewPw = request.getParameter("newPw");
		        
		        // ★ [추가] 화면에서 선택한 이미지 파일명 받기
		        String uProfile = request.getParameter("profile"); 
		        
		        UserDTO currentUser = (UserDTO)request.getSession().getAttribute("sessionUser");
		        
		        // DAO 실행 (인자값에 uProfile 추가)
		        int updateRes = dao.updateAll(currentUser.getJdi_user(), uName, uPhone, uEmail, uNewPw, uProfile);
		        
		        if(updateRes > 0) {
		            currentUser.setJdi_name(uName);
		            currentUser.setJdi_phone(uPhone);
		            currentUser.setJdi_email(uEmail);
		            
		            // ★ [추가] 세션 정보에도 프로필 업데이트 (그래야 즉시 바뀜)
		            currentUser.setJdi_profile(uProfile);
		            
		            request.getSession().setAttribute("sessionUser", currentUser);
		            
		            // 증표 삭제(재진입 방지) 후 마이페이지로
		            request.getSession().removeAttribute("isPwdChecked");
		            response.setContentType("text/html; charset=UTF-8");
		            response.getWriter().write("<script>alert('수정되었습니다.'); location.href='mypage.jsp';</script>");
		        } else {
		            response.sendRedirect("edit_profile.jsp?error=fail");
		        }
		        break;
		} // switch 끝
	}
}
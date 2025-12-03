package com.jdi.apply;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jdi.user.UserDTO;

@WebServlet("*.apply") // 주소 패턴: ~~~.apply
public class ApplyController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		String uri = request.getRequestURI();
		String ctx = request.getContextPath();
		String command = uri.substring(ctx.length());
		
		ApplyDAO dao = ApplyDAO.getInstance();
		
		switch(command) {
			
			// [1] 단어 신청 요청 (/request.apply)
			case "/request.apply":
				// 로그인 체크
				UserDTO user = (UserDTO)request.getSession().getAttribute("sessionUser");
				if(user == null) {
					response.sendRedirect("login.jsp");
					return;
				}
				
				// 파라미터 받기
				String word = request.getParameter("word");
				String doc = request.getParameter("doc");
				String korean = request.getParameter("korean");
				String jlpt = request.getParameter("jlpt");
				
				// DTO 생성
				ApplyDTO dto = new ApplyDTO(word, doc, korean, jlpt, user.getJdi_user());
				
				// DAO 실행
				int result = dao.insertApply(dto);
				
				// 결과 처리
				response.setContentType("text/html; charset=UTF-8");
				if(result > 0) {
					response.getWriter().write("<script>alert('신청이 완료되었습니다.'); location.href='mypage.jsp';</script>");
				} else {
					response.getWriter().write("<script>alert('신청 실패.'); history.back();</script>");
				}
				break;
				
				// [2] 관리자용 신청 목록 조회
		    case "/adminList.apply":
		        // (보안) 관리자 아니면 쫓아내기
		        UserDTO admin = (UserDTO)request.getSession().getAttribute("sessionUser");
		        if(admin == null || !"ADMIN".equals(admin.getJdi_role())) {
		            response.sendRedirect("index.jsp"); return;
		        }
		        
		        ArrayList<ApplyDTO> list = dao.getWaitList();
		        request.setAttribute("list", list);
		        request.getRequestDispatcher("admin/request_list.jsp").forward(request, response);
		        break;

		    // [3] 승인 처리 (Approve)
		    case "/approve.apply":
		        int reqId = Integer.parseInt(request.getParameter("id"));
		        
		        // 1. 신청 정보 가져오기
		        ApplyDTO reqDto = dao.getApply(reqId);
		        
		        if(reqDto != null) {
		            // 2. 실제 단어장에 넣기 (WordDAO 호출)
		            com.jdi.word.WordDTO wordDto = new com.jdi.word.WordDTO();
		            wordDto.setWord(reqDto.getWord());
		            wordDto.setDoc(reqDto.getDoc());
		            wordDto.setKorean(reqDto.getKorean());
		            wordDto.setJlpt(reqDto.getJlpt());
		            
		            com.jdi.word.WordDAO.getInstance().insertWord(wordDto);
		            
		            // 3. 상태를 'OK'로 변경
		            dao.updateStatus(reqId, "OK");
		            
		            // 4. 신청자에게 포인트 50점 지급
		            com.jdi.user.PointDAO.getInstance().addPoint(reqDto.getJdiUser(), 50, "단어등록 승인 보상");
		        }
		        
		        response.sendRedirect("adminList.apply");
		        break;

		    // [4] 거절 처리 (Reject)
		    case "/reject.apply":
		        int rejectId = Integer.parseInt(request.getParameter("id"));
		        dao.updateStatus(rejectId, "NO"); // 상태만 NO로 변경
		        response.sendRedirect("adminList.apply");
		        break;
		} // switch 끝
	}
}
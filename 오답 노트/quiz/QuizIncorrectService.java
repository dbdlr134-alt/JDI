package com.jdi.quiz;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jdi.user.UserDTO;
import com.jdi.util.Action;

public class QuizIncorrectService implements Action {

	@Override
	public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object obj = session.getAttribute("sessionUser");
        
        // 2. 로그인을 안 했다면 ->쫒가내기
        if(obj == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('로그인이 필요한 서비스입니다!'); location.href='login.jsp';</script>");
            return;
        }
        UserDTO user = (UserDTO) obj;
        String userId = user.getJdi_user();
        
        // 3. DAO에서 틀린 문제 가져오기
        QuizDAO dao = QuizDAO.getInstance();
        
        //메소드 호출
        List<QuizDTO> noteList = dao.getIncorrectNotes(userId);
        
        // 4. JSP로 데이터 보내기
        request.setAttribute("noteList", noteList);
        request.getRequestDispatcher("quiz_incorrect_answer_note.jsp").forward(request, response);
	}

}

package com.jdi.word;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jdi.util.Action;
import com.jdi.user.UserDTO;
// ★ 이전에 만든 apply 패키지의 클래스들을 가져옵니다.
import com.jdi.apply.ApplyDAO;
import com.jdi.apply.ApplyDTO;

public class WordReqService implements Action {

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. 로그인 여부 확인
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("sessionUser");

        if (user == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('로그인이 필요한 서비스입니다.'); location.href='login.jsp';</script>");
            return;
        }

        // 2. 파라미터 받기 (request_word.jsp 폼에서 넘어온 값)
        String word = request.getParameter("word");
        String doc = request.getParameter("doc");
        String korean = request.getParameter("korean");
        String jlpt = request.getParameter("jlpt");

        // 3. 신청 정보 DTO에 담기 (ApplyDTO 사용)
        ApplyDTO dto = new ApplyDTO();
        dto.setWord(word);
        dto.setDoc(doc);
        dto.setKorean(korean);
        dto.setJlpt(jlpt);
        dto.setJdiUser(user.getJdi_user()); // 신청자 ID

        // 4. DAO 호출 (ApplyDAO 사용)
        ApplyDAO dao = ApplyDAO.getInstance();
        int result = dao.insertApply(dto);

        // 5. 결과 처리
        response.setContentType("text/html; charset=UTF-8");
        if (result > 0) {
            // [수정] MemberController 대신 mypage.jsp로 이동하도록 변경
            response.getWriter().write("<script>alert('단어 신청이 완료되었습니다!\\n관리자 검토 후 등록됩니다.'); location.href='mypage.jsp';</script>");
        } else {
            response.getWriter().write("<script>alert('신청에 실패했습니다.'); history.back();</script>");
        }
    }
}
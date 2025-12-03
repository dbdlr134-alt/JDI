package com.jdi.quiz;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// ★ [필수] UserDTO 임포트! (패키지명 다르면 수정해!)
import com.jdi.user.UserDTO;
import com.jdi.util.Action;

public class WordQuizServices implements Action {

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // -------------------------------------------------------
        // 1. 세션 & 로그인 정보 확인
        // -------------------------------------------------------
        HttpSession session = request.getSession();
        
        String loginUser = null;
        Object obj = session.getAttribute("sessionUser"); // 로그인할 때 저장한 이름
        
        if(obj != null) {
            UserDTO user = (UserDTO) obj;
            loginUser = user.getJdi_user(); // 진짜 ID 꺼내기
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date()); 
        
        String sessionDate = (String) session.getAttribute("dailyQuizDate");
        String savedScore = (String) session.getAttribute("dailyScore");
        
        if (savedScore == null) savedScore = "-"; 

        boolean hasSolvedToday = (sessionDate != null && sessionDate.equals(today));
        
        // 틀린 문제 번호를 담을 리스트 만들기
        List<Integer> wrongQuizIds = new ArrayList<>();

        // 2. 채점 로직
        int totalScore = 0;   
        int totalCount = 0;   
        
        List<Map<String, String>> resultList = new ArrayList<>();
        Enumeration<String> params = request.getParameterNames();
        
        // ★ [추가 1] DAO 미리 소환
        QuizDAO dao = QuizDAO.getInstance();
        
        while(params.hasMoreElements()) {
            String paramName = params.nextElement();
            
            if(paramName.startsWith("ans_")) {
                totalCount++; 
                
                String quizIdStr = paramName.substring(4); // "101" (문자열 상태)
                String myAns = request.getParameter(paramName);              
                String correctAns = request.getParameter("correct_" + quizIdStr); 
                String word = request.getParameter("word_" + quizIdStr);        
                
                boolean isCorrect = myAns.equals(correctAns);
                
                if(isCorrect) {
                    totalScore++;
                } else {
                    // 틀렸을 때 로그인했다면 -> DB 저장
                    if(loginUser != null) {
                        try {
                            dao.addIncorrectNote(loginUser, Integer.parseInt(quizIdStr));
                            wrongQuizIds.add(Integer.parseInt(quizIdStr));
                        } catch (Exception e) {
                            e.printStackTrace(); 
                        }
                    }
                }
                
                Map<String, String> map = new HashMap<>();
                map.put("word", word);
                map.put("myAns", myAns);
                map.put("correctAns", correctAns);
                map.put("isCorrect", isCorrect ? "O" : "X");
                
                resultList.add(map);
            }
        }
        int wrongCount = totalCount - totalScore;

        // 3. 결과 처리 (세션 저장 및 이동)
        // [A] 방금 제출함 -> 결과 보여주고 세션 저장
        if (totalCount > 0) {
            int finalScore = (totalScore * 100 / totalCount);
         
            session.setAttribute("dailyQuizDate", today);        
            session.setAttribute("dailyScore", String.valueOf(finalScore)); 
            session.setAttribute("recentWrongIds", wrongQuizIds);//틀린문제 세션에 저장
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("correctCount", totalScore);
            request.setAttribute("wrongCount", wrongCount);
            request.setAttribute("score", finalScore);
            request.setAttribute("resultList", resultList);
            
            String jlpt = request.getParameter("jlpt");
            request.setAttribute("jlpt", (jlpt == null ? "N1" : jlpt));
            
            request.getRequestDispatcher("word_quiz.jsp").forward(request, response);
            return; 
        }
        
        // [B] 제출 안 했는데 오늘 기록 있음 -> 차단
        if (hasSolvedToday) {
            request.setAttribute("msg", "오늘의 퀴즈는 이미 완료했습니다! (세션 기록 보유)");
            request.setAttribute("alreadySolved", true); 
            request.setAttribute("savedScore", savedScore);
            
            request.getRequestDispatcher("word_quiz.jsp").forward(request, response);
            return; 
        }
       
        // [C] 기록 없음 -> 문제 출제
        String jlpt = request.getParameter("jlpt");
        if(jlpt == null || jlpt.isEmpty()) {
            jlpt = "N1"; 
        }
        
        // (위에서 dao 선언했으니 재활용)
        List<QuizDTO> qlist = dao.getRandomQuiz(jlpt);
        
        request.setAttribute("qlist", qlist);
        request.setAttribute("jlpt", jlpt);
        
        request.getRequestDispatcher("word_quiz.jsp").forward(request, response);
    }
}
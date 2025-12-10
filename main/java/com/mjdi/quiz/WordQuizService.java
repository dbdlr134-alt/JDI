package com.mjdi.quiz;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mjdi.user.PointDAO;
import com.mjdi.user.UserDTO;
import com.mjdi.util.Action;
import com.mjdi.util.DBM;

public class WordQuizService implements Action {

    @Override
    public void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String method = request.getMethod();
        
        // --------------------------------------------------------
        // [1] POST 방식: 채점 및 결과 DB 저장
        // --------------------------------------------------------
        if ("POST".equalsIgnoreCase(method)) {
            processGrading(request, response);
        } 
        // --------------------------------------------------------
        // [2] GET 방식: 문제 출제
        // --------------------------------------------------------
        else {
            String jlpt = request.getParameter("jlpt");
            if (jlpt == null || jlpt.isEmpty()) jlpt = "N5";
            
            String forceWordId = request.getParameter("force_word");
            QuizDAO dao = QuizDAO.getInstance();
            List<QuizDTO> qlist = new ArrayList<>();

            try {
                if (forceWordId != null && !forceWordId.isEmpty()) {
                    int targetId = Integer.parseInt(forceWordId);
                    
                    // 1번 문제 고정
                    QuizDTO firstQuiz = dao.getQuizByWordId(targetId);
                    if(firstQuiz != null) qlist.add(firstQuiz);
                    
                    // 나머지 랜덤
                    List<QuizDTO> randomList = dao.getRandomQuiz(jlpt);
                    for (QuizDTO q : randomList) {
                        if (q.getWord_id() == targetId) continue;
                        qlist.add(q);
                        if (qlist.size() >= 5) break;
                    }
                    request.setAttribute("isDaily", true); 
                } else {
                    qlist = dao.getRandomQuiz(jlpt);
                }
            } catch (Exception e) {
                e.printStackTrace();
                qlist = dao.getRandomQuiz(jlpt);
            }

            request.setAttribute("qlist", qlist);
            request.setAttribute("jlpt", jlpt);
            request.getRequestDispatcher("quiz/quiz.jsp").forward(request, response);
        }
    }

    // ==========================================================
    //  ★ 채점 및 DB 저장 로직 (수정 완료)
    // ==========================================================
    private void processGrading(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("sessionUser");
        String userId = (user != null) ? user.getJdi_user() : null;

        int totalScore = 0;
        int correctCount = 0;
        int wrongCount = 0;
        int earnedPoints = 0;
        
        // 오답 복습 모드인지 확인
        String isRetryParam = request.getParameter("isRetry");
        boolean isRetry = "true".equals(isRetryParam);
        
        List<Map<String, String>> resultList = new ArrayList<>();
        
        QuizDAO quizDao = QuizDAO.getInstance();
        PointDAO pointDao = PointDAO.getInstance();
        Connection conn = null;

        try {
            conn = DBM.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            Enumeration<String> params = request.getParameterNames();
            while (params.hasMoreElements()) {
                String paramName = params.nextElement();
                
                // 파라미터가 정답 제출(ans_1, ans_2...)인 경우만 처리
                if (paramName.startsWith("ans_")) {
                    
                    // 1. 문제 번호 및 ID 추출
                    String questionNum = paramName.substring(4); 
                    
                    // 2. 진짜 단어 ID 가져오기
                    String realIdStr = request.getParameter("real_id_" + questionNum);
                    int targetWordId = 0;
                    if(realIdStr != null) targetWordId = Integer.parseInt(realIdStr);
                    else continue;

                    // 3. 내 답(번호)과 정답(번호) 가져오기
                    String myAnsNum = request.getParameter(paramName); // 예: "1"
                    String correctAnsNum = request.getParameter("correct_" + questionNum); // 예: "2"
                    String word = request.getParameter("word_" + questionNum);

                    // ★★★ [추가] 번호를 텍스트로 변환하는 로직 시작 ★★★
                    String sel1 = request.getParameter("sel1_" + questionNum);
                    String sel2 = request.getParameter("sel2_" + questionNum);
                    String sel3 = request.getParameter("sel3_" + questionNum);
                    String sel4 = request.getParameter("sel4_" + questionNum);

                    // 내 답 번호를 텍스트로 변환
                    String myAnsText = "";
                    if ("1".equals(myAnsNum)) myAnsText = sel1;
                    else if ("2".equals(myAnsNum)) myAnsText = sel2;
                    else if ("3".equals(myAnsNum)) myAnsText = sel3;
                    else if ("4".equals(myAnsNum)) myAnsText = sel4;

                    // 정답 번호를 텍스트로 변환
                    String correctAnsText = "";
                    if ("1".equals(correctAnsNum)) correctAnsText = sel1;
                    else if ("2".equals(correctAnsNum)) correctAnsText = sel2;
                    else if ("3".equals(correctAnsNum)) correctAnsText = sel3;
                    else if ("4".equals(correctAnsNum)) correctAnsText = sel4;
                    // ★★★ [변환 로직 끝] ★★★

                    boolean isCorrect = (myAnsNum != null && myAnsNum.equals(correctAnsNum));
                    
                    // 결과 리스트에 담기 (이제 번호 대신 텍스트를 넣습니다!)
                    Map<String, String> map = new HashMap<>();
                    map.put("word", word);
                    map.put("myAns", myAnsText);         // 수정됨 (숫자 -> 텍스트)
                    map.put("correctAns", correctAnsText); // 수정됨 (숫자 -> 텍스트)
                    map.put("isCorrect", isCorrect ? "O" : "X");
                    resultList.add(map);
                   
                    
                    if (isCorrect) {
                        correctCount++;
                        totalScore += 20; 
                        
                        // [DB] 복습 모드라면 오답노트에서 삭제 (진짜 ID 사용)
                        if (userId != null && isRetry) {
                            quizDao.removeIncorrectNoteWithConn(conn, userId, targetWordId);
                        }
                    } else {
                        wrongCount++;
                        
                        // [DB] 틀린 문제는 오답노트에 추가 (진짜 ID 사용)
                        if (userId != null) {
                            quizDao.addIncorrectNoteWithConn(conn, userId, targetWordId);
                        }
                    }
                }
            }
            
            // [DB] 포인트 지급 
            if (userId != null && correctCount > 0) {
                earnedPoints = correctCount * 2; 
                pointDao.addPoint(conn, userId, earnedPoints, "퀴즈 정답 보상");
            }
            
            if (userId != null) {
                // [DB] 마이페이지 그래프용 기록 저장
                quizDao.insertQuizHistoryWithConn(conn, userId, correctCount, 5);
                
                // [DB] 총 풀이 횟수 증가 
                quizDao.updateSolveCountWithConn(conn, userId, (correctCount + wrongCount));
            }

            conn.commit(); // 커밋

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch(Exception ex) {}
            e.printStackTrace();
        } finally {
            DBM.close(conn, null, null);
        }

        // 결과 화면에 보낼 데이터 세팅
        request.setAttribute("score", totalScore);
        request.setAttribute("correctCount", correctCount);
        request.setAttribute("wrongCount", wrongCount);
        request.setAttribute("earnedPoints", earnedPoints);
        request.setAttribute("resultList", resultList);
        
        // 오늘의 퀴즈 쿠키 굽기
        String isDaily = request.getParameter("isDaily");
        if ("true".equals(isDaily)) {
            javax.servlet.http.Cookie dailyCookie = new javax.servlet.http.Cookie("dailySolved", "true");
            dailyCookie.setMaxAge(24 * 60 * 60); 
            dailyCookie.setPath("/"); 
            response.addCookie(dailyCookie);
        }
        
        request.getRequestDispatcher("quiz/quiz.jsp").forward(request, response);
    }
}
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JLPT 퀴즈</title>
    <link rel="stylesheet" href="style/style.css">
    <style>
        /* 급수 선택 메뉴 스타일 */
        .level-menu { margin-bottom: 30px; display: flex; justify-content: center; gap: 10px; }
        .btn-level {
            padding: 8px 16px; border: 1px solid #9EADFF; border-radius: 20px;
            background: #fff; color: #9EADFF; text-decoration: none; font-weight: bold; transition: 0.3s;
        }
        .btn-level:hover { background: #f0f2ff; }
        .btn-level.active { background: #9EADFF; color: #fff; }

        /* 성적표용 스타일 */
        .stats-box { display: flex; justify-content: space-around; margin-bottom: 30px; padding: 20px; background: #f8f9fa; border-radius: 10px; }
        .stat-item { text-align: center; }
        .stat-value { display: block; font-size: 32px; font-weight: bold; }
        .c-total { color: #5c6bc0; }
        .c-correct { color: #29b6f6; }
        .c-wrong { color: #ff7043; }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge-o { background: #e3f2fd; color: #1e88e5; }
        .badge-x { background: #ffebee; color: #e53935; }
        .result-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .result-table th, .result-table td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; }
        .result-table th { background: #f9f9f9; color: #666; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <section class="daily-section" style="padding-top: 50px;">
        <div class="inner center-box">
            <article class="card" style="width: 100%; max-width: 650px; padding: 40px; text-align: center;">
                
                <div class="card-header" style="font-size: 18px; color: #9EADFF; margin-bottom: 15px;">
                     [ ${jlpt == null ? '전체' : jlpt} ] 오늘의 퀴즈
                </div>

                <div class="level-menu">
                    <a href="QuizController?cmd=word_quiz&jlpt=N1" class="btn-level ${jlpt == 'N1' ? 'active' : ''}">N1</a>
                    <a href="QuizController?cmd=word_quiz&jlpt=N2" class="btn-level ${jlpt == 'N2' ? 'active' : ''}">N2</a>
                    <a href="QuizController?cmd=word_quiz&jlpt=N3" class="btn-level ${jlpt == 'N3' ? 'active' : ''}">N3</a>
                    <a href="QuizController?cmd=word_quiz&jlpt=N4" class="btn-level ${jlpt == 'N4' ? 'active' : ''}">N4</a>
                    <a href="QuizController?cmd=word_quiz&jlpt=N5" class="btn-level ${jlpt == 'N5' ? 'active' : ''}">N5</a>
                </div>
                
                <hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 30px;">

                <div class="card-body">
                    
                    <c:choose>
                        <%-- 상황 1: 채점 결과가 있을 때 -> [성적표] --%>
                        <c:when test="${not empty resultList}">
                            
                            <h2 style="color: #333; margin-bottom: 30px;">TEST RESULT</h2>
                            
                            <div class="stats-box">
                                <div class="stat-item">
                                    <span class="stat-label">TOTAL</span>
                                    <span class="stat-value c-total">${totalCount}</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-label">CORRECT</span>
                                    <span class="stat-value c-correct">${correctCount}</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-label">WRONG</span>
                                    <span class="stat-value c-wrong">${wrongCount}</span>
                                </div>
                            </div>

                            <table class="result-table">
                                <thead>
                                    <tr>
                                        <th>문제</th>
                                        <th>내 답</th>
                                        <th>정답</th>
                                        <th>결과</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="res" items="${resultList}">
                                        <tr>
                                            <td style="font-weight: bold;">${res.word}</td>
                                            <td>${res.myAns}</td>
                                            <td style="font-weight: bold; color: #555;">${res.correctAns}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${res.isCorrect == 'O'}">
                                                        <span class="badge badge-o">정답</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-x">오답</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            
                            <br><br>
                            <a href="WordController?cmd=word_search" class="btn-action peri">
                                메인 화면으로 
                            </a>
                            <a href="QuizController?cmd=quiz_incorrect" class="btn-action peri">
                            	오답노트로
                            </a>
                        </c:when>


                        <%-- 상황 2: 결과가 없을 때 -> [문제 풀기] --%>
                        <c:otherwise>
                            <form action="QuizController?cmd=word_quiz" method="post">
                                <input type="hidden" name="jlpt" value="${jlpt}">
                                
                                <c:if test="${!empty qlist}">
                                    <c:forEach var="Quiz" items="${qlist}" varStatus="status">
                                        <div style="border-bottom: 1px solid #eee; padding-bottom: 30px; margin-bottom: 30px; text-align: left;">
                                            
                                            <h2 style="font-size: 20px; color: #888;">Q${status.count}.</h2>
                                            <h1 style="font-size: 40px; margin: 10px 0; text-align: center; color: #333;">${Quiz.word}</h1>
                                            
                                            <div class="options" style="margin-top: 20px; display: inline-block; text-align: left;">
                                                <label style="display:block; margin: 5px 0;"><input type="radio" name="ans_${Quiz.quiz_id}" value="1"> ① ${Quiz.selection1}</label>
                                                <label style="display:block; margin: 5px 0;"><input type="radio" name="ans_${Quiz.quiz_id}" value="2"> ② ${Quiz.selection2}</label>
                                                <label style="display:block; margin: 5px 0;"><input type="radio" name="ans_${Quiz.quiz_id}" value="3"> ③ ${Quiz.selection3}</label>
                                                <label style="display:block; margin: 5px 0;"><input type="radio" name="ans_${Quiz.quiz_id}" value="4"> ④ ${Quiz.selection4}</label>
                                            </div>
            
                                            <input type="hidden" name="correct_${Quiz.quiz_id}" value="${Quiz.answer}">
                                            <input type="hidden" name="word_${Quiz.quiz_id}" value="${Quiz.word}">
                                        </div>
                                    </c:forEach>
                                    
                                    <button type="submit" class="btn-action peri" style="width: 100%; height: 50px; font-size: 18px;">
                                        답안지 제출하기
                                    </button>
                                </c:if>
            
                                <c:if test="${empty qlist}">
                                    <p>오늘의 퀴즈를 이미 푸셨습니다.</p>
                                    <a href="WordController?cmd=word_search" class="btn-action">[메인화면으로]</a>
                                </c:if>
                            </form>
                        </c:otherwise>
                        
                    </c:choose>
                </div>
            </article>
        </div>
    </section>
</body>
</html>
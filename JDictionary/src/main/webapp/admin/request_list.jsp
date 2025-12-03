<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>단어 신청 관리</title>
    <link rel="stylesheet" href="../style/style.css"> <style>
        .admin-wrap { max-width: 1000px; margin: 50px auto; padding: 0 20px; }
        .req-table { width: 100%; border-collapse: collapse; background: #fff; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .req-table th, .req-table td { padding: 15px; border-bottom: 1px solid #eee; text-align: center; }
        .req-table th { background: #f8f9fa; color: #555; font-weight: bold; }
        
        .btn-ok { background: #4caf50; color: white; padding: 5px 10px; border-radius: 5px; font-size: 12px; border:none; cursor:pointer;}
        .btn-no { background: #f44336; color: white; padding: 5px 10px; border-radius: 5px; font-size: 12px; border:none; cursor:pointer;}
        .top-nav { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    </style>
</head>
<body>

    <div class="admin-wrap">
        <div class="top-nav">
            <h2>📢 단어 등록 대기열</h2>
            <a href="main.jsp" class="btn-action" style="background:#ddd; color:#333; padding:8px 15px;">관리자 홈으로</a>
        </div>

        <table class="req-table">
            <thead>
                <tr>
                    <th>신청자</th>
                    <th>단어</th>
                    <th>요미가나</th>
                    <th>뜻</th>
                    <th>급수</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="dto" items="${list}">
                            <tr>
                                <td>${dto.jdiUser}</td>
                                <td style="font-weight:bold; color:#333;">${dto.word}</td>
                                <td>${dto.doc}</td>
                                <td>${dto.korean}</td>
                                <td><span style="background:#eee; padding:2px 5px; border-radius:3px; font-size:12px;">${dto.jlpt}</span></td>
                                <td>
                                    <button class="btn-ok" onclick="if(confirm('승인하시겠습니까?')) location.href='../approve.apply?id=${dto.reqId}'">승인</button>
                                    <button class="btn-no" onclick="if(confirm('거절하시겠습니까?')) location.href='../reject.apply?id=${dto.reqId}'">거절</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="padding: 50px; color: #888;">대기 중인 신청이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</body>
</html>
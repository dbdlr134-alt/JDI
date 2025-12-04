<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>신규 등록 관리</title>
    <link rel="stylesheet" href="style/design.css">
</head>
<body>

    <div class="admin-container">
        
        <div class="table-section">
            <div class="section-title">
                <span>📢 신규 단어 등록 대기열</span>
                <a href="${pageContext.request.contextPath}/admin/main.jsp" class="btn-home">관리자 홈</a>
            </div>

            <table class="req-table">
                <thead>
                    <tr>
                        <th style="width:10%;">신청자</th>
                        <th style="width:20%;">단어</th>
                        <th style="width:20%;">요미가나</th>
                        <th style="width:20%;">뜻</th>
                        <th style="width:10%;">급수</th>
                        <th style="width:20%;">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="dto" items="${list}">
                                <tr>
                                    <td>${dto.jdiUser}</td>
                                    <td style="font-weight:bold; color:#0C4DA1;">${dto.word}</td>
                                    <td>${dto.doc}</td>
                                    <td>${dto.korean}</td>
                                    <td><span style="background:#e0f2f1; color:#00A295; padding:2px 6px; border-radius:4px; font-size:11px; font-weight:bold;">${dto.jlpt}</span></td>
                                    <td>
                                        <button class="btn-ok" onclick="if(confirm('승인하시겠습니까?')) location.href='../approve.apply?id=${dto.reqId}'">승인</button>
                                        <button class="btn-no" onclick="if(confirm('거절하시겠습니까?')) location.href='../reject.apply?id=${dto.reqId}'">거절</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" style="padding: 50px; color: #999;">대기 중인 신청이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        
    </div>

</body>
</html>
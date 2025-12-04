<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 목록 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/design.css">
    <style>
        .user-table th, .user-table td { text-align: center; }
        .user-table td { font-size: 13px; padding: 10px 5px; }
    </style>
</head>
<body>

    <div class="admin-container">
        
        <div class="table-section">
            <div class="section-title">
                <span>👥 전체 회원 목록 조회</span>
                <a href="${pageContext.request.contextPath}/admin/main.jsp" class="btn-home">관리자 홈</a>
            </div>

            <table class="req-table user-table">
                <thead>
                    <tr>
                        <th style="width:15%;">아이디</th>
                        <th style="width:15%;">이름</th>
                        <th style="width:20%;">이메일</th>
                        <th style="width:15%;">전화번호</th>
                        <th style="width:10%;">권한</th>
                        <th style="width:15%;">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty userList}">
                            <c:forEach var="user" items="${userList}">
                                <tr>
                                    <td>${user.jdi_user}</td>
                                    <td>${user.jdi_name}</td>
                                    <td>${user.jdi_email}</td>
                                    <td>${user.jdi_phone}</td>
                                    <td>${user.jdi_role}</td>
                                    <td>
                                        <button class="btn-no" onclick="alert('차단 예정')">차단</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" style="padding: 50px; color: #999;">등록된 회원이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
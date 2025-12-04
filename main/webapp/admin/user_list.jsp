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
                <a href="${pageContext.request.contextPath}/adminMain.apply" class="btn-home">관리자 홈</a>
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
								        <!-- 자바스크립트로 전송 팝업 호출 -->
								        <button class="btn-ok" onclick="sendWarning('${user.jdi_user}')" style="background:#ff9800;">경고</button>
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
<script>
function sendWarning(userId) {
    // 간단하게 prompt로 입력받기
    const msg = prompt(userId + "님에게 보낼 경고/알림 내용을 입력하세요:");
    if(msg) {
        // 전송 서비스 호출
        location.href = "${pageContext.request.contextPath}/msgSend.do?receiver=" + userId + "&content=" + encodeURIComponent(msg);
    }
}
</script>
</html>
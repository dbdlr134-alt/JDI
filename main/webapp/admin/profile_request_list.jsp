<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>프로필 변경 신청 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/design.css">
</head>
<body>
    <jsp:include page="/include/header.jsp" />

    <div class="admin-container">
        <div class="table-section">
            <div class="section-title">
                <span>👤 프로필 변경 신청 대기열</span>
            </div>

            <table class="req-table">
                <thead>
                    <tr>
                        <th>신청번호</th>
                        <th>회원 ID</th>
                        <th>신청 이미지</th>
                        <th>메모</th>
                        <th>신청일</th>
                        <th>처리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="dto" items="${list}">
                                <tr>
                                    <td>${dto.reqId}</td>
                                    <td>${dto.userId}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/${dto.imagePath}"
                                             alt="신청 이미지" style="width:60px; height:60px; border-radius:50%;">
                                    </td>
                                    <td style="max-width:200px; white-space:pre-line; text-align:left;">
                                        ${dto.comment}
                                    </td>
                                    <td>${dto.reqDate}</td>
                                    <td>
                                        <button class="btn-ok"
                                                onclick="if(confirm('이 이미지로 프로필을 변경 승인하시겠습니까?')) 
                                                         location.href='${pageContext.request.contextPath}/approveProfileReq.do?id=${dto.reqId}'">
                                            승인
                                        </button>
                                        <button class="btn-no"
                                                onclick="if(confirm('이 신청을 거절하시겠습니까?')) 
                                                         location.href='${pageContext.request.contextPath}/rejectProfileReq.do?id=${dto.reqId}'">
                                            거절
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" style="padding:40px; text-align:center; color:#999;">
                                    대기 중인 프로필 변경 신청이 없습니다.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>

    <!-- 공통 레이아웃 + 디자인 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/design.css">

    <style>
        /* 상단고정 버튼 스타일 */
        .btn-top {
            padding: 3px 8px;
            background-color: #0C4DA1;
            color: white;
            border-radius: 6px;
            border: none;
            font-size: 12px;
            cursor: pointer;
            margin-left: 5px;
        }
        .btn-top:hover {
            background-color: #074285;
        }
    </style>
</head>
<body>

    <!-- 상단 공통 헤더 -->
    <jsp:include page="/include/header.jsp" />

    <div class="admin-container">

        <div class="table-section">
            <div class="section-title">
                <span>📢 공지사항</span>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">메인 홈</a>
            </div>

            <table class="req-table">
                <thead>
                    <tr>
                    	<th style="width:100px;"></th> <!-- 공지 라벨 컬럼 -->
                        <th>제목</th>
                        <th style="width:100px;"></th> <!-- 상단고정 버튼 -->
                        <th style="width:180px;">작성자</th>
                        <th style="width:180px;">작성일</th>
                    </tr>
                </thead>

                <tbody>
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="n" items="${list}">
                                <tr>
                                 <!-- 공지 라벨 컬럼: 맨 앞 -->
                                    <td class="notice-label-col">
                                        <c:if test="${n.is_top == 1}">
                                             <span style="color:red; font-weight:bold; margin-right:5px;">📌공지</span>
                                        </c:if>
                                    </td>
                                    <td style="font-weight:600; color:#0C4DA1;">
                                        <a href="${pageContext.request.contextPath}/NoticeController?cmd=notice_view&idx=${n.idx}">
                                            ${n.title}
                                        </a>
                                    </td>
                                     <!-- 관리자 전용 상단고정/해제 버튼 -->
                                        <td class="top-btn-col">
		                                    <c:if test="${sessionScope.sessionUser != null && sessionScope.sessionUser.jdi_role == 'ADMIN'}">
		                                        <form action="${pageContext.request.contextPath}/NoticeController" method="post" style="display:inline;">
		                                            <input type="hidden" name="cmd" value="notice_top">
		                                            <input type="hidden" name="idx" value="${n.idx}">
		                                            <input type="hidden" name="isTop" value="${n.is_top == 1 ? 'false' : 'true'}">
		                                            <button type="submit" class="btn-top">
		                                                ${n.is_top == 1 ? '상단해제' : '상단고정'}
		                                            </button>
		                                        </form>
		                                    </c:if>
		                                </td>
                                    <td>관리자</td>
                                    <td>${fn:substring(n.created_at,0,10)}</td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="3" style="padding:40px; color:#999; text-align:center;">
                                    등록된 공지사항이 없습니다.
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

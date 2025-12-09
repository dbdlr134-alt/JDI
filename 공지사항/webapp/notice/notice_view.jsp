<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세보기</title>

    <!-- 공통 레이아웃 + 디자인 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/design.css">
</head>
<body>

    <!-- 상단 공통 헤더 -->
    <jsp:include page="/include/header.jsp" />

    <div class="admin-container">

        <div class="table-section" style="max-width:800px; margin:auto;">
            <div class="section-title">
                <span>📢 공지사항</span>
                <a href="${pageContext.request.contextPath}/NoticeController?cmd=notice_list" class="btn-home">목록으로 돌아가기</a>
            </div>

            <div class="notice-detail">
                <h2 style="color:#0C4DA1; font-weight:bold; margin-bottom:10px;">
                    ${dto.title}
                </h2>
                <div style="display:flex; justify-content:space-between; color:#999; font-size:14px; margin-bottom:20px;">
                    <span>작성자: 관리자</span>
                    <span>작성일: ${fn:substring(dto.created_at,0,10)}</span>
                </div>
                <div style="padding:20px; border:1px solid #ddd; border-radius:8px; background:#f9f9f9; line-height:1.6;">
                    ${dto.content} <!-- 이미 서비스에서 <br>로 변환됨 -->
                </div>
                
                <%-- 관리자만 삭제/수정 버튼 --%>
			  <c:if test="${sessionScope.sessionUser != null && sessionScope.sessionUser.jdi_role == 'ADMIN'}">
				    <div style="margin-top:20px; text-align:right;">
				        <a href="${pageContext.request.contextPath}/NoticeController?cmd=notice_delete&idx=${dto.idx}"
				           onclick="return confirm('정말 삭제하시겠습니까?');"
				           class="btn-home" style="margin-right:10px;">
				           삭제
				        </a>
				        <a href="${pageContext.request.contextPath}/NoticeController?cmd=notice_modify&idx=${dto.idx}"
				           class="btn-home">
				           수정
				        </a>
				    </div>
				</c:if>
            </div>

        </div>
    </div>

</body>
</html>

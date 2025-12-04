<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>새 프로필 등록 신청</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/user.css">
</head>
<body>
    <jsp:include page="/include/header.jsp" />

    <div class="auth-wrap">
        <div class="auth-box">
            <h2 class="auth-title">새 프로필 등록 신청</h2>
            <p style="text-align:center; color:#e53935; margin-bottom:20px; font-weight:bold;">
                ※ 등록 신청 시 50 P가 차감됩니다.
            </p>
            
            <p style="text-align:center; padding: 30px 0;">
                현재는 시스템 구현 관계로,<br>
                **[신청하기]** 버튼을 누르면 포인트가 차감되고<br>
                새로운 프로필 사진 5번이 등록된 것으로 간주됩니다.
            </p>

            <div style="text-align:center;">
                <a href="${pageContext.request.contextPath}/request_profile.do" 
                   class="btn-submit" style="display:inline-block; text-decoration:none; width: 100%;">
                    50 P 차감하고 등록 신청하기
                </a>
            </div>
        </div>
    </div>
</body>
</html>
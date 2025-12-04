<%-- include/header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mjdi.user.UserDTO" %>
<%@ page import="com.mjdi.user.PointDAO" %>
<%@ page import="com.mjdi.user.MessageDAO" %>

<%
    UserDTO headerUser = (UserDTO)session.getAttribute("sessionUser");
    String ctx = request.getContextPath(); // 절대 경로용 변수

    int headerPoint = 0;
    int unreadMsg = 0;
    String headerProfile = "profile1.png";   // 기본 프로필 파일명
    String profileSrc = ctx + "/images/" + headerProfile; // 실제 img src

    if (headerUser != null) {
        headerPoint = PointDAO.getInstance().getTotalPoint(headerUser.getJdi_user());

        if (headerUser.getJdi_profile() != null && !headerUser.getJdi_profile().trim().isEmpty()) {
            headerProfile = headerUser.getJdi_profile();
            unreadMsg = MessageDAO.getInstance().getUnreadCount(headerUser.getJdi_user());
        }

        // ✅ 프로필 경로 판별
        // 1) profile*.png → /images/ 아래 기본 이미지
        // 2) 그 외 값 (예: upload/profile/xxx.png) → 컨텍스트 루트 기준 경로로 사용
        if (headerProfile.startsWith("profile")) {
            profileSrc = ctx + "/images/" + headerProfile;
        } else {
            // 예: headerProfile = "upload/profile/xxx.png" 이라고 가정
            profileSrc = ctx + "/" + headerProfile;
        }
    }
%>

<header class="top-header">
    <div class="inner">
        <div class="logo">
            <a href="<%= ctx %>/WordController?cmd=main">My J-Dic</a>
        </div>
        <nav class="util-nav">
            <% if(headerUser != null) { %>
                <div class="user-info-bar">
                    <!-- ✅ 여기서 profileSrc 사용 -->
                    <img src="<%= profileSrc %>" style="width:32px; height:32px; border-radius:50%;" alt="프사">
                    <span><%= headerUser.getJdi_name() %>님</span>
                </div>
                <a href="<%= ctx %>/msgBox.do" class="alarm-bell <%= unreadMsg > 0 ? "active" : "" %>" title="알림">
                        🔔
                        <% if(unreadMsg > 0) { %>
                            <span class="dot"></span> <!-- 빨간 점 포인트 -->
                        <% } %>
                    </a>
            <% } else { %>
                <a href="<%= ctx %>/login.jsp" class="login-link">로그인</a>
            <% } %>

            <a href="javascript:void(0)" class="btn-menu" onclick="toggleMenu()">:::</a>
            
            <div id="userMenu" class="dropdown-content">
                <% if(headerUser != null) { %>
                    <div class="menu-profile-area">
                        <span class="menu-name"><%= headerUser.getJdi_name() %>님</span>
                        <span class="menu-point">💰 <%= String.format("%,d", headerPoint) %> P</span>
                    </div>
                    <div class="menu-divider"></div>
                    <a href="<%= ctx %>/mypage.jsp" class="menu-item">마이페이지</a>
                    <% if("ADMIN".equals(headerUser.getJdi_role())) { %>
                        <a href="<%= ctx %>/adminMain.apply" class="menu-item" style="color:blue;">관리자 페이지</a>
                    <% } %>
                    <a href="<%= ctx %>/logout.do" class="menu-item logout">로그아웃</a>
                <% } else { %>
                    <a href="<%= ctx %>/login.jsp" class="menu-item">로그인</a>
                    <a href="<%= ctx %>/join.jsp" class="menu-item">회원가입</a>
                <% } %>
            </div>
        </nav>
    </div>
</header>

<script>
    /* 메뉴 토글 기능 */
    function toggleMenu() {
        var menu = document.getElementById("userMenu");
        menu.classList.toggle("show");
    }

    /* 메뉴 바깥쪽 클릭 시 닫기 */
    window.onclick = function(event) {
        if (!event.target.matches('.btn-menu')) {
            var dropdowns = document.getElementsByClassName("dropdown-content");
            for (var i = 0; i < dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                }
            }
        }
    }
</script>

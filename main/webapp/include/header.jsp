<%-- include/header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mjdi.user.UserDTO" %>
<%@ page import="com.mjdi.user.PointDAO" %>
<%
    UserDTO headerUser = (UserDTO)session.getAttribute("sessionUser");
    String ctx = request.getContextPath(); // 절대 경로용 변수
    int headerPoint = 0;
    String headerProfile = "profile1.png";
    if(headerUser != null) {
        headerPoint = PointDAO.getInstance().getTotalPoint(headerUser.getJdi_user());
        if(headerUser.getJdi_profile() != null) headerProfile = headerUser.getJdi_profile();
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
                    <img src="<%= ctx %>/images/<%= headerProfile %>" style="width:32px; height:32px; border-radius:50%;" alt="프사">
                    <span><%= headerUser.getJdi_name() %>님</span>
                </div>
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
                        <a href="<%= ctx %>/admin/main.jsp" class="menu-item" style="color:blue;">관리자 페이지</a>
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
        menu.classList.toggle("show"); // .show 클래스를 넣었다 뺐다 함
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
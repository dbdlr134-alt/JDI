<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jdi.user.UserDTO" %>
<%@ page import="com.jdi.user.PointDAO" %> <%-- 우리 스타일: DAO 직접 임포트 --%>

<%
    // 1. 세션에서 로그인 정보 가져오기
    UserDTO headerUser = (UserDTO)session.getAttribute("sessionUser");
    int headerPoint = 0;
    String headerProfile = "profile1.png"; // 기본 이미지
    
    // 2. 로그인 상태라면 DB에서 최신 정보(포인트) 갱신
    if(headerUser != null) {
        // [핵심] 컨트롤러 거치지 않고 DAO로 바로 조회 (우리가 했던 방식)
        headerPoint = PointDAO.getInstance().getTotalPoint(headerUser.getJdi_user());
        
        // 프로필 사진 설정
        if(headerUser.getJdi_profile() != null) {
            headerProfile = headerUser.getJdi_profile();
        }
    }
%>

<header class="top-header">
    <div class="inner">
        <div class="logo"><a href="WordController?cmd=main">My J-Dic</a></div>
        
        <nav class="util-nav" style="position: relative;">
            
            <a href="javascript:void(0)" class="btn-menu" onclick="toggleMenu()">:::</a>
            
            <div id="userMenu" class="dropdown-content">
                
                <% if(headerUser != null) { %>
                    <div class="menu-profile-area">
                        <img src="<%= request.getContextPath() %>/images/<%= headerProfile %>" class="menu-img" alt="프로필">
                        
                        <div class="menu-text">
                            <span class="menu-name"><%= headerUser.getJdi_name() %>님</span>
                            <span class="menu-point">💰 <%= String.format("%,d", headerPoint) %> P</span>
                        </div>
                    </div>
                    
                    <div class="menu-divider"></div>
                    
                    <a href="mypage.jsp" class="menu-item">마이페이지로</a>
                    <a href="logout.do" class="menu-item logout">로그아웃</a>
                    
                <% } else { %>
                    <p class="menu-msg">로그인이 필요합니다.</p>
                    <a href="login.jsp" class="menu-item login-btn">로그인</a>
                    <a href="join.jsp" class="menu-item">회원가입</a>
                <% } %>
                
            </div>
        </nav>
    </div>
</header>

<script>
    // [우리 스타일] 단순하고 직관적인 메뉴 토글 함수
    function toggleMenu() {
        var menu = document.getElementById("userMenu");
        menu.classList.toggle("show");
    }

    // 메뉴 바깥쪽 클릭 시 닫기
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
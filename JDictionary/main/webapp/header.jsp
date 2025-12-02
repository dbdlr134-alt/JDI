<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jdi.user.UserDTO" %>

<%
    // 세션에서 로그인 정보 가져오기 (모든 페이지 공통)
    UserDTO headerUser = (UserDTO)session.getAttribute("sessionUser");
%>

<header class="top-header">
    <div class="inner">
        <div class="logo"><a href="index.jsp">My J-Dic</a></div>
        
        <nav class="util-nav">
            <% if(headerUser == null) { %>
                <a href="login.jsp" class="btn-login">로그인</a>
                <a href="join.jsp" class="btn-join">회원가입</a>
            <% } else { %>
                <span class="user-welcome">
                    <b><%= headerUser.getJdi_name() %></b>님
                </span>
                <a href="mypage.jsp" class="btn-mypage">마이페이지</a>
                <a href="logout.do" class="btn-login">로그아웃</a>
            <% } %>
            
            <a href="#" class="btn-menu">:::</a>
        </nav>
    </div>
</header>
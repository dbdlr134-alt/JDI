<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jdi.word.*" %>

<%
    int wordId = Integer.parseInt(request.getParameter("word_id"));
    WordDAO dao = WordDAO.getInstance();
    WordDTO word = dao.wordSelect(wordId);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>단어 수정 신청</title>
<link rel="stylesheet" href="style/style.css">
</head>
<body>

<h2>단어 수정 신청</h2>

<form action="requestEdit.apply" method="post">

    <input type="hidden" name="word_id" value="<%=word.getWord_id()%>">

    <p>단어</p>
    <input type="text" name="word" value="<%=word.getWord()%>" required>

    <p>요미가나</p>
    <input type="text" name="doc" value="<%=word.getDoc()%>" required>

    <p>뜻</p>
    <input type="text" name="korean" value="<%=word.getKorean()%>" required>

    <p>JLPT 급수</p>
    <input type="text" name="jlpt" value="<%=word.getJlpt()%>" required>

    <br><br>
    <button type="submit" class="btn-action peri">수정 신청 제출</button>

</form>

</body>
</html>

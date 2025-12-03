<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<c:if test="${not empty noteList}">
	<c:forEach var="i" items="${noteList}">
			<li class="result-item">
                <a href="WordController?cmd=word_view&word_id=${i.word_id}" style="display:block; text-decoration:none;">
                    <span class="word">${i.word}</span>
                    <span class="doc">[${i.doc}]</span>
                    <span class="korean">${i.korean}</span>
                    <span class="wrong_count"><br>틀린 횟수:	 ${i.wrong_count}</span>
                </a>
                
            </li>
</c:forEach>
<a href="WordController?cmd=main" style="color:#9EADFF; margin-top:10px; display:inline-block;">메인으로 돌아가기</a>
</c:if>
<c:if test="${empty noteList}">
<h1>리스트가 비어이씀</h1>
</c:if>
</body>
</html>
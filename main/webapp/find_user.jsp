<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디/비밀번호 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <style>
        .find-container { max-width: 500px; margin: 80px auto; background: #fff; border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); overflow: hidden; }
        
        /* 탭 버튼 스타일 */
        .tab-header { display: flex; background: #f0f2f5; }
        .tab-btn { flex: 1; padding: 20px; text-align: center; cursor: pointer; font-weight: bold; color: #888; border-bottom: 2px solid transparent; transition: 0.3s; }
        .tab-btn.active { background: #fff; color: var(--main-color); border-bottom: 2px solid var(--main-color); }
        
        .tab-content { padding: 40px; display: none; }
        .tab-content.active { display: block; }
        
        .btn-find { width: 100%; padding: 15px; background: var(--main-color); color: #fff; border: none; border-radius: 30px; font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 20px; }
        .btn-find:hover { background: var(--hover-color); }
    </style>
</head>
<body>
    <jsp:include page="/include/header.jsp" />

    <div class="find-container">
        <div class="tab-header">
            <div class="tab-btn active" onclick="openTab('findId')">아이디 찾기</div>
            <div class="tab-btn" onclick="openTab('findPw')">비밀번호 찾기</div>
        </div>

        <div id="findId" class="tab-content active">
            <h3 style="text-align:center; margin-bottom:20px; color:#555;">이름과 이메일로 찾기</h3>
            <form action="findId.do" method="post">
                <div class="input-group">
                    <input type="text" name="name" class="input-field" placeholder="이름" required>
                </div>
                <div class="input-group">
                    <input type="email" name="email" class="input-field" placeholder="가입한 이메일" required>
                </div>
                <button type="submit" class="btn-find">아이디 찾기</button>
            </form>
        </div>

        <div id="findPw" class="tab-content">
		    <h3 style="text-align:center; margin-bottom:20px; color:#555;">임시 비밀번호 발급</h3>
		    <p style="font-size:12px; color:#999; text-align:center; margin-bottom:20px;">
		        가입된 휴대폰 번호로 임시 비밀번호를 전송합니다.
		    </p>
		    
		    <form action="findPw.do" method="post">
		        <div class="input-group">
		            <input type="text" name="id" class="input-field" placeholder="아이디" required>
		        </div>
		        <div class="input-group">
		            <input type="text" name="name" class="input-field" placeholder="이름" required>
		        </div>
		        
		        <div class="input-group">
		            <input type="text" name="phone" class="input-field" placeholder="가입한 전화번호 (01012345678)" required>
		        </div>
		        
		        <button type="submit" class="btn-find">비밀번호 재설정</button>
		    </form>
		</div>
    </div>

    <script>
        // 탭 전환 스크립트
        function openTab(tabName) {
            // 모든 탭 내용 숨김
            var contents = document.getElementsByClassName("tab-content");
            for (var i = 0; i < contents.length; i++) {
                contents[i].classList.remove("active");
            }
            // 모든 탭 버튼 비활성화
            var btns = document.getElementsByClassName("tab-btn");
            for (var i = 0; i < btns.length; i++) {
                btns[i].classList.remove("active");
            }
            // 선택한 탭 보이기
            document.getElementById(tabName).classList.add("active");
            event.currentTarget.classList.add("active");
        }
    </script>
</body>
</html>
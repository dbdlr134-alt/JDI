<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입 - My J-Dic</title>
    <link rel="stylesheet" href="style/style.css">
    <style>
        /* 회원가입 전용 스타일 */
        .join-wrap { display: flex; justify-content: center; padding-top: 50px; padding-bottom: 50px; }
        .join-box {
            background: #fff; width: 500px; padding: 40px;
            border-radius: 20px; box-shadow: 0 10px 30px rgba(158, 173, 255, 0.2);
        }
        .join-title { color: var(--main-color); font-size: 24px; font-weight: bold; margin-bottom: 20px; text-align: center; }
        .input-label { display: block; margin-bottom: 5px; font-weight: 500; color: #555; }
        .input-group { margin-bottom: 15px; }
        .input-field {
            width: 100%; height: 45px; padding: 0 15px;
            border: 2px solid #ddd; border-radius: 8px; font-size: 15px; outline: none;
        }
        .input-field:focus { border-color: var(--main-color); }
        .btn-submit {
            width: 100%; height: 50px; background-color: var(--main-color); color: #fff;
            border: none; border-radius: 10px; font-size: 18px; font-weight: bold; cursor: pointer; margin-top: 10px;
        }
        .btn-submit:hover { background-color: var(--hover-color); }
        /* 에러 메시지 스타일 */
        .error-msg { color: #ff6b6b; font-size: 12px; margin-top: 5px; display: none; }
    </style>
</head>
<body>

	<jsp:include page="header.jsp" />

    <div class="inner join-wrap">
        <div class="join-box">
            <h2 class="join-title">회원가입</h2>
            
            <form action="join.do" method="post" name="joinForm">
                
                <div class="input-group">
                    <span class="input-label">아이디</span>
                    <input type="text" name="id" id="uid" class="input-field" placeholder="영문, 숫자 4자 이상" required>
                </div>

                <div class="input-group">
                    <span class="input-label">비밀번호</span>
                    <input type="password" name="pw" id="upw" class="input-field" placeholder="4자 이상 입력" required>
                </div>
                
                <div class="input-group">
                    <span class="input-label">비밀번호 확인</span>
                    <input type="password" id="upw_check" class="input-field" placeholder="비밀번호 재입력">
                    <p id="pw-msg" class="error-msg">비밀번호가 일치하지 않습니다.</p>
                </div>

                <div class="input-group">
                    <span class="input-label">이름</span>
                    <input type="text" name="name" id="uname" class="input-field" placeholder="본명 또는 닉네임" required>
                </div>

                <div class="input-group">
                    <span class="input-label">이메일</span>
                    <div style="display:flex; gap:5px; align-items: center;">
                        <input type="text" id="emailId" class="input-field" placeholder="이메일" style="flex:1;">
                        <span style="font-weight:bold; color:#555;">@</span>
                        <select id="emailDomain" class="input-field" style="flex:1;">
                            <option value="">선택하세요</option>
                            <option value="naver.com">naver.com</option>
                            <option value="gmail.com">gmail.com</option>
                            <option value="daum.net">daum.net</option>
                            <option value="nate.com">nate.com</option>
                        </select>
                    </div>
                    <input type="hidden" name="email" id="realEmail">
                </div>
                
                <div class="input-group">
                    <span class="input-label">전화번호</span>
                    <div style="display:flex; gap:10px;">
                        <input type="text" id="phone" name="phone" class="input-field" placeholder="01012345678">
                        <button type="button" onclick="sendSms()" class="btn-submit" style="width:120px; font-size:14px; margin-top:0;">인증번호 받기</button>
                    </div>
                </div>
                
                <div class="input-group" id="auth-box" style="display:none;">
                    <span class="input-label">인증번호</span>
                    <div style="display:flex; gap:10px;">
                        <input type="text" id="authCode" class="input-field" placeholder="4자리 숫자">
                        <button type="button" onclick="checkSms()" class="btn-submit" style="width:100px; font-size:14px; margin-top:0; background-color:#666;">확인</button>
                    </div>
                    <input type="hidden" id="isVerified" value="false">
                    <p id="msg-auth" class="error-msg" style="display:block; color:#555;"></p>
                </div>
                
                <button type="button" onclick="joinSubmit()" class="btn-submit">가입 완료</button>
            </form>
        </div>
    </div>

<script>
    // === 1. 인증번호 발송 요청 ===
    function sendSms() {
        const phone = document.getElementById("phone").value;
        if(phone.length < 10) { alert("전화번호를 올바르게 입력하세요."); return; }

        fetch('sendSms.do?phone=' + phone)
            .then(res => res.text())
            .then(data => {
                if(data.trim() === 'success') {
                    alert("인증번호가 발송되었습니다.");
                    document.getElementById("auth-box").style.display = "block";
                } else {
                    alert("발송 실패. 관리자에게 문의하세요.");
                }
            })
            .catch(err => alert("서버 에러: " + err));
    }

    // === 2. 인증번호 확인 요청 ===
    function checkSms() {
        const code = document.getElementById("authCode").value;
        if(!code) { alert("인증번호를 입력하세요."); return; }

        fetch('checkSms.do?code=' + code)
            .then(res => res.text())
            .then(data => {
                const msgBox = document.getElementById("msg-auth");
                
                if(data.trim() === 'ok') {
                    msgBox.innerText = "인증 성공!";
                    msgBox.style.color = "blue";
                    document.getElementById("isVerified").value = "true";
                    document.getElementById("authCode").disabled = true;
                } else {
                    msgBox.innerText = "인증번호가 틀렸습니다.";
                    msgBox.style.color = "red";
                    document.getElementById("isVerified").value = "false";
                }
            })
            .catch(err => alert("서버 에러: " + err));
    }

    // === 3. 회원가입 최종 검사 ===
    function joinSubmit() {
        // 변수 가져오기
        const uid = document.getElementById("uid");
        const upw = document.getElementById("upw");
        const upwCheck = document.getElementById("upw_check"); // 비밀번호 확인
        const uname = document.getElementById("uname");
        
        // 이메일
        const emailId = document.getElementById("emailId");
        const emailDomain = document.getElementById("emailDomain");
        const realEmail = document.getElementById("realEmail");
        
        // 인증여부
        const verified = document.getElementById("isVerified").value;

        // [검사 1] 아이디
        if(uid.value.trim().length < 4) {
            alert("아이디는 4글자 이상이어야 합니다.");
            uid.focus(); return;
        }

        // [검사 2] 비밀번호 길이
        if(upw.value.trim().length < 4) {
            alert("비밀번호는 4글자 이상이어야 합니다.");
            upw.focus(); return;
        }

        // [검사 3] 비밀번호 일치 확인 (중요)
        const pwMsg = document.getElementById("pw-msg");
        if(upw.value !== upwCheck.value) {
            pwMsg.style.display = "block"; // 빨간 글씨 보이기
            upwCheck.focus(); return;
        } else {
            pwMsg.style.display = "none";
        }

        // [검사 4] 이름
        if(uname.value.trim() === "") {
            alert("이름을 입력해주세요.");
            uname.focus(); return;
        }

        // [검사 5] 이메일 합치기
        if(emailId.value.trim() === "" || emailDomain.value === "") {
            alert("이메일을 완성해주세요.");
            emailId.focus(); return;
        }
        // 합쳐서 hidden 태그에 넣기
        realEmail.value = emailId.value + "@" + emailDomain.value;

        // [검사 6] 휴대폰 인증
        if(verified !== "true") {
            alert("휴대폰 인증을 완료해주세요!");
            return;
        }

        // [통과] 전송
        document.joinForm.submit();
    }
</script>
</body>
</html>
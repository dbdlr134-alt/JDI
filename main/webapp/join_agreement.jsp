<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>약관 동의 - My J-Dic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/style.css">
    <style>
        .agree-container { max-width: 800px; margin: 60px auto; padding: 0 20px; }
        .agree-title { font-size: 28px; font-weight: bold; color: #0C4DA1; margin-bottom: 30px; text-align: center; }
        
        .term-box {
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #fff;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .term-header {
            font-size: 16px; font-weight: bold; color: #333; margin-bottom: 10px;
            display: flex; justify-content: space-between; align-items: center;
        }
        
        .term-content {
            width: 100%; height: 150px;
            border: 1px solid #f1f1f1;
            background: #f9f9f9;
            padding: 10px;
            overflow-y: scroll;
            font-size: 13px; color: #555; line-height: 1.6;
            resize: none;
        }
        
        .chk-area { font-size: 14px; color: #333; }
        .chk-area input { margin-right: 5px; transform: scale(1.2); }
        .chk-area label { cursor: pointer; }
        .chk-essential { color: #e53935; font-weight: bold; font-size: 12px; margin-left: 5px; }

        .all-check-box {
            background: #f1f8ff; border: 1px solid #0C4DA1;
            padding: 15px; border-radius: 8px; margin-bottom: 30px;
        }

        .btn-area { text-align: center; margin-top: 30px; }
        .btn-next {
            padding: 12px 40px; background: #0C4DA1; color: white;
            border: none; border-radius: 30px; font-size: 16px; font-weight: bold;
            cursor: pointer; transition: 0.2s;
        }
        .btn-next:hover { background: #00337C; }
        .btn-cancel {
            padding: 12px 40px; background: #eee; color: #555;
            border: none; border-radius: 30px; font-size: 16px; font-weight: bold;
            cursor: pointer; margin-right: 10px; text-decoration: none;
        }
    </style>
</head>
<body>

    <jsp:include page="/include/header.jsp" />

    <div class="agree-container">
        <div class="agree-title">약관 동의</div>
        
        <form action="join.jsp" method="post" id="agreeForm">
            
            <div class="all-check-box">
                <label>
                    <input type="checkbox" id="checkAll"> 
                    <strong>이용약관 및 개인정보 수집 및 이용에 모두 동의합니다.</strong>
                </label>
            </div>

            <div class="term-box">
                <div class="term-header">
                    <span>이용약관 동의 <span class="chk-essential">(필수)</span></span>
                    <div class="chk-area">
                        <label><input type="checkbox" name="agree1" class="normal-check"> 동의함</label>
                    </div>
                </div>
                <textarea class="term-content" readonly>
제1조 (목적)
이 약관은 My J-Dic(이하 "회사")이 제공하는 서비스의 이용조건 및 절차, 회사와 회원 간의 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다.

제2조 (용어의 정의)
1. "회원"이란 본 약관에 동의하고 가입한 자를 말합니다.
2. "포인트"는 서비스 내에서 사용되는 가상 화폐를 의미합니다.

제3조 (회원의 의무)
회원은 관계법령, 이 약관의 규정, 이용안내 및 주의사항 등 회사가 통지하는 사항을 준수하여야 하며, 기타 회사의 업무에 방해되는 행위를 하여서는 안 됩니다.

(이하 생략 - 상세 내용은 위에 적어드린 텍스트 참고)
                </textarea>
            </div>

            <div class="term-box">
                <div class="term-header">
                    <span>개인정보 수집 및 이용 동의 <span class="chk-essential">(필수)</span></span>
                    <div class="chk-area">
                        <label><input type="checkbox" name="agree2" class="normal-check"> 동의함</label>
                    </div>
                </div>
                <textarea class="term-content" readonly>
1. 수집하는 개인정보 항목
- 필수항목: 아이디, 비밀번호, 닉네임
- 수집방법: 홈페이지 회원가입

2. 개인정보의 수집 및 이용목적
- 회원제 서비스 이용에 따른 본인확인, 개인 식별, 불량회원의 부정 이용 방지
- 포인트 적립 및 사용 내역 관리

3. 개인정보의 보유 및 이용기간
- 회원 탈퇴 시까지 (단, 관계 법령에 따름)
                </textarea>
            </div>

            <div class="btn-area">
                <a href="index.jsp" class="btn-cancel">취소</a>
                <button type="button" class="btn-next" onclick="checkAgreement()">다음 단계</button>
            </div>
        </form>
    </div>

    <script>
        // 전체 동의 체크박스 로직
        const checkAll = document.getElementById('checkAll');
        const checkBoxes = document.querySelectorAll('.normal-check');

        checkAll.addEventListener('change', function() {
            checkBoxes.forEach(cb => cb.checked = checkAll.checked);
        });

        // 개별 체크박스 해제 시 전체 동의 해제
        checkBoxes.forEach(cb => {
            cb.addEventListener('change', function() {
                const total = checkBoxes.length;
                const checked = document.querySelectorAll('.normal-check:checked').length;
                checkAll.checked = (total === checked);
            });
        });

        // 다음 단계 버튼 클릭 시 검증
        function checkAgreement() {
            const agree1 = document.getElementsByName('agree1')[0];
            const agree2 = document.getElementsByName('agree2')[0];

            if (!agree1.checked) {
                alert('이용약관에 동의해주셔야 합니다.');
                agree1.focus();
                return;
            }
            if (!agree2.checked) {
                alert('개인정보 수집 및 이용에 동의해주셔야 합니다.');
                agree2.focus();
                return;
            }

            // 모두 동의했으면 회원가입 페이지(join.jsp)로 이동
            document.getElementById('agreeForm').submit();
        }
    </script>

</body>
</html>
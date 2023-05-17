<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입(일반)</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/user/user_join.js"></script> --%>
</head>
<body>
<h2>회원가입(일반)</h2>
<form method="post" name="joinForm" id="joinForm" action="<%=request.getContextPath()%>/user_join_ok.do" onsubmit="return joinFormCheck()">
	<table>
		<tr>
			<th>아이디</th>
			<td>
				<input type="text" name="user_id" id="user_id" placeholder="ID" onblur="checkId()" onkeyup="idKorCheck(this)">
				<input type="hidden" name="idcheckfin" value="idUncheck">
				<br>
				<span id="idcheck"></span>
			</td>
		</tr>
		<tr>
			<th>비밀번호</th>
			<td>
				<input type="password" name="user_pwd" id="user_pwd" placeholder="비밀번호를 입력해주세요." onkeyup="pwdKorCheck(this)" onchange="pwdInput()">
				<br>
				<span id="pwdcheck"></span>
			</td>
		</tr>
		<tr>
			<th>비밀번호 확인</th>
			<td>
				<input type="password" name="user_repwd" id="user_repwd" placeholder="비밀번호를 확인해주세요." onchange="pwdInput()">
				<br>
				<span id="repwdcheck"></span>
			</td>
		</tr>
		<tr>
			<th>이름</th>
			<td>
				<input type="text" name="user_name" id="user_name" placeholder="홍길동">
				<br>
				<span id="namecheck"></span>
			</td>
		</tr>
		<tr>
			<th>닉네임</th>
			<td>
				<input type="text" name="user_nickname" id="user_nickname" placeholder="홍길동">
				<br>
				<span id="user_nicknamecheck"></span>
			</td>
		</tr>
		<tr>
			<th>휴대전화</th>
			<td>
				<div id="user_phone">
					<input type="text" name="user_phone" id="user_phone" class="phone_number" maxlength="11" placeholder="010-0000-0000" oninput="this.value=this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');">
				</div>
				<span id="phonecheck"></span>
			</td>
		</tr>
		<!-- <tr>
			<th>선호 테마</th>
			<td>
				<select name="user_like_keyword" id="user_like_keyword">
					<option value="thema1">thema1</option>
					<option value="thema2">thema2</option>
					<option value="thema3">thema3</option>
					<option value="thema4">thema4</option>
		         </select>
		         <br>
				 <span id="user_like_keyword_check"></span>
			</td>
		</tr> -->
		<tr>
			<th>이메일</th>
			<td>
				<input type="text" name="user_email" id="user_email" onkeyup="autoEmail()" autocomplete="off" placeholder="이메일을 입력해주세요.">
				<input type="button" id="user_emailSend" value="이메일 인증" onclick="emailSend()">
				<br>
				<span id="emailcheck"></span>
			</td>
		</tr>
		<tr>
			<th>이메일 확인</th>
			<td>
				<div class="user_email_check">
					<input type="text" id="user_email_check" placeholder="이메일 인증코드를 입력해주세요.">
					<input type="button" id="user_email_checkSubmit" value="인증코드 확인" onclick="emailCheck()">
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="2" aling = "center">
			<input type = "submit" value = "회원가입">
			</td>
		</tr>
	</table>
	</form>
</body>
</html>

$.validator.addMethod("engAndNum", function(value, element) {
  var pattern = /^[A-Za-z0-9@._-]*$/;

  return pattern.test(value);
});

$.validator.addMethod("specialChars", function(value, element) {
	// Define the pattern to match special characters
	var pattern = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;

	// Test the value against the pattern and return true or false
	return pattern.test(value);
});



$.validator.addMethod("emailCheck", function(value, elements) {
	var pattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;

	return pattern.test(value);

});

$.validator.addMethod("phoneCheck", function(value, elements) {
	var pattern = /[0-9]/;

	return pattern.test(value);

});

// id_check 메서드를 정의
$.validator.addMethod("id_check", function(value, element, param) {
   var validater = this;
   // 아이디 중복 여부 확인
	$("#user_id").keyup(function() {
	    
	    let user_id = $(this).val(); // 입력된 아이디 값 가져오기
	    let messageElement = $(".id_check"); // 메세지를 표시할 요소 선택
	    
		$.ajax({
			ContentType: "application/x-www-form-urlencoded; charset=UTF-8",
			async:false,
			type: "post",
			url: "user_idCheck.go",
			data: { id: user_id },
			datatype: "text",
			success: function(data) {
				messageElement.empty(); // 기존 메세지 초기화
        		
			
				console.log(data);
				if (data === "db") {
					isValid = false;
				} else {
					isValid = true;
				}
			},

			error: function() {
                alert("데이터 통신 오류입니다.");
            }
		});
	});
   return isValid;
});
// nick_check 메서드를 정의
$.validator.addMethod("nick_check", function(value, element, param) {
   var validater = this;
   // 아이디 중복 여부 확인
	$("#user_nickname").change(function() {
	    
	    let user_nickname = $(this).val(); // 입력된 아이디 값 가져오기
	    console.log(user_nickname);
	    let messageElement = $(".name_check"); // 메세지를 표시할 요소 선택
	    
		$.ajax({
			ContentType: "application/x-www-form-urlencoded; charset=UTF-8",
			async:false,
			type: "post",
			url: "nicknameCheck.go",
			data: { nickname: user_nickname },
			datatype: "text",
			success: function(data) {
				messageElement.empty(); // 기존 메세지 초기화
        		
			
				console.log(data);
				if (data === "db") {
					isValid = false;
				} else {
					console.log("사용가능.");
					isValid = true;
				}
			},

			error: function() {
                alert("데이터 통신 오류입니다.");
            }
		});
	});
   return isValid;
});

// email_check 메서드를 정의
$.validator.addMethod("email_check", function(value, element, param) {
   var validater = this;
   // 아이디 중복 여부 확인
	$("#user_email").keyup(function() {
	    
	    let user_email = $(this).val(); // 입력된 아이디 값 가져오기
	    let messageElement = $(".email_check"); // 메세지를 표시할 요소 선택
	    
		$.ajax({
			ContentType: "application/x-www-form-urlencoded; charset=UTF-8",
			async:false,
			type: "post",
			url: "emailCheck.go",
			data: { email: user_email },
			datatype: "text",
			success: function(data) {
				messageElement.empty(); // 기존 메세지 초기화
        		
			
				console.log(data);
				if (data === "db") {
					isValid = false;
				} else {
					isValid = true;
				}
			},

			error: function() {
                alert("데이터 통신 오류입니다.");
            }
		});
	});
	
	
   return isValid;
});


$("#joinForm").validate({


	rules: {


		user_pwd: {
			required: true,
			minlength: 6,
			maxlength: 12,
			specialChars: true
			
		},
		user_repwd:{
			required: true,
			equalTo: user_pwd
		},
		user_id: {
			required: true,
			minlength: 4,
			maxlength: 20,
			engAndNum: true,
			id_check : true
		},

		user_email: {
		    required: true,
			emailCheck: true,
			email_check: true
		},
		user_phone: {
			phoneCheck : true
		},
		user_nickname: {
		   required : true,
		   nick_check : true
		},
		chk_agree:{
			required : true
		}
		
	},

	messages: {
		user_pwd: {
			required: "비밀번호 입력은 필수 입니다.",
			minlength: "최소 6글자 이상 입력해주세요.",
			maxlength: "12글자를 넘지 말아주세요.",
			specialChars: "특수문자 입력해주세요."
		},
		user_repwd:{
			required: "비밀번호 중복 체크를 진행하세요.",
			equalTo: "비밀번호를 확인하세요."
		},
		user_id: {
			required: "아이디는 필수 입니다.",
			minlength: "최소 4글자 이상 입력해주세요",
			maxlength: "20글자를 넘지 말아주세요",
			engAndNum: "아이디는 영문과 숫자로만 작성해 주세요.",
			id_check: "중복 아이디 입니다.!!!"
		},

		user_email: {
			required: "이메일 입력은 필수 입니다.",
			emailCheck: "이메일 형식에 맞게 입력해 주세요.",
			email_check: "이미 가입된 이메일입니다."
		},
		user_phone: {
			phoneCheck : "전화번호 형식에 맞게 입력하세요."
		},
		user_nickname: {
			required: "닉네임 필수 입니다.",
		    nick_check : "닉네임이 중복되었습니다."
		},
		chk_agree : {
			required : "약관에 동의 하셔야 합니다."
		}

	},
	
	errorElement: "span",
	errorClass: "bad",
	validClass: "good",

	success: function(label) {
		// This function is called when a field passes validation
		label.text("check").addClass("okayValid");
	},
	onkeyup: function(element) {
		// Trigger validation on keyup event
		$(element).valid();
	},

});



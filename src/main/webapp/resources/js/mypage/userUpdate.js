/**
 * 
 */

let id = $(".id").val();
let user_nickname= $(".user_nickname").val();
let user_id = $(".user_id").val();
let user_email = $(".user_email").val();

console.log(user_nickname);
console.log(user_id);
console.log(user_email);

let isValid;

 

$.validator.addMethod("specialChars", function(value, element) {
	// Define the pattern to match special characters
	var pattern = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;

	// Test the value against the pattern and return true or false
	return pattern.test(value);
});

$.validator.addMethod("capitalLetters", function(value, element) {
	// Define the pattern to match capital letters
	var pattern = /[A-Z]/;

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



$.validator.addMethod("nick_check", function(value, element, param) {
   var validater = this;
   console.log(user_nickname);
   
   if (user_nickname == $(element).val()) {
       isValid = true;
   } else {
       let user_nickname = $(element).val();
       let messageElement = $(".name_check"); // 메세지를 표시할 요소 선택
       console.log("id:", id);
       
       $.ajax({
           contentType: "application/x-www-form-urlencoded; charset=UTF-8",
           async: false,
           type: "post",
           url: "nicknameCheck.go",
           data: { nickname: user_nickname, num: id },
           dataType: "text",
           success: function(data) {
               messageElement.empty(); // 기존 메세지 초기화
               console.log(data);
               if (data === "db") {
                   console.log("중복");
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
   }
   return isValid;
});

// email_check 메서드를 정의
$.validator.addMethod("email_check", function(value, element, param) {
   var validater = this;
   // 아이디 중복 여부 확인
   
   if (user_email == $(element).val()) {
       isValid = true;
   } else {
       let user_email = $(element).val();
       let messageElement = $(".email_check"); // 메세지를 표시할 요소 선택
       console.log("id:", id);
    
	$(".user_email").keyup(function() {
	    

	    let user_email = $(this).val(); // 입력된 아이디 값 가져오기
	 	console.log(user_email);
	 	console.log("id:", id);
	 	
	    let messageElement = $(".email_check"); // 메세지를 표시할 요소 선택
	    
		$.ajax({
			ContentType: "application/x-www-form-urlencoded; charset=UTF-8",
			async:false,
			type: "post",
			url: "emailCheck.go",
			data: { email: user_email,
			        num: id },
			datatype: "text",
			success: function(data) {
				messageElement.empty(); // 기존 메세지 초기화
        		
			
				console.log(data);
				if (data === "db") {
					console.log("중복");
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
	
    
    }
	
   return isValid;
});


$("#frm1").validate({


	rules: {


		db_pwd: {
			required: true,
			minlength: 6,
			maxlength: 12,
			specialChars: true,
			capitalLetters: true
			
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
		   nick_check : true
		}


	},

	messages: {
		db_pwd: {
			required: "비밀번호 입력은 필수 입니다.",
			minlength: "최소 6글자 이상 입력해주세요.",
			maxlength: "12글자를 넘지 말아주세요.",
			capitalLetters: "대문자 하나 입력해주세요",
			specialChars: "특수문자 입력해주세요."
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
		    nick_check : "닉네임이 중복되었습니다."
		}


	},
	
	errorElement: "span",
	errorClass: "bad",
	validClass: "good",

	success: function(label) {
		// This function is called when a field passes validation
		label.text("사용가능!").addClass("okayValid");
	},
	onkeyup: function(element) {
		// Trigger validation on keyup event
		$(element).valid();
	},

});



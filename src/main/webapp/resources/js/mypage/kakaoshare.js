/**
 * 
 */
 //공유 버튼을 누를경우 alert 메시지  
//세션이 있는데 카카오 세션일 경우 카카오 회원가입 창으로 으로 전송
//일반 유저의 세션인 경우 공유하기 페이지 윈도우 창으로 띄워주기
function opensharePage(){
  		console.log(kid);
        console.log(kid);
          console.log(typeof kid,kid);
          console.log(typeof uid,uid);
          //카카오 세션인 경우 유효성 검사 해당 이메일이 db상의 이메일과 일치하고 해당 유저의 iskakao여부가 1인지 0인지
          //컨트롤러 상에서 카카오 연동 회원 일 경우에는 (email & iskako 충족) ->return share.go(결과 값만 출력 해서 구분)
          //연동회원이 아닐 경우에는 return 0  --> alert("연동계정으로 전환하시겠습니까?")--> 회원 가입 페이지로 아예 보내 버리기.
          if(kid != '' && uid == ''){
             $.ajax({
                url : "iskakao_check.go",
                type : "POST",
                data : {
                   user_email : kid
                },
                 success:function(result){ 
                    //temporary 테이블에 이메일이 존재하고 연계회원가입이 되어 있는 경우.
                    if(result == 1){ 
                        //공유하는 창으로 보낸다.
                        planlistcheck(kid);
                     //temporary 테이블에 이메일이 존재하지만 연계회원가입이 되어 있지 않은 경우.   
                     }else if(result == -1){
                        let ask_result = confirm('일정 공유 기능은 카카오톡연동회원만 가능합니다. 추가정보를 입력하여 가입하겠습니까?');
                        if(ask_result){
                           var url = "kakaoUser_join.go?user_email=" + kid;
                           location.href = url;
                        }
                     }else{
                        alert('로그인이 필요한 기능입니다.');
                     }
                 },
                 error:function(error){
                     alert("아이디를 다시 입력해 주세요");
                 } 
                
             }); 
          }else if(uid != '' &&  kid == ''){
              console.log(uid);
              planlistcheck(uid);
          }else{
             alert('로그인이 필요한 기능입니다.');
          }
    }
    function planlistcheck(id,a){
       $.ajax({
          url : "planlistCheck.go",
          type : "POST",
          data : {
             user_id : id
          },
           success:function(result){ 
              //해당 아이디로 저장된 일정리스트가 있는 경우.
              if(result == 1){ 
                  //수정하는 창으로 보낸다.
                 let ask_result = confirm('일정정보를 공유하시겠습니까?');
                  if(ask_result){
                	  sendLink();
                  }
                  //해당 아이디로 저장된 일정리스트가 없는 경우.   
               }else if(result == -1){
                  alert('보유하신 일정 리스트가 없습니다. 일정을 먼저 추가해 주세요.')
               }
           },
           error:function(error){
               alert("통신 오류.");
           } 
       }); 
    }
    //정회원 회원 여부 구분 후 modify page 이동.
   function openModifyPage(){
      let kid = '${kakao_id}';
      let uid = '${user_id}';   
      
      if(kid != '' && uid == ''){
          $.ajax({
             url : "iskakao_check.go",
             type : "POST",
             data : {
                user_email : kid
             },
              success:function(result){ 
                 //temporary 테이블에 이메일이 존재하고 연계회원가입이 되어 있는 경우.
                 if(result == 1){ 
                     //수정하는 창으로 보낸다.
                     location.href='userprofile.go';
                  //temporary 테이블에 이메일이 존재하지만 연계회원가입이 되어 있지 않은 경우.   
                  }else if(result == -1){
                     let ask_result = confirm('회원님은 sns연동 임시 회원입니다. 추가정보를 입력하여 sns연동 회원가입을 하시겠습니까?');
                     if(ask_result){
                        var url = "kakaoUser_join.go?user_email=" + kid;
                        location.href = url;
                     }
                  }else{
                     alert('로그인이 필요한 기능입니다.');
                  }
              },
              error:function(error){
                  alert("아이디를 다시 입력해 주세요");
              } 
             
          }); 
      }else{
         location.href='userprofile.go';
      }
   }
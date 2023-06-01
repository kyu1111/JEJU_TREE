<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.1.0/kakao.min.js"
  integrity="sha384-dpu02ieKC6NUeKFoGMOKz6102CLEWi9+5RQjWSV0ikYSFFd8M3Wp2reIcquJOemx" crossorigin="anonymous"></script>
<title>Insert title here</title>
</head>
<body>
<c:set var = "normal_session" value="${user_id}"/>
<div class="content E-Solution" id="content" align="center">
	<h2>카톡계정의 친구에게 일정을 공유해 보세요</h2> 
	<input type="hidden" onclick="sendLinkCustom();" value="Custom" /> 
	<h3><a onclick="sendLink();" value="공유하기">친구목록 불러오기</a></h3>
	<input type="button" onclick="sendLink();" value="공유하기" />
	<a id="kakaotalk-sharing-btn" href="javascript:;"> 
	 <img src="https://developers.kakao.com/assets/img/about/logos/kakaotalksharing/kakaotalk_sharing_btn_medium.png"
    alt="카카오톡 공유 보내기 버튼" />
    </a>
</div>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script language="javascript">
let parameter_id = '${user_id}';
let normal_session = '${normal_session}'

console.log('normal_session');
//기존의 로그인 했던 카카오 유저의 친구목록 찌끄래기를 날려주는 메서드
 



Kakao.init("ddee3a2c7a119e1824460c4c13d5fd83");

try {
  function sendLink() {
	  /* if(normal_session != ''){
			 Kakao.Auth.logout();
		}  */

		let is_guest = 'y';  
    Kakao.Link.sendDefault({
      objectType: 'feed',
      content: {
        title: 'JejuTree일정에 당신을 초대합니다.',
        description: parameter_id + '님이 일정에 당신을 초대했어요',
        imageUrl: 'https://ifh.cc/g/P8cvPg.png',
        link: {
          webUrl: 'http://localhost:8585/model/plan_list.go?id=' + parameter_id + '&is_guest=' + is_guest + '' // parameter_id 변수를 파라미터로 추가
        },
      },
      buttons: [
        {
          title: '일정확인하기',
          link: {
            webUrl: 'http://localhost:8585/model/plan_list.go?id=' + parameter_id + '&is_guest=' + is_guest + '' // parameter_id 변수를 파라미터로 추가
          },
        },
      ],
    });
  }

  window.kakaoDemoCallback && window.kakaoDemoCallback();
} catch (e) {
  window.kakaoDemoException && window.kakaoDemoException(e);
}
</script>
</body>
</html>
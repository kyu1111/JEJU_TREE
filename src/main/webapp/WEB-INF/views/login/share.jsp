<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.1.0/kakao.min.js"
  integrity="sha384-dpu02ieKC6NUeKFoGMOKz6102CLEWi9+5RQjWSV0ikYSFFd8M3Wp2reIcquJOemx" crossorigin="anonymous"></script>
<title>JEJU TREE</title>
</head>
<body>
<c:set var = "normal_session" value="${user_id}"/>
	<div class="find_id_container" align="center">
		<div class="find_id_title">
			<div class="search_id">아이디 찾기</div>
			<div class="title-account">제주 여행의 시작 JEJU TREE</div>
		</div>
	
		<div class="find_id_cont">
			<form method="post" action="<%=request.getContextPath()%>/id_search.go">
			    <div>
		            <div class="find_id_text">
		            	<div class="content E-Solution" id="content" align="center">
					<a onclick="sendLink();" value="공유하기">
  					<img style="width: -webkit-fill-available;" src="<%=request.getContextPath()%>/resources/images/kakao_logo/btn_sns_kakao.png">
					</a>
					</div>
		            </div>
		            <div class="find_id_text">
		            	<span class="find_id_span">
		            		* 메일이 도착하기까지 몇 분 정도 소요될 수 있습니다.
		            	</span>
		            	<span class="find_id_span">
		            		* 스팸 메일함으로 발송될 수 있으니 체크바랍니다.
		            	</span>
		            </div>
			    </div>
			</form>
		</div>
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
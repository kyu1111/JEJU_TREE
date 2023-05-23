<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.1.0/kakao.min.js"
  integrity="sha384-dpu02ieKC6NUeKFoGMOKz6102CLEWi9+5RQjWSV0ikYSFFd8M3Wp2reIcquJOemx" crossorigin="anonymous"></script>
<title>Insert title here</title>
</head>
<body>
<div class="content E-Solution" id="content">
	<input type="hidden" onclick="sendLinkCustom();" value="Custom" /> 
	<input type="button" onclick="sendLink();" value="공유하기" />
	
</div>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script language="javascript">
	Kakao.init("ddee3a2c7a119e1824460c4c13d5fd83");   //어플의 Javascript Key 값
	function sendLinkCustom() {
		Kakao.Link.sendCustom({
			templateId : 744020	  //숫자값
			});	
	}
	try {
		function sendLink() {
		Kakao.Link.sendDefault({
		  objectType : 'feed',
		  content : {
			title : '공유테스트 으아',
			description : '',
			imageUrl : 'http://k.kakaocdn.net/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png',
			link : {
				mobileWebUrl : 'http://localhost:8585/model/plan_list.go?id=',
				webUrl : 'http://localhost:8585/model/plan_list.go?id=',
			},
		  },
		  social : {
			likeCount : 100,
			commentCount : 200,
			sharedCount : 300,
		  },
		  buttons : [
			{
				title : '웹으로 보기',
				link : {
					mobileWebUrl : 'http://localhost:8585/model/plan_list.go?id=',
					webUrl : 'http://localhost:8585/model/plan_list.go?id=',
				},
			},
			{
				title : '앱으로 보기',
				link : {
					mobileWebUrl : 'http://localhost:8585/model/plan_list.go?id=',
					webUrl : 'http://localhost:8585/model/plan_list.go?id=',
				},
			}, ],
		})
		}
		;
		window.kakaoDemoCallback && window.kakaoDemoCallback()
	} catch (e) {
		window.kakaoDemoException && window.kakaoDemoException(e)
	}
</script>
</body>
</html>
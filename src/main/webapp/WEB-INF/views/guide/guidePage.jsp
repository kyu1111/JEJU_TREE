<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/model/resources/css/guide/guidePage.css">
<link rel="stylesheet" href="/model/resources/css/include/navbar.css">    
<meta charset="UTF-8">
<title>이용 가이드 페이지</title>
<script type="text/javascript">
	function scrollToTop() {
	    window.scrollTo({ top: 0, behavior: 'smooth' });
	}
</script>
</head>
<body>

<!-- 상단바 설정하기  -->
<%@ include file="../include/navbar.jsp"%>

<div class="root">
	<div class="wrapper">
		<div class="h1-container">
			<h1><b>4단계로 간편하게 끝내는 여행 스케줄링</b></h1>
		</div>
	
		<div style="width: 100%">
			<div class="section-container">
				<div class="flex-container">
					<div class="half-flex-div-gif">
						<div class="gif-container">		
							<div class="guide_img">
								<img class="guideImg" src="/model/resources/images/guideImg1.png">
							</div>
						</div>	
					</div>

					<div class="half-flex-div-text">
						<div class="section-title-text">1. 지역 선택</div>
							<div class="section-text">
								먼저 제주도에서 방문 할 지역 선택하세요. <br>
								100여개의 유명한 지역별 장소가 준비되어 있으며, <br>
								지속적으로 사용자님들의 편의를 위해 업데이트 중입니다. <br>
								맛집, 포토 스팟 등 필터 기능으로  다양한 지역들을 보여드립니다. <br>
								지역을 선택하고 간단한 여행 정보들을 확인해보세요.
							</div>
					</div>
				</div>			
			</div>
			
			<div class="section-container">
				<div class="flex-container">
					<div class="half-flex-div-text">
						<div class="section-title-text">2. 장소 선택</div>
							<div class="section-text">
								여행 일자, 숙소, 가고 싶은 장소만 선택하세요. <br>
								가고 싶은 장소를 정하지 않았어도 상관없어요. <br>
								유저 데이터를 기반으로 제주트리가 추천해주는 장소들을 선택하세요. <br>
								검색해도 나오지 않는 장소들은 직접 등록이 가능합니다. <br>
								선택이 끝났다면 일정 생성 버튼을 눌러 작성을 완료하세요. <br>
							</div>
					</div>
					
					<div class="half-flex-div-gif">
						<div class="gif-container">		
							<div class="guide_img">
								<img class="guideImg" src="/model/resources/images/guideImg2.png">
							</div>
						</div>	
					</div>
				</div>			
			</div>
			
			<div class="section-container">
				<div class="flex-container">
					<div class="half-flex-div-gif">
						<div class="gif-container">		
							<div class="guide_img">
								<img class="guideImg" src="/model/resources/images/guideImg3.png">
							</div>
						</div>	
					</div>

					<div class="half-flex-div-text">
						<div class="section-title-text">3. 일정 확인 및 편집</div>
							<div class="section-text">
								제주트리가 위치, 동선, 장소별 영업시간 등 여행 일정에 필요한 <br>
								모든 요소를 고려하여 만들어준 최적의 여행 일정을 확인하세요. <br>
								장소를 드래그하여 일정을 수정하고 일자별 스케줄을 확인해보세요. <br>
								일정을 저장하면 웹과 앱 언제든지 편집이 가능하고 친구와 공유도 가능합니다. <br>
							</div>
					</div>
				</div>			
			</div>
			
			<div class="section-container">
				<div class="flex-container">
					<div class="half-flex-div-text">
						<div class="section-title-text">4. 시작</div>
							<div class="section-text">
								모든 준비가 끝났습니다. <br>
								웹에서나 앱에서나 마이페이지에서 일정을 확인하세요. <br>
								일정표를 PDF로 출력하거나 모바일 일정표를 보며 여행을 즐기세요! <br>
							</div>
					</div>
					
					<div class="half-flex-div-gif">
						<div class="gif-container">		
							<div class="guide_img">
								<img class="guideImg" src="/model/resources/images/guideImg4.png">
							</div>
						</div>	
					</div>
				</div>			
			</div>
		</div>		
	</div>
</div>

<span class="to-top" onclick="scrollToTop()">&#9650;</span>

<div>
<%@ include file="../include/footer.jsp" %>
</div>
	
</body>
</html>
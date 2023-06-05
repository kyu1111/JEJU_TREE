<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mainpage/mainpage.css"> 
    <!-- Add jQuery library -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>
	 <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
	 
    <title>GIF 슬라이드</title>
    <script type="text/javascript">
        let slideIndex = 0;

        function slideGifs() {
            const slides = document.querySelectorAll('.slide');
            for (let i = 0; i < slides.length; i++) {
                slides[i].style.display = 'none';
            }
            slideIndex++;
            if (slideIndex > slides.length) {
                slideIndex = 1;
            }
            slides[slideIndex - 1].style.display = 'block';
            updateDots();
            setTimeout(slideGifs, 4000); // 이미지 변경 시간 (3000ms = 3초)
        }

        function updateDots() {
            const dots = document.querySelectorAll('.dot');
            for (let i = 0; i < dots.length; i++) {
                dots[i].classList.remove('active');
            }
            dots[slideIndex - 1].classList.add('active');
        }

        function moveToSlide(n) {
            clearTimeout(slideGifs);
            slideIndex = slideIndex + n;
            const slides = document.querySelectorAll('.slide');
            if (slideIndex > slides.length) {
                slideIndex = 1;
            }
            if (slideIndex < 1) {
                slideIndex = slides.length;
            }
            for (let i = 0; i < slides.length; i++) {
                slides[i].style.display = 'none';
            }
            slides[slideIndex - 1].style.display = 'block';
            updateDots();
        }

        function currentSlide(n) {
            clearTimeout(slideGifs);
            moveToSlide(n - slideIndex);
        }
        
        function scrollToTop() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
    </script>
    
    <!-- 폰트어썸 cdn링크 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.0/css/all.min.css" integrity="sha512-10/jx2EXwxxWqCLX/hHth/vu2KY3jCF70dCQB8TSgNjbCVAC/8vai53GfMDrO2Emgwccf2pJqxct9ehpzG+MTw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

</head>

<body onload="slideGifs()">

<!-- 상단바 설정하기  -->
<%@ include file="./include/navbar.jsp" %>
	 <div class = "container">
	 
	 <div class="main_content">
     <div class="container_wrap">  
        <div class="intro-text" align="center">
            <p style="font-size:26px; text-align: left; padding-left: 21%">
           		<b style="font-size:28px;">JEJU TREE</b> 에서 손쉽게 <br>
               	여행 일정을 계획하세요.
            </p>
            <div class="button-container">
                <button class="btn-day" onclick="location.href='tmap.go'">일정 만들기</button>
                <button class="btn-guide" onclick="location.href='guidePage.go'">이용 가이드</button>
              <!--  <button class="btn-drag" onclick="location.href='drag_plan_list.go'">DragFunction</button> -->
            </div>
        </div>
        		
        <div class="slider">
        		
            <div class="arrows">
                <span class="prev" onclick="moveToSlide(-1)">&#10094;</span>
                <span class="next" onclick="moveToSlide(1)">&#10095;</span>
            </div>
            	
            <div class="slides">
            
                <img class="slide" src="<%=request.getContextPath()%>/resources/images/spring.gif" alt="GIF 1">
                <img class="slide" src="<%=request.getContextPath()%>/resources/images/summer.gif" alt="GIF 2">
                <img class="slide" src="<%=request.getContextPath()%>/resources/images/fall.gif" alt="GIF 3">
                <img class="slide" src="<%=request.getContextPath()%>/resources/images/winter.gif" alt="GIF 4">
                <!-- 추가로 슬라이드 이미지를 넣고 싶다면 위의 양식을 그대로 따라하되 새로운 .gif을 지정해주면 됩니다. -->
                
            </div>
            
            <div class="dots">
            
                <span class="dot" onclick="currentSlide(1)"></span>
                <span class="dot" onclick="currentSlide(2)"></span>
                <span class="dot" onclick="currentSlide(3)"></span>
                <span class="dot" onclick="currentSlide(4)"></span>
                
            </div>
            
        </div>
	</div>
  
    
    <!-- 인스타 핫플 영역 -->
    <div class="container-insta-hot">
        <div class="insta-hot">
            <h2 style="text-align: center; margin-bottom: 20px;">#인스타 핫플</h2>
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap; margin-bottom: 60px;">
            <a class="image-container" href="<%=request.getContextPath()%>/">
           <img src="<%=request.getContextPath()%>/resources/images/카페 엘리펀트힙-470.jpg" alt="Image 1">
           <div class="hidden-content">
               <span class="sp-cont"><span class="sp-title">카페 엘리펀트힙</span><br>
               	제주공항 근처 에그인더헬이 맛있는 <br>
               	핫플레이스 브런치카페 <br><br>
                #제주공항 #브런치 #카페 #맛집</span>
           </div>
         </a> 
         <a class="image-container" href="<%=request.getContextPath()%>/">
           <img src="<%=request.getContextPath()%>/resources/images/카페 그계절-470.jpg" alt="Image 2">
           <div class="hidden-content">
              <span class="sp-cont"><span class="sp-title">카페 그계절</span><br>
               	제주 구좌읍 초록이들 가득한 <br>
               	플렌테리어 카페 <br><br>
                #반려동물가능 #카페 #포토존 #싱그러움</span>
           </div>
         </a> 
            <a class="image-container" href="<%=request.getContextPath()%>/">   
                <img src="<%=request.getContextPath()%>/resources/images/카페 까르네-470.jpg" alt="Image 3">
                <div class="hidden-content">
                   <span class="sp-cont"><span class="sp-title">카페 까르네</span><br>
               		제철 과일을 이용한 디저트와  <br>
               		음료를 즐길 수 있는 구좌읍 상도리 카페<br><br>
               		#야외석 #카페 #디저트 #반려동물</span>
            </div>
            
         </a>
            </div>
        </div>
    </div>
    
    <!-- 스테디 인기 영역 -->
    <div class="container-steady-hot">
        <div class="steady-hot">
            <h2 style="text-align: center; margin-bottom: 20px;">#스테디 인기</h2>
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap; margin-bottom: 60px;">
                 <a class="image-container" href="<%=request.getContextPath()%>/">
           <img src="<%=request.getContextPath()%>/resources/images/오설록티뮤지엄-470.jpg" alt="Image 1">
           <div class="hidden-content">
              <span class="sp-cont"><span class="sp-title">오설록티뮤지엄</span><br>
                  	제주 녹차 문화의 중심<br>
                  	차 박물관과 카페테리아 <br><br>
                  	#녹차 #여름포토스팟 #디저트 #카페</span>
            </div>
         </a> 
         <a class="image-container" href="<%=request.getContextPath()%>/">
           <img src="<%=request.getContextPath()%>/resources/images/용머리해안-470.jpg" alt="Image 2">
           <div class="hidden-content">
                 <span class="sp-cont"><span class="sp-title">용머리해안</span><br>
                 	한국의 그랜드 캐니언<br>
                 	멋진 지질트레일 덕분에 핫플레이스<br><br>
               		#서귀포 #해변 #유네스코 #시간확인필수</span>
            </div>
         </a> 
            <a class="image-container" href="<%=request.getContextPath()%>/">   
                <img src="<%=request.getContextPath()%>/resources/images/신창풍차해안도로-470.jpg" alt="Image 3">
                <div class="hidden-content" >
                   <span class="sp-cont"><span class="sp-title">신창풍차해안도로</span><br>
                   		예쁜 바다와 풍차를 한번에 찍을 수 있는 곳<br>
                   		해질녘 드라이브 최고의 명소<br><br>
                   		#커플 #노을맛집 #드라이브 #사진필수</span>
            </div>
            
         </a>
            </div>
        </div>
    </div>
    
    <!-- 사진 핫플 영역 -->
    <div class="container-photo-hot">
        <div class="photo-hot">
            <h2 style="text-align: center; margin-bottom: 20px;">#사진 맛집</h2>
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap; margin-bottom: 60px;">
                 <a class="image-container" href="<%=request.getContextPath()%>/">
           <img src="<%=request.getContextPath()%>/resources/images/김녕바닷길-470.jpg" alt="Image 1">
           <div class="hidden-content">
              <span class="sp-cont"><span class="sp-title">김녕바닷길</span><br>
              		제주 동쪽 여행 중 바닷가 필수 코스<br>
              		제주 바다 감성을 물씬 느낄 수 있는 명소<br><br>
               		#제주감성 #예쁜바다 #인생샷 #스노쿨링</span>
            </div>
         </a> 
         <a class="image-container" href="<%=request.getContextPath()%>/">
           <img src="<%=request.getContextPath()%>/resources/images/노루손이 오름-470.jpg" alt="Image 2">
           <div class="hidden-content" >
              <span class="sp-cont"><span class="sp-title">노루손이 오름</span><br>
              		등린이도 도전할 수 있는 등산코스<br>
              		뷰가 예뻐서 사진 찍기에 좋은 오름<br><br>
               		#자연 #트레킹 #뷰맛집 #반려동물가능</span>
            </div>
         </a> 
         <a class="image-container" href="<%=request.getContextPath()%>/">   
            <img src="<%=request.getContextPath()%>/resources/images/안돌오름-470.jpg" alt="Image 3">
            <div class="hidden-content">
               <span class="sp-cont"><span class="sp-title">안돌오름</span><br>
	               	숲길 사진으로 유명한 안돌오름 비밀의 숲<br>
	               	스냅 촬영의 성지이자 요즘 핫한 명소<br><br>
	           		#사진필수 #커플 #초원 #숲길</span>
            </div>
            
         </a>
            </div>
            </div>
    </div>
    
    <br>
    <br>
    <br>
    <br>
    <br>
    
    <span class="to-top" onclick="scrollToTop()">&#9650;</span>
	</div>
	</div>
	<%@ include file="./include/footer.jsp" %>
</html>

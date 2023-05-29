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
            <h2>
                <i class="fa-solid fa-plane fa-3x" style="position:relative; top:-10px; left:-135px;"></i>
            </h2>
            <p style="font-size:30px;">
                	손쉽게 일정을  조정하세요.
            </p>
            <div class="button-container">
                <button class="btn" onclick="location.href='tmap.go'">일정 만들기</button>
                <button class="btn">이용 가이드</button>
                <button class="btn" onclick="location.href='share.go'">일정 공유하기1</button>
				<button class="btn" onclick="location.href='share2.go'">일정 공유하기2</button>
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
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap;">
            <a class="image-container" href="<%=request.getContextPath()%>/">
			  <img src="<%=request.getContextPath()%>/resources/images/카페 엘리펀트힙-470.jpg" alt="Image 1">
			  <div class="hidden-content">
			      <h3>카페 엘리펀트힙</h3>
			      <p>제주공항 근처 에그인더헬이 맛있는 핫플레이스 브런치카페</p>
			   </div>
			</a> 
			<a class="image-container" href="<%=request.getContextPath()%>/">
			  <img src="<%=request.getContextPath()%>/resources/images/카페 그계절-470.jpg" alt="Image 2">
			  <div class="hidden-content">
			  	<h3>카페 그계절</h3>
			      <p>제주 구좌읍카페 초록이들 가득한 플렌테리어카페</p>
			   </div>
			</a> 
            <a class="image-container" href="<%=request.getContextPath()%>/">   
                <img src="<%=request.getContextPath()%>/resources/images/카페 까르네-470.jpg" alt="Image 3">
                <div class="hidden-content">
                	<h3>카페 까르네</h3>
			      <p>구좌읍 상도리에 위치한 작은 디저트 카페.</p>
			   </div>
			   
			</a>
            </div>
        </div>
    </div>
    
    <!-- 스테디 인기 영역 -->
    <div class="container-steady-hot">
        <div class="steady-hot">
            <h2 style="text-align: center; margin-bottom: 20px;">#스테디 인기</h2>
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap;">
                 <a class="image-container" href="<%=request.getContextPath()%>/">
			  <img src="<%=request.getContextPath()%>/resources/images/오설록티뮤지엄-470.jpg" alt="Image 1">
			  <div class="hidden-content">
				  <h3>오설록티뮤지엄</h3>
				      <p>제주녹차문화의 중심, 차박물관과 카페테리아</p>
			   </div>
			</a> 
			<a class="image-container" href="<%=request.getContextPath()%>/">
			  <img src="<%=request.getContextPath()%>/resources/images/용머리해안-470.jpg" alt="Image 2">
			  <div class="hidden-content">
			  		<h3>용머리해안</h3>
			      <p>#해변 #휴식/힐링 #부모님 동반 #커플 #맑음 #봄 #자연경관 #유네스코 #무장애관광</p>
			   </div>
			</a> 
            <a class="image-container" href="<%=request.getContextPath()%>/">   
                <img src="<%=request.getContextPath()%>/resources/images/신창풍차해안도로-470.jpg" alt="Image 3">
                <div class="hidden-content" >
                	<h3>신창풍차해안도로</h3>
			      <p>#커플 #경관/포토 #해안도로 #드라이브 #반려동물동반입장 #반려동물동반_산책로 #반려동물동반_자연 #반려동물동반_관광지</p>
			   </div>
			   
			</a>
            </div>
        </div>
    </div>
    
    <!-- 사진 핫플 영역 -->
    <div class="container-photo-hot">
        <div class="photo-hot">
            <h2 style="text-align: center; margin-bottom: 20px;">#사진 맛집</h2>
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap;">
                 <a class="image-container" href="<%=request.getContextPath()%>/">
			  <img src="<%=request.getContextPath()%>/resources/images/김녕바닷길-470.jpg" alt="Image 1">
			  <div class="hidden-content">
			  	<h3>김녕바닷길</h3>
			      <p>#지질트레일 #걷기/등산 #친구 #커플 #가을 #겨울 #자연경관 #체험</p>
			   </div>
			</a> 
			<a class="image-container" href="<%=request.getContextPath()%>/">
			  <img src="<%=request.getContextPath()%>/resources/images/노루손이 오름-470.jpg" alt="Image 2">
			  <div class="hidden-content" >
			  	<h3>노루손이 오름</h3>
			      <p>#자연 #목장 #노루생이오름 #트레킹 #고사리 #고사리꺽기 #검은오름 #노리오름</p>
			   </div>
			</a> 
            <a class="image-container" href="<%=request.getContextPath()%>/">   
                <img src="<%=request.getContextPath()%>/resources/images/안돌오름-470.jpg" alt="Image 3">
                <div class="hidden-content">
                	<h3>안돌오름</h3>
			      <p>#친구 #아이 #맑음 #오름 #자연경관 #도보여행 #도보 #어린이</p>
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

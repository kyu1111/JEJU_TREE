<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GIF 슬라이드</title>
    <style>
    
        .container {
        
            display: flex;
            justify-content: center;
            align-items: center;
            height: calc(100vh - 80px); /* 상단 여백 조정 */
            
        }
        
        .container-insta-hot, .container-steady-hot, .container-photo-hot {
  			margin: 10px 0;
		}

        .slider {
            width: 100%;
            position: relative;
            overflow: hidden;
        }

        .slides {
            display: flex;
            transition: transform 0.6s ease-in-out;
        }

        .slide {
            flex-shrink: 0;
            width: 100%;
            height: 540px; /* 슬라이드의 크기 조정 */
            object-fit: cover;
        }

        .intro-text {
        
            width: 50%;
            padding-right: 20px;
            
        }

        .arrows {
        
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 100%;
            display: flex;
            justify-content: space-between;
            z-index: 10;
            
        }

        .prev, .next {
        
            cursor: pointer;
            font-size: 24px;
            padding: 8px;
            background-color: rgba(0, 0, 0, 0.5);
            color: white;
            border-radius: 50%;
            
        }

        .dots {
        
            position: absolute;
            bottom: 10px;
            display: flex;
            justify-content: center;
            width: 100%;
            z-index: 10;
            
        }

        .dot {
        
            cursor: pointer;
            height: 10px;
            width: 10px;
            margin: 0 4px;
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            display: inline-block;
            
        }

        .dot.active {
        
            background-color: rgba(255, 255, 255, 0.9);
            
        }
        
        .button-container {
        
            margin-top: 20px;
            display: flex;
            justify-content: center;
            flex-direction: column; /* 버튼을 세로로 나열 */
            align-items: center; /* 버튼을 수직으로 가운데 정렬 */
            
        }

        .btn {
        
            font-size: 18px;
            width: 350px; /* 버튼 너비 지정 */
            height: 45px; /* 버튼 높이 지정 */
            padding: 12px 24px;
            margin: 8px 0; /* 버튼 간격 조정 */
            cursor: pointer;
            border: none;
            border-radius: 5px;
            color: white;
            background-color: #007bff;
            transition: background-color 0.3s;
            display: flex; /* 추가 */
            justify-content: center; /* 추가 */
            align-items: center; /* 추가 */
            
        }

        .btn:hover {
        
            background-color: #0056b3;
            
        }
        
		.to-top {
		
    		position: fixed;
   		    bottom: 20px;
    		right: 20px;
    		z-index: 99;
    		font-size: 24px;
    		padding: 8px;
    		background-color: rgba(0, 0, 0, 0.5);
    		color: white;
    		border-radius: 50%;
    		cursor: pointer;
    		
		}
		
        .insta-hot {
        
            display: flex;
            flex-direction: column;
            align-items: center;
            
        }
		
    </style>
    
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
<%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="intro-text" align="center">
            <h2>
                <i class="fa-solid fa-plane fa-3x" style="position:relative; top:-10px; left:-135px;"></i>
            </h2>
            <p style="font-size:30px;">
            
                	손쉽게 일정을  조정하세요.
            
            </p>
            <div class="button-container">
                <button class="btn">일정짜기</button>
                <button class="btn">이용 가이드</button>
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
                <img src="<%=request.getContextPath()%>/resources/images/image1.jpg" alt="Image 1" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
                <img src="<%=request.getContextPath()%>/resources/images/image2.jpg" alt="Image 2" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
                <img src="<%=request.getContextPath()%>/resources/images/image3.jpg" alt="Image 3" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
            </div>
        </div>
    </div>
    
    <!-- 스테디 인기 영역 -->
    <div class="container-steady-hot">
        <div class="steady-hot">
            <h2 style="text-align: center; margin-bottom: 20px;">#스테디 인기</h2>
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap;">
                <img src="<%=request.getContextPath()%>/resources/images/image1.jpg" alt="Image 1" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
                <img src="<%=request.getContextPath()%>/resources/images/image2.jpg" alt="Image 2" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
                <img src="<%=request.getContextPath()%>/resources/images/image3.jpg" alt="Image 3" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
            </div>
        </div>
    </div>
    
    <!-- 사진 핫플 영역 -->
    <div class="container-photo-hot">
        <div class="photo-hot">
            <h2 style="text-align: center; margin-bottom: 20px;">#사진 맛집</h2>
            <div style="display: flex; justify-content: space-around; flex-wrap: wrap;">
                <img src="<%=request.getContextPath()%>/resources/images/image1.png" alt="Image 1" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
                <img src="<%=request.getContextPath()%>/resources/images/image2.png" alt="Image 2" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
                <img src="<%=request.getContextPath()%>/resources/images/image3.png" alt="Image 3" style="width: 30%; height: auto; margin-bottom: 20px; border-radius: 5px;">
            </div>
        </div>
    </div>
    
    <br>
    <br>
    <br>
    <br>
    <br>
    
    <span class="to-top" onclick="scrollToTop()">&#9650;</span>
</body>
</html>

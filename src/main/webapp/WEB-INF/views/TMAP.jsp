<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>simpleMap</title>
<style type="text/css">
#map_div {
	margin-top: 80px; /* 상단바와 지도가 겹치게 하지 않기 위함. */
}

/* 거리표시 팝업*/
.mPop {
	border: 1px;
	background-color: #FFF;
	font-size: 12px;
	border-color: #FF0000;
	border-style: solid;
	text-align: center;
}

/*공통사용 클래스*/
.mPopStyle {
	border: 1px;
	background-color: #FFF;
	font-size: 12px;
	border-color: #FF0000;
	border-style: solid;
	text-align: left;
}
</style>
<script
	src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>
<script type="text/javascript">
	var map;
	function initTmap() {
			map = new Tmapv2.Map("map_div", {
			center : new Tmapv2.LatLng(33.361666, 126.529167), // 지도 초기 좌표
			width : "890px",
			height : "400px",
			zoom : 10
		});
		map.addListener("click", onClick); // 이벤트의 종류와 해당 이벤트 발생 시 실행할 함수를 리스너를 통해 등록합니다
		map.addListener("zoom_changed", onChanged); // 지도의 줌 변경시, 이벤트 리스너 등록.
		map.addListener("drag", onDrag); // 지도 드래그시, 이벤트 리스너 등록.
		map.addListener("dragstart", onDragstart); // 지도 드래그 시작시, 이벤트 리스너 등록.
		map.addListener("dragend", onDragend); // 지도 드래그 끝났을 때, 이벤트 리스너 등록.
		map.addListener("contextmenu", onContextmenu); // 지도 우클릭시, 이벤트 리스너 등록.
		map.addListener("touchstart", onTouchstart); // 모바일에서 지도 터치 시작시, 이벤트 리스너 등록.
		map.addListener("touchend", onTouchend); // 모바일에서 지도 터치 터치가 끝났을때, 이벤트 리스너 등록.
	}
	
	function onClick(e) {
		var result = '클릭한 위치의 좌표는' + e.latLng + '입니다.';
		var resultDiv = document.getElementById("result");
		resultDiv.innerHTML = result;
	}
	
	function onChanged(e) {
		var result = '현재 zoom : ' + e.zoom+ '입니다.';
		var resultDiv = document.getElementById("result");
		resultDiv.innerHTML = result;
	}
	
	function onDrag(e) {
		var result = '드래그한 위치의 좌표는' + e.latLng + '입니다.';
		var resultDiv = document.getElementById("result");
		resultDiv.innerHTML = result;
	}
	
	function onDragstart(e) {
		var result = '드래그를 시작한 위치의 좌표는' + e.latLng + '입니다.';
		var resultDiv = document.getElementById("result");
		resultDiv.innerHTML = result;
	}
	
	function onDragend(e) {
		var result = '드래그가 끝난 위치의 중앙좌표는' + e.latLng + '입니다.';
		var resultDiv = document.getElementById("result");
		resultDiv.innerHTML = result;
	}
	
	function onContextmenu(e) {
		var result = '우클릭한 위치의 좌표는' + e.latLng + '입니다.';
		var resultDiv = document.getElementById("result");
		resultDiv.innerHTML = result;
	}
	
	function onTouchstart(e) {
		var result = '모바일에서 터치가 시작된 위치의 좌표는' + e.latLng + '입니다.';
		var resultDiv = document.getElementById("result");
		resultDiv.innerHTML = result;
	}

	function onTouchend(e) {
		var result = '모바일에서 터치가 끝난 위치의 좌표는' + e.latLng + '입니다.';
		var resultDiv = document.getElementById("result");
		resultDiv.innerHTML = result;
	}
	
</script>
</head>
<body onload="initTmap()">
	<!-- 상단바 설정  -->
	<%@ include file="./include/navbar.jsp"%>
	<div id="map_div"></div>
	<p id="result" />
</body>
</html>

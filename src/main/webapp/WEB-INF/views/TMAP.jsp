<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>simpleMap</title>
<!-- Add jQuery library -->
<script src="https://cdn.jsdelivr.net/npm/@turf/turf@6/turf.min.js"></script>
<script src = "https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src = "https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/sidebar.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/tmap/tmap.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar_ajax.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/include/sidebar.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/weather-icons/2.0.9/css/weather-icons.min.css">


<!-- 폰트어썸 cdn링크 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
  
<script type="text/javascript">
$(() => {
   //사이드바에 북마크 목록+해제버튼 생성
   $('.openbtn2').click(function(){
       $.ajax({
           url: "bm_list.go",
           method: "POST",
           dataType : "json",
           contentType: "application/json; charset=UTF-8",
           async: false,
           success: function(data) {
              console.log(data);
              let list = data.list;
              let table = "";
              for(let i=0;i<list.length;i++){
                 let cont = list[i];
                 table += "<tr>" +
                           "<td>"+cont.location+"</td>" +
                           "<td class='td_x'><input type='button' value='×' onclick='bookmark_del(\""+cont.location+"\",this)'></td>" +
                       "</tr>";
              }
              console.log($('.blist_table').find('tr:gt(0)'));
              $('.blist_table').find('tr:gt(0)').remove();
              $('.blist_table').append(table);
           },
           error : function(request, status, error) {
              console.log("code:" + request.status + "\n" + "error:" + error + "\n" + "errortext:" + request.responseText );
           }
       });
   });
});

//사용자 ID를 가져오는 함수
function getUserID(userId, title) {
  $.ajax({
    url: "/get_user_id.go", // 사용자 ID를 가져오는 서버 엔드포인트 URL
    method: "POST",
    dataType: "text",
    success: function(response) {
      userId = response; // 수정된 부분: 서버로부터 가져온 사용자 ID 값을 변수에 저장
      toggleBm(itemId, userId, title);
    },
    error: function(xhr, status, error) {
       console.log("에러 발생 (상태 코드: " + xhr.status + "): " + xhr.responseText);
    }
  });
}

// 북마크 해제
function bookmark_del(location, self){
   $.ajax({
        url: "bm_delete_ok.go",
        method: "POST",
        data: {
           location: location
        },
        dataType : "text",
        async: false,
        success: function(data) {
           console.log(data);
           if(data>0){
              $(self).parent().parent().remove();
           }else{
              alert('실패');
           }
        },
        error : function(request, status, error) {
           console.log("code:" + request.status + "\n" + "error:" + error + "\n" + "errortext:" + request.responseText );
        }
    });
}

// 북마크 클릭 함수
function toggleBm(title) {
 var h = $('#heart');
 let userId = '${user_id}';
   console.log(title);
   console.log("아이디", userId);
 $.ajax({
   url: "toggle_like.go",
   method: "get",
   data: { 
      user_id : userId,
      location : title 
   },
   dataType: "text",
   success: function(response) {
      if(response>0) {
          let table = "<tr>" +
                        "<td>"+title+"</td>" +
                        "<td><input type='button' value='해제' onclick='bookmark_del(\""+title+"\",this)'></td>" +
                       "</tr>";
         $('.blist_table').append(table);
       }else if(response == -1){
          alert('이미 등록된 장소입니다');
       }else{
          alert('실패');
       }
   },
   error: function(xhr, status, error) {
      console.log("에러 발생 (상태 코드: " + xhr.status + "): " + xhr.responseText);
   }
 });
}

var map;
var infoWindow;
var marker;
var markerArr = [], labelArr = [];
var popupCount2 = 0;
var isDrawing = false;
var fixedMarkers = [];
var userMarkers = [];
var infoWindow = null;  // 전역 변수로 선언
var line = null;
var polygon = null;

// map 생성
function initTmap() {
      // map 생성 
      map = new Tmapv2.Map("map_div", {
         center : new Tmapv2.LatLng(33.3666, 126.5333),
         width : "70%", // 지도의 넓이
         height : "400px", // 지도의 높이
         zoom : 10
         // zoomControl : true,
       // scrollwheel : true
      });
      
      fixedMarkers[0] = new Tmapv2.Marker({
         position : new Tmapv2.LatLng(33.361666, 126.529166), // 한라산 국립공원
         map : map,
         visible : false
      });

      fixedMarkers[0].addListener( "click", function() {
               var content = "<form id='infoWindowForm'>"
                   + "<div style='width:200px; height:20px; position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"
                   + "<div style='font-size: 12px; line-height: 15px;'>"
                   + "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>티맵 모빌리티"
                   + "</div>"
                   + "</div>"
                   + "<div style='position: relative; padding-top: 5px; display:inline-block'>"
                   + "<div style='display:inline-block; border:1px solid #dcdcdc;'><img src='/resources/images/common/sk_logo.png' width='73' height='70'></div>"
                   + "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"
                   + "<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>서울 중구 삼일대로 343 (우)04538</span>"
                   + "<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>(지번) 저동1가 114</span>"
                   + "<span style='font-size: 12px; margin-left:2px;'><a href='https://openapi.sk.com/' target='blank'>개발자센터</a></span>"
                 //+ "<p>Start Date : <input type='date' class = 'plan_start_date' name='start_date'></p>" // Start Date input field
                 //+ "<p>End Date : <input type='date' class = 'plan_end_date' name='end_date'></p>" // End Date input field
                   + "<input type='submit' style='position: absolute; top: 0; right: 0;' value='Close' />"
                   + "</div>"
                   + "</div>"
                   + "</form>";

                     var infoWindow = new Tmapv2.InfoWindow({
                        position : new Tmapv2.LatLng(33.361666, 126.529166),
                        content : content,
                        map : map
                     });
                     
                  });

      fixedMarkers[1] = new Tmapv2.Marker({
         position : new Tmapv2.LatLng(33.455483, 126.768394), // 성산일출봉
         map : map,
         visible : false
      });

      fixedMarkers[1].addListener( "click", function() {
         var content = "<form id='infoWindowForm'>"
             + "<div style='width:200px; height:20px; position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"
             + "<div style='font-size: 12px; line-height: 15px;'>"
             + "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>티맵 모빌리티"
             + "</div>"
             + "</div>"
             + "<div style='position: relative; padding-top: 5px; display:inline-block'>"
             + "<div style='display:inline-block; border:1px solid #dcdcdc;'><img src='/resources/images/common/sk_logo.png' width='73' height='70'></div>"
             + "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"
             + "<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>서울 중구 삼일대로 343 (우)04538</span>"
             + "<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>(지번) 저동1가 114</span>"
             + "<span style='font-size: 12px; margin-left:2px;'><a href='https://openapi.sk.com/' target='blank'>개발자센터</a></span>"
             //+ "<p>Start Date : <input type='date' class = 'plan_start_date' name='start_date'></p>" // Start Date input field
             //+ "<p>End Date : <input type='date' class = 'plan_end_date' name='end_date'></p>" // End Date input field
             + "<input type='submit' style='position: absolute; top: 0; right: 0;' value='Close' />"
             + "</div>"
             + "</div>"
             + "</form>";

                  var infoWindow = new Tmapv2.InfoWindow({
                     position : new Tmapv2.LatLng(33.458875, 126.942933),
                     content : content,
                     map : map
                  });
                  
               });

      fixedMarkers[2] = new Tmapv2.Marker({
          position : new Tmapv2.LatLng(33.458875, 126.942933), // 주상절리대
          icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_g_m_h.png",
          iconSize : new Tmapv2.Size(24, 38),
          map : map,
          visible : false
       });

      fixedMarkers[2].addListener( "click", function() {
          var content = "<form id='infoWindowForm' action='<%=request.getContextPath()%>/plans_insert_ok.go' method='post'>"
              + "<input type='hidden' name='title' value='성산일출봉'>"
              + "<input type='hidden' name='addr' value='제주 서귀포시 성산읍 성산리 1'>"
              + "<div class='heartAddX'><a class='heart' data-item-id='item-1' href='#' onclick=\'toggleBm(\"성산일출봉\")\'><i id='heart' class='fas fa-heart'></i></a>"
              + "<button id='selectButtonPlaceholder' type='submit'>일정 추가</button><a id='closeButtonPlaceholder' class='close-btn'>×</a></div>"
              + "<input type='hidden' name='location' value='성산일출봉'>"
              + "<input type='hidden' name='markerLat' value='33.458875'>" // replace 'latitude' with real value
              + "<input type='hidden' name='markerLng' value='126.942933'>" // replace 'longitude' with real value
              + "<div style='padding:10px; width:250px;'>성산일출봉"
              + "<div>제주 서귀포시 성산읍 성산리 1</div>"
              + "<p class='start'>입장 : <input type='date' class='plan_start_date' name='start_date'></p>" // Start Date input field
              + "<p class='end'>퇴장 : <input type='date' class='plan_end_date' name='end_date'></p>" // End Date input field
              + "</form>";

                  var infoWindow = new Tmapv2.InfoWindow({
                     position : new Tmapv2.LatLng(33.455483, 126.768394),
                     content : content,
                     map : map
                  });
                  
                  setTimeout(function() {
                      var closeButton = document.getElementById('closeButtonPlaceholder');
                      var submitButton = document.getElementById('selectButtonPlaceholder');

                      if (closeButton) {
                          closeButton.addEventListener('click', function(event) {
                              event.preventDefault();
                              infoWindow.setMap(null);
                          });
                      }

                      if (submitButton) {
                          submitButton.addEventListener('click', function(event) {
                              // 원하는 경우 이 라인을 제거하여 폼 제출 시 페이지 새로고침을 허용
                              event.preventDefault(); 
                              document.getElementById('infoWindowForm').submit();
                          });
                      }
                  }, 200);  
                  
               });

      // map.addListener 메서드 시작.
      map.addListener("click", function(e) {
           if (isDrawing) {
               var position = new Tmapv2.LatLng(e.latLng.lat(), e.latLng.lng());
               var marker = new Tmapv2.Marker({
                   position : position,
                    icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png",
                    iconSize : new Tmapv2.Size(24, 38),
                   map : map
               });
               userMarkers.push(marker);
               if (userMarkers.length > 1 && userMarkers.length < 4) {
                   if (line) {
                       line.setMap(null);
                   }
                   var path = userMarkers.map(function(marker) {
                       return marker.getPosition();
                   });
                   line = new Tmapv2.Polyline({
                       path: path,
                       strokeColor: "blue",
                       strokeWeight: 4,
                       map: map
                   });
               } 
               else if (userMarkers.length === 4) {
                   if (line) {
                       line.setMap(null);
                       line = null;
                   }
                   if (polygon) {
                       polygon.setMap(null);
                   }
                   var path = userMarkers.map(function(marker) {
                       return marker.getPosition();
                   });
                   polygon = new Tmapv2.Polygon({
                       paths: path,
                       strokeColor: "#99dce6",
                       fillColor: "#99dce6",
                       fillOpacity: 0.5,
                       map: map
                   });
                   isDrawing = false;
               }
           }
       }); // map.addListener 메서드 종료.
   // 2. POI 통합 검색 API 요청
  $("#btn_select").click(
     function() {
        var searchKeyword = $('#searchKeyword').val(); // 검색 키워드
        var headers = {}; 
        headers["appKey"]="857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ";
        $.ajax({
           method : "GET", // 요청 방식
           headers : headers,
           url : "https://apis.openapi.sk.com/tmap/pois?version=1&format=json&callback=result", // url 주소
           async : false, // 동기설정
           data : { // 요청 데이터 정보
              "searchKeyword" : searchKeyword, // 검색 키워드
              "resCoordType" : "EPSG3857", // 요청 좌표계
              "reqCoordType" : "WGS84GEO", // 응답 좌표계
                "searchtypCd" : "A",
               "radius" : 30,
               "centerLon" : "126.5333",
              "centerLat" : "33.3666",
              "count" : 10 // 가져올 갯수
           },
           success : function(response) {
              var resultpoisData = response.searchPoiInfo.pois.poi;
              // 2. 기존 마커, 팝업 제거
              if (markerArr.length > 0) {
                 for(var i in markerArr) {
                    markerArr[i].setMap(null);
                 }
                 markerArr = [];
              }
              if (labelArr.length > 0) {
                 for (var i in labelArr) {
                    labelArr[i].setMap(null);
                 }
                 labelArr = [];
              }
              var innerHtml = ""; // Search Reulsts 결과값 노출 위한 변수
              //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
              var positionBounds = new Tmapv2.LatLngBounds(); 

              // 3. POI 마커 표시
              for (var k in resultpoisData) {
                 // POI 마커 정보 저장
                 var noorLat = Number(resultpoisData[k].noorLat);
                 var noorLon = Number(resultpoisData[k].noorLon);
                 var name = resultpoisData[k].name;
                 // POI 정보의 ID
                 let id = resultpoisData[k].id;
                 // 좌표 객체 생성
                 var pointCng = new Tmapv2.Point(
                       noorLon, noorLat);
                 // EPSG3857좌표계를 WGS84GEO좌표계로 변환
                 var projectionCng = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(pointCng);
                 var lat = projectionCng._lat;
                 var lon = projectionCng._lng;
                 // 좌표 설정
                 var markerPosition = new Tmapv2.LatLng(lat, lon);
                 // Marker 설정
                 marker = new Tmapv2.Marker(
                    {
                       position : markerPosition, // 마커가 표시될 좌표
                       //icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
                       icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_"
                             + k
                             + ".png", // 아이콘 등록
                       iconSize : new Tmapv2.Size(
                             24, 38), // 아이콘 크기 설정
                       title : name, // 마커 타이틀
                       map : map // 마커가 등록될 지도 객체
                    });
                       marker.addListener("click",function(){
                           poiDetail(id); // id는 해당 마커의 POI ID입니다.
                        });
                 // 결과창에 나타날 검색 결과 html
                 innerHtml += "<li><div><img src='http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + k + ".png' style='vertical-align:middle;'/><span>"
                       + name
                       + "</span>  <button type='button' name='sendBtn' onClick='poiDetail("
                       + id
                       + ");'>상세보기</button></div></li>";
                 
                 // 마커들을 담을 배열에 마커 저장
                 markerArr.push(marker);
                 positionBounds.extend(markerPosition); // LatLngBounds의 객체 확장
              }

              $("#searchResult").html(innerHtml); //searchResult 결과값 노출
              // map.panToBounds(positionBounds); // 확장된 bounds의 중심으로 이동시키기
              // map.zoomOut();
              map.setZoom(10);
           },
           error : function(request, status, error) {
              console.log("code:"
                    + request.status + "\n"
                    + "message:"
                    + request.responseText
                    + "\n" + "error:" + error);
           }
        });
     }); // 종료.

     $('#btn_select').trigger('click');
     
   //현재 날씨 정보 
   // 페이지 진입 시 자동으로 제주시 중앙 좌표 날씨 조회 후 출력
   $(document).ready(function () {
      var defaultLat = 33.5008;
      var defaultLon = 126.5469;
      getWeatherInfo(defaultLat, defaultLon);
      getForecastInfo(defaultLat, defaultLon);
   });


   function getWeatherInfo(lat, lon) {
      var apiURI = "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&appid=de6ed7fe5b4d58853d7b79503d5d01fa";

      $.ajax({
         url: apiURI,
         dataType: "json",
         type: "GET",
         async: false,
         success: function (resp) {
            console.log("현재온도 : " + (resp.main.temp - 273.15).toFixed(1));
            console.log("현재습도 : " + resp.main.humidity);
            console.log("날씨 : " + resp.weather[0].main);
            console.log("상세날씨설명 : " + resp.weather[0].description);
            console.log("날씨 이미지 : " + resp.weather[0].icon);
            console.log("바람 : " + resp.wind.speed);
            console.log("나라 : " + resp.sys.country);
            console.log("도시이름 : " + resp.name);
            console.log("구름 : " + resp.clouds.all + "%");

            $('#temp').text((resp.main.temp - 273.15).toFixed(1) + ' °C');
            //$('#humidity').text('현재습도 : ' + resp.main.humidity + '%');
            //$('#windSpeed').text('풍속 : ' + resp.wind.speed + ' m/s');

            var iconClass = 'wi wi-owm-' + resp.weather[0].id;
            $('#icon').attr('class', iconClass);
         },
         error: function () {
            console.log('날씨불러오기 오류');
         }
      });
   }

   function getForecastInfo(lat, lon) {
      var apiURI = "http://api.openweathermap.org/data/2.5/forecast?lat=" + lat + "&lon=" + lon + "&appid=de6ed7fe5b4d58853d7b79503d5d01fa";

      $.ajax({
         url: apiURI,
         dataType: "json",
         type: "GET",
         async: false,
         success: function (resp) {
            var forecastList = resp.list;

            for (var i = 0; i < forecastList.length; i += 8) {
               var forecast = forecastList[i];

               var forecastTime = new Date(forecast.dt * 1000);
               console.log("예보 시간 : " + forecastTime);

               console.log("예상 온도 : " + (forecast.main.temp - 273.15).toFixed(1));
               console.log("예상 습도 : " + forecast.main.humidity);
               console.log("예상 날씨 : " + forecast.weather[0].main);
               console.log("상세날씨설명 : " + forecast.weather[0].description);
               console.log("날씨 이미지 : " + forecast.weather[0].icon);
               console.log("예상 풍속 : " + forecast.wind.speed);
               console.log("예상 구름 : " + forecast.clouds.all + "%");

               $('#forecast-temp-day' + ((i / 8) + 1)).text((forecast.main.temp - 273.15).toFixed(1) + ' °C');
               //$('#forecast-humidity-day' + ((i / 8) + 1)).text('예상 습도 : ' + forecast.main.humidity + '%');
               //$('#forecast-windSpeed-day' + ((i / 8) + 1)).text('예상 풍속 : ' + forecast.wind.speed + ' m/s');

               var iconClass = 'wi wi-owm-' + forecast.weather[0].id;
               $('#day' + ((i / 8) + 1) + '-icon').attr('class', iconClass);
            }
         },
         error: function () {
            console.log('날씨불러오기 오류');
         }
      });
   }
   function getTourInfo(lat, lon) {
        var latlng = {
            _lat: lat,
            _lng: lon
        };
        var defaultImgSrc = "<%=request.getContextPath()%>/resources/images/title.png"; // 기본 이미지 URL

        console.log(latlng);
        var apiURI = "http://api.openweathermap.org/data/2.5/weather?lat=" + latlng._lat + "&lon=" + latlng._lng + "&appid=de6ed7fe5b4d58853d7b79503d5d01fa";

        $.ajax({
            url: 'https://apis.data.go.kr/B551011/KorService1/locationBasedList1?MobileOS=ETC&MobileApp=AppTest&_type=json&numOfRows=10&pageNo=1',
            data: {
                serviceKey: decodeURIComponent('h25GokrXt4MRvyzdkh5DJNs8HRscb9jBf6OX/Fy3AiiTckC7U+HPtX+hXL7yWVJdYWnq4FrIDyjNbM6XQ5iPwA=='),
                mapX: latlng._lng,
                mapY: latlng._lat,
                radius: 100
            },
            success: function(data) {
                if (data && data.response && data.response.body && data.response.body.items && data.response.body.items.item.length > 0) {
                    var item = data.response.body.items.item[0]; // 첫 번째 아이템
                    // 좌표 클릭 시 addr1과 title 합쳐서 크롤링
                    var searchQuery = item.title;
                    $.ajax({
                        url: '<%= request.getContextPath() %>/model/tmap.go',
                        type: 'GET',
                        data: {
                            title: searchQuery
                        },
                        dataType: 'html',
                        success: function(response) {
                            console.log("Response:", response);

                            // 크롤링 결과가 추가되기 전에 기존 데이터 지우기
                            $('#crawlingResult table tr').not(':first').remove();

                            var $responseHtml = $(response);
                            var $table = $responseHtml.find('#crawlingResult table');
                            console.log("$table:", $table.length > 0 ? "Table found" : "Table not found");

                            var $tableRows = $table.find('tr');
                            console.log("$tableRows:", $tableRows.length, "rows found");
                            var $secondRowCells = $table.find('tr:eq(1) td');
                            console.log("$secondRowCells:", $secondRowCells.length, "columns found");

                            $tableRows.each(function(rowIndex) {
                                var $currentRow = $(this);
                                var $cells = $currentRow.find('td');

                                $cells.each(function(cellIndex) {
                                    var cellText = $(this).text();
                                    console.log("Row", rowIndex+1, "Cell", cellIndex+1, ":", cellText);
                                });
                            });

                            var numColumns = 5; // 각 행에 원하는 열의 수
                            var currentRow = '<tr>'; // 현재 행을 시작합니다.

                            $tableRows.each(function(rowIndex) {
                                var $currentRow = $(this);
                                var $cells = $currentRow.find('td');

                                $cells.each(function(cellIndex) {
                                    var title = $(this).text();
                                    var url = $(this).find('a').attr('href');
                                    var thumbnailUrl = $(this).find('img').attr('src');

                                    console.log("Url:::", url);
                                    console.log("Thumbnail URL:::", thumbnailUrl);

                                    // 유효한 값인지 확인
                                    if (url && thumbnailUrl) {
                                        var newCell = '<td>' +
                                            '<a href="' + url + '" target="_blank">' +
                                            '<img src="' + thumbnailUrl + '" alt="Thumbnail" width="200" height="200"><br>' +
                                            title +
                                            '</a>' +
                                            '</td>';

                                        currentRow += newCell;

                                        // 현재 행에 열이 numColumns개 있으면 테이블에 행을 추가하고 새 행을 시작합니다.
                                        if ((cellIndex + 1) % numColumns == 0) {
                                            currentRow += '</tr>';
                                            $('#crawlingResult table').append(currentRow);
                                            currentRow = '<tr>'; // 새 행을 시작합니다.
                                        }
                                    }
                                });
                                // 마지막 행의 마지막 셀이 아직 테이블에 추가되지 않았다면 추가합니다.
                                if (currentRow != '<tr>') {
                                    currentRow += '</tr>';
                                    $('#crawlingResult table').append(currentRow);
                                }
                            });

                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            console.log("AJAX call failed.");
                            console.log("Status: " + textStatus + ", Error: " + errorThrown);
                        }

                    });

                // Check if item.firstimage2 is null or empty
                var Src = item.firstimage2 ? item.firstimage2 : defaultImgSrc;

                // Add a marker and infoWindow at the click position
                var marker = new Tmapv2.Marker({
                   position: new Tmapv2.LatLng(latlng._lat, latlng._lng),
                   map: map
                });

                popupCount2++;
                var popupId2 = 'popup' + popupCount2;
                var selectButtonId2 = 'selectBtn' + popupCount2;
                var closeButtonId2 = 'closeBtn' + popupCount2;

                var content = "<form id='" + popupId2 + "' action='<%=request.getContextPath()%>/plans_insert_ok.go' method='post'>" +
                   "<input type='hidden' name='title' value='" + item.title + "'>" +
                   "<input type='hidden' name='addr' value='" + item.addr1 + "'>" +
                   "<div class='heartAddX'><a class='heart' data-item-id='item-1' href='#' onclick=\'toggleBm(\""+item.title+"\")\'><i id='heart' class='fas fa-heart'></i></a>" +
                   "<button class='selectBt' id='" + selectButtonId2 + "' type='submit'>일정 추가</button><a id='" + closeButtonId2 + "' class='close-btn'>×</a></div>" + 
                   "<input type='hidden' name='location' value='" + item.title + "'>" +
                   "<input type='hidden' name='markerLat' value='" + latlng._lat + "'>" + // latitude input field
                   "<input type='hidden' name='markerLng' value='" + latlng._lng + "'>" + // longitude input field
                   "<div style='padding:10px; width:250px;'>" + item.title +
                   "<div>" + item.addr1 + "</div>" +
                   "<div><img src='" + Src + "' name='image' alt='Image' style='width:100px; height:auto;'></div>" +
                   "<p class='start'>입장 : <input type='date' class='plan_start_date' name='start_date'></p>" + // Start Date input field
                   "<p class='end'>퇴장 : <input type='date' class='plan_end_date' name='end_date'></p>" + // End Date input field
                   "</form>";

                var infoWindow = new Tmapv2.InfoWindow({
                   position: new Tmapv2.LatLng(latlng._lat, latlng._lng),
                   content: content,
                   type: 2,
                   map: map
                });

                // Close button event
                $(document).on('click', '#' + closeButtonId2,
                   function() {
                      infoWindow.setMap(null);
                      marker.setMap(null);
                      $(this).off('click');
                   });

                document.getElementById('selectBtn').addEventListener('click', function(e) {
                   console.log('The select button was clicked.');
                });

                // info btn
                $(document).on('click', '#websiteBtn', function(e) {
                   e.preventDefault();
                   var searchQuery = item.addr1 + ' ' + item.title; // 관광지 제목과 주소를 검색어로 사용
                   var googleSearchURL = "https://www.google.com/search?q=" + encodeURIComponent(searchQuery);
                   window.open(googleSearchURL, '_blank'); // 새 탭에서 구글 검색 결과 열기
                });

             } else {
                console.error("관광정보없음", data);
             }
          }
       });
    }

// 일기예보에 날짜 반영 기능.
   $(document).ready(function () {
       var currentDate = new Date();

       var optionsCurrent = { month: 'numeric', day: 'numeric' };
       var formattedCurrentDate = currentDate.toLocaleDateString('ko-KR', optionsCurrent);
       var splitCurrentDate = formattedCurrentDate.split('.');
       var finalCurrentDate = splitCurrentDate[0] + ' / ' + splitCurrentDate[1];
       $('#date1').text(finalCurrentDate);

       for (var i = 2; i <= 5; i++) {
          var nextDate = new Date();
          nextDate.setDate(currentDate.getDate() + i - 1);

          var optionsNext = { month: 'numeric', day: 'numeric' };
          var formattedNextDate = nextDate.toLocaleDateString('ko-KR', optionsNext);
          var splitNextDate = formattedNextDate.split('.');
          var finalNextDate = splitNextDate[0] + ' / ' + splitNextDate[1];

          $('#date' + i).text(finalNextDate);
       }
    });
   // Map click event listener
   map.addListener("click", function (e) {
       var latlng = e.latLng;
       var defaultImgSrc = "<%=request.getContextPath()%>/resources/images/title.png"; // 기본 이미지 URL

       var lat = latlng._lat;
       var lon = latlng._lng;

       var apiURI = "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&appid=de6ed7fe5b4d58853d7b79503d5d01fa";

       getForecastInfo(lat, lon);
       getWeatherInfo(lat, lon);
       getTourInfo(lat, lon);
    });
   
}  // initTmap() 메서드를 종료시키고 다음 메서드로 넘어갑니다.

var popupCount = 0;

// 4. POI 상세 정보 API
function poiDetail(poiId) {
   console.log(poiId);
   var headers = {}; 
   headers["appKey"]="857KZ5RE6M1rUW7d6KPzX3cF1f6pgN017jnAkmdJ";
   $.ajax({
      method : "GET", // 요청 방식
      headers : headers,
      url : "https://apis.openapi.sk.com/tmap/pois/"
            + poiId // 상세보기를 누른 아이템의 POI ID
            + "?version=1&resCoordType=EPSG3857&format=json&callback=result",
      async : false, // 동기 설정
      success : function(response) {
         console.log(response);
         // 응답받은 POI 정보
         var detailInfo = response.poiDetailInfo;
         var name = detailInfo.name;
         var address = detailInfo.address;
         var noorLat = Number(detailInfo.frontLat);
         var noorLon = Number(detailInfo.frontLon);
         var pointCng = new Tmapv2.Point(noorLon, noorLat);
         var projectionCng = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
               pointCng);
         var lat = projectionCng._lat;
         var lon = projectionCng._lng;
         var labelPosition = new Tmapv2.LatLng(lat, lon);
         popupCount++;
         var popupId = 'popup' + popupCount;
         var selectButtonId = 'selectBtn' + popupCount;
         var closeButtonId = 'closeBtn' + popupCount;
         // 상세보기 클릭 시 지도에 표출할 popup창
         var content = "<form id='" + popupId + "' action='<%=request.getContextPath()%>/plans_insert_ok.go' method='post' style='background-color: white; font-size: 14px;' >"
                     + "<input type='hidden' name='title' value='" + name + "'>"
                     + "<input type='hidden' name='addr' value='" + address + "'>"
                     + "<div class='heartAddX'><a class='heart' data-item-id='item-1' href='#' onclick=\'toggleBm(\""+ name +"\")\'><i id='heart' class='fas fa-heart'></i></a>"
                     + "<button class='selectBt' id='" + selectButtonId + "' type='submit'>일정 추가</button><a id='" + closeButtonId + "' class='close-btn'>×</a></div>"
                     + "<input type='hidden' name='location' value='비자림'>"
                     + "<input type='hidden' name='markerLat' value='" + lat + "'>" // latitude input field
                     + "<input type='hidden' name='markerLng' value='" + lon + "'>" // longitude input field 
                     + "<div class='name_div' style='padding:10px; width:250px;'>" + name
                     + "<div class='addr_div'>"
                     + address
                     + "</div>"
                     // + "<div><img src='" + item.firstimage2 + "' alt='Image' style='width:100px; height:auto;'></div>"
                     + "<p>입장 : <input type='date' class = 'plan_start_date' name='start_date'></p>" // Start Date input field
                     + "<p>퇴장 : <input type='date' class = 'plan_end_date' name='end_date'></p>" // End Date input field
                     + "</form>";
               var labelInfo = new Tmapv2.Label({
                  position : labelPosition,
                  content : content,
                  map : map
               });
               
               $(document).on('click', '#' + closeButtonId,
                     function() {
                        labelInfo.setMap(null); // Removes the label (popup) from the map
                        $(this).off('click');
                     });
               
               document.getElementById('selectBtn').addEventListener('click',function(e) {
                   console.log('The select button was clicked.');
                });
               
               //popup 생성
               // popup들을 담을 배열에 팝업 저장
               labelArr.push(labelInfo);
            },
            error : function(request, status, error) {
               console.log("code:" + request.status + "\n"
                     + "message:" + request.responseText + "\n"
                     + "error:" + error);
            }
         });
} // 종료.

   $(document).ready(function() {
      $('.location').click(function() {
         var lat = $(this).data('lat');
         var lng = $(this).data('lng');

         // Create a new marker
         marker = new Tmapv2.Marker({
            position : new Tmapv2.LatLng(lat, lng),
            map : map
         });

         // Center the map on the new marker
         map.setCenter(new Tmapv2.LatLng(lat, lng));

      });

   });

   function validateAndSubmitForm() {
      if (PlanListValidCheck()) {
         // Get the src value from the img tag
         var imgSrc = $("img[name='image']").attr("src");

         // Add the hidden input field with the imgSrc value
         var content = "<input type='hidden' name='image' value='" + imgSrc + "'>";

         // Rest of your code...
         $('#markerDataForm').append(content);
         $('#markerDataForm').submit();
      } else {
         alert('항목을 모두 입력하셔야 합니다.');
      }
   }
   function PlanListValidCheck() {

      if ($('.plan_start_date').val() == '') {
         return false;
      }
      if ($('.plan_end_date').val() == '') {
         return false;
      }
      return true;
   }
   function planList_check(a) {
      let kid = '${kakao_id}';
      let uid = '${user_id}';
      let user_id = '';

      if (kid != '') {
         user_id = kid;
      } else if (uid != '') {
         user_id = uid;
      }
      console.log(user_id);
      $.ajax({
         url : "planlistCheck.go",
         type : "POST",
         data : {
            user_id : user_id
         },
         success : function(result) {
            //해당 아이디로 저장된 일정리스트가 있는 경우.
            if (result == 1) {
               //수정하는 창으로 보낸다.
               let ask_result = confirm('일정정보를 수정하시겠습니까?');
               if (ask_result) {
                  let url = a;
                  location.href = url;
               }
               //해당 아이디로 저장된 일정리스트가 없는 경우.   
            } else if (result == -1) {
               alert('보유하신 일정 리스트가 없습니다. 일정을 먼저 추가해 주세요.')
            }
         },
         error : function(error) {
            alert("통신 오류.");
         }

      });

   }
   
   function clearMarkers() {
       for (var i = 0; i < markerArr.length; i++) {
           markerArr[i].setMap(null);
       }
       markerArr = [];
       
       $("#searchResult").html("<li>검색결과</li>");
       
       $('#searchKeyword').val("");
   }

   function MapType(type){
       if("SATELLITE" == type){
           map.setMapType(Tmapv2.Map.MapType.SATELLITE);
       }else if("HYBRID" == type){
           map.setMapType(Tmapv2.Map.MapType.HYBRID)
       }else if("ROAD" == type){
           map.setMapType(Tmapv2.Map.MapType.ROAD)
       }
   }
   
   // form의 제출 이벤트에 대응하는 함수.
   function closeInfoWindow(event) {
     event.preventDefault();
     if (infoWindow !== null) {
       infoWindow.setMap(null);  // InfoWindow를 제거.
       infoWindow = null;
     }
   }
   
   // form의 제출 이벤트에 대응하는 함수를 전역으로 등록.
   window.addEventListener('load', function() {
     document.getElementById('infoWindowForm').addEventListener('submit', closeInfoWindow);
   });
   
   var drawingObject = null;
   function drawPolygon() {
       var path = userMarkers.map(function(marker) {
           return marker.getPosition();
       });
       drawingObject = new Tmapv2.extension.Drawing({
           map:map, // 지도 객체
           strokeWeight: 4, // 테두리 두께
           strokeColor:"blue", // 테두리 색상
           strokeOpacity:1, // 테두리 투명도
           fillColor:"red", // 도형 내부 색상
           fillOpacity: 0.5 // 투명도 조정
       });
       drawingObject.drawPolygon({
           paths : path,
       });
   }
   function startDrawing() {
      isDrawing = true;
      userMarkers.forEach(function(marker) {
         marker.setMap(null);
      });
      userMarkers = [];
      // Hide all fixed markers.
      //fixedMarkers.forEach(function(marker) {
      //marker.setVisible(false);
      //});
   }
   function hideMarkers() {
      fixedMarkers.forEach(function(marker) {
       marker.setVisible(false);
      });
      
      if(polygon) {
         polygon.setMap(null);
         polygon = null;
      }
   }
   function stopDrawing() {
      var path = userMarkers.map(function(marker) {
         return [ marker.getPosition().lng(), marker.getPosition().lat() ];
      });
      path.push(path[0]); // Add the first point to the end to close the polygon.
      var polygon = turf.polygon([ path ]);
      fixedMarkers.forEach(function(marker) {
         var point = turf.point([ marker.getPosition().lng(),
               marker.getPosition().lat() ]);
         if (turf.booleanPointInPolygon(point, polygon)) {
            marker.setVisible(true);
         }
      });
      console.log(userMarkers.map(function(marker) {
         return marker.getPosition();
      }));
   }


</script>
</head>
<body onload="initTmap()">
<c:set var = "normal_session" value="${user_id}"/>
<!-- 상단바 설정하기  -->
<%@ include file="./include/navbar.jsp" %>
<br>
<br>
<br>
    <div class="search_container">
      <div class="search_body" style="width: 30%; float:left;">
            <div class="search_title">
            <c:choose>
            <c:when test="${empty requestScope.searchKeyword}">
                    <input type="text" class="text_custom" id="searchKeyword" name="searchKeyword" placeholder="장소를 검색하세요">
                </c:when>
                <c:otherwise>
                    <input type="text" class="text_custom" id="searchKeyword" name="searchKeyword" value="<%=request.getAttribute("searchKeyword")%>">
                </c:otherwise>
            </c:choose>&nbsp;&nbsp;&nbsp;

            <button class="search_bt" id="btn_select">검색</button>
            <button id="btn_clear" onclick="clearMarkers()">초기화</button>
            <br>
            <button class="start_bt" onclick="startDrawing()">시작점</button>&nbsp;
            <button class="end_bt" onclick="stopDrawing()">끝점</button>
            <button class="end_bt" onclick="hideMarkers()">숨김</button>
           </div> 
           
            <div class="search_intro">
               <span>
                  시작점 버튼을 누른 후 추출하고 싶은 장소 주위를 지도에 찍어보세요.<br>
                  그 후 끝점을 누르면 시작점 좌표 중심에 추출하고 싶던 장소가 표시됩니다.<br>
                  숨김버튼을 누르면 폴리곤 영역이 사라집니다.
               </span>
            </div>

         <div class="rst_wrap">
            <div class="rst_mCustomScrollbar" style="height: 277px; overflow: auto;">
               <ul id="searchResult" name="searchResult" style="padding-left: 20px;">
                  <li class="search_list">검색결과</li>
               </ul>
            </div>
         </div>
      </div>



    <div class="map_div" id="map_div" class="map_wrap" style="float:left">
        <!-- 맵 생성 실행 -->
   </div>
    
    <!-- 사이드바 설정하기 -->
   <div id = "container">
   <%@ include file="./include/sidebar2.jsp" %>
   <c:if test="${!empty user_id}">
   <div class="planList_btn_div" align="center"><a class = "planList_btn" onclick="planList_check('<%=request.getContextPath()%>/plan_list.go?id=${user_id}')"><b class="text_b">일정 관리</b></a></div>
   </c:if>
   
   <c:if test="${!empty kakao_id}">
   <div class="planList_btn_div"><a class = "planList_btn" onclick="planList_check('<%=request.getContextPath() %>/plan_list.go?id=${kakao_id}')"><b class="text_b">일정 관리</b></a></div>
   </c:if>
   
   <c:if test="${empty user_id and empty kakao_id}">
   <div class="no_logind_planList_btn_div"></div>
   </c:if>
   
   

        <!-- 날씨 관련 출력창 -->
        <div id="weather-widget" style="float:center" height="400" width="800">
          <table class="weather_table">
              <tr>
                  <td>
                     <div id="date1">
                     
                     </div>
                      <div id="weather" align="center">
                          <img id="icon" src="" alt="">
                      </div>
                      <div id="temperature">
                          <p id="temp"></p>
                      </div>
                  </td>
                  <td>
                     <div id=date2>
                     
                     </div>
                      <div id="forecast-day2">
                          <div id="forecast-weather" align="center">
                              <img id="day2-icon" src="" alt="">
                          </div>
                          <div id="forecast-info-day2">
                              <p id="forecast-temp-day2"></p>
                          </div>
                      </div>
                  </td>
                  <td>
                     <div id="date3">
                     
                     </div>
                      <div id="forecast-day3">
                          <div id="forecast-weather" align="center">
                              <img id="day3-icon" src="" alt="">
                          </div>
                          <div id="forecast-info-day3">
                              <p id="forecast-temp-day3"></p>
                          </div>
                      </div>
                  </td>
                  <td>
                     <div id="date4">
                     
                     </div>
                      <div id="forecast-day4">
                          <div id="forecast-weather" align="center">
                              <img id="day4-icon" src="" alt="">
                          </div>
                          <div id="forecast-info-day4">
                              <p id="forecast-temp-day4"></p>
                          </div>
                      </div>
                  </td>
                  <td>
                     <div id="date5">
                     
                     </div>
                      <div id="forecast-day5">
                          <div id="forecast-weather" align="center">
                              <img id="day5-icon" src="" alt="">
                          </div>
                          <div id="forecast-info-day5">
                              <p id="forecast-temp-day5"></p>
                          </div>
                      </div>
                  </td>
              </tr>
          </table>
      </div>
   </div>   <!-- container div end -->   
   

<div id="crawlingResult" align="center">
    <!-- 크롤링 결과 -->
    <div class="crawling_title"><b class="crawling_title_b">제주 여행지 추천 자료</b></div>
    <table class="crawling_table" border="0" cellspacing="0">
        <tr>
            <th id="titleHeader" colspan="5"></th>
        </tr>
        <c:forEach var="crawlingData" items="${crawlingDataList}" varStatus="loop">
            <c:if test="${loop.index % 5 == 0}">
                <tr>
            </c:if>
            <td>
                <a href="${crawlingData.url}" target="_blank">
                    <img src="${crawlingData.thumbnail}" alt="Thumbnail" width="200" height="200">
                    <br>
                    ${crawlingData.title}
                </a>
            </td>
            <c:if test="${loop.index % 5 == 4 or loop.last}">
            </c:if>
        </c:forEach>
    </table>
</div>
</div>

<br>
<br>
<br>
</body>

<div class="tmap_footer">
   <%@ include file="./include/footer.jsp" %>
</div>

</html>
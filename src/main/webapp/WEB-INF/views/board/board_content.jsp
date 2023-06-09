<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동행자 게시판</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/include/footer.css">

<style type="text/css">
  html, body {
     height: 100%;
   }
   #container {
     position: relative;
     top: 50%;
     left: 50%;
     transform: translate(-50%, -50%);
     width: 800px;
     height: 100%;
     display: flex;
     flex-direction: column;
     justify-content: center;
   }

   

   #board_table {
     display: flex;
     flex-direction: column;
     width: 100%;
     border: 1px solid black;
   }

   #table_row {
     display: flex;
     flex-direction: row;
     width: 100%;
     border-bottom: 1px solid black;
   }

   .board_board_col {
     padding: 10px;
   }

   textarea {
     width: 100%;
     height: 200px;
   }
/* 댓글 컨텐츠 영역 */
/* 댓글 컨텐츠 영역 */
board_comment_content_area{
overflow-y: auto;
}
#board_comment_content_area {
  margin-top: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  max-height: 400px; /* 원하는 높이로 조정해주세요 */
  
}

/* 댓글 입력 테이블 */
#board_comment_table {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-top: 10px;
}

/* 댓글 입력 텍스트 영역 */
#board_comment_table textarea {
  width: 100%;
  height: 20px;
  resize: none;
  padding: 5px;
}

/* 댓글 등록 버튼 */
.comment_wirte_btn {
  margin-left: 10px;
  padding: 5px 10px;
  text-decoration: none;
}

/* 댓글 목록 영역 */
.comment_list_Area {
  font-size:10px;
  margin-top: 20px;
  border-top: 1px solid #ccc;
  max-height: 200px; /* 원하는 높이로 조정해주세요 */
  overflow-y: auto;
  display: flex;
  flex-direction: row;
}
#comment_content{
  display: flex;
  flex-direction: row;
  align-items: center;
}
#comment_none {
  margin-top: 10px;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
}
</style>
</head>
<body>
   <%@ include file="../include/navbar.jsp" %>
  
   <div id="container">
      <div id="board_content">
         <c:set var="board_content" value="${board_content}" />
         <div id="board_table">
            <div id="table_row">
               <div class="board_board_col">${board_content.board_Title}</div>
               <div class="board_board_col">${board_content.writer}</div>
               <div class="board_board_col">${board_content.user_Nickname}</div>
            </div>
            <div id="table_row">
               <div class="board_board_col">
                  ${board_content.board_no}
               </div>
            </div>
            <div id="table_row">
               <div class="board_board_col">작성자 일정 스케줄 확인하기</div>
               <div class="board_board_col">
                  <a class="planList_btn" href="plan_list.go?id=${board_content.writer}">일정보기</a>
               </div>
            </div>
            <div id="table_row">
               <div class="board_board_col">
                  <textarea style="width: 700px"  rows="25" cols="6" readonly="readonly">${board_content.board_Content}</textarea>
               </div>
            </div>
            <div id="table_row">
               <c:if test="${board_content.board_Update_Date eq board_content.board_RegDate}">
                      <div class="table_col">${board_content.board_RegDate.substring(0, 10) }</div>
                  </c:if>
                  <c:if test="${board_content.board_Update_Date ne board_content.board_RegDate}">
                       <div class="table_col">${board_content.board_Update_Date.substring(0, 10) }</div>
                  </c:if>
              <div class="table_col">조회수 : ${board_content.board_hit}</div>
              <div class="table_col"><button onclick="likefunction()" id="likeButton">
                                  </button></div>
            </div>
         </div>
      </div>
      <!--댓글 영역  -->
      기존 댓글 영역.

   <div id = "comment_area">   
      <div id = "board_comment_content_area">
         <form id = "board_comment_form">
                <span><strong>댓글</strong></span><span id="comment_count"></span><!--CCnt가 댓글수 나오는 데인가봄 -->
                  <div id = "board_comment_table">
                     <div id = "board_board_comment_table_row">
                       <div id = "board_board_comment_table_col">
                          <textarea style="width: 500px"  rows="3" cols="30" id="comment" name="comment" placeholder="댓글을 입력하세요"></textarea>
                             <br>
                         </div>
                         <div>
                             <a href='#' onclick = "comment_wirte('${board_content.board_no}')"class="comment_wirte_btn">등록</a><!-- onClick="fn_comment('${result.code }')" 이따 리스트의 번호가 여기 드가서 여기에 대한 댓글 넣을 수 있게. -->
                         </div>
                     </div>
                  </div>
                  <input type="hidden" id="board_no" name="board_no" value="${board_content.board_no}" /> <!--${result.code } 답글이 달릴 번호인듯 -->
         </form>
      </div>
      <div class="comment_list_Area">
          <form id="commentListForm" name="commentListForm" method="post">
              <div id="commentList">
              </div>
          </form>
      </div>
   </div>
     
     <input type="button" value="글 수정" onclick="location.href='board_modify.go?no=${board_content.board_no}&page=${Paging }'">
        <input type="button" value="글 삭제" onclick="if(confirm('정말로 게시글을 삭제하시겠습니까?')) {
        	location.href='board_delete.go?no=${board_content.board_no}&page=${Paging }'  }else { return;} ">
        <input type="button" value="전체목록" onclick="location.href='PlanBoardList.go'">
      
   </div>
    <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/board/board_content.js"></script>
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
     <script type="text/javascript">
     
     $(document).ready(function () {
    	    var board_no = ${board_content.board_no};
    	    var user_id = "${board_content.writer}";

    	    $.ajax({
    	      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	      type: "post",
    	      url: "like_count.go",
    	      data: {
    	        no: board_no,
    	        user_id: user_id
    	      },
    	      datatype: "text/html",
    	      success: function (data) {
    	    	  if (data === 1 || data === -1) {
				        $("#likeButton").text("좋아요").val();
				    } else if (data === 0) {
				        $("#likeButton").text("좋아요 취소").val();
				    } 
    	      },
    	      error: function () {
    	        alert("데이터 통신 오류입니다.");
    	      }
    	    });
    	  });

        function likefunction() {
        	var board_no = ${board_content.board_no };
        	var user_id = "${board_content.writer}";
        	console.log(${board_content.board_no });
        	console.log("${board_content.writer}");
        	$.ajax({
        		 contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        		  type: "post",
        		  url: "board_like.go",
    			data: { no : board_no,
    				   user_id : user_id
    			},
    			datatype: "text/html",
    			success: function(data) {
    				console.log(data); 
    				console.log(data); 
   				 if (data === 1) {
				        alert("좋아요 누름");
				        $("#likeButton").text("좋아요 취소").val();
				    } else if (data === 0) {
				        alert("좋아요 취소");
				        $("#likeButton").text("좋아요").val();
				    } else {
				        alert("본인 글");
				    }
   				  
    				  console.log($("#likeButton").val());
    				  
    			},

    			error: function() {
                    alert("데이터 통신 오류입니다.");
                }
    		
    	});
        }
     </script>
</body>
</html>
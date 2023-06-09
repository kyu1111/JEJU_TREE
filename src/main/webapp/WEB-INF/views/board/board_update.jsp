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
      #container {
     display: flex;
     flex-direction: column;
     align-items: center;
     justify-content: center;
     min-height: 100vh;
   }

   #board_content {
     width: 50%;
   }

   #board_table {
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
</style>
</head>
<body>
   <%@ include file="../include/navbar.jsp" %>
   <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/board/board_content.js"></script>
   <form method="post" action="<%=request.getContextPath()%>/board_modify_ok.go?page=${Paging}">
   <div id="container">
      <div id="board_content">
         <c:set var="board_content" value="${board_content}" />
         <input type="hidden" name="board_no" value="${board_content.board_no }">
         <div id="board_table">
            <div id="table_row">
               <div class="board_board_col"><input name="board_Title" value="${board_content.board_Title}" /></div>
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
                  <textarea style="width: 700px"  rows="25" cols="6" name="board_Content">${board_content.board_Content}</textarea>
               </div>
            </div>
            <div id="table_row">
               <c:if test="${board_content.board_Update_Date eq board_content.board_RegDate}">
                      <div class="table_col">${board_content.board_RegDate.substring(0, 10) }</div>
                  </c:if>
                  <c:if test="${!board_content.board_Update_Date eq board_content.board_RegDate}">
                       <div class="table_col">${board_content.board_Update_Date.substring(0, 10) }</div>
                  </c:if>
            </div>
         </div>
      </div>

     
     <input type="submit" value="수정하기">&nbsp;&nbsp;
	        <input type="reset" value="다시쓰기">
   </div>
      </form>
   
     
</body>
</html>
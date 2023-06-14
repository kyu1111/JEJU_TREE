<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동행자 게시판</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/board/board_update.css">
</head>
<body>
   <div id="container">
   	  <%@ include file="../include/navbar.jsp" %>	
      <div id = "write_title">EDIT POST</div>
      <div id="board_content">
      	<form method="post" action="<%=request.getContextPath()%>/board_modify_ok.go?page=${Paging}">
      	<c:set var="board_content" value="${board_content}" />
        	<input type="hidden" name="board_no" value="${board_content.board_no }">
        <div id="board_table">
         	<div id="table_row">
               <div class="board_board_col">post no.${board_content.board_no}</div>
            </div>
            <div id="table_row">
               <div class="board_board_col"><span id ="col_span">title : </span><input name="board_Title" value="${board_content.board_Title}" /></div>
            </div>
            <div id="table_row">
               <div class="board_board_col"><span id ="col_span">writer : </span>${board_content.writer}</div>
            </div>
            <div id="table_row">
                <span id ="col_span">reg :</span>&nbsp;
             	<c:if test="${board_content.board_Update_Date eq board_content.board_RegDate}">
                <div class="table_col">${board_content.board_RegDate.substring(0, 10) }</div>
                </c:if>
                <c:if test="${board_content.board_Update_Date ne board_content.board_RegDate}">
                <div class="table_col">${board_content.board_Update_Date.substring(0, 10) }</div>
                </c:if>
            </div>
            <div id="table_row">
                <div class="board_board_col">
                <span id ="col_span">plan : </span>
                <a class="planList_btn" href="plan_list.go?id=${board_content.writer}">${board_content.writer} 님의 일정보기</a>
                </div>
            </div>
            <div id="table_row" class = "textarea_row">
                <div class="board_board_col">
                  <textarea rows="25" cols="6" name="board_Content">${board_content.board_Content}</textarea>
               </div>
            </div>
			<div id = "table_row">
				<div class="table_col">
					<a href="PlanBoardList.go"><i class="fas fa-th-list"></i></a>
				</div>
			</div>
        </div>
	    <div id = "button_area">
			 <i class="fas fa-paper-plane"></i><input type="submit" value="modify">&nbsp;&nbsp;
			 <i class="fas fa-sync"></i><input type="reset" value="reset">
		</div>
    </form> 
	</div>
  </div>
</body>
</html>

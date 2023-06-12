<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동행자 게시판</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/board/board_content.css">
</head>
<body>
   <div id="container">
   	   <%@ include file="../include/navbar.jsp" %>	
      <div id="board_content">
      <div id = "write_title">POST DETAILS AND COMMENTS</div>
         <c:set var="board_content" value="${board_content}" />
         <div id="board_table">
         	<div id="table_row">
               <div class="board_board_col">post no.${board_content.board_no}</div>
               <div class="board_modify_col">
                    <a href="board_modify.go?no=${board_content.board_no}&page=${Paging }"><i class="fas fa-edit"></i></a> 
					<a href="javascript:void(0);" onclick="if(confirm('정말로 게시글을 삭제하시겠습니까?')) {
					  location.href='board_delete.go?no=${board_content.board_no}&page=${Paging }';
					} else {
					  return;
					}"><i class="far fa-trash-alt"></i></a>
				</div>
            </div>
            <div id="table_row">
               <div class="board_board_col"><span id ="col_span">title : </span>${board_content.board_Title}</div>
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
               <a class="planList_btn" href="plan_list.go?id=${board_content.writer}">${board_content.writer} 님의 시간표 보기</a></div>
            </div>
             <div id="table_row">
               <div class="board_board_col">
               <span id ="col_span">Dragplan : </span>
               <a class="planList_btn" href="get_others_plans.go?otherUserId=${board_content.writer}&is_guest=1">${board_content.writer}일정 보기</a></div>
            </div>
            <div id="table_row" class = "textarea_row">
               <div class="board_board_col">
                  <textarea rows="25" cols="6" readonly="readonly">${board_content.board_Content}</textarea>
               </div>
            </div>
            <div id = "table_row">
            	<div class="table_col"><span id ="col_span">조회수  : </span>${board_content.board_hit}</div>
            	<i class="fa fa-thumbs-o-up" aria-hidden="true"></i>
            </div>
            <div id = "table_row">
                <div class="table_col"><button onclick="likefunction()" id="likeButton"></button></div>
            </div>
			<div id = "table_row">
				<div class="table_col">
					<a href="PlanBoardList.go"><i class="fas fa-th-list"></i></a>
				</div>
			</div>
         </div>
         <div id = "comment_area">
       <div id = "commentform_Title">댓글달기</div>
	       <div id="commentForm">
		      <textarea id="commentContent" rows="2" cols="5"></textarea>
		      <input type="hidden" id="commentId" value="">
		      <button id="submitComment"><i class="fa-solid fa-pen"></i></button>
		   </div>
		   <div id="commentList">
		      <div id = "commentList_Title">댓글목록</div>
		      <ul id="commentListContainer">
		      </ul>
		  </div>
	  </div>
    </div>
  </div>
<script type="text/javascript">
	 $(document).ready(function() {
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
		   			        $("#likeButton").html('<i class="fas fa-thumbs-up" aria-hidden="true"></i>').val();
		   			    } else if (data === 0) {
		   			        $("#likeButton").text('<i class="fas fa-thumbs-down"></i>').val();
		   			    } 
		   	      },
		   	      error: function () {
		   	        alert("데이터 통신 오류입니다.");
		   	      }
		   	    });
		       
		     function loadComments() {
		    	 let kakao_id = '${kakao_id}';
		    	 let normal_session = '${normal_session}';
		    	 let writer = '';
		    	 
		    	 if(kakao_id != ''){
		    		 writer = kakao_id;
		    	 }else if(user_id != ''){
		    		 writer = normal_session;
		    	 }
		    	 
		         let commentListContainer = $('#commentListContainer');
		         commentListContainer.empty();
		   		
		         $.ajax({
		             url: 'commentList.go',
		             type: 'GET',
		             dataType: 'json',
		             data: { board_no: '${board_content.board_no}' },
		             success: function(data) {
		                 $.each(data, function(index, comment) {
		               	  let commentListItem = $('<li></li>');
		                     
		                     let commentHeader = $('<div class="comment-header"></div>');
		                     
		                     let writerSpan = $('<span class="writer"></span>').text(comment.writer);
		                     let regdateSpan = $('<span class="regdate"></span>').text(comment.regdate);
		                     commentHeader.append(writerSpan).append(regdateSpan);
		                     let commentContent = $('<div class="comment-content"></div>');
		                     let contentSpan = $('<span></span>').text(comment.content);
		                     let btnwrap = $('<div class="btnwrap"></div>');
		                     let editBtn = $('<button class = "editBtn"></button>').text('수정');
		                     console.log(kakao_id);
		                     console.log(normal_session);
		                     let deleteBtn = $('<button = class="deleteBtn"></button></div>').text('삭제');
		                     

		                     editBtn.click(function() {
		                              
		                         let originalContent = contentSpan.text();
		                               
		                         contentSpan.hide();

		                         let contentInput = $('<input>').attr('type', 'text').val(originalContent);
		                             contentSpan.after(contentInput);

		                         editBtn.text('수정 완료').off('click').on('click', function() {
		                             let newContent = contentInput.val();
		                             if (newContent) {
		                                 $.ajax({
		                                     url: 'comment_update.go',
		                                     type: 'POST',
		                                     dataType: 'json',
		                                     data: { rno: comment.rno, content: newContent },
		                                     success: function(response) {
		                                         if (response.result === "success") {
		                                       	  console.log('그라모 성공했다.');
		                                             contentSpan.text(newContent).show();
		                                             contentInput.remove();
		                                             editBtn.text('수정').off('click').on('click', updateComment);
		                                             loadComments();
		                                         } else {
		                                             alert('댓글 수정에 실패했습니다.');
		                                       }
		                                     }
		                                 });
		                               }
		                           });
		                       });
		                          function updateComment() {
		                              let newContent = $('#commentContent').val();
		                              let commentId = $('#commentId').val();
		                               
		                              if (newContent) {
		                                  $.ajax({
		                                      url: 'comment_update.go',
		                                      type: 'POST',
		                                      dataType: 'json',
		                                      data: { rno: comment.rno, content: newContent },
		                                      success: function(response) {
		                                   	  
		                                          if (response.result === "success") {
		                                       	   console.log('그라모 성공했네.');
		                                              loadComments();
		                                              $('#formTitle').text('댓글 작성');
		                                              $('#commentContent').val('');
		                                              $('#commentId').val('');
		                                              $('#submitComment').text('댓글 작성');
		                                              $('#submitComment').off('click').on('click', submitComment);
		                                          } else {
		                                              alert('댓글 수정에 실패했습니다.');
		                                          }
		                                      }
		                                  });
		                              }
		                          }
		                           deleteBtn.click(function() {
		                               if (confirm('댓글을 정말 삭제하시겠습니까?')) {
		                                   $.ajax({
		                                       url: 'comment_delete.go',
		                                       type: 'POST',
		                                       dataType: 'json',
		                                       data: { rno: comment.rno },
		                                       success: function(response) {
		                                           if (response.result === "success") {
		                                               loadComments();
		                                           } else {
		                                               alert('댓글 삭제에 실패했습니다.');
		                                           }
		                                       }
		                                  });
		                               }
		                           });
		                           btnwrap.append(editBtn).append(deleteBtn);
		                           commentContent.append(contentSpan).append(btnwrap);
		                           
		                           commentListItem.append(commentHeader).append(commentContent);
		                           if (writer != comment.writer) {
		                        	     btnwrap.hide(); // 수정 버튼 숨김
				                    	} 
		                           if (index < data.length - 1) {
		                               let commentDivider = $('<div class="comment-divider"></div>');
		                               commentListItem.append(commentDivider);
		                           }
		                           commentListContainer.append(commentListItem);
		                       });
		                   }
		               });
		           }
		           loadComments();
		           
		           function submitComment() {
		               let content = $('#commentContent').val();
		               $.ajax({
		                   url: 'commentwirte.go',
		                   type: 'POST',
		                   dataType: 'json',
		                   data: { board_no: '${board_content.board_no}', content: content },
		                   success: function(response) {
		                       if (response.result === "success") {
		                           loadComments();
		                           $('#commentContent').val('');
		                       } else {
		                         alert('댓글 작성에 실패했습니다.');
		                     }
		                   }
		               });
		           }
		           $('#submitComment').click(submitComment);
		       });
		   function likefunction() {
		   	var board_no = ${board_content.board_no };
		   	var user_id = "${board_content.writer}";
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
		   		        $("#likeButton").html('<i class="fas fa-thumbs-down"></i>').val();
		   		    } else if (data === 0) {
		   		        alert("좋아요 취소");
		   		        $("#likeButton").html('<i class="fas fa-thumbs-up" aria-hidden="true"></i>').val();
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
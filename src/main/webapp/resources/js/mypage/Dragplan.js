/**
 * 
 */
   function allowDrop(ev) {
   
      ev.preventDefault();
   }

   function drag(ev) {
      
      ev.dataTransfer.setData("text", ev.target.id);
      
   }

   function drop(ev) {
      ev.preventDefault();
      var data = ev.dataTransfer.getData("text");
      var droppedElement = document.getElementById(data);
      ev.target.appendChild(droppedElement);

      var planId = droppedElement.innerText.split("\n")[0].split(": ")[1];
      var userId;

      if (ev.target.id === "others-plans") {
         userId = $("input[name='otherUserId']").val();

         $.ajax({
            url : 'drag_update.go', // The URL of your server-side script
            method : 'POST',
            data : {
               'planId' : planId,
               'userId' : userId
            },
            success : function(response) {
               alert('공유 성공!!');
            }
         });
      }
      else if (ev.target.id === "your-plans") {
         var userId = '<%=request.getSession().getAttribute("user_id")%>';

			$.ajax({
				url : 'drag_update_back.go', // The URL of your server-side script for this direction
				method : 'POST',
				data : {
					'planId' : planId,
					'userId' : userId
				},
				success : function(response) {
					alert('공유 성공!!');
				}
			});
		}
	}
   $(document).ready(function(){
       $(".deleteButton").click(function(e) {
           e.stopPropagation(); 

           var planId = $(this).data('plan-id');
           var userId = '<%=request.getSession().getAttribute("user_id")%>';

           $.ajax({
               url : 'delete_plan.go', 
               method : 'POST',
               data : {
                   'planId' : planId,
                   'userId' : userId
               },
               success : function(response) {
                   alert('삭제 성공!!');
                   location.reload(); 
               }
           });
       });
   });
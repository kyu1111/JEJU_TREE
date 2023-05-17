/**
 * 
 */
 	
 	
 	
 	
 
 
 
 function openMenu(openbtn_className) {
	
	
	if(openbtn_className == 'openbtn1'){
	  document.getElementById("sidebar1_page").style.marginLeft = "350px";
      document.querySelector('.sidebar1').style.width = "350px";
      document.querySelector('.openbtn1').style.display = 'none';	
	}else{
	  document.getElementById("sidebar2_page").style.marginRight = "350px";
      document.querySelector('.sidebar2').style.width = "350px";
      document.querySelector('.openbtn2').style.display = 'none';	
	}
   
}

function closeMenu(closebtn_className) { 
	if(closebtn_className == 'closebtn1'){
	  document.getElementById("sidebar1_page").style.marginLeft= "0";
      document.querySelector('.sidebar1').style.width = "0";
      document.querySelector('.openbtn1').style.display = 'block';	
	}else{
	  document.getElementById("sidebar2_page").style.marginRight= "0";
      document.querySelector('.sidebar2').style.width = "0";
      document.querySelector('.openbtn2').style.display = 'block';
	}
    
}




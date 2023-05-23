/**
 * 
 */
$(function() {
	let click = true;

	$(".submit-btn").click(function() {
		if (click) {
			console.log("클릭됨");
			click = !click;

			setTimeout(function() {
				click = true;
				$(".submit-btn").attr("disabled", false);
			}, 2000)

		} else {
			$(".submit-btn").attr("disabled", true);
			console.log("중복됨");
		}
	});

});
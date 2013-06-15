(function resizeAndDraw() {
	var ctx = document.getElementById("myChart").getContext("2d");
	// resize the canvas to fill browser window dynamically
	window.addEventListener('resize', resizeCanvas, false);
	function resizeCanvas() {
		ctx.canvas.width = window.innerWidth * 0.9;
		ctx.canvas.height = window.innerHeight * 0.4;
		var myNewChart = new Chart(ctx).Line(data);	            
	}
	resizeCanvas();
})();
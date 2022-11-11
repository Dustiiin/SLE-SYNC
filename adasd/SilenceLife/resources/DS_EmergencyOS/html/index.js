let resource

$(document).ready(function(){
	window.addEventListener('message', function(event) {
		var data = event.data;

		if (data.name) {
			resource = data.name
		}

		if (data.show == true) {
			document.getElementById('display').style.display = 'block';
		} else {
			document.getElementById('display').style.display = 'none';
		}
	});

	$(document).keydown((event) => {
		if (event.which == 27 || event.which == 77) {
			$.post('http://' + resource +'/close', JSON.stringify({}));
		}
	})
});

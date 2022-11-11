var toggle = false;

$(document).ready(function(){
    window.addEventListener('message', function( event ) {       
      if (event.data.action == 'open') {

        $(".head-switch-in").removeClass("selected"); 
        $(".head-switch-out").removeClass("selected");  
        $(".head-switch-in").addClass("selected"); 

        const vehicles = document.getElementById("vehicle-list");
          vehicles.innerHTML = '';

        $.post('http://maestro_garage/enable-parkout', JSON.stringify({}));

        toggle = false;

        $('.Canvas2').css('display', 'block');        

      } else if (event.data.action == 'add') {
                
        AddCar(event.data.plate,event.data.model);        

      } else {
        $('.Canvas2').css('display', 'none');
      }
    });
 
    $( "#close" ).click(function() {
      $('.Canvas2').css('display', 'none');
      $.post('http://maestro_garage/escape', JSON.stringify({}));
    }); 

    $( ".head-switch-in" ).click(function() {      
      $(".head-switch-in").removeClass("selected"); 
      $(".head-switch-out").removeClass("selected");  
      $(".head-switch-in").addClass("selected"); 

      const vehicles = document.getElementById("vehicle-list");
        vehicles.innerHTML = '';

      $.post('http://maestro_garage/enable-parkout', JSON.stringify({}));

      toggle = false;
    }); 

    $( ".head-switch-out" ).click(function() {     
      $(".head-switch-in").removeClass("selected");  
      $(".head-switch-out").removeClass("selected"); 
      $(".head-switch-out").addClass("selected");   
      
      const vehicles = document.getElementById("vehicle-list");
        vehicles.innerHTML = '';

      $.post('http://maestro_garage/enable-parking', JSON.stringify({}));

      toggle = true;
    }); 

    function AddCar(plate,model) {
      $("#vehicle-list").append
      (`
      
      <div class="vehicle" onclick="parkOut('` + plate + `');" data-plate="` + plate + `">
        <div class="vehicle-inner" style="	
        background-image: url(https://media.discordapp.net/attachments/915943394117824543/917837552491307028/dsdajklHintergrundIMG.png);
        background-size: 100%;
        border: 1px #ffffff solid;
  
        background-color: rgba(0, 0, 0, 0.47);
        background-repeat: no-repeat; 
        width: 359px;
    height: 110px;">

            <p class="inner-label-knz">` + model + `</p>
            <p class="inner-label-knz2">` + plate +`</p>
        </div>
      </div>

      `);
    }
});

function parkOut(plate) {
  if (toggle == false) {
    $('.Canvas2').css('display', 'none');
    $.post('http://maestro_garage/escape', JSON.stringify({}));
    $.post('http://maestro_garage/park-out', JSON.stringify({plate: plate}));
  } else if (toggle == true) {
    $('.Canvas2').css('display', 'none');
    $.post('http://maestro_garage/escape', JSON.stringify({}));
    $.post('http://maestro_garage/park-in', JSON.stringify({plate: plate}));
  }
}


window.onload = function(){
    document.getElementById('close').onclick = function(){
            $.post('http://maestro_garage/escape', JSON.stringify({}));
        return
    };
};

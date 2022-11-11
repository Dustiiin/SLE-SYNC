var warenkorb = []

$(document).ready(function(){
    window.addEventListener('message', function( event ) {      
      if (event.data.action == 'open') {

        const warenkorb2 = document.getElementById("warenkorb-list");
        warenkorb2.innerHTML = '';

        warenkorb = []

        $('#warenkorb-1').text('$0.0');
        $('#warenkorb-2').text('$0.0');

        $('.container').css('display', 'block');        

      } else if (event.data.action == 'add') {
                
        AddItem(event.data.name, event.data.display, event.data.price);       

      } else {
        $('.container').css('display', 'none');
      }
    });

    $( ".close" ).click(function() {
      closeUI();
    });
});

function closeUI() { 
  $('.container').css('display', 'none');
  $.post('http://maestro_supermarkt/escape', JSON.stringify({}));
}

function AddWarenkorb(name, display, price) {
  warenkorb.push({name: name, display: display, price: price});

  $(".warenkorb-list").append
  (`
    <div class="warenkorb-list-elem">
    <p>
    &nbsp; &nbsp; &nbsp; <font style=' font-size: 12px; color:#fff; font-weight: 100;'>
    `+ display +`
    </font> &nbsp; &nbsp; &nbsp;
    <font style=' font-size: 12px; border-radius:5px; ;padding: 4px;color:green; font-weight: 100;'>
    +`+ price +`$
    </font></p>
    
</div>

  `);

  var current = $('#warenkorb-1').text();
  var current2 = current.replace("$", "");
  var int = parseFloat(current2)
  
  $('#warenkorb-1').text((int + parseFloat(price)) + ' $');

  var xcurrent = $('#warenkorb-1').text();
  var xcurrent2 = xcurrent.replace("$", "");
  var xint = parseFloat(xcurrent2)

  $('#warenkorb-2').text('$' + (xint + (xint * 0.00)));
}

function buy() {
  $.post('http://maestro_supermarkt/buy', JSON.stringify({warenkorb: warenkorb}));
  closeUI();
}
var counter = 0;

function AddItem(name, display, price) {
  counter ++;
  $("#items-container").append
      (`
      

      <div class="items-element">
      <div class="items-element-inner" style="background-image: url(items/`+name+`.png);">
      <div class="line"></div>

      </div>
      <div class="items-element-sub" onclick="AddWarenkorb('`+name+`', '`+display+`', '`+price+`')">
         `+price+` $
      </div>
      <div class="items-element-sub2">
         `+display+`
      </div>
  </div>
      `);
}
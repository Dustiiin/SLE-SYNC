$(function () {


    function display(bool) {
        if (bool) {
            $(".claimcodes").fadeIn(500);
        } else {
          $(".claimcodes").fadeOut(500);
          $(".mycodes").fadeOut(500);
            $(".adminpanel").fadeOut(500);
        }
    }


    display(false)

    $(document).ready(function(){
      setTimeout(function() {
        $.post('https://dnz_donator/initiate', JSON.stringify({ 
        }), function(data){
        });
    }, 5000);
  });

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }else if (item.type === "notify") {
          var divmm = Math.floor(Math.random() * 100000000);
            $('.notifications').append(`<div class="notify" id="` + divmm +`">
            <div class="head">`+ item.title +`</div>
            <hr>
            <div class="message">`+ item.message +`</div>
    </div>`)
      setTimeout(function() {
          $('#' + divmm).remove();
      }, item.time);
    }else if (item.type === "setgeneratedcode") {
      $('#codesoutput').val(item.code)
    }else if (item.type === "delnoadmin") {
      $('.adminpanelz').remove()
      $('.adminpanel').remove()
    }else if (item.type === "setitems") {
      $('#itemauswahlqq').append(`<option value="`+ item.name+ `">`+item.label+`</option>`)
    }else if (item.type === "setfahrzeuge") {
      $('#fahrzeuginputsss').append(`<option value="`+ item.name+ `">`+item.label+`</option>`)
    }else if (item.type === "clearcodess") {
      refreshCodes()
}else if (item.type === "setunusedcodes") {
  $('#codesverwaltentext').html(`Codes verwalten [Aktive Codes: `+ item.totalcodes +`]`)
  $('#activecodesbox').append(` <div class="genbox">
  <div class="toptext">`+ item.toplinie +`</div>
  <div class="hr"></div>
  <div class="code">Code:</div>
  <div class="itemtype">Item/Type:</div>
  <div class="value">Anzahl/Value:</div>
  <div class="codeoutput">`+ item.code +`</div>
  <div class="itemtypeoutput">`+ item.item +`</div>
  <div class="valueoutput">`+ item.anzahl +`</div>
  <div class="button1" onclick="deletecode(`+ item.id +`)"><div class="text">Löschen</div></div>
  <div class="button2" onclick="copycode('`+ item.code+ `')"><div class="text">Kopieren</div></div>
</div>`)
}else if (item.type === "setusedcodes") {
  $('#cdseinlosentop').html(`Eingelöste Codes [Eingelöst: `+ item.totalcodes +`]`)
  $('#inactivecodesbox').append(`   <div class="genbox" >
  <div class="toptext">`+ item.toplinie +`</div>
  <div class="hr"></div>
  <div class="code">Code:</div>
  <div class="itemtype">Item/Type:</div>
  <div class="value">Anzahl/Value:</div>
  <div class="codeoutput">`+ item.code +`</div>
  <div class="itemtypeoutput">`+ item.item +`</div>
  <div class="valueoutput">`+ item.anzahl +`</div>
  <div class="button1" onclick="copycode('`+ item.identifier+ `')"><div class="text">Identifier kopieren</div></div>
</div>`)
}else if (item.type === "setmycodes") {
  $('#myusedcodes').append(`<div class="box">
  <img src="code.png" alt="" class="img">
  <div class="code"><p> `+ item.code +`</p></div>
  <div class="text"> `+ item.item +`</div>
</div>`)
}
    })
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://dnz_donator/exit', JSON.stringify({}));
            return
        } 
    };

    
    
    $(".return").click(function () {
        $(".adminpanel").fadeOut(150)
            setTimeout(function(){ 
                $(".claimcodes").fadeIn(200)
        }, 300);
    })
    $("#backdonator").click(function () {
        $(".mycodes").fadeOut(150)
        setTimeout(function(){ 
            $(".claimcodes").fadeIn(200)
    }, 300); 
    })

    $(".adminpanelz").click(function () {
        $(".claimcodes").fadeOut(150)
        setTimeout(function(){ 
            $(".adminpanel").fadeIn(200)
    }, 300); 
    })

    $(".meinecodes").click(function () {
        $(".claimcodes").fadeOut(150)
        setTimeout(function(){ 
            $(".mycodes").fadeIn(200)
    }, 300); 
    })

    $(".button1").click(function () {
        $('.button1').removeClass('active')
        $(this).addClass('active')
    })

    $("#createitemcode").click(function () {
      $('#codesoutput').val("Bitte warte..")
      var amount = $('#iteminputamount').val();
      var codeanzahl = $('#itemcodeamount').val();
      var item = $( "#itemauswahlqq option:selected" ).val();
      $.post('http://dnz_donator/createitemcode', JSON.stringify({type: 'item', amount: amount,item: item, codeanzahl: codeanzahl}));
      return
    })
  
    $("#createvehiclecode").click(function () {
      $('#codesoutput').val("Bitte warte..")
        var vehicle = $( "#fahrzeuginputsss option:selected" ).val();
        var codeanzahl = $('#codeamountvehicle').val();
        $.post('http://dnz_donator/createfahrzeugcode', JSON.stringify({type: 'fahrzeug', vehicle: vehicle, codeanzahl: codeanzahl}));
        return
    })

    $("#geldcodeerstellen").click(function () {
      $('#codesoutput').val("Bitte warte..")
        var amount = $('#inputamountmoney').val();
        var typ = $( "#geldtyp option:selected" ).val();
        var codeanzahl = $('#codeamountmoney').val();
        $.post('http://dnz_donator/createmoneycode', JSON.stringify({type: 'money', amount: amount, anzahlcode: codeanzahl, typ: typ}));
        return
    })


    $("#redeemcodebutton").click(function () {
      var code = $( "#mycodeinputredeem" ).val();
      $("#redeemcodebutton").hide(100)
      setTimeout(function(){ $("#redeemcodebutton").show(100) }, 3000);
      $.post('http://dnz_donator/redeemcodes', JSON.stringify({code: code}));
      return
  })


    $("#searchused").keyup(function() {

        // Retrieve the input field text and reset the count to zero
        var filter = $(this).val(),
          count = 0;
  
        // Loop through the comment list
        $('.container3 .appends .genbox').each(function() {
          // If the list item does not contain the text phrase fade it out
          if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();  // MY CHANGE
  
            // Show the list item if the phrase matches and increase the count by 1
          } else {
            $(this).show(); // MY CHANGE
            count++;
          }
  
        });
  
      });

      $("#searchactive").keyup(function() {

        // Retrieve the input field text and reset the count to zero
        var filter = $(this).val(),
          count = 0;
  
        // Loop through the comment list
        $('.container2 .appends .genbox').each(function() {
          // If the list item does not contain the text phrase fade it out
          if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();  // MY CHANGE
  
            // Show the list item if the phrase matches and increase the count by 1
          } else {
            $(this).show(); // MY CHANGE
            count++;
          }
  
        });
  
      });

})
function load(who) {
    $(".container1").hide(150)
    $(".container2").hide(150)
    $(".container3").hide(150)
    $(who).show(200)
}


function load1(who) {
  $(".adminpanel").hide(150)
  $(who).show(200)
}

function getItems() {
  $.post('http://dnz_donator/getitems', JSON.stringify({}));
  return
}

function getMyCodes() {
  $.post('http://dnz_donator/getmycodes', JSON.stringify({}));
  return
}

function refreshCodes() {
  $('#activecodesbox').html('')
  $('#inactivecodesbox').html('')
  $.post('http://dnz_donator/getcodes', JSON.stringify({}));
  return
}

function deletecode(id) {
  $.post('http://dnz_donator/delcode', JSON.stringify({id: id}));
  $.post('http://dnz_donator/notify', JSON.stringify({title: 'Code verwaltung', message: 'Der Code mit der ID ' + id + ' wurde gelöscht'}));
}

function createPremiumKey() {
  $.post('http://dnz_donator/createpremiumkey', JSON.stringify({}));
}

function copycode(text){
  var $temp = $("<div>");
  $("body").append($temp);
  $temp.attr("contenteditable", true)
       .html(text)
       .on("focus", function() { document.execCommand('selectAll',false,null); })
       .focus();
  document.execCommand("copy");
  $temp.remove();
  $.post('http://dnz_donator/notify', JSON.stringify({title: 'Code verwaltung', message: 'Die Information wurde in deine Zwischenablage kopiert'}));
}

function CopyWhole(){
  var $temp = $("<div>");
  var cc = $('#codesoutput').val()
  $("body").append($temp);
  $temp.attr("contenteditable", true)
       .html(cc)
       .on("focus", function() { document.execCommand('selectAll',false,null); })
       .focus();
  document.execCommand("copy");
  $temp.remove();
  $.post('http://dnz_donator/notify', JSON.stringify({title: 'Codes erstellung', message: 'Deine Codes wurden erfolgreich in die Zwischenablage kopiert.'}));
}
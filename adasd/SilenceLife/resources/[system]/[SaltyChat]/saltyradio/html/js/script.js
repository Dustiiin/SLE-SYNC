var disconnectText = `<span class="text-danger"><i class="fas fa-times"></i> Offline</span> &mdash; <span class="text-warning "><font color="red"> Crystal </font></span> Funk`; 
var nopeTexts = [
    `<i class="fas fa-times"></i> Nein`,
]

var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;
var lastChannel = 137;

var cursor = document.getElementById("cursor");
var cursorX = documentWidth / 2;
var cursorY = documentHeight / 2;

function UpdateCursorPos() {
    cursor.style.left = cursorX;
    cursor.style.top = cursorY;
}

function Click(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
}

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            if(event.data.enable) {
                $(".radio-container").css("animation", "moveIn 1s ease-in-out forwards");
                loadFavorites(); loadHistory();
            } else {
                $(".radio-container").css("animation", "moveOut 1s ease-in-out forwards");
            }
        } else if (event.data.type == "hasradio") {
                if(event.data.status) {
                    $(".radio-container").style("display", "block");
                }
        } else if (event.data.type == "click") {
            // Avoid clicking the cursor itself, click 1px to the top/left;
            Click(cursorX - 1, cursorY - 1);
        } else if (event.data.type == "changeChannel") {
            lastChannel = event.data.value;
            if(event.data.value == -1) {
                $("nav").removeClass("connected");
                $("nav > a#navbar-title").html(disconnectText);
            } else {
                $("nav").addClass("connected");
                $("nav > a#navbar-title").html(`<i class="fas fa-wifi"></i> Verbunden - ${event.data.value}.00 MHz`);
            }
            
        }
    });

    function loadFavorites() {
        var lsGetter = localStorage.getItem("radio-favorites") || "[]";
        $("select#favorites-container").find('option').remove();
        if(lsGetter != null) {
            favorites = JSON.parse(lsGetter);
            favorites.forEach((fav) => {
                $("select#favorites-container").append(`<option value="${fav.value}">${fav.value}.00 MHz &mdash; ${fav.name}</option>`);
            });
        }
    }

    function loadHistory() {
        var lsGetter = sessionStorage.getItem("radio-history") || "[]";
        $("select#history-container").find('option').remove();
        if(lsGetter != null) {
            var history = JSON.parse(lsGetter);
            history.forEach(entry => {
                $("select#history-container").append(`<option value="${entry}">${entry}.00 MHz</option>`);
            });
        }
    }

    $(document).mousemove(function(event) {
        cursorX = event.pageX;
        cursorY = event.pageY;
        UpdateCursorPos();
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://saltyradio/escape', JSON.stringify({}));
        }
    };

    $("#radio-connect").click(function(e) {
        e.preventDefault();

        var channel = parseInt($("#radio-channel").val()) || 1;

        if(channel <= 0 || channel > 1000) {
            $("#radio-channel").val("");
            $("nav > a#navbar-title").fadeOut('slow', function() {
                $(this).html(nopeTexts[Math.floor(Math.random() * nopeTexts.length)]);
                $(this).fadeIn('slow');
                $(this).fadeOut('slow', function() {
                    $(this).html(disconnectText);
                    $(this).fadeIn('slow');
                });
            });
        } else {
            $.post('http://saltyradio/joinRadio', JSON.stringify({
                channel: channel
            }));

            var history = JSON.parse(sessionStorage.getItem('radio-history') || "[]");
            if(history != null && !history.includes(channel)) {
                history.push(channel);
            }
            sessionStorage.setItem('radio-history', JSON.stringify(history));
        }

    });

    $("#radio-disconnect").click(function(e) {
        e.preventDefault();

        $("#radio-channel").val("");

        $.post('http://saltyradio/leaveRadio', JSON.stringify({
        }));
    });

    $("#radio-favorites-add").click(function(e) {
        e.preventDefault();
        var name = $("#radio-favorites-name").val() || "unnamed";
        var channel = lastChannel;

        var lsGetter = localStorage.getItem("radio-favorites");
        favorites = [];
        if(lsGetter != null) {
            favorites = JSON.parse(lsGetter);
        }
        
        if(lastChannel != -1 && !(name.trim() === '')) favorites.push({ "value": channel, "name": name });
        localStorage.setItem("radio-favorites", JSON.stringify(favorites));
        loadFavorites();
    });

    $("#radio-history-clear").click(function(e) {
        sessionStorage.setItem("radio-history", "[]");
        loadHistory();
    })
    
    $('select#favorites-container').on("keyup", function(e){
        if(e.keyCode == 46) {
            var selectedValue = $(this).children("option:selected").val();
            var lsGetter = localStorage.getItem("radio-favorites");
            favorites = [];
            if(lsGetter != null) {
                favorites = JSON.parse(lsGetter);
            }

            var indexToRemove = favorites.findIndex(fav => fav.value == selectedValue);
            favorites.splice(indexToRemove, 1);
            localStorage.setItem('radio-favorites', JSON.stringify(favorites));
            loadFavorites();
        }
    });

    $('select').on("dblclick", "option", function(e) {
      e.preventDefault(); // Prevent form from submitting
	  
	  var channel = parseInt(this.value) || 1;
	  
      $.post('http://saltyradio/joinRadio', JSON.stringify({
          channel: channel
      }));
    });

    $("#favorites-tab").click(loadFavorites);
    $("#history-tab").click(loadHistory);
});

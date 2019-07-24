document.addEventListener("turbolinks:load", function() {

  // tutor card hover shadow

  $(document).on({
    mouseenter: function() {
      $(this).removeClass("shadow-sm");
      $(this).addClass("shadow");
      $(this).css({"width": "101%", "height": "101%", "margin-top": "-0.5%", "margin-left": "-0.5%"});
    },
    mouseleave: function() {
      $(this).removeClass("shadow");
      $(this).addClass("shadow-sm");
      $(this).css({"width": "100%", "height": "100%", "margin-top": "0%", "margin-left": "0%"});
    }
  }, '.tutor-card');

});

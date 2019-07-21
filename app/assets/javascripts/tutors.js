document.addEventListener("turbolinks:load", function() {

  // search form autocomplete

  $input = $("[data-behavior='autocomplete-tutors']");

  var controller = $('.form-control').data('controller');
  var action     = $('.form-control').data('action');

  var options = {
    getValue: "name",
    url: function(phrase) {

      if (controller === "tutors") {
        if (action === "index") {
          return "/tutors.json?search=" + phrase;
        }
      }

    },
    list: {
      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url;
        $input.val("");
        Turbolinks.visit(url);
      },
    }
  };

  $input.easyAutocomplete(options);

  // tutor card hover shadow

  $('.tutor-card').hover(
      function() {
        $(this).removeClass("shadow-sm");
        $(this).addClass("shadow");
        $(this).css({"width": "101%", "height": "101%", "margin-top": "-0.5%", "margin-left": "-0.5%"});
      },
      function() {
        $(this).removeClass("shadow");
        $(this).addClass("shadow-sm");
        $(this).css({"width": "100%", "height": "100%", "margin-top": "0%", "margin-left": "0%"});
      }
      );
});

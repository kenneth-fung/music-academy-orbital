document.addEventListener("turbolinks:load", function() {

  // search form autocomplete

  $input = $("[data-behavior='autocomplete']");

  var controller = $('.form-control').data('controller');
  var action     = $('.form-control').data('action');

  var options = {
    getValue: "title",
    url: function(phrase) {

      if (controller == "tutors") {
        if (action == "show") {
          id = $('.form-control').data('id');
          return "/tutors/" + id + "/courses.json?search_profile=" + phrase;
        } 
      } else if (controller == "students") {
        id = $('.form-control').data('id');
        return "/students/" + id + "/courses.json?search_profile=" + phrase;
      } else {
        return "/courses.json?search=" + phrase; 
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

  // course card hover shadow
  
  $('.course-card').hover(
      function() {
        $(this).removeClass("shadow-sm");
        $(this).addClass("shadow");
        $(this).css({"width": "101%", "height": "101%", "margin-top": "-1%", "margin-left": "-1%"});
      },
      function() {
        $(this).removeClass("shadow");
        $(this).addClass("shadow-sm");
        $(this).css({"width": "100%", "height": "100%", "margin-top": "0%", "margin-left": "0%"});
      }
      );
});

document.addEventListener("turbolinks:load", function() {
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
        } else if (action == "index") {
          return "/tutors.json?search=" + phrase;
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
});

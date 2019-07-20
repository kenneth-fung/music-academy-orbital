document.addEventListener("turbolinks:load", function() {
  $input = $("[data-behavior='autocomplete-tutors']");

  var controller = $('.form-control').data('controller');
  var action     = $('.form-control').data('action');

  var options = {
    getValue: "name",
    url: function(phrase) {

      if (controller == "tutors") {
        if (action == "index") {
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
});

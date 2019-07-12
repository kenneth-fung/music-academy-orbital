document.addEventListener("turbolinks:load", function() {
  $input = $("[data-behavior='autocomplete']");

  var options = {
    getValue: "title",
    url: function(phrase) {
      return "/courses.json?search=" + phrase; 
    },
    list: {
      onChooseEvent: function() {
        var url = $input.getSelectedItemData().url;
        $input.val("");
        Turbolinks.visit(url);
      },
      match: {
        enabled: false
      }
    }
  };

  $input.easyAutocomplete(options);
});

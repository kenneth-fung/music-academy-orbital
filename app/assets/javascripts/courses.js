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
      showAnimation: {
        type: "fade",
        time: 100,
        callback: function() {}
      },
      hideAnimation: {
        type: "fade",
        time: 100,
        callback: function() {}
      }
    }
  };

  $input.easyAutocomplete(options);
});

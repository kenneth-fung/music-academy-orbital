document.addEventListener("turbolinks:load", function() {

  // search form autocomplete

  $input = $("[data-behavior='autocomplete']");

  var controller = $('.form-control').data('controller');
  var action     = $('.form-control').data('action');

  var options = {
    getValue: "title",
    url: function(phrase) {

      if (controller === "tutors") {
        if (action === "show") {
          id = $('.form-control').data('id');
          return "/tutors/" + id + "/courses.json?search_profile=" + phrase;
        } 
      } else if (controller === "students") {
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
  }, '.course-card');

  // disable inputs and links on form submits

  $('form').submit(function() {
    // greys out form links and inputs only if the form is not
    // (1) a search form
    // (2) a post/message form
    // (3) a review form
    var readonly = 
      $(this).hasClass("search-bar") === false && 
      $(this).hasClass("post-form") === false && 
      $(this).hasClass("message-form") === false &&
      $(this).hasClass("review-form") === false;

    if (readonly) {
      $('.form-control').attr("readonly", true);
      $('.form-control-file').css({"display": "none"});

      var links = $('a,#logo').not($(this));
      links.addClass("disabled");
    }
  });

});

// listen for back button press
window.addEventListener("popstate", function(e) {
  location.reload();
});

// update url on pressing course tab
$(document).on("click", "#course-tab", function() {
  $('.lesson-selected').removeClass('lesson-selected');
  history.pushState({}, '', "/courses/" + $('.title').data('id'));
});

// update url on pressing lesson tab
$(document).on("click", "#lessons-tab", function() {
  var lesson_page = $('#lesson-name').data('position');
  $('.list-group-item').eq(lesson_page - 1).addClass('list-group-item-secondary lesson-selected');
  history.pushState({}, '', window.location.pathname + "?lesson_page=" + lesson_page);
});

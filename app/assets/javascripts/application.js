// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .
$(document).ready(function() {
  var form = $("#review_form"),
      timerField = $("#review_timer");

  var counter = (function() {
    var counter = 0;
    function changeBy(val) {
      counter += val;
    }
    return {
      add: function() {
        changeBy(1);
      },
      sub: function() {
        changeBy(-1);
      },
      val: function() {
        return counter;
      }
    };
  })();

  if (form) {
    var timer = setInterval(function(){ counter.add() }, 1000);
  }

  form.submit(function(event) {
    event.preventDefault();
    timerField.val(counter.val());
    form.off("submit");
    form.submit();
  });
});

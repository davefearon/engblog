$(document).ready(function() {

  $('article header h2').click(function() {
    var href = $(this).parent().parent().data('link');
    window.location.href = href;
  });

});
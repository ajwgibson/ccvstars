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
//= require bootstrap-sprockets
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require slimscroll/jquery.slimscroll.min.js
//= require toastr/toastr.min.js
//= require datapicker/bootstrap-datepicker.js
//= require jasny/jasny-bootstrap.min.js
//= require typeahead/bootstrap3-typeahead.min.js
//= require select2/select2.full.min.js
//= require clockpicker/clockpicker.js
//= require_tree .

$(function () {

  $('[data-toggle="tooltip"]').tooltip();

  toastr.options = {
    "closeButton": true,
    "debug": true,
    "progressBar": true,
    "preventDuplicates": false,
    "positionClass": "toast-top-right",
    "onclick": null,
    "showDuration": "400",
    "hideDuration": "1000",
    "timeOut": "2000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  };

  $('.toastr-message').each(function() {
    window["toastr"][$(this).attr('data-toastr-type')]($(this).text());
  });

  $('.decade .input-group.date').datepicker({
      format: "dd/mm/yyyy",
      startView: "decade",
      todayBtn: "linked",
      keyboardNavigation: false,
      forceParse: false,
      autoclose: true
  });

  $('.days .input-group.date').datepicker({
      format: "dd/mm/yyyy",
      startView: "days",
      todayBtn: true,
      todayHighlight: true,
      keyboardNavigation: false,
      forceParse: false,
      autoclose: true
  });

  $('.clockpicker').clockpicker();



  $('button.now').click(function() {

    var now = new Date();

    var date_target_id = $(this).data('date-target');
    var time_target_id = $(this).data('time-target');

    $('#'+date_target_id).val(getDateString(now));
    $('#'+time_target_id).val(getTimeString(now));

  });


  function getDateString(date) {

    var day   = date.getDate() + "";
    var month = (date.getMonth() + 1) + "";
    var year  = date.getFullYear() + "";

    if (day.length == 1)   day = "0" + day;
    if (month.length == 1) month = "0" + month;

    return day + "/" + month + "/" + year;
  }


  function getTimeString(date) {

    var hours   = date.getHours() + "";
    var minutes = date.getMinutes() + "";
    var seconds = date.getSeconds() + "";

    if (hours.length == 1)   hours = "0" + hours;
    if (minutes.length == 1) minutes = "0" + minutes;
    if (seconds.length == 1) seconds = "0" + seconds;

    return hours + ":" + minutes + ":" + seconds;
  }

})

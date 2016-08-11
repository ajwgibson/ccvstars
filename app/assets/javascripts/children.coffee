# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

//= require datapicker/bootstrap-datepicker.js

jQuery ->
  $('.decade .input-group.date').datepicker({
      format: "dd/mm/yyyy",
      startView: 2,
      todayBtn: "linked",
      keyboardNavigation: false,
      forceParse: false,
      autoclose: true
  })

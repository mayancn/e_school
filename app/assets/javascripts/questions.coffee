# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("#match").hide()
  $("#has_mcq").hide()
  val = $('#question_question_type').val()
  if val=="Text"
    $("#has_mcq").hide()
    $("#has_mcq").attr("aria-hidden", true)
    $("#match").show()
    $("#match").attr("aria-hidden", false)
  else if val=="Multiple Choice"
    $("#match").hide()
    $("#match").attr("aria-hidden", true)
    $("#has_mcq").show()
    $("#has_mcq").attr("aria-hidden", false)
  else if val=="Match"
    $("#match").show()
    $("#match").attr("aria-hidden", false)
    $("#has_mcq").hide()
    $("#has_mcq").attr("aria-hidden", true)
  $('#question_question_type').change ->
    val = $('#question_question_type').val()
    if val=="Text"
      $("#has_mcq").hide()
      $("#has_mcq").attr("aria-hidden", true)
      $("#match").show()
      $("#match").attr("aria-hidden", false)
    else if val=="Multiple Choice"
      $("#match").hide()
      $("#match").attr("aria-hidden", true)
      $("#has_mcq").show()
      $("#has_mcq").attr("aria-hidden", false)
    else if val=="Match"
      $("#match").show()
      $("#match").attr("aria-hidden", false)
      $("#has_mcq").hide()
      $("#has_mcq").attr("aria-hidden", true)


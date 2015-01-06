$ ->
  # Side bar toggling
  $(".sidebar-toggler").on "click", ->
    $(".body-wrapper").toggleClass "isOpen"
    $(".sidebar").toggleClass "isOpen"
    $(".sidebar-toggler .icon").toggleClass "hidden"

  # Search bar
  $(".search-input").focus ->
    $('.search.search-open').width('550px')

  $(".search-input").blur ->
    $('.search.search-open').width('350px')

  $("[name='my-checkbox']").bootstrapSwitch(
      onText: "",
      offText: "")

  # Pin toggle
  div_all = $("<div class = 'fa fa-tasks'>")
  div_pin = $("<div class = 'fa fa-thumb-tack'>")
  $('.pinned-toggler .bootstrap-switch-handle-on').append(div_all)
  $('.pinned-toggler .bootstrap-switch-handle-off').append(div_pin)

  # Pop up register and login panels
  $("#register").on "shown.bs.modal", ->
    $("#register_username").focus()

  $("#login").on "shown.bs.modal", ->
    $("#login_username").focus()

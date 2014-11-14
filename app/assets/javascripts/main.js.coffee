$ ->
  $(".sidebar-toggler").on "click", ->
    $(".body-wrapper").toggleClass "isOpen"
    $(".sidebar").toggleClass "isOpen"

  $(".search-input").focus ->
    $('.search.search-open').width('550px')

  $(".search-input").blur ->
    $('.search.search-open').width('350px')

  $("[name='my-checkbox']").bootstrapSwitch(
      onText: "",
      offText: "")

  div_all = $("<div class = 'fa fa-tasks'>")
  # div_exh = $("<div class = 'fa fa-exchange'>")
  div_pin = $("<div class = 'fa fa-thumb-tack'>")
  $('.pinned-toggler .bootstrap-switch-handle-on').append(div_all)
  # $('.pinned-toggler .bootstrap-switch-label').append(div_exh)
  $('.pinned-toggler .bootstrap-switch-handle-off').append(div_pin)


$(window).scroll ->
  if $(window).scrollTop() + $(window).height() is $(document).height()
    $('#next-page').trigger('click');
  return

$ ->
  # Side bar toggling
  $('.carousel').carousel();
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

  # add/remove discussion color theme
  $(".post-discussion-toggler").on "click", ->
    $("#post-discussion .modal-content").addClass($(this).data('type'))
    $("#post-discussion .comment .btn-sm").addClass("btn-#{$(this).data('type')}")

  $("#post-discussion").on "hidden.bs.modal", ->
    $("#post-discussion .modal-content").removeClass("work")
    $("#post-discussion .modal-content").removeClass("play")
    $("#post-discussion .modal-content").removeClass("facility")
    $("#post-discussion .comment .btn-sm").removeClass("btn-work")
    $("#post-discussion .comment .btn-sm").removeClass("btn-play")
    $("#post-discussion .comment .btn-sm").removeClass("btn-facility")

  # like/dislike setting positive to true/false before submitting
  $("body").on "click", ".btn-like", (e) ->
    $(this).siblings("#opinion_positive").attr("value", "true")
    $(this).parent().submit()
  $("body").on "click", ".btn-dislike", (e) ->
    $(this).siblings("#opinion_positive").attr("value", "false")
    $(this).parent().submit()
  $("body").on "click", ".btn-fav", (e) ->
    $(this).parent().next("form").submit()
  $("body").on "click", ".btn-archive", (e) ->
    value_field = $(".btn-archive").parent().prev().prev().children("#post_graveyard")
    value_field.attr("value", $(this).data('value'))
    $(this).parent().prev().prev("form").submit()

  $(".popover-trigger").popover();
  $("body").on "mouseover", ".popover-trigger", (e) ->
    $(this).popover()

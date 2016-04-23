$ ->
  $(window).unbind("scroll")
  if ($("body").height() < $(window).height())
    $('#next-page').trigger('click')
  $(window).scroll ->
    $myElt       = $('.last-elm');
    $window      = $(window);
    myTop        = $myElt.offset().top;
    windowTop    = $window.scrollTop();
    windowBottom = windowTop + $window.height()
    if (myTop > windowTop && myTop < windowBottom )
      $('#next-page').trigger('click');
    # if $(window).scrollTop() + $(window).height() is $(document).height()
    #   $('#next-page').trigger('click');
    # return

$ ->
  $('.carousel').carousel();
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

  # # add/remove discussion color theme
  # $(".post-discussion-toggler").on "click", ->
  #   $("#post-discussion .modal-content").addClass($(this).data('type'))
  #   $("#post-discussion .comment .btn-sm").addClass("btn-#{$(this).data('type')}")

  # $("#post-discussion").on "hidden.bs.modal", ->
  #   $("#post-discussion .modal-content").removeClass("work")
  #   $("#post-discussion .modal-content").removeClass("play")
  #   $("#post-discussion .modal-content").removeClass("facility")
  #   $("#post-discussion .comment .btn-sm").removeClass("btn-work")
  #   $("#post-discussion .comment .btn-sm").removeClass("btn-play")
  #   $("#post-discussion .comment .btn-sm").removeClass("btn-facility")

  # like/dislike setting positive to true/false before submitting
  $("body").on "click", ".btn-launch-approve", (e) ->
    $(this).parent().submit()
  $("body").on "click", ".btn-approve", (e) ->
    $(this).parent().submit()
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

  $("#user_management").modal('show')

$ ->
  textarea_count = (entrance, exit, text, characters) ->
    entranceObj = entrance[0]
    exitObj = exit
    length = characters - (entranceObj.value.length)
    if length <= 0
      length = 0
      text = '<span class="disable"> ' + text + ' </span>'
      entranceObj.value = entranceObj.value.substr(0, characters)
    exitObj.innerHTML = text.replace('{CHAR}', length)

  $('body').on 'keyup', 'textarea', ->
    textarea_count($(this), $(this).siblings()[0], 'Content ({CHAR} characters remaining)', $(this).attr('maxlength'))

$ ->
  $('.action-date').on "changeDate", () ->
    # submit form, AJAX-y
    $(this).parent().submit()

  $('.date-filter').datepicker
    'endDate': new Date()
    'autoclose': true

  # winHeight = undefined
  # winWidth = undefined
  # winWidth = $(window).width()
  # winHeight = $(window).height()
  # $('.body-wrapper').css
  #   #width: winWidth
  #   height: winHeight
  # $(window).resize ->
  #   $('.body-wrapper').css
  #     #width: $(window).width()
  #     height: $(window).height()
  #   # if $('.content-wrapper').height() < winHeight
  #   #   height: $('.content-wrapper').height()
  #   # else
  #   #   height: $(window).height()
  # return

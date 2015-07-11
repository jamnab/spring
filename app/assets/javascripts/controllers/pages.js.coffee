# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# class Sync.CommentNotification extends Sync.View
#   afterInsert: ->
#     $('.new-comment-number').fadeIn("slow")
#     count = $('.new-comment-number > .new-comment-notification').length
#     $('.new-comment-number > .number').text(count)
class Sync.PostNotification extends Sync.View
  afterInsert: ->
    $('.new-post-number').fadeIn("slow")
    count = $('.new-post-number > .new-post-notification').length
    $('.new-post-number > .number').text(count)

class Sync.CommentNotification extends Sync.View
  afterInsert: ->
    $('.new-comment-number').fadeIn("slow")
    count = $('.new-comment-number > .new-comment-notification').length
    $('.new-comment-number > .number').text(count)


class Sync.PostCard extends Sync.View
  beforeInsert: ($el) ->
    $el.hide()
    post = $el.children()
    class_type = $(post).attr("id")
    if $('.option.filter').attr("id") == "filter-post-play"
      if class_type == "play"
        @insert($el)
    else if $('.option.filter').attr("id") == "filter-post-word"
      if class_type == "word"
        @insert($el)
    else if $('.option.filter').attr("id") == "filter-post-facility"
      if class_type == "facility"
        @insert($el)
    else if $('.option.filter').attr("id") == "filter-post-doit"
      if $el.hasClass("doithidden")
        @insert($el)
    else
      @insert($el)
  afterInsert: ->
    $(".loading-wrapper").remove();
    @$el.fadeIn 'slow'
    $(".post-loading").click ->
      id = $(this).attr("id")
      target = ".post.".concat(id);
      $(target).append("<div class='loading-wrapper'><div class='loading-container'><div class='loading'></div><div id='loading-text'>Loading</div></div></div>")
  afterUpdate: ->
    $(".post-loading").click ->
      id = $(this).attr("id")
      target = ".post.".concat(id);
      $(target).append("<div class='loading-wrapper'><div class='loading-container'><div class='loading'></div><div id='loading-text'>Loading</div></div></div>")
  beforeRemove: -> @$el.fadeOut 'slow', => @remove()

$ ->
  # init search ajax
  # $('.new-post-number').change ->
  #   alert("change")

  $("#search").on "ajax:success", (data,status,xhr) ->
     $("#reportalert").text "Done."

  # init datatable for personnel
  $('.analytics_data_table').dataTable({
    # "processing": true,
    # "serverSide": true,
    # "ajax": "/summary"
  });

$ ->

  $(".nested_pics_button").click ->
    $('.nested_pics_form').append("<input class='nested_pics_button' id='images_' multiple='multiple' name='images[]' type='file'>")

  $('.filter-sort-link').click ->
    query = "all"
    sort = "newest"

    query = "all" if $('#filter-posts .text').text() == "ALL"
    query = "0" if $('#filter-posts .text').text() == "WORK"
    query = "1" if $('#filter-posts .text').text() == "PLAY"
    query = "2" if $('#filter-posts .text').text() == "FACILITY"
    query = "doit" if $('#filter-posts .text').text() == "DOIT"

    sort = "doit" if $('#sort-posts .text').text() == "NEWEST"
    sort = "discussed" if $('#sort-posts .text').text() == "MOST DISCUSSED"
    sort = "upvoted" if $('#sort-posts .text').text() == "MOST UPVOTED"

    $(this).attr("href", $(this).data("base-url")+"?query=#{query}&sort=#{sort}")

    console.log($(this).attr("href"))

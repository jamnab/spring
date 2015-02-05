# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
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
  $("#search").on "ajax:success", (data,status,xhr) ->
     $("#reportalert").text "Done."

  # init datatable for personnel
  $('#personnel-table').dataTable({
    # "processing": true,
    # "serverSide": true,
    # "ajax": "/summary"
  });

$ ->

  $(".nested_pics_button").click ->
    $('.nested_pics_form').append("<input class='nested_pics_button' id='images_' multiple='multiple' name='images[]' type='file'>")

  # $('#filter-post-work').click ->
  #   $('#filter-posts').removeClass()
  #   $('#filter-posts').addClass('filter-post-work option filter')
  #   $('#filter-posts .text').text("WORK")

  # $('#filter-post-play').click ->
  #   $('#filter-posts').removeClass()
  #   $('#filter-posts').addClass('filter-post-play option filter')
  #   $('#filter-posts .text').text("PLAY")

  # $('#filter-post-facility').click ->
  #   $('#filter-posts').removeClass()
  #   $('#filter-posts').addClass('filter-post-facility option filter')
  #   $('#filter-posts .text').text("FACILITY")

  # $('#filter-post-doit').click ->
  #   $('#filter-posts').removeClass()
  #   $('#filter-posts').addClass('filter-post-doit option filter')
  #   $('#filter-posts .text').text("DOIT")

  # $('#filter-post-all').click ->
  #   $('#filter-posts').removeClass()
  #   $('#filter-posts').addClass('filter-post-all option filter')
  #   $('#filter-posts .text').text("ALL")

  # $('#sort-post-newest').click ->
  #   $('#sort-posts .text').text("NEWEST")
  # $('#sort-post-discussed').click ->
  #   $('#sort-posts .text').text("MOST DISCUSSED")
  # $('#sort-post-upvoted').click ->
  #   $('#sort-posts .text').text("MOST UPVOTED")

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
    # console.log($('#filter-posts .text').text() + " " + $('#sort-posts .text').text())

# sample chart
$ ->
  data = {
    labels : ["Dec 14 - Dec 20", "Dec 21 - Dec 27", "Dec 28 - Jan 3",
              "Jan 4 - Jan 10", "Jan 11 - Jan 17", "Jan 18 - Jan 24",
              "Jan 25 - Jan 31", "Feb 1 - Feb 7", "Feb 8 - Feb 14"],
    datasets : [
      {
        fillColor : "rgba(220,220,220,0.5)",
        strokeColor : "rgba(220,220,220,1)",
        pointColor : "rgba(220,220,220,1)",
        pointStrokeColor : "#fff",
        data : [90, 80, 90, 80, 95, 85, 80, 90, 85]
      },
      {
        fillColor : "rgba(220,220,220,0.5)",
        strokeColor : "rgba(220,220,220,1)",
        pointColor : "rgba(220,220,220,1)",
        pointStrokeColor : "#fff",
        data : [70, 65, 80, 70, 85, 75, 70, 80, 60]
      },
      {
        fillColor : "rgba(151,187,205,0.5)",
        strokeColor : "rgba(151,187,205,1)",
        pointColor : "rgba(151,187,205,1)",
        pointStrokeColor : "#fff",
        data : [30, 45, 55, 55, 45, 40, 50, 55, 40]
      }
    ]
  }
  chart_canvas = $(".org-graph-canvas").get(0).getContext("2d")
  org_graph = new Chart(chart_canvas).Line(data, {bezierCurveTension : 0.0})


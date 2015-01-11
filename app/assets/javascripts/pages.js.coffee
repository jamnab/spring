# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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

  chart_canvas = $("#org-graph-canvas").get(0).getContext("2d")
  org_graph = new Chart(chart_canvas).Line(data, {bezierCurveTension : 0.0})

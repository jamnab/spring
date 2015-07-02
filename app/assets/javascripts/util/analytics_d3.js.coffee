## sample chart
render_contributions_by_department = (where_to_render, data_to_render) ->
  dataset = []

  data_to_render.map (data_point) ->
    dp = {}
    dp['label'] = data_point[0][1]
    dp['count'] = data_point[1][1]
    dataset.push(dp)

  width = 360
  height = 360
  radius = Math.min(width, height) / 2
  donutWidth = 50;
  legendRectSize = 18;
  legendSpacing = 4;

  color = d3.scale.category20b()
  svg = d3.select('#contributions_by_department_graph').append('svg')
    .attr('width', width)
    .attr('height', height)
    .append('g')
    .attr('transform',
          'translate(' + width / 2 + ',' + height / 2 + ')')

  arc = d3.svg.arc()
    .innerRadius(radius - donutWidth)
    .outerRadius(radius)

  pie = d3.layout.pie().value((d) ->
    d.count
  ).sort(null)

  path = svg.selectAll('path').data(pie(dataset)).enter().append('path').attr('d', arc).attr('fill', (d, i) ->
    color(d.data.label + " (#{d.data.count})")
  )

  legend = svg.selectAll('.legend').data(color.domain()).enter()
    .append('g').attr('class', 'legend').attr('transform', (d, i) ->
      height = legendRectSize + legendSpacing
      offset = height * color.domain().length / 2
      horz = -3.5 * legendRectSize
      vert = i * height - offset
      'translate(' + horz + ',' + vert + ')'
  )

  legend.append('rect').attr('width', legendRectSize).attr('height', legendRectSize).style('fill', color).style 'stroke', color
  legend.append('text').attr('x', legendRectSize + legendSpacing).attr('y', legendRectSize - legendSpacing).text (d) ->
    d


$.ajax
  type: 'GET'
  contentType: 'application/json; charset=utf-8'
  url: '/summary'
  dataType: 'json'
  data: '{}'
  success: (received_data) ->
    render_contributions_by_department('#contributions_by_department_graph', received_data.contributions_by_department)
    return
  error: (result) ->


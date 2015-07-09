## sample chart
render_donut_chart = (where_to_render, data_to_render) ->
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

render_bar_chart = (where_to_render, data_to_render) ->
  dataset = []

  data_to_render.shift()  # shift out first element
  data_to_render.map (data_point) ->
    dp = {}
    dp['letter'] = data_point[0].replace(/[a-z ]/g, '')
    dp['score'] = 1 * data_point[1] +
                  0.5 * data_point[3] +
                  0.2 * (data_point[4] + data_point[5]) +
                  0.1 * (data_point[6] + data_point[7])
    dataset.push(dp)

  margin =
    top: 20
    right: 20
    bottom: 30
    left: 40
  width = 460 - (margin.left) - (margin.right)
  height = 360 - (margin.top) - (margin.bottom)
  x = d3.scale.ordinal().rangeRoundBands([
    0
    width
  ], .1)
  y = d3.scale.linear().range([
    height
    0
  ])
  xAxis = d3.svg.axis().scale(x).orient('bottom')
  yAxis = d3.svg.axis().scale(y).orient('left').ticks(10)
  svg = d3.select(where_to_render)
    .append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  x.domain dataset.map((d) ->
    d.letter
  )
  y.domain [
    0
    d3.max(dataset, (d) ->
      d.score
    )
  ]
  svg.append('g')
    .attr('class', 'x axis')
    .attr('transform', 'translate(0,' + height + ')').call xAxis
  svg.append('g')
    .attr('class', 'y axis')
      .call(yAxis).append('text')
      .attr('y', 6).attr('dy', '-1.25em').style('text-anchor', 'end')
      .text 'Score'
  svg.selectAll('.bar').data(dataset).enter().append('rect').attr('class', 'bar').attr('x', (d) ->
    x d.letter
  ).attr('width', x.rangeBand()).attr('y', (d) ->
    y d.score
  ).attr 'height', (d) ->
    height - y(d.score)
  return

type = (d) ->
  d.score = +d.score
  d

$.ajax
  type: 'GET'
  contentType: 'application/json; charset=utf-8'
  url: '/summary'
  dataType: 'json'
  data: '{}'
  success: (received_data) ->
    render_donut_chart('#contributions_by_department_graph', received_data.contributions_by_department)
    render_bar_chart('#contributions_by_employee_graph', received_data.contributions_by_employee)
    return
  error: (result) ->


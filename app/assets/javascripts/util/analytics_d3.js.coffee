$('.summary').ready ->
  ## sample chart
  render_donut_chart = (where_to_render, data_to_render) ->
    dataset = []

    data_to_render.map (data_point) ->
      dp = {}
      dp['label'] = data_point['Department']
      dp['count'] = data_point['# Ideas Actionable']
      dataset.push(dp)

    width = 460
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
    y_axis_label = ''
    if(data_to_render[0]['Label'] != undefined) # posts
      y_axis_label = 'Support'
      data_to_render.map (data_point) ->
        dp = {}
        dp['letter'] = data_point['Label'].replace(/[a-z ]/g, '')
        dp['score'] = data_point['Support']
        dataset.push(dp)
    else # employee contribution
      y_axis_label = 'Score'
      data_to_render.map (data_point) ->
        dp = {}
        dp['letter'] = data_point['Name'].replace(/[a-z ]/g, '')
        dp['score'] = 1.0 * data_point['# Ideas Actionable'] +
                      0.5 * data_point['# Ideas Approved'] +
                      0.2 * (data_point['# of Comments Received'] + data_point['# of Comments Given']) +
                      0.1 * (data_point['# of Votes Received'] + data_point['# of Votes Given'])
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
        .attr('y', 6).attr('dy', '-1.25em')
        .attr('dx', '2em').style('text-anchor', 'end')
        .text y_axis_label
    svg.selectAll('.bar').data(dataset).enter().append('rect').attr('class', 'bar').attr('x', (d) ->
      x d.letter
    ).attr('width', x.rangeBand()).attr('y', (d) ->
      y d.score
    ).attr 'height', (d) ->
      height - y(d.score)
    return


  render_multiline_chart = (where_to_render, data_to_render) ->
    data = []
    data_headers = data_to_render.shift()  # shift out first element
    data_to_render.map (data_point) ->
      dp = {}
      dp['date'] = data_point[0]
      for i in [1..3]
        dp[data_headers[i]] = parseInt(data_point[i])
      data.push(dp)

    margin =
      top: 20
      right: 50
      bottom: 50
      left: 50
    width = 460 - (margin.left) - (margin.right)
    height = 360 - (margin.top) - (margin.bottom)

    parseDate = d3.time.format('%m/%d/%Y').parse

    x = d3.time.scale().range([
      0
      width
    ])
    y = d3.scale.linear().range([
      height
      0
    ])
    color = d3.scale.category10()
    xAxis = d3.svg.axis().scale(x).orient('bottom')
      .tickFormat(d3.time.format('%b %d'))
    yAxis = d3.svg.axis().scale(y).orient('left')
    line = d3.svg.line().interpolate('basis').x((d) ->
      x d.date
    ).y((d) ->
      y d.temperature
    )
    svg = d3.select(where_to_render).append('svg')
      .attr('width', width + margin.left + margin.right)
      .attr('height', height + margin.top + margin.bottom)
      .append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    color.domain d3.keys(data[0]).filter((key) ->
      key != 'date'
    )
    data.forEach (d) ->
      d.date = parseDate(d.date)
      return
    cities = color.domain().map((name) ->
      {
        name: name
        values: data.map((d) ->
          {
            date: d.date
            temperature: +d[name]
          }
        )
      }
    )
    x.domain d3.extent(data, (d) ->
      d.date
    )
    y.domain [
      d3.min(cities, (c) ->
        d3.min c.values, (v) ->
          v.temperature
      )
      d3.max(cities, (c) ->
        d3.max c.values, (v) ->
          v.temperature
      )
    ]
    svg.append('g').attr('class', 'x axis')
      .attr('transform', 'translate(0,' + height + ')')
      .call(xAxis)
      .selectAll('text').style('text-anchor', 'end')
      .attr('dx', '-.8em').attr('dy', '.15em')
      .attr 'transform', (d) ->
        'rotate(-65)'

    svg.append('g').attr('class', 'y axis')
      .call(yAxis).append('text').attr('transform', 'rotate(-90)')
      .attr('y', 6).attr('dy', '.71em').style('text-anchor', 'end')
      .text 'Number of Posts'
    city = svg.selectAll('.city')
      .data(cities).enter()
      .append('g').attr('class', 'city')
    city.append('path').attr('class', 'line').attr('d', (d) ->
      line d.values
    ).style 'stroke', (d) ->
      color d.name
    city.append('text').datum((d) ->
      {
        name: d.name
        value: d.values[d.values.length - 1]
      }
    ).attr('transform', (d) ->
      'translate(' + x(d.value.date) + ',' + y(d.value.temperature) + ')'
    ).attr('x', -80).attr('dy', '0em').text (d) ->
      d.name
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
      render_bar_chart('#trending_ideas_graph', received_data.trending_ideas)
      render_bar_chart('#approved_ideas_graph', received_data.approved_ideas)
      render_multiline_chart('#detailed_trends_graph', received_data.detailed_trends)
      return
    error: (result) ->


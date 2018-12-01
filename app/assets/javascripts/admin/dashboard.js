$(document).ready(() => {
  const $chart = $('#statisticsChart')

  const xLabels = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
  ]
  const makeDataArray = () => new Array(xLabels.length).fill(0)
  const makeDataSet = () => {
    return makeDataArray().map(() => Math.round(Math.random() * 1000))
  }
  const findMax = array => Math.max(...array)

  const initializeChart = () => {
    const labels = {
      x: $chart.data('x-label'),
      y: $chart.data('y-label'),
      chart: $chart.data('label'),
    }

    const dataSet = makeDataSet()
    const maxData = findMax(dataSet)

    return new Chart($chart, {
      type: 'line',
      data: {
        labels: xLabels,
        datasets: [
          {
            label: labels.chart,
            backgroundColor: '#03a9f4',
            borderColor: '#03a9f4',
            data: dataSet,
            fill: false,
          },
        ],
      },
      options: {
        maintainAspectRatio: false,
        hover: {
          mode: 'nearest',
          intersect: true,
        },
        scales: {
          xAxes: [
            {
              display: true,
              scaleLabel: {
                display: true,
                labelString: labels.x,
              },
              gridLines: {
                drawTicks: false,
              },
              ticks: {
                padding: 20,
              },
            },
          ],
          yAxes: [
            {
              display: true,
              scaleLabel: {
                display: true,
                labelString: labels.y,
              },
              gridLines: {
                drawTicks: false,
              },
              ticks: {
                padding: 10,
                min: 0,
                stepSize: Math.round(maxData / 4),
              },
            },
          ],
        },
      },
    })
  }

  if ($chart.length > 0) {
    initializeChart()
  }
})

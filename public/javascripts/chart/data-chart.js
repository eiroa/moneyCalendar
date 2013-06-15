window.setGetData = function(dates, data) {
      return data = {
      labels : dates,
      datasets : [
        {
          fillColor : "rgba(220,220,220,0.5)",
          strokeColor : "rgba(220,220,220,1)",
          pointColor : "rgba(220,220,220,1)",
          pointStrokeColor : "#fff",
          data : data
        },
      ]
    }
}
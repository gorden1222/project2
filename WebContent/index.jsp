<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
#chartdiv {
  width: 100%;
  height: 500px;
}

</style>

<!-- Resources -->
<script src="https://www.amcharts.com/lib/4/core.js"></script>
<script src="https://www.amcharts.com/lib/4/charts.js"></script>
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>


<!-- Chart code -->
<script>

var updateInterval = 30000;

$(document).ready(function () {
	//init(); 
	 // 開啟selenium抓資料function
	 GetData();
});

function init(){
	$.ajax({
    	url: "/project2/LoadDataServlet.do",
    	data:{
    		doAction:"startGetData"
    	},
        dataType: "json",
        type: "POST",
        success: function(rtnData){
        },
        error: function () {
           init();
        }
    });
}

function GetData() {
    $.ajaxSetup({ cache: false });

    $.ajax({
    	url: "/project2/LoadDataServlet.do",
    	data:{
    		doAction:"loadData"
    	},
        dataType: "json",
        type: "POST",
        success: function(rtnData){
        	console.log(rtnData);
        	contents = rtnData[0].result[0].awayTeam;
        	length = Object.keys(rtnData).length;
        	length = Object.keys(rtnData[0].result).length;
        	
        	generateChartData(rtnData);
        },
        error: function () {
            setTimeout(GetData, updateInterval);
        }
    });
}

am4core.ready(function() {

// Themes begin
// Themes end

// Create chart instance
var chart = am4core.create("chartdiv", am4charts.XYChart);

// Increase contrast by taking evey second color
chart.colors.step = 2;

// Add data
chart.data = generateChartData();

// Create axes
var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
dateAxis.renderer.minGridDistance = 50;

// Create series
function createAxisAndSeries(field, name, opposite, bullet) {
  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
  
  var series = chart.series.push(new am4charts.LineSeries());
  series.dataFields.valueY = field;
  series.dataFields.dateX = "date";
  series.strokeWidth = 2;
  series.yAxis = valueAxis;
  series.name = name;
  series.tooltipText = "{name}: [bold]{valueY}[/]";
  series.tensionX = 1;
  
  var interfaceColors = new am4core.InterfaceColorSet();
  
  switch(bullet) {
    case "triangle":
      var bullet = series.bullets.push(new am4charts.Bullet());
      bullet.width = 12;
      bullet.height = 12;
      bullet.horizontalCenter = "middle";
      bullet.verticalCenter = "middle";
      
      var triangle = bullet.createChild(am4core.Triangle);
      triangle.stroke = interfaceColors.getFor("background");
      triangle.strokeWidth = 2;
      triangle.direction = "top";
      triangle.width = 12;
      triangle.height = 12;
      break;
    case "rectangle":
      var bullet = series.bullets.push(new am4charts.Bullet());
      bullet.width = 10;
      bullet.height = 10;
      bullet.horizontalCenter = "middle";
      bullet.verticalCenter = "middle";
      
      var rectangle = bullet.createChild(am4core.Rectangle);
      rectangle.stroke = interfaceColors.getFor("background");
      rectangle.strokeWidth = 2;
      rectangle.width = 10;
      rectangle.height = 10;
      break;
    default:
      var bullet = series.bullets.push(new am4charts.CircleBullet());
      bullet.circle.stroke = interfaceColors.getFor("background");
      bullet.circle.strokeWidth = 2;
      break;
  }
  
  valueAxis.renderer.line.strokeOpacity = 1;
  valueAxis.renderer.line.strokeWidth = 2;
  valueAxis.renderer.line.stroke = series.stroke;
  valueAxis.renderer.labels.template.fill = series.stroke;
  valueAxis.renderer.opposite = opposite;
  valueAxis.renderer.grid.template.disabled = true;
}

createAxisAndSeries("visits", "Visits", false, "circle");
createAxisAndSeries("views", "Views", true, "triangle");
createAxisAndSeries("hits", "Hits", true, "rectangle");


// Add legend
chart.legend = new am4charts.Legend();

// Add cursor
chart.cursor = new am4charts.XYCursor();

// generate some random data, quite different range
function generateChartData(data) {
  var chartData = [];
  var firstDate = new Date();
  firstDate.setDate(firstDate.getDate() - 100);
  firstDate.setHours(0, 0, 0, 0);

  var visits = 1600;
  var hits = 2900;
  var views = 8700;

  for (var i = 0; i < 15; i++) {
    var newDate = new Date(firstDate);
    newDate.setDate(newDate.getDate() + i);

    visits += Math.round((Math.random()<0.5?1:-1)*Math.random()*10);
    hits += Math.round((Math.random()<0.5?1:-1)*Math.random()*10);
    views += Math.round((Math.random()<0.5?1:-1)*Math.random()*10); 

    chartData.push({
      date: newDate,
      visits: visits,
      hits: hits,
      views: views
    });
  }
  return chartData;
}

}); // end am4core.ready()
</script>
</head>
<body>
<!-- HTML -->
<div id="chartdiv"></div>
</body>
</html>
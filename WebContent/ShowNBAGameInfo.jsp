<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- Styles -->
<style>
#chartdiv {
  width: 100%;
  height: 500px;
}

</style>

<!-- Resources -->
<script type="text/javascript" src="https://www.amcharts.com/lib/4/core.js"></script>
<script type="text/javascript" src="https://www.amcharts.com/lib/4/charts.js"></script>
<script type="text/javascript" src="https://www.amcharts.com/lib/4/themes/spiritedaway.js"></script>
<script type="text/javascript" src="https://www.amcharts.com/lib/4/themes/animated.js"></script>
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<title>Insert title here</title>

<!-- Chart code -->
<script>
var awaymoneyline = [], homemoneyline = [], awayhandicap = [], homehandicap = [], totalpoint_up = [], totalpoint_low = [], time = [];

var dataset;
var lastawaymoneyline = 0, lasthomemoneyline = 0, lastawayhandicap = 0, lasthomehandicap = 0, lasttotalpoint_up = 0, lasttotalpoint_low = 0;
var totalPoints = 100;
var updateInterval = 60000;
var now = new Date().getTime();
var inittime = now;
var contents;
var length;


function GetData() {
    $.ajaxSetup({ cache: false });

    $.ajax({
        
    	url: "/project2/LoadDataServlet.do",
    	data:{
    		doAction:"loadData",
    		type:"NBA"
    	},
        dataType: "json",
        type: "POST",
        success: function(rtnData){
        	update(rtnData);
        	console.log(rtnData);
        	contents = rtnData[0].result[0].awayTeam;
        	length = Object.keys(rtnData).length;
        	console.log(length);
        	length = Object.keys(rtnData[0].result).length;
        	console.log(length);
        	//alert(JSON.stringify(rtnData));
        	//setInterval(GetData, updateInterval);
        },
        error: function () {
            //setTimeout(GetData, updateInterval);
            console.log("error");
        }
    });
}

var temp;

function update(_data) {

	//var starttime = inittime,
	var count=0;
	CreateChart("runlinediv");
	for(i=0;i<Object.keys(_data).length;i++){
		//======[Pony]20190512, show charts(Not Comlete yet)========
		awaymoneyline = [], homemoneyline = [], awayhandicap = [], homehandicap = [], totalpoint_up = [], totalpoint_low = [];
		var btn = document.createElement("INPUT");   // Create a <button> element
		btn.setAttribute("type", "checkbox");
		btn.setAttribute("checked", "true");
		btn.setAttribute("value", i);
		btn.setAttribute("id", _data[i].result[0].awayTeam);
		//btn.setAttribute("value", _data[i].result[0].awayTeam + "V.S" + _data[i].result[0].homeTeam);
		btn.innerText = _data[i].result[0].awayTeam + "V.S" + _data[i].result[0].homeTeam;      // Insert text
		document.body.appendChild(btn);               // Append <button> to <body>
		var rundiv = document.createElement("div");
		rundiv.setAttribute("id",_data[i].result[0].awayTeam+"runline");
		document.body.appendChild(rundiv);
		var moneydiv = document.createElement("div");
		moneydiv.setAttribute("id",_data[i].result[0].awayTeam+"moneyline");
		document.body.appendChild(moneydiv);
		var totaldiv = document.createElement("div");
		totaldiv.setAttribute("id",_data[i].result[0].awayTeam+"total");
		document.body.appendChild(totaldiv);
		var runlinechartData = [],moneylinechartdata = [],totallinechartdata=[];
		//======[Pony]20190512, show charts(Not Comlete yet)========
		//CreateChart(_data[i].result[0].awayTeam+"runline");
		//CreateChart(_data[i].result[0].awayTeam+"moneyline");
		//CreateChart(_data[i].result[0].awayTeam+"total");
		for(j=0;j<Object.keys(_data[0].result).length;j++){
			//if(lastawaymoneyline == 0 || lastawaymoneyline != _data[0].result[j].awayMoneyLineOdds) {
				//temp = [_data[0].result[count].sysTime, _data[0].result[count].awayMoneyLineOdds];
			    awaymoneyline.push({
			    	time:_data[0].result[j].dataTime,
			    	values:_data[0].result[j].awayMoneyLineOdds
			    });
			    
			    lastawaymoneyline = _data[0].result[count].awayMoneyLineOdds;
			    console.log("awaymoneyline "+awaymoneyline[j].time);
			//}
			
		   // console.log(temp);
			if(lasthomemoneyline == 0 || lasthomemoneyline != _data[0].result[j].homeMoneyLineOdds) {
				//temp = [_data[0].result[j].sysTime, _data[0].result[j].homeMoneyLineOdds ];
			    //homemoneyline.push(temp);
			    homemoneyline.push({
			    	time:_data[0].result[j].dataTime,
			    	values:_data[0].result[j].homeMoneyLineOdds
			    });
			    lasthomemoneyline = _data[0].result[j].homeMoneyLineOdds;
			    console.log("homemoneyline "+homemoneyline);
			}
		    
			if(lastawayhandicap == 0 || lastawayhandicap != _data[0].result[j].awayHandicapOdds) {
				//temp = [_data[0].result[j].sysTime, _data[0].result[j].awayHandicapOdds, _data[0].result[count].awayHandicap];
			   // awayhandicap.push(temp);
			    awayhandicap.push({
			    	time:_data[0].result[j].dataTime,
			    	values:_data[0].result[j].awayHandicapOdds
			    });
			    lastawayhandicap = _data[0].result[j].awayHandicapOdds;
			    console.log("awayhandicap "+awayhandicap);
			    
			}
		    
		    if(lasthomehandicap == 0 || lasthomehandicap != _data[0].result[j].homeHandicapOdds) {
		    	//temp = [_data[0].result[count].sysTime, _data[0].result[count].homeHandicapOdds, _data[0].result[count].homeHandicap];
			   // homehandicap.push(temp);
			    homehandicap.push({
			    	time:_data[0].result[j].dataTime,
			    	values:_data[0].result[j].homeHandicapOdds
			    });
			    lasthomehandicap = _data[0].result[j].homeHandicapOdds;
			    console.log("homehandicap "+homehandicap);
		    }
		    
			if(lasttotalpoint_up == 0 || lasttotalpoint_up != _data[0].result[j].bigTotalOdds) {
				//temp = [_data[0].result[j].sysTime, _data[0].result[j].bigTotalOdds, _data[0].result[j].total];
			   // totalpoint_up.push(temp);
			    totalpoint_up.push({
			    	time:_data[0].result[j].dataTime,
			    	values:_data[0].result[j].bigTotalOdds
			    });
			    lasttotalpoint_up = _data[0].result[j].bigTotalOdds;
			    console.log("totalpoint_up "+totalpoint_up);
			    
			}
		    
			if(lasttotalpoint_low == 0 || lasttotalpoint_low != _data[0].result[j].smallTotalOdds) {
				//temp = [_data[0].result[j].sysTime, _data[0].result[j].smallTotalOdds, _data[0].result[count].total];
			   // totalpoint_low.push(temp);
			    totalpoint_low.push({
			    	time:_data[0].result[j].dataTime,
			    	values:_data[0].result[j].smallTotalOdds
			    });
			    lasttotalpoint_low = _data[0].result[j].smallTotalOdds;
			    console.log("totalpoint_low "+totalpoint_low);
			}

		}

	}
/*	while(count < Object.keys(_data[0].result).length) {

		if(lastawaymoneyline == 0 || lastawaymoneyline != _data[0].result[count].awayMoneyLineOdds) {
			temp = [_data[0].result[count].sysTime, _data[0].result[count].awayMoneyLineOdds];
		    awaymoneyline.push(temp);
		    lastawaymoneyline = _data[0].result[count].awayMoneyLineOdds;
		//    console.log(temp);
		}
		
	   // console.log(temp);
		if(lasthomemoneyline == 0 || lasthomemoneyline != _data[0].result[count].homeMoneyLineOdds) {
			temp = [_data[0].result[count].sysTime, _data[0].result[count].homeMoneyLineOdds ];
		    homemoneyline.push(temp);
		    lasthomemoneyline = _data[0].result[count].homeMoneyLineOdds;
		}
	    
		if(lastawayhandicap == 0 || lastawayhandicap != _data[0].result[count].awayHandicapOdds) {
			temp = [_data[0].result[count].sysTime, _data[0].result[count].awayHandicapOdds, _data[0].result[count].awayHandicap];
		    awayhandicap.push(temp);
		    lastawayhandicap = _data[0].result[count].awayHandicapOdds;
		    
		}
	    
	    if(lasthomehandicap == 0 || lasthomehandicap != _data[0].result[count].homeHandicapOdds) {
	    	temp = [_data[0].result[count].sysTime, _data[0].result[count].homeHandicapOdds, _data[0].result[count].homeHandicap];
		    homehandicap.push(temp);
		    lasthomehandicap = _data[0].result[count].homeHandicapOdds;
	    }
	    
		if(lasttotalpoint_up == 0 || lasttotalpoint_up != _data[0].result[count].bigTotalOdds) {
			temp = [_data[0].result[count].sysTime, _data[0].result[count].bigTotalOdds, _data[0].result[count].total];
		    totalpoint_up.push(temp);
		    lasttotalpoint_up = _data[0].result[count].bigTotalOdds;
		}
	    
		if(lasttotalpoint_low == 0 || lasttotalpoint_low != _data[0].result[count].smallTotalOdds) {
			temp = [_data[0].result[count].sysTime, _data[0].result[count].smallTotalOdds, _data[0].result[count].total];
		    totalpoint_low.push(temp);
		    lasttotalpoint_low = _data[0].result[count].smallTotalOdds;
		}
	    
	    count++;
	   // starttime += updateInterval;	
	}
	*/
	//am4core.ready(); // end am4core.ready()
    now += updateInterval;
   // setTimeout(GetData, updateInterval);
}

function CreateChart(divname) {

	// Themes begin
	am4core.useTheme(am4themes_spiritedaway);
	am4core.useTheme(am4themes_animated);
	// Themes end

	// Create chart instance
	var chart = am4core.create(divname, am4charts.XYChart);

	chart.data = generateChartData();
	//console.log(secondDate);

	// Set input format for the dates
	//chart.dateFormatter.inputDateFormat = "yyyy-MM-dd";
	var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
	dateAxis.baseInterval = {
	  "timeUnit": "minute",
	  "count": 1
	};
	//dateAxis.baseUnit = "second";
	dateAxis.title.text = "time";
	//chart.durationFormatter.durationFormat = "hh 'hours' mm 'minutes' ss 'seconds'";
	dateAxis.tooltipDateFormat = "HH:mm, d MM";

	// Create axes
	//var dateAxis = chart.xAxes.push(new am4charts.DurationAxis());
	var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());

	var series = chart.series.push(new am4charts.LineSeries());
	series.dataFields.valueY = "value";
	series.dataFields.dateX = "time";
	series.tooltipText = "{value: [bold]{valueY}[/]}";
	series.fillOpacity = 0.3;
	series.strokeWidth = 2;
	series.minBulletDistance = 15;

	// Drop-shaped tooltips
	series.tooltip.background.cornerRadius = 20;
	series.tooltip.background.strokeOpacity = 0;
	series.tooltip.pointerOrientation = "vertical";
	series.tooltip.label.minWidth = 40;
	series.tooltip.label.minHeight = 40;
	series.tooltip.label.textAlign = "middle";
	series.tooltip.label.textValign = "middle";

	// Make bullets grow on hover
	var bullet = series.bullets.push(new am4charts.CircleBullet());
	bullet.circle.strokeWidth = 2;
	bullet.circle.radius = 4;
	bullet.circle.fill = am4core.color("#fff");

	var bullethover = bullet.states.create("hover");
	bullethover.properties.scale = 1.3;

	// Make a panning cursor
	chart.cursor = new am4charts.XYCursor();
	chart.cursor.behavior = "panXY";
	chart.cursor.xAxis = dateAxis;
	chart.cursor.snapToSeries = series;

	// Create vertical scrollbar and place it before the value axis
	chart.scrollbarY = new am4core.Scrollbar();
	chart.scrollbarY.parent = chart.leftAxesContainer;
	chart.scrollbarY.toBack();

	// Create a horizontal scrollbar with previe and place it underneath the date axis
	chart.scrollbarX = new am4charts.XYChartScrollbar();
	chart.scrollbarX.series.push(series);
	chart.scrollbarX.parent = chart.bottomAxesContainer;

	chart.events.on("ready", function () {
	  dateAxis.zoom({start:0.79, end:1});
	});
	function generateChartData() {
	    var chartData = [];
	    // current date
	    var firstDate = new Date();
	    // now set 500 minutes back
	    firstDate.setMinutes(firstDate.getDate() - 500);

	    // and generate 500 data items
	    var visits = 500;
	    for (var i = 0; i < 500; i++) {
	        var newDate = new Date(firstDate);
	        // each time we add one minute
	        newDate.setMinutes(newDate.getMinutes() + i);
	        // some random number
	        visits += Math.round((Math.random()<0.5?1:-1)*Math.random()*10);
	        // add data item to the array
	        chartData.push({
	            time: newDate,
	            value: visits
	        });
	        console.log(newDate);
	      //  console.log(visits);
	    }
	    return chartData;
	}

}


$(document).ready(function () {
	//init(); 
	 // 開啟selenium抓資料function
	//setTimeout(GetData, updateInterval);
	 console.log("ShowNBAGame");
	 GetData();    
});
</script>


</head>
<body>
<!-- HTML -->
<div id="runlinediv"></div>

</body>
</html>
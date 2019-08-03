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
<title>Show NBA Charts</title>

<!-- Chart code -->
<script>
var awaymoneyline = [], homemoneyline = [], awayhandicap = [], homehandicap = [], totalpoint_up = [], totalpoint_low = [];
var moneyline = [], handicap = [], total = [];
var dataset;
var lastawaymoneyline = 0, lasthomemoneyline = 0, lastawayhandicap = 0, lasthomehandicap = 0, lasttotalpoint_up = 0, lasttotalpoint_low = 0;
var totalPoints = 100;
var updateInterval = 60000;
var now = new Date().getTime();
var inittime = now;
var contents;
var length;


function init() {
	$.ajaxSetup({ cache: false });
	
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
           // setTimeout(GetData, updateInterval);
           init();
        }
    });
}

function GetData() {
    $.ajaxSetup({ cache: false });

    $.ajax({
        //url: "http://www.jqueryflottutorial.com/AjaxUpdateChart.aspx",
    	url: "/project2/LoadDataServlet.do",
    	data:{
    		doAction:"loadData",
    		type:"1"
    	},
        dataType: "json",
        async: false,
        type: "GET",
        success: function(rtnData){
        	update(rtnData);
        	console.log(rtnData);
        	contents = rtnData[0].result[0].awayTeam;
        	length = Object.keys(rtnData).length;
        	console.log(length);
        	length = Object.keys(rtnData[0].result).length;
        	console.log(length);
        	checkboxclick();
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
function checkboxclick(){
	var checkboxes = document.getElementsByTagName('input');
	for(i = 0;i < checkboxes.length; i++){
	//	console.log(checkboxes[i].id);
		document.getElementById(checkboxes[i].id).onclick = function() {
		    // access properties using this keyword
		    if ( this.checked ) {
		        console.log(this.id + "checked");
		    	var awayRunlineSpan = document.getElementById(this.id + " Runline");
		    	awayRunlineSpan.style.display = ''; 
		    	var homeRunlineSpan = document.getElementById(this.name + " Runline");
		    	homeRunlineSpan.style.display = ''; 
		    	
		    	var awayMoneylineSpan = document.getElementById(this.id + " Moneyline");
		    	awayMoneylineSpan.style.display = ''; 
		    	var homeMoneylineSpan = document.getElementById(this.name + " Moneyline");
		    	homeMoneylineSpan.style.display = ''; 
		    	
				var total_upSpan = document.getElementById(this.id + "V.S" + this.name + " total_up");
				total_upSpan.style.display = '';
				var total_lowSpan = document.getElementById(this.id + "V.S" + this.name + " total_low");
				total_lowSpan.style.display = '';
				
				var away_rundiv = document.getElementById(this.id+"runline");
				away_rundiv.style.display = '';
				var home_rundiv = document.getElementById(this.name+"runline");
				home_rundiv.style.display = '';
				
				var away_moneydiv = document.getElementById(this.id+"moneyline");
				away_moneydiv.style.display = '';
				var home_moneydiv = document.getElementById(this.name+"moneyline");
				home_moneydiv.style.display = '';
				
				var total_up_div = document.getElementById((this.value)+ "_total_up");
				total_up_div.style.display = '';
				var total_low_div = document.getElementById((this.value) + "_total_low");
				total_low_div.style.display = '';
				
		    } else {
		    //	console.log(this.id + "unchecked");
		    	var awayRunlineSpan = document.getElementById(this.id + " Runline");
		    	awayRunlineSpan.style.display = 'none'; 
		    	var homeRunlineSpan = document.getElementById(this.name + " Runline");
		    	homeRunlineSpan.style.display = 'none'; 
		    	
		    	var awayMoneylineSpan = document.getElementById(this.id + " Moneyline");
		    	awayMoneylineSpan.style.display = 'none'; 
		    	var homeMoneylineSpan = document.getElementById(this.name + " Moneyline");
		    	homeMoneylineSpan.style.display = 'none'; 
		    	
				var total_upSpan = document.getElementById(this.id + "V.S" + this.name + " total_up");
				total_upSpan.style.display = 'none';
				var total_lowSpan = document.getElementById(this.id + "V.S" + this.name + " total_low");
				total_lowSpan.style.display = 'none';
				
				var away_rundiv = document.getElementById(this.id+"runline");
				away_rundiv.style.display = 'none';
				var home_rundiv = document.getElementById(this.name+"runline");
				home_rundiv.style.display = 'none';
				
				var away_moneydiv = document.getElementById(this.id+"moneyline");
				away_moneydiv.style.display = 'none';
				var home_moneydiv = document.getElementById(this.name+"moneyline");
				home_moneydiv.style.display = 'none';
				
				var total_up_div = document.getElementById((this.value)+ "_total_up");
				total_up_div.style.display = 'none';
				var total_low_div = document.getElementById((this.value) + "_total_low");
				total_low_div.style.display = 'none';

		        
		    }
		};
	}
}

function update(_data) {

	//var starttime = inittime,
	var count=0;
	//CreateChart("runlinediv");
	console.log("_data.length = " + Object.keys(_data).length);
	var index = <%= request.getParameter("id") %>

		//======[Pony]20190512, show charts(Not Comlete yet)========
		awaymoneyline = [], homemoneyline = [], awayhandicap = [], homehandicap = [], totalpoint_up = [], totalpoint_low = [];
		moneyline = [];
		handicap = [];
		total = [];
		
		//===========[Pony]生成Checkbox(想要用來顯示/隱藏每一場對戰的charts)==========
		var textdiv = document.createElement("div");
		textdiv.setAttribute("id","height: 200px");
		textdiv.setAttribute("align","center");
		textdiv.setAttribute("style","height: 250px;width: 100%;");
		
			
		var btn = document.createElement("input");   // Create a <button> element
		btn.setAttribute("type", "checkbox");
		btn.setAttribute("checked", "false");
		btn.setAttribute("value", index);
		btn.setAttribute("id", _data[index].result[0].awayTeam);
		btn.setAttribute("name", _data[index].result[0].homeTeam);
		btn.setAttribute("align", "center");
		btn.setAttribute("style", "width:20px;height:20px;");
		//btn.setAttribute("value", _data[index].result[0].awayTeam + "V.S" + _data[index].result[0].homeTeam);
		btn.innerHtml = _data[index].result[0].awayTeam + "V.S" + _data[index].result[0].homeTeam;      // Insert text
		textdiv.appendChild(btn);
		//document.body.appendChild(btn);               // Append <button> to <body>
		
		var TextSpan = document.createElement("span");
		TextSpan.setAttribute("name",_data[index].result[0].awayTeam + "V.S" + _data[index].result[0].homeTeam);
		TextSpan.setAttribute("style","font-size:36px;");
		TextSpan.setAttribute("align", "center");
		TextSpan.appendChild(document.createTextNode(_data[index].result[0].awayTeam + "V.S" + _data[index].result[0].homeTeam));

		textdiv.appendChild(TextSpan);
		document.body.appendChild(textdiv); 
		//===========[Pony]生成Checkbox(想要用來顯示/隱藏每一場對戰的charts)==========
			
			
			
		//==============[Pony]Create Charts DIV=================
		//每個對戰組合(每份JSON檔)生出六個Charts(主隊&母隊的讓分、PK盤以及大小分)	
			
		var awayRunlineSpan = document.createElement("span");
		awayRunlineSpan.setAttribute("id",_data[index].result[0].awayTeam + " Runline");
		awayRunlineSpan.setAttribute("style","font-size:24px;");
		awayRunlineSpan.appendChild(document.createTextNode(_data[index].result[0].awayTeam + " Runline"));
		document.body.appendChild(awayRunlineSpan); 
		var away_rundiv = document.createElement("div");
		away_rundiv.setAttribute("id",_data[index].result[0].awayTeam+"runline");
		away_rundiv.setAttribute("style","height: 600px");
		document.body.appendChild(away_rundiv);
		
		var homeRunlineSpan = document.createElement("span");
		homeRunlineSpan.setAttribute("id",_data[index].result[0].homeTeam + " Runline");
		homeRunlineSpan.setAttribute("style","font-size:24px;");
		homeRunlineSpan.appendChild(document.createTextNode(_data[index].result[0].homeTeam + " Runline"));
		document.body.appendChild(homeRunlineSpan); 
		var home_rundiv = document.createElement("div");
		home_rundiv.setAttribute("id",_data[index].result[0].homeTeam+"runline");
		home_rundiv.setAttribute("style","height: 600px");
		document.body.appendChild(home_rundiv);
		
		var awayMoneylineSpan = document.createElement("span");
		awayMoneylineSpan.setAttribute("id",_data[index].result[0].awayTeam + " Moneyline");
		awayMoneylineSpan.setAttribute("style","font-size:24px;");
		awayMoneylineSpan.appendChild(document.createTextNode(_data[index].result[0].awayTeam + " Moneyline"));
		document.body.appendChild(awayMoneylineSpan); 
		var away_moneydiv = document.createElement("div");
		away_moneydiv.setAttribute("id",_data[index].result[0].awayTeam+"moneyline");
		away_moneydiv.setAttribute("style","height: 600px");
		document.body.appendChild(away_moneydiv);
		
		var homeMoneylineSpan = document.createElement("span");
		homeMoneylineSpan.setAttribute("id",_data[index].result[0].homeTeam + " Moneyline");
		homeMoneylineSpan.setAttribute("style","font-size:24px;");
		homeMoneylineSpan.appendChild(document.createTextNode(_data[index].result[0].homeTeam + " Moneyline"));
		document.body.appendChild(homeMoneylineSpan);
		var home_moneydiv = document.createElement("div");
		home_moneydiv.setAttribute("id",_data[index].result[0].homeTeam+"moneyline");
		home_moneydiv.setAttribute("style","height: 600px");
		document.body.appendChild(home_moneydiv);
		
		var total_upSpan = document.createElement("span");
		total_upSpan.setAttribute("id",_data[index].result[0].awayTeam + "V.S" + _data[index].result[0].homeTeam + " total_up");
		total_upSpan.setAttribute("style","font-size:24px;");
		total_upSpan.appendChild(document.createTextNode((_data[index].result[0].awayTeam + "V.S" + _data[index].result[0].homeTeam) + " total_up"));
		document.body.appendChild(total_upSpan); 
		var total_up_div = document.createElement("div");
		total_up_div.setAttribute("id",index + "_total_up");
		total_up_div.setAttribute("style","height: 600px");
		document.body.appendChild(total_up_div);
		

		var total_lowSpan = document.createElement("span");
		total_lowSpan.setAttribute("id",_data[index].result[0].awayTeam + "V.S" + _data[index].result[0].homeTeam + " total_low");
		total_lowSpan.setAttribute("style","font-size:24px;");
		total_lowSpan.appendChild(document.createTextNode((_data[index].result[0].awayTeam + "V.S" + _data[index].result[0].homeTeam) + " total_low"));
		document.body.appendChild(total_lowSpan); 
		var total_low_div = document.createElement("div");
		total_low_div.setAttribute("id",index + "_total_low");
		total_low_div.setAttribute("style","height: 600px");
		document.body.appendChild(total_low_div);
		var runlinechartData = [],moneylinechartdata = [],totallinechartdata=[];
		//console.log("result.length = " + Object.keys(_data[index].result).length);
		//==============[Pony]Create Charts DIV=================
			
			
			
		//============[Pony]Push資料到Array裡面讓Charts套用================
		for(j=0;j<Object.keys(_data[index].result).length;j++){
			
			if(j == 0){
				
			    moneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	away:_data[index].result[j].awayMoneyLineOdds,
			    	home:_data[index].result[j].homeMoneyLineOdds
			    });
			    
			    awaymoneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].awayMoneyLineOdds
			    });
			    
			    homemoneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].homeMoneyLineOdds
			    });
			    
			    
			    lastawaymoneyline = _data[index].result[count].awayMoneyLineOdds;

			    handicap.push({
			    	time:_data[index].result[j].dataTime,
			    	away:_data[index].result[j].awayHandicapOdds,
			    	home:_data[index].result[j].homeHandicapOdds	
			    });
			    lastawayhandicap = _data[index].result[j].awayHandicapOdds;
			   // console.log("awayhandicap "+awayhandicap);
			    
			    awayhandicap.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].awayHandicapOdds
			    });
			    
			    homehandicap.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].homeHandicapOdds
			    });

			    total.push({
			    	time:_data[index].result[j].dataTime,
			    	away:_data[index].result[j].bigTotalOdds,
			    	home:_data[index].result[j].smallTotalOdds
			    });
			    lasttotalpoint_up = _data[index].result[j].bigTotalOdds;
			//    console.log("totalpoint_up "+totalpoint_up);
			    
			    totalpoint_up.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].bigTotalOdds
			    });
			    
			    totalpoint_low.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].smallTotalOdds
			    });
			} else if(0 < j < Object.keys(_data[index].result).length - 1){
				
				if(_data[index].result[j].awayMoneyLineOdds != _data[index].result[j-1].awayMoneyLineOdds)			    
			    awaymoneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].awayMoneyLineOdds
			    });
			    
				if(_data[index].result[j].homeMoneyLineOdds != _data[index].result[j-1].homeMoneyLineOdds)
			    homemoneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].homeMoneyLineOdds
			    });
			    	
				if(_data[index].result[j].awayHandicapOdds != _data[index].result[j-1].awayHandicapOdds
				  ||_data[index].result[j].awayHandicap != _data[index].result[j-1].awayHandicap)
			    
			    awayhandicap.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].awayHandicapOdds
			    });
			    
				if(_data[index].result[j].homeHandicapOdds != _data[index].result[j-1].homeHandicapOdds
				  || _data[index].result[j].homeHandicap != _data[index].result[j-1].homeHandicap)
			    homehandicap.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].homeHandicapOdds
			    });
			    
				if(_data[index].result[j].bigTotalOdds != _data[index].result[j-1].bigTotalOdds
				 || _data[index].result[j].total != _data[index].result[j-1].total)
			    totalpoint_up.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].bigTotalOdds
			    });
			    
				if(_data[index].result[j].smallTotalOdds != _data[index].result[j-1].smallTotalOdds
				  || _data[index].result[j].total != _data[index].result[j-1].total)
			    totalpoint_low.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].smallTotalOdds
			    });
			    
			}else{
			    moneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	away:_data[index].result[j].awayMoneyLineOdds,
			    	home:_data[index].result[j].homeMoneyLineOdds
			    });
			    
			    awaymoneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].awayMoneyLineOdds
			    });
			    
			    homemoneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].homeMoneyLineOdds
			    });
			    
			    
			    lastawaymoneyline = _data[index].result[count].awayMoneyLineOdds;

			    handicap.push({
			    	time:_data[index].result[j].dataTime,
			    	away:_data[index].result[j].awayHandicapOdds,
			    	home:_data[index].result[j].homeHandicapOdds	
			    });
			    lastawayhandicap = _data[index].result[j].awayHandicapOdds;
			   // console.log("awayhandicap "+awayhandicap);
			    
			    awayhandicap.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].awayHandicapOdds
			    });
			    
			    homehandicap.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].homeHandicapOdds
			    });

			    total.push({
			    	time:_data[index].result[j].dataTime,
			    	away:_data[index].result[j].bigTotalOdds,
			    	home:_data[index].result[j].smallTotalOdds
			    });
			    lasttotalpoint_up = _data[index].result[j].bigTotalOdds;
			//    console.log("totalpoint_up "+totalpoint_up);
			    
			    totalpoint_up.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].bigTotalOdds
			    });
			    
			    totalpoint_low.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].smallTotalOdds
			    });
			}




		}
		//============[Pony]Push資料到Array裡面讓Charts套用================
			
			
		//======[Pony]20190512, show charts(Not Comlete yet)========
		//CreateMulChart(_data[index].result[0].awayTeam+"runline",moneyline);
		//CreateMulChart(_data[index].result[0].awayTeam+"moneyline",handicap);
		//CreateMulChart(_data[index].result[0].awayTeam+"total",total);
		
		//======[Pony]將資料以及div name輸入到生成chart的 function========
		CreateChart(_data[index].result[0].awayTeam+"moneyline",awaymoneyline);
		CreateChart(_data[index].result[0].homeTeam+"moneyline",homemoneyline);
		
		CreateChart(_data[index].result[0].awayTeam+"runline",awayhandicap);
		CreateChart(_data[index].result[0].homeTeam+"runline",homehandicap);
		
		CreateChart(index + "_total_up",totalpoint_up);
		CreateChart(index + "_total_low",totalpoint_low);
		var br =  document.createElement("br");
		document.body.appendChild(br);
		//======[Pony]將資料以及div name輸入到生成chart的 function========

}
function CreateChart(divname,datas) {

	// Themes begin
	am4core.useTheme(am4themes_spiritedaway);
	am4core.useTheme(am4themes_animated);
	// Themes end

	// Create chart instance
	var chart = am4core.create(divname, am4charts.XYChart);

	chart.data = datas;

	// Set input format for the dates
	//chart.dateFormatter.inputDateFormat = "yyyy-MM-dd";
	var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
	dateAxis.baseInterval = {
	  "timeUnit": "second",
	  "count": 1
	};
	//dateAxis.baseUnit = "second";
	dateAxis.title.text = "time";
	//chart.durationFormatter.durationFormat = "hh 'hours' mm 'minutes' ss 'seconds'";
	dateAxis.tooltipDateFormat = "HH:mm:ss, d MMMM";

	// Create axes
	//var dateAxis = chart.xAxes.push(new am4charts.DurationAxis());
	var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());

	var series = chart.series.push(new am4charts.LineSeries());
	series.dataFields.valueY = "value";
	series.dataFields.dateX = "time";
	//series.tooltipText = "{value: [bold]{valueY}[/]}";
	
	series.tooltipText = "{dateX}: {valueY}";//[Pony]改這個可以修改滑鼠放在每個點上面時該顯示甚麼資料
	
	series.fillOpacity = 0.3;
	//series.strokeWidth = 2;
	//series.minBulletDistance = 15;

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
	    firstDate.setMinutes(firstDate.getDate() - 20);

	    // and generate 500 data items
	    var visits = 20;
	    for (var i = 0; i < 20; i++) {
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
	        console.log(visits);
	    }
	    return chartData;
	}

}

function CreateMulChart(divname,datas) {
	// Themes begin
	// Themes end
	// Create chart instance
	var chart = am4core.create(divname, am4charts.XYChart);
	// Increase contrast by taking evey second color
	chart.colors.step = 2;
	// Add data
	//chart.data = generateChartData();
	chart.data = datas;
	// Create axes
	var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
	dateAxis.baseInterval = {
	  "timeUnit": "minute",
	  "count": 1
	};
	//dateAxis.baseUnit = "second";
	dateAxis.title.text = "time";
	//chart.durationFormatter.durationFormat = "hh 'hours' mm 'minutes' ss 'seconds'";
	dateAxis.tooltipDateFormat = "HH:mm, d MM";
	function createAxisAndSeries(field, name, opposite, bullet) {
	  var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
	  
	  var series = chart.series.push(new am4charts.LineSeries());
	  series.dataFields.valueY = field;
	  series.dataFields.dateX = "time";
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
	createAxisAndSeries("away", "away", false, "circle");
	createAxisAndSeries("home", "home", true, "triangle");
//	createAxisAndSeries("hits", "Hits", true, "rectangle");
	// Add legend
	chart.legend = new am4charts.Legend();
	// Add cursor
	//chart.cursor = new am4charts.XYCursor();
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
<!-- <div id="runlinediv" style="left: 0px; max-width: 100%; height: 400px"></div> -->
</body>
</html>
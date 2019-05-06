<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link href="./examples.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" type="text/css" href="flot.css" />
    <title></title>
    <script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
	
	<script type="text/javascript" src="js/flot/jquery.flot.min.js"></script>
	<script type="text/javascript" src="js/flot/jquery.flot.js"></script>
	<script type="text/javascript" src="js/flot/jquery.flot.time.js"></script>    
	<script type="text/javascript" src="js/flot/jshashtable-2.1.js"></script>    
	<script type="text/javascript" src="js/flot/jquery.numberformatter-1.2.3.min.js"></script>
	<script type="text/javascript" src="js/flot/jquery.flot.symbol.js"></script>
	<script type="text/javascript" src="js/flot/jquery.flot.axislabels.js"></script>
	<script>
	var awaymoneyline = [], homemoneyline = [], awayhandicap = [], homehandicap = [], totalpoint_up = [], totalpoint_low = [];
	var dataset;
	var lastawaymoneyline = 0, lasthomemoneyline = 0, lastawayhandicap = 0, lasthomehandicap = 0, lasttotalpoint_up = 0, lasttotalpoint_low = 0;
	var totalPoints = 100;
	var updateInterval = 30000;
	var now = new Date().getTime();
	var inittime = now;
	var contents;
	var length;
	var data = [[1, 130], [2, 40], [3, 80], [4, 160], [5, 159], [6, 370], [7, 330], [8, 350], [9, 370], [10, 400], [11, 330], [12, 350]];

	 
    var dataset = [{ label: "AwayMoneyLine", data: awaymoneyline, lines:{show: true,lineWidth:1.2}, color: "#00FF00" },
                   { label: "AwayHandicap", data: awayhandicap,lines: {show: true,lineWidth: 1.2}, color: "#0044FF",},
                   { label: "HomeMoneyLine", data: homemoneyline, lines:{show: true,lineWidth:1.2}, color: "#00FFFF" },
                   { label: "HomeHandicap", data: homehandicap,lines: {show: true,lineWidth: 1.2}, color: "#00FFDD",},
                   { label: "Upper to Total Point", data: totalpoint_up, lines: {show: true,lineWidth: 1.2}, color: "#FF0000" },
                   { label: "Lower to Total Point", data: totalpoint_low, lines: {show: true,lineWidth: 1.2}, color: "#0000FF" }];
//---------------------------flot2-----------------------------------
    var options = {
        series: {
            lines: { show: true },
            points: {
                radius: 3,
                show: true
            }
        },
       xaxis: {
        mode: "time",
        tickSize: [10, "minute"],
        tickFormatter: function (v, axis) {
            var date = new Date(v);

            if (date.getSeconds() % 30 == 0) {

        	   var hours = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
               var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
               var seconds = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();

                return hours + ":" + minutes + ":" + seconds;
            } else {
                return "";
            }
        },
        axisLabel: "Time",
        axisLabelUseCanvas: true,
        axisLabelFontSizePixels: 12,
        axisLabelFontFamily: 'Verdana, Arial',
        axisLabelPadding: 10
      },
      grid: {      
	        backgroundColor: { colors: ["#ffffff", "#EDF5FF"] },
	    	hoverable:true,
	    	clickable:true
	  }
    };

 /*   $(document).ready(function () {
        $.plot($("#flot-placeholder2"), dataset, options);
    });*/
    
//---------------------------flot2-----------------------------------    
	var options2 = {
	    series: {
	        lines: {
	            lineWidth: 1.2
	        },
	        points: {
                radius: 3,
                show: true
            },
	        bars: {
	            align: "center",
	            fillColor: { colors: [{ opacity: 1 }, { opacity: 1}] },
	            barWidth: 500,
	            lineWidth: 1
	        }
	    },
	    xaxis: {
	        mode: "time",
	        tickSize: [10, "minute"],
	        tickFormatter: function (v, axis) {
	            var date = new Date(v);
	
	            if (date.getSeconds() % 30 == 0) {
	                var hours = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
	                var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
	                var seconds = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
	
	                return hours + ":" + minutes ;
	            } else {
	                return "";
	            }
	        },
	        axisLabel: "Time",
	        axisLabelUseCanvas: true,
	        axisLabelFontSizePixels: 12,
	        axisLabelFontFamily: 'Verdana, Arial',
	        axisLabelPadding: 10
	    },
	  /*  yaxes: [
	        {
	            min: 0,
	            max: 100,
	            tickSize: 10,
	            tickFormatter: function (v, axis) {
	                if (v % 10 == 0) {
	                    return v + "%";
	                } else {
	                    return "";
	                }
	            },
	            axisLabel: "Odds",
	            axisLabelUseCanvas: true,
	            axisLabelFontSizePixels: 12,
	            axisLabelFontFamily: 'Verdana, Arial',
	            axisLabelPadding: 6
	        }, {
	            max: 6120,
	            position: "right",
	            axisLabel: "Test",
	            axisLabelUseCanvas: true,
	            axisLabelFontSizePixels: 12,
	            axisLabelFontFamily: 'Verdana, Arial',
	            axisLabelPadding: 6
	        }
	    ],*/
	    legend: {
	        noColumns: 0,
	        position:"nw"
	    },
	    grid: {      
	        backgroundColor: { colors: ["#ffffff", "#EDF5FF"] },
	    	hoverable:true,
	    	clickable:true
	    }
	};
	
	function initData() {
	    for (var i = 0; i < totalPoints; i++) {
	        var temp = [now += updateInterval, 0];
	
	        cpu.push(temp);
	        cpuCore.push(temp);
	        disk.push(temp);
	    }
	}
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
	    dataset = [{ label: "AwayMoneyLine", data: awaymoneyline, lines:{show: true,lineWidth:1.2}, color: "#00FF00" },
                   { label: "AwayHandicap:", data: awayhandicap,lines: {show: true,lineWidth: 1.2}, color: "#0044FF",},
                   { label: "HomeMoneyLine", data: homemoneyline, lines:{show: true,lineWidth:1.2}, color: "#00FFFF" },
                   { label: "HomeHandicap:", data: homehandicap,lines: {show: true,lineWidth: 1.2}, color: "#00FF44",},
                   { label: "Upper to Total Point", data: totalpoint_up, lines: {show: true,lineWidth: 1.2}, color: "#FF0000" },
                   { label: "Lower to Total Point", data: totalpoint_low, lines: {show: true,lineWidth: 1.2}, color: "#0000FF" }];
	
	    $.plot($("#flot-placeholder1"), dataset, options2);
	    $.plot($("#flot-placeholder2"), dataset, options);

		$("#flot-placeholder1").bind("plothover", function (event, pos, item) {

				if (item) {
					var timeMilliSec = item.datapoint[0].toFixed(0);
					var tmpdate = new Date(parseInt(timeMilliSec));
					var x = tmpdate.getHours() + ":" + tmpdate.getMinutes() + ":" + tmpdate.getSeconds();
					var y = item.datapoint[1].toFixed(3);
					var z = item.series.data[item.dataIndex][2];
					if(z === undefined || z === null)
					$("#tooltip").html(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y)
						.css({top: item.pageY+5, left: item.pageX+5})
						.fadeIn(200);
					else $("#tooltip").html(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y + " ,\n value =  " + z)
					.css({top: item.pageY+5, left: item.pageX+5})
					.fadeIn(200);
				} else {
					$("#tooltip").hide();
				}
		});
		$("#flot-placeholder2").bind("plothover", function (event, pos, item) {

				if (item) {
					var timeMilliSec = item.datapoint[0].toFixed(0);
					var tmpdate = new Date(parseInt(timeMilliSec));
					
					var x = tmpdate.getHours() + ":" + tmpdate.getMinutes() + ":" + tmpdate.getSeconds();
					var y = item.datapoint[1].toFixed(3);
					var z = item.series.data[item.dataIndex][2];
					if(z === undefined || z === null)
						$("#tooltip").html(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y)
							.css({top: item.pageY+5, left: item.pageX+5})
							.fadeIn(200);
						else $("#tooltip").html(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y + " ,\n value =  " + z)
						.css({top: item.pageY+5, left: item.pageX+5})
						.fadeIn(200);
				} else {
					$("#tooltip").hide();
				}
		});
		$("#flot-placeholder1").bind("plotclick", function (event, pos, item) {
			if (item) {
				var timeMilliSec = item.datapoint[0].toFixed(0);
				var tmpdate = new Date(parseInt(timeMilliSec));
				console.log(item);
				var x = tmpdate.getHours() + ":" + tmpdate.getMinutes() + ":" + tmpdate.getSeconds();
				var y = item.datapoint[1].toFixed(3);
				var z = item.series.data[item.dataIndex][2];
				if(z === undefined || z === null) alert(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y);
				else alert(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y + " ,\n value =  " + z);
				//$("#clickdata").text(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y);
				//plot.highlight(item.series, item.datapoint);
			}
		});
		$("#flot-placeholder2").bind("plotclick", function (event, pos, item) {
			if (item) {
				var timeMilliSec = item.datapoint[0].toFixed(0);
				var tmpdate = new Date(parseInt(timeMilliSec));
				console.log(item);
				var x = tmpdate.getHours() + ":" + tmpdate.getMinutes() + ":" + tmpdate.getSeconds();
				var y = item.datapoint[1].toFixed(3);
				var z = item.series.data[item.dataIndex][2];
				if(z === undefined || z === null) alert(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y);
				else alert(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y + " ,\n value =  " + z);
				//$("#clickdata").text(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y);
				//plot.highlight(item.series, item.datapoint);
			}
		});
	}
	
	function GetData() {
	    $.ajaxSetup({ cache: false });
	
	    $.ajax({
	        //url: "http://www.jqueryflottutorial.com/AjaxUpdateChart.aspx",
	    	url: "/project2/LoadDataServlet.do",
	    	data:{
	    		doAction:"loadData"
	    	},
	        dataType: "json",
	        type: "POST",
	        success: function(rtnData){
	        	update(rtnData);
	        	console.log(rtnData);
	        	contents = rtnData[0].result[0].awayTeam;
	        	length = Object.keys(rtnData).length;
	        //	console.log(length);
	        	length = Object.keys(rtnData[0].result).length;
	        //	console.log(length);
	        	//alert(JSON.stringify(rtnData));
	        	//setInterval(GetData, updateInterval);
	        },
	        error: function () {
	            setTimeout(GetData, updateInterval);
	        }
	    });
	}
	
	var temp;
	
	function update(_data) {

		var starttime = inittime,count=0;
		while(count < Object.keys(_data[0].result).length) {

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
		    starttime += updateInterval;
			
		}
		
	//	console.log(awaymoneyline);
	
	    now += updateInterval
	
	    
	
	    dataset = [{ label: "AwayMoneyLine", data: awaymoneyline, lines:{show: true,lineWidth:1.2}, color: "#00FF00" },
                   { label: "AwayHandicap:", data: awayhandicap,lines: {show: true,lineWidth: 1.2}, color: "#0044FF",},
                   { label: "HomeMoneyLine", data: homemoneyline, lines:{show: true,lineWidth:1.2}, color: "#00FFFF" },
                   { label: "HomeHandicap:", data: homehandicap,lines: {show: true,lineWidth: 1.2}, color: "#00FF44",},
                   { label: "Upper to Total Point", data: totalpoint_up, lines: {show: true,lineWidth: 1.2}, color: "#FF0000" },
                   { label: "Lower to Total Point", data: totalpoint_low, lines: {show: true,lineWidth: 1.2}, color: "#0000FF" }];
	
	    $.plot($("#flot-placeholder1"), dataset, options2);
	    $.plot($("#flot-placeholder2"), dataset, options);

	/*	$("#flot-placeholder1").bind("plothover", function (event, pos, item) {

				if (item) {
					var timeMilliSec = item.datapoint[0].toFixed(0);
					var tmpdate = new Date(parseInt(timeMilliSec));
					var x = tmpdate.getHours() + ":" + tmpdate.getMinutes() + ":" + tmpdate.getSeconds();
					var y = item.datapoint[1].toFixed(3);
					var z = item.series.data[item.dataIndex][2];
					if(z === undefined || z === null)
					$("#tooltip").html(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y)
						.css({top: item.pageY+5, left: item.pageX+5})
						.fadeIn(200);
					else $("#tooltip").html(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y + " ,\n value =  " + z)
					.css({top: item.pageY+5, left: item.pageX+5})
					.fadeIn(200);
				} else {
					$("#tooltip").hide();
				}
		});
		$("#flot-placeholder2").bind("plothover", function (event, pos, item) {

				if (item) {
					var timeMilliSec = item.datapoint[0].toFixed(0);
					var tmpdate = new Date(parseInt(timeMilliSec));
					
					var x = tmpdate.getHours() + ":" + tmpdate.getMinutes() + ":" + tmpdate.getSeconds();
					var y = item.datapoint[1].toFixed(3);
					var z = item.series.data[item.dataIndex][2];
					if(z === undefined || z === null)
						$("#tooltip").html(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y)
							.css({top: item.pageY+5, left: item.pageX+5})
							.fadeIn(200);
						else $("#tooltip").html(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y + " ,\n value =  " + z)
						.css({top: item.pageY+5, left: item.pageX+5})
						.fadeIn(200);
				} else {
					$("#tooltip").hide();
				}
		});
		$("#flot-placeholder1").bind("plotclick", function (event, pos, item) {
			if (item) {
				var timeMilliSec = item.datapoint[0].toFixed(0);
				var tmpdate = new Date(parseInt(timeMilliSec));
				console.log(item);
				var x = tmpdate.getHours() + ":" + tmpdate.getMinutes() + ":" + tmpdate.getSeconds();
				var y = item.datapoint[1].toFixed(3);
				var z = item.series.data[item.dataIndex][2];
				if(z === undefined || z === null) alert(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y);
				else alert(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y + " ,\n value =  " + z);
				//$("#clickdata").text(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y);
				//plot.highlight(item.series, item.datapoint);
			}
		});
		$("#flot-placeholder2").bind("plotclick", function (event, pos, item) {
			if (item) {
				var timeMilliSec = item.datapoint[0].toFixed(0);
				var tmpdate = new Date(parseInt(timeMilliSec));
				console.log(item);
				var x = tmpdate.getHours() + ":" + tmpdate.getMinutes() + ":" + tmpdate.getSeconds();
				var y = item.datapoint[1].toFixed(3);
				var z = item.series.data[item.dataIndex][2];
				if(z === undefined || z === null) alert(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y);
				else alert(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y + " ,\n value =  " + z);
				//$("#clickdata").text(item.series.label + " ,\n Time =  " + x + " ,\n Odds = " + y);
				//plot.highlight(item.series, item.datapoint);
			}
		});*/
	    setTimeout(GetData, updateInterval);
	}
	
	
	$(document).ready(function () {
		init(); 
		 // 開啟selenium抓資料function
		$("<div id='tooltip'></div>").css({
			position: "absolute",
			display: "none",
			border: "1px solid #fdd",
			padding: "2px",
			"background-color": "#fee",
			opacity: 0.80
		}).appendTo("body");
		 GetData();
	   // setTimeout(GetData, updateInterval);
	   /* dataset2 = [        
	        { label: "AwayMoneyLine", data: awaymoneyline, lines:{lineWidth:1.2}, color: "#00FF00" },
                   { label: "AwayHandicap:", data: awayhandicap,lines: {lineWidth: 1.2}, color: "#0044FF",},
                   { label: "HomeMoneyLine", data: homemoneyline, lines:{lineWidth:1.2}, color: "#00FFFF" },
                   { label: "HomeHandicap:", data: homehandicap,lines: {lineWidth: 1.2}, color: "#00FF44",},
                   { label: "Upper to Total Point", data: totalpoint_up, lines: {lineWidth: 1.2}, color: "#FF0000" },
                   { label: "Lower to Total Point", data: totalpoint_low, lines: {lineWidth: 1.2}, color: "#0000FF" }
	    ];
	
	    $.plot($("#flot-placeholder1"), dataset, options2);
	    $.plot($("#flot-placeholder2"), dataset, options);*/
	    
	});
	
	
	
	</script>

</head>
<body>  
	<div id="flot-placeholder1" style="width:1850px;height:300px;margin:0 auto"></div>
	<div id="flot-placeholder2" style="width:1850px;height:300px;margin:0 auto"></div>
	<div> 
		<jsp:include page="amcharts.jsp" /> 
	</div>
</body>
</html>
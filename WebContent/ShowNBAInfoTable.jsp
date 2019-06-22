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
<title>Show NBA Info Table</title>

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
    		type:"NBA"
    	},
        dataType: "json",
        async: false,
        type: "GET",
        success: function(rtnData){
        	update(rtnData);
        	console.log(rtnData);
        	contents = rtnData[0].result[0].awayTeam;
        	//length = Object.keys(rtnData).length;
        	//console.log(length);
        	//length = Object.keys(rtnData[0].result).length;
        	//console.log(length);
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
		    	console.log(this.id + "unchecked");
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

function GetFormattedDate(date) {
    var todayTime = new Date(date);
    var month = todayTime.getMonth() + 1;
    var day = todayTime.getDate();
    var year = todayTime.getFullYear();
    var hour = todayTime.getHours();
    var minute = todayTime.getMinutes();
    var second = todayTime.getSeconds();
    var result = month + "/" + day + ", ";
    if(hour < 10) result += "0" + hour + ":";
    else result += hour + ":";
    if(minute < 10) result += "0" + minute + ":";
    else result += minute + ":";
    if(second < 10) result += "0" + second;
    else result += second;
    return result;
}

var temp;

function update(_data) {

	//var starttime = inittime,
	var count=0;
	//CreateChart("runlinediv");
	//console.log("_data.length = " + Object.keys(_data).length);
	var index = <%= request.getParameter("id") %>

		//======[Pony]20190512, show charts(Not Comlete yet)========
		awaymoneyline = [], homemoneyline = [], awayhandicap = [], homehandicap = [], totalpoint_up = [], totalpoint_low = [];
		moneyline = [];
		handicap = [];
		total = [];
		
		//===========[Pony]生成Checkbox(想要用來顯示/隱藏每一場對戰的charts)==========
		var textdiv = document.createElement("div");
		textdiv.setAttribute("id",index);
		textdiv.setAttribute("align","center");
		textdiv.setAttribute("style","height: 250px;width: 100%;");
		
			
		var btn = document.createElement("INPUT");   // Create a <button> element
		btn.setAttribute("type", "checkbox");
		btn.setAttribute("checked", "true");
		btn.setAttribute("value", index);
		//btn.setAttribute("id", _data[index].result[0].awayTeam);
		//btn.setAttribute("name", _data[index].result[0].homeTeam);
		btn.id = _data[index].result[0].awayTeam;
		btn.name = _data[index].result[0].homeTeam;
		btn.checked = true;
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
		//==================Process Data======================
		for(j=0;j<Object.keys(_data[index].result).length;j++){
			if(j==0){
			    homemoneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].homeMoneyLineOdds,
			    	second:_data[index].result[j].dataSecond
			    });
			    awaymoneyline.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].awayMoneyLineOdds   	
			    });
			    awayhandicap.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].awayHandicapOdds,
			    	score:_data[index].result[j].awayHandicap,
			    	second:_data[index].result[j].dataSecond
			    });
			    homehandicap.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].homeHandicapOdds,
			    	score:_data[index].result[j].homeHandicap,
			    	second:_data[index].result[j].dataSecond
			    });
			    totalpoint_up.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].bigTotalOdds,
			    	score:_data[index].result[j].total,
			    	second:_data[index].result[j].dataSecond
			    });
			    totalpoint_low.push({
			    	time:_data[index].result[j].dataTime,
			    	value:_data[index].result[j].smallTotalOdds,
			    	second:_data[index].result[j].dataSecond
			    }); 
			}
			else{
				if((_data[index].result[j].awayMoneyLineOdds != _data[index].result[j-1].awayMoneyLineOdds)
						|| (_data[index].result[j].homeMoneyLineOdds != _data[index].result[j-1].homeMoneyLineOdds)){
						var homeoddsdiff = _data[index].result[j].homeMoneyLineOdds - _data[index].result[j-1].homeMoneyLineOdds;
						var awayoddsdiff = _data[index].result[j].awayMoneyLineOdds - _data[index].result[j-1].awayMoneyLineOdds;
						var timediff = _data[index].result[j].dataSecond - _data[index].result[j-1].dataSecond;
						var homeslope = homeoddsdiff / timediff;
						var awayslope = awayoddsdiff / timediff;
						//console.log(homeslope);
						//console.log(awayslope);

					    homemoneyline.push({
					    	time:_data[index].result[j].dataTime,
					    	value:_data[index].result[j].homeMoneyLineOdds,
					    	second:_data[index].result[j].dataSecond
					    });
					    awaymoneyline.push({
					    	time:_data[index].result[j].dataTime,
					    	value:_data[index].result[j].awayMoneyLineOdds,
					    	second:_data[index].result[j].dataSecond
					    });
					}			    
				    	
					if(_data[index].result[j].awayHandicapOdds != _data[index].result[j-1].awayHandicapOdds
					  ||_data[index].result[j].awayHandicap != _data[index].result[j-1].awayHandicap 
					  ||_data[index].result[j].homeHandicapOdds != _data[index].result[j-1].homeHandicapOdds
					  ||_data[index].result[j].homeHandicap != _data[index].result[j-1].homeHandicap){
						var homeoddsdiff = _data[index].result[j].homeHandicapOdds - _data[index].result[j-1].homeHandicapOdds;
						var awayoddsdiff = _data[index].result[j].awayHandicapOdds - _data[index].result[j-1].awayHandicapOdds;
						var timediff = _data[index].result[j].dataSecond - _data[index].result[j-1].dataSecond;
						var homeslope = homeoddsdiff / timediff;
						var awayslope = awayoddsdiff / timediff;
						//console.log(homeslope);
						//console.log(awayslope);
					    awayhandicap.push({
					    	time:_data[index].result[j].dataTime,
					    	value:_data[index].result[j].awayHandicapOdds,
					    	score:_data[index].result[j].awayHandicap,
					    	second:_data[index].result[j].dataSecond
					    });
					    homehandicap.push({
					    	time:_data[index].result[j].dataTime,
					    	value:_data[index].result[j].homeHandicapOdds,
					    	score:_data[index].result[j].homeHandicap,
					    	second:_data[index].result[j].dataSecond
					    });
					}
				    
					if(_data[index].result[j].bigTotalOdds != _data[index].result[j-1].bigTotalOdds
					   ||_data[index].result[j].smallTotalOdds != _data[index].result[j-1].smallTotalOdds
					   ||_data[index].result[j].total != _data[index].result[j-1].total){
						var upoddsdiff = _data[index].result[j].bigTotalOdds - _data[index].result[j-1].bigTotalOdds;
						var lowoddsdiff = _data[index].result[j].smallTotalOdds - _data[index].result[j-1].smallTotalOdds;
						var timediff = _data[index].result[j].dataSecond - _data[index].result[j-1].dataSecond;
						var upslope = upoddsdiff / timediff;
						var lowslope = lowoddsdiff / timediff;
					//	console.log(upslope);
						//console.log(lowslope);
					    totalpoint_up.push({
					    	time:_data[index].result[j].dataTime,
					    	value:_data[index].result[j].bigTotalOdds,
					    	score:_data[index].result[j].total,
					    	second:_data[index].result[j].dataSecond
					    });
					    totalpoint_low.push({
					    	time:_data[index].result[j].dataTime,
					    	value:_data[index].result[j].smallTotalOdds,
					    	second:_data[index].result[j].dataSecond
					    }); 
					}
			}
			
		}
		//==================Process Data======================
		var runlinechartData = [],moneylinechartdata = [],totallinechartdata=[];
		//===========[Pony]Create Table div==========
		var moneylinediv = document.createElement("div");
		moneylinediv.id = index+"_moneyline_div";
		//==============[Pony]Create Table div=================
		//===========[Pony]Create Table==========
		var moneyline_table = document.createElement('TABLE');
		moneyline_table.border = '1';	
		var moneyline_tableBody = document.createElement('TBODY');
		moneyline_table.appendChild(moneyline_tableBody);		
		//===========[Pony]Create Table==========
		
		console.log("result.length = " + Object.keys(_data[index].result).length);
		var moneyline_tr = document.createElement('TR');
	    
	    var moneyline_td_starttime = document.createElement('TD');
	    moneyline_td_starttime.width = '300';
	    moneyline_td_starttime.align = "center";
	    moneyline_td_starttime.style = "font-size:24px;";
	    moneyline_td_starttime.appendChild(document.createTextNode("Time"));
	    moneyline_tr.appendChild(moneyline_td_starttime);

	 /*   var moneyline_td_endtime = document.createElement('TD');
	    moneyline_td_endtime.width = '300';
	    moneyline_td_endtime.align = "center";
	    moneyline_td_endtime.style = "font-size:24px;";
	    moneyline_td_endtime.appendChild(document.createTextNode("變化發生時間"));
	    moneyline_tr.appendChild(moneyline_td_endtime);*/
	    
	    var td_away_moneyline = document.createElement('TD');
	    td_away_moneyline.width = '300';
	    td_away_moneyline.align = "center";
	    td_away_moneyline.style = "font-size:24px;";
	    td_away_moneyline.appendChild(document.createTextNode("away moneyline Odds"));
	    moneyline_tr.appendChild(td_away_moneyline);
	    
	    var td_home_moneyline = document.createElement('TD');
	    td_home_moneyline.width = '300';
	    td_home_moneyline.align = "center";
	    td_home_moneyline.style = "font-size:24px;";
	    td_home_moneyline.appendChild(document.createTextNode("home moneyline Odds"));
	    moneyline_tr.appendChild(td_home_moneyline);

	    var td_away_slope_moneyline = document.createElement('TD'); 
	    td_away_slope_moneyline.width = '300';
	    td_away_slope_moneyline.align = "center";
	    td_away_slope_moneyline.style = "font-size:24px;";
	    td_away_slope_moneyline.appendChild(document.createTextNode("away moneyline slope"));
	    moneyline_tr.appendChild(td_away_slope_moneyline);
	    
	    var td_home_slope_moneyline = document.createElement('TD'); 
	    td_home_slope_moneyline.width = '300';
	    td_home_slope_moneyline.align = "center";
	    td_home_slope_moneyline.style = "font-size:24px;";
	    td_home_slope_moneyline.appendChild(document.createTextNode("home moneyline slope"));
	    moneyline_tr.appendChild(td_home_slope_moneyline);
	    
	    moneyline_tableBody.appendChild(moneyline_tr);
	    
	    //==============print out moneyline data================
	   // if(homemoneyline.length > 1){
		    for(a=0;a<homemoneyline.length;a++){
		    	var moneyline_data_tr = document.createElement('TR');
			    
			    var moneyline_data_td_starttime = document.createElement('TD');
			    moneyline_data_td_starttime.width = '300';
			    moneyline_data_td_starttime.align = "center";
			    moneyline_data_td_starttime.style = "font-size:24px;";
			    if(a==0)
			    	moneyline_data_td_starttime.appendChild(document.createTextNode(GetFormattedDate(homemoneyline[a].time)));
			    else
			    	moneyline_data_td_starttime.appendChild(document.createTextNode(GetFormattedDate(homemoneyline[a-1].time)));
			    moneyline_data_tr.appendChild(moneyline_data_td_starttime);

			    /*     var moneyline_data_td_endtime = document.createElement('TD');
			    moneyline_data_td_endtime.width = '300';
			    moneyline_data_td_endtime.align = "center";
			    moneyline_data_td_endtime.style = "font-size:24px;";
			    moneyline_data_td_endtime.appendChild(document.createTextNode(GetFormattedDate(homemoneyline[a].time)));
			    moneyline_data_tr.appendChild(moneyline_data_td_endtime);*/
			    
			    var td_away_moneyline_data = document.createElement('TD');
			    td_away_moneyline_data.width = '300';
			    td_away_moneyline_data.align = "center";
			    td_away_moneyline_data.style = "font-size:24px;";
			    td_away_moneyline_data.appendChild(document.createTextNode(awaymoneyline[a].value));
			    moneyline_data_tr.appendChild(td_away_moneyline_data);
			    
			    var td_home_moneyline_data = document.createElement('TD');
			    td_home_moneyline_data.width = '300';
			    td_home_moneyline_data.align = "center";
			    td_home_moneyline_data.style = "font-size:24px;";
			    td_home_moneyline_data.appendChild(document.createTextNode(homemoneyline[a].value));
			    moneyline_data_tr.appendChild(td_home_moneyline_data);
			    
			    var away_slope;
			    var home_slope;
			    if(a==0){
			    	away_slope = 0;
			    	home_slope = 0;
			    }
			    else{
				    var time_diff = homemoneyline[a].second - homemoneyline[a-1].second;
				    var away_odds_diff = awaymoneyline[a].value - awaymoneyline[a-1].value;
				    var home_odds_diff = homemoneyline[a].value - homemoneyline[a-1].value;
				    var away_slope = away_odds_diff / time_diff * 100000;
				    var home_slope = home_odds_diff / time_diff * 100000;
			    }





			    var td_away_slope_moneyline_data = document.createElement('TD'); 
			    td_away_slope_moneyline_data.width = '300';
			    td_away_slope_moneyline_data.align = "center";
			    td_away_slope_moneyline_data.style = "font-size:24px;";
			    td_away_slope_moneyline_data.appendChild(document.createTextNode(away_slope.toFixed(3)));
			    moneyline_data_tr.appendChild(td_away_slope_moneyline_data);
			    
			    var td_home_slope_moneyline_data = document.createElement('TD'); 
			    td_home_slope_moneyline_data.width = '300';
			    td_home_slope_moneyline_data.align = "center";
			    td_home_slope_moneyline_data.style = "font-size:24px;";
			    td_home_slope_moneyline_data.appendChild(document.createTextNode(home_slope.toFixed(3)));
			    moneyline_data_tr.appendChild(td_home_slope_moneyline_data);
			    
			    moneyline_tableBody.appendChild(moneyline_data_tr);
		    }
	   // }
	    //==============print out moneyline data================

	    
	    
	    moneylinediv.appendChild(moneyline_table);
	    document.body.appendChild(moneylinediv);
	    
	    document.body.appendChild(document.createElement("br"));
	    document.body.appendChild(document.createElement("br"));
	    
	    
	    var runlinediv = document.createElement("div");
	    runlinediv.id = index+"_runline_div";
		//==============[Pony]Create Table div=================
		//===========[Pony]Create Table==========
		var runline_table = document.createElement('TABLE');
		runline_table.border = '1';	
		var runline_tableBody = document.createElement('TBODY');
		runline_table.appendChild(runline_tableBody);		
		//===========[Pony]Create Table==========

		var runline_tr = document.createElement('TR');
		
	    var runline_td_starttime = document.createElement('TD');
	    runline_td_starttime.width = '300';
	    runline_td_starttime.align = "center";
	    runline_td_starttime.style = "font-size:24px;";
	    runline_td_starttime.appendChild(document.createTextNode("Time"));
	    runline_tr.appendChild(runline_td_starttime);

	    /*  var runline_td_endtime = document.createElement('TD');
	    runline_td_endtime.width = '300';
	    runline_td_endtime.align = "center";
	    runline_td_endtime.style = "font-size:24px;";
	    runline_td_endtime.appendChild(document.createTextNode("變化發生時間"));
	    runline_tr.appendChild(runline_td_endtime);*/
	    
	    var td_away_runline = document.createElement('TD');
	    td_away_runline.width = '300';
	    td_away_runline.align = "center";
	    td_away_runline.style = "font-size:24px;";
	    td_away_runline.appendChild(document.createTextNode("away Runline Odds"));
	    runline_tr.appendChild(td_away_runline);
	    
	    var td_away_runline_scores = document.createElement('TD');
	    td_away_runline_scores.width = '300';
	    td_away_runline_scores.align = "center";
	    td_away_runline_scores.style = "font-size:24px;";
	    td_away_runline_scores.appendChild(document.createTextNode("away Runline scores"));
	    runline_tr.appendChild(td_away_runline_scores);
	    
	    var td_home_runline = document.createElement('TD');
	    td_home_runline.width = '300';
	    td_home_runline.align = "center";
	    td_home_runline.style = "font-size:24px;";
	    td_home_runline.appendChild(document.createTextNode("home Runline Odds"));
	    runline_tr.appendChild(td_home_runline);
	    
	    var td_home_runline_scores = document.createElement('TD');
	    td_home_runline_scores.width = '300';
	    td_home_runline_scores.align = "center";
	    td_home_runline_scores.style = "font-size:24px;";
	    td_home_runline_scores.appendChild(document.createTextNode("home Runline Scores"));
	    runline_tr.appendChild(td_home_runline_scores);

	    var td_away_slope_runline = document.createElement('TD'); 
	    td_away_slope_runline.width = '300';
	    td_away_slope_runline.align = "center";
	    td_away_slope_runline.style = "font-size:24px;";
	    td_away_slope_runline.appendChild(document.createTextNode("away Runline slope"));
	    runline_tr.appendChild(td_away_slope_runline);
	    
	    var td_home_slope_runline = document.createElement('TD'); 
	    td_home_slope_runline.width = '300';
	    td_home_slope_runline.align = "center";
	    td_home_slope_runline.style = "font-size:24px;";
	    td_home_slope_runline.appendChild(document.createTextNode("home Runline slope"));
	    runline_tr.appendChild(td_home_slope_runline);
	    
	    runline_tableBody.appendChild(runline_tr);
	    
    	
	    //==============print out runline data================
	    //if(homehandicap.length > 1){
		    for(a=0;a<homehandicap.length;a++){
				var runline_data_tr = document.createElement('TR');
			    
			    var runline_data_td_starttime = document.createElement('TD');
			    runline_data_td_starttime.width = '300';
			    runline_data_td_starttime.align = "center";
			    runline_data_td_starttime.style = "font-size:24px;";
			    if(a==0)
			    	runline_data_td_starttime.appendChild(document.createTextNode(GetFormattedDate(homehandicap[a].time)));
			    else
			    	runline_data_td_starttime.appendChild(document.createTextNode(GetFormattedDate(homehandicap[a-1].time)));
			    runline_data_tr.appendChild(runline_data_td_starttime);

			    /*    var runline_data_td_endtime = document.createElement('TD');
			    runline_data_td_endtime.width = '300';
			    runline_data_td_endtime.align = "center";
			    runline_data_td_endtime.style = "font-size:24px;";
			    runline_data_td_endtime.appendChild(document.createTextNode(GetFormattedDate(homehandicap[a].time)));
			    runline_data_tr.appendChild(runline_data_td_endtime);*/
			    
			    var td_away_runline_data = document.createElement('TD');
			    td_away_runline_data.width = '300';
			    td_away_runline_data.align = "center";
			    td_away_runline_data.style = "font-size:24px;";
			    td_away_runline_data.appendChild(document.createTextNode(awayhandicap[a].value));
			    runline_data_tr.appendChild(td_away_runline_data);
			    
			    var td_away_runline_data_scores = document.createElement('TD');
			    td_away_runline_data_scores.width = '300';
			    td_away_runline_data_scores.align = "center";
			    td_away_runline_data_scores.style = "font-size:24px;";
			    td_away_runline_data_scores.appendChild(document.createTextNode(awayhandicap[a].score));
			    runline_data_tr.appendChild(td_away_runline_data_scores);
			    
			    var td_home_runline_data = document.createElement('TD');
			    td_home_runline_data.width = '300';
			    td_home_runline_data.align = "center";
			    td_home_runline_data.style = "font-size:24px;";
			    td_home_runline_data.appendChild(document.createTextNode(homehandicap[a].value));
			    runline_data_tr.appendChild(td_home_runline_data);
			    
			    var td_home_runline_data_scores = document.createElement('TD');
			    td_home_runline_data_scores.width = '300';
			    td_home_runline_data_scores.align = "center";
			    td_home_runline_data_scores.style = "font-size:24px;";
			    td_home_runline_data_scores.appendChild(document.createTextNode(homehandicap[a].score));
			    runline_data_tr.appendChild(td_home_runline_data_scores);
			    var away_slope;
			    var home_slope;
			    if(a==0){
			    	away_slope = 0;
			    	home_slope = 0;
			    }
			    else{
				    var time_diff = homehandicap[a].second - homehandicap[a-1].second;
				    var away_odds_diff = awayhandicap[a].value - awayhandicap[a-1].value;
				    var home_odds_diff = homehandicap[a].value - homehandicap[a-1].value;
				    var away_slope = away_odds_diff / time_diff * 100000;
				    var home_slope = home_odds_diff / time_diff * 100000;
			    }

			    


			    var td_away_slope_runline_data = document.createElement('TD'); 
			    td_away_slope_runline_data.width = '300';
			    td_away_slope_runline_data.align = "center";
			    td_away_slope_runline_data.style = "font-size:24px;";
			    td_away_slope_runline_data.appendChild(document.createTextNode(away_slope.toFixed(3)));
			    runline_data_tr.appendChild(td_away_slope_runline_data);
			    
			    var td_home_slope_runline_data = document.createElement('TD'); 
			    td_home_slope_runline_data.width = '300';
			    td_home_slope_runline_data.align = "center";
			    td_home_slope_runline_data.style = "font-size:24px;";
			    td_home_slope_runline_data.appendChild(document.createTextNode(home_slope.toFixed(3)));
			    runline_data_tr.appendChild(td_home_slope_runline_data);
			    
			    runline_tableBody.appendChild(runline_data_tr);
		    }
	   // }
	    //==============print out runline data================
	        
	    runlinediv.appendChild(runline_table);
	    document.body.appendChild(runlinediv);
	    
	    document.body.appendChild(document.createElement("br"));
	    document.body.appendChild(document.createElement("br"));

	    
	    var totaldiv = document.createElement("div");
	    totaldiv.id = index+"_total_div";
		//==============[Pony]Create Table div=================
		//===========[Pony]Create Table==========
		var total_table = document.createElement('TABLE');
		total_table.border = '1';	
		var total_tableBody = document.createElement('TBODY');
		total_table.appendChild(total_tableBody);		
		//===========[Pony]Create Table==========

		var total_tr = document.createElement('TR');
		
		var total_td_starttime = document.createElement('TD');
		total_td_starttime.width = '300';
		total_td_starttime.align = "center";
		total_td_starttime.style = "font-size:24px;";
		total_td_starttime.appendChild(document.createTextNode("Time"));
		total_tr.appendChild(total_td_starttime);

		/* var total_td_endtime = document.createElement('TD');
	    total_td_endtime.width = '300';
	    total_td_endtime.align = "center";
	    total_td_endtime.style = "font-size:24px;";
	    total_td_endtime.appendChild(document.createTextNode("變化發生時間"));
	    total_tr.appendChild(total_td_endtime);*/
		
		
	    
	    var td_total_up = document.createElement('TD');
	    td_total_up.width = '300';
	    td_total_up.align = "center";
	    td_total_up.style = "font-size:24px;";
	    td_total_up.appendChild(document.createTextNode("Total Up Odds"));
	    total_tr.appendChild(td_total_up);
	    
	    
	    var td_total_low = document.createElement('TD');
	    td_total_low.width = '300';
	    td_total_low.align = "center";
	    td_total_low.style = "font-size:24px;";
	    td_total_low.appendChild(document.createTextNode("Total Low Odds"));
	    total_tr.appendChild(td_total_low);
	    
	    var td_total_scores = document.createElement('TD');
	    td_total_scores.width = '300';
	    td_total_scores.align = "center";
	    td_total_scores.style = "font-size:24px;";
	    td_total_scores.appendChild(document.createTextNode("Total Scores"));
	    total_tr.appendChild(td_total_scores);

	    var td_slope_total_up = document.createElement('TD'); 
	    td_slope_total_up.width = '300';
	    td_slope_total_up.align = "center";
	    td_slope_total_up.style = "font-size:24px;";
	    td_slope_total_up.appendChild(document.createTextNode("Total Up slope"));
	    total_tr.appendChild(td_slope_total_up);
	    
	    var td_slope_total_low = document.createElement('TD'); 
	    td_slope_total_low.width = '300';
	    td_slope_total_low.align = "center";
	    td_slope_total_low.style = "font-size:24px;"
	    td_slope_total_low.appendChild(document.createTextNode("Total Low slope"));
	    total_tr.appendChild(td_slope_total_low);
	    
	    total_tableBody.appendChild(total_tr);
	    
	  //==============print out total score data================
	    //if(totalpoint_up.length > 1){
		    for(a=0;a<totalpoint_up.length;a++){
				var total_data_tr = document.createElement('TR');
			    
			    var total_data_td_starttime = document.createElement('TD');
			    total_data_td_starttime.width = '300';
			    total_data_td_starttime.align = "center";
			    total_data_td_starttime.style = "font-size:24px;";
			    if(a==0)
			   		total_data_td_starttime.appendChild(document.createTextNode(GetFormattedDate(totalpoint_up[a].time)));
			    else
			    	total_data_td_starttime.appendChild(document.createTextNode(GetFormattedDate(totalpoint_up[a-1].time)));
			    total_data_tr.appendChild(total_data_td_starttime);

			    /*    var total_data_td_endtime = document.createElement('TD');
			    total_data_td_endtime.width = '300';
			    total_data_td_endtime.align = "center";
			    total_data_td_endtime.style = "font-size:24px;";
			    total_data_td_endtime.appendChild(document.createTextNode(GetFormattedDate(totalpoint_up[a].time)));
			    total_data_tr.appendChild(total_data_td_endtime); */
			    
			    var td_total_up_data = document.createElement('TD');
			    td_total_up_data.width = '300';
			    td_total_up_data.align = "center";
			    td_total_up_data.style = "font-size:24px;";
			    td_total_up_data.appendChild(document.createTextNode(totalpoint_up[a].value));
			    total_data_tr.appendChild(td_total_up_data);
			    
			    var td_total_low_data = document.createElement('TD');
			    td_total_low_data.width = '300';
			    td_total_low_data.align = "center";
			    td_total_low_data.style = "font-size:24px;";
			    td_total_low_data.appendChild(document.createTextNode(totalpoint_low[a].value));
			    total_data_tr.appendChild(td_total_low_data);
			    
			    var td_total_data_scores = document.createElement('TD');
			    td_total_data_scores.width = '300';
			    td_total_data_scores.align = "center";
			    td_total_data_scores.style = "font-size:24px;";
			    td_total_data_scores.appendChild(document.createTextNode(totalpoint_up[a].score));
			    total_data_tr.appendChild(td_total_data_scores);
			    
			    
			    if(a==0){
			    	up_slope = 0;
			    	low_slope = 0;
			    }
			    else{
			    	var time_diff = totalpoint_up[a].second - totalpoint_up[a-1].second;
				    var up_odds_diff = totalpoint_up[a].value - totalpoint_up[a-1].value;
				    var low_odds_diff = totalpoint_low[a].value - totalpoint_low[a-1].value;
				    up_slope = up_odds_diff / time_diff * 100000;
				    low_slope = low_odds_diff / time_diff * 100000;
			    }
			    


			    var td_total_up_slope_data = document.createElement('TD'); 
			    td_total_up_slope_data.width = '300';
			    td_total_up_slope_data.align = "center";
			    td_total_up_slope_data.style = "font-size:24px;";
			    td_total_up_slope_data.appendChild(document.createTextNode(up_slope.toFixed(3)));
			    total_data_tr.appendChild(td_total_up_slope_data);
			    
			    var td_total_low_slope_data = document.createElement('TD'); 
			    td_total_low_slope_data.width = '300';
			    td_total_low_slope_data.align = "center";
			    td_total_low_slope_data.style = "font-size:24px;";
			    td_total_low_slope_data.appendChild(document.createTextNode(low_slope.toFixed(3)));
			    total_data_tr.appendChild(td_total_low_slope_data);
			    
			    total_tableBody.appendChild(total_data_tr);
		    }
	   // }
		  
	    
	  //==============print out total score data================  
	    totaldiv.appendChild(total_table);
	    document.body.appendChild(totaldiv);
	    
	    document.body.appendChild(document.createElement("br"));
	    document.body.appendChild(document.createElement("br"));


		//============[Pony]Push資料到Array裡面讓Charts套用================
			
			
		//======[Pony]20190512, show charts(Not Comlete yet)========
		//CreateMulChart(_data[index].result[0].awayTeam+"runline",moneyline);
		//CreateMulChart(_data[index].result[0].awayTeam+"moneyline",handicap);
		//CreateMulChart(_data[index].result[0].awayTeam+"total",total);
		
		//======[Pony]將資料以及div name輸入到生成chart的 function========
		var br =  document.createElement("br");
		document.body.appendChild(br);
		//======[Pony]將資料以及div name輸入到生成chart的 function========
	

    now += updateInterval;
   // setTimeout(GetData, updateInterval);
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
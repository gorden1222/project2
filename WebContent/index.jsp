<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- Resources -->
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<title>Pinnacle Data Index</title>

<!-- Chart code -->
<script>





function init() {
	$.ajaxSetup({ cache: false });
	
	$.ajax({
    	url: "/project2/LoadDataServlet.do",
    	data:{
    		doAction:"startGetData"
    	},
    	async: false,
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

function stop() {
	$.ajaxSetup({ cache: false });
	
	$.ajax({
    	url: "/project2/LoadDataServlet.do",
    	data:{
    		doAction:"stopGetData"
    	},
    	async: false,
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


var temp;

$(document).ready(function () {
	
	 // 開啟selenium抓資料function
	//setTimeout(GetData, updateInterval);
	//GetData();   
	$('#start').click(function(){
	    console.log("NBA logo onclick");
	    if(confirm("Start Get Data from pinnacle?"))
	    init();
	});
	
	$('#stop').click(function(){
	    console.log("NBA logo onclick");
	    if(confirm("Stop Getting data?"))
	    stop();
	});
	
	$('#nba').click(function(){
	    console.log("NBA logo onclick");
	    window.open('http://localhost:8080/project2/ShowNBAGameIndex.jsp', '_blank');
	});

	$('#mlb').click(function(){
	    console.log("MLB logo onclick");
	    window.open('http://localhost:8080/project2/ShowMLBGameIndex.jsp', '_blank');
	});

	$('#npb').click(function(){
	    console.log("NPB logo onclick");
	    window.open('http://localhost:8080/project2/ShowNPBGameIndex.jsp', '_blank');
	});
	
	$('#kbo').click(function(){
	    console.log("KBO logo onclick");
	    window.open('http://localhost:8080/project2/ShowKBOGameIndex.jsp', '_blank');
	});
	
	$('#history').click(function(){
	    console.log("KBO logo onclick");
	    window.open('http://localhost:8080/project2/ShowHistoryGame.jsp', '_blank');
	});
	
/*	$('#nba_table').click(function(){
	    console.log("NBA_TABLE logo onclick");
	    window.open('http://localhost:8080/project2/ShowNBAInfoTable.jsp', '_blank');
	});

	$('#mlb_table').click(function(){
	    console.log("MLB_TABLE logo onclick");
	    window.open('http://localhost:8080/project2/ShowMLBInfoTable.jsp', '_blank');
	});

	$('#npb_table').click(function(){
	    console.log("NPB_TABLE logo onclick");
	    window.open('http://localhost:8080/project2/ShowNPBInfoTable.jsp', '_blank');
	});
	
	$('#kbo_table').click(function(){
	    console.log("KBO_TABLE logo onclick");
	    window.open('http://localhost:8080/project2/ShowKBOInfoTable.jsp', '_blank');
	});*/
});




</script>


</head>
<body>
<!-- HTML -->
<center><img id="start" src="start.png" width="30%"/> <t> <img id="stop" src="stop.jpg" width="30%"/> <br><br></center>
<br><br><br><br>
<center><img id="nba" src="nba.png" width="30%"/> <br><br></center>
<center><img id="mlb" src="mlb.jpg" width="30%"/> <br></center>
<center><img id="npb" src="npb.png" width="30%"/> <br></center>
<center><img id="kbo" src="kbo.png" width="30%"/> <br><br><br><br></center>
<center><img id="history" src="history.jpg" width="30%"/> </center>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<title>Show NBA Game Index</title>

<script>
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
        	setgamelink(rtnData);
        	console.log(rtnData);
        	contents = rtnData[0].result[0].awayTeam;

        },
        error: function () {
            //setTimeout(GetData, updateInterval);
            console.log("error");
        }
    });
}

function setgamelink(_data) {
	
	for(i=0;i<Object.keys(_data).length;i++){
		
		var chartdiv = document.createElement("div");
		chartdiv.setAttribute("id",i);
		chartdiv.setAttribute("align","center");
		chartdiv.setAttribute("style","height: 100px;width: 100%;");
		
		var chartHref = document.createElement("a");
		chartHref.setAttribute("name",_data[i].result[0].awayTeam + "V.S" + _data[i].result[0].homeTeam );
		chartHref.setAttribute("id",i+1);
		chartHref.setAttribute("style","font-size:36px;");
		chartHref.setAttribute("align", "center");
		chartHref.setAttribute("href", "ShowNBAGameInfo.jsp" + "?id=" + i);
		chartHref.appendChild(document.createTextNode(_data[i].result[0].awayTeam + "V.S" + _data[i].result[0].homeTeam+ "----Chart"));

		chartdiv.appendChild(chartHref);
		document.body.appendChild(chartdiv); 
		
		
		
		
		var tablediv = document.createElement("div");
		tablediv.setAttribute("id",i);
		tablediv.setAttribute("align","center");
		tablediv.setAttribute("style","height: 200px;width: 100%;");
		
		var tableHref = document.createElement("a");
		tableHref.setAttribute("name",_data[i].result[0].awayTeam + "V.S" + _data[i].result[0].homeTeam);
		tableHref.setAttribute("id",i+1);
		tableHref.setAttribute("style","font-size:36px;");
		tableHref.setAttribute("align", "center");
		tableHref.setAttribute("href", "ShowNBAInfoTable.jsp" + "?id=" + i);
		tableHref.appendChild(document.createTextNode(_data[i].result[0].awayTeam + "V.S" + _data[i].result[0].homeTeam+ "----Table"));

		tablediv.appendChild(tableHref);
		document.body.appendChild(tablediv); 
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

</body>
</html>
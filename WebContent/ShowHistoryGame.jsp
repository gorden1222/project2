<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<title>History Record</title>
</head>
<body>
	<center>
	<div id="ctrls"></div>
	
	<br><br><br><br><br>
	<table id="selectTable" border="0">
	 <tr height="100px"><td align="center" width="150px" style="font-size:27px">Sport: </td>
	 <td><select id="sport" name="sport" style="font-size:27px">
		 <option value="1"> NBA </option> 
		 <option value="2"> MLB </option> 
	 	 <option value="3"> NPB </option> 
		 <option value="4"> KBO </option> </select></td>
	 </tr>
	 <tr height="100px"><td align="center" width="150px" style="font-size:27px">Year : </td>
	 <td><select id="year" name="year" style="font-size:27px"></select></td>
	 </tr>
	 <tr height="100px"><td align="center" width="150px" style="font-size:27px">Month : </td>
	 <td><select id="month" name="month" style="font-size:27px"></select></td>
	 </tr>
	 <tr height="100px"><td align="center" width="150px" style="font-size:27px">Date : </td>
	 <td><select id="day" name="day" style="font-size:27px"></select></td>
	 </tr>
	 <tr height="100px"><td align="center" width="150px" style="font-size:27px">Show : </td>
	 <td><select id="form" name="form" style="font-size:27px">
	 	<option value="1"> Charts </option> 
	 	<option value="2"> Table </option> </select></td>
	 </tr>
	</table>
	 <img id="go" src="go.jpg" alt="">
	</center>
<script>

$(document).ready(function () {
	var href = 'http://localhost:8080/project2/ShowHistoryIndex.jsp?sport=';
	var select_sport = document.getElementById('sport');
	var select_year = document.getElementById('year');
	var select_month = document.getElementById('month');
	var select_day = document.getElementById('day');
	var select_form = document.getElementById('form');
	for(i=0;i<31;i++){
		if(i < 12){
			var new_month_opt = new Option(i+1,i+1);
			select_month.options.add(new_month_opt);
			var new_year_opt = new Option(i+2019,i+2019);
			select_year.options.add(new_year_opt);
		}
		var new_day_opt = new Option(i+1,i+1);
		select_day.options.add(new_day_opt);
	}
  
	$('#go').click(function(){
	    console.log("go onclick");
	    console.log("select_sport = " + select_sport.value);
	    console.log("select_year = " + select_year.value);
	    console.log("select_month = " + select_month.value);
	    console.log("select_day = " + select_day.value);
	    console.log("href = " + href+select_sport.value+'&year='+select_year.value+'&month='+select_month.value+'&day='+select_day.value);
	    window.open(href+select_sport.value+'&year='+select_year.value+'&month='+select_month.value+'&day='+select_day.value, '_blank');
	});


});


</script>
</body>
</html>
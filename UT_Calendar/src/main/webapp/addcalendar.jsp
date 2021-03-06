<!DOCTYPE html>
<html>

<%@ page import ="java.util.List" %>
<%@ page import ="java.util.ArrayList" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="utcalendar.User" %>
<%@ page import="utcalendar.Schedule" %>
<%@ page import ="java.util.List" %>

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Add Calendar</title>

<style>
{
box-sizing
:
 
border-box
;


}
#myInput {
	background-image: url('/css/searchicon.png');
	background-position: 10px 10px;
	background-repeat: no-repeat;
	width: 100%;
	font-size: 16px;
	padding: 12px 20px 12px 40px;
	border: 1px solid #ddd;
	margin-bottom: 12px;
}

#myTable {
	border-collapse: collapse;
	width: 100%;
	border: 1px solid #ddd;
	font-size: 18px;
	display:none;
}

#myTable th, #myTable td {
	text-align: left;
	padding: 12px;
}

#myTable tr {
	border-bottom: 1px solid #ddd;
}

#myTable tr.header, #myTable tr:hover {
	background-color: #f1f1f1;
}
</style>
<link rel="stylesheet" type="text/css"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css">
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>

</head>
<%
	ObjectifyService.register(User.class);
	ObjectifyService.register(Schedule.class);
	List<User> users = ObjectifyService.ofy().load().type(User.class).list();
	Long id = Long.parseLong(request.getParameter("id"));
	User u = ObjectifyService.ofy().load().type(User.class).filter("id", id).first().get();
	String idString = Long.toString(id);
	pageContext.setAttribute("name", u.getName());
	pageContext.setAttribute("idString", idString);
%>
<body>

	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="#">UTCalendar</a>
			</div>
			<ul class="nav navbar-nav navbar-center">
				<li style="text-align:center;text-indent:150px">
				<a href="#">Hello, ${name}!</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li>
					<form action="login.jsp">
						<button style ="color: #ffffff;text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
						background-color: #006dcc;*background-color: #0044cc;background-image: -moz-linear-gradient(top, #0088cc, #0044cc);
						background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#0088cc), to(#0044cc));background-image: -webkit-linear-gradient(top, #0088cc, #0044cc);
						background-image: -o-linear-gradient(top, #0088cc, #0044cc);background-image: linear-gradient(to bottom, #0088cc, #0044cc);
						background-repeat: repeat-x;border-color: #0044cc #0044cc #002a80;border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
						filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff0088cc', endColorstr='#ff0044cc', GradientType=0);
						filter: progid:DXImageTransform.Microsoft.gradient(enabled=false)"class="btn btn-default navbar-btn">Logout
						</button>
					</form>
				</li>
			</ul>
		</div>
	</nav>
	
	<%
	//Table consists of Schedules from datastore
	List<Schedule> schedules = ObjectifyService.ofy()
		.load()
		.type(Schedule.class)
		.list();
	%>

	<div class="container">
		<h1>Add/Delete Schedules</h1>
		<input type="text" id="myInput" onkeyup="myFunction()"
			placeholder="Search for schedules.." title="Type in a name">

		<table id="myTable">
			<tr class="header">
				<th style="width: 60%;">Schedule</th>
				<th style="width: 30%;">Author</th>
				<th style="width: 10%;"></th>
			</tr>
			<%
			for(int i=0; i<schedules.size();i++){
				pageContext.setAttribute("title",schedules.get(i).getTitle());
				String name = ObjectifyService.ofy().load().type(User.class).filter("id", schedules.get(i).getAuthor()).first().get().getName();
				pageContext.setAttribute("author", name);
				String title = schedules.get(i).getTitle();
				%>
				<tr>
				<td>${title}</td> 
				<td>${author}</td>
				<td><a href="/addschedule?id=${idString}&schedules=${title}">Add</a> </td>
			</tr>
			
			<%
			}
			%>
		</table>

		<div id="mySchedule">
		</div>
		
		<script>
			function myFunction() {
				
				var input, filter, table, tr, td, i;
				input = document.getElementById("myInput");
				filter = input.value.toUpperCase();
				table = document.getElementById("myTable");
				tr = table.getElementsByTagName("tr");
				for (i = 0; i < tr.length; i++) {
					td = tr[i].getElementsByTagName("td")[0];
					if (td) {
						if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
							tr[i].style.display = "";
						} else {
							tr[i].style.display = "none";
						}
					}
				}
				if(input.value=="" || input.value=="Search for schedules to add"){
					$("#myTable").hide();
				}
				else{ 
					$("#myTable").show();
				}
				
			}
			//NEED TO IMPLEMENT THIS
			function addSchedule(scheduleID, scheduleName){
				content=$("#mySchedule").html()+"<br>"+scheduleName+selected+"</br>";
				//$("#mySchedule").html(content);
				//send request to server, add ID
				/*$.ajax({
					  url: "doAddSchedule.jsp?id="+scheduleID,
					}).done(function( data ) {
						  content=$("#mySchedule").html()+"<br>"+scheduleName;
							$("#mySchedule").html(content);
					  }); */
			}
		</script>
		<%
			ArrayList<String> mySchedules = u.schedules;
			for (String s : mySchedules) {
				pageContext.setAttribute("s", s); %>
				<p>${s}<a href="/deleteschedule?id=${idString}&schedules=${s}" style="float: right;">Delete</a></p>

		<% 		
			}
		%>
		
		<form class="col=md-12 center-block" action="newschedule.jsp">
  			<input type="hidden" name="id" id="id" value="<%=idString%>" />
			<div class="col-sm-11" style="padding-bottom: 5px; padding-top: 10px">
			<div class="form-group" align="right">
				<input type="submit" class="btn btn-primary pull-left" value="Create New Schedule" style ="color: #ffffff;text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
						background-color: #006dcc;*background-color: #0044cc;background-image: -moz-linear-gradient(top, #0088cc, #0044cc);
						background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#0088cc), to(#0044cc));background-image: -webkit-linear-gradient(top, #0088cc, #0044cc);
						background-image: -o-linear-gradient(top, #0088cc, #0044cc);background-image: linear-gradient(to bottom, #0088cc, #0044cc);
						background-repeat: repeat-x;border-color: #0044cc #0044cc #002a80;border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
						filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff0088cc', endColorstr='#ff0044cc', GradientType=0);
						filter: progid:DXImageTransform.Microsoft.gradient(enabled=false)">
			</div>
			</div>
		</form>
		
		<form class="col=md-12 center-block" action="/backtocalendar">
  			<input type="hidden" name="id" id="id" value="<%=idString%>" />
			<div class="col-sm-11" style="padding-bottom: 5px">
			<div class="form-group">
				<input type="submit" class="btn btn-primary pull-left" value="Back To Calendar" style ="color: #ffffff;text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
						background-color: #006dcc;*background-color: #0044cc;background-image: -moz-linear-gradient(top, #0088cc, #0044cc);
						background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#0088cc), to(#0044cc));background-image: -webkit-linear-gradient(top, #0088cc, #0044cc);
						background-image: -o-linear-gradient(top, #0088cc, #0044cc);background-image: linear-gradient(to bottom, #0088cc, #0044cc);
						background-repeat: repeat-x;border-color: #0044cc #0044cc #002a80;border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
						filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff0088cc', endColorstr='#ff0044cc', GradientType=0);
						filter: progid:DXImageTransform.Microsoft.gradient(enabled=false)">
			</div>
			</div>
		</form>

	</div>
</body>



</html>
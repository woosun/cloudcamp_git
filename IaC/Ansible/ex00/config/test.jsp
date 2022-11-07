<%@page import="java.sql.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ page import="java.net.InetAddress" %>

 

 

클라이언트 IP <%=request.getRemoteAddr()%><br>

요청URI <%=request.getRequestURI()%><br>

요청URL: <%=request.getRequestURL()%><br>

서버이름 <%=request.getServerName()%><br>

<%

InetAddress inet= InetAddress.getLocalHost();

%>

동작 서버 IP <%=inet.getHostAddress()%><br>

서버포트 <%=request.getServerPort()%><br>

	<%
		Connection conn = null;
		ResultSet rs = null;
	      
		String url = "jdbc:mysql://svc-mysql:3306/yoskr_db?serverTimezone=UTC";
		String id = "root";
		String pwd = "qwer1234";


		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(url, id, pwd);
			Statement stmt = conn.createStatement();
     
	
			String sql = "SELECT sname FROM student";
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				out.println(rs.getString("sname"));
			}


			conn.close();
		} catch (Exception e) {

			e.printStackTrace();
		}	
	%>
</body>
</html>

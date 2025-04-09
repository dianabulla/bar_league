<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession sesion = request.getSession(false);
    String nombre = (sesion != null) ? (String) sesion.getAttribute("nombre") : null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inicio - bar_league</title>
</head>
<body>
<% if (nombre != null) { %>
    <h2>Bienvenido, <%= nombre %>!</h2>
<% } else { %>
    <h2>No has iniciado sesión.</h2>
    <a href="login.html">Ir al login</a>
<% } %>
</body>
</html>

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
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            background-color: #f4f4f4;
            text-align: center;
        }

        h2 {
            color: #333;
        }

        .menu {
            margin-top: 30px;
        }

        .menu a {
            display: inline-block;
            margin: 10px;
            padding: 12px 24px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .menu a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<% if (nombre != null) { %>
    <h2>Bienvenido, <%= nombre %>!</h2>

    <div class="menu">
        <a href="usuarios.jsp">👥 Gestión de Usuarios</a>
        <a href="productos.jsp">🍔 Gestión de Productos</a>
    </div>
<% } else { %>
    <h2>No has iniciado sesión.</h2>
    <a href="login.html">Ir al login</a>
<% } %>
</body>
</html>

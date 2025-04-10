<%@ page import="java.sql.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Productos</title>
</head>
<body>
<h2>Registrar nuevo producto</h2>
<form action="ProductoServlet" method="post">
    <input type="hidden" name="action" value="insert">
    <label>Código:</label><br>
    <input type="text" name="codigo"><br>
    <label>Nombre:</label><br>
    <input type="text" name="nombre"><br>
    <label>Descripción:</label><br>
    <textarea name="descripcion"></textarea><br>
    <label>Valor unitario:</label><br>
    <input type="number" name="valor_unitario" step="0.01"><br><br>
    <input type="submit" value="Registrar">
</form>

<hr>
<h2>Lista de productos</h2>
<table border="1">
    <tr>
        <th>Código</th>
        <th>Nombre</th>
        <th>Descripción</th>
        <th>Valor</th>
        <th>Acciones</th>
    </tr>
    <%
        try (Connection conn = ConexionBD.conectar()) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM productos");

            while (rs.next()) {
                int id = rs.getInt("id_producto");
    %>
    <form action="ProductoServlet" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id_producto" value="<%=id%>">
        <tr>
            <td><input type="text" name="codigo" value="<%=rs.getString("codigo")%>"></td>
            <td><input type="text" name="nombre" value="<%=rs.getString("nombre")%>"></td>
            <td><input type="text" name="descripcion" value="<%=rs.getString("descripcion")%>"></td>
            <td><input type="number" name="valor_unitario" step="0.01" value="<%=rs.getBigDecimal("valor_unitario")%>"></td>
            <td>
                <input type="submit" value="Actualizar">
            </form>
            <form action="ProductoServlet" method="post" style="display:inline">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id_producto" value="<%=id%>">
                <input type="submit" value="Eliminar">
            </form>
            </td>
        </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</table>
</body>
</html>

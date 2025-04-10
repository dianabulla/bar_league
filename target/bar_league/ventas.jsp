<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ventas</title>
</head>
<body>

<h2>Ventas Registradas</h2>
<table border="1">
    <tr>
        <th>ID Venta</th>
        <th>ID Pedido</th>
        <th>Total</th>
        <th>Fecha</th>
    </tr>
    <%
        try (Connection conn = ConexionBD.conectar()) {
            String sql = "SELECT id_venta, id_pedido, total_venta, fecha_venta FROM ventas ORDER BY fecha_venta DESC";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id_venta") + "</td>");
                out.println("<td>" + rs.getInt("id_pedido") + "</td>");
                out.println("<td>" + rs.getBigDecimal("total_venta") + "</td>");
                out.println("<td>" + rs.getTimestamp("fecha_venta") + "</td>");
                out.println("</tr>");
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</table>

<br>
<a href="index.jsp">← Volver al menú</a>

</body>
</html>

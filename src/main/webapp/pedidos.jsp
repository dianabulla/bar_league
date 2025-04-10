<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pedidos</title>
</head>
<body>
<h2>Nuevo Pedido</h2>
<form action="PedidoServlet" method="post">
    <label>Usuario:</label>
    <select name="id_usuario">
        <%
            try (Connection conn = ConexionBD.conectar()) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT id_usuario, nombre FROM usuarios");
                while (rs.next()) {
                    out.println("<option value='" + rs.getInt("id_usuario") + "'>" + rs.getString("nombre") + "</option>");
                }
            } catch (Exception e) {
                out.println("<option>Error al cargar usuarios</option>");
            }
        %>
    </select><br><br>

    <label>Productos:</label><br>
    <%
        try (Connection conn = ConexionBD.conectar()) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id_producto, nombre FROM productos");
            while (rs.next()) {
                int idProducto = rs.getInt("id_producto");
                String nombre = rs.getString("nombre");
                out.println(nombre + ": <input type='number' name='producto_" + idProducto + "' min='0'><br>");
            }
        } catch (Exception e) {
            out.println("Error al cargar productos");
        }
    %>
    <br>
    <input type="submit" value="Registrar Pedido">
</form>

<hr>
<h2>Pedidos Registrados</h2>
<table border="1">
    <tr>
        <th>ID</th>
        <th>Usuario</th>
        <th>Fecha</th>
        <th>Estado</th>
        <th>Acciones</th>
    </tr>
    <%
        try (Connection conn = ConexionBD.conectar()) {
            String sql = "SELECT p.id_pedido, u.nombre, p.fecha, p.estado " +
                         "FROM pedidos p JOIN usuarios u ON p.id_usuario = u.id_usuario ORDER BY p.id_pedido DESC";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                int idPedido = rs.getInt("id_pedido");
                out.println("<tr>");
                out.println("<td>" + idPedido + "</td>");
                out.println("<td>" + rs.getString("nombre") + "</td>");
                out.println("<td>" + rs.getString("fecha") + "</td>");
                out.println("<td>");
                out.println("<form action='PedidoServlet' method='post' style='display:inline;'>");
                out.println("<input type='hidden' name='action' value='cambiar_estado'>");
                out.println("<input type='hidden' name='id_pedido' value='" + idPedido + "'>");
                out.println("<select name='estado'>");
                String estadoActual = rs.getString("estado");
                String[] estados = {"pendiente", "servido", "pagado"};
                for (String estado : estados) {
                    out.print("<option value='" + estado + "'");
                    if (estado.equals(estadoActual)) out.print(" selected");
                    out.println(">" + estado + "</option>");
                }
                out.println("</select>");
                out.println("<input type='submit' value='Actualizar'>");
                out.println("</form>");
                out.println("</td>");

                out.println("<td><a href='pedidos.jsp?detalle=" + idPedido + "'>Detalle</a></td>");
                out.println("</tr>");
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</table>

<%
    String detalleId = request.getParameter("detalle");
    if (detalleId != null) {
%>
    <hr>
    <h3>Detalle del Pedido ID: <%= detalleId %></h3>
    <table border="1">
        <tr>
            <th>Producto</th>
            <th>Cantidad</th>
            <th>Subtotal</th>
        </tr>
        <%
            try (Connection conn = ConexionBD.conectar()) {
                String sqlDetalle = "SELECT p.nombre, dp.cantidad, dp.subtotal " +
                                    "FROM detalle_pedido dp " +
                                    "JOIN productos p ON dp.id_producto = p.id_producto " +
                                    "WHERE dp.id_pedido = ?";
                PreparedStatement stmt = conn.prepareStatement(sqlDetalle);
                stmt.setInt(1, Integer.parseInt(detalleId));
                ResultSet rsDetalle = stmt.executeQuery();

                boolean hayDetalle = false;
                while (rsDetalle.next()) {
                    hayDetalle = true;
                    out.println("<tr>");
                    out.println("<td>" + rsDetalle.getString("nombre") + "</td>");
                    out.println("<td>" + rsDetalle.getInt("cantidad") + "</td>");
                    out.println("<td>" + rsDetalle.getBigDecimal("subtotal") + "</td>");
                    out.println("</tr>");
                }
                if (!hayDetalle) {
                    out.println("<tr><td colspan='3'>Este pedido no tiene productos.</td></tr>");
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='3'>Error al cargar detalle: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
    
<% } %>

</body>
</html>

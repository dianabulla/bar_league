<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Pedidos</title>
</head>
<body>

<h2>Nuevo Pedido</h2>
<form action="PedidoServlet" method="post">
    <input type="hidden" name="action" value="crear">

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
                out.println("<option>Error cargando usuarios</option>");
            }
        %>
    </select>

    <h3>Productos</h3>
    <table>
        <tr>
            <th>Producto</th>
            <th>Cantidad</th>
        </tr>
        <%
            try (Connection conn = ConexionBD.conectar()) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT id_producto, nombre FROM productos");
                while (rs.next()) {
                    int id = rs.getInt("id_producto");
        %>
        <tr>
            <td><%= rs.getString("nombre") %></td>
            <td><input type="number" name="cantidad_<%=id%>" min="0"></td>
            <input type="hidden" name="producto_ids" value="<%=id%>">
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='2'>Error cargando productos</td></tr>");
            }
        %>
    </table>

    <br>
    <input type="submit" value="Registrar Pedido">
</form>

<hr>

<h2>Pedidos Registrados</h2>
<table border="1">
    <tr>
        <th>ID Pedido</th>
        <th>Usuario</th>
        <th>Fecha</th>
        <th>Estado</th>
        <th>Acción</th>
    </tr>
    <%
        try (Connection conn = ConexionBD.conectar()) {
            String sql = "SELECT p.id_pedido, u.nombre, p.fecha, p.estado FROM pedidos p JOIN usuarios u ON p.id_usuario = u.id_usuario";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id_pedido") + "</td>");
                out.println("<td>" + rs.getString("nombre") + "</td>");
                out.println("<td>" + rs.getString("fecha") + "</td>");
                out.println("<td>" + rs.getString("estado") + "</td>");
                out.println("<td>");
                out.println("<form action='PedidoServlet' method='post' style='display:inline;'>");
                out.println("<input type='hidden' name='action' value='cambiar_estado'>");
                out.println("<input type='hidden' name='id_pedido' value='" + rs.getInt("id_pedido") + "'>");
                out.println("<select name='estado'>");
                out.println("<option value='pendiente'>Pendiente</option>");
                out.println("<option value='servido'>Servido</option>");
                out.println("<option value='pagado'>Pagado</option>");
                out.println("</select>");
                out.println("<input type='submit' value='Actualizar'>");
                out.println("</form>");
                out.println("</td>");
                out.println("</tr>");
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</table>

</body>
</html>

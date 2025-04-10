<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registrar Compras</title>
</head>
<body>
    <h2>Nueva Compra</h2>
    <form action="CompraServlet" method="post">
        <label>Producto:</label>
        <select name="id_producto">
            <%
                try (Connection conn = ConexionBD.conectar()) {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT id_producto, nombre FROM productos");
                    while (rs.next()) {
                        out.println("<option value='" + rs.getInt("id_producto") + "'>" + rs.getString("nombre") + "</option>");
                    }
                } catch (Exception e) {
                    out.println("<option>Error al cargar productos</option>");
                }
            %>
        </select><br><br>

        <label>Cantidad:</label>
        <input type="number" name="cantidad" min="1" required><br><br>

        <label>Valor Compra:</label>
        <input type="number" name="valor_compra" min="0" step="0.01" required><br><br>

        <input type="submit" value="Registrar Compra">
    </form>

    <hr>
    <h2>Historial de Compras</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Producto</th>
            <th>Cantidad</th>
            <th>Valor Compra</th>
            <th>Fecha</th>
        </tr>
        <%
            try (Connection conn = ConexionBD.conectar()) {
                String sql = "SELECT c.id_compra, p.nombre, c.cantidad, c.valor_compra, c.fecha_compra " +
                             "FROM compras c JOIN productos p ON c.id_producto = p.id_producto ORDER BY c.id_compra DESC";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id_compra") + "</td>");
                    out.println("<td>" + rs.getString("nombre") + "</td>");
                    out.println("<td>" + rs.getInt("cantidad") + "</td>");
                    out.println("<td>$" + rs.getBigDecimal("valor_compra") + "</td>");
                    out.println("<td>" + rs.getTimestamp("fecha_compra") + "</td>");
                    out.println("</tr>");
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='5'>Error al cargar historial: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>

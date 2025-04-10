<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<!-- Importamos las clases necesarias para conectarse a la base de datos -->

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registrar Compras</title>
</head>
<body>

    <!-- ==== FORMULARIO PARA REGISTRAR UNA NUEVA COMPRA ==== -->
    <h2>Nueva Compra</h2>
    <form action="CompraServlet" method="post">
        <!-- Campo para seleccionar el producto -->
        <label>Producto:</label>
        <select name="id_producto">
            <%
                // Cargamos los productos desde la base de datos y los mostramos en el select
                try (Connection conn = ConexionBD.conectar()) {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT id_producto, nombre FROM productos");
                    while (rs.next()) {
                        out.println("<option value='" + rs.getInt("id_producto") + "'>" + rs.getString("nombre") + "</option>");
                    }
                } catch (Exception e) {
                    // En caso de error mostramos un mensaje dentro del select
                    out.println("<option>Error al cargar productos</option>");
                }
            %>
        </select><br><br>

        <!-- Campo para ingresar la cantidad -->
        <label>Cantidad:</label>
        <input type="number" name="cantidad" min="1" required><br><br>

        <!-- Campo para ingresar el valor de la compra -->
        <label>Valor Compra:</label>
        <input type="number" name="valor_compra" min="0" step="0.01" required><br><br>

        <!-- Botón para enviar el formulario -->
        <input type="submit" value="Registrar Compra">
    </form>

    <hr>

    <!-- ==== SECCIÓN DEL HISTORIAL DE COMPRAS ==== -->
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
                // Consulta SQL que une las compras con los productos para mostrar datos descriptivos
                String sql = "SELECT c.id_compra, p.nombre, c.cantidad, c.valor_compra, c.fecha_compra " +
                             "FROM compras c JOIN productos p ON c.id_producto = p.id_producto ORDER BY c.id_compra DESC";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                // Iteramos sobre los resultados y generamos filas en la tabla HTML
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
                // En caso de error al consultar, mostramos una fila con el error
                out.println("<tr><td colspan='5'>Error al cargar historial: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>

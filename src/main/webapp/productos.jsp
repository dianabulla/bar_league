<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<%
    // Variables por defecto para el formulario
    int id_producto = 0;
    String codigo = "";
    String nombre = "";
    String descripcion = "";
    double valor_unitario = 0.0;
    String action = "insert";

    // Si viene el parámetro "edit", llenamos el formulario
    if (request.getParameter("edit") != null) {
        int idEditar = Integer.parseInt(request.getParameter("edit"));
        try (Connection conn = ConexionBD.conectar()) {
            String sql = "SELECT * FROM productos WHERE id_producto=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idEditar);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                id_producto = rs.getInt("id_producto");
                codigo = rs.getString("codigo");
                nombre = rs.getString("nombre");
                descripcion = rs.getString("descripcion");
                valor_unitario = rs.getDouble("valor_unitario");
                action = "update";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Productos</title>
</head>
<body>
    <h2><%= action.equals("insert") ? "Registrar nuevo producto" : "Editar producto" %></h2>
    <form action="ProductoServlet" method="post">
        <input type="hidden" name="action" value="<%= action %>">
        <input type="hidden" name="id_producto" value="<%= id_producto %>">

        <label>Código:</label><br>
        <input type="text" name="codigo" value="<%= codigo %>"><br>

        <label>Nombre:</label><br>
        <input type="text" name="nombre" value="<%= nombre %>"><br>

        <label>Descripción:</label><br>
        <textarea name="descripcion"><%= descripcion %></textarea><br>

        <label>Valor unitario:</label><br>
        <input type="number" step="0.01" name="valor_unitario" value="<%= valor_unitario %>"><br><br>

        <input type="submit" value="<%= action.equals("insert") ? "Registrar" : "Actualizar" %>">
    </form>

    <hr>
    <h2>Lista de productos</h2>
    <table border="1">
        <tr>
            <th>Código</th>
            <th>Nombre</th>
            <th>Descripción</th>
            <th>Valor unitario</th>
            <th>Acciones</th>
        </tr>
        <%
            try (Connection conn = ConexionBD.conectar()) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM productos");

                while (rs.next()) {
                    int id = rs.getInt("id_producto");
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("codigo") + "</td>");
                    out.println("<td>" + rs.getString("nombre") + "</td>");
                    out.println("<td>" + rs.getString("descripcion") + "</td>");
                    out.println("<td>" + rs.getDouble("valor_unitario") + "</td>");
                    out.println("<td>");
                    out.println("<a href='productos.jsp?edit=" + id + "'>Actualizar</a>");
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

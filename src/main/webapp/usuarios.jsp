<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<%
    String editarId = request.getParameter("editar");
    String codigoEdit = "", nombreEdit = "", tipoEdit = "", contrasenaEdit = "";

    if (editarId != null) {
        try (Connection conn = ConexionBD.conectar()) {
            String sql = "SELECT * FROM usuarios WHERE id_usuario = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(editarId));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                codigoEdit = rs.getString("codigo");
                nombreEdit = rs.getString("nombre");
                tipoEdit = rs.getString("tipo_usuario");
                contrasenaEdit = rs.getString("contrasena");
            }
        } catch (Exception e) {
            out.println("<p>Error al cargar usuario: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lista de Usuarios</title>
</head>
<body>
    <h2><%= (editarId != null) ? "Editar usuario" : "Registrar nuevo usuario" %></h2>
    <form action="UsuarioServlet" method="post">
        <% if (editarId != null) { %>
            <input type="hidden" name="accion" value="editar">
            <input type="hidden" name="id_usuario" value="<%= editarId %>">
        <% } else { %>
            <input type="hidden" name="accion" value="crear">
        <% } %>
        <label>Código:</label><br>
        <input type="text" name="codigo" value="<%= codigoEdit %>" required><br>
        <label>Nombre:</label><br>
        <input type="text" name="nombre" value="<%= nombreEdit %>" required><br>
        <label>Contraseña:</label><br>
        <input type="password" name="contrasena" value="<%= contrasenaEdit %>" required><br>
        <label>Tipo:</label><br>
        <select name="tipo_usuario" required>
            <option value="admin" <%= "admin".equals(tipoEdit) ? "selected" : "" %>>Administrador</option>
            <option value="mesero" <%= "mesero".equals(tipoEdit) ? "selected" : "" %>>Mesero</option>
        </select><br><br>
        <input type="submit" value="<%= (editarId != null) ? "Actualizar" : "Registrar" %>">
    </form>

    <hr>
    <h2>Usuarios registrados</h2>
    <table border="1">
        <tr>
            <th>Código</th>
            <th>Nombre</th>
            <th>Tipo</th>
            <th>Acciones</th>
        </tr>
        <%
            try (Connection conn = ConexionBD.conectar()) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT id_usuario, codigo, nombre, tipo_usuario FROM usuarios");

                while (rs.next()) {
                    int id = rs.getInt("id_usuario");
                    String codigo = rs.getString("codigo");
                    String nombre = rs.getString("nombre");
                    String tipo = rs.getString("tipo_usuario");

                    out.println("<tr>");
                    out.println("<td>" + codigo + "</td>");
                    out.println("<td>" + nombre + "</td>");
                    out.println("<td>" + tipo + "</td>");
                    out.println("<td>");
                    out.println("<form action='usuarios.jsp' method='get' style='display:inline;'>");
                    out.println("<input type='hidden' name='editar' value='" + id + "'>");
                    out.println("<input type='submit' value='Editar'>");
                    out.println("</form>");
                    out.println("<form action='UsuarioServlet' method='post' style='display:inline; margin-left:5px;'>");
                    out.println("<input type='hidden' name='accion' value='eliminar'>");
                    out.println("<input type='hidden' name='id_usuario' value='" + id + "'>");
                    out.println("<input type='submit' value='Eliminar'>");
                    out.println("</form>");
                    out.println("</td>");
                    out.println("</tr>");
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>

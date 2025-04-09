<%@ page import="java.sql.*, java.util.*" %>
    <%@ page import="com.barleague.utils.ConexionBD" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Lista de Usuarios</title>
        </head>

        <body>
            <h2>Registrar nuevo usuario</h2>
            <form action="UsuarioServlet" method="post">
                <label>Código:</label><br>
                <input type="text" name="codigo"><br>
                <label>Nombre:</label><br>
                <input type="text" name="nombre"><br>
                <label>Contraseña:</label><br>
                <input type="password" name="contrasena"><br>
                <label>Tipo:</label><br>
                <select name="tipo_usuario">
                    <option value="admin">Administrador</option>
                    <option value="mesero">Mesero</option>
                </select><br><br>
                <input type="submit" value="Registrar">
            </form>

            <hr>
            <h2>Usuarios registrados</h2>
            <table border="1">
                <tr>
                    <th>Código</th>
                    <th>Nombre</th>
                    <th>Tipo</th>
                </tr>
                <% try (Connection conn=ConexionBD.conectar()) { Statement stmt=conn.createStatement(); ResultSet
                    rs=stmt.executeQuery("SELECT codigo, nombre, tipo_usuario FROM usuarios"); while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("codigo") + "</td>");
                    out.println("<td>" + rs.getString("nombre") + "</td>");
                    out.println("<td>" + rs.getString("tipo_usuario") + "</td>");
                    out.println("</tr>");
                    }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
                    }
                    %>
            </table>

            <br>
            <a href="registrar_usuario.html">← Registrar otro usuario</a>
        </body>

        </html>
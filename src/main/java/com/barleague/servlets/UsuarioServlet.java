package com.barleague.servlets;

import com.barleague.utils.ConexionBD;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String id = request.getParameter("id_usuario");
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String contrasena = request.getParameter("contrasena");
        String tipo = request.getParameter("tipo_usuario");

        try (Connection conn = ConexionBD.conectar()) {

            if ("crear".equals(accion)) {
                String sql = "INSERT INTO usuarios (codigo, nombre, contrasena, tipo_usuario) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, codigo);
                stmt.setString(2, nombre);
                stmt.setString(3, contrasena);
                stmt.setString(4, tipo);
                stmt.executeUpdate();

            } else if ("editar".equals(accion)) {
                String sql = "UPDATE usuarios SET codigo=?, nombre=?, contrasena=?, tipo_usuario=? WHERE id_usuario=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, codigo);
                stmt.setString(2, nombre);
                stmt.setString(3, contrasena);
                stmt.setString(4, tipo);
                stmt.setInt(5, Integer.parseInt(id));
                stmt.executeUpdate();

            } else if ("eliminar".equals(accion)) {
                String sql = "DELETE FROM usuarios WHERE id_usuario=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(id));
                stmt.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("usuarios.jsp");
    }
}


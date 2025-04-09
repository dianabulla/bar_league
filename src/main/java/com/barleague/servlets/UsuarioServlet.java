package com.barleague.servlets;

import com.barleague.utils.ConexionBD;

import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

//@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String contrasena = request.getParameter("contrasena");
        String tipo = request.getParameter("tipo_usuario");

        try (Connection conn = ConexionBD.conectar()) {
            String sql = "INSERT INTO usuarios (codigo, nombre, contrasena, tipo_usuario) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, codigo);
            stmt.setString(2, nombre);
            stmt.setString(3, contrasena); // Puedes luego aplicar hash
            stmt.setString(4, tipo);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("usuarios.jsp");
    }
}

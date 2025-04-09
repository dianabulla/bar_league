package com.barleague.servlets;

import com.barleague.utils.ConexionBD;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String codigo = request.getParameter("codigo");
        String contrasena = request.getParameter("contrasena");

        try (Connection conn = ConexionBD.conectar()) {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT * FROM usuarios WHERE codigo = ? AND contrasena = ?"
            );
            stmt.setString(1, codigo);
            stmt.setString(2, contrasena);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession sesion = request.getSession();
                sesion.setAttribute("nombre", rs.getString("nombre"));
                sesion.setAttribute("tipo_usuario", rs.getString("tipo_usuario"));
                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("login.html");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.html");
        }
    }
}

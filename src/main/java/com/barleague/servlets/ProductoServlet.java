package com.barleague.servlets;

import com.barleague.utils.ConexionBD;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class ProductoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Habilitar CORS
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String valorStr = request.getParameter("valor_unitario");

        double valor_unitario = 0.0;
        try {
            valor_unitario = Double.parseDouble(valorStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        try (Connection conn = ConexionBD.conectar()) {
            PreparedStatement stmt;

            if ("insert".equals(action)) {
                String sql = "INSERT INTO productos (codigo, nombre, descripcion, valor_unitario) VALUES (?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, codigo);
                stmt.setString(2, nombre);
                stmt.setString(3, descripcion);
                stmt.setDouble(4, valor_unitario);
                stmt.executeUpdate();

            } else if ("update".equals(action)) {
                int id_producto = Integer.parseInt(request.getParameter("id_producto"));
                String sql = "UPDATE productos SET codigo=?, nombre=?, descripcion=?, valor_unitario=? WHERE id_producto=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, codigo);
                stmt.setString(2, nombre);
                stmt.setString(3, descripcion);
                stmt.setDouble(4, valor_unitario);
                stmt.setInt(5, id_producto);
                stmt.executeUpdate();

            } else if ("delete".equals(action)) {
                int id_producto = Integer.parseInt(request.getParameter("id_producto"));
                String sql = "DELETE FROM productos WHERE id_producto=?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, id_producto);
                stmt.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("Error interno del servidor: " + e.getMessage());
            return;
        }

        // Si la petición viene de React
        if (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json")) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\":\"ok\"}");
        } else {
            response.sendRedirect("productos.jsp");
        }
    }

}

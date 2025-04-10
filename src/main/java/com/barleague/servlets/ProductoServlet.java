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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("productos.jsp");
    }
}


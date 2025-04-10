// ProductoServlet.java
package com.barleague.servlets;

import com.barleague.utils.ConexionBD;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class ProductoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String id = request.getParameter("id_producto");
        String codigo = request.getParameter("codigo");
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String valor = request.getParameter("valor_unitario");

        try (Connection conn = ConexionBD.conectar()) {
            PreparedStatement stmt;

            switch (action) {
                case "insert":
                    stmt = conn.prepareStatement("INSERT INTO productos (codigo, nombre, descripcion, valor_unitario) VALUES (?, ?, ?, ?)");
                    stmt.setString(1, codigo);
                    stmt.setString(2, nombre);
                    stmt.setString(3, descripcion);
                    stmt.setBigDecimal(4, new java.math.BigDecimal(valor));
                    stmt.executeUpdate();
                    break;

                case "update":
                    stmt = conn.prepareStatement("UPDATE productos SET codigo=?, nombre=?, descripcion=?, valor_unitario=? WHERE id_producto=?");
                    stmt.setString(1, codigo);
                    stmt.setString(2, nombre);
                    stmt.setString(3, descripcion);
                    stmt.setBigDecimal(4, new java.math.BigDecimal(valor));
                    stmt.setInt(5, Integer.parseInt(id));
                    stmt.executeUpdate();
                    break;

                case "delete":
                    stmt = conn.prepareStatement("DELETE FROM productos WHERE id_producto=?");
                    stmt.setInt(1, Integer.parseInt(id));
                    stmt.executeUpdate();
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("productos.jsp");
    }
}


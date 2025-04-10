package com.barleague.servlets;

import com.barleague.utils.ConexionBD;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;

public class VentaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idPedido = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = ConexionBD.conectar()) {
            // Verificar si ya existe una venta con este pedido
            String checkVenta = "SELECT COUNT(*) FROM ventas WHERE id_pedido = ?";
            PreparedStatement psCheck = conn.prepareStatement(checkVenta);
            psCheck.setInt(1, idPedido);
            ResultSet rsCheck = psCheck.executeQuery();
            if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                response.getWriter().println("Este pedido ya ha sido registrado como venta.");
                return;
            }

            // Calcular total desde detalle_pedido
            String totalQuery = "SELECT SUM(subtotal) AS total FROM detalle_pedido WHERE id_pedido = ?";
            PreparedStatement psTotal = conn.prepareStatement(totalQuery);
            psTotal.setInt(1, idPedido);
            ResultSet rsTotal = psTotal.executeQuery();

            double totalVenta = 0;
            if (rsTotal.next()) {
                totalVenta = rsTotal.getDouble("total");
            }

            // Insertar en ventas
            String insertVenta = "INSERT INTO ventas (id_pedido, total_venta, fecha_venta) VALUES (?, ?, ?)";
            PreparedStatement psVenta = conn.prepareStatement(insertVenta);
            psVenta.setInt(1, idPedido);
            psVenta.setDouble(2, totalVenta);
            psVenta.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            psVenta.executeUpdate();

            response.sendRedirect("ventas.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al registrar la venta: " + e.getMessage());
        }
    }
}

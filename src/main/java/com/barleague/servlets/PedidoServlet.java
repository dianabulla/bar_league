package com.barleague.servlets;

import com.barleague.utils.ConexionBD;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.Enumeration;

public class PedidoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idUsuarioStr = request.getParameter("id_usuario");

        if (idUsuarioStr == null || idUsuarioStr.isEmpty()) {
            response.getWriter().println("ID de usuario es requerido.");
            return;
        }

        int idUsuario = Integer.parseInt(idUsuarioStr);
        boolean tieneProductos = false;

        try (Connection conn = ConexionBD.conectar()) {
            conn.setAutoCommit(false);

            // Insertar pedido
            String insertPedidoSQL = "INSERT INTO pedidos (fecha, id_usuario, estado) VALUES (?, ?, ?)";
            PreparedStatement pedidoStmt = conn.prepareStatement(insertPedidoSQL, Statement.RETURN_GENERATED_KEYS);
            pedidoStmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            pedidoStmt.setInt(2, idUsuario);
            pedidoStmt.setString(3, "pendiente");
            pedidoStmt.executeUpdate();

            ResultSet generatedKeys = pedidoStmt.getGeneratedKeys();
            int idPedido = -1;
            if (generatedKeys.next()) {
                idPedido = generatedKeys.getInt(1);
            }

            // Insertar productos (solo los que tengan cantidad > 0)
            String insertDetalleSQL = "INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES (?, ?, ?, ?)";
            PreparedStatement detalleStmt = conn.prepareStatement(insertDetalleSQL);

            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("cantidad_")) {
                    String idProductoStr = paramName.substring("cantidad_".length());
                    String cantidadStr = request.getParameter(paramName);

                    try {
                        int cantidad = Integer.parseInt(cantidadStr);
                        if (cantidad > 0) {
                            tieneProductos = true;

                            int idProducto = Integer.parseInt(idProductoStr);

                            // Obtener precio del producto
                            String sqlPrecio = "SELECT valor_unitario FROM productos WHERE id_producto = ?";
                            PreparedStatement precioStmt = conn.prepareStatement(sqlPrecio);
                            precioStmt.setInt(1, idProducto);
                            ResultSet rs = precioStmt.executeQuery();

                            if (rs.next()) {
                                double precio = rs.getDouble("valor_unitario");
                                double subtotal = cantidad * precio;

                                detalleStmt.setInt(1, idPedido);
                                detalleStmt.setInt(2, idProducto);
                                detalleStmt.setInt(3, cantidad);
                                detalleStmt.setDouble(4, subtotal);
                                detalleStmt.addBatch();
                            }
                        }
                    } catch (NumberFormatException ignored) {}
                }
            }

            if (tieneProductos) {
                detalleStmt.executeBatch();
                conn.commit();
                response.sendRedirect("pedidos.jsp");
            } else {
                conn.rollback();
                response.getWriter().println("Debes ingresar al menos un producto con cantidad mayor a 0.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al registrar pedido: " + e.getMessage());
        }
    }
}


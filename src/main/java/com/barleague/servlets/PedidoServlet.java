package com.barleague.servlets;

import com.barleague.utils.ConexionBD;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class PedidoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("cambiar_estado".equals(action)) {
            int idPedido = Integer.parseInt(request.getParameter("id_pedido"));
            String nuevoEstado = request.getParameter("estado");

            try (Connection conn = ConexionBD.conectar()) {
                String sql = "UPDATE pedidos SET estado = ? WHERE id_pedido = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nuevoEstado);
                stmt.setInt(2, idPedido);
                stmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error al actualizar estado: " + e.getMessage());
                return;
            }

            response.sendRedirect("pedidos.jsp");
            return;
        }

        int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));
        Map<Integer, Integer> productosSeleccionados = new HashMap<>();

        try (Connection conn = ConexionBD.conectar()) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id_producto FROM productos");

            while (rs.next()) {
                int idProducto = rs.getInt("id_producto");
                String param = request.getParameter("producto_" + idProducto);

                if (param != null && !param.isEmpty()) {
                    int cantidad = Integer.parseInt(param);
                    if (cantidad > 0) {
                        productosSeleccionados.put(idProducto, cantidad);
                    }
                }
            }

            if (productosSeleccionados.isEmpty()) {
                response.getWriter().println("Debes ingresar al menos un producto con cantidad mayor a 0.");
                return;
            }

            String insertPedido = "INSERT INTO pedidos (fecha, id_usuario, estado) VALUES (?, ?, ?)";
            PreparedStatement psPedido = conn.prepareStatement(insertPedido, Statement.RETURN_GENERATED_KEYS);
            psPedido.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            psPedido.setInt(2, idUsuario);
            psPedido.setString(3, "pendiente");
            psPedido.executeUpdate();

            ResultSet rsKeys = psPedido.getGeneratedKeys();
            int idPedido = 0;
            if (rsKeys.next()) {
                idPedido = rsKeys.getInt(1);
            }

            String insertDetalle = "INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES (?, ?, ?, ?)";
            PreparedStatement psDetalle = conn.prepareStatement(insertDetalle);

            for (Map.Entry<Integer, Integer> entry : productosSeleccionados.entrySet()) {
                int idProducto = entry.getKey();
                int cantidad = entry.getValue();

                PreparedStatement psPrecio = conn.prepareStatement("SELECT valor_unitario FROM productos WHERE id_producto = ?");
                psPrecio.setInt(1, idProducto);
                ResultSet rsPrecio = psPrecio.executeQuery();
                if (rsPrecio.next()) {
                    double precio = rsPrecio.getDouble("valor_unitario");
                    double subtotal = precio * cantidad;

                    psDetalle.setInt(1, idPedido);
                    psDetalle.setInt(2, idProducto);
                    psDetalle.setInt(3, cantidad);
                    psDetalle.setDouble(4, subtotal);
                    psDetalle.addBatch();
                }
            }

            psDetalle.executeBatch();
            response.sendRedirect("pedidos.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error al registrar el pedido: " + e.getMessage());
        }
    }
}

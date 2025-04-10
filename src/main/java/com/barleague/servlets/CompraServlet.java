package com.barleague.servlets;

import com.barleague.dao.CompraDAO;
import com.barleague.models.Compra;
import com.barleague.models.Producto;
import com.barleague.utils.HibernateUtil;
import org.hibernate.Session;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;

public class CompraServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // parsear parametros
        int idProducto = Integer.parseInt(request.getParameter("id_producto"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        double valorCompra = Double.parseDouble(request.getParameter("valor_compra"));

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            // Obtener el producto desde Hibernate (relación ManyToOne)
            Producto producto = session.get(Producto.class, idProducto);

            Compra compra = new Compra();
            compra.setProducto(producto);
            compra.setCantidad(cantidad);
            compra.setValorCompra(valorCompra);
            compra.setFechaCompra(LocalDateTime.now());

            // Usar el DAO para guardar
            CompraDAO compraDAO = new CompraDAO();
            boolean guardado = compraDAO.registrarCompra(compra);

            if (guardado) {
                response.sendRedirect("compras.jsp");
            } else {
                response.getWriter().println("Error al guardar la compra.");
            }

        } catch (Exception e) {
            //imprimir error
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

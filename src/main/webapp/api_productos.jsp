<%@ page import="java.sql.*, java.util.*, org.json.*" %>
<%@ page import="com.barleague.utils.ConexionBD" %>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");
%>
<%@ page contentType="application/json;charset=UTF-8" %>

<%
    JSONArray productos = new JSONArray();

    try (Connection conn = ConexionBD.conectar()) {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM productos");

        while (rs.next()) {
            JSONObject prod = new JSONObject();
            prod.put("id_producto", rs.getInt("id_producto"));
            prod.put("codigo", rs.getString("codigo"));
            prod.put("nombre", rs.getString("nombre"));
            prod.put("descripcion", rs.getString("descripcion"));
            prod.put("valor_unitario", rs.getDouble("valor_unitario"));
            productos.put(prod);
        }
    } catch (Exception e) {
        JSONObject error = new JSONObject();
        error.put("error", e.getMessage());
        productos.put(error);
    }

    out.print(productos.toString());
%>

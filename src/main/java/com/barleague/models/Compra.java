package com.barleague.models;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "compras")
public class Compra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_compra")
    private int id;

    @ManyToOne
    @JoinColumn(name = "id_producto", nullable = false)
    private Producto producto;

    @Column(nullable = false)
    private int cantidad;

    @Column(name = "valor_compra", nullable = false)
    private double valorCompra;

    @Column(name = "fecha_compra")
    private LocalDateTime fechaCompra;

    // === Constructores ===
    public Compra() {}

    public Compra(Producto producto, int cantidad, double valorCompra, LocalDateTime fechaCompra) {
        this.producto = producto;
        this.cantidad = cantidad;
        this.valorCompra = valorCompra;
        this.fechaCompra = fechaCompra;
    }

    // === Getters y Setters ===
    public int getId() {
        return id;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getValorCompra() {
        return valorCompra;
    }

    public void setValorCompra(double valorCompra) {
        this.valorCompra = valorCompra;
    }

    public LocalDateTime getFechaCompra() {
        return fechaCompra;
    }

    public void setFechaCompra(LocalDateTime fechaCompra) {
        this.fechaCompra = fechaCompra;
    }
}


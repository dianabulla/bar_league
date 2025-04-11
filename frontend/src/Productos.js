import React, { useEffect, useState } from 'react';
import axios from 'axios';

export default function Productos() {
  const [productos, setProductos] = useState([]);
  const [formData, setFormData] = useState({
    id_producto: null,
    codigo: '',
    nombre: '',
    descripcion: '',
    valor_unitario: ''
  });

  useEffect(() => {
    obtenerProductos();
  }, []);

  const obtenerProductos = async () => {
    try {
      const res = await axios.get('http://localhost:8080/bar_league/api_productos.jsp');
      setProductos(res.data);
    } catch (err) {
      console.error('Error al obtener productos:', err);
    }
  };

  const handleChange = e => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async e => {
    e.preventDefault();
    try {
      const url = 'http://localhost:8080/bar_league/ProductoServlet';
      const form = new FormData();
      form.append('codigo', formData.codigo);
      form.append('nombre', formData.nombre);
      form.append('descripcion', formData.descripcion);
      form.append('valor_unitario', formData.valor_unitario);
      form.append('action', formData.id_producto ? 'update' : 'insert');
      if (formData.id_producto) form.append('id_producto', formData.id_producto);
      await axios.post(url, form);
      setFormData({ id_producto: null, codigo: '', nombre: '', descripcion: '', valor_unitario: '' });
      obtenerProductos();
    } catch (err) {
      console.error('Error al guardar producto:', err);
    }
  };

  const handleEditar = producto => {
    setFormData(producto);
  };

  const handleEliminar = async id => {
    if (!window.confirm('¿Deseas eliminar este producto?')) return;
    try {
      const url = `http://localhost:8080/bar_league/ProductoServlet?action=delete&id_producto=${id}`;
      await axios.get(url);
      obtenerProductos();
    } catch (err) {
      console.error('Error al eliminar producto:', err);
    }
  };

  return (
    <div className="container p-4">
      <h2 className="text-xl font-bold mb-4">Productos</h2>
      <form onSubmit={handleSubmit} className="mb-4 space-y-2">
        <input name="codigo" value={formData.codigo} onChange={handleChange} placeholder="Código" required className="border p-2 w-full" />
        <input name="nombre" value={formData.nombre} onChange={handleChange} placeholder="Nombre" required className="border p-2 w-full" />
        <textarea name="descripcion" value={formData.descripcion} onChange={handleChange} placeholder="Descripción" className="border p-2 w-full"></textarea>
        <input name="valor_unitario" type="number" step="0.01" value={formData.valor_unitario} onChange={handleChange} placeholder="Valor unitario" required className="border p-2 w-full" />
        <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">
          {formData.id_producto ? 'Actualizar' : 'Registrar'}
        </button>
      </form>

      <table className="w-full border">
        <thead>
          <tr className="bg-gray-200">
            <th className="border p-2">Código</th>
            <th className="border p-2">Nombre</th>
            <th className="border p-2">Descripción</th>
            <th className="border p-2">Valor</th>
            <th className="border p-2">Acciones</th>
          </tr>
        </thead>
        <tbody>
          {productos.map(p => (
            <tr key={p.id_producto}>
              <td className="border p-2">{p.codigo}</td>
              <td className="border p-2">{p.nombre}</td>
              <td className="border p-2">{p.descripcion}</td>
              <td className="border p-2">${p.valor_unitario}</td>
              <td className="border p-2 space-x-2">
                <button onClick={() => handleEditar(p)} className="bg-yellow-400 px-2 py-1 rounded">Editar</button>
                <button onClick={() => handleEliminar(p.id_producto)} className="bg-red-500 text-white px-2 py-1 rounded">Eliminar</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

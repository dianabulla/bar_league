package com.barleague.dao;

import com.barleague.models.Compra;
import com.barleague.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class CompraDAO {

    // Método para registrar una nueva compra
    public boolean registrarCompra(Compra compra) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();

            session.save(compra);

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }
}

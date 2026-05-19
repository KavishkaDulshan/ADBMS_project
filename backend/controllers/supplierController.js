const { getDBPool, sql } = require('../config/db');

const getAllSuppliers = async (req, res) => {
  try {
    const pool = await getDBPool();
    
    // Fetch suppliers with their primary address and total spend
    const result = await pool.request().query(`
      SELECT 
        s.SupplierID,
        s.SupplierName,
        st.TypeName as Category,
        sa.City,
        sa.Province,
        (SELECT TOP 1 ContactValue FROM SupplierContact WHERE SupplierID = s.SupplierID AND ContactType = 'Email') as Email,
        (SELECT TOP 1 ContactValue FROM SupplierContact WHERE SupplierID = s.SupplierID AND ContactType = 'Phone') as Phone,
        ISNULL((
            SELECT SUM(TotalAmount) 
            FROM ExpenseHeader 
            WHERE SupplierID = s.SupplierID AND StatusID = 2 -- 'Approved'
        ), 0) as TotalSpend
      FROM Supplier s
      JOIN SupplierType st ON s.SupplierTypeID = st.SupplierTypeID
      LEFT JOIN SupplierAddress sa ON s.SupplierID = sa.SupplierID AND sa.IsPrimary = 1
    `);
    
    res.json(result.recordset);
  } catch (error) {
    console.error('Error in getAllSuppliers:', error);
    res.status(500).json({ error: error.message });
  }
};

module.exports = { getAllSuppliers };

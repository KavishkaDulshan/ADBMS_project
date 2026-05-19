const { getDBPool, sql } = require('../config/db');

const getBudgets = async (req, res) => {
  try {
    const pool = await getDBPool();
    
    // We fetch budgets for the current month and year
    // and calculate the actual spent amount from approved expenses
    const result = await pool.request().query(`
      SELECT 
        ec.CategoryName as category,
        b.AllocatedAmount as budget,
        ISNULL((
            SELECT SUM(eli.Quantity * eli.UnitPrice)
            FROM ExpenseLineItem eli
            JOIN ExpenseHeader eh ON eli.ExpenseID = eh.ExpenseID
            JOIN DateDimension dd ON eh.DateKey = dd.DateKey
            WHERE eli.ExpenseCategoryID = b.ExpenseCategoryID
              AND MONTH(dd.FullDate) = b.BudgetMonth
              AND YEAR(dd.FullDate) = b.BudgetYear
              AND eh.StatusID = 2 -- 'Approved'
        ), 0) as spent
      FROM Budget b
      JOIN ExpenseCategory ec ON b.ExpenseCategoryID = ec.ExpenseCategoryID
      WHERE b.BudgetMonth = MONTH(GETDATE()) AND b.BudgetYear = YEAR(GETDATE())
    `);
    
    res.json(result.recordset);
  } catch (error) {
    console.error('Error in getBudgets:', error);
    res.status(500).json({ error: error.message });
  }
};

module.exports = { getBudgets };

const { getDBPool, sql } = require('../config/db');

const getBudgets = async (req, res) => {
  try {
    const pool = await getDBPool();

    // sp_GetBudgetReport returns budget vs actual for the current month,
    // plus BudgetStatus (SAFE/WARNING/CRITICAL) and PredictedNextMonth from UDFs
    const result = await pool.request().query(`EXEC sp_GetBudgetReport`);

    // Map to the shape the frontend expects
    const budgets = result.recordset.map(row => ({
      id:               row.BudgetID,
      category:         row.CategoryName,
      budget:           row.BudgetAmount,
      spent:            row.ActualSpend,
      variance:         row.Variance,
      utilizationPct:   row.UtilizationPct,
      status:           row.BudgetStatus,          // SAFE / WARNING / CRITICAL
      predictedNext:    row.PredictedNextMonth,
    }));

    res.json(budgets);
  } catch (error) {
    console.error('Error in getBudgets:', error);
    res.status(500).json({ error: error.message });
  }
};

const createBudget = async (req, res) => {
  try {
    const { categoryId, amount } = req.body;
    const pool = await getDBPool();
    await pool.request()
      .input('categoryId', sql.Int, categoryId)
      .input('amount', sql.Decimal(18,2), amount)
      .query(`
        INSERT INTO Budget (ExpenseCategoryID, AllocatedAmount, BudgetMonth, BudgetYear)
        VALUES (@categoryId, @amount, MONTH(GETDATE()), YEAR(GETDATE()))
      `);
    res.status(201).json({ message: 'Budget created successfully' });
  } catch (error) {
    console.error('Error creating budget:', error);
    res.status(500).json({ error: error.message });
  }
};

const updateBudget = async (req, res) => {
  try {
    const { id } = req.params;
    const { amount } = req.body;
    const pool = await getDBPool();
    await pool.request()
      .input('id', sql.Int, id)
      .input('amount', sql.Decimal(18,2), amount)
      .query(`
        UPDATE Budget 
        SET AllocatedAmount = @amount
        WHERE BudgetID = @id
      `);
    res.json({ message: 'Budget updated successfully' });
  } catch (error) {
    console.error('Error updating budget:', error);
    res.status(500).json({ error: error.message });
  }
};

const deleteBudget = async (req, res) => {
  try {
    const { id } = req.params;
    const pool = await getDBPool();
    
    // Check if any budget alerts are linked to it and delete first
    await pool.request().input('id', sql.Int, id).query(`DELETE FROM BudgetAlert WHERE BudgetID = @id`);
    
    await pool.request()
      .input('id', sql.Int, id)
      .query(`DELETE FROM Budget WHERE BudgetID = @id`);
      
    res.json({ message: 'Budget deleted successfully' });
  } catch (error) {
    console.error('Error deleting budget:', error);
    res.status(500).json({ error: error.message });
  }
};

module.exports = { getBudgets, createBudget, updateBudget, deleteBudget };

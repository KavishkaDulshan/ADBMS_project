import { useState, useEffect, useCallback } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import Layout from '../components/layout/Layout';
import Card from '../components/ui/Card';
import Table from '../components/ui/Table';
import Button from '../components/ui/Button';
import Badge from '../components/ui/Badge';
import { getExpenseById, updateExpense, deleteExpense, approveExpense } from '../services/expenseService';
import { useExpenseLookups } from '../hooks/useExpenseLookups';
import { ArrowLeft, Edit2, Save, X, CheckCircle, Trash2, Loader2 } from 'lucide-react';

const ExpenseDetail = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const location = useLocation();
  const { suppliers, employees, paymentMethods, loading: lookupsLoading } = useExpenseLookups();

  const [expense, setExpense] = useState(null);
  const [approvals, setApprovals] = useState([]);
  const [lineItems, setLineItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);

  const [editForm, setEditForm] = useState({
    description: '',
    totalAmount: '',
    paymentMethodId: '',
    employeeId: '',
    supplierId: ''
  });

  const fetchExpense = useCallback(async () => {
    setLoading(true);
    try {
      const data = await getExpenseById(id);
      setExpense(data.expense);
      setApprovals(data.approvals || []);
      setLineItems(data.lineItems || []);
      setError(null);
    } catch (err) {
      setError(err.message || 'Failed to fetch expense details');
    } finally {
      setLoading(false);
    }
  }, [id]);

  const enterEditMode = useCallback(() => {
    setExpense((current) => {
      if (!current) return current;
      setEditForm({
        description: current.Description || '',
        totalAmount: current.TotalAmount?.toString() || '',
        paymentMethodId: current.PaymentMethodID?.toString() || '',
        employeeId: current.EmployeeID?.toString() || '',
        supplierId: current.SupplierID?.toString() || ''
      });
      return current;
    });
    setIsEditing(true);
  }, []);

  useEffect(() => {
    fetchExpense();
  }, [fetchExpense]);

  useEffect(() => {
    if (location.state?.edit && expense && !isEditing) {
      enterEditMode();
      window.history.replaceState({}, document.title);
    }
  }, [location.state?.edit, expense, isEditing, enterEditMode]);

  const handleEdit = () => {
    if (lookupsLoading) {
      alert('Loading lookup data, please wait...');
      return;
    }
    enterEditMode();
  };

  const handleCancel = () => {
    setIsEditing(false);
  };

  const handleSave = async () => {
    if (!editForm.description.trim()) {
      alert('Description is required.');
      return;
    }
    setIsSubmitting(true);
    try {
      await updateExpense(id, {
        description: editForm.description,
        totalAmount: Number(editForm.totalAmount),
        paymentMethodId: Number(editForm.paymentMethodId),
        employeeId: Number(editForm.employeeId),
        supplierId: editForm.supplierId ? Number(editForm.supplierId) : null
      });
      setIsEditing(false);
      await fetchExpense();
    } catch (_err) {
      console.error('Update expense failed:', _err);
      alert('Failed to update expense.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleApprove = async () => {
    if (!window.confirm('Approve this expense?')) return;
    setIsSubmitting(true);
    try {
      await approveExpense(id, { approvedBy: 1, statusId: 2, remarks: null });
      await fetchExpense();
    } catch (_err) {
      console.error('Approve expense failed:', _err);
      alert('Failed to approve expense.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('Are you sure you want to delete this expense?')) return;
    setIsSubmitting(true);
    try {
      await deleteExpense(id);
      navigate('/expenses');
    } catch (_err) {
      console.error('Delete expense failed:', _err);
      alert('Failed to delete expense.');
      setIsSubmitting(false);
    }
  };

  const getStatusVariant = (status) => {
    switch (status?.toLowerCase()) {
      case 'approved': return 'green';
      case 'pending': return 'yellow';
      case 'rejected': return 'red';
      default: return 'gray';
    }
  };

  if (loading) {
    return (
      <Layout title="Expense Detail">
        <div className="flex items-center justify-center h-64">
          <Loader2 className="animate-spin mr-2" size={24} />
          <span className="text-gray-500 text-lg">Loading expense details...</span>
        </div>
      </Layout>
    );
  }

  if (error || !expense) {
    return (
      <Layout title="Expense Detail">
        <div className="text-center py-20">
          <p className="text-red-500 text-lg mb-4">{error || 'Expense not found.'}</p>
          <Button onClick={() => navigate('/expenses')} variant="outline" className="flex items-center gap-2">
            <ArrowLeft size={16} /> Back to Expenses
          </Button>
        </div>
      </Layout>
    );
  }

  const isPending = expense.StatusName?.toLowerCase() === 'pending';

  return (
    <Layout title={`Expense #${expense.ExpenseID}`}>
      <div className="mb-4 flex justify-between items-center flex-wrap gap-3">
        <Button onClick={() => navigate('/expenses')} variant="outline" className="flex items-center gap-2">
          <ArrowLeft size={16} /> Back to Expenses
        </Button>
        <div className="flex gap-3">
          {isEditing ? (
            <>
              <Button onClick={handleSave} disabled={isSubmitting} className="flex items-center gap-2 bg-green-600 hover:bg-green-700">
                <Save size={16} /> {isSubmitting ? 'Saving...' : 'Save Changes'}
              </Button>
              <Button onClick={handleCancel} variant="outline" className="flex items-center gap-2">
                <X size={16} /> Cancel
              </Button>
            </>
          ) : (
            <>
              <Button onClick={handleEdit} disabled={lookupsLoading} className="flex items-center gap-2">
                <Edit2 size={16} /> Edit
              </Button>
              {isPending && (
                <Button onClick={handleApprove} disabled={isSubmitting} className="flex items-center gap-2 bg-emerald-600 hover:bg-emerald-700">
                  <CheckCircle size={16} /> Approve
                </Button>
              )}
              {isPending && (
                <Button onClick={handleDelete} disabled={isSubmitting} variant="outline" className="flex items-center gap-2 text-red-600 border-red-300 hover:bg-red-50">
                  <Trash2 size={16} /> Delete
                </Button>
              )}
            </>
          )}
        </div>
      </div>

      <Card className="mb-6 border-none shadow-sm">
        <h3 className="text-lg font-bold text-gray-800 mb-4 pb-2 border-b">Header Details</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Expense ID</label>
            <p className="text-gray-900 font-mono font-bold">#{expense.ExpenseID}</p>
          </div>
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Date</label>
            <p className="text-gray-900">{new Date(expense.FullDate).toLocaleDateString()}</p>
          </div>
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Status</label>
            <Badge variant={getStatusVariant(expense.StatusName)}>{expense.StatusName}</Badge>
          </div>
          <div className="col-span-1 md:col-span-2">
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Description</label>
            {isEditing ? (
              <input
                type="text"
                value={editForm.description}
                onChange={e => setEditForm({ ...editForm, description: e.target.value })}
                className="w-full border border-gray-300 rounded-md p-2 text-sm focus:ring-blue-500 focus:border-blue-500"
              />
            ) : (
              <p className="text-gray-900">{expense.Description || '-'}</p>
            )}
          </div>
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Total Amount</label>
            {isEditing ? (
              <input
                type="number"
                min="0"
                step="0.01"
                value={editForm.totalAmount}
                onChange={e => setEditForm({ ...editForm, totalAmount: e.target.value })}
                className="w-full border border-gray-300 rounded-md p-2 text-sm focus:ring-blue-500 focus:border-blue-500"
              />
            ) : (
              <p className="text-gray-900 font-bold text-lg">Rs. {parseFloat(expense.TotalAmount).toFixed(2)}</p>
            )}
          </div>
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Supplier</label>
            {isEditing ? (
              <select
                value={editForm.supplierId}
                onChange={e => setEditForm({ ...editForm, supplierId: e.target.value })}
                className="w-full border border-gray-300 rounded-md p-2 text-sm focus:ring-blue-500 focus:border-blue-500"
                disabled={lookupsLoading}
              >
                <option value="">None</option>
                {suppliers.map(s => <option key={s.SupplierID} value={s.SupplierID}>{s.SupplierName}</option>)}
              </select>
            ) : (
              <p className="text-gray-900 font-semibold">{expense.SupplierName || '-'}</p>
            )}
          </div>
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Employee</label>
            {isEditing ? (
              <select
                value={editForm.employeeId}
                onChange={e => setEditForm({ ...editForm, employeeId: e.target.value })}
                className="w-full border border-gray-300 rounded-md p-2 text-sm focus:ring-blue-500 focus:border-blue-500"
                disabled={lookupsLoading}
              >
                {employees.map(e => <option key={e.EmployeeID} value={e.EmployeeID}>{e.EmployeeName}</option>)}
              </select>
            ) : (
              <p className="text-gray-900">{expense.EmployedBy || '-'}</p>
            )}
          </div>
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">Payment Method</label>
            {isEditing ? (
              <select
                value={editForm.paymentMethodId}
                onChange={e => setEditForm({ ...editForm, paymentMethodId: e.target.value })}
                className="w-full border border-gray-300 rounded-md p-2 text-sm focus:ring-blue-500 focus:border-blue-500"
                disabled={lookupsLoading}
              >
                {paymentMethods.map(p => <option key={p.PaymentMethodID} value={p.PaymentMethodID}>{p.MethodName}</option>)}
              </select>
            ) : (
              <p className="text-gray-900">{expense.PaymentMethodName || '-'}</p>
            )}
          </div>
        </div>
      </Card>

      <Card className="mb-6 border-none shadow-sm">
        <h3 className="text-lg font-bold text-gray-800 mb-4 pb-2 border-b">Line Items</h3>
        {lineItems.length === 0 ? (
          <p className="text-gray-500 text-center py-6">No line items for this expense.</p>
        ) : (
          <Table
            headers={['#', 'Item', 'Category', 'Qty', 'Unit Price', 'Line Total']}
            data={lineItems}
            renderRow={(item, idx) => (
              <>
                <td className="px-6 py-3 whitespace-nowrap text-sm text-gray-500">{idx + 1}</td>
                <td className="px-6 py-3 whitespace-nowrap text-sm font-medium text-gray-900">{item.ItemName || 'N/A'}</td>
                <td className="px-6 py-3 whitespace-nowrap text-sm text-gray-500">{item.CategoryName || 'N/A'}</td>
                <td className="px-6 py-3 whitespace-nowrap text-sm text-gray-500">{item.Quantity}</td>
                <td className="px-6 py-3 whitespace-nowrap text-sm text-gray-500">Rs. {parseFloat(item.UnitPrice).toFixed(2)}</td>
                <td className="px-6 py-3 whitespace-nowrap text-sm font-bold text-gray-900">Rs. {parseFloat(item.LineTotal).toFixed(2)}</td>
              </>
            )}
          />
        )}
      </Card>

      <Card className="mb-6 border-none shadow-sm">
        <h3 className="text-lg font-bold text-gray-800 mb-4 pb-2 border-b">Approval History</h3>
        {approvals.length === 0 ? (
          <p className="text-gray-500 text-center py-6">No approval records yet.</p>
        ) : (
          <Table
            headers={['#', 'Date', 'Status', 'Approved By', 'Remarks']}
            data={approvals}
            renderRow={(approval) => (
              <>
                <td className="px-6 py-3 whitespace-nowrap text-sm text-gray-500">#{approval.ApprovalID}</td>
                <td className="px-6 py-3 whitespace-nowrap text-sm text-gray-500">{new Date(approval.ApprovalDate).toLocaleString()}</td>
                <td className="px-6 py-3 whitespace-nowrap">
                  <Badge variant={getStatusVariant(approval.StatusName)}>{approval.StatusName}</Badge>
                </td>
                <td className="px-6 py-3 whitespace-nowrap text-sm text-gray-900">{approval.ApprovedByName || '-'}</td>
                <td className="px-6 py-3 whitespace-nowrap text-sm text-gray-500">{approval.Remarks || '-'}</td>
              </>
            )}
          />
        )}
      </Card>
    </Layout>
  );
};

export default ExpenseDetail;

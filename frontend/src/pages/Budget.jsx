import React from 'react';
import Layout from '../components/layout/Layout';
import Card from '../components/ui/Card';
import BudgetBarChart from '../components/charts/BudgetBarChart';
import { useBudget } from '../hooks/useBudget';
import { AlertCircle, Loader2, PieChart } from 'lucide-react';

const Budget = () => {
  const { budgets, loading, error } = useBudget();

  return (
    <Layout title="Budget Management">
      {loading ? (
        <div className="flex flex-col items-center justify-center h-64 text-gray-500">
          <Loader2 className="animate-spin mb-4" size={48} />
          <p className="text-lg font-medium">Fetching budget data...</p>
        </div>
      ) : error ? (
        <div className="bg-red-50 border border-red-200 text-red-700 px-6 py-4 rounded-lg flex items-center gap-3">
          <AlertCircle size={24} />
          <div>
            <p className="font-bold">Error loading budget</p>
            <p className="text-sm">{error}</p>
          </div>
        </div>
      ) : budgets.length === 0 ? (
        <Card className="text-center py-12">
          <PieChart className="mx-auto text-gray-300 mb-4" size={64} />
          <h3 className="text-xl font-bold text-gray-800">No Budget Set</h3>
          <p className="text-gray-500">There are no budget allocations for the current month.</p>
        </Card>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 animate-in fade-in duration-500">
          <Card title="Budget vs Actual Spent" className="border-none shadow-sm">
            <BudgetBarChart data={budgets} />
          </Card>
          
          <Card title="Budget Allocation Details" className="border-none shadow-sm">
            <div className="space-y-6">
              {budgets.map((item, index) => (
                <div key={index} className="group">
                  <div className="flex justify-between mb-2">
                    <span className="text-sm font-semibold text-gray-700 group-hover:text-blue-600 transition-colors">
                      {item.category}
                    </span>
                    <span className={`text-sm font-bold ${item.spent > item.budget ? 'text-red-600' : 'text-gray-600'}`}>
                      ${item.spent.toLocaleString()} / ${item.budget.toLocaleString()}
                    </span>
                  </div>
                  <div className="w-full bg-gray-100 rounded-full h-3 overflow-hidden">
                    <div 
                      className={`h-full rounded-full transition-all duration-1000 ease-out ${
                        item.spent > item.budget ? 'bg-red-500' : 'bg-blue-600'
                      }`}
                      style={{ width: `${Math.min((item.spent / item.budget) * 100, 100)}%` }}
                    ></div>
                  </div>
                  {item.spent > item.budget && (
                    <p className="text-[10px] text-red-500 mt-1 font-bold uppercase tracking-wider flex items-center gap-1">
                      <AlertCircle size={10} /> Over Budget
                    </p>
                  )}
                </div>
              ))}
            </div>
          </Card>
        </div>
      )}
    </Layout>
  );
};

export default Budget;

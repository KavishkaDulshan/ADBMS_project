import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Dashboard.css';

const Dashboard = () => {
    const navigate = useNavigate();
    const userStr = localStorage.getItem('user');
    const user = userStr ? JSON.parse(userStr) : null;

    const handleLogout = () => {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        navigate('/login');
    };

    return (
        <div className="dashboard-container">
            <header className="dashboard-header">
                <div className="logo">Vaultix</div>
                <div className="user-info">
                    <span className="username">Welcome, {user?.username || 'User'}</span>
                    <span className="role-badge">{user?.role || 'Employee'}</span>
                    <button onClick={handleLogout} className="logout-button">Logout</button>
                </div>
            </header>
            <main className="dashboard-main">
                <div className="dashboard-card welcome-card">
                    <h2>Dashboard</h2>
                    <p>You have successfully authenticated via JWT. This is a protected route.</p>
                </div>
            </main>
        </div>
    );
};

export default Dashboard;

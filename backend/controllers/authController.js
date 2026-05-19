const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { getDBPool, sql } = require('../config/db');

exports.login = async (req, res) => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            return res.status(400).json({ message: 'Please provide both username and password.' });
        }

        const pool = await getDBPool();
        
        // Query the Employee table joined with Role table
        // We assume the schema has fields like Username, PasswordHash, RoleId etc.
        const result = await pool.request()
            .input('username', sql.VarChar, username)
            .query(`
                SELECT e.*, r.RoleName 
                FROM Employee e
                LEFT JOIN Role r ON e.RoleId = r.RoleId
                WHERE e.Username = @username
            `);

        const employee = result.recordset[0];

        if (!employee) {
            return res.status(401).json({ message: 'Invalid credentials.' });
        }

        // Compare password. 
        // Note: For a real system, passwords should be hashed. 
        // We'll assume the password might be hashed, but if it's plaintext for some reason, we could also do a direct check.
        // Assuming bcrypt hashing is used as per standard:
        let isMatch = false;
        
        // As a fallback for demonstration if passwords aren't actually hashed in the provided DB
        if (employee.PasswordHash) {
             isMatch = await bcrypt.compare(password, employee.PasswordHash);
        } else if (employee.Password) {
             // In case the column is named Password and plaintext for demo purposes
             isMatch = (password === employee.Password);
             // If they are hashed, it should be: isMatch = await bcrypt.compare(password, employee.Password);
             // Best effort to handle bcrypt if it looks like a hash
             if (employee.Password.startsWith('$2')) {
                  isMatch = await bcrypt.compare(password, employee.Password);
             }
        }

        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid credentials.' });
        }

        // Generate JWT
        const payload = {
            id: employee.EmployeeId || employee.Id,
            username: employee.Username,
            role: employee.RoleName || employee.Role
        };

        const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1d' });

        res.json({
            message: 'Login successful',
            token,
            user: {
                id: payload.id,
                username: payload.username,
                role: payload.role
            }
        });

    } catch (err) {
        console.error('Login error:', err);
        res.status(500).json({ message: 'Server error during login.' });
    }
};

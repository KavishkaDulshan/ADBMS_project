-- ============================================================
--  VAULTIX — Dummy Data Insertion Script (Sri Lankan Context)
-- ============================================================

USE Vaultix;

-- ------------------------------------------------------------
-- 1. Top-up Seeded Tables (to reach 12 records)
-- ------------------------------------------------------------

-- Add 10 more to SupplierCategory (2 were already seeded)
INSERT INTO SupplierCategory (CategoryName) VALUES
('IT Services'),
('Consultancy'),
('Logistics'),
('Hardware'),
('Software'),
('Food & Beverage'),
('Real Estate'),
('Event Management'),
('Raw Materials'),
('Apparel');

-- Add 8 more to Role (4 were already seeded)
INSERT INTO Role (RoleName) VALUES
('Assistant Manager'),
('Sales Executive'),
('HR Executive'),
('Admin Officer'),
('Delivery Driver'),
('Security Guard'),
('Cleaner'),
('IT Support');

-- Add 8 more to PaymentMethod (4 were already seeded)
INSERT INTO PaymentMethod (MethodName) VALUES
('Mobile Money (eZ Cash)'),
('Mobile Money (mCash)'),
('LankaQR'),
('CEFT'),
('SLIPS'),
('RTGS'),
('PayOrder'),
('Petty Cash');

-- Add 4 more to ExpenseCategory (8 were already seeded)
INSERT INTO ExpenseCategory (CategoryName) VALUES
('Office Supplies'),
('Internet & Communication'),
('Staff Welfare'),
('Legal Fees');


-- ------------------------------------------------------------
-- 2. Insert 12 Records into Empty Tables
-- ------------------------------------------------------------

-- Item
INSERT INTO Item (ItemName, Description, UnitOfMeasure, SupplierTypeID, IsActive) VALUES
('A4 Paper Ream (Double A)', '80gsm 500 sheets', 'Ream', 1, 1),
('CR Book 120 Pages', 'Single rule CR book', 'Book', 2, 1),
('Atlas Blue Pen', 'Ballpoint pen 0.7mm', 'Box', 2, 1),
('Promate Highlighter Set', '5 colors pack', 'Pack', 3, 1),
('Kangaroo Stapler', 'Heavy duty stapler', 'Unit', 4, 1),
('Box File', 'A4 size box file', 'Unit', 3, 1),
('3M Sticky Notes', 'Yellow 3x3 inches', 'Pad', 1, 1),
('Whiteboard Marker Black', 'Dry erase marker', 'Box', 2, 1),
('HP 65 Black Ink', 'Original printer cartridge', 'Unit', 6, 1),
('Casio Calculator', '12 digit desktop calculator', 'Unit', 5, 1),
('Sellotape 1 inch', 'Clear adhesive tape', 'Roll', 7, 1),
('Brown Envelopes', 'A4 size 100 pack', 'Pack', 1, 1);

-- Supplier
INSERT INTO Supplier (SupplierName, RegisteredDate, SupplierTypeID) VALUES
('Sarasavi Bookshop', '2020-01-15', 1),
('MD Gunasena', '2015-05-20', 2),
('Atlas Axillia', '2010-08-10', 2),
('Promate', '2018-11-25', 3),
('Richard Pieris', '2005-02-14', 5),
('Singer Sri Lanka', '2000-09-30', 6),
('Abans PLC', '2002-12-12', 6),
('Dialog Axiata', '1995-04-01', 8),
('Ceylon Electricity Board', '1969-11-01', 8),
('National Water Supply', '1975-01-01', 8),
('Cargills Ceylon', '1980-06-15', 12),
('Softlogic Holdings', '2012-07-22', 5);

-- SupplierAddress
INSERT INTO SupplierAddress (SupplierID, Street, City, Province, PostalCode, IsPrimary) VALUES
(1, 'High Level Rd', 'Nugegoda', 'Western', '10250', 1),
(2, 'Olcott Mawatha', 'Colombo 11', 'Western', '00110', 1),
(3, 'Nawaloka Rd', 'Peliyagoda', 'Western', '11830', 1),
(4, 'Galle Rd', 'Moratuwa', 'Western', '10400', 1),
(5, 'Hyde Park Corner', 'Colombo 02', 'Western', '00200', 1),
(6, 'Navam Mawatha', 'Colombo 02', 'Western', '00200', 1),
(7, 'Galle Rd', 'Colombo 03', 'Western', '00300', 1),
(8, 'Union Place', 'Colombo 02', 'Western', '00200', 1),
(9, 'Sir Chittampalam A Gardiner Mw', 'Colombo 02', 'Western', '00200', 1),
(10, 'Galle Rd', 'Ratmalana', 'Western', '10390', 1),
(11, 'York Street', 'Colombo 01', 'Western', '00100', 1),
(12, 'De Fonseka Place', 'Colombo 04', 'Western', '00400', 1);

-- SupplierContact
INSERT INTO SupplierContact (SupplierID, ContactPerson, Phone, Email, IsPrimary) VALUES
(1, 'Kamal Perera', '0771112222', 'kamal@sarasavi.lk', 1),
(2, 'Nimal Silva', '0712223333', 'nimal@mdgunasena.com', 1),
(3, 'Sunil Fernando', '0773334444', 'sunil@atlas.lk', 1),
(4, 'Nuwan Jayasinghe', '0714445555', 'nuwan@promate.lk', 1),
(5, 'Chaminda Rathnayake', '0775556666', 'chaminda@arpico.com', 1),
(6, 'Ruwan Bandara', '0716667777', 'ruwan@singer.lk', 1),
(7, 'Pradeep Kumara', '0777778888', 'pradeep@abans.lk', 1),
(8, 'Asanka Dissanayake', '0778889999', 'asanka@dialog.lk', 1),
(9, 'Mahesh Senanayake', '0112324414', 'mahesh@ceb.lk', 1),
(10, 'Sanjeewa Rajapaksha', '0112638999', 'sanjeewa@waterboard.lk', 1),
(11, 'Dinesh Gunawardena', '0779990000', 'dinesh@cargills.lk', 1),
(12, 'Roshan De Silva', '0710001111', 'roshan@softlogic.lk', 1);

-- Employee
INSERT INTO Employee (FirstName, LastName, RoleID, HireDate) VALUES
('Kasun', 'Perera', 1, '2021-01-15'),
('Amila', 'Silva', 2, '2021-03-10'),
('Saman', 'Kumara', 3, '2022-05-20'),
('Nayana', 'Fernando', 4, '2022-08-01'),
('Tharushi', 'Jayasinghe', 5, '2023-01-10'),
('Dilini', 'Rathnayake', 6, '2023-02-15'),
('Gayan', 'Bandara', 7, '2023-06-01'),
('Lahiru', 'Dissanayake', 8, '2023-09-15'),
('Chamika', 'Senanayake', 9, '2024-01-05'),
('Saduni', 'Rajapaksha', 10, '2024-03-20'),
('Ishara', 'Gunawardena', 11, '2024-06-10'),
('Ruwanthi', 'De Silva', 12, '2024-08-01');

-- EmployeeContact
INSERT INTO EmployeeContact (EmployeeID, ContactType, ContactValue, IsPrimary) VALUES
(1, 'Mobile', '0771234567', 1),
(2, 'Email', 'amila.s@vaultix.lk', 1),
(3, 'Work', '0112345678', 1),
(4, 'Mobile', '0719876543', 1),
(5, 'Home', '0332223344', 1),
(6, 'Email', 'dilini.r@vaultix.lk', 1),
(7, 'Mobile', '0774567890', 1),
(8, 'Mobile', '0716543210', 1),
(9, 'Work', '0118765432', 1),
(10, 'Email', 'saduni.r@vaultix.lk', 1),
(11, 'Home', '0812233445', 1),
(12, 'Mobile', '0770002222', 1);

-- ExpenseHeader
-- Note: DateKey values map to January 2025 dates generated in your DateDimension table
INSERT INTO ExpenseHeader (DateKey, SupplierID, EmployeeID, PaymentMethodID, StatusID, TotalAmount, Description) VALUES
(20250101, 1, 1, 1, 2, 15000.00, 'Monthly office stationery purchase'),
(20250102, 2, 2, 2, 1, 8500.00, 'Additional CR books and pens'),
(20250103, 3, 3, 3, 2, 25000.00, 'Bulk purchase of printing paper'),
(20250104, 4, 4, 4, 3, 12000.00, 'Rejected order for highlighters'),
(20250105, 5, 5, 5, 2, 45000.00, 'Office chairs and desks maintenance'),
(20250106, 6, 6, 6, 1, 3500.00, 'Pantry appliances repair'),
(20250107, 7, 7, 7, 2, 75000.00, 'New laptops for IT staff'),
(20250108, 8, 8, 8, 2, 18000.00, 'Monthly internet and mobile bills'),
(20250109, 9, 9, 1, 1, 22000.00, 'Electricity bill for January'),
(20250110, 10, 10, 2, 2, 5500.00, 'Water bill for January'),
(20250111, 11, 11, 3, 2, 15000.00, 'Staff welfare grocery purchase'),
(20250112, 12, 12, 4, 1, 10000.00, 'Printer toners and ink');

-- ExpenseLineItem
INSERT INTO ExpenseLineItem (ExpenseID, ItemID, ExpenseCategoryID, Quantity, UnitPrice) VALUES
(1, 1, 1, 10, 1500.00),
(2, 2, 1, 50, 170.00),
(3, 1, 1, 20, 1250.00),
(4, 4, 1, 15, 800.00),
(5, 5, 5, 5, 9000.00),
(6, 10, 8, 1, 3500.00),
(7, 9, 1, 5, 15000.00),
(8, 7, 2, 20, 900.00),
(9, 6, 2, 11, 2000.00),
(10, 8, 2, 11, 500.00),
(11, 11, 11, 30, 500.00),
(12, 12, 1, 20, 500.00);

-- Budget
INSERT INTO Budget (ExpenseCategoryID, AllocatedAmount, BudgetMonth, BudgetYear) VALUES
(1, 100000.00, 1, 2025),
(2, 50000.00, 1, 2025),
(3, 500000.00, 1, 2025),
(4, 200000.00, 1, 2025),
(5, 75000.00, 1, 2025),
(6, 40000.00, 1, 2025),
(7, 60000.00, 1, 2025),
(8, 30000.00, 1, 2025),
(9, 150000.00, 1, 2025),
(10, 80000.00, 1, 2025),
(11, 45000.00, 1, 2025),
(12, 100000.00, 1, 2025);

-- BudgetAlert
INSERT INTO BudgetAlert (BudgetID, AlertDate, SpentAmount, Message) VALUES
(1, '2025-01-15', 95000.00, 'Warning: Office Supplies budget 95% utilized.'),
(2, '2025-01-16', 48000.00, 'Warning: Utilities budget nearly exhausted.'),
(3, '2025-01-20', 490000.00, 'Warning: Salaries budget limit reached.'),
(4, '2025-01-22', 195000.00, 'Warning: Rent budget 98% utilized.'),
(5, '2025-01-25', 70000.00, 'Warning: Maintenance budget 90% utilized.'),
(6, '2025-01-26', 38000.00, 'Warning: Transport budget critically low.'),
(7, '2025-01-27', 59000.00, 'Warning: Marketing budget 98% utilized.'),
(8, '2025-01-28', 29000.00, 'Warning: Miscellaneous budget 95% utilized.'),
(9, '2025-01-29', 145000.00, 'Warning: Secondary Office Supplies budget low.'),
(10, '2025-01-29', 78000.00, 'Warning: Comms budget 97% utilized.'),
(11, '2025-01-30', 44000.00, 'Warning: Welfare budget 97% utilized.'),
(12, '2025-01-31', 99000.00, 'Warning: Legal Fees budget nearly fully exhausted.');

-- ApprovalLog
INSERT INTO ApprovalLog (ExpenseID, ApprovedBy, ApprovalDate, StatusID, Remarks) VALUES
(1, 1, '2025-01-02', 2, 'Approved by Manager'),
(2, 1, '2025-01-03', 1, 'Pending additional details'),
(3, 1, '2025-01-04', 2, 'Approved for bulk discount'),
(4, 1, '2025-01-05', 3, 'Rejected due to budget constraints'),
(5, 1, '2025-01-06', 2, 'Approved routine maintenance'),
(6, 1, '2025-01-07', 1, 'Pending invoice verification'),
(7, 1, '2025-01-08', 2, 'Approved IT hardware request'),
(8, 1, '2025-01-09', 2, 'Approved monthly recurring'),
(9, 1, '2025-01-10', 1, 'Pending management approval'),
(10, 1, '2025-01-11', 2, 'Approved basic utilities'),
(11, 1, '2025-01-12', 2, 'Approved staff welfare'),
(12, 1, '2025-01-13', 1, 'Pending stock count verification');

-- Receipt
INSERT INTO Receipt (ExpenseID, ReceiptNumber, FilePath) VALUES
(1, 'REC-2025-001', '/docs/receipts/2025/rec_001.pdf'),
(2, 'REC-2025-002', '/docs/receipts/2025/rec_002.pdf'),
(3, 'REC-2025-003', '/docs/receipts/2025/rec_003.pdf'),
(4, 'REC-2025-004', '/docs/receipts/2025/rec_004.pdf'),
(5, 'REC-2025-005', '/docs/receipts/2025/rec_005.pdf'),
(6, 'REC-2025-006', '/docs/receipts/2025/rec_006.pdf'),
(7, 'REC-2025-007', '/docs/receipts/2025/rec_007.pdf'),
(8, 'REC-2025-008', '/docs/receipts/2025/rec_008.pdf'),
(9, 'REC-2025-009', '/docs/receipts/2025/rec_009.pdf'),
(10, 'REC-2025-010', '/docs/receipts/2025/rec_010.pdf'),
(11, 'REC-2025-011', '/docs/receipts/2025/rec_011.pdf'),
(12, 'REC-2025-012', '/docs/receipts/2025/rec_012.pdf');

-- SystemAuditLog
INSERT INTO SystemAuditLog (TableName, ActionType, RecordID, OldValue, NewValue, ChangedDate) VALUES
('ExpenseHeader', 'INSERT', 1, NULL, '{"StatusID":2, "TotalAmount":15000}', '2025-01-01 10:00:00'),
('ExpenseHeader', 'UPDATE', 1, '{"StatusID":1}', '{"StatusID":2}', '2025-01-02 11:30:00'),
('Supplier', 'INSERT', 1, NULL, '{"SupplierName":"Sarasavi Bookshop"}', '2025-01-01 09:00:00'),
('Employee', 'INSERT', 1, NULL, '{"FirstName":"Kasun", "RoleID":1}', '2025-01-01 09:15:00'),
('Budget', 'INSERT', 1, NULL, '{"AllocatedAmount":100000}', '2025-01-01 08:30:00'),
('BudgetAlert', 'INSERT', 1, NULL, '{"SpentAmount":95000}', '2025-01-15 14:00:00'),
('ApprovalLog', 'INSERT', 1, NULL, '{"StatusID":2}', '2025-01-02 11:35:00'),
('Receipt', 'INSERT', 1, NULL, '{"ReceiptNumber":"REC-2025-001"}', '2025-01-02 12:00:00'),
('ExpenseLineItem', 'INSERT', 1, NULL, '{"Quantity":10}', '2025-01-01 10:05:00'),
('Item', 'UPDATE', 1, '{"IsActive":0}', '{"IsActive":1}', '2025-01-01 09:45:00'),
('SupplierContact', 'UPDATE', 1, '{"Phone":"0771110000"}', '{"Phone":"0771112222"}', '2025-01-05 16:20:00'),
('EmployeeContact', 'DELETE', 13, '{"ContactType":"Home"}', NULL, '2025-01-10 09:00:00');
-- ============================================================
--  VAULTIX — Stationery Shop Expense Tracking System
--  Full Database Creation Script
--  MS SQL Server
-- ============================================================

-- ------------------------------------------------------------
-- CREATE DATABASE
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Vaultix')
BEGIN
    CREATE DATABASE Vaultix;
END

USE Vaultix;

-- ============================================================
-- GROUP 1 — BI DIMENSION TABLES
-- ============================================================

-- ------------------------------------------------------------
-- 1. DateDimension
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='DateDimension' AND xtype='U')
CREATE TABLE DateDimension (
    DateKey         INT             NOT NULL,
    FullDate        DATE            NOT NULL,
    DayOfWeek       VARCHAR(10)     NOT NULL,
    MonthName       VARCHAR(15)     NOT NULL,
    CalendarYear    INT             NOT NULL,
    CalendarQuarter INT             NOT NULL,
    IsWeekend       BIT             NOT NULL DEFAULT 0,
    CONSTRAINT PK_DateDimension PRIMARY KEY (DateKey)
);

-- ------------------------------------------------------------
-- 2. SupplierType (needed before Item FK)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SupplierCategory' AND xtype='U')
CREATE TABLE SupplierCategory (
    SupplierCategoryID  INT             IDENTITY(1,1)   NOT NULL,
    CategoryName        VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_SupplierCategory PRIMARY KEY (SupplierCategoryID)
);

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SupplierType' AND xtype='U')
CREATE TABLE SupplierType (
    SupplierTypeID      INT             IDENTITY(1,1)   NOT NULL,
    TypeName            VARCHAR(100)    NOT NULL,
    SupplierCategoryID  INT             NOT NULL,
    CONSTRAINT PK_SupplierType PRIMARY KEY (SupplierTypeID),
    CONSTRAINT FK_SupplierType_Category FOREIGN KEY (SupplierCategoryID)
        REFERENCES SupplierCategory(SupplierCategoryID)
);

-- ------------------------------------------------------------
-- 3. Item
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Item' AND xtype='U')
CREATE TABLE Item (
    ItemID          INT             IDENTITY(1,1)   NOT NULL,
    ItemName        VARCHAR(150)    NOT NULL,
    Description     VARCHAR(255)    NULL,
    UnitOfMeasure   VARCHAR(50)     NOT NULL,
    SupplierTypeID  INT             NULL,
    IsActive        BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_Item PRIMARY KEY (ItemID),
    CONSTRAINT FK_Item_SupplierType FOREIGN KEY (SupplierTypeID)
        REFERENCES SupplierType(SupplierTypeID)
);


-- ============================================================
-- GROUP 2 — SUPPLIER HUB
-- ============================================================

-- ------------------------------------------------------------
-- 4. Supplier
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Supplier' AND xtype='U')
CREATE TABLE Supplier (
    SupplierID      INT             IDENTITY(1,1)   NOT NULL,
    SupplierName    VARCHAR(150)    NOT NULL,
    RegisteredDate  DATE            NOT NULL,
    SupplierTypeID  INT             NOT NULL,
    CONSTRAINT PK_Supplier PRIMARY KEY (SupplierID),
    CONSTRAINT FK_Supplier_SupplierType FOREIGN KEY (SupplierTypeID)
        REFERENCES SupplierType(SupplierTypeID)
);

-- ------------------------------------------------------------
-- 5. SupplierAddress
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SupplierAddress' AND xtype='U')
CREATE TABLE SupplierAddress (
    AddressID       INT             IDENTITY(1,1)   NOT NULL,
    SupplierID      INT             NOT NULL,
    Street          VARCHAR(255)    NULL,
    City            VARCHAR(100)    NULL,
    Province        VARCHAR(100)    NULL,
    PostalCode      VARCHAR(20)     NULL,
    IsPrimary       BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_SupplierAddress PRIMARY KEY (AddressID),
    CONSTRAINT FK_SupplierAddress_Supplier FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID)
);

-- ------------------------------------------------------------
-- 6. SupplierContact
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SupplierContact' AND xtype='U')
CREATE TABLE SupplierContact (
    ContactID       INT             IDENTITY(1,1)   NOT NULL,
    SupplierID      INT             NOT NULL,
    ContactPerson   VARCHAR(150)    NOT NULL,
    Phone           VARCHAR(20)     NULL,
    Email           VARCHAR(150)    NULL,
    IsPrimary       BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_SupplierContact PRIMARY KEY (ContactID),
    CONSTRAINT FK_SupplierContact_Supplier FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID)
);


-- ============================================================
-- GROUP 3 — EMPLOYEE HUB
-- ============================================================

-- ------------------------------------------------------------
-- 7. Role
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Role' AND xtype='U')
CREATE TABLE Role (
    RoleID      INT             IDENTITY(1,1)   NOT NULL,
    RoleName    VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Role PRIMARY KEY (RoleID)
);

-- ------------------------------------------------------------
-- 8. Employee
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Employee' AND xtype='U')
CREATE TABLE Employee (
    EmployeeID  INT             IDENTITY(1,1)   NOT NULL,
    FirstName   VARCHAR(100)    NOT NULL,
    LastName    VARCHAR(100)    NOT NULL,
    RoleID      INT             NOT NULL,
    HireDate    DATE            NOT NULL,
    CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_Employee_Role FOREIGN KEY (RoleID)
        REFERENCES Role(RoleID)
);

-- ------------------------------------------------------------
-- 9. EmployeeContact
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='EmployeeContact' AND xtype='U')
CREATE TABLE EmployeeContact (
    ContactID       INT             IDENTITY(1,1)   NOT NULL,
    EmployeeID      INT             NOT NULL,
    ContactType     VARCHAR(50)     NOT NULL,
    ContactValue    VARCHAR(150)    NOT NULL,
    IsPrimary       BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_EmployeeContact PRIMARY KEY (ContactID),
    CONSTRAINT FK_EmployeeContact_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID),
    CONSTRAINT CK_EmployeeContact_Type CHECK (
        ContactType IN ('Mobile', 'Work', 'Home', 'Email')
    )
);


-- ============================================================
-- GROUP 4 — CORE TRANSACTION TABLES
-- ============================================================

-- ------------------------------------------------------------
-- 10. ExpenseCategory
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ExpenseCategory' AND xtype='U')
CREATE TABLE ExpenseCategory (
    ExpenseCategoryID   INT             IDENTITY(1,1)   NOT NULL,
    CategoryName        VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_ExpenseCategory PRIMARY KEY (ExpenseCategoryID)
);

-- ------------------------------------------------------------
-- 11. PaymentMethod
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PaymentMethod' AND xtype='U')
CREATE TABLE PaymentMethod (
    PaymentMethodID INT             IDENTITY(1,1)   NOT NULL,
    MethodName      VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_PaymentMethod PRIMARY KEY (PaymentMethodID)
);

-- ------------------------------------------------------------
-- 12. ExpenseStatus
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ExpenseStatus' AND xtype='U')
CREATE TABLE ExpenseStatus (
    StatusID    INT             IDENTITY(1,1)   NOT NULL,
    StatusName  VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_ExpenseStatus PRIMARY KEY (StatusID),
    CONSTRAINT CK_ExpenseStatus_Name CHECK (
        StatusName IN ('Pending', 'Approved', 'Rejected')
    )
);

-- ------------------------------------------------------------
-- 13. ExpenseHeader
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ExpenseHeader' AND xtype='U')
CREATE TABLE ExpenseHeader (
    ExpenseID       INT             IDENTITY(1,1)   NOT NULL,
    DateKey         INT             NOT NULL,
    SupplierID      INT             NULL,
    EmployeeID      INT             NOT NULL,
    PaymentMethodID INT             NOT NULL,
    StatusID        INT             NOT NULL,
    TotalAmount     DECIMAL(18,2)   NOT NULL,
    Description     VARCHAR(255)    NULL,
    CONSTRAINT PK_ExpenseHeader PRIMARY KEY (ExpenseID),
    CONSTRAINT FK_ExpenseHeader_Date FOREIGN KEY (DateKey)
        REFERENCES DateDimension(DateKey),
    CONSTRAINT FK_ExpenseHeader_Supplier FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID),
    CONSTRAINT FK_ExpenseHeader_Employee FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_ExpenseHeader_PaymentMethod FOREIGN KEY (PaymentMethodID)
        REFERENCES PaymentMethod(PaymentMethodID),
    CONSTRAINT FK_ExpenseHeader_Status FOREIGN KEY (StatusID)
        REFERENCES ExpenseStatus(StatusID),
    CONSTRAINT CK_ExpenseHeader_Amount CHECK (TotalAmount >= 0)
);

-- ------------------------------------------------------------
-- 14. ExpenseLineItem
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ExpenseLineItem' AND xtype='U')
CREATE TABLE ExpenseLineItem (
    LineItemID          INT             IDENTITY(1,1)   NOT NULL,
    ExpenseID           INT             NOT NULL,
    ItemID              INT             NOT NULL,
    ExpenseCategoryID   INT             NOT NULL,
    Quantity            INT             NOT NULL,
    UnitPrice           DECIMAL(18,2)   NOT NULL,
    LineTotal           AS (Quantity * UnitPrice) PERSISTED,
    CONSTRAINT PK_ExpenseLineItem PRIMARY KEY (LineItemID),
    CONSTRAINT FK_LineItem_Expense FOREIGN KEY (ExpenseID)
        REFERENCES ExpenseHeader(ExpenseID),
    CONSTRAINT FK_LineItem_Item FOREIGN KEY (ItemID)
        REFERENCES Item(ItemID),
    CONSTRAINT FK_LineItem_Category FOREIGN KEY (ExpenseCategoryID)
        REFERENCES ExpenseCategory(ExpenseCategoryID),
    CONSTRAINT CK_LineItem_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_LineItem_UnitPrice CHECK (UnitPrice >= 0)
);


-- ============================================================
-- GROUP 5 — BUDGETING & CONTROLS
-- ============================================================

-- ------------------------------------------------------------
-- 15. Budget
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Budget' AND xtype='U')
CREATE TABLE Budget (
    BudgetID            INT             IDENTITY(1,1)   NOT NULL,
    ExpenseCategoryID   INT             NOT NULL,
    AllocatedAmount     DECIMAL(18,2)   NOT NULL,
    BudgetMonth         INT             NOT NULL,
    BudgetYear          INT             NOT NULL,
    CONSTRAINT PK_Budget PRIMARY KEY (BudgetID),
    CONSTRAINT FK_Budget_Category FOREIGN KEY (ExpenseCategoryID)
        REFERENCES ExpenseCategory(ExpenseCategoryID),
    CONSTRAINT CK_Budget_Month CHECK (BudgetMonth BETWEEN 1 AND 12),
    CONSTRAINT CK_Budget_Year CHECK (BudgetYear >= 2000),
    CONSTRAINT CK_Budget_Amount CHECK (AllocatedAmount >= 0),
    CONSTRAINT UQ_Budget_CategoryMonthYear UNIQUE (
        ExpenseCategoryID, BudgetMonth, BudgetYear
    )
);

-- ------------------------------------------------------------
-- 16. BudgetAlert
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='BudgetAlert' AND xtype='U')
CREATE TABLE BudgetAlert (
    AlertID         INT             IDENTITY(1,1)   NOT NULL,
    BudgetID        INT             NOT NULL,
    AlertDate       DATETIME        NOT NULL DEFAULT GETDATE(),
    SpentAmount     DECIMAL(18,2)   NOT NULL,
    Message         VARCHAR(255)    NOT NULL,
    CONSTRAINT PK_BudgetAlert PRIMARY KEY (AlertID),
    CONSTRAINT FK_BudgetAlert_Budget FOREIGN KEY (BudgetID)
        REFERENCES Budget(BudgetID)
);


-- ============================================================
-- GROUP 6 — AUDITING & COMPLIANCE
-- ============================================================

-- ------------------------------------------------------------
-- 17. ApprovalLog
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ApprovalLog' AND xtype='U')
CREATE TABLE ApprovalLog (
    ApprovalID      INT             IDENTITY(1,1)   NOT NULL,
    ExpenseID       INT             NOT NULL,
    ApprovedBy      INT             NOT NULL,
    ApprovalDate    DATETIME        NOT NULL DEFAULT GETDATE(),
    StatusID        INT             NOT NULL,
    Remarks         VARCHAR(255)    NULL,
    CONSTRAINT PK_ApprovalLog PRIMARY KEY (ApprovalID),
    CONSTRAINT FK_ApprovalLog_Expense FOREIGN KEY (ExpenseID)
        REFERENCES ExpenseHeader(ExpenseID),
    CONSTRAINT FK_ApprovalLog_Employee FOREIGN KEY (ApprovedBy)
        REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_ApprovalLog_Status FOREIGN KEY (StatusID)
        REFERENCES ExpenseStatus(StatusID)
);

-- ------------------------------------------------------------
-- 18. Receipt
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Receipt' AND xtype='U')
CREATE TABLE Receipt (
    ReceiptID       INT             IDENTITY(1,1)   NOT NULL,
    ExpenseID       INT             NOT NULL,
    ReceiptNumber   VARCHAR(100)    NOT NULL,
    FilePath        VARCHAR(500)    NULL,
    CONSTRAINT PK_Receipt PRIMARY KEY (ReceiptID),
    CONSTRAINT FK_Receipt_Expense FOREIGN KEY (ExpenseID)
        REFERENCES ExpenseHeader(ExpenseID),
    CONSTRAINT UQ_Receipt_Number UNIQUE (ReceiptNumber)
);

-- ------------------------------------------------------------
-- 19. SystemAuditLog
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SystemAuditLog' AND xtype='U')
CREATE TABLE SystemAuditLog (
    AuditID         INT             IDENTITY(1,1)   NOT NULL,
    TableName       VARCHAR(100)    NOT NULL,
    ActionType      VARCHAR(10)     NOT NULL,
    RecordID        INT             NOT NULL,
    OldValue        NVARCHAR(MAX)   NULL,
    NewValue        NVARCHAR(MAX)   NULL,
    ChangedDate     DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_SystemAuditLog PRIMARY KEY (AuditID),
    CONSTRAINT CK_AuditLog_ActionType CHECK (
        ActionType IN ('INSERT', 'UPDATE', 'DELETE')
    )
);


-- ============================================================
-- SEED DATA — Lookup Tables
-- ============================================================

-- ExpenseStatus
INSERT INTO ExpenseStatus (StatusName) VALUES
('Pending'),
('Approved'),
('Rejected');

-- PaymentMethod
INSERT INTO PaymentMethod (MethodName) VALUES
('Cash'),
('Bank Transfer'),
('Credit Card'),
('Cheque');

-- Role
INSERT INTO Role (RoleName) VALUES
('Manager'),
('Cashier'),
('Warehouse Staff'),
('Accountant');

-- SupplierCategory
INSERT INTO SupplierCategory (CategoryName) VALUES
('Goods'),
('Service');

-- SupplierType
INSERT INTO SupplierType (TypeName, SupplierCategoryID) VALUES
('Paper & Printing Supplies',   1),
('Writing Instruments',         1),
('Filing & Organization',       1),
('Art & Craft Supplies',        1),
('Office Equipment',            1),
('Computer & Tech Accessories', 1),
('Packaging Materials',         1),
('Utility Provider',            2),
('Maintenance & Repair',        2),
('Transport & Delivery',        2),
('Marketing & Advertising',     2),
('Cleaning Services',           2),
('Security Services',           2);

-- ExpenseCategory
INSERT INTO ExpenseCategory (CategoryName) VALUES
('Stock Purchase'),
('Utilities'),
('Salaries'),
('Rent'),
('Maintenance & Repairs'),
('Transport & Delivery'),
('Marketing & Advertising'),
('Miscellaneous');

-- DateDimension (populate 2025 and 2026)
DECLARE @StartDate DATE = '2025-01-01';
DECLARE @EndDate   DATE = '2026-12-31';
DECLARE @Date      DATE = @StartDate;

WHILE @Date <= @EndDate
BEGIN
    INSERT INTO DateDimension (
        DateKey, FullDate, DayOfWeek,
        MonthName, CalendarYear, CalendarQuarter, IsWeekend
    )
    VALUES (
        CAST(FORMAT(@Date, 'yyyyMMdd') AS INT),
        @Date,
        DATENAME(WEEKDAY, @Date),
        DATENAME(MONTH, @Date),
        YEAR(@Date),
        DATEPART(QUARTER, @Date),
        CASE WHEN DATENAME(WEEKDAY, @Date) IN ('Saturday','Sunday') THEN 1 ELSE 0 END
    );
    SET @Date = DATEADD(DAY, 1, @Date);
END

-- ============================================================
-- PRINT SUMMARY
-- ============================================================
PRINT '========================================';
PRINT ' Vaultix Database Created Successfully';
PRINT ' Tables: 19';
PRINT ' Seed data inserted for lookup tables';
PRINT ' DateDimension populated: 2025-2026';
PRINT '========================================';

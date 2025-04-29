-- Create the database
CREATE DATABASE IF NOT EXISTS business_company;
USE business_company;

-- Departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    budget DECIMAL(15,2),
    manager_id INT
);

-- Employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    department_id INT,
    manager_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- Add foreign key to departments after employees is created
ALTER TABLE departments
ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

-- Projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15,2),
    department_id INT,
    status ENUM('Planning', 'In Progress', 'On Hold', 'Completed', 'Cancelled') DEFAULT 'Planning',
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Employee projects (many-to-many relationship)
CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    hours_assigned INT,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Clients table
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100) NOT NULL,
    industry VARCHAR(50),
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

-- Contracts table
CREATE TABLE contracts (
    contract_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    project_id INT,
    contract_date DATE,
    amount DECIMAL(15,2),
    payment_terms VARCHAR(100),
    status ENUM('Draft', 'Active', 'Completed', 'Terminated') DEFAULT 'Draft',
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    employee_id INT,
    client_id INT,
    sale_date DATETIME NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    total_amount DECIMAL(12,2) GENERATED ALWAYS AS (quantity * unit_price * (1 - discount)) STORED,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

-- Performance reviews
CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    reviewer_id INT,
    review_date DATE NOT NULL,
    performance_score DECIMAL(3,1),
    comments TEXT,
    goals TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees(employee_id)
);



-- Insert departments
INSERT INTO departments (department_name, location, budget) VALUES 
('Executive', 'Floor 10', 1000000.00),
('IT', 'Floor 5', 500000.00),
('Marketing', 'Floor 3', 300000.00),
('Sales', 'Floor 2', 350000.00),
('HR', 'Floor 1', 200000.00),
('Finance', 'Floor 4', 250000.00),
('Operations', 'Floor 6', 400000.00);

-- Insert employees (managers first)
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, salary) VALUES
('John', 'Smith', 'john.smith@company.com', '555-1001', '2010-05-15', 'CEO', 250000.00),
('Sarah', 'Johnson', 'sarah.johnson@company.com', '555-1002', '2012-03-10', 'CTO', 200000.00),
('Michael', 'Williams', 'michael.williams@company.com', '555-1003', '2013-07-22', 'Marketing Director', 180000.00),
('Emily', 'Brown', 'emily.brown@company.com', '555-1004', '2014-01-30', 'Sales Director', 175000.00),
('David', 'Jones', 'david.jones@company.com', '555-1005', '2011-11-05', 'HR Director', 160000.00),
('Jennifer', 'Miller', 'jennifer.miller@company.com', '555-1006', '2013-09-18', 'Finance Director', 170000.00),
('Robert', 'Davis', 'robert.davis@company.com', '555-1007', '2012-06-12', 'Operations Director', 185000.00);

-- Update departments with managers
UPDATE departments SET manager_id = 1 WHERE department_name = 'Executive';
UPDATE departments SET manager_id = 2 WHERE department_name = 'IT';
UPDATE departments SET manager_id = 3 WHERE department_name = 'Marketing';
UPDATE departments SET manager_id = 4 WHERE department_name = 'Sales';
UPDATE departments SET manager_id = 5 WHERE department_name = 'HR';
UPDATE departments SET manager_id = 6 WHERE department_name = 'Finance';
UPDATE departments SET manager_id = 7 WHERE department_name = 'Operations';

-- Insert more employees
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, salary, department_id, manager_id) VALUES
('James', 'Wilson', 'james.wilson@company.com', '555-1008', '2015-04-15', 'Senior Software Engineer', 120000.00, 2, 2),
('Jessica', 'Moore', 'jessica.moore@company.com', '555-1009', '2016-08-20', 'Software Engineer', 95000.00, 2, 8),
('Daniel', 'Taylor', 'daniel.taylor@company.com', '555-1010', '2017-02-10', 'Marketing Specialist', 85000.00, 3, 3),
('Lisa', 'Anderson', 'lisa.anderson@company.com', '555-1011', '2016-05-25', 'Sales Representative', 80000.00, 4, 4),
('Matthew', 'Thomas', 'matthew.thomas@company.com', '555-1012', '2018-03-15', 'HR Specialist', 75000.00, 5, 5),
('Amanda', 'Jackson', 'amanda.jackson@company.com', '555-1013', '2017-07-10', 'Financial Analyst', 90000.00, 6, 6),
('Christopher', 'White', 'christopher.white@company.com', '555-1014', '2018-01-22', 'Operations Manager', 110000.00, 7, 7),
('Ashley', 'Harris', 'ashley.harris@company.com', '555-1015', '2019-06-05', 'IT Support Specialist', 70000.00, 2, 8),
('Joshua', 'Martin', 'joshua.martin@company.com', '555-1016', '2018-11-12', 'Marketing Coordinator', 65000.00, 3, 3),
('Nicole', 'Thompson', 'nicole.thompson@company.com', '555-1017', '2019-04-18', 'Sales Associate', 70000.00, 4, 4),
('Andrew', 'Garcia', 'andrew.garcia@company.com', '555-1018', '2020-02-03', 'Recruiter', 68000.00, 5, 5),
('Megan', 'Martinez', 'megan.martinez@company.com', '555-1019', '2019-09-15', 'Accountant', 82000.00, 6, 6),
('Kevin', 'Robinson', 'kevin.robinson@company.com', '555-1020', '2020-01-10', 'Logistics Coordinator', 73000.00, 7, 7);

-- Insert projects
INSERT INTO projects (project_name, description, start_date, end_date, budget, department_id, status) VALUES
('Website Redesign', 'Complete overhaul of company website with modern design', '2023-01-15', '2023-06-30', 150000.00, 2, 'In Progress'),
('Product Launch', 'Marketing campaign for new product line', '2023-03-01', '2023-09-30', 200000.00, 3, 'Planning'),
('CRM Implementation', 'Implement new customer relationship management system', '2023-02-10', '2023-12-15', 300000.00, 2, 'In Progress'),
('Employee Training', 'Company-wide skills development program', '2023-01-05', '2023-04-30', 75000.00, 5, 'Completed'),
('Sales Expansion', 'Expand sales to new regional markets', '2023-04-01', '2023-11-30', 175000.00, 4, 'In Progress'),
('Financial System Upgrade', 'Upgrade accounting and financial reporting systems', '2023-05-15', '2023-10-31', 225000.00, 6, 'Planning');

-- Insert employee projects
INSERT INTO employee_projects (employee_id, project_id, role, hours_assigned) VALUES
(8, 1, 'Lead Developer', 200),
(9, 1, 'Frontend Developer', 150),
(8, 3, 'System Architect', 250),
(9, 3, 'Database Specialist', 180),
(10, 2, 'Campaign Manager', 120),
(11, 5, 'Sales Lead', 100),
(12, 4, 'Training Coordinator', 80),
(13, 6, 'Financial Analyst', 150),
(14, 1, 'QA Tester', 100),
(15, 2, 'Content Creator', 90),
(16, 5, 'Market Researcher', 70),
(17, 4, 'HR Specialist', 60),
(18, 6, 'Accountant', 120),
(19, 3, 'Support Technician', 90);

-- Insert clients
INSERT INTO clients (client_name, industry, contact_person, email, phone, address) VALUES
('Acme Corporation', 'Manufacturing', 'Tom Johnson', 'tom.johnson@acme.com', '555-2001', '123 Industrial Park, New York, NY'),
('Global Tech', 'Technology', 'Susan Lee', 'susan.lee@globaltech.com', '555-2002', '456 Tech Drive, San Francisco, CA'),
('Urban Retail', 'Retail', 'Mark Wilson', 'mark.wilson@urbanretail.com', '555-2003', '789 Shopping Lane, Chicago, IL'),
('Green Energy', 'Energy', 'Lisa Chen', 'lisa.chen@greenenergy.com', '555-2004', '321 Eco Way, Denver, CO'),
('Ocean Shipping', 'Logistics', 'David Brown', 'david.brown@oceanshipping.com', '555-2005', '654 Harbor Road, Miami, FL');

-- Insert contracts
INSERT INTO contracts (client_id, project_id, contract_date, amount, payment_terms, status) VALUES
(1, 1, '2022-12-15', 120000.00, '50% upfront, 50% on completion', 'Active'),
(2, 3, '2023-01-20', 250000.00, '30% upfront, 40% at midpoint, 30% on completion', 'Active'),
(3, 2, '2023-02-05', 180000.00, '25% upfront, 75% on completion', 'Draft'),
(4, 5, '2023-03-10', 150000.00, '50% upfront, 50% on completion', 'Active'),
(5, 6, '2023-04-01', 200000.00, '40% upfront, 30% at midpoint, 30% on completion', 'Draft');

-- Insert products
INSERT INTO products (product_name, description, unit_price, stock_quantity, department_id) VALUES
('Business Suite Pro', 'Comprehensive business management software', 499.99, 150, 2),
('Marketing Analytics', 'Advanced marketing data analysis tool', 299.99, 200, 3),
('Sales Tracker', 'CRM and sales performance monitoring', 199.99, 300, 4),
('HR Portal', 'Employee management and self-service portal', 349.99, 100, 5),
('Financial Dashboard', 'Real-time financial reporting system', 399.99, 120, 6),
('Operations Optimizer', 'Supply chain and logistics optimization', 449.99, 80, 7);

-- Insert sales
INSERT INTO sales (product_id, employee_id, client_id, sale_date, quantity, unit_price, discount) VALUES
(1, 4, 1, '2023-01-10 10:30:00', 5, 499.99, 0.10),
(3, 4, 3, '2023-01-15 14:45:00', 10, 199.99, 0.15),
(2, 11, 2, '2023-02-05 11:20:00', 8, 299.99, 0.05),
(5, 13, 4, '2023-02-20 09:15:00', 3, 399.99, 0.00),
(6, 19, 5, '2023-03-01 16:30:00', 2, 449.99, 0.20),
(4, 12, 1, '2023-03-10 13:10:00', 4, 349.99, 0.10),
(1, 11, 2, '2023-03-15 10:00:00', 6, 499.99, 0.12),
(3, 4, 3, '2023-03-20 15:45:00', 15, 199.99, 0.18);

-- Insert performance reviews
INSERT INTO performance_reviews (employee_id, reviewer_id, review_date, performance_score, comments, goals) VALUES
(8, 2, '2023-01-15', 4.5, 'Excellent technical skills and leadership. Needs to improve documentation.', 'Lead the website redesign project to completion. Mentor junior developers.'),
(9, 8, '2023-01-16', 4.2, 'Strong coding skills. Should work on communication with non-technical staff.', 'Complete frontend development for website project. Improve documentation.'),
(10, 3, '2023-01-17', 4.0, 'Creative marketer. Needs to be more data-driven in approach.', 'Develop successful product launch campaign. Improve analytics skills.'),
(11, 4, '2023-01-18', 4.7, 'Top performer in sales. Excellent client relationships.', 'Expand sales to 3 new regional markets. Mentor new sales associates.'),
(12, 5, '2023-01-19', 3.8, 'Good HR skills. Needs to be more proactive in recruitment.', 'Complete employee training program. Improve time management.'),
(13, 6, '2023-01-20', 4.3, 'Strong financial analysis. Should work on presenting findings more clearly.', 'Lead financial system upgrade. Improve presentation skills.'),
(14, 7, '2023-01-21', 3.9, 'Good operations management. Needs to improve cross-department coordination.', 'Streamline logistics processes. Improve interdepartmental communication.');

-- show all tables
select* from business_company.departments;
select* from business_company.employees ;
select* from business_company.projects;
select* from business_company.employee_projects;
select* from business_company.clients;
select* from business_company.contracts;
select* from business_company.products;
select* from business_company.sales;
select* from business_company.performance_reviews;

-- Analyze department performance based on projects and budgets
SELECT 
    d.department_name,
    COUNT(p.project_id) AS active_projects,
    SUM(p.budget) AS total_project_budgets,
    d.budget AS department_budget,
    CONCAT(FORMAT(SUM(p.budget / d.budget) * 100, 2), '%') AS budget_utilization_percent,
    COUNT(e.employee_id) AS employee_count,
    FORMAT(AVG(e.salary), 2) AS avg_salary
FROM 
    departments d
LEFT JOIN 
    projects p ON d.department_id = p.department_id AND p.status IN ('In Progress', 'Planning')
LEFT JOIN 
    employees e ON d.department_id = e.department_id
GROUP BY 
    d.department_id
ORDER BY 
    budget_utilization_percent DESC;
    
    
    
-- Show employee workload across projects
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    d.department_name,
    COUNT(ep.project_id) AS project_count,
    SUM(ep.hours_assigned) AS total_hours_assigned,
    CASE 
        WHEN SUM(ep.hours_assigned) > 300 THEN 'Overloaded'
        WHEN SUM(ep.hours_assigned) BETWEEN 150 AND 300 THEN 'Optimal'
        ELSE 'Underutilized'
    END AS workload_status
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
LEFT JOIN 
    employee_projects ep ON e.employee_id = ep.employee_id
LEFT JOIN 
    projects p ON ep.project_id = p.project_id AND p.status IN ('In Progress', 'Planning')
GROUP BY 
    e.employee_id
ORDER BY 
    total_hours_assigned DESC;
    
    
    
-- Analyze sales performance by employee and product
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS sales_rep,
    d.department_name,
    p.product_name,
    COUNT(s.sale_id) AS sales_count,
    SUM(s.quantity) AS units_sold,
    FORMAT(SUM(s.total_amount), 2) AS total_revenue,
    FORMAT(AVG(s.discount * 100), 2) AS avg_discount_percent,
    FORMAT(SUM(s.total_amount) / COUNT(DISTINCT MONTH(s.sale_date)), 2) AS monthly_avg_revenue
FROM 
    sales s
JOIN 
    employees e ON s.employee_id = e.employee_id
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    e.employee_id, p.product_id
ORDER BY 
    total_revenue DESC;
    
    
-- Analyze sales performance by employee and product
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS sales_rep,
    d.department_name,
    p.product_name,
    COUNT(s.sale_id) AS sales_count,
    SUM(s.quantity) AS units_sold,
    FORMAT(SUM(s.total_amount), 2) AS total_revenue,
    FORMAT(AVG(s.discount * 100), 2) AS avg_discount_percent,
    FORMAT(SUM(s.total_amount) / COUNT(DISTINCT MONTH(s.sale_date)), 2) AS monthly_avg_revenue
FROM 
    sales s
JOIN 
    employees e ON s.employee_id = e.employee_id
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    e.employee_id, p.product_id
ORDER BY 
    total_revenue DESC;
    
    
-- Compare employee performance with their compensation
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    d.department_name,
    e.salary,
    pr.performance_score,
    CASE 
        WHEN pr.performance_score >= 4.5 THEN 'Top Performer'
        WHEN pr.performance_score >= 4.0 THEN 'High Performer'
        WHEN pr.performance_score >= 3.5 THEN 'Solid Performer'
        WHEN pr.performance_score >= 3.0 THEN 'Needs Improvement'
        ELSE 'Underperforming'
    END AS performance_category,
    FORMAT(e.salary / (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) * 100, 2) AS salary_vs_dept_avg,
    CASE 
        WHEN pr.performance_score >= 4.5 AND e.salary < (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) THEN 'Underpaid'
        WHEN pr.performance_score < 3.5 AND e.salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) THEN 'Overpaid'
        ELSE 'Appropriate'
    END AS pay_status
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    performance_reviews pr ON e.employee_id = pr.employee_id
WHERE 
    pr.review_date = (SELECT MAX(review_date) FROM performance_reviews WHERE employee_id = e.employee_id)
ORDER BY 
    performance_score DESC, salary_vs_dept_avg DESC;
    
    
-- Analyze client profitability based on contracts and sales
-- Analyze client profitability based on contracts and sales
SELECT 
    c.client_id,
    c.client_name,
    c.industry,
    COUNT(DISTINCT ct.contract_id) AS contract_count,
    FORMAT(SUM(ct.amount), 2) AS total_contract_value,
    COUNT(DISTINCT s.sale_id) AS product_sales_count,
    FORMAT(SUM(s.total_amount), 2) AS total_product_sales,
    FORMAT(SUM(IFNULL(ct.amount, 0) + SUM(IFNULL(s.total_amount, 0)), 2) AS total_revenue,
    FORMAT((SUM(IFNULL(ct.amount, 0) + SUM(IFNULL(s.total_amount, 0))) / 
          (SELECT SUM(amount) + SUM(total_amount) FROM contracts LEFT JOIN sales ON contracts.client_id = sales.client_id) * 100, 2) AS revenue_percentage
FROM 
    clients c
LEFT JOIN 
    contracts ct ON c.client_id = ct.client_id
LEFT JOIN 
    sales s ON c.client_id = s.client_id
GROUP BY 
    c.client_id
ORDER BY 
    total_revenue DESC;
    
    
    
-- Identify cross-selling opportunities based on client purchases
SELECT 
    c.client_id,
    c.client_name,
    GROUP_CONCAT(DISTINCT p1.product_name ORDER BY p1.product_name SEPARATOR ', ') AS purchased_products,
    GROUP_CONCAT(DISTINCT p2.product_name ORDER BY p2.product_name SEPARATOR ', ') AS potential_products,
    COUNT(DISTINCT s.sale_id) AS purchase_count,
    FORMAT(SUM(s.total_amount), 2) AS total_spent
FROM 
    clients c
JOIN 
    sales s ON c.client_id = s.client_id
JOIN 
    products p1 ON s.product_id = p1.product_id
JOIN 
    products p2 ON p1.department_id = p2.department_id AND p1.product_id != p2.product_id
WHERE 
    NOT EXISTS (
        SELECT 1 FROM sales 
        WHERE client_id = c.client_id AND product_id = p2.product_id
    )
GROUP BY 
    c.client_id
HAVING 
    COUNT(DISTINCT p1.product_id) >= 1
ORDER BY 
    total_spent DESC;
    
    
    -- Optimize resource allocation across projects
WITH project_resources AS (
    SELECT 
        p.project_id,
        p.project_name,
        p.budget,
        p.status,
        d.department_name,
        SUM(ep.hours_assigned) AS total_hours_assigned,
        COUNT(DISTINCT ep.employee_id) AS employee_count,
        SUM(e.salary * ep.hours_assigned / 160) AS estimated_labor_cost,
        SUM(ep.hours_assigned) / COUNT(DISTINCT ep.employee_id) AS avg_hours_per_employee
    FROM 
        projects p
    JOIN 
        departments d ON p.department_id = d.department_id
    LEFT JOIN 
        employee_projects ep ON p.project_id = ep.project_id
    LEFT JOIN 
        employees e ON ep.employee_id = e.employee_id
    WHERE 
        p.status IN ('In Progress', 'Planning')
    GROUP BY 
        p.project_id
),
department_capacity AS (
    SELECT 
        d.department_id,
        d.department_name,
        COUNT(e.employee_id) AS total_employees,
        SUM(CASE WHEN ep.employee_id IS NOT NULL THEN 1 ELSE 0 END) AS allocated_employees,
        COUNT(e.employee_id) - SUM(CASE WHEN ep.employee_id IS NOT NULL THEN 1 ELSE 0 END) AS available_employees
    FROM 
        departments d
    JOIN 
        employees e ON d.department_id = e.department_id
    LEFT JOIN 
        employee_projects ep ON e.employee_id = ep.employee_id
    LEFT JOIN 
        projects p ON ep.project_id = p.project_id AND p.status IN ('In Progress', 'Planning')
    GROUP BY 
        d.department_id
)
SELECT 
    pr.project_id,
    pr.project_name,
    pr.department_name,
    pr.status,
    pr.employee_count,
    dc.total_employees,
    dc.available_employees,
    pr.total_hours_assigned,
    pr.avg_hours_per_employee,
    CASE 
        WHEN pr.avg_hours_per_employee > 200 THEN 'Overallocated'
        WHEN pr.avg_hours_per_employee < 100 THEN 'Underallocated'
        ELSE 'Balanced'
    END AS allocation_status,
    pr.estimated_labor_cost,
    pr.budget,
    FORMAT((pr.estimated_labor_cost / pr.budget) * 100, 2) AS labor_cost_percentage
FROM 
    project_resources pr
JOIN 
    department_capacity dc ON pr.department_name = dc.department_name
ORDER BY 
    allocation_status, labor_cost_percentage DESC;
    
    
-- Identify employees at risk of leaving based on performance and compensation
-- Identify employees at risk of leaving based on performance and compensation
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    d.department_name,
    e.hire_date,
    DATEDIFF(CURDATE(), e.hire_date) / 365 AS years_with_company,
    e.salary,
    FORMAT(e.salary / (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) * 100, 2) AS salary_vs_dept_avg,
    pr.performance_score,
    CASE 
        WHEN DATEDIFF(CURDATE(), pr.review_date) > 180 THEN 'Overdue for review'
        ELSE 'Reviewed recently'
    END AS review_status,
    CASE 
        WHEN DATEDIFF(CURDATE(), e.hire_date) / 365 BETWEEN 3 AND 5 AND e.salary < (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) THEN 'High Risk'
        WHEN pr.performance_score >= 4.0 AND e.salary < (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) THEN 'Medium Risk'
        WHEN DATEDIFF(CURDATE(), pr.review_date) > 365 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS retention_risk
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    performance_reviews pr ON e.employee_id = pr.employee_id
WHERE 
    pr.review_date = (SELECT MAX(review_date) FROM performance_reviews WHERE employee_id = e.employee_id)
ORDER BY 
    CASE retention_risk
        WHEN 'High Risk' THEN 1
        WHEN 'Medium Risk' THEN 2
        ELSE 3
    END,
    years_with_company DESC;
    
    
-- Create indexes for performance optimization
CREATE INDEX idx_employee_department ON employees(department_id);
CREATE INDEX idx_employee_manager ON employees(manager_id);
CREATE INDEX idx_project_department ON projects(department_id);
CREATE INDEX idx_sale_product ON sales(product_id);
CREATE INDEX idx_sale_employee ON sales(employee_id);
CREATE INDEX idx_sale_client ON sales(client_id);
CREATE INDEX idx_sale_date ON sales(sale_date);

-- Create a view for employee project assignments
CREATE VIEW employee_project_assignments AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    d.department_name,
    p.project_name,
    p.status AS project_status,
    ep.role,
    ep.hours_assigned,
    p.start_date,
    p.end_date,
    DATEDIFF(p.end_date, CURDATE()) AS days_remaining
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
JOIN 
    employee_projects ep ON e.employee_id = ep.employee_id
JOIN 
    projects p ON ep.project_id = p.project_id;

-- Create a stored procedure for employee promotion
DELIMITER //
CREATE PROCEDURE promote_employee(
    IN emp_id INT,
    IN new_title VARCHAR(100),
    IN new_salary DECIMAL(10,2),
    IN new_dept_id INT,
    IN effective_date DATE
)
BEGIN
    DECLARE old_dept_id INT;
    DECLARE old_manager_id INT;
    
    -- Get current department and manager
    SELECT department_id, manager_id INTO old_dept_id, old_manager_id
    FROM employees WHERE employee_id = emp_id;
    
    -- Update employee record
    UPDATE employees 
    SET 
        job_title = new_title,
        salary = new_salary,
        department_id = new_dept_id,
        manager_id = (SELECT manager_id FROM departments WHERE department_id = new_dept_id)
    WHERE employee_id = emp_id;
    
    -- Log the promotion
    INSERT INTO employee_promotions (employee_id, old_title, new_title, old_salary, new_salary, old_department_id, new_department_id, promotion_date)
    VALUES (emp_id, 
           (SELECT job_title FROM employees WHERE employee_id = emp_id),
           new_title,
           (SELECT salary FROM employees WHERE employee_id = emp_id),
           new_salary,
           old_dept_id,
           new_dept_id,
           effective_date);
    
    -- If the employee was a manager, update the department
    IF EXISTS (SELECT 1 FROM departments WHERE manager_id = emp_id) THEN
        UPDATE departments SET manager_id = old_manager_id WHERE manager_id = emp_id;
    END IF;
    
    COMMIT;
END //
DELIMITER ;

-- Create a trigger to update department budget when project is completed
DELIMITER //
CREATE TRIGGER after_project_completion
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed' AND OLD.status != 'Completed' THEN
        UPDATE departments 
        SET budget = budget + (NEW.budget * 0.1) -- Add 10% of project budget back to department
        WHERE department_id = NEW.department_id;
    END IF;
END //
DELIMITER ;
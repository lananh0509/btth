CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    salary DECIMAL(10, 2)
);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255) UNIQUE
);

CREATE TABLE employee_departments (
    employee_id INT,
    department_id INT,
    PRIMARY KEY (employee_id, department_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Viết câu lệnh SQL để liệt kê tất cả các nhân viên trong bộ phận có tên là "Kế toán". Kết quả cần hiển thị mã nhân viên và tên nhân viên.
SELECT e.employee_id, e.name
FROM employees e
JOIN employee_departments ed ON e.employee_id = ed.employee_id
JOIN departments d ON ed.department_id = d.department_id
WHERE d.department_name = 'ke toan';

-- Viết câu lệnh SQL để tìm các nhân viên có mức lương lớn hơn 50,000. Kết quả trả về cần bao gồm mã nhân viên, tên nhân viên và mức lương.
SELECT employee_id, name, salary
FROM employees
WHERE salary > 50000;

-- Viết câu lệnh SQL để hiển thị tất cả các bộ phận và số lượng nhân viên trong từng bộ phận. Kết quả trả về cần bao gồm tên bộ phận và số lượng nhân viên.
SELECT d.department_name, COUNT(ed.employee_id) AS employee_count
FROM departments d
JOIN employee_departments ed ON d.department_id = ed.department_id
GROUP BY d.department_name;

-- Viết câu lệnh SQL để tìm ra các thành viên có mức lương cao nhất theo từng bộ phận. Kết quả trả về là một danh sách theo bất cứ thứ tự nào. Nếu có nhiều nhân viên bằng lương nhau nhưng cũng là mức lương cao nhất thì hiển thị tất cả những nhân viên đó ra.
SELECT e.employee_id, e.name, e.salary, d.department_name
FROM employees e
JOIN employee_departments ed ON e.employee_id = ed.employee_id
JOIN departments d ON ed.department_id = d.department_id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    JOIN employee_departments ed2 ON e2.employee_id = ed2.employee_id
    WHERE ed2.department_id = ed.department_id
);

-- Viết câu lệnh SQL để tìm các bộ phận có tổng mức lương của nhân viên vượt quá 100,000 (hoặc một mức tùy chọn khác). Kết quả trả về bao gồm tên bộ phận và tổng mức lương của bộ phận đó.
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN employee_departments ed ON e.employee_id = ed.employee_id
JOIN departments d ON ed.department_id = d.department_id
GROUP BY d.department_name
HAVING SUM(e.salary) > 100000;

-- Viết câu lệnh SQL để liệt kê tất cả các nhân viên làm việc trong hơn 2 bộ phận khác nhau. Kết quả cần hiển thị mã nhân viên, tên nhân viên và số lượng bộ phận mà họ tham gia.
SELECT e.employee_id, e.name, COUNT(DISTINCT ed.department_id) AS department_count
FROM employees e
JOIN employee_departments ed ON e.employee_id = ed.employee_id
GROUP BY e.employee_id, e.name
HAVING COUNT(DISTINCT ed.department_id) > 2;


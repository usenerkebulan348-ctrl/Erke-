DROP SCHEMA IF EXISTS ecommerce CASCADE;
DROP TABLE IF EXISTS order_items, orders, products_fk, categories, books, publishers, authors, employees_dept, departments, student_courses, course_enrollments, users, inventory, customers, bookings, products_catalog, employees CASCADE;

CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);

CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (regular_price > 0 AND discount_price > 0 AND discount_price < regular_price)
);

CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10),
    CHECK (check_out_date > check_in_date)
);

INSERT INTO employees VALUES (1, 'Aigerim', 'Nurlanova', 25, 450000), (2, 'Daniyar', 'Sagyndykov', 40, 800000);
INSERT INTO products_catalog VALUES (1, 'Laptop', 500000, 450000), (2, 'Phone', 300000, 250000);
INSERT INTO bookings VALUES (1, '2026-11-01', '2026-11-05', 2), (2, '2026-12-20', '2026-12-27', 10);

CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

INSERT INTO customers VALUES (1, 'aigerim@mail.kz', '+77011234567', '2026-01-15'), (2, 'asel@mail.kz', NULL, '2026-03-05');
INSERT INTO inventory VALUES (1, 'Notebook', 100, 450, NOW()), (2, 'Pen', 500, 50.5, NOW());

CREATE TABLE users (
    user_id INTEGER,
    username TEXT,
    email TEXT,
    created_at TIMESTAMP,
    CONSTRAINT unique_username UNIQUE (username),
    CONSTRAINT unique_email UNIQUE (email)
);

CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);

INSERT INTO users VALUES (1, 'aigerim', 'aigerim@mail.kz', NOW()), (2, 'daniyar', 'daniyar@mail.kz', NOW());
INSERT INTO course_enrollments VALUES (1, 100, 'CS101', 'Fall2026'), (2, 100, 'CS101', 'Spring2027');

CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO departments VALUES (1, 'IT', 'Almaty'), (2, 'HR', 'Astana'), (3, 'Finance', 'Shymkent');
INSERT INTO student_courses VALUES (1, 10, '2026-09-01', 'A'), (1, 20, '2026-09-01', 'B');

CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments,
    hire_date DATE
);

INSERT INTO employees_dept VALUES (1, 'Aigerim', 1, '2025-03-01'), (2, 'Daniyar', 2, '2025-06-15');

CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors,
    publisher_id INTEGER REFERENCES publishers,
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

INSERT INTO authors VALUES (1, 'Abai Kunanbayev', 'Kazakhstan'), (2, 'George Orwell', 'UK');
INSERT INTO publishers VALUES (1, 'Zhazushy', 'Almaty'), (2, 'Penguin Books', 'London');
INSERT INTO books VALUES (1, 'Words of Edification', 1, 1, 1998, '978-601-01'), (2, '1984', 2, 2, 1949, '978-0-14-10');

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk,
    quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories VALUES (1, 'Electronics'), (2, 'Books');
INSERT INTO products_fk VALUES (1, 'Laptop', 1), (2, 'Textbook', 2);
INSERT INTO orders VALUES (1, '2026-10-01'), (2, '2026-10-05');
INSERT INTO order_items VALUES (1, 1, 1, 1), (2, 1, 2, 2), (3, 2, 1, 1);

DELETE FROM orders WHERE order_id = 1;
SELECT * FROM order_items;

CREATE SCHEMA ecommerce;

CREATE TABLE ecommerce.customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE ecommerce.products (
    product_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0)
);

CREATE TABLE ecommerce.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES ecommerce.customers ON DELETE RESTRICT,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);

CREATE TABLE ecommerce.order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES ecommerce.orders ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES ecommerce.products ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0)
);

INSERT INTO ecommerce.customers (name, email, phone) VALUES
    ('Aigerim', 'aigerim@mail.kz', '+77011112233'),
    ('Daniyar', 'daniyar@mail.kz', '+77022223344'),
    ('Asel', 'asel@mail.kz', NULL),
    ('Timur', 'timur@mail.kz', '+77044445566'),
    ('Dana', 'dana@mail.kz', '+77055556677');

INSERT INTO ecommerce.products (name, description, price, stock_quantity) VALUES
    ('Laptop', '15-inch', 450000, 20),
    ('Smartphone', '128GB', 250000, 50),
    ('Headphones', 'Wireless', 35000, 100),
    ('Keyboard', 'Mechanical', 25000, 75),
    ('Mouse', 'Optical', 8000, 200);

INSERT INTO ecommerce.orders (customer_id, total_amount, status) VALUES
    (1, 485000, 'delivered'),
    (2, 250000, 'shipped'),
    (3, 43000, 'processing'),
    (4, 25000, 'pending'),
    (5, 35000, 'cancelled');

INSERT INTO ecommerce.order_details (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 450000),
    (1, 3, 1, 35000),
    (2, 2, 1, 250000),
    (3, 5, 1, 8000),
    (4, 4, 1, 25000);
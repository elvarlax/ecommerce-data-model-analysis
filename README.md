# Ecommerce Data Model and Analysis

## Dataset
The dataset has been anonymized and comprises a subset of more than 3 million grocery orders placed by over 200,000 users on Instacart. Each user's dataset includes a variable number of orders, ranging from 4 to 100, showcasing the sequence of products purchased in each order. Additionally, the dataset includes information about the week and time of day when the orders were placed, along with a relative measure of time between consecutive orders.

You can download the dataset from [Kaggle](https://www.kaggle.com/competitions/instacart-market-basket-analysis/data).

## Entity-Relationship (ER) Model
![Entity-Relationship (ER) Model](https://github.com/elvarlax/ecommerce-data-model-analysis/blob/main/er_model.jpg)

## Data Model

The data model consists of the following tables:

- `aisles`: Contains information about different aisles.
- `departments`: Contains information about different departments.
- `products`: Contains information about different products, including their aisle and department.
- `orders`: Contains information about orders, including user ID, order number, and timing information.
- `order_products`: Represents the relationship between orders and products, including additional information such as add-to-cart order and whether the product was reordered.

```sql
CREATE TABLE aisles (
    aisle_id INTEGER PRIMARY KEY,
    aisle VARCHAR(255)
);

CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department VARCHAR(255)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    aisle_id INTEGER,
    department_id INTEGER,
    product_name VARCHAR(255),
    FOREIGN KEY (aisle_id) REFERENCES aisles (aisle_id),
    FOREIGN KEY (department_id) REFERENCES departments (department_id)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    order_number INTEGER,
    order_dow INTEGER,
    order_hour_of_day INTEGER,
    days_since_prior_order INTEGER
);

CREATE TABLE order_products (
    order_id INTEGER,
    product_id INTEGER,
    add_to_cart_order INTEGER,
    reordered INTEGER,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);
```

## Contents
- `data/`: Folder where the dataset CSV files should be stored.
- `data_model.ipynb`: Jupyter Notebook for creating the data model and inserting data into PostgreSQL.
- `practice_questions.sql`: SQL script containing practice questions and corresponding queries.

## Instructions
1. Clone this repository to your local machine.
2. Download the dataset from Kaggle and place the CSV files in the `data/` folder.
3. Open and run the `data_model.ipynb` Jupyter Notebook to create the data model and insert data into PostgreSQL.
4. Run the SQL queries in `practice_questions.sql` to perform analysis on the dataset.

### Install Packages
```
pip install pandas
pip install psycopg2
pip install SQLAlchemy
```

## Practice Questions

1. Create a temporary table that joins the orders, order_products, and products tables to get information about each order, including the products that were purchased and their department and aisle information.
2. Create a temporary table that groups the orders by product and finds the total number of times each product was purchased, the total number of times each product was reordered, and the average number of times each product was added to a cart.
3. Create a temporary table that groups the orders by department and finds the total number of products purchased, the total number of unique products purchased, the total number of products purchased on weekdays vs weekends, and the average time of day that products in each department are ordered.
4. Create a temporary table that groups the orders by aisle and finds the top 10 most popular aisles, including the total number of products purchased and the total number of unique products purchased from each aisle.
5. Combine the information from the previous temporary tables into a final table that shows the product ID, product name, department ID, department name, aisle ID, aisle name, total number of times purchased, total number of times reordered, average number of times added to cart, total number of products purchased, total number of unique products purchased, total number of products purchased on weekdays, total number of products purchased on weekends, and average time of day products are ordered in each department.

[Click here to access my solution to the practice questions](https://github.com/elvarlax/ecommerce-data-model-analysis/blob/main/practice_questions.sql)
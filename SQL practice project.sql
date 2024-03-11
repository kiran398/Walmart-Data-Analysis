CREATE DATABASE if not exists saleDataWalmart;
CREATE TABLE if not exists sales(
      invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
      branch VARCHAR(5) NOT NULL,
      city VARCHAR(30),
      customer_type VARCHAR(30) NOT NULL,
      gender VARCHAR(10),
      product_line VARCHAR(100),
      unit_price DECIMAL(10,2),
      quantity INT NOT NULL,
      vat FLOAT(6,4) NOT NULL,
      total DECIMAL(10,2),
      date DATE NOT NULL,
      time TIME NOT NULL,
      payment_method VARCHAR(15) NOT NULL,
      cogs DECIMAL (10,2) NOT NULL,
      gross_margin_percentage FLOAT(11,9),
      gross_income DECIMAL(10,2)  NOT NULL,
      rating FLOAT (2,1)      
);

                            -- Feature Engineering --
-- time_of_day
SELECT 
    time,
	(CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning" 
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END) AS time_of_date
FROM sales;
 
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20); 
UPDATE sales
SET time_of_day =(
		CASE
			WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning" 
			WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
			ELSE "Evening"
		END);

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10); 
UPDATE sales 
SET day_name =DAYNAME(date);

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20); 
UPDATE sales 
SET month_name =MONTHNAME(date);

-- How many unique cities does the data have?
SELECT DISTINCT city from sales;
SELECT DISTINCT branch from sales;

-- In which city is each branch?
SELECT DISTINCT city,branch from sales; 

                           -- PRODUCT --

-- Unique product line data have
SELECT COUNT(DISTINCT product_line) FROM sales;

-- What is the most common payment method?
SELECT 
	payment_method, 
    COUNT(payment_method) AS count
from sales 
GROUP BY payment_method
ORDER BY count desc;

-- What is the most selling product line?
SELECT 
 	product_line, 
    COUNT(product_line) AS count
from sales 
GROUP BY product_line
ORDER BY count desc;

-- What is the total revenue by month?
SELECT 
	SUM(total) AS total_revenue, 
    month_name as month
	from sales
    GROUP BY month_name
    ORDER BY total_revenue DESC ;
    
-- What month had the largest COGS?
SELECT SUM(cogs) AS cogs,
	month_name AS month 
	from sales
    GROUP BY month_name;
    
   -- What product line had the largest revenue?
SELECT SUM(total) AS max_revenue, 
		product_line
		from sales
        GROUP BY product_line
        ORDER BY max_revenue DESC;
        
-- What is the city with the largest revenue?
SELECT 
	SUM(total) AS max_revenue,
    city
    from sales
    GROUP BY city
    ORDER BY max_revenue DESC;
    
-- What product line had the largest VAT?
SELECT product_line,
	AVG(vat) as avg_vat 
	from sales
    GROUP BY product_line
    ORDER BY avg_vat DESC;
    
-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(total) AS avg_total,
    product_line
    from sales
    GROUP BY product_line;
    
-- Which branch sold more products than average product sold?
SELECT
	branch, 
    SUM(quantity) AS qty
	FROM sales
    GROUP BY branch
    HAVING SUM(quantity) > (SELECT AVG(quantity) from sales)
    ;
    
-- What is the most common product line by gender?alter

SELECT 
	gender,
	product_line,
    COUNT(gender) as total_cnt
    FROM sales
    GROUP BY product_line,gender
    ORDER BY total_cnt DESC;
    
-- What is the average rating of each product line?
SELECT 
	ROUND(AVG(rating),2) as avg_rating,
    product_line
    FROM sales
    GROUP BY product_line;
     
                -- SALES --
    
-- Number of sales made in each time of the day per weekday
SELECT 
	SUM(quantity) AS no_of_sales,
	time_of_day
    FROM sales
    WHERE day_name='Sunday'
    GROUP BY time_of_day
    ORDER BY no_of_sales DESC;
    
-- Which of the customer types brings the most revenue?
SELECT 
	customer_type,
    SUM(total) AS total_revenue
    FROM sales
    GROUP BY customer_type
    ORDER BY total_revenue DESC;
    
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
	ROUND(AVG(vat),2) AS max_vat,
    city
    FROM sales
    GROUP BY city
    ORDER BY max_vat DESC;
    
-- Which customer type pays the most in VAT?
SELECT 
	ROUND(AVG(vat),2) AS max_vat,
    customer_type
    FROM sales
    GROUP BY customer_type
    ORDER BY max_vat DESC;
	
                        -- CUSTOMER --
-- How many unique customer types does the data have?
SELECT 
	DISTINCT customer_type
    FROM sales
    GROUP BY customer_type;
    
-- How many unique payment methods does the data have?
SELECT 
	DISTINCT payment_method
    FROM sales
    GROUP BY payment_method;

-- What is the most common customer type?
SELECT 
	customer_type,
	COUNT(customer_type) AS no_of_customer
    FROM sales
    GROUP BY customer_type
    ORDER BY no_of_customer DESC;
    
-- Which customer type buys the most?
SELECT
	SUM(quantity) as total_qty,
    customer_type
    FROM sales
    GROUP BY customer_type
     ORDER BY total_qty DESC;
     
-- What is the gender of most of the customers?
SELECT
	COUNT(gender) as gender_count,
    gender
    FROM sales
    GROUP BY gender;
    
-- What is the gender distribution per branch?
SELECT
	COUNT(gender) as gender_count,
    gender,
    branch
    FROM sales
    GROUP BY branch,gender
    ORDER BY gender_count DESC;
    
-- Which time of the day do customers give most ratings?
SELECT 
	ROUND(AVG(rating),2) AS avg_rate,
    time_of_day
    FROM sales
    GROUP BY time_of_day
    ORDER BY avg_rate DESC;
    
-- Which time of the day do customers give most ratings per branch?
SELECT 
	ROUND(AVG(rating),2) AS avg_rate,
    branch,
    time_of_day
    FROM sales
    GROUP BY time_of_day,branch
    ORDER BY branch DESC;
    
-- Which day of the week has the best avg ratings?
SELECT
	ROUND(AVG(rating),2) AS avg_rate,
	day_name
    FROM sales
    GROUP BY day_name
    ORDER BY avg_rate DESC;
    
-- Which day of the week has the best average ratings per branch?
SELECT
	ROUND(AVG(rating),2) AS avg_rate,
    branch,
	day_name
    FROM sales
    GROUP BY day_name,branch
    ORDER BY branch, avg_rate DESC;
    
	





	



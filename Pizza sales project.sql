use pizzasales;
Select * from orders;
Select * from order_details;
Select * from pizzas;
Select * from pizza_types;


#QUERIES:

-- 1.Retrieve total orders received each day?
 
			SELECT 
				date, COUNT(order_id) AS Number_of_orders
			FROM
				orders
			GROUP BY date
			ORDER BY date;


-- 2.Retrieve the details of a specific order?

			SELECT 
				*
			FROM
				orders o
					JOIN
				order_details od ON o.order_id = od.order_id
					JOIN
				pizzas p ON od.pizza_id = p.pizza_id
					JOIN
				pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
			WHERE
				o.order_id = 2;


-- 3.Retrieve the total sales for a specific pizza type?
-- Ans: The total sales done by "The Big Meat Pizza" Is $22968.



			SELECT 
				   sum(p.price * od.quantity) AS total_sales
			FROM  
				Order_details od
					JOIN
				Pizzas p ON od.pizza_id = p.Pizza_id
					JOIN
				Pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
			WHERE
				pt.name = 'The Big Meat Pizza';
    
    
    
--   4.Retrieve the top 5 selling pizza types(Quantity wise) in  "supreme" category?
--  ANS:  
/* The Sicilian Pizza	                    1938
   The Spicy Italian Pizza	                1924
   The Italian Supreme Pizza	            1884
   The Prosciutto and Arugula Pizza	        1457
   The Pepper Salami Pizza	                1446   */    
			
            SELECT 
				   Pt.name, sum(od.quantity) AS total_quantity
			FROM  
				Order_details od
					JOIN
				Pizzas p ON od.pizza_id = p.Pizza_id
					JOIN
				Pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
				where pt.category = 'supreme'
				group by pt.name
				order by total_quantity desc
				limit 5;
    
    
-- 5.Retrieve the average order size for each day of the week?

			
            SELECT 
				DAYNAME(date) AS day_of_week, 
				AVG(od.quantity) AS avg_order_size
			FROM  
				Orders o
				JOIN 
				Order_details od ON o.Order_id = od.order_id
			GROUP BY 
				DAYNAME(date), DAYOFWEEK(date)
			ORDER BY 
				DAYOFWEEK(date);
    
    
    
-- 6.Retrieve the customers who have placed the most repeat orders?
-- Ans: There are 36 customers who have ordered (max. repeat orders = 3)
			
            
            Select od.order_id, p.pizza_type_id, count(od.pizza_id) as repeat_orders
			from order_details od
			join pizzas p ON p.pizza_id = od.pizza_id

			group by od.order_id, p.pizza_type_id
			having repeat_orders > 2 
			order by  od.order_id desc
			 ;


-- 7.Retrieve the total sales for each pizza size?
-- Ans: 
   /*    M	$ 249382.25
	     L	$ 375318.70
	     S	$ 178076.50
        XL	$ 14076.00
	   XXL	$ 1006.60       */
			
           
           
           SELECT 
			 p.size,  sum(p.price * od.quantity) AS total_sales
		FROM  
			Order_details od
				JOIN
			Pizzas p ON od.pizza_id = p.Pizza_id
			group by p.size;
    
    
-- 8.Retrieve the total sales for each pizza category?
 -- Ans:    CATEGORY   SALES
      /*    Chicken	  11050
			Classic   14888
			Supreme	  11987
			Veggie	  11649   */
		 
         
         
         SELECT 
		   Pt.category, sum(od.quantity) AS total_sales
	FROM  
		Order_details od
			JOIN
		Pizzas p ON od.pizza_id = p.Pizza_id
			JOIN
		Pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
			group by pt.category;
        
        
        
        
-- 9.Retrieve the average order size for each pizza type?


		SELECT pt.name, AVG(od.quantity) AS avg_order_size
		FROM Order_details od
		JOIN Pizzas p ON od.pizza_id = p.Pizza_id
		JOIN Pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
		GROUP BY pt.name;


-- 10.Retrieve the number of orders placed during each hour of the day
 -- Ans:   MAX. orders  occurred at 12th hour of the day.     
		
        
        SELECT 
			HOUR(time) hour_of_the_day, COUNT(*) AS num_of_orders
		FROM
			orders
		GROUP BY HOUR(time)
		ORDER BY HOUR(time);






-- 11.Retrieve the number of orders placed on each day of the week
-- Ans: 
/*      Sunday	    2624
		Monday	    2794
		Tuesday	    2973
		Wednesday	3024
		Saturday	3158
		Thursday	3239
		Friday	    3538
		*/
       
       
       SELECT dayname(date) as weekday, count(*) as num_of_orders
		from orders
		group by weekday
		order by num_of_orders;




-- 12.Retrieve the number of orders placed in each month?
-- Ans.:  Maximum orders came in "JULY".

		
        SELECT monthname(date) as month , count(*) as num_of_orders
		from orders
		group by month
		;


-- 13.Retrieve the top 2 selling pizza types for each pizza size?
-- ANS:  
	/*      L	The Thai Chicken Pizza	      1410
			L	The Five Cheese Pizza	      1409
			M	The Classic Deluxe Pizza	  1181
			M	The Barbecue Chicken Pizza	   956
			S	The Big Meat Pizza	          1914
			S	The Hawaiian Pizza	          1020
			XL	The Greek Pizza	               552
			XXL	The Greek Pizza	                28   */
		
        SELECT *
        From
        (SELECT p.size, pt.name, SUM(od.quantity) AS total_quantity_sold,
               Rank() Over(partition by p.size  order by Sum(od.quantity) desc) as rnk
		FROM Order_details od
		JOIN Pizzas p ON od.pizza_id = p.Pizza_id
		JOIN Pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
		GROUP BY p.size, pt.name
		ORDER BY p.size, total_quantity_sold DESC) as a
        Where a.rnk IN (1,2)
		;


-- 14.Retrieve the number of orders placed by each customer?

		
        
        SELECT o.order_id as customers_id, sum(od.quantity) as num_of_orders_placed
		from orders o
		join order_details od on o.order_id = od.order_id
		group by o.order_id;



-- 15.Retrieve the top 5 customers who have placed the largest orders(in terms of sales)?
-- Ans:     order_id     Largest_orders(Saleswise)
		/*      18845	444.20
				10760	417.15
				1096	285.15
				6169	284.00
				740	    280.95     */
        
        Select o.order_id, sum(od.quantity*p.price) as largest_orders
		from orders o
		join order_details od ON od.order_id = o.order_id
		join pizzas p ON p.pizza_id = od.pizza_id
		group by o.order_id
		order by largest_orders desc
		limit 5;
    
    
-- 16.Retrieve the most popular pizza size?
-- ANS: Most popular size was L with 18526 Total orders



		SELECT p.size, count(od.quantity) as total_orders
		from order_details od
		join pizzas p ON p.pizza_id = od.pizza_id
		group by p.size
		order by total_orders desc
		limit 1;



-- 17.Retrieve the top 5 pizza that are ordered most number of times?
-- ANS:  
		/*  The Classic Deluxe Pizza	2453
			The Barbecue Chicken Pizza	2432
			The Hawaiian Pizza	         2422
			The Pepperoni Pizza	        2418
			The Thai Chicken Pizza	     2371     */
        
	    
        
        Select pt.name, sum(od.quantity) as num_of_orders
		from order_details od
		join pizzas p ON p.pizza_id = od.pizza_id
		join pizza_types pt ON Pt.pizza_type_id = p.pizza_type_id
		group by pt.name
		order by num_of_orders desc
		limit 5;




-- 18.Retrieve the Bottom 5 pizza that are ordered least number of times?
 -- ANS:    
    /*      The Brie Carre Pizza	    490
			The Mediterranean Pizza	    934
			The Calabrese Pizza	        937
			The Spinach Supreme Pizza	950
			The Soppressata Pizza	    961  */
		
        
        Select pt.name, sum(od.quantity) as num_of_orders
		from order_details od
		join pizzas p ON p.pizza_id = od.pizza_id
		join pizza_types pt ON Pt.pizza_type_id = p.pizza_type_id
		group by pt.name
		order by num_of_orders 
		limit 5;





-- 19.Retrieve the average price for each pizza type?

		
          
          SELECT pt.name, round(AVG(p.price), 2) as avg_price
		  from pizzas p
		  join pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
		  group by pt.name
		  order by avg_price desc;
  
  

-- 20.Retrieve the average number of pizzas per order
-- ANS: Average pizzas per order are 2.2773
		
        
        SELECT AVG(num_pizzas) AS avg_pizzas_per_order
		FROM (
			SELECT o.Order_id, COUNT(od.quantity) AS num_pizzas
			FROM Orders o
			JOIN Order_details od ON o.Order_id = od.order_id
			GROUP BY o.Order_id
		) as a ;



-- 21.Retrieve the top 3 busiest day of the week
-- ANS:  
/*  Friday	8106
	Saturday	7355
	Thursday	7323*/
	
    
          
          SELECT dayname(o.date) as weekdays, count(*) as num_of_orders
		  from  order_details od
		  join orders o ON o.order_id = od.order_id
		  group by weekdays
		  order by num_of_orders desc
		  limit 3;




 -- 22.Retrieve the changes in total sales over time, broken down by pizza type?
 
 
 
		SELECT 
				DATE(o.date) AS order_date, pt.name, SUM(od.quantity * p.price) AS total_sales
		FROM 
				Orders o
		JOIN 
				Order_details od ON o.Order_id = od.order_id
		JOIN 
				Pizzas p ON od.pizza_id = p.Pizza_id
		JOIN
				Pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
		GROUP BY 
				order_date, pt.name
		ORDER BY
				order_date, pt.name;




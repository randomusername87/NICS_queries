/* Average sales for each state vs 2020 sales */

WITH cte_avg AS --cte_avg
	(
	SELECT
		state,
		ROUND((12 * purchase_estimate / num_months), 0) AS avg_purch_yearly
	FROM
		(	
		SELECT
			state,
			num_months,
			SUM(handgun_adj) + SUM(long_gun_adj) + SUM(other_adj) + SUM(multiple_adj) 
				AS purchase_estimate
		FROM
			(
			SELECT 
				state,
				COUNT(month) AS num_months,
				SUM(handgun) * 1.1 AS handgun_adj,
				SUM(long_gun) * 1.1 AS long_gun_adj,
				SUM(other) * 1.1 AS other_adj,
				SUM(multiple) * 2 AS multiple_adj
			FROM nics_checks
			GROUP BY state
			) AS sub_1
		GROUP BY state, num_months
		) AS sub_2
	GROUP BY state, avg_purch_yearly
	),
cte_2020 AS --cte_2020
	(
	SELECT
		state,
		SUM(handgun_adj) + SUM(long_gun_adj) + SUM(other_adj) + SUM(multiple_adj) 
			AS purchase_2020
	FROM
		(
		SELECT 
			state,
			month,
			SUM(handgun) * 1.1 AS handgun_adj,
			SUM(long_gun) * 1.1 AS long_gun_adj,
			SUM(other) * 1.1 AS other_adj,
			SUM(multiple) * 2 AS multiple_adj
		FROM nics_checks
		GROUP BY state, month
		) AS sub
	WHERE month LIKE '2020%'	--change date here
	GROUP BY state
	)
SELECT 
	cte_avg.state,
	avg_purch_yearly,
	purchase_2020,
	(purchase_2020 - avg_purch_yearly) AS purchase_vs_avg
FROM cte_avg
JOIN cte_2020
ON cte_avg.state = cte_2020.state 
GROUP BY cte_avg.state, avg_purch_yearly, purchase_2020
ORDER BY purchase_vs_avg DESC
;
	



/* Old stuff below


WITH cte_avg AS 
	(
	SELECT 
		state,
		12 * (ROUND((total_purchase / month_count), 0)) AS avg_yearly_sales
	FROM
		(
		SELECT 
			state, 
			month_count,
			SUM(grand_total - total_non_purchase) AS total_purchase
		FROM
			(
			SELECT
				state,
				COUNT(month) AS month_count,
				SUM(permit + permit_recheck  + admin + prepawn_handgun + prepawn_long_gun + prepawn_other + redemption_handgun + redemption_long_gun + redemption_other + returned_handgun + returned_long_gun + returned_other + rentals_handgun + rentals_long_gun + return_to_seller_handgun + return_to_seller_long_gun + return_to_seller_other) 
					AS total_non_purchase,
				SUM(totals) AS grand_total
			FROM nics_checks
			GROUP BY state
			) AS sub_1
		GROUP BY state, month_count
		) AS sub_2
		GROUP BY state, total_purchase, month_count
	),
cte_2020 AS 
	(
	SELECT 
		state,
		non_purchase,
		grand_total,
		(grand_total - non_purchase) AS sales_2020
	FROM 
		(
		SELECT 
			state,
			SUM(permit + permit_recheck  + admin + prepawn_handgun + prepawn_long_gun + prepawn_other + redemption_handgun + redemption_long_gun + redemption_other + returned_handgun + returned_long_gun + returned_other + rentals_handgun + rentals_long_gun + return_to_seller_handgun + return_to_seller_long_gun + return_to_seller_other) 
				AS non_purchase,
			SUM(totals) AS grand_total
		FROM nics_checks
		WHERE month LIKE '2020%'
		GROUP BY state
		) AS sub_2020
	GROUP BY state, non_purchase, grand_total, sales_2020
	)
SELECT 
	cte_avg.state,
	avg_yearly_sales,
	sales_2020,
	(sales_2020 - avg_yearly_sales) AS sales_increase
FROM cte_avg
JOIN cte_2020
ON cte_avg.state = cte_2020.state 
GROUP BY cte_avg.state, avg_yearly_sales, sales_2020
ORDER BY sales_increase
;
	
	--not working right?
	
	*/
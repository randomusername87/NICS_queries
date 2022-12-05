	--What is the average number of NICS run for purchases in a YEAR for each state?

SELECT
	state,
	ROUND((12 * purchase_estimate / num_months), 0) AS avg_purch_monthly
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
GROUP BY state, avg_purch_monthly
ORDER BY avg_purch_monthly DESC
LIMIT 55;

	
	
	
/* old stuff below
	
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
	ORDER BY avg_yearly_sales DESC
;


*/
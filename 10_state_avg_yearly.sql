--What is the annual average purchase estimate in each state?

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
			SUM(COALESCE(handgun, 0)) * 1.1 AS handgun_adj,
			SUM(COALESCE(long_gun, 0)) * 1.1 AS long_gun_adj,
			SUM(COALESCE(other, 0)) * 1.1 AS other_adj,
			SUM(COALESCE(multiple, 0)) * 2 AS multiple_adj
		FROM nics_checks
		GROUP BY state
		) AS sub_1
	GROUP BY state, num_months
	) AS sub_2
GROUP BY state, avg_purch_monthly
ORDER BY avg_purch_monthly DESC
LIMIT 55;

	
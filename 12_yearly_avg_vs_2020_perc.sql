/*Average annual purchase by state vs 2020 and percentage change */


WITH cte_avg AS 
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
				SUM(COALESCE(handgun, 0)) * 1.1 AS handgun_adj,
				SUM(COALESCE(long_gun, 0)) * 1.1 AS long_gun_adj,
				SUM(COALESCE(other, 0)) * 1.1 AS other_adj,
				SUM(COALESCE(multiple, 0)) * 2 AS multiple_adj
			FROM nics_checks
			GROUP BY state
			) AS sub_1
		GROUP BY state, num_months
		) AS sub_2
	GROUP BY state, avg_purch_yearly
	),
cte_2020 AS 
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
			SUM(COALESCE(handgun, 0)) * 1.1 AS handgun_adj,
			SUM(COALESCE(long_gun, 0)) * 1.1 AS long_gun_adj,
			SUM(COALESCE(other, 0)) * 1.1 AS other_adj,
			SUM(COALESCE(multiple, 0)) * 2 AS multiple_adj
		FROM nics_checks
		GROUP BY state, month
		) AS sub
	WHERE month LIKE '2020%'
	GROUP BY state
	)
SELECT 
	cte_avg.state,
	avg_purch_yearly,
	purchase_2020,
	(purchase_2020 - avg_purch_yearly) AS purchase_vs_avg,
	ROUND(
		(((purchase_2020 - avg_purch_yearly) / NullIf(avg_purch_yearly,0)) * 100)
		,2) AS perc_increase		
FROM cte_avg
JOIN cte_2020
ON cte_avg.state = cte_2020.state 
GROUP BY cte_avg.state, avg_purch_yearly, purchase_2020
ORDER BY perc_increase DESC
;
	







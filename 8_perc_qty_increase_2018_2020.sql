--Gun Sale Increase 2018 to 2020 as total and percentage


WITH 
	cte_2018 AS
		(
		SELECT
			state,
			SUM(handgun_adj) + SUM(long_gun_adj) + SUM(other_adj) + SUM(multiple_adj) 
				AS purchase_estimate
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
		WHERE month LIKE '2018%'	
		GROUP BY state
		),
	cte_2020 AS
		(
		SELECT
			state,
			SUM(handgun_adj) + SUM(long_gun_adj) + SUM(other_adj) + SUM(multiple_adj) 
				AS purchase_estimate
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
	cte_2018.state,
	cte_2018.purchase_estimate AS purchase_2018,
	cte_2020.purchase_estimate AS purchase_2020,
	COALESCE((cte_2020.purchase_estimate - cte_2018.purchase_estimate), 0) AS purchase_increase,
	COALESCE(ROUND(
		(((cte_2020.purchase_estimate - cte_2018.purchase_estimate) / NullIf(cte_2018.purchase_estimate,0)) * 100)
		,2), 0) AS perc_increase
FROM cte_2018
JOIN cte_2020
ON cte_2018.state = cte_2020.state
GROUP BY cte_2018.state, cte_2018.purchase_estimate, cte_2020.purchase_estimate 
ORDER BY perc_increase DESC
;
		
		
		
	
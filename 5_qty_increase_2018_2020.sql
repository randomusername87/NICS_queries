--How much did gun sales increase/decrease from 2018 to 2020 by state? (quantity of NICS checks)

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
				SUM(handgun) * 1.1 AS handgun_adj,
				SUM(long_gun) * 1.1 AS long_gun_adj,
				SUM(other) * 1.1 AS other_adj,
				SUM(multiple) * 2 AS multiple_adj
			FROM nics_checks
			GROUP BY state, month
			) AS sub
		WHERE month LIKE '2018%'	--change date here to compare other years
		GROUP BY state
		--ORDER BY purchase_estimate DESC
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
				SUM(handgun) * 1.1 AS handgun_adj,
				SUM(long_gun) * 1.1 AS long_gun_adj,
				SUM(other) * 1.1 AS other_adj,
				SUM(multiple) * 2 AS multiple_adj
			FROM nics_checks
			GROUP BY state, month
			) AS sub
		WHERE month LIKE '2020%'	--change date here to compare other years
		GROUP BY state
		)
SELECT
	cte_2018.state,
	cte_2018.purchase_estimate AS purchase_2018,
	cte_2020.purchase_estimate AS purchase_2020,
	(cte_2020.purchase_estimate - cte_2018.purchase_estimate) AS purchase_increase
FROM cte_2018
JOIN cte_2020
ON cte_2018.state = cte_2020.state
GROUP BY cte_2018.state, cte_2018.purchase_estimate, cte_2020.purchase_estimate 
ORDER BY purchase_increase DESC
;

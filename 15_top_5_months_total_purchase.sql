/* What months had the most sales ever? (top 10) */


--Top 10 months ever	

SELECT
	month,
	SUM(handgun_adj) + SUM(long_gun_adj) + SUM(other_adj) + SUM(multiple_adj) 
		AS purchase_estimate
FROM
	(
	SELECT 
		state,
		SUM(COALESCE(handgun, 0)) * 1.1 AS handgun_adj,
		SUM(COALESCE(long_gun, 0)) * 1.1 AS long_gun_adj,
		SUM(COALESCE(other, 0)) * 1.1 AS other_adj,
		SUM(COALESCE(multiple, 0)) * 2 AS multiple_adj,
		month
	FROM nics_checks
	GROUP BY state, month
	) AS sub
GROUP BY month
ORDER BY purchase_estimate DESC
LIMIT 10;








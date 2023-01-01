/* What months had the most sales ever? (top 10)
	-How does this compare to average */

SELECT
	month, 
	purchase_estimate,
	avg_purch_yearly,
	purchase_estimate - avg_purch_yearly AS diff_from_avg,
	ROUND((purchase_estimate - avg_purch_yearly) / purchase_estimate * 100, 1) AS perc_diff_from_avg
FROM
	(
	SELECT
		month,
		purchase_estimate,
		ROUND(AVG(purchase_estimate) OVER (), 1) AS avg_purch_yearly	
	FROM
		(
		SELECT
			month,
			SUM(handgun_adj) + SUM(long_gun_adj) + SUM(other_adj) + SUM(multiple_adj) 
				AS purchase_estimate
		FROM
			(
			SELECT 
				SUM(COALESCE(handgun, 0)) * 1.1 AS handgun_adj,
				SUM(COALESCE(long_gun, 0)) * 1.1 AS long_gun_adj,
				SUM(COALESCE(other, 0)) * 1.1 AS other_adj,
				SUM(COALESCE(multiple, 0)) * 2 AS multiple_adj,
				month
			FROM nics_checks
			GROUP BY month
			) AS sub
		GROUP BY month
		) AS sub2
	GROUP BY month, purchase_estimate
	) AS sub3
ORDER BY diff_from_avg DESC
LIMIT 10;
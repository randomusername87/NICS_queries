 /*3) What rolling 3-month period had the most sales ever?
	-Can I compare this to the average rolling 3-month period? */




--Top 5 rolling 3-month averages
SELECT
	month AS final_month, 
	three_month_avg
FROM
	(
	SELECT
		month,
		purchase_estimate,
		ROUND(AVG(purchase_estimate) OVER (ORDER BY month ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), 1) AS three_month_avg	
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
ORDER BY three_month_avg DESC
LIMIT 5;


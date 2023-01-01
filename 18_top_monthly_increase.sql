 /* Which month had the sharpest month-over-month increase? 
 Top 5 month-to-month increases by sales volume */
 
 
SELECT
	month, 
	purchase_estimate,
	sales_increase
FROM
	(
	SELECT
		month,
		purchase_estimate,
		COALESCE(purchase_estimate - (LAG(purchase_estimate, 1) OVER (ORDER BY MONTH)),0) AS sales_increase	
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
ORDER BY sales_increase DESC 
LIMIT 5;
 

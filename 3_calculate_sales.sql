/*SEPARATING OUT BACKGROUND CHECKS RUN FOR PURCHASES
	(Some checks are run for various permits, and some states run checks annually 
	to confirm permit eligibility). Used 1.1 for purchases other than multiple. Used 2 for multiple*/

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
GROUP BY state
ORDER BY purchase_estimate DESC
LIMIT 55;

--How many guns did each state buy in 2020?

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
WHERE month LIKE '2020%'	--change date here to examine other years
GROUP BY state
ORDER BY purchase_estimate DESC
LIMIT 55;











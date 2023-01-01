/*How many guns have been purchased in each state? 
Gives breakdown of each type of gun: */

SELECT 
		state,
		SUM(COALESCE(handgun, 0)) * 1.1 AS handgun_adj,
		SUM(COALESCE(long_gun, 0)) * 1.1 AS long_gun_adj,
		SUM(COALESCE(other, 0)) * 1.1 AS other_adj,
		SUM(COALESCE(multiple, 0)) * 2 AS multiple_adj
FROM nics_checks
GROUP BY state
ORDER BY state
limit 55;	
/*SEPARATING OUT BACKGROUND CHECKS RUN FOR PURCHASES
	(Some checks are run for various permits, and some states run checks annually 
	to confirm permit eligibility)/*

SELECT 
	sub.state,
 	non_purchase,
 	grand_total,
 	(grand_total - non_purchase) AS total_purchase
FROM 
 	(
   	SELECT state,
   	SUM(permit + permit_recheck  + admin + prepawn_handgun + prepawn_long_gun + prepawn_other + redemption_handgun + redemption_long_gun + redemption_other + returned_handgun + returned_long_gun + returned_other + rentals_handgun + rentals_long_gun + return_to_seller_handgun + return_to_seller_long_gun + return_to_seller_other) 
     	AS non_purchase,
   	SUM(totals) AS grand_total
   	FROM nics_checks
   	GROUP BY state
 	) AS sub
INNER JOIN nics_checks AS n
ON sub.state = n.state
GROUP BY sub.state, non_purchase, grand_total, total_purchase
ORDER BY total_purchase DESC
LIMIT 55;


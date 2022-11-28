--How much did gun sales increase/decrease from 2018 to 2020 by state? (quantity of NICS checks)

WITH 
	cte_2018 AS
		(
		/*cte_2018*/
		SELECT 
			sub18.state,
			non_purchase,
			grand_total,
			(grand_total - non_purchase) AS total_purchase
		FROM 
			(
		   	SELECT 
				state,
				SUM(permit + permit_recheck  + admin + prepawn_handgun + prepawn_long_gun + prepawn_other + redemption_handgun + redemption_long_gun + redemption_other + returned_handgun + returned_long_gun + returned_other + rentals_handgun + rentals_long_gun + return_to_seller_handgun + return_to_seller_long_gun + return_to_seller_other) 
		     		AS non_purchase,
		   		SUM(totals) AS grand_total
		   	FROM nics_checks
		   	WHERE month LIKE '2018%'
		   	GROUP BY state
			) AS sub18
		JOIN nics_checks AS n
		ON sub18.state = n.state
		GROUP BY sub18.state, non_purchase, grand_total, total_purchase
		ORDER BY total_purchase DESC
		),
	cte_2020 AS
		(
		/*cte_2020*/
		SELECT 
			sub20.state,
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
		   	WHERE month LIKE '2020%'
		   	GROUP BY state
		 	) AS sub20
		INNER JOIN nics_checks AS n
		ON sub20.state = n.state
		GROUP BY sub20.state, non_purchase, grand_total, total_purchase
		ORDER BY total_purchase DESC
		)
SELECT
	cte_2018.state,
	cte_2018.total_purchase AS purchase_2018,
	cte_2020.total_purchase AS purchase_2020,
	(cte_2020.total_purchase - cte_2018.total_purchase) AS purchase_increase
FROM cte_2018
JOIN cte_2020
ON cte_2018.state = cte_2020.state
GROUP BY cte_2018.state, cte_2018.total_purchase, cte_2020.total_purchase 
ORDER BY purchase_increase DESC
;
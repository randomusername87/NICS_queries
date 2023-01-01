/* What were the top 5 years for gun sales in the US? */

SELECT
	year,
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
		CASE WHEN month LIKE '1998%' THEN '1998'
			WHEN month LIKE '1999%' THEN '1999'
			WHEN month LIKE '2000%' THEN '2000'
			WHEN month LIKE '2001%' THEN '2001'
			WHEN month LIKE '2002%' THEN '2002'
			WHEN month LIKE '2003%' THEN '2003'
			WHEN month LIKE '2004%' THEN '2004'
			WHEN month LIKE '2005%' THEN '2005'
			WHEN month LIKE '2006%' THEN '2006'
			WHEN month LIKE '2007%' THEN '2007'
			WHEN month LIKE '2008%' THEN '2008'
			WHEN month LIKE '2009%' THEN '2009'
			WHEN month LIKE '2010%' THEN '2010'
			WHEN month LIKE '2011%' THEN '2011'
			WHEN month LIKE '2012%' THEN '2012'
			WHEN month LIKE '2013%' THEN '2013'
			WHEN month LIKE '2014%' THEN '2014'
			WHEN month LIKE '2015%' THEN '2015'
			WHEN month LIKE '2016%' THEN '2016'
			WHEN month LIKE '2017%' THEN '2017'
			WHEN month LIKE '2018%' THEN '2018'
			WHEN month LIKE '2019%' THEN '2019'
			WHEN month LIKE '2020%' THEN '2020'
			WHEN month LIKE '2021%' THEN '2021'
			WHEN month LIKE '2022%' THEN '2022'
			ELSE '0000' END
			AS year
	FROM nics_checks
	GROUP BY state, month
	) AS sub
GROUP BY year
ORDER BY purchase_estimate DESC
LIMIT 5;



--purchase estimate, annual average, difference, and % increase

SELECT
	year, 
	purchase_estimate,
	avg_purch_yearly,
	purchase_estimate - avg_purch_yearly AS diff_from_avg,
	ROUND((purchase_estimate - avg_purch_yearly) / purchase_estimate * 100, 1) AS perc_diff_from_avg
FROM
	(
	SELECT
		year,
		purchase_estimate,
		ROUND(AVG(purchase_estimate) OVER (), 1) AS avg_purch_yearly	
	FROM
		(
		SELECT
			year,
			SUM(handgun_adj) + SUM(long_gun_adj) + SUM(other_adj) + SUM(multiple_adj) 
				AS purchase_estimate
		FROM
			(
			SELECT 
				SUM(COALESCE(handgun, 0)) * 1.1 AS handgun_adj,
				SUM(COALESCE(long_gun, 0)) * 1.1 AS long_gun_adj,
				SUM(COALESCE(other, 0)) * 1.1 AS other_adj,
				SUM(COALESCE(multiple, 0)) * 2 AS multiple_adj,
				CASE WHEN month LIKE '1998%' THEN '1998'
					WHEN month LIKE '1999%' THEN '1999'
					WHEN month LIKE '2000%' THEN '2000'
					WHEN month LIKE '2001%' THEN '2001'
					WHEN month LIKE '2002%' THEN '2002'
					WHEN month LIKE '2003%' THEN '2003'
					WHEN month LIKE '2004%' THEN '2004'
					WHEN month LIKE '2005%' THEN '2005'
					WHEN month LIKE '2006%' THEN '2006'
					WHEN month LIKE '2007%' THEN '2007'
					WHEN month LIKE '2008%' THEN '2008'
					WHEN month LIKE '2009%' THEN '2009'
					WHEN month LIKE '2010%' THEN '2010'
					WHEN month LIKE '2011%' THEN '2011'
					WHEN month LIKE '2012%' THEN '2012'
					WHEN month LIKE '2013%' THEN '2013'
					WHEN month LIKE '2014%' THEN '2014'
					WHEN month LIKE '2015%' THEN '2015'
					WHEN month LIKE '2016%' THEN '2016'
					WHEN month LIKE '2017%' THEN '2017'
					WHEN month LIKE '2018%' THEN '2018'
					WHEN month LIKE '2019%' THEN '2019'
					WHEN month LIKE '2020%' THEN '2020'
					WHEN month LIKE '2021%' THEN '2021'
					WHEN month LIKE '2022%' THEN '2022'
					ELSE '0000' END
					AS year
			FROM nics_checks
			GROUP BY month
			) AS sub
		GROUP BY year
		) AS sub2
	GROUP BY year, purchase_estimate
	) AS sub3
ORDER BY diff_from_avg DESC
LIMIT 5;
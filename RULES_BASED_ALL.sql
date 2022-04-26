DROP TABLE RULE_PT_BR_TT

SELECT * INTO RULE_PT_BR_TT FROM (
--------------------------------------------------------------RULLING : UNIQUE TERM CODE (Y_PT)---------------------------------------------------------------------------------------	 
	 SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_PT' AS [Logical System Group] 
		 FROM (
			 SELECT 	tb1.[Term code],
						'___' AS [Number Range],
						'___' AS [Product Hierarchy],
						[Reference Number],
						Amount AS [Number of part used]
				FROM (		
					SELECT		[Term code],
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									 WHERE  [Logical System Group] = 'Y_PT' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000'
					GROUP BY [Term code],[Reference Number] HAVING [Reference Number] <> '' ) tb1  
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	
										SELECT 	DISTINCT([Term code]) AS [Term code] FROM  (
											SELECT *,row_number() OVER (PARTITION BY [Term code] ORDER BY [Term code]) AS row_number 
												FROM (		
													SELECT		[Term code],
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																	  WHERE  [Logical System Group] = 'y_pt' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' 
													GROUP BY [Term code],[Reference Number] HAVING [Reference Number] <> '' ) tb1  ) tb2
																WHERE row_number > 1 )  t2
							ON tb1.[Term code] = t2.[Term code] WHERE t2.[Term code] IS NULL ) tb2
							--**************************************************************************************************************
																	LEFT JOIN hscodedata hs ON tb2.[Reference Number] = hs.[PART NUMBER]
																		WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] <> ''
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING : UNIQUE HIERARCHY (Y_PT)---------------------------------------------------------------------------------------	 
	 SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_PT' AS [Logical System Group] 
		 FROM (
			 SELECT 	'___' AS [Term code],
						'___' AS [Number Range],
						tb1.[Product Hierarchy],
						[Reference Number],
						Amount AS [Number of part used]
				FROM (		
					SELECT		[Product Hierarchy],
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
										WHERE  [Product Hierarchy] <> ''   AND  [Logical System Group] = 'Y_PT'
					GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '' ) tb1 
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	
										SELECT 	DISTINCT([Product Hierarchy]) AS [Product Hierarchy] FROM  (
											SELECT *,row_number() OVER (PARTITION BY [Product Hierarchy] ORDER BY [Product Hierarchy]) AS row_number 
												FROM (		
													SELECT		[Product Hierarchy],
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE  [Product Hierarchy] <> ''   AND  [Logical System Group] = 'Y_PT'
													GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '' ) tb1  ) tb2
																WHERE row_number > 1 )  t2
							ON tb1.[Product Hierarchy] = t2.[Product Hierarchy] WHERE t2.[Product Hierarchy] IS NULL ) tb2
							--**************************************************************************************************************
																	LEFT JOIN hscodedata hs ON tb2.[Reference Number] = hs.[PART NUMBER]
																		WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING: UNIQUE NUMBER RANGE + TERM CODE (Y_PT)-------------------------------------------------------------------------------------------------------------	
		SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_PT' AS [Logical System Group]
			FROM (
				SELECT    
						LEFT(tb2.Term_nRange, CHARINDEX('.', tb2.Term_nRange) - 1) AS [Number Range],
						right(tb2.Term_nRange, CHARINDEX('.', REVERSE(tb2.Term_nRange)) - 1) AS [Term code],
						'___' AS [Product Hierarchy],
						[Reference Number],
						Amount AS [Number of part used]
					FROM (
					SELECT * FROM (
						SELECT	LEFT([Product Number],4) + '.' + [Term code] AS Term_nRange,
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Logical System Group] = 'Y_PT'					     							
						GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Term code] HAVING [Reference Number] <> '') tb1
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	 
										SELECT DISTINCT(Term_nRange1) AS Term_nRange1 FROM (
												SELECT *,row_number() OVER (PARTITION BY Term_nRange1 ORDER BY Term_nRange1) AS row_number 
													FROM(	
														SELECT	LEFT([Product Number],4) + '.' + [Term code] AS Term_nRange1,
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Logical System Group] = 'Y_PT'					     							
														GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Term code] HAVING [Reference Number] <> '') t1 ) t2   
																WHERE row_number > 1 ) t2
							ON tb1.Term_nRange = t2.Term_nRange1 WHERE t2.Term_nRange1 IS NULL ) tb2 ) tb3
							--**************************************************************************************************************
													LEFT JOIN hscodedata hs ON tb3.[Reference Number] = hs.[PART NUMBER] 
															WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING: UNIQUE NUMBER RANGE + HIERARCHY (Y_PT)-------------------------------------------------------------------------------------------------------------	
		SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_PT' AS [Logical System Group]
			FROM (
				SELECT    
						LEFT(tb2.Hie_nRange, CHARINDEX('.', tb2.Hie_nRange) - 1) AS [Number Range],
						right(tb2.Hie_nRange, CHARINDEX('.', REVERSE(tb2.Hie_nRange)) - 1) AS [Product Hierarchy],
						'___' AS [Term code],
						[Reference Number],
						Amount AS [Number of part used]
					FROM (
					SELECT * FROM (
						SELECT	LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_PT' 					     							
						GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	 
										SELECT DISTINCT(Hie_nRange1) AS Hie_nRange1 FROM (
												SELECT *,row_number() OVER (PARTITION BY Hie_nRange1 ORDER BY Hie_nRange1) AS row_number 
													FROM(	
														SELECT	LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange1,
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_PT'					     							
														GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') t1 ) t2   
																WHERE row_number > 1 ) t2
							ON tb1.Hie_nRange = t2.Hie_nRange1 WHERE t2.Hie_nRange1 IS NULL ) tb2 ) tb3
							--**************************************************************************************************************
													LEFT JOIN hscodedata hs ON tb3.[Reference Number] = hs.[PART NUMBER] 
															WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING: UNIQUE TERM CODE + HIERARCHY (Y_PT)-------------------------------------------------------------------------------------------------------------	
		SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_PT' AS [Logical System Group]
			FROM (
				SELECT    
						LEFT(tb2.Term_Hierarchy, CHARINDEX('.', tb2.Term_Hierarchy) - 1) AS [Term code],
						RIGHT(tb2.Term_Hierarchy, CHARINDEX('.', REVERSE(tb2.Term_Hierarchy)) - 1) AS [Product Hierarchy],
						'___' AS [Number Range],
						[Reference Number],
						Amount AS [Number of part used]
					FROM (
					SELECT * FROM (
						SELECT	[Term code] + '.' + [Product Hierarchy] AS Term_Hierarchy,
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_PT' 					     							
						GROUP BY [Reference Number],[Term code] + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	 
										SELECT DISTINCT(Term_Hierarchy1) AS Term_Hierarchy1 FROM (
												SELECT *,row_number() OVER (PARTITION BY Term_Hierarchy1 ORDER BY Term_Hierarchy1) AS row_number 
													FROM(	
														SELECT	[Term code] + '.' + [Product Hierarchy] AS Term_Hierarchy1,
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_PT'					     							
														GROUP BY [Reference Number],[Term code] + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') t1 ) t2   
																WHERE row_number > 1 ) t2
							ON tb1.Term_Hierarchy = t2.Term_Hierarchy1 WHERE t2.Term_Hierarchy1 IS NULL ) tb2 ) tb3
							--**************************************************************************************************************
													LEFT JOIN hscodedata hs ON tb3.[Reference Number] = hs.[PART NUMBER] 
															WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING : UNIQUE TERM CODE (Y_BR)---------------------------------------------------------------------------------------	 
	 SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_BR' AS [Logical System Group] 
		 FROM (
			 SELECT 	tb1.[Term code],
						'___' AS [Number Range],
						'___' AS [Product Hierarchy],
						[Reference Number],
						Amount AS [Number of part used]
				FROM (		
					SELECT		[Term code],
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									 WHERE  [Logical System Group] = 'Y_BR' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000'
					GROUP BY [Term code],[Reference Number] HAVING [Reference Number] <> '' ) tb1  
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	
										SELECT 	DISTINCT([Term code]) AS [Term code] FROM  (
											SELECT *,row_number() OVER (PARTITION BY [Term code] ORDER BY [Term code]) AS row_number 
												FROM (		
													SELECT		[Term code],
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																	  WHERE  [Logical System Group] = 'Y_BR' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' 
													GROUP BY [Term code],[Reference Number] HAVING [Reference Number] <> '' ) tb1  ) tb2
																WHERE row_number > 1 )  t2
							ON tb1.[Term code] = t2.[Term code] WHERE t2.[Term code] IS NULL ) tb2
							--**************************************************************************************************************
																	LEFT JOIN hscodedata hs ON tb2.[Reference Number] = hs.[PART NUMBER]
																		WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] <> ''
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING : UNIQUE HIERARCHY (Y_BR)---------------------------------------------------------------------------------------	 
	 SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_BR' AS [Logical System Group] 
		 FROM (
			 SELECT 	'___' AS [Term code],
						'___' AS [Number Range],
						tb1.[Product Hierarchy],
						[Reference Number],
						Amount AS [Number of part used]
				FROM (		
					SELECT		[Product Hierarchy],
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
										WHERE  [Product Hierarchy] <> ''   AND  [Logical System Group] = 'Y_BR'
					GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '' ) tb1 
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	
										SELECT 	DISTINCT([Product Hierarchy]) AS [Product Hierarchy] FROM  (
											SELECT *,row_number() OVER (PARTITION BY [Product Hierarchy] ORDER BY [Product Hierarchy]) AS row_number 
												FROM (		
													SELECT		[Product Hierarchy],
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE  [Product Hierarchy] <> ''   AND  [Logical System Group] = 'Y_BR'
													GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '' ) tb1  ) tb2
																WHERE row_number > 1 )  t2
							ON tb1.[Product Hierarchy] = t2.[Product Hierarchy] WHERE t2.[Product Hierarchy] IS NULL ) tb2
							--**************************************************************************************************************
																	LEFT JOIN hscodedata hs ON tb2.[Reference Number] = hs.[PART NUMBER]
																		WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING: UNIQUE NUMBER RANGE + TERM CODE (Y_BR)-------------------------------------------------------------------------------------------------------------	
		SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_BR' AS [Logical System Group]
			FROM (
				SELECT    
						LEFT(tb2.Term_nRange, CHARINDEX('.', tb2.Term_nRange) - 1) AS [Number Range],
						RIGHT(tb2.Term_nRange, CHARINDEX('.', REVERSE(tb2.Term_nRange)) - 1) AS [Term code],
						'___' AS [Product Hierarchy],
						[Reference Number],
						Amount AS [Number of part used]
					FROM (
					SELECT * FROM (
						SELECT	LEFT([Product Number],4) + '.' + [Term code] AS Term_nRange,
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Logical System Group] = 'Y_BR'					     							
						GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Term code] HAVING [Reference Number] <> '') tb1
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	 
										SELECT DISTINCT(Term_nRange1) AS Term_nRange1 FROM (
												SELECT *,row_number() OVER (PARTITION BY Term_nRange1 ORDER BY Term_nRange1) AS row_number 
													FROM(	
														SELECT	LEFT([Product Number],4) + '.' + [Term code] AS Term_nRange1,
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Logical System Group] = 'Y_BR'					     							
														GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Term code] HAVING [Reference Number] <> '') t1 ) t2   
																WHERE row_number > 1 ) t2
							ON tb1.Term_nRange = t2.Term_nRange1 WHERE t2.Term_nRange1 IS NULL ) tb2 ) tb3
							--**************************************************************************************************************
													LEFT JOIN hscodedata hs ON tb3.[Reference Number] = hs.[PART NUMBER] 
															WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING: UNIQUE NUMBER RANGE + HIERARCHY (Y_BR)-------------------------------------------------------------------------------------------------------------	
		SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_BR' AS [Logical System Group]
			FROM (
				SELECT    
						LEFT(tb2.Hie_nRange, CHARINDEX('.', tb2.Hie_nRange) - 1) AS [Number Range],
						right(tb2.Hie_nRange, CHARINDEX('.', REVERSE(tb2.Hie_nRange)) - 1) AS [Product Hierarchy],
						'___' AS [Term code],
						[Reference Number],
						Amount AS [Number of part used]
					FROM (
					SELECT * FROM (
						SELECT	LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_BR' 					     							
						GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	 
										SELECT DISTINCT(Hie_nRange1) AS Hie_nRange1 FROM (
												SELECT *,row_number() OVER (PARTITION BY Hie_nRange1 ORDER BY Hie_nRange1) AS row_number 
													FROM(	
														SELECT	LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange1,
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_BR'					     							
														GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') t1 ) t2   
																WHERE row_number > 1 ) t2
							ON tb1.Hie_nRange = t2.Hie_nRange1 WHERE t2.Hie_nRange1 IS NULL ) tb2 ) tb3
							--**************************************************************************************************************
													LEFT JOIN hscodedata hs ON tb3.[Reference Number] = hs.[PART NUMBER] 
															WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING: UNIQUE TERM CODE + HIERARCHY (Y_BR)-------------------------------------------------------------------------------------------------------------	
		SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_BR' AS [Logical System Group]
			FROM (
				SELECT    
						LEFT(tb2.Term_Hierarchy, CHARINDEX('.', tb2.Term_Hierarchy) - 1) AS [Term code],
						right(tb2.Term_Hierarchy, CHARINDEX('.', REVERSE(tb2.Term_Hierarchy)) - 1) AS [Product Hierarchy],
						'___' AS [Number Range],
						[Reference Number],
						Amount AS [Number of part used]
					FROM (
					SELECT * FROM (
						SELECT	[Term code] + '.' + [Product Hierarchy] AS Term_Hierarchy,
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_BR' 					     							
						GROUP BY [Reference Number],[Term code] + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	 
										SELECT DISTINCT(Term_Hierarchy1) AS Term_Hierarchy1 FROM (
												SELECT *,row_number() OVER (PARTITION BY Term_Hierarchy1 ORDER BY Term_Hierarchy1) AS row_number 
													FROM(	
														SELECT	[Term code] + '.' + [Product Hierarchy] AS Term_Hierarchy1,
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_BR'					     							
														GROUP BY [Reference Number],[Term code] + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') t1 ) t2   
																WHERE row_number > 1 ) t2
							ON tb1.Term_Hierarchy = t2.Term_Hierarchy1 WHERE t2.Term_Hierarchy1 IS NULL ) tb2 ) tb3
							--**************************************************************************************************************
													LEFT JOIN hscodedata hs ON tb3.[Reference Number] = hs.[PART NUMBER] 
															WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING : UNIQUE HIERARCHY (Y_TT01)---------------------------------------------------------------------------------------	 
	 SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_TT01' as [Logical System Group] 
		 FROM (
			 SELECT 	'___' AS [Term code],
						'___' AS [Number Range],
						tb1.[Product Hierarchy],
						[Reference Number],
						Amount as [Number of part used]
				FROM (		
					SELECT		[Product Hierarchy],
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA]   
									WHERE  [Product Hierarchy] <> ''   AND  [Logical System Group] = 'Y_TT01'
					GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '' ) tb1 
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	
										SELECT 	DISTINCT([Product Hierarchy]) AS [Product Hierarchy] FROM  (
											SELECT *,row_number() OVER (PARTITION BY [Product Hierarchy] ORDER BY [Product Hierarchy]) AS row_number 
												FROM (		
													SELECT		[Product Hierarchy],
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA]   
																	WHERE  [Product Hierarchy] <> ''   AND  [Logical System Group] = 'Y_TT01'
													GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '' ) tb1  ) tb2
																WHERE row_number > 1 )  t2
							ON tb1.[Product Hierarchy] = t2.[Product Hierarchy] where t2.[Product Hierarchy] is null ) tb2
							--**************************************************************************************************************
																	LEFT JOIN hscodedata hs ON tb2.[Reference Number] = hs.[PART NUMBER]
																		WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING: UNIQUE NUMBER RANGE + HIERARCHY (Y_TT01)-------------------------------------------------------------------------------------------------------------	
		SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_TT01' as [Logical System Group]
			FROM (
				SELECT    
						left(tb2.Hie_nRange, CHARINDEX('.', tb2.Hie_nRange) - 1) AS [Number Range],
						right(tb2.Hie_nRange, CHARINDEX('.', REVERSE(tb2.Hie_nRange)) - 1) AS [Product Hierarchy],
						'___' as [Term code],
						[Reference Number],
						Amount as [Number of part used]
					FROM (
					SELECT * FROM (
						SELECT	left([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_TT01' 					     							
						GROUP BY [Reference Number],left([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	 
										SELECT DISTINCT(Hie_nRange1) AS Hie_nRange1 FROM (
												SELECT *,row_number() OVER (PARTITION BY Hie_nRange1 ORDER BY Hie_nRange1) AS row_number 
													FROM(	
														SELECT	left([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange1,
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_TT01'					     							
														GROUP BY [Reference Number],left([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') t1 ) t2   
																WHERE row_number > 1 ) t2
							ON tb1.Hie_nRange = t2.Hie_nRange1 where t2.Hie_nRange1 is null ) tb2 ) tb3
							--**************************************************************************************************************
													LEFT JOIN hscodedata hs ON tb3.[Reference Number] = hs.[PART NUMBER] 
															WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------RULLING : UNIQUE HIERARCHY (Y_ST)---------------------------------------------------------------------------------------	 
	 SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_ST' as [Logical System Group] 
		 FROM (
			 SELECT 	'___' AS [Term code],
						'___' AS [Number Range],
						tb1.[Product Hierarchy],
						[Reference Number],
						Amount as [Number of part used]
				FROM (		
					SELECT		[Product Hierarchy],
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE  [Product Hierarchy] <> ''   AND  [Logical System Group] = 'Y_ST'
					GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '' ) tb1 
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	
										SELECT 	DISTINCT([Product Hierarchy]) AS [Product Hierarchy] FROM  (
											SELECT *,row_number() OVER (PARTITION BY [Product Hierarchy] ORDER BY [Product Hierarchy]) AS row_number 
												FROM (		
													SELECT		[Product Hierarchy],
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA]   
																		WHERE  [Product Hierarchy] <> ''   AND  [Logical System Group] = 'Y_ST'
													GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '' ) tb1  ) tb2
																WHERE row_number > 1 )  t2
							ON tb1.[Product Hierarchy] = t2.[Product Hierarchy] where t2.[Product Hierarchy] is null ) tb2
							--**************************************************************************************************************
																	LEFT JOIN hscodedata hs ON tb2.[Reference Number] = hs.[PART NUMBER]
																		WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
----------------------------------------------------------------RULLING: UNIQUE NUMBER RANGE + HIERARCHY (Y_ST)-------------------------------------------------------------------------------------------------------------	
		SELECT [Term code],[Number Range],[Product Hierarchy],[Reference Number],[Number of part used],PRODUCT_GROUP,'Y_ST' as [Logical System Group]
			FROM (
				SELECT    
						left(tb2.Hie_nRange, CHARINDEX('.', tb2.Hie_nRange) - 1) AS [Number Range],
						right(tb2.Hie_nRange, CHARINDEX('.', REVERSE(tb2.Hie_nRange)) - 1) AS [Product Hierarchy],
						'___' as [Term code],
						[Reference Number],
						Amount as [Number of part used]
					FROM (
					SELECT * FROM (
						SELECT	left([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
								[Reference Number],
								COUNT([Product Number]) AS Amount
								FROM [dbo].[MO_TABLE_DATA] 
									WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_ST' 					     							
						GROUP BY [Reference Number],left([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1
						--*********************************************************************************************************************************************
							 LEFT JOIN ( 
						--*********************************************************************************************************************************************	 
										SELECT DISTINCT(Hie_nRange1) AS Hie_nRange1 FROM (
												SELECT *,row_number() OVER (PARTITION BY Hie_nRange1 ORDER BY Hie_nRange1) AS row_number 
													FROM(	
														SELECT	left([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange1,
																[Reference Number],
																COUNT([Product Number]) AS Amount
																FROM [dbo].[MO_TABLE_DATA] 
																		WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_ST'					     							
														GROUP BY [Reference Number],left([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') t1 ) t2   
																WHERE row_number > 1 ) t2
							ON tb1.Hie_nRange = t2.Hie_nRange1 where t2.Hie_nRange1 is null ) tb2 ) tb3
							--**************************************************************************************************************
													LEFT JOIN hscodedata hs ON tb3.[Reference Number] = hs.[PART NUMBER] 
															WHERE [PART NUMBER] IS NOT NULL OR [PART NUMBER] = ''
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
) AS INTO_TABLE
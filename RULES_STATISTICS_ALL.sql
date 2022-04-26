DROP TABLE RULE_STATISTICS

SELECT * INTO RULE_STATISTICS FROM (
--------------------------------------------------------------STATISTICS : TERM CODE (Y_BR)---------------------------------------------------------------------------------------			
	SELECT [Term code],[Number Range],tb4.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_BR' AS [Logical System Group] FROM (
				SELECT tb3.[Term code],'___' as [Number Range],'___' as [Product Hierarchy],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage 
					FROM (	
						SELECT		[Term code],
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
											WHERE  [Logical System Group] = 'Y_BR' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' 
						GROUP BY [Term code],[Reference Number] HAVING [Reference Number] <> '') tb1

				LEFT JOIN (
						--********************GROUP BY TERM CODE AND SUM THE AMOUNT ******************
						SELECT [Term code],SUM(Amount) as SUM FROM (	
								SELECT		[Term code],
											[Reference Number],
											COUNT([Product Number]) AS Amount
											FROM [dbo].[MO_TABLE_DATA] 
													WHERE  [Logical System Group] = 'Y_BR' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' 
								GROUP BY [Term code],[Reference Number] HAVING [Reference Number] <> '') tb2
						GROUP BY [Term code]
						) tb3
				ON tb1.[Term code] = tb3.[Term code] ) tb4
				LEFT JOIN hscodedata hs ON  tb4.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------STATISTICS : PRODUCT HIERARCHY (Y_BR)-----------------------------------------------------------------------------------------------
	SELECT [Term code],[Number Range],tb4.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_BR' AS [Logical System Group] FROM (
		SELECT '___' as [Term code],'___' as [Number Range],tb3.[Product Hierarchy],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage 
					FROM (	
						SELECT		[Product Hierarchy],
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
											WHERE  [Logical System Group] = 'Y_BR' AND [Product Hierarchy] <> ''
						GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '') tb1

				LEFT JOIN (
						--********************GROUP BY PRODUCT HIERARCHY AND SUM THE AMOUNT ******************
						SELECT [Product Hierarchy],SUM(Amount) as SUM FROM (	
								SELECT		[Product Hierarchy],
											[Reference Number],
											COUNT([Product Number]) AS Amount
											FROM [dbo].[MO_TABLE_DATA] 
													WHERE  [Logical System Group] = 'Y_BR' AND [Product Hierarchy] <> ''
								GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '') tb2
						GROUP BY [Product Hierarchy]
						) tb3
				ON tb1.[Product Hierarchy] = tb3.[Product Hierarchy] ) tb4
				LEFT JOIN hscodedata hs ON  tb4.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
---------------------------------------------------------------STATISTICS : NUMBER RANGE + TERM CODE (Y_BR)-----------------------------------------------------------------
	SELECT [Term code],[Number Range],tb5.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_BR' AS [Logical System Group] FROM (	
					SELECT 
						'___' as [Product Hierarchy],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage, 
						LEFT(tb3.Term_nRange, CHARINDEX('.', tb3.Term_nRange) - 1) AS [Number Range],
						RIGHT(tb3.Term_nRange, CHARINDEX('.', REVERSE(tb3.Term_nRange)) - 1) AS [Term code]
						FROM (	
							SELECT	LEFT([Product Number],4) + '.' + [Term code] AS Term_nRange,
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
										WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Logical System Group] = 'Y_BR'					     							
							GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Term code] HAVING [Reference Number] <> '') tb1

							LEFT JOIN (

								SELECT Term_nRange,SUM(Amount) as SUM FROM (	
										SELECT		LEFT([Product Number],4) + '.' + [Term code] AS Term_nRange,
													[Reference Number],
													COUNT([Product Number]) AS Amount
													FROM [dbo].[MO_TABLE_DATA] 
															WHERE  [Logical System Group] = 'Y_BR' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' 
										GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Term code] HAVING [Reference Number] <> '') tb2
								GROUP BY Term_nRange ) tb3
							ON tb1.Term_nRange = tb3.Term_nRange ) tb5
					LEFT JOIN hscodedata hs ON  tb5.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
---------------------------------------------------------------STATISTICS : NUMBER RANGE + PRODUCT HIERARCHY (Y_BR)--------------------------------------------------------
	SELECT [Term code],[Number Range],tb5.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_BR' AS [Logical System Group] FROM (	
					SELECT 
						'___' as [Term code],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage, 
						LEFT(tb3.Hie_nRange, CHARINDEX('.', tb3.Hie_nRange) - 1) AS [Number Range],
						RIGHT(tb3.Hie_nRange, CHARINDEX('.', REVERSE(tb3.Hie_nRange)) - 1) AS [Product Hierarchy]
						FROM (	
							SELECT	LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
										WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_BR'					     							
							GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1

							LEFT JOIN (

								SELECT Hie_nRange,SUM(Amount) as SUM FROM (	
										SELECT		LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
													[Reference Number],
													COUNT([Product Number]) AS Amount
													FROM [dbo].[MO_TABLE_DATA] 
															WHERE  [Logical System Group] = 'Y_BR' AND [Product Hierarchy] <> ''
										GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb2
								GROUP BY Hie_nRange ) tb3
							ON tb1.Hie_nRange = tb3.Hie_nRange ) tb5
					LEFT JOIN hscodedata hs ON  tb5.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
---------------------------------------------------------------STATISTICS : TERM CODE + PRODUCT HIERARCHY (Y_BR)------------------------------------------------------------
	SELECT [Term code],[Number Range],tb5.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_BR' AS [Logical System Group] FROM (	
					SELECT 
						'___' as [Number Range],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage, 
						LEFT(tb3.Term_Hierarchy, CHARINDEX('.', tb3.Term_Hierarchy) - 1) AS [Term code],
						RIGHT(tb3.Term_Hierarchy, CHARINDEX('.', REVERSE(tb3.Term_Hierarchy)) - 1) AS [Product Hierarchy]
						FROM (	
							SELECT	[Term code] + '.' + [Product Hierarchy] AS Term_Hierarchy,
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
										WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_BR'					     							
							GROUP BY [Reference Number],[Term code] + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1

							LEFT JOIN (

								SELECT Term_Hierarchy,SUM(Amount) as SUM FROM (	
										SELECT		[Term code] + '.' + [Product Hierarchy] AS Term_Hierarchy,
													[Reference Number],
													COUNT([Product Number]) AS Amount
													FROM [dbo].[MO_TABLE_DATA] 
															WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Logical System Group] = 'Y_BR' AND [Product Hierarchy] <> ''
										GROUP BY [Reference Number],[Term code] + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb2
								GROUP BY Term_Hierarchy ) tb3
							ON tb1.Term_Hierarchy = tb3.Term_Hierarchy ) tb5
					LEFT JOIN hscodedata hs ON  tb5.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION			 
--------------------------------------------------------------STATISTICS : TERM CODE (Y_PT)---------------------------------------------------------------------------------------			
	SELECT [Term code],[Number Range],tb4.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_PT' AS [Logical System Group] FROM (
				SELECT tb3.[Term code],'___' as [Number Range],'___' as [Product Hierarchy],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage 
					FROM (	
						SELECT		[Term code],
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
											WHERE  [Logical System Group] = 'Y_PT' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' 
						GROUP BY [Term code],[Reference Number] HAVING [Reference Number] <> '') tb1

				LEFT JOIN (
						--********************GROUP BY TERM CODE AND SUM THE AMOUNT ******************
						SELECT [Term code],SUM(Amount) as SUM FROM (	
								SELECT		[Term code],
											[Reference Number],
											COUNT([Product Number]) AS Amount
											FROM [dbo].[MO_TABLE_DATA] 
													WHERE  [Logical System Group] = 'Y_PT' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' 
								GROUP BY [Term code],[Reference Number] HAVING [Reference Number] <> '') tb2
						GROUP BY [Term code]
						) tb3
				ON tb1.[Term code] = tb3.[Term code] ) tb4
				LEFT JOIN hscodedata hs ON  tb4.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------STATISTICS : PRODUCT HIERARCHY (Y_PT)-----------------------------------------------------------------------------------------------
	SELECT [Term code],[Number Range],tb4.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_PT' AS [Logical System Group] FROM (
		SELECT '___' as [Term code],'___' as [Number Range],tb3.[Product Hierarchy],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage 
					FROM (	
						SELECT		[Product Hierarchy],
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
											WHERE  [Logical System Group] = 'Y_PT' AND [Product Hierarchy] <> ''
						GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '') tb1

				LEFT JOIN (
						--********************GROUP BY PRODUCT HIERARCHY AND SUM THE AMOUNT ******************
						SELECT [Product Hierarchy],SUM(Amount) as SUM FROM (	
								SELECT		[Product Hierarchy],
											[Reference Number],
											COUNT([Product Number]) AS Amount
											FROM [dbo].[MO_TABLE_DATA] 
													WHERE  [Logical System Group] = 'Y_PT' AND [Product Hierarchy] <> ''
								GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '') tb2
						GROUP BY [Product Hierarchy]
						) tb3
				ON tb1.[Product Hierarchy] = tb3.[Product Hierarchy] ) tb4
				LEFT JOIN hscodedata hs ON  tb4.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
---------------------------------------------------------------STATISTICS : NUMBER RANGE + TERM CODE (Y_PT)-----------------------------------------------------------------
	SELECT [Term code],[Number Range],tb5.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_PT' AS [Logical System Group] FROM (	
					SELECT 
						'___' as [Product Hierarchy],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage, 
						LEFT(tb3.Term_nRange, CHARINDEX('.', tb3.Term_nRange) - 1) AS [Number Range],
						RIGHT(tb3.Term_nRange, CHARINDEX('.', REVERSE(tb3.Term_nRange)) - 1) AS [Term code]
						FROM (	
							SELECT	LEFT([Product Number],4) + '.' + [Term code] AS Term_nRange,
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
										WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Logical System Group] = 'Y_PT'					     							
							GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Term code] HAVING [Reference Number] <> '') tb1

							LEFT JOIN (

								SELECT Term_nRange,SUM(Amount) as SUM FROM (	
										SELECT		LEFT([Product Number],4) + '.' + [Term code] AS Term_nRange,
													[Reference Number],
													COUNT([Product Number]) AS Amount
													FROM [dbo].[MO_TABLE_DATA] 
															WHERE  [Logical System Group] = 'Y_PT' AND ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' 
										GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Term code] HAVING [Reference Number] <> '') tb2
								GROUP BY Term_nRange ) tb3
							ON tb1.Term_nRange = tb3.Term_nRange ) tb5
					LEFT JOIN hscodedata hs ON  tb5.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
---------------------------------------------------------------STATISTICS : NUMBER RANGE + PRODUCT HIERARCHY (Y_PT)--------------------------------------------------------
	SELECT [Term code],[Number Range],tb5.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_PT' AS [Logical System Group] FROM (	
					SELECT 
						'___' as [Term code],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage, 
						LEFT(tb3.Hie_nRange, CHARINDEX('.', tb3.Hie_nRange) - 1) AS [Number Range],
						RIGHT(tb3.Hie_nRange, CHARINDEX('.', REVERSE(tb3.Hie_nRange)) - 1) AS [Product Hierarchy]
						FROM (	
							SELECT	LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
										WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_PT'					     							
							GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1

							LEFT JOIN (

								SELECT Hie_nRange,SUM(Amount) as SUM FROM (	
										SELECT		LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
													[Reference Number],
													COUNT([Product Number]) AS Amount
													FROM [dbo].[MO_TABLE_DATA] 
															WHERE  [Logical System Group] = 'Y_PT' AND [Product Hierarchy] <> ''
										GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb2
								GROUP BY Hie_nRange ) tb3
							ON tb1.Hie_nRange = tb3.Hie_nRange ) tb5
					LEFT JOIN hscodedata hs ON  tb5.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
---------------------------------------------------------------STATISTICS : TERM CODE + PRODUCT HIERARCHY (Y_PT)------------------------------------------------------------
	SELECT [Term code],[Number Range],tb5.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_PT' AS [Logical System Group] FROM (	
					SELECT 
						'___' as [Number Range],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage, 
						LEFT(tb3.Term_Hierarchy, CHARINDEX('.', tb3.Term_Hierarchy) - 1) AS [Term code],
						RIGHT(tb3.Term_Hierarchy, CHARINDEX('.', REVERSE(tb3.Term_Hierarchy)) - 1) AS [Product Hierarchy]
						FROM (	
							SELECT	[Term code] + '.' + [Product Hierarchy] AS Term_Hierarchy,
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
										WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_PT'					     							
							GROUP BY [Reference Number],[Term code] + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1

							LEFT JOIN (

								SELECT Term_Hierarchy,SUM(Amount) as SUM FROM (	
										SELECT		[Term code] + '.' + [Product Hierarchy] AS Term_Hierarchy,
													[Reference Number],
													COUNT([Product Number]) AS Amount
													FROM [dbo].[MO_TABLE_DATA] 
															WHERE ISNUMERIC([Term code]) = 1 AND [Term code] <> '000000' AND [Logical System Group] = 'Y_PT' AND [Product Hierarchy] <> ''
										GROUP BY [Reference Number],[Term code] + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb2
								GROUP BY Term_Hierarchy ) tb3
							ON tb1.Term_Hierarchy = tb3.Term_Hierarchy ) tb5
					LEFT JOIN hscodedata hs ON  tb5.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------STATISTICS : PRODUCT HIERARCHY (Y_TT01)-----------------------------------------------------------------------------------------------
	SELECT [Term code],[Number Range],tb4.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_TT01' AS [Logical System Group] FROM (
		SELECT '___' as [Term code],'___' as [Number Range],tb3.[Product Hierarchy],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage 
					FROM (	
						SELECT		[Product Hierarchy],
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
											WHERE  [Logical System Group] = 'Y_TT01' AND [Product Hierarchy] <> ''
						GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '') tb1

				LEFT JOIN (
						--********************GROUP BY PRODUCT HIERARCHY AND SUM THE AMOUNT ******************
						SELECT [Product Hierarchy],SUM(Amount) as SUM FROM (	
								SELECT		[Product Hierarchy],
											[Reference Number],
											COUNT([Product Number]) AS Amount
											FROM [dbo].[MO_TABLE_DATA] 
													WHERE  [Logical System Group] = 'Y_TT01' AND [Product Hierarchy] <> ''
								GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '') tb2
						GROUP BY [Product Hierarchy]
						) tb3
				ON tb1.[Product Hierarchy] = tb3.[Product Hierarchy] ) tb4
				LEFT JOIN hscodedata hs ON  tb4.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
---------------------------------------------------------------STATISTICS : NUMBER RANGE + PRODUCT HIERARCHY (Y_TT01)--------------------------------------------------------
	SELECT [Term code],[Number Range],tb5.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_TT01' AS [Logical System Group] FROM (	
					SELECT 
						'___' as [Term code],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage, 
						LEFT(tb3.Hie_nRange, CHARINDEX('.', tb3.Hie_nRange) - 1) AS [Number Range],
						RIGHT(tb3.Hie_nRange, CHARINDEX('.', REVERSE(tb3.Hie_nRange)) - 1) AS [Product Hierarchy]
						FROM (	
							SELECT	LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
										WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_TT01'					     							
							GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1

							LEFT JOIN (

								SELECT Hie_nRange,SUM(Amount) as SUM FROM (	
										SELECT		LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
													[Reference Number],
													COUNT([Product Number]) AS Amount
													FROM [dbo].[MO_TABLE_DATA] 
															WHERE  [Logical System Group] = 'Y_TT01' AND [Product Hierarchy] <> ''
										GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb2
								GROUP BY Hie_nRange ) tb3
							ON tb1.Hie_nRange = tb3.Hie_nRange ) tb5
					LEFT JOIN hscodedata hs ON  tb5.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
--------------------------------------------------------------STATISTICS : PRODUCT HIERARCHY (Y_ST)-----------------------------------------------------------------------------------------------
	SELECT [Term code],[Number Range],tb4.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_ST' AS [Logical System Group] FROM (
		SELECT '___' as [Term code],'___' as [Number Range],tb3.[Product Hierarchy],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage 
					FROM (	
						SELECT		[Product Hierarchy],
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
											WHERE  [Logical System Group] = 'Y_ST' AND [Product Hierarchy] <> ''
						GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '') tb1

				LEFT JOIN (
						--********************GROUP BY PRODUCT HIERARCHY AND SUM THE AMOUNT ******************
						SELECT [Product Hierarchy],SUM(Amount) as SUM FROM (	
								SELECT		[Product Hierarchy],
											[Reference Number],
											COUNT([Product Number]) AS Amount
											FROM [dbo].[MO_TABLE_DATA] 
													WHERE  [Logical System Group] = 'Y_ST' AND [Product Hierarchy] <> ''
								GROUP BY [Product Hierarchy],[Reference Number] HAVING [Reference Number] <> '') tb2
						GROUP BY [Product Hierarchy]
						) tb3
				ON tb1.[Product Hierarchy] = tb3.[Product Hierarchy] ) tb4
				LEFT JOIN hscodedata hs ON  tb4.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION
---------------------------------------------------------------STATISTICS : NUMBER RANGE + PRODUCT HIERARCHY (Y_ST)--------------------------------------------------------
	SELECT [Term code],[Number Range],tb5.[Product Hierarchy],[Reference Number],Follow_part,Percentage,PRODUCT_GROUP,'Y_ST' AS [Logical System Group] FROM (	
					SELECT 
						'___' as [Term code],[Reference Number],Amount as Follow_part, CAST(Amount AS DECIMAL) / SUM * 100 AS Percentage, 
						LEFT(tb3.Hie_nRange, CHARINDEX('.', tb3.Hie_nRange) - 1) AS [Number Range],
						RIGHT(tb3.Hie_nRange, CHARINDEX('.', REVERSE(tb3.Hie_nRange)) - 1) AS [Product Hierarchy]
						FROM (	
							SELECT	LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
									[Reference Number],
									COUNT([Product Number]) AS Amount
									FROM [dbo].[MO_TABLE_DATA] 
										WHERE [Product Hierarchy] <> '' AND [Logical System Group] = 'Y_ST'					     							
							GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb1

							LEFT JOIN (

								SELECT Hie_nRange,SUM(Amount) as SUM FROM (	
										SELECT		LEFT([Product Number],4) + '.' + [Product Hierarchy] AS Hie_nRange,
													[Reference Number],
													COUNT([Product Number]) AS Amount
													FROM [dbo].[MO_TABLE_DATA] 
															WHERE  [Logical System Group] = 'Y_ST' AND [Product Hierarchy] <> ''
										GROUP BY [Reference Number],LEFT([Product Number],4) + '.' + [Product Hierarchy] HAVING [Reference Number] <> '') tb2
								GROUP BY Hie_nRange ) tb3
							ON tb1.Hie_nRange = tb3.Hie_nRange ) tb5
					LEFT JOIN hscodedata hs ON  tb5.[Reference Number] = hs.[PART NUMBER] WHERE [PRODUCT_GROUP] IS NOT NULL
) AS INTO_TABLE
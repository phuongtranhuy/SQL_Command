MERGE MO_TABLE_DATA mo 
USING (
SELECT * FROM (
	SELECT *,ROW_NUMBER() OVER (PARTITION BY main_tb3.[Product Number] ORDER BY main_tb3.[Product Number]) AS ROWS 
	 FROM(
		SELECT [Logical System Group],main_tb1.[Product Number],[Term code],[Product Hierarchy],[Reference Number],[Rule Name],[Number of part similar],[Risk point],Follow_part,Percentage,[Rule Type]			
		  FROM (
			SELECT *
				FROM ( 	
					select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Termcode' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_pt' and st.[Term code] <> '___' and  [Number Range] = '___' and st.[Product Hierarchy] = '___' ) t1
												where [CHECK] = 'TRUE'		
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Term-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_pt' and st.[Term code] <> '___' and  [Number Range] <> '___' and st.[Product Hierarchy] = '___') t1
												where [CHECK] = 'TRUE'
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Term-Hierarchy' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Product Hierarchy] = m.[Product Hierarchy] and st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_pt' and st.[Term code] <> '___' and  [Number Range] = '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'

			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hie-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Product Hierarchy] = m.[Product Hierarchy]
											where m.[Logical System Group] = 'y_pt' and st.[Term code] = '___' and  [Number Range] <> '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'

			--***************************************************************************************************************************************************************************************
			----------------------------
			UNION
			----------------------------
			SELECT *
				FROM ( 	
					select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Termcode' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_br' and st.[Term code] <> '___' and  [Number Range] = '___' and st.[Product Hierarchy] = '___' ) t1
												where [CHECK] = 'TRUE'		

			----------------------------
			UNION
			----------------------------
			SELECT *
				FROM ( 	
					select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hierarchy' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Product Hierarchy] = m.[Product Hierarchy]
											where m.[Logical System Group] = 'y_br' and st.[Term code] = '___' and  [Number Range] = '___' and st.[Product Hierarchy] <> '___' ) t1
												where [CHECK] = 'TRUE'

			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Term-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_br' and st.[Term code] <> '___' and  [Number Range] <> '___' and st.[Product Hierarchy] = '___') t1
												where [CHECK] = 'TRUE'
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Term-Hierarchy' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Product Hierarchy] = m.[Product Hierarchy] and st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_br' and st.[Term code] <> '___' and  [Number Range] = '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hie-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Product Hierarchy] = m.[Product Hierarchy]
											where m.[Logical System Group] = 'y_br' and st.[Term code] = '___' and  [Number Range] <> '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'

			--*******************************************************************************************************************************************************************************************
			----------------------------
			UNION
			----------------------------
			SELECT *
				FROM ( 	
					select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hierarchy' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Product Hierarchy] = m.[Product Hierarchy]
											where (m.[Logical System Group] = 'y_tt01' or m.[Logical System Group] = 'y_st' ) and st.[Term code] = '___' and  [Number Range] = '___' and st.[Product Hierarchy] <> '___' ) t1
												where [CHECK] = 'TRUE'
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hie-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Product Hierarchy] = m.[Product Hierarchy]
											where (m.[Logical System Group] = 'y_tt01' or m.[Logical System Group] = 'y_st' ) and st.[Term code] = '___' and  [Number Range] <> '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'


			) main_tb1

			INNER JOIN (

			SELECT [Product Number],MAX(Follow_part) as MAX_Follower
			FROM (	
			SELECT *
				FROM ( 	
					select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Termcode' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_pt' and st.[Term code] <> '___' and  [Number Range] = '___' and st.[Product Hierarchy] = '___' ) t1
												where [CHECK] = 'TRUE'		
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Term-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_pt' and st.[Term code] <> '___' and  [Number Range] <> '___' and st.[Product Hierarchy] = '___') t1
												where [CHECK] = 'TRUE'
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Term-Hierarchy' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Product Hierarchy] = m.[Product Hierarchy] and st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_pt' and st.[Term code] <> '___' and  [Number Range] = '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'

			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hie-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Product Hierarchy] = m.[Product Hierarchy]
											where m.[Logical System Group] = 'y_pt' and st.[Term code] = '___' and  [Number Range] <> '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'

			--***************************************************************************************************************************************************************************************
			----------------------------
			UNION
			----------------------------
			SELECT *
				FROM ( 	
					select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Termcode' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_br' and st.[Term code] <> '___' and  [Number Range] = '___' and st.[Product Hierarchy] = '___' ) t1
												where [CHECK] = 'TRUE'		

			----------------------------
			UNION
			----------------------------
			SELECT *
				FROM ( 	
					select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hierarchy' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Product Hierarchy] = m.[Product Hierarchy]
											where m.[Logical System Group] = 'y_br' and st.[Term code] = '___' and  [Number Range] = '___' and st.[Product Hierarchy] <> '___' ) t1
												where [CHECK] = 'TRUE'

			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Term-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_br' and st.[Term code] <> '___' and  [Number Range] <> '___' and st.[Product Hierarchy] = '___') t1
												where [CHECK] = 'TRUE'
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Term-Hierarchy' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Product Hierarchy] = m.[Product Hierarchy] and st.[Term code] = m.[Term code]
											where m.[Logical System Group] = 'y_br' and st.[Term code] <> '___' and  [Number Range] = '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hie-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Product Hierarchy] = m.[Product Hierarchy]
											where m.[Logical System Group] = 'y_br' and st.[Term code] = '___' and  [Number Range] <> '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'

			--*******************************************************************************************************************************************************************************************
			----------------------------
			UNION
			----------------------------
			SELECT *
				FROM ( 	
					select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hierarchy' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Product Hierarchy] = m.[Product Hierarchy]
											where (m.[Logical System Group] = 'y_tt01' or m.[Logical System Group] = 'y_st' ) and st.[Term code] = '___' and  [Number Range] = '___' and st.[Product Hierarchy] <> '___' ) t1
												where [CHECK] = 'TRUE'
			----------------------------
			UNION
			----------------------------
			SELECT *
					FROM ( 
						select 
							m.[Logical System Group],
							[Product Number],
							m.[Term code],
							m.[Product Hierarchy],
							m.[Reference Number],
							[Rule Name],
							[Number of part similar],
							[Risk point],
							[Follow_part],
							[Percentage],
							'Hie-NumRange' as [Rule Type],
							CASE WHEN m.[Reference Number] = st.[Reference Number] THEN 'TRUE' ELSE 'FALSE'	END AS [CHECK]
									from MO_TABLE_DATA m 
										LEFT JOIN RULE_STATISTICS st
											ON st.[Number Range] = LEFT([Product Number],4) and st.[Product Hierarchy] = m.[Product Hierarchy]
											where (m.[Logical System Group] = 'y_tt01' or m.[Logical System Group] = 'y_st' ) and st.[Term code] = '___' and  [Number Range] <> '___' and st.[Product Hierarchy] <> '___') t1
												where [CHECK] = 'TRUE'


			) main_tb
			GROUP BY [Product Number] ) main_tb2 

			ON main_tb1.[Product Number] = main_tb2.[Product Number] 
				where Follow_part = MAX_Follower ) main_tb3 ) main_tb4 where main_tb4.ROWS = 1 ) result

ON mo.[Product Number] = result.[Product Number] --ON CONDITION FOR MERGE
WHEN MATCHED THEN UPDATE SET mo.[Rule Name] = result.[Rule Type],
							 mo.[Number of part similar] = result.Follow_part,
							 mo.[Risk point] = CAST(ROUND((100 - result.[Percentage]),0) as INT);
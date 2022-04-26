
---------------------------------------------------KPI RECORDS FOR MANUAL CLASSIFICATION------------------------------------------------------------	
	SELECT [Logical System Group],tb1.[Product Number],[Product Group],[HS code],[User ID],[Upload time],Task,
			ROW_NUMBER() OVER (PARTITION BY tb1.[Product Number] ORDER BY tb1.[Product Number]) AS Row_Number
			FROM (
				SELECT *,'2nd Classification' AS Task
					FROM Records_2nd_Classification 
						UNION
				SELECT *,'QC 2nd Classification' AS Task
					FROM Records_QC_Classification 
						UNION
				SELECT *,'Create New Group' AS Task
					FROM Records_Create_New_Classification ) tb1 
						LEFT JOIN DL_P94_Trigger t ON tb1.[Product Number] = t.[Product Number] 
							WHERE [Product Group] = 'UNCLASSIFY'


--------------------------------------------------AUTO CLASSIFICATION RECORDS------------------------------------------------------------------
SELECT [Logical System Group],[Product Number],[Auto-classify],[Log time SQL]
		FROM DW_P94_Processed_Data WHERE [Auto-classify] <> '' AND [Need to Check] = '' AND [Reference Number] <> ''



---------------------------------------------------BACK LOG (MANUAL + INITIAL) ------------------------------------------------------------------------------------------
SELECT tb3.[Logical System Group],tb3.[Product Number],[Product Group],[User ID],[Upload time],Task 
	FROM(
		SELECT *,ROW_NUMBER() OVER (PARTITION BY tb2.[Product Number] ORDER BY tb2.[Product Number]) AS Row_Number 
				FROM(
					SELECT [Logical System Group],tb1.[Product Number],[Product Group],[User ID],[Upload time],Task
						FROM (
							SELECT *,'2nd Classification' AS Task
								FROM Records_2nd_Classification 
									UNION
							SELECT *,'QC 2nd Classification' AS Task
								FROM Records_QC_Classification 
									UNION
							SELECT *,'Create New Group' AS Task
								FROM Records_Create_New_Classification ) tb1 
									LEFT JOIN DL_P94_Trigger t ON tb1.[Product Number] = t.[Product Number] 
										WHERE [Product Group] = 'UNCLASSIFY') tb2 ) tb3
											LEFT JOIN DW_P94_Processed_Data p ON p.[Product Number] = tb3.[Product Number]
													WHERE Row_Number = 1 and p.[Reference Number] = ''

UNION

SELECT  [Logical System Group],
		[Product Number],
		[Need to Check],
		'',
		[Log time SQL],
		'Initial Backlog'
			FROM DW_P94_Processed_Data WHERE [Auto-classify] like '%FTMD%'

								  

			--ROW_NUMBER() OVER (PARTITION BY tb1.[Product Number] ORDER BY tb1.[Product Number]) AS Row_Number
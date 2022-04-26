	SELECT *,   (CASE
					WHEN Month_Year_Created_On = Month_Year_Valid_From THEN 'IN MONTH'
					ELSE 'PREVIOUS MONTHs'
				END ) AS [Check_Clear_Backlog]
	    FROM (
		SELECT * FROM (	
			SELECT *,DATENAME(month, [P94 Created On]) + '-' + CAST(Year([P94 Created On]) as nvarchar(10)) as Month_Year_Created_On
					,DATENAME(month, [Valid From]) + '-' + CAST(Year([Valid From]) as nvarchar(10)) as Month_Year_Valid_From
					,DATEDIFF(DAY,[P94 Created On],[Valid From]) as [Lead_Time (day)]
				FROM (	
					SELECT  m.[Logical System Group],
							m.[Product Number],
							[Hardness grade],
							LEFT(Number,6) as [HS code],
							[Product Number1] as [REF Number],
							t.[Created On] as [P94 Created On],
							m.[Valid From]
								FROM [DB_PEP_OPERATION].[dbo].DL_MO_TABLE_ALL m
									LEFT JOIN DL_P94_Worklist t ON m.[Product Number] = t.[Product Number]
									) tb1 WHERE [P94 Created On] >= '2018-01-01' and DATEDIFF(DAY,[P94 Created On],[Valid From])  > 0 ) tb2							
														 ) tb3 order by [Lead_Time (day)]

--select month('2021-10-21 00:00:00.000')
--select DATENAME(month, '2021-10-21 00:00:00.000') + '-' + CAST(Year('2021-10-21 00:00:00.000') as nvarchar(10) )  
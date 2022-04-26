		SELECT *,DATEDIFF(HOUR,[P94 Created On],CAST([Log time MO_TABLE] AS datetime)) as [Lead_Time (hour)]
			FROM (	
				SELECT  m.[Logical System Group],
						m.[Product Number],
						[Hardness grade],
						LEFT(Number,6) as [HS code],
						[Product Number1] as [REF Number],
						STUFF(STUFF(STUFF(STUFF(STUFF(CAST(CAST([Created On1] AS DECIMAL(20)) AS VARCHAR(20)),5,0,'-'),8,0,'-'),11,0,' '),14,0,':'),17,0,':') AS [Log time MO_TABLE],
						t.[Created On] as [P94 Created On]
							FROM [DB_PEP_OPERATION].[dbo].[DL_MO_Table_Data] m
								LEFT JOIN DL_P94_Trigger t ON m.[Product Number] = t.[Product Number] ) tb1
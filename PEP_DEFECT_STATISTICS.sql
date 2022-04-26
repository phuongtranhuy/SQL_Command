/****** Script for SelectTopNRows command from SSMS  ******/
SELECT tb2.[Logical Group],tb2.[Product Number],tb2.[PIC classification] as [2nd PIC],[2nd Product Group],tb2.[2nd_Task],
		tb3.[PIC classification] as [QC PIC],[QC Product Group],QC_Task,tb3.[Upload time to SQL],
		(CASE 
			WHEN [2nd Product Group] = [QC Product Group] THEN 'True'
			ELSE 'False'
		END) as [Check]
	FROM (
		SELECT [Logical Group],KPI.[Product Number],[PIC classification],[Product Group] as [2nd Product Group],Task AS [2nd_Task],[Upload time to SQL]
			FROM DW_PEP_KPI kpi 
				INNER JOIN (

					SELECT [Product Number],count([Product Group]) as Amount_Group
					  FROM [DB_PEP_OPERATION].[dbo].[DW_PEP_KPI] where Task <> 'MAINTAIN' and  Task <> 'Reclassification' and  task <>'1st Classification' and task <> 'QC Classification'
																	
					GROUP BY [Product Number] having count([Product Group]) > 1 ) tb1

				ON kpi.[Product Number] = tb1.[Product Number]
							WHERE [Product Group] <> 'UNCLASSIFY' AND TASK ='2nd Classification' ) tb2

INNER JOIN (
SELECT [Logical Group],KPI.[Product Number],[PIC classification],[Product Group] as [QC Product Group],Task as [QC_Task],[Upload time to SQL]
	FROM DW_PEP_KPI kpi 
		INNER JOIN (

			SELECT [Product Number],count([Product Group]) as Amount_Group
			  FROM [DB_PEP_OPERATION].[dbo].[DW_PEP_KPI] where Task <> 'MAINTAIN' and  Task <> 'Reclassification' and  task <>'1st Classification' and task <> 'QC Classification'
																	
			GROUP BY [Product Number] having count([Product Group]) > 1 ) tb1

		ON kpi.[Product Number] = tb1.[Product Number]
					WHERE [Product Group] <> 'UNCLASSIFY' AND TASK ='QC 2nd Classification') tb3
ON tb2.[Product Number] = tb3.[Product Number]
select [2nd PIC],DATEDIFF(hour,[2nd classify down time],[2nd classify upload time]) as Lead_Time,
     (Case
	   when DATEDIFF(hour,[2nd classify down time],[2nd classify upload time]) < 24  then 'EaV2'-- proceeding within a day
	   when DATEDIFF(hour,[2nd classify down time],[2nd classify upload time]) >= 24  and DATEDIFF(hour,[2nd classify down time],[2nd classify upload time]) < 168  then 'EaV1'
	   when DATEDIFF(hour,[2nd classify down time],[2nd classify upload time]) >= 168 then 'EaV0'
	 End) as EaV_Factor
			from P94_worklist where     [2nd classify down time] <> '1900-01-01 00:00:00.000'
								    and [2nd classify upload time]<> '1900-01-01 00:00:00.000'
									and [Logical System Group] <> 'y_ubk'
									and [Upload time to SQL] >= '2022-01-01'
									and [2nd PIC] <> ''
										ORDER BY Lead_Time 
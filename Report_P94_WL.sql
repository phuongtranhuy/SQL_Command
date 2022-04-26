select [Logical System Group],
       [Product Number],
       [Created On],
       [Auto-classify],
       [Need to Check],
       [Product Group],
       [2nd PIC],
       [New Product Group],
       [Upload time to SQL],
       [P94 upload status],
       [ONDEMAND PROJECT]
               from P94_worklist 
          where [Logical System Group] <> 'y_ubk' and 
                [ONDEMAND PROJECT] not like '%BEE%' and 
                [ONDEMAND PROJECT] not like '%TBD%' and 
                [Created On] >= '2018-12-01' and 
                [Product Number] not like 'R33%'
				and (
							[P94 upload status] = 'done' OR 
							[P94 upload status] = 'Done-already existing on MO TABLE' OR 
							[P94 upload status] = 'Done-QKPI maintain' OR 
							[P94 upload status] = 'Done-Ticket maintain' OR 
							[P94 upload status] = 'Done-UNCLASSIFY OVER 3 TIMES' OR
							[P94 upload status] = ''
					) 
UNION

select [Logical System Group],
		[Product Number],
		[Created On],
		[Auto-classify],
		[Need to Check],
		[Product Group],
		[2nd PIC],
		[New Product Group],
		[Upload time to SQL],
		[P94 upload status],
                [ONDEMAND PROJECT] 
                        FROM P94_worklist	
				where [Logical System Group] = 'y_ubk' and 
				[Created On] >= '2018-12-01' 
				and (
							[P94 upload status] = 'done' OR 
							[P94 upload status] = 'Done-already existing on MO TABLE' OR 
							[P94 upload status] = 'Done-QKPI maintain' OR 
							[P94 upload status] = 'Done-Ticket maintain' OR 
							[P94 upload status] = 'Done-UNCLASSIFY OVER 3 TIMES' OR
							[P94 upload status] = ''
					) 
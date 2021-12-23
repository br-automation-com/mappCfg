PROGRAM _CYCLIC
	
	// Read unique mapp configuration parameter
	IF mappReadUnique THEN
		MpCfgRW_01.Enable 		:= TRUE;
		MpCfgRW_01.MpLink 		:= gDatabaseCore;
		MpCfgRW_01.ReadWrite 	:= MpCfgRead;
		MpCfgRW_01.ParaName 	:= 'IPAddress';
		MpCfgRW_01.GroupArray	:= 0;
		
		IF MpCfgRW_01.CommandDone THEN
			MpCfgRW_01.Enable := FALSE;
			mappReadUnique := FALSE;
		END_IF
	END_IF
	
	// Read mapp configuration parameter with additional group information
	IF mappReadGroup THEN
		// Group array definition
		GroupArray.Item[0] := 'mapp.Database.Core';
		GroupArray.Item[1] := 'DBQueries';
		GroupArray.Item[2] := '[1]';
		GroupArray.Item[3] := 'Where';
		GroupArray.Item[4] := '[0]';
		
		MpCfgRW_01.Enable 		:= TRUE;
		MpCfgRW_01.MpLink 		:= gDatabaseCore;
		MpCfgRW_01.ReadWrite 	:= MpCfgRead;
		MpCfgRW_01.ParaName 	:= 'Column';
		MpCfgRW_01.GroupArray	:= ADR(GroupArray);
		
		IF MpCfgRW_01.CommandDone THEN
			MpCfgRW_01.Enable := FALSE;
			mappReadGroup := FALSE;
		END_IF
	END_IF
	
	
	// Write unique mapp configuration parameter
	IF mappWriteUnique THEN
		MpCfgRW_01.Enable 		:= TRUE;
		MpCfgRW_01.MpLink 		:= gDatabaseCore;
		MpCfgRW_01.ReadWrite 	:= MpCfgWrite;
		MpCfgRW_01.ParaName 	:= 'IPAddress';
		MpCfgRW_01.ParaValue 	:= '192.168.0.1';
		MpCfgRW_01.GroupArray	:= 0;
		
		IF MpCfgRW_01.CommandDone THEN
			MpCfgRW_01.Enable := FALSE;
			mappWriteUnique := FALSE;
		END_IF
	END_IF
	
	// Write mapp configuration parameter with additional group information
	IF mappWriteGroup THEN
		// Group array definition
		GroupArray.Item[0] := 'mapp.Database.Core';
		GroupArray.Item[1] := 'DBQueries';
		GroupArray.Item[2] := '[1]';
		GroupArray.Item[3] := 'Where';
		GroupArray.Item[4] := '[0]';
		
		MpCfgRW_01.Enable 		:= TRUE;
		MpCfgRW_01.MpLink 		:= gDatabaseCore;
		MpCfgRW_01.ReadWrite 	:= MpCfgWrite;
		MpCfgRW_01.ParaName 	:= 'Column';
		MpCfgRW_01.ParaValue 	:= 'product_group';
		MpCfgRW_01.GroupArray	:= ADR(GroupArray);
		
		IF MpCfgRW_01.CommandDone THEN
			MpCfgRW_01.Enable := FALSE;
			mappWriteGroup := FALSE;
		END_IF
	END_IF
	
	MpCfgRW_01();
	 
END_PROGRAM




PROGRAM _INIT
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	// Read mapp configuration parameter
	IF mappRead THEN
		MpCfgRW_01.Enable 		:= TRUE;
		MpCfgRW_01.MpLink 		:= gDatabaseCore;
		MpCfgRW_01.ReadWrite 	:= MpCfgRead;
		MpCfgRW_01.ParaName 	:= 'IPAddress';
		
		IF MpCfgRW_01.CommandDone THEN
			MpCfgRW_01.Enable := FALSE;
			mappRead := FALSE;
		END_IF
	END_IF
	
	// Write mapp configuration parameter
	IF mappWrite THEN
		MpCfgRW_01.Enable 		:= TRUE;
		MpCfgRW_01.MpLink 		:= gDatabaseCore;
		MpCfgRW_01.ReadWrite 	:= MpCfgWrite;
		MpCfgRW_01.ParaName 	:= 'IPAddress';
		MpCfgRW_01.ParaValue 	:= '192.168.0.1';
		
		IF MpCfgRW_01.CommandDone THEN
			MpCfgRW_01.Enable := FALSE;
			mappWrite := FALSE;
		END_IF
	END_IF
	
	MpCfgRW_01();
	 
END_PROGRAM


